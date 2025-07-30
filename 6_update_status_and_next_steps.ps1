# Cambia estado y agrega next steps...

# Parámetros del incidente y ServiceNow
$TicketNumber = "INC0012348"
$NewState = 2  # 1: New, 2: In Progress, 3: On Hold, 6: Resolved, 7: Closed
$NextSteps = "Se solicitó validación al equipo de QA."
$SNInstance = "https://midominio.service-now.com"
$SNUser = "usuario_api"
$SNPass = "contraseña_api"

# Obtener sys_id del incidente
try {
    $incidentUrl = "$SNInstance/api/now/table/incident?sysparm_query=number=$TicketNumber"
    $ticket = Invoke-RestMethod -Uri $incidentUrl `
        -Method Get `
        -Headers @{ "Accept" = "application/json" } `
        -Credential (New-Object System.Management.Automation.PSCredential(
            $SNUser, (ConvertTo-SecureString $SNPass -AsPlainText -Force)))

    if ($ticket.result.Count -eq 0) {
        Write-Host "No se encontró el incidente con número: $TicketNumber"
        exit 1
    }

    $sys_id = $ticket.result[0].sys_id
} catch {
    Write-Host "Error al consultar el incidente: $_"
    exit 1
}

# Construir el cuerpo para actualizar
$updateBody = @{
    state = $NewState
    comments = $NextSteps
    work_notes = "Automated Update: $NextSteps"
} | ConvertTo-Json

# Hacer el PATCH
try {
    $updateUrl = "$SNInstance/api/now/table/incident/$sys_id"
    Invoke-RestMethod -Uri $updateUrl `
        -Method Patch `
        -Headers @{ "Content-Type" = "application/json" } `
        -Credential (New-Object System.Management.Automation.PSCredential(
            $SNUser, (ConvertTo-SecureString $SNPass -AsPlainText -Force))) `
        -Body $updateBody

    Write-Host "Incidente $TicketNumber actualizado correctamente."
} catch {
    Write-Host "Error al actualizar el incidente: $_"
}
