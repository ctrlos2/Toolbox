$urls = @(
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/2/starter.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/22222.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/IPv4NetworkScan.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/nowyfolder.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/udostepnione_foldery_host.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/udostepnione_foldery_ip.ps1",
    "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/ustawieniaudostepniania.ps1"
)

$tempDir = [System.IO.Path]::GetTempPath()

# Define the target directory where files will be downloaded
$targetDir = "C:\temp"

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

# Run starter.ps1 in a hidden PowerShell window
$starterScriptPath = [System.IO.Path]::Combine($targetDir, "starter.ps1")
Write-Output "Running script $starterScriptPath"
Start-Process -FilePath "powershell.exe" -ArgumentList "-File `"$starterScriptPath`"" -WindowStyle Hidden -NoNewWindow


# Run starter.ps1 in a visible PowerShell window
$starterScriptPath = [System.IO.Path]::Combine($targetDir, "starter.ps1")
Write-Output "Running script $starterScriptPath"
Start-Process -FilePath "powershell.exe" -ArgumentList "-File `"$starterScriptPath`""

# Wait for a few seconds to ensure starter.ps1 has started
Start-Sleep -Seconds 5
