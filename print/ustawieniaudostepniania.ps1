Add-Type -AssemblyName System.Windows.Forms

# Funkcja sprawdzająca i uruchamiająca skrypt jako administrator
function RunAsAdministrator {
    param (
        [string]$ScriptPath
    )

    # Utwórz obiekt do uruchamiania procesu
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""
    $psi.Verb = "runas"  # Uruchamia jako administrator

    # Uruchom proces
    [System.Diagnostics.Process]::Start($psi) | Out-Null
    exit
}

# Sprawdzenie czy skrypt jest uruchamiany jako administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Jeśli nie jest uruchomiony jako administrator, uruchom ponownie jako administrator
    RunAsAdministrator -ScriptPath $MyInvocation.MyCommand.Path
}

# Tworzenie okna głównego
$form = New-Object System.Windows.Forms.Form
$form.Text = "Udostępnianie folderu na dysku C:"
$form.Width = 400
$form.Height = 250
$form.StartPosition = "CenterScreen"

# Tworzenie kontrolki etykiety
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(20, 20)
$label.Size = New-Object System.Drawing.Size(300, 20)
$label.Text = "Wprowadź nazwę folderu do udostępnienia na dysku C:"
$form.Controls.Add($label)

# Tworzenie kontrolki textbox
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(20, 50)
$textBox.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($textBox)

# Tworzenie przycisku Sprawdź
$checkButton = New-Object System.Windows.Forms.Button
$checkButton.Location = New-Object System.Drawing.Point(230, 48)
$checkButton.Size = New-Object System.Drawing.Size(120, 25)
$checkButton.Text = "Sprawdź nazwę"
$checkButton.Add_Click({
    $folderName = $textBox.Text
    $folderPath = Join-Path -Path "C:\" -ChildPath $folderName
    if (Test-Path -Path $folderPath -PathType Container) {
        [System.Windows.Forms.MessageBox]::Show("Nazwa folderu jest poprawna.", "Sprawdzono nazwę", "OK", [System.Windows.Forms.MessageBoxIcon]::Information)
        $shareButton.Enabled = $true
    } else {
        [System.Windows.Forms.MessageBox]::Show("Nie można znaleźć folderu o podanej nazwie na dysku C.", "Błąd", "OK", [System.Windows.Forms.MessageBoxIcon]::Error)
        $shareButton.Enabled = $false
    }
})
$form.Controls.Add($checkButton)

# Tworzenie przycisku Udostępnij (domyślnie wyłączony)
$shareButton = New-Object System.Windows.Forms.Button
$shareButton.Location = New-Object System.Drawing.Point(20, 90)
$shareButton.Size = New-Object System.Drawing.Size(120, 30)
$shareButton.Text = "Udostępnij folder"
$shareButton.Enabled = $false
$shareButton.Add_Click({
    $folderName = $textBox.Text
    $folderPath = Join-Path -Path "C:\" -ChildPath $folderName
    $shareName = $folderName + "_U"
    
    # Sprawdź, czy udostępnienie już istnieje
    $existingShare = Get-SmbShare -Name $shareName -ErrorAction SilentlyContinue
    if ($existingShare -eq $null) {
        try {
            # Utwórz nowe udostępnienie
            New-SmbShare -Name $shareName -Path $folderPath -FullAccess "Wszyscy"
            [System.Windows.Forms.MessageBox]::Show("Folder został pomyślnie udostępniony jako $shareName.", "Sukces", "OK", [System.Windows.Forms.MessageBoxIcon]::Information)
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Wystąpił problem podczas próby udostępnienia folderu.", "Błąd", "OK", [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Folder już jest udostępniony jako $shareName.", "Błąd", "OK", [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})
$form.Controls.Add($shareButton)

# Wyświetlanie formularza
$form.ShowDialog() | Out-Null
