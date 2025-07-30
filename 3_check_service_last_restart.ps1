# Verifica última vez iniciado...
$ServiceName = "Spooler"
$svc = Get-WmiObject -Class Win32_Service -Filter "Name='$ServiceName'"
$LastStateChange = $svc.ConvertToDateTime($svc.Started)

Write-Output "El servicio '$ServiceName' fue iniciado por última vez en: $LastStateChange"
