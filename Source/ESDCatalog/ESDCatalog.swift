//
// Copyright © 2023 Turing Software, LLC. All rights reserved.
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

actor ESDCatalog {
    struct File: Equatable {
        let name: String
        let languageCode: String
        let languagePretty: String
        let edition: String
        let editionPretty: String
        let architecture: String
        let architecturePretty: String
        let size: Int64
        let sha1: String
        let filePath: String
        let isRetailOnly: Bool
        let eula: String?
    }
    
    private(set) var files: [File]
    
    init(from data: Data) async throws {
        let result: ESDCatalogParser.Result = try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let parser = XMLParser(data: data)
                let coordinator = ESDCatalogParser()
                coordinator.continuation = continuation
                parser.delegate = coordinator
                if !parser.parse() && coordinator.continuation != nil {
                    continuation.resume(throwing: parser.parserError ?? ESDCatalogError.unknown)
                }
            }
        }
        files = try result.files.map { parseFile in
            let languageCode = parseFile.LanguageCode ?? "default"
            guard let localization = result.localization[languageCode] else {
                throw ESDCatalogError.localizationNotFound(languageCode)
            }
            return try Self.parseResult(parseFile, localization: localization, eulas: result.eulas)
        }
    }
    
    private static func parseResult(_ result: ESDCatalogParser.File, localization: [String: String], eulas: [String: String?]) throws -> File {
        guard let name = result.FileName else {
            throw ESDCatalogError.missingElement("FileName", "Unknown")
        }
        guard let languageCode = result.LanguageCode else {
            throw ESDCatalogError.missingElement("LanguageCode", name)
        }
        guard let languagePretty = result.Language else {
            throw ESDCatalogError.missingElement("Language", name)
        }
        guard let edition = result.Edition else {
            throw ESDCatalogError.missingElement("Edition", name)
        }
        guard let editionLoc = result.Edition_Loc else {
            throw ESDCatalogError.missingElement("Edition_Loc", name)
        }
        let editionPretty = localize(editionLoc, localization: localization)
        guard let architecture = result.Architecture else {
            throw ESDCatalogError.missingElement("Architecture", name)
        }
        guard let architectureLoc = result.Architecture_Loc else {
            throw ESDCatalogError.missingElement("Architecture_Loc", name)
        }
        let architecturePretty = localize(architectureLoc, localization: localization)
        guard let size = result.Size else {
            throw ESDCatalogError.missingElement("Size", name)
        }
        guard let sha1 = result.Sha1 else {
            throw ESDCatalogError.missingElement("Sha1", name)
        }
        guard let filePath = result.FilePath else {
            throw ESDCatalogError.missingElement("FilePath", name)
        }
        guard let isRetailOnly = result.IsRetailOnly else {
            throw ESDCatalogError.missingElement("IsRetailOnly", name)
        }
        let eula = eulas[languageCode] ?? nil
        return File(name: name,
                    languageCode: languageCode,
                    languagePretty: languagePretty,
                    edition: edition,
                    editionPretty: editionPretty,
                    architecture: architecture,
                    architecturePretty: architecturePretty,
                    size: size,
                    sha1: sha1,
                    filePath: filePath,
                    isRetailOnly: isRetailOnly,
                    eula: eula)
    }
    
    private static func localize(_ string: String, localization: [String: String]) -> String {
        let lookup = String(string.dropFirst().dropLast())
        return localization[lookup] ?? lookup
    }
}

