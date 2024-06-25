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

# Download each file except for 22222.ps1 (we'll run this one separately)
foreach ($url in $urls) {
    $fileName = [System.IO.Path]::GetFileName($url)
    $destinationPath = [System.IO.Path]::Combine($targetDir, $fileName)
    if ($fileName -ne "22222.ps1") {
        try {
            Download-File -url $url -destination $destinationPath -ErrorAction Stop > $null  # Redirect output to $null to suppress download messages
        } catch {
            Write-Error "Failed to download $url. Error: $_"
        }
    }
}
# Set full path to 22222.ps1
$scriptPath = "C:\temp\22222.ps1"

# Check if the script file exists
if (-not (Test-Path $scriptPath -PathType Leaf)) {
    Write-Error "Script file does not exist: $scriptPath"
    exit 1
}

# Run the script
Write-Output "Running script $scriptPath"
try {
    powershell.exe -File $scriptPath -ErrorAction Stop
} catch {
    Write-Error "Failed to run $scriptPath. Error: $_"
    exit 1
}

# Wait for a few seconds after running the script
Start-Sleep -Seconds 5
