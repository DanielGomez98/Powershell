# Sube logs como adjunto...

$LogPath = "C:\Logs\app-error.log"
$TicketNumber = "INC0012347"
$SNInstance = "https://midominio.service-now.com"
$AttachmentAPI = "$SNInstance/api/now/attachment/file"
$sys_id = "reemplazar_con_sys_id_incidente"

# Leer archivo como binario
$fileBytes = [System.IO.File]::ReadAllBytes($LogPath)
$fileBase64 = [Convert]::ToBase64String($fileBytes)

# Enviar archivo como adjunto
Invoke-RestMethod -Uri $AttachmentAPI `
    -Method POST `
    -Headers @{
        "Accept" = "application/json"
        "Content-Type" = "application/octet-stream"
        "Authorization" = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$SNUser:$SNPass"))
    } `
    -Body $fileBytes `
    -InFile $LogPath `
    -ContentType "application/octet-stream"
