#!/bin/sh

set -e

command -v realpath >/dev/null 2>&1 || realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}
BASEDIR="$(dirname "$(realpath $0)")"

if [ $# -lt 3 ]; then
	echo "usage: $0 MODE APP.xcarchive outputPath BUNDLE_ID TEAM_ID PROFILE_NAME"
	echo "  MODE is one of:"
	echo "          developer-id (signed DMG)"
	echo "          app-store (Mac App Store package)"
	echo "  BUNDLE_ID is the app's bundle id"
	echo "  TEAM_ID is the Developer ID"
	echo "  PROFILE_NAME can be the name or UUID"
	exit 1
fi

MODE=$1
INPUT=$2
OUTPUT=$3
BUNDLE_ID=$4
TEAM_ID=$5
PROFILE_NAME=$6
OPTIONS="/tmp/options.$$.plist"
SIGNED="/tmp/signed.$$"
APP_BUNDLE="$(basename $INPUT/Products/Applications/*.app)"
APP_NAME="${APP_BUNDLE%.*}"

cat >"$OPTIONS" <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>compileBitcode</key>
	<false/>
	<key>installerSigningCertificate</key>
	<string>3rd Party Mac Developer Installer</string>
	<key>method</key>
	<string>${MODE}</string>
	<key>provisioningProfiles</key>
	<dict>
		<key>${BUNDLE_ID}</key>
		<string>${PROFILE_NAME}</string>
	</dict>
	<key>signingStyle</key>
	<string>manual</string>
	<key>stripSwiftSymbols</key>
	<true/>
	<key>teamID</key>
	<string>${TEAM_ID}</string>
	<key>thinning</key>
	<string>&lt;none&gt;</string>
</dict>
</plist>
EOL

xcodebuild -exportArchive -exportOptionsPlist "$OPTIONS" -archivePath "$INPUT" -exportPath "$SIGNED"

rm "$OPTIONS"

if [ "$MODE" == "app-store" ]; then
	cp "$SIGNED/${APP_NAME}.pkg" "$OUTPUT/${APP_NAME}.pkg"
else
	rm -f "$OUTPUT/${APP_NAME}.dmg"
	hdiutil create -fs HFS+ -srcfolder "$SIGNED/${APP_NAME}.app" -volname "${APP_NAME}" "$OUTPUT/${APP_NAME}.dmg"
fi
rm -rf "$SIGNED"