fileprivate class ESDCatalogParser: NSObject, XMLParserDelegate {
    enum Inside: String {
        case MCT
        case Catalogs
        case Catalog
        case PublishedMedia
        case Files
        case File
        case Languages
        case Language
        case EULAs
        case EULA
    }
    
    struct File {
        var FileName: String?
        var LanguageCode: String?
        var Language: String?
        var Edition: String?
        var Architecture: String?
        var Size: Int64?
        var Sha1: String?
        var FilePath: String?
        var Architecture_Loc: String?
        var Edition_Loc: String?
        var IsRetailOnly: Bool?
    }
    
    struct Language {
        var LanguageCode: String
        var Localization: [String: String] = [:]
    }
    
    struct EULA {
        var LanguageCode: String?
        var URL: String?
    }
    
    typealias Result = (files: [File], localization: [String: [String: String]], eulas: [String: String?])
    
    var continuation: CheckedContinuation<Result, Error>?
    private var inside: Inside?
    private var field: String?
    private var currentRecord: Any?
    private var files: [File] = []
    private var localization: [String: [String: String]] = [:]
    private var eulas: [String: String?] = [:]
    
    func parserDidStartDocument(_ xmlParser: XMLParser) {
        inside = nil
    }
    
    func parserDidEndDocument(_ xmlParser: XMLParser) {
        if let c = continuation {
            continuation = nil
            c.resume(returning: (files, localization, eulas))
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
        case .MCT:
            guard expect(elementName, named: .Catalogs, in: xmlParser) else {
                return
            }
            inside = .Catalogs
        case .Catalogs:
            guard expect(elementName, named: .Catalog, in: xmlParser) else {
                return
            }
            inside = .Catalog
        case .Catalog:
            guard expect(elementName, named: .PublishedMedia, in: xmlParser) else {
                return
            }
            inside = .PublishedMedia
        case .PublishedMedia:
            if elementName == Inside.Files.rawValue {
                inside = .Files
            } else if elementName == Inside.Languages.rawValue {
                inside = .Languages
            } else if elementName == Inside.EULAs.rawValue {
                inside = .EULAs
            } else {
                parser(xmlParser, parseErrorOccurred: ESDCatalogError.invalidElement(elementName))
            }
        case .Files:
            guard expect(elementName, named: .File, in: xmlParser) else {
                return
            }
            inside = .File
            currentRecord = File()
        case .Languages:
            guard expect(elementName, named: .Language, in: xmlParser) else {
                return
            }
            guard let languageCode = attributeDict["LanguageCode"] else {
                parser(xmlParser, parseErrorOccurred: ESDCatalogError.attributeNotFound("LanguageCode"))
                return
            }
            inside = .Language
            currentRecord = Language(LanguageCode: languageCode)
        case .EULAs:
            guard expect(elementName, named: .EULA, in: xmlParser) else {
                return
            }
            inside = .EULA
            currentRecord = EULA()
        case nil:
            guard expect(elementName, named: .MCT, in: xmlParser) else {
                return
            }
            inside = .MCT
        case .File, .Language, .EULA:
            guard field == nil else {
                parser(xmlParser, parseErrorOccurred: ESDCatalogError.invalidElement(elementName))
                return
            }
            field = elementName
        }
    }
    
    func parser(_ xmlParser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard field == nil else {
            if field == elementName {
                field = nil
            } else {
                parser(xmlParser, parseErrorOccurred: ESDCatalogError.invalidElement(elementName))
            }
            return
        }
        guard elementName == inside?.rawValue else {
            parser(xmlParser, parseErrorOccurred: ESDCatalogError.invalidElement(elementName))
            return
        }
        switch inside! {
        case .MCT:
            inside = nil
        case .Catalogs:
            inside = .MCT
        case .Catalog:
            inside = .Catalogs
        case .PublishedMedia:
            inside = .Catalog
        case .File:
            inside = .Files
            files.append(currentRecord as! File)
        case .Language:
            inside = .Languages
            let record = currentRecord as! Language
            localization[record.LanguageCode] = record.Localization
        case .EULA:
            inside = .EULAs
            let record = currentRecord as! EULA
            if let languageCode = record.LanguageCode {
                eulas[languageCode] = record.URL
            }
        case .Files, .Languages, .EULAs:
            inside = .PublishedMedia
        }
    }
    
    func parser(_ xmlParser: XMLParser, foundCharacters string: String) {
        guard let field = field else {
            return
        }
        if inside == .File {
            parseFileElement(string, for: field)
        } else if inside == .Language {
            parseLanguageElement(string, for: field)
        } else if inside == .EULA {
            parseEULAElement(string, for: field)
        } else {
            parser(xmlParser, parseErrorOccurred: ESDCatalogError.unexpectedString(string, field))
        }
    }
    
    private func parseFileElement(_ element: String, for field: String) {
        var record = currentRecord as! File
        switch field {
        case "FileName": record.FileName = element
        case "LanguageCode": record.LanguageCode = element
        case "Language": record.Language = element
        case "Edition": record.Edition = element
        case "Architecture": record.Architecture = element
        case "Size": record.Size = Int64(element)
        case "Sha1": record.Sha1 = element
        case "FilePath": record.FilePath = element
        case "Architecture_Loc": record.Architecture_Loc = element
        case "Edition_Loc": record.Edition_Loc = element
        case "IsRetailOnly": record.IsRetailOnly = element == "True"
        default: break
        }
        currentRecord = record
    }
    
    private func parseLanguageElement(_ element: String, for field: String) {
        var record = currentRecord as! Language
        record.Localization[field] = element
        currentRecord = record
    }
    
    private func parseEULAElement(_ element: String, for field: String) {
        var record = currentRecord as! EULA
        switch field {
        case "LanguageCode": record.LanguageCode = element
        case "URL": record.URL = element
        default: break
        }
        currentRecord = record
    }
    
    private func expect(_ elementName: String, named element: Inside, in xmlParser: XMLParser) -> Bool {
        guard elementName == element.rawValue else {
            parser(xmlParser, parseErrorOccurred: ESDCatalogError.invalidElement(elementName))
            return false
        }
        return true
    }
}

enum ESDCatalogError: Error {
    case unknown
    case invalidElement(String)
    case attributeNotFound(String)
    case unexpectedString(String, String)
    case localizationNotFound(String)
    case missingElement(String, String)
}

extension ESDCatalogError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknown: return NSLocalizedString("Unknown parser error.", comment: "ESDCatalog")
        case .invalidElement(let element): return String.localizedStringWithFormat(NSLocalizedString("Failed to parse element '%@'", comment: "ESDCatalog"), element)
        case .attributeNotFound(let string): return String.localizedStringWithFormat(NSLocalizedString("Attribute '%@' not found", comment: "ESDCatalog"), string)
        case .unexpectedString(let string, let field): return String.localizedStringWithFormat(NSLocalizedString("Unexpected string '%@' for field '%@'", comment: "ESDCatalog"), string, field)
        case .localizationNotFound(let string): return String.localizedStringWithFormat(NSLocalizedString("Localization '%@' not found", comment: "ESDCatalog"), string)
        case .missingElement(let element, let fileName): return String.localizedStringWithFormat(NSLocalizedString("Missing element '%@' in '%@'", comment: "ESDCatalog"), element, fileName)
        }
    }
}
