# Reinicia un servicio...
# Parámetros
$ServiceName = "W3SVC"
$TicketNumber = "INC0012345"
$SNInstance = "https://midominio.service-now.com"
$SNUser = "usuario_api"
$SNPass = "contraseña_api"

# Reinicia el servicio
try {
    Restart-Service -Name $ServiceName -Force -ErrorAction Stop
    $status = "Servicio '$ServiceName' reiniciado correctamente."
} catch {
    $status = "Error al reiniciar el servicio: $_"
}

# Actualiza el ticket en ServiceNow
$body = @{
    comments = $status
    work_notes = $status
} | ConvertTo-Json

Invoke-RestMethod -Uri "$SNInstance/api/now/table/incident?sysparm_query=number=$TicketNumber" `
    -Method Patch `
    -Headers @{ "Content-Type" = "application/json" } `
    -Credential (New-Object System.Management.Automation.PSCredential($SNUser,(ConvertTo-SecureString $SNPass -AsPlainText -Force))) `
    -Body $body
