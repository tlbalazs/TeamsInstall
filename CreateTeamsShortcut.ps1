# Author: LATOTH
# 2023.10.27

$logSource = "Teams Deployment"
if (![System.Diagnostics.EventLog]::SourceExists($logSource))
{
    New-Eventlog -LogName Application -Source $logSource
}

$username = (Get-ChildItem Env:USERNAME).Value
$sourcePath = "\\PATH\TO\SHARED\Teams\Microsoft Teams (work or school).lnk"
$destinationPath = "\\FILESERVER\emp\$username\Desktop"
$shortcutExists = Test-Path -Path "$destinationPath\Microsoft Teams (work or school).lnk"
$AppXStatus = Get-AppxPackage MSTeams

try
{
    if($shortcutExists -eq $false -and $AppXStatus -ne $null)
    {
        Copy-Item $sourcePath $destinationPath -Force
        Remove-Item "C:\Users\$username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Teams.lnk"
        Write-Eventlog -LogName Application -Source $logSource -EntryType Information -EventId 100 -Message "Teams shortcut has been copied to the Desktop."
    }
    else
    {
        Write-Eventlog -LogName Application -Source $logSource -EntryType Information -EventId 100 -Message "The shortcut already exists."
    }
}
catch [exception]
{
    Write-Eventlog -LogName Application -Source $logSource -EntryType Information -EventId 104 -Message "An error occured while creating the shortcut."
}
