# Verifica espacio en disco...
$Ticket = "INC0012346"
$WarningThreshold = 15  # % de espacio libre
$alerts = @()

Get-PSDrive -PSProvider 'FileSystem' | ForEach-Object {
    if ($_.Free / $_.Used * 100 -lt $WarningThreshold) {
        $alerts += "Disco $_.Name tiene solo $([math]::Round($_.Free / 1GB, 2)) GB libres."
    }
}

if ($alerts.Count -gt 0) {
    $note = $alerts -join "`n"
} else {
    $note = "Todos los discos tienen suficiente espacio disponible."
}

# (Reutilizar autenticación de ejemplo anterior para enviar nota al ticket)
