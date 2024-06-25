# Define the target directory where files will be downloaded
$targetDir = "C:\temp"

# Check if the temp folder exists, create it if it doesn't
$tempFolderPath = Join-Path -Path "C:\" -ChildPath "temp"
if (-not (Test-Path -Path $tempFolderPath -PathType Container)) {
    New-Item -Path $tempFolderPath -ItemType Directory | Out-Null
}

# URLs of the files to download
$urls = @(
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/2/starter.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/22222.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/IPv4NetworkScan.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/nowyfolder.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/udostepnione_foldery_host.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/udostepnione_foldery_ip.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/ustawieniaudostepniania.ps1",
    "https://github.com/ctrlos2/Toolbox/raw/main/print/qr.png"
)

# Function to download a file from a URL
function Download-File {
    param (
        [string]$url,
        [string]$destination
    )
    Invoke-WebRequest -Uri $url -OutFile $destination
}

# Download each file to the target directory
foreach ($url in $urls) {
    $fileName = [System.IO.Path]::GetFileName($url)
    $destinationPath = [System.IO.Path]::Combine($targetDir, $fileName)
    
    # Download the file
    try {
        Download-File -url $url -destination $destinationPath -ErrorAction Stop > $null
    } catch {
        Write-Error "Failed to download $url. Error: $_"
    }
}

# Set execution policy
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

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
