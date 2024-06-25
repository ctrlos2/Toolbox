# Define the target directory where files will be downloaded
$targetDir = "C:\temp"

# Check if the temp folder exists, create it if it doesn't
$tempFolderPath = Join-Path -Path "C:\" -ChildPath "temp"
if (-not (Test-Path -Path $tempFolderPath -PathType Container)) {
    New-Item -Path $tempFolderPath -ItemType Directory | Out-Null
}

$urls = @(
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/2/starter.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/22222.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/IPv4NetworkScan.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/nowyfolder.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/udostepnione_foldery_host.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/udostepnione_foldery_ip.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/ustawieniaudostepniania.ps1"
)

function Download-File {
    param (
        [string]$url,
        [string]$destination
    )
    Invoke-WebRequest -Uri $url -OutFile $destination
}

# Download each file except for starter.ps1 (we'll run this one separately)
foreach ($url in $urls) {
    $fileName = [System.IO.Path]::GetFileName($url)
    $destinationPath = [System.IO.Path]::Combine($targetDir, $fileName)
    if ($fileName -ne "starter.ps1") {
        Download-File -url $url -destination $destinationPath > $null  # Redirect output to $null to suppress download messages
    }
}

# Set execution policy
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Run 22222.ps1 from C:\temp
$scriptPath = [System.IO.Path]::Combine($targetDir, "starter.ps1")
Write-Output "Running script $scriptPath"
powershell.exe -File $scriptPath

# Wait for a few seconds after running the script
Start-Sleep -Seconds 5
