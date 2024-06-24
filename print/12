Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Tworzenie formularza
$form = New-Object System.Windows.Forms.Form
$form.Text = "Custom Launcher"
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"

# Tworzenie kontrolki TabControl
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = [System.Windows.Forms.DockStyle]::Fill

# Tworzenie zakładki 1
$tabPage1 = New-Object System.Windows.Forms.TabPage
$tabPage1.Text = "Apps"

# Tworzenie zakładki 2
$tabPage2 = New-Object System.Windows.Forms.TabPage
$tabPage2.Text = "Directories"

# Dodawanie zakładek do TabControl
$tabControl.TabPages.Add($tabPage1)
$tabControl.TabPages.Add($tabPage2)

# ===============================================================#
# Tab Page 1 [Buttons 1-5 appear on the first tab]               #
# ===============================================================#

function Add-ButtonToTab($tabPage, $text, $top, $onClick) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $text
    $button.Size = New-Object System.Drawing.Size(200, 30)
    $button.Location = New-Object System.Drawing.Point(10, $top)
    $button.Add_Click($onClick)
    $tabPage.Controls.Add($button)
}

# Definiowanie akcji dla przycisków
$action1 = {
    Start-Process -FilePath "Pv4NetworkScan.ps1"
}
$action2 = {
    Start-Process -FilePath "nowyfolder.ps1"
}
$action3 = {
    Start-Process -FilePath "udostepnione_foldery_ip.ps1"
}
$action4 = {
    Start-Process -FilePath "udostepnione_foldery_host.ps1"
}
$action5 = {
    Start-Process -FilePath "ustawieniaudostepniania.ps1"
}

# Dodawanie przycisków do pierwszej zakładki
Add-ButtonToTab $tabPage1 "SKANOWANIE IP" 10 $action1
Add-ButtonToTab $tabPage1 "Nowy folder na dysku C" 50 $action2
Add-ButtonToTab $tabPage1 "Sprawdz Udostepnione IP" 90 $action3
Add-ButtonToTab $tabPage1 "udostepnione foldery host" 130 $action4
Add-ButtonToTab $tabPage1 "Udostepnij Folder" 170 $action5

# Dodawanie TabControl do formularza
$form.Controls.Add($tabControl)

# Wyświetlanie formularza
[void]$form.ShowDialog()
