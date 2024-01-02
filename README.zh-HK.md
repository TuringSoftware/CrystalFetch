CrystalFetch
============
[![Build](https://github.com/TuringSoftware/CrystalFetch/workflows/Build/badge.svg?branch=main&event=push)][1]

CrystalFetch 是一個 macOS 應用程式，用於製作 Windows® 11 安裝程式 ISO 映像檔。它可以與 [UTM 虛擬電腦][3]及其他虛擬電腦解決方案一齊使用。

注意：CrystalFetch 與 Microsoft 無關聯，安裝 Windows® 11 需要有效的許可證（產品金鑰）。

<p align="center">
  <img alt="CrystalFetch logo" src="Source/Assets.xcassets/AppIcon.appiconset/icon_128x128.png" srcset="Source/Assets.xcassets/AppIcon.appiconset/icon_128x128@2x@2x.png 2x" /><br />
  <img alt="CrystalFetch screenshot" src="Extras/screen.png" />
</p>

構建
--------
1. 確保你使用 `git submodule update --init` 來獲取子模組。
2. 如你有 Apple Developer 付費賬戶，請複製 `CodeSigning.xcconfig.sample` 到 `CodeSigning.xcconfig`，並在此檔案中填寫你的開發人員訊息。
3. 如你沒有 Apple Developer 付費賬戶，你需要禁用庫驗證。對於項目中的每一個構建目標，轉至“Signing & Capabilities”，之後選取“Disable Library Validation”核取方塊。
4. 現在你就可以由 Xcode 構建並執行此項目了。

致謝
-------
CrystalFetch 使用了 [UUPDump][3] 的 API 與轉換程式碼。

CrystalFetch 使用了由 Technogeezer 製作的 [esd2iso][4]。

此項目與 Microsoft Corporation 無關聯。Windows® 為 Microsoft Corporation 的註冊商標。

  [1]: https://github.com/TuringSoftware/CrystalFetch/actions?query=event%3Arelease+workflow%3ABuild
  [2]: https://mac.getutm.app
  [3]: https://uupdump.net
  [4]: https://communities.vmware.com/t5/VMware-Fusion-Documents/w11arm-esd2iso-a-utility-to-create-Windows-11-ARM-ISOs-from/ta-p/2957381
