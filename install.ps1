# Installs session management commands into %USERPROFILE%\.claude\commands\
# so they're available as slash commands in any Claude Code project.
# Run from PowerShell: .\install.ps1

$commandsDir = Join-Path $env:USERPROFILE ".claude\commands"
$scriptDir   = $PSScriptRoot

New-Item -ItemType Directory -Force -Path $commandsDir | Out-Null

Get-ChildItem -Path (Join-Path $scriptDir "commands") -Filter "*.md" | ForEach-Object {
    $dest = Join-Path $commandsDir $_.Name
    Copy-Item $_.FullName -Destination $dest -Force
    Write-Host "Installed: $dest"
}

Write-Host ""
Write-Host "Done. Commands available in Claude Code:"
Get-ChildItem -Path (Join-Path $scriptDir "commands") -Filter "*.md" | ForEach-Object {
    Write-Host "  /$($_.BaseName)"
}
