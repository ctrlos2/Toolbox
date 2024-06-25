Add-Type -AssemblyName PresentationFramework

# Pobranie adresu IP z bieżącego połączenia IPv4
$ipAddress = (Get-NetIPAddress -InterfaceAlias (Get-NetConnectionProfile).InterfaceAlias -AddressFamily IPv4).IPAddress

# Wyświetlenie adresu IP w oknie dialogowym (popup)
[System.Windows.MessageBox]::Show("Twoj adres IP to: $ipAddress", "Adres IP", "OK", [System.Windows.MessageBoxImage]::Information)
