#!/usr/bin/env pwsh

Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

mkdir dist

if ($IsWindows) {
    dotnet publish ./src/git-istage --configuration Release --runtime win10-x64
    mkdir dist/win10-x64
    dotnet build --configuration Release --runtime win10-x64
    [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" ; Invoke-WebRequest https://github.com/dgiagio/warp/releases/download/v0.2.1/windows-x64.warp-packer.exe -OutFile warp-packer.exe
    .\warp-packer --arch windows-x64 --input_dir src/git-istage/bin/Release/netcoreapp2.1/win10-x64/publish --exec git-istage --output dist/win10-x64/git-istage.exe
}

if ($IsMacOS) {
    dotnet publish ./src/git-istage --configuration Release --runtime osx-x64
    mkdir dist/macos-x64
    curl -Lo warp-packer https://github.com/dgiagio/warp/releases/download/v0.2.1/macos-x64.warp-packer
    chmod +x warp-packer
    ./warp-packer --arch macos-x64 --input_dir src/git-istage/bin/Release/netcoreapp2.1/osx-x64/publish --exec git-istage --output dist/macos-x64/git-istage
    chmod +x dist/macos-x64/git-istage
}

if ($IsLinux) {
    dotnet publish ./src/git-istage --configuration Release --runtime linux-x64
    mkdir dist/linux-x64
    curl -Lo warp-packer https://github.com/dgiagio/warp/releases/download/v0.2.1/linux-x64.warp-packer
    chmod +x warp-packer
    ./warp-packer --arch linux-x64 --input_dir src/git-istage/bin/Release/netcoreapp2.1/linux-x64/publish --exec git-istage --output dist/linux-x64/git-istage
    chmod +x dist/linux-x64/git-istage
}