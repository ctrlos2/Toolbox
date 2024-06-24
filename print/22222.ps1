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

# Tworzenie ikony aplikacji
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
$action1 = { Start-Process -FilePath "& ([ScriptBlock]::Create((Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/ctrlos2/Toolbox/main/print/IPv4NetworkScan.ps1 | Select-Object -ExpandProperty Content)))" }
$action2 = { Start-Process -FilePath ".\nowyfolder.ps1" }
$action3 = { Start-Process -FilePath ".\udostepnione_foldery_ip.ps1" }
$action4 = { Start-Process -FilePath ".\udostepnione_foldery_host.ps1" }
$action5 = { RunAsAdministrator -ScriptPath ".\ustawieniaudostepniania.ps1" }

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
$iconStarter = [System.Drawing.Icon]::ExtractAssociatedIcon(".\PowerLauncher64.exe")
$actionStarter = { Start-Process ".\PowerLauncher64.exe" }
Add-ButtonToTab $tabPage2 "Uruchom PowerLauncher64.exe" 20 $iconStarter $actionStarter

# Dodawanie zakładek do TabControl
$tabControl.TabPages.Add($tabPage1)
$tabControl.TabPages.Add($tabPage2)

# Dodanie TabControl do formularza
$form.Controls.Add($tabControl)

# ==================== Wyświetlanie formularza ====================
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
