# Builds SeralythPlugin.dll against every Seralyth Remake variant and deploys
# each build to its matching Plugins folder.
param(
    [string]$MenuBuildDir = "C:\Users\kalew\Downloads\Seralyth-Menu-4.8.5 (1)\Seralyth-Menu-4.8.5\bin\Debug\netstandard2.1",
    [string]$ProjectDir = $PSScriptRoot
)

$variants = @(
    @{ Name = "Seralyth Remake Debug";   File = "Seralyth Remake Debug.dll";   Folder = "SeralythMenu" },
    @{ Name = "Seralyth Remake Classic";  File = "Seralyth Remake Classic.dll"; Folder = "Classic" },
    @{ Name = "Seralyth Remake.Client";   File = "Seralyth Remake.Client.dll";  Folder = "Client" },
    @{ Name = "Seralyth Remake Free";     File = "Seralyth Remake Free.dll";    Folder = "Free" },
    @{ Name = "Seralyth Remake Legal";    File = "Seralyth Remake Legal.dll";   Folder = "Legal" },
    @{ Name = "Seralyth Remake Legacy";   File = "Seralyth Remake Legacy.dll";  Folder = "Legacy" },
    @{ Name = "Seralyth Remake Lite";     File = "Seralyth Remake Lite.dll";    Folder = "Lite" },
    @{ Name = "Seralyth Remake Pro";      File = "Seralyth Remake Pro.dll";     Folder = "Pro" },
    @{ Name = "Seralyth Remake Reborn";   File = "Seralyth Remake Reborn.dll";  Folder = "Reborn" },
    @{ Name = "Seralyth Remake Redux";    File = "Seralyth Remake Redux.dll";   Folder = "Redux" },
    @{ Name = "Seralyth Remake Reforged"; File = "Seralyth Remake Reforged.dll";Folder = "Reforged" },
    @{ Name = "Seralyth Remake Trial";    File = "Seralyth Remake Trial.dll";   Folder = "Trial" },
    @{ Name = "Seralyth Remake Ultra";    File = "Seralyth Remake Ultra.dll";   Folder = "Ultra" }
)

$gamePath = "C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag"

foreach ($v in $variants) {
    $dllPath = Join-Path $MenuBuildDir $v.File
    if (-not (Test-Path $dllPath)) { Write-Host "SKIP (missing dll): $($v.Name)"; continue }
    Write-Host "=== Building for $($v.Name) ==="
    Push-Location $ProjectDir
    dotnet build SeralythPlugin.csproj -p:MenuDllName="$($v.Name)" -p:MenuDllPath="$dllPath" | Out-Null
    $code = $LASTEXITCODE
    Pop-Location
    if ($code -ne 0) { Write-Host "FAILED: $($v.Name) (exit $code)"; continue }
    $dest = if ($v.Folder -eq "SeralythMenu") { "$gamePath\SeralythMenu\Plugins" } else { "$gamePath\SeralythMenu\$($v.Folder)\Plugins" }
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Copy-Item "$ProjectDir\bin\Debug\netstandard2.1\SeralythPlugin.dll" "$dest\SeralythPlugin.dll" -Force
    Write-Host "Deployed to $dest"
}
Write-Host "ALL DONE"