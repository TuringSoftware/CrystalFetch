//
// Copyright © 2025 Turing Software, LLC. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

actor MCTCatalogs {
    struct Version: Equatable {
        let latestCabUrl: URL?
        let releases: [Release]
    }

    struct Release: Equatable, Hashable, Identifiable {
        let build: String
        let date: Date?
        let cabUrl: URL

        var id: Int {
            hashValue
        }
    }

    enum Windows: Int {
        case windows10 = 10
        case windows11 = 11
    }

    private(set) var versions: [Windows: Version] = [:]

    init(from data: Data) async throws {
        let result = try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let parser = XMLParser(data: data)
                let coordinator = MCTCatalogsParser()
                coordinator.continuation = continuation
                parser.delegate = coordinator
                if !parser.parse() && coordinator.continuation != nil {
                    continuation.resume(throwing: parser.parserError ?? ESDCatalogError.unknown)
                }
            }
        }
        let results = try result.map { try Self.parseVersion($0) }
        for (number, version) in results {
            if let windows = Windows(rawValue: number) {
                versions[windows] = version
            } else {
                NSLog("Ignoring unknown Windows version: %@", number)
            }
        }
    }

    private static func parseVersion(_ result: MCTCatalogsParser.Version) throws -> (number: Int, version: Version) {
        let latestCabUrl: URL?
        if let latestCabLink = result.latestCabLink {
            latestCabUrl = URL(string: latestCabLink)!
        } else {
            latestCabUrl = nil
        }
        guard let number = Int(result.number) else {
            throw ESDCatalogError.missingElement("number", "version")
        }
        let releases = try result.releases.map { try Self.parseRelease($0) }
        return (number, Version(latestCabUrl: latestCabUrl, releases: releases))
    }

    private static func parseRelease(_ result: MCTCatalogsParser.Release) throws -> Release {
        let date: Date?
        if let dateString = result.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            date = dateFormatter.date(from: dateString)
        } else {
            date = nil
        }
        guard let cabLink = result.cabLink else {
            throw ESDCatalogError.missingElement("cabLink", "release")
        }
        let cabUrl: URL = URL(string: cabLink)!
        return Release(build: result.build, date: date, cabUrl: cabUrl)
    }
}

fileprivate class MCTCatalogsParser: NSObject, XMLParserDelegate {
    enum Inside: String {
        case productsDb
        case versions
        case version
        case latestCabLink
        case releases
        case release
        case date
        case cabLink
    }

    struct Version {
        var number: String
        var latestCabLink: String?
        var releases: [Release] = []
    }

    struct Release {
        var build: String
        var date: String?
        var cabLink: String?
    }

    var continuation: CheckedContinuation<[Version], Error>?
    private var inside: Inside?
    private var versions: [Version] = []
    private var currentVersion: Version?
    private var currentRelease: Release?

    func parserDidStartDocument(_ xmlParser: XMLParser) {
        inside = nil
    }

    func parserDidEndDocument(_ xmlParser: XMLParser) {
        if let c = continuation {
            continuation = nil
            c.resume(returning: versions)
        }
    }

    func parser(_ xmlParser: XMLParser, parseErrorOccurred parseError: Error) {
        if let c = continuation {
            continuation = nil
            c.resume(throwing: parseError)
        }
        xmlParser.abortParsing()
    }

    func parser(_ xmlParser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch inside {
        case nil:
            guard expect(elementName, named: .productsDb, in: xmlParser) else {
                return
            }
            inside = .productsDb
        case .productsDb:
            guard expect(elementName, named: .versions, in: xmlParser) else {
                return
            }
            inside = .versions
        case .versions:
            guard expect(elementName, named: .version, in: xmlParser) else {
                return
            }
            guard let number = attributeDict["number"] else {
                parser(xmlParser, parseErrorOccurred: ESDCatalogError.attributeNotFound("number"))
                return
            }
            inside = .version
            currentVersion = Version(number: number)
        case .version:
            guard let seen = expect(elementName, namedOneOf: [.latestCabLink, .releases], in: xmlParser) else {
                return
            }
            inside = seen
        case .releases:
            guard expect(elementName, named: .release, in: xmlParser) else {
                return
            }
            guard let build = attributeDict["build"] else {
                parser(xmlParser, parseErrorOccurred: ESDCatalogError.attributeNotFound("build"))
                return
            }
            inside = .release
            currentRelease = Release(build: build)
        case .release:
            guard let seen = expect(elementName, namedOneOf: [.date, .cabLink], in: xmlParser) else {
                return
            }
            inside = seen
        default:
            parser(xmlParser, parseErrorOccurred: ESDCatalogError.invalidElement(elementName))
        }
    }

    func parser(_ xmlParser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard elementName == inside?.rawValue else {
            parser(xmlParser, parseErrorOccurred: ESDCatalogError.invalidElement(elementName))
            return
        }
        switch inside! {
        case .productsDb:
            inside = nil
        case .versions:
            inside = .productsDb
        case .version:
            versions.append(currentVersion!)
            currentVersion = nil
            inside = .versions
        case .latestCabLink, .releases:
            inside = .version
        case .release:
            currentVersion!.releases.append(currentRelease!)
            currentRelease = nil
            inside = .releases
        case .date, .cabLink:
            inside = .release
        }
    }

    func parser(_ xmlParser: XMLParser, foundCharacters string: String) {
        if inside == .latestCabLink {
            currentVersion!.latestCabLink = string
        } else if inside == .date {
            currentRelease!.date = string
        } else if inside == .cabLink {
            currentRelease!.cabLink = string
        } else {
            parser(xmlParser, parseErrorOccurred: ESDCatalogError.unexpectedString(string, inside?.rawValue ?? ""))
        }
    }

    private func expect(_ elementName: String, named element: Inside, in xmlParser: XMLParser) -> Bool {
        guard elementName == element.rawValue else {
            parser(xmlParser, parseErrorOccurred: ESDCatalogError.invalidElement(elementName))
            return false
        }
        return true
    }

    private func expect(_ elementName: String, namedOneOf elements: [Inside], in xmlParser: XMLParser) -> Inside? {
        for element in elements {
            if elementName == element.rawValue {
                return element
            }
        }
        parser(xmlParser, parseErrorOccurred: ESDCatalogError.invalidElement(elementName))
        return nil
    }
}
