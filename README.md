# Cursor Trial Reset Tool (PowerShell Version)
A Windows-focused PowerShell utility that manages Cursor editor's device identification system by resetting stored device IDs.  
This tool can help resolve issues related to account restrictions when switching between accounts or during trial periods.

## How It Works
The script generates random device IDs, letting Cursor recognize your system as new. It backs up your original config file before any changes.

## Key Features
- ✨ Automatic random device ID generation
- 🔄 Automatic backup of original configuration
- 💻 Windows-only PowerShell implementation
- 📦 Works out of the box - requires only Windows PowerShell (pre-installed on all Windows systems)

> [!IMPORTANT]  
> You must log out and completely close Cursor before running the script.  
> If Cursor is running in the background, it may revert to the previous device ID, undoing the reset.

## Usage
Open Windows Powershell and paste this one-line script into the terminal.

```powershell
$sf="$env:APPDATA\Cursor\User\globalStorage\storage.json";if(Test-Path $sf){Copy-Item $sf "$sf.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')";$c=Get-Content -Raw $sf}else{$d=@{};New-Item -ItemType Directory (Split-Path $sf) -Force};function Get-RandHex{$b=New-Object byte[] 32;(New-Object Security.Cryptography.RNGCryptoServiceProvider).GetBytes($b);-join($b|%{'{0:x2}' -f $_})};$c=$c -replace '(?<="telemetry.machineId":\s*")[^"]*(?=")', (Get-RandHex) -replace '(?<="telemetry.macMachineId":\s*")[^"]*(?=")', (Get-RandHex) -replace '(?<="telemetry.devDeviceId":\s*")[^"]*(?=")', (New-Guid).Guid;Set-Content -Path $sf -Value $c -NoNewline;$d=[System.Text.RegularExpressions.Regex]::Matches($c,'"telemetry\.(machineId|macMachineId|devDeviceId)":\s*"([^"]*)"')|ForEach-Object{$_.Groups[2].Value}|Select-Object -First 3;Write-Host "`n✅ Cursor Trial Successfully Reset - New Device IDs Generated:`n";@{machineId=$d[0];macMachineId=$d[1];devDeviceId=$d[2]}|ConvertTo-Json
```
## Configuration Location
The Windows configuration file is located at:
```
%APPDATA%\Cursor\User\globalStorage\storage.json
```
(Typically resolves to `C:\Users\[YourUsername]\AppData\Roaming\Cursor\User\globalStorage\storage.json`)

Backups are created in the same directory with timestamps: `storage.json.backup_YYYYMMDD_HHMMSS`

## Important Notice
This tool is developed for research and educational purposes only. Please use responsibly.
The developer assumes no liability for any issues that may arise from using this tool.

## Credits
https://github.com/ultrasev/cursor-reset
