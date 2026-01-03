Invoke-WebRequest ((Invoke-WebRequest -Uri "https://nightly.link/mpv-player/mpv/workflows/build/master").Links | Where-Object { $_.href -like "*x86_64-pc-windows-msvc.zip" } | Select-Object -ExpandProperty href) -OutFile "$HOME\Downloads\mpv.zip"

Expand-Archive -Force -Path "$HOME\Downloads\mpv.zip" -DestinationPath "$HOME\AppData\Local\mpv"

Remove-Item "$HOME\Downloads\mpv.zip"

if (-Not ([Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User).Contains("$HOME\AppData\Local\mpv"))) {
    [Environment]::SetEnvironmentVariable(
        "Path",
        [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";$HOME\AppData\Local\mpv",
        [EnvironmentVariableTarget]::User
    )
}

if (-Not (Test-Path "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\mpv.lnk")) {
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut("$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\mpv.lnk")
    $shortcut.TargetPath = "$HOME\AppData\Local\mpv\mpv.exe"
    $shortcut.Save()
}

if (-Not (Test-Path "$HOME\AppData\Roaming\mpv\mpv.conf")) {
    New-Item -Force -ItemType File -Path "$HOME\AppData\Roaming\mpv\mpv.conf"
}
