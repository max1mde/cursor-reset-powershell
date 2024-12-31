$sf = "$env:APPDATA\Cursor\User\globalStorage\storage.json"

if (Test-Path $sf) {
    Copy-Item $sf "$sf.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    $c = Get-Content -Raw $sf
} else {
    $d = @{}
    New-Item -ItemType Directory (Split-Path $sf) -Force
}

function Get-RandHex {
    $b = New-Object byte[] 32
    (New-Object Security.Cryptography.RNGCryptoServiceProvider).GetBytes($b)
    -join ($b | ForEach-Object { '{0:x2}' -f $_ })
}

$c = $c -replace '(?<="telemetry.machineId":\s*")[^"]*(?=")', (Get-RandHex) `
        -replace '(?<="telemetry.macMachineId":\s*")[^"]*(?=")', (Get-RandHex) `
        -replace '(?<="telemetry.devDeviceId":\s*")[^"]*(?=")', (New-Guid).Guid

Set-Content -Path $sf -Value $c -NoNewline

$d = [System.Text.RegularExpressions.Regex]::Matches($c, '"telemetry\.(machineId|macMachineId|devDeviceId)":\s*"([^"]*)"') |
    ForEach-Object { $_.Groups[2].Value } | 
    Select-Object -First 3

Write-Host "`n✅ Cursor Trial Successfully Reset - New Device IDs Generated:`n"

@{
    machineId    = $d[0]
    macMachineId = $d[1]
    devDeviceId  = $d[2]
} | ConvertTo-Json
