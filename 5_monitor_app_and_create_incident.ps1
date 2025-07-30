# Monitorea app y crea incidente...

$appName = "MyApp"
$process = Get-Process -Name $appName -ErrorAction SilentlyContinue

if (-not $process) {
    # Crear ticket en ServiceNow
    $body = @{
        short_description = "$appName no se está ejecutando"
        description = "Se detectó que la aplicación $appName no está activa en $(hostname) a las $(Get-Date)."
        urgency = "2"
        impact = "2"
    } | ConvertTo-Json

    Invoke-RestMethod -Uri "$SNInstance/api/now/table/incident" `
        -Method Post `
        -Headers @{ "Content-Type" = "application/json" } `
        -Credential (New-Object System.Management.Automation.PSCredential($SNUser,(ConvertTo-SecureString $SNPass -AsPlainText -Force))) `
        -Body $body
}
