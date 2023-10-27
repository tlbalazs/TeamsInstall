# Author: LATOTH
# 2023.09.10
# Switches used are "-install" and "-uninstall"
### Setting parameters
param
(
    [Parameter(Mandatory=$false)][Switch]$Install,
    [Parameter(Mandatory=$false)][Switch]$Uninstall,
    [Parameter(ValueFromRemainingArguments=$true)] $args
)
 
# LOGGING INITIALISATION
$logSource = "Teams Deployment"
if (![System.Diagnostics.EventLog]::SourceExists($logSource))
{
        New-Eventlog -LogName Application -Source $logSource
}
 
$AppXStatus = Get-AppxPackage MSTeams 
 
### Installation
If ($Install)
{
	try 
    {
        if($AppXStatus -eq $null)
        {
        \\PATH\TO\SHARED\FOLDER\Teams\teamsbootstrapper.exe -p
        Write-Eventlog -LogName Application -Source $logSource -EntryType Information -EventId 100 -Message "The new Teams client has been successfully installed."        
        }
        else
        {
            Write-Eventlog -LogName Application -Source $logSource -EntryType Information -EventId 100 -Message "The new Teams client was installed earlier."
        }
	} 
    catch [exception] 
    {
        Write-Eventlog -LogName Application -Source $logSource -EntryType Information -EventId 102 -Message "An error occured while installing Teams client."
	}
}
### Uninstallation
If ($Uninstall)
{
	try 
    {
       Get-AppxPackage MSTeams -AllUsers | Remove-AppxPackage -AllUsers
       Write-Eventlog -LogName Application -Source $logSource -EntryType Information -EventId 101 -Message "The new Teams client has been successfully removed."
	} 
    catch [exception] 
    {
        Write-Eventlog -LogName Application -Source $logSource -EntryType Information -EventId 103 -Message "An error occured while uninstalling OneDrive client."
	}
}