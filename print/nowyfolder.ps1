Add-Type -AssemblyName System.Windows.Forms

# Tworzenie okna głównego
$form = New-Object System.Windows.Forms.Form
$form.Text = "Utworz nowy folder"
$form.Width = 300
$form.Height = 150
$form.StartPosition = "CenterScreen"

# Tworzenie kontrolki etykiety
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.Size = New-Object System.Drawing.Size(280, 20)
$label.Text = "Wprowadz nazwe nowego folderu:"
$form.Controls.Add($label)

# Tworzenie kontrolki textbox
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, 50)
$textBox.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($textBox)

# Tworzenie przycisku OK
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(220, 48)
$button.Size = New-Object System.Drawing.Size(60, 25)
$button.Text = "Utworz"
$button.Add_Click({
    $folderName = $textBox.Text
    if (-not [string]::IsNullOrWhiteSpace($folderName)) {
        $folderPath = Join-Path -Path "C:\" -ChildPath $folderName
        New-Item -Path $folderPath -ItemType Directory -ErrorAction SilentlyContinue
        [System.Windows.Forms.MessageBox]::Show("Folder został utworzony: $folderPath", "Utworzono folder", "OK", [System.Windows.Forms.MessageBoxIcon]::Information)
    } else {
        [System.Windows.Forms.MessageBox]::Show("Wprowadź nazwę folderu!", "Błąd", "OK", [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})
$form.Controls.Add($button)

# Wyświetlanie formularza
$form.ShowDialog() | Out-Null
