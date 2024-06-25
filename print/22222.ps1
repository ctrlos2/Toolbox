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

# Tworzenie kontrolki TabControl
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = [System.Windows.Forms.DockStyle]::Fill

# ==================== Tab Page 1 ====================
$tabPage1 = New-Object System.Windows.Forms.TabPage
$tabPage1.Text = "Apps"

# Funkcja do dodawania przycisków bez ikon
function Add-ButtonToTab {
    param (
        [System.Windows.Forms.TabPage]$tabPage,
        [string]$text,
        [int]$top,
        [scriptblock]$onClick
    )
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $text
    $button.Size = New-Object System.Drawing.Size(250, 40)
    $button.Location = New-Object System.Drawing.Point(30, $top)
    $button.FlatStyle = "Flat"
    $button.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $button.Add_Click($onClick)
    $tabPage.Controls.Add($button)
}

# Akcje dla przycisków
$action1 = { Start-Process -FilePath ".\IPv4NetworkScan.ps1" }
$action2 = { Start-Process -FilePath ".\nowyfolder.ps1" }
$action3 = { Start-Process -FilePath ".\udostepnione_foldery_ip.ps1" }
$action4 = { Start-Process -FilePath ".\udostepnione_foldery_host.ps1" }
$action5 = { Start-Process -FilePath ".\ustawieniaudostepniania.ps1" }

# Dodawanie przycisków do pierwszej zakładki
Add-ButtonToTab -tabPage $tabPage1 -text "SKANOWANIE IP" -top 20 -onClick $action1
Add-ButtonToTab -tabPage $tabPage1 -text "Nowy folder na dysku C" -top 80 -onClick $action2
Add-ButtonToTab -tabPage $tabPage1 -text "Sprawdź Udostępnione IP" -top 140 -onClick $action3
Add-ButtonToTab -tabPage $tabPage1 -text "Udostępnione foldery host" -top 200 -onClick $action4
Add-ButtonToTab -tabPage $tabPage1 -text "Ustawienia Udostępniania" -top 260 -onClick $action5

# Dodanie zakładki do kontrolki TabControl
$tabControl.TabPages.Add($tabPage1)

# Dodanie kontrolki TabControl do formularza
$form.Controls.Add($tabControl)

# Wyświetlanie formularza
$form.ShowDialog()

# ==================== Tab Page 2 ====================
$tabPage2 = New-Object System.Windows.Forms.TabPage
$tabPage2.Text = "Directories"


# Dodawanie zakładek do TabControl
$tabControl.TabPages.Add($tabPage1)
$tabControl.TabPages.Add($tabPage2)

# Dodanie TabControl do formularza
$form.Controls.Add($tabControl)

# ==================== Wyświetlanie formularza ====================
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
