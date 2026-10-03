$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$login = Invoke-WebRequest -Uri 'http://localhost:8080/login' -Method Post -Body @{username='supplier';password='supplier123'} -WebSession $session
Write-Host "Login: " $login.StatusCode
$r1 = Invoke-WebRequest -Uri 'http://localhost:8080/supplier' -WebSession $session
Write-Host "Supplier Orders: " $r1.StatusCode
$r2 = Invoke-WebRequest -Uri 'http://localhost:8080/supplier/deliveries' -WebSession $session
Write-Host "Supplier Deliveries: " $r2.StatusCode
$r3 = Invoke-WebRequest -Uri 'http://localhost:8080/supplier/network' -WebSession $session
Write-Host "Supplier Network: " $r3.StatusCode
