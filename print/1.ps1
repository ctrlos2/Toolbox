Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework

# Funkcja do uruchamiania skryptów jako administrator
function RunAsAdministrator {
    param (
        [string]$ScriptPath
    )

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""
    $psi.Verb = "runas"  # Uruchamia jako administrator

    [System.Diagnostics.Process]::Start($psi) | Out-Null
    exit
}

# Tworzenie formularza głównego
$form = New-Object System.Windows.Forms.Form
$form.Text = "Custom Launcher"
$form.Size = New-Object System.Drawing.Size(800, 600)
$form.StartPosition = "CenterScreen"

# Tworzenie ikony aplikacji na podstawie bieżącego procesu
$icon = [System.Drawing.Icon]::ExtractAssociatedIcon((Get-Process -Id $PID).Path)
$form.Icon = $icon

# Tworzenie kontrolki TabControl
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = [System.Windows.Forms.DockStyle]::Fill

# ==================== Tab Page 1 ====================
$tabPage1 = New-Object System.Windows.Forms.TabPage
$tabPage1.Text = "Apps"

# Funkcja do dodawania przycisków z ikonami
function Add-ButtonToTab($tabPage, $text, $top, $icon, $onClick) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $text
    $button.Image = $icon
    $button.ImageAlign = "MiddleLeft"
    $button.TextImageRelation = "ImageBeforeText"
    $button.Size = New-Object System.Drawing.Size(250, 40)
    $button.Location = New-Object System.Drawing.Point(30, $top)
    $button.FlatStyle = "Flat"
    $button.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $button.Add_Click($onClick)
    $tabPage.Controls.Add($button)
}

# Akcje dla przycisków
$action1 = {
    try {
        $icon1 = [System.Drawing.Icon]::ExtractAssociatedIcon("ip.exe")
        Start-Process -FilePath "ip.exe"
    } catch {
        Write-Host "Nie można załadować ikony lub pliku ip.exe."
    }
}

$action2 = {
    try {
        $response = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/nowyfolder.ps1"
        $icon2 = [System.Drawing.Icon]::ExtractAssociatedIcon($response.BaseResponse.ResponseUri)
        $response | Out-Null
        Start-Process -FilePath $response.BaseResponse.ResponseUri
    } catch {
        Write-Host "Nie można załadować ikony lub pliku nowyfolder.ps1."
    }
}

$action3 = {
    try {
        $response = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/nowyfolder.ps1"
        $icon3 = [System.Drawing.Icon]::ExtractAssociatedIcon($response.BaseResponse.ResponseUri)
        $response | Out-Null
        Start-Process -FilePath $response.BaseResponse.ResponseUri
    } catch {
        Write-Host "Nie można załadować ikony lub pliku nowyfolder.ps1."
    }
}

$action4 = {
    try {
        $response = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/udostepnione_foldery_ip.ps1"
        $icon4 = [System.Drawing.Icon]::ExtractAssociatedIcon($response.BaseResponse.ResponseUri)
        $response | Out-Null
        Start-Process -FilePath $response.BaseResponse.ResponseUri
    } catch {
        Write-Host "Nie można załadować ikony lub pliku udostepnione_foldery_ip.ps1."
    }
}

$action5 = {
    try {
        $response = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/ustawieniaudostepniania.ps1"
        $icon5 = [System.Drawing.Icon]::ExtractAssociatedIcon($response.BaseResponse.ResponseUri)
        $response | Out-Null
        $scriptPath = "$env:TEMP\ustawieniaudostepniania.ps1"
        $response.Content | Out-File -FilePath $scriptPath
        RunAsAdministrator -ScriptPath $scriptPath
    } catch {
        Write-Host "Nie można załadować ikony lub pliku ustawieniaudostepniania.ps1."
    }
}

# Ikona dla przycisku Starter
try {
    $iconStarter = [System.Drawing.Icon]::ExtractAssociatedIcon(".\PowerLauncher64.exe")
} catch {
    Write-Host "Nie można załadować ikony lub pliku PowerLauncher64.exe."
}

$actionStarter = {
    try {
        Start-Process ".\PowerLauncher64.exe"
    } catch {
        Write-Host "Nie można uruchomić pliku PowerLauncher64.exe."
    }
}

# Dodawanie przycisków do pierwszej zakładki
Add-ButtonToTab $tabPage1 "SKANOWANIE IP" 20 $icon1 $action1
Add-ButtonToTab $tabPage1 "Nowy folder na dysku C" 80 $icon2 $action2
Add-ButtonToTab $tabPage1 "Sprawdź Udostępnione IP" 140 $icon3 $action3
Add-ButtonToTab $tabPage1 "Udostępnione foldery host" 200 $icon4 $action4
Add-ButtonToTab $tabPage1 "Ustawienia Udostępniania" 260 $icon5 $action5

# ==================== Tab Page 2 ====================
$tabPage2 = New-Object System.Windows.Forms.TabPage
$tabPage2.Text = "Directories"

# Dodawanie przycisku "Starter" z ikoną
Add-ButtonToTab $tabPage2 "Uruchom PowerLauncher64.exe" 20 $iconStarter $actionStarter

# Dodawanie zakładek do TabControl
$tabControl.TabPages.Add($tabPage1)
$tabControl.TabPages.Add($tabPage2)

# Dodanie TabControl do formularza
$form.Controls.Add($tabControl)

# ==================== Wyświetlanie formularza ====================
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
