CrystalFetch
============
[![Build](https://github.com/TuringSoftware/CrystalFetch/workflows/Build/badge.svg?branch=main&event=push)][1]

CrystalFetch 是一个用于创建 Windows® 11 安装 ISO 映像的 macOS 应用程序。它可以与 [UTM 虚拟机][3]及其他虚拟机解决方案一起使用。

注意：CrystalFetch 不隶属于 Microsoft（微软）。安装 Windows® 11 需要有效的许可证（产品密钥）。

<p align="center">
  <img alt="CrystalFetch logo" src="Source/Assets.xcassets/AppIcon.appiconset/icon_128x128.png" srcset="Source/Assets.xcassets/AppIcon.appiconset/icon_128x128@2x@2x.png 2x" /><br />
  <img alt="CrystalFetch screenshot" src="Extras/screen.png" />
</p>

编译
--------
1. 确保使用 `git submodule update --init` 来获取子模块（submodule）。
2. 若你有付费的 Apple Developer 账号，请将 `CodeSigning.xcconfig.sample` 拷贝到 `CodeSigning.xcconfig`，并用你的开发者信息来填写该文件。
3. 若你没有付费的 Apple Developer 账号，需要禁用库验证（library validation）。对于此项目中的每个编译目标（build target），请前往“Signing & Capabilities”并勾选“Disable Library Validation”。
4. 现在可以从 Xcode 编译和运行此项目了。

致谢
-------
CrystalFetch 使用了 [UUPDump][3] 的 API 与转换脚本。

CrystalFetch 使用了由 Technogeezer 编写的 [esd2iso][4]。

此项目不隶属于 Microsoft Corporation。Windows® 是 Microsoft Corporation 的注册商标。

  [1]: https://github.com/TuringSoftware/CrystalFetch/actions?query=event%3Arelease+workflow%3ABuild
  [2]: https://mac.getutm.app
  [3]: https://uupdump.net
  [4]: https://communities.vmware.com/t5/VMware-Fusion-Documents/w11arm-esd2iso-a-utility-to-create-Windows-11-ARM-ISOs-from/ta-p/2957381
