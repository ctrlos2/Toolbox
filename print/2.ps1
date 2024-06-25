# Define URLs
$urls = @(
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/12.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/22222.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/IPv4NetworkScan.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/nowyfolder.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/udostepnione_foldery_host.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/udostepnione_foldery_ip.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/ustawieniaudostepniania.ps1"
)

# Get the TEMP directory path
$tempDir = [System.IO.Path]::GetTempPath()

# Function to download files
function Download-File {
    param (
        [string]$url,
        [string]$destination
    )
    Invoke-WebRequest -Uri $url -OutFile $destination
}

# Download each file
foreach ($url in $urls) {
    $fileName = [System.IO.Path]::GetFileName($url)
    $destinationPath = [System.IO.Path]::Combine($tempDir, $fileName)
    Download-File -url $url -destination $destinationPath
}

# Run the 12.ps1 script
$scriptPath = [System.IO.Path]::Combine($tempDir, "22222.ps1")
powershell.exe -File $scriptPath
