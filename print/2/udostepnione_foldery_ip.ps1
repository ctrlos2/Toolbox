# Dodanie typu Windows Forms, aby można było użyć MessageBox i DataGridView
Add-Type -AssemblyName System.Windows.Forms

# Funkcja do pobierania adresu IP dla interfejsu Ethernet lub Wi-Fi
function Get-IPAddress {
    # Pobranie wszystkich interfejsów sieciowych IPv4, pomijając pętlę i vEthernet
    $networkInterfaces = Get-NetIPAddress -AddressFamily IPv4 |
        Where-Object { $_.InterfaceAlias -ne 'Loopback Pseudo-Interface 1' -and $_.InterfaceDescription -notlike '*vEthernet*' }

    # Szukanie pierwszego interfejsu Wi-Fi, jeśli istnieje
    $wifiInterface = $networkInterfaces | Where-Object { $_.InterfaceAlias -like '*Wi-Fi*' } | Select-Object -First 1

    if ($wifiInterface) {
        return $wifiInterface.IPAddress
    }

    # Jeśli nie znaleziono Wi-Fi, zwróć pierwszy interfejs Ethernet
    $ethInterface = $networkInterfaces | Where-Object { $_.InterfaceAlias -like '*Ethernet*' } | Select-Object -First 1

    if ($ethInterface) {
        return $ethInterface.IPAddress
    }

    return $null
}

# Pobranie adresu IP komputera
$ipAddress = Get-IPAddress

if (-not $ipAddress) {
    [System.Windows.Forms.MessageBox]::Show("Nie można uzyskać aktywnego adresu IP. Sprawdź połączenie sieciowe.", "Błąd", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit
}

# Pobranie informacji o udostępnionych folderach
$shares = Get-WmiObject -Class Win32_Share | Where-Object { $_.Name -ne 'IPC$' }

# Utworzenie formularza Windows Forms
$form = New-Object System.Windows.Forms.Form
$form.Text = "Udostepnione foldery"
$form.Size = New-Object System.Drawing.Size(600, 400)

# Utworzenie DataGridView
$dataGridView = New-Object System.Windows.Forms.DataGridView
$dataGridView.Dock = 'Fill'
$dataGridView.AutoSizeColumnsMode = 'Fill'
$dataGridView.ReadOnly = $true
$dataGridView.AllowUserToAddRows = $false
$dataGridView.AllowUserToDeleteRows = $false
$dataGridView.AllowUserToOrderColumns = $false
$dataGridView.RowHeadersVisible = $false
$dataGridView.SelectionMode = 'FullRowSelect'
$dataGridView.MultiSelect = $false

# Dodanie kolumny do DataGridView
$column = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$column.HeaderText = "Pelna sciezka sieciowa"
$dataGridView.Columns.Add($column)

# Dodanie danych do DataGridView
$shares | ForEach-Object {
    $dataGridView.Rows.Add("\\$ipAddress\$($_.Name)")
}

# Dodanie DataGridView do formularza
$form.Controls.Add($dataGridView)

# Dodanie przycisku do kopiowania
$copyButton = New-Object System.Windows.Forms.Button
$copyButton.Text = "Kopiuj"
$copyButton.Dock = 'Bottom'
$copyButton.Add_Click({
    $selectedRow = $dataGridView.SelectedRows[0]
    $pathToCopy = $selectedRow.Cells[0].Value
    [System.Windows.Forms.Clipboard]::SetText($pathToCopy)
    [System.Windows.Forms.MessageBox]::Show("Skopiowano sciezke do schowka:`n$pathToCopy", "Sukces", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})
$form.Controls.Add($copyButton)

# Wyświetlenie formularza
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
