<# 
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Get-LoggedOnUser.ps1
	 Created on:   	2016-09-18 15:48
	 Created by:   	Mike Sims
	 Changed on:   	2016-09-18
	 Changed by:   	Mike Sims
	 Version:     	1.1
	 History:      	1.0 - Initial Release
                    1.1 - Enabled Strict Mode
	===========================================================================
	.DESCRIPTION
		Get-LoggedOnUser Function
#>

Function Get-LoggedOnUser
{
    <#
        .SYNOPSIS
            Get logged on users.
        
        .DESCRIPTION
            Get logged on users of a local or remote system.
        
        .PARAMETER ComputerName
            Hostname of a remote system.
        
        .PARAMETER Credential
            Credentials for remote system.
        
        .EXAMPLE
            PS C:\> Get-LoggedOnUser -ComputerName ComputerName -Credential (Get-Credential)
        
        .NOTES
            
    #>
    
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    
    Param
    (
        [Parameter(ValueFromPipeline = $true,
                   Position = 0)]
        [Alias('CN')]
        [System.String] $ComputerName = [System.Environment]::MachineName,
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty
    )
    
    Begin
    {
        Set-StrictMode -Version 'Latest'
        
        [Hashtable] $LogonType = [Ordered] @{
            "0" = "Local System";
            "2" = "Interactive";        # Local Logon
            "3" = "Network";            # Remote Logon
            "4" = "Batch";              # Scheduled Task
            "5" = "Service";            # Service Account Logon
            "7" = "Unlock";             # Screen Saver
            "8" = "NetworkCleartext";   # Cleartext Network Logon
            "9" = "NewCredentials";     # RunAs Alternate Credentials
            "10" = "RemoteInteractive"; # RDP \ TS \ RemoteAssistance
            "11" = "CachedInteractive"; # Local Cached Credentials
        }
        
        $LogonTypeFilter = 
        
        $CIMSessionParam = @{
            ComputerName = $ComputerName
            ErrorAction = "Stop"
        }
        
        If ($Credential.UserName)
        {
            $CIMSessionParam.Add("Credential", $Credential)
        }
    }
    
    Process
    {
        Try
        {
            $CimSession = New-CimSession @CIMSessionParam
        }
        Catch
        {
            Write-Warning "CimSession : Access is denied"
            Return $Null
        }
        
        If ($ComputerName)
        {
            $LogonSessions = Get-CimInstance -ClassName Win32_LogonSession -CimSession $CimSession
            $LogonUsers = Get-CimInstance -ClassName Win32_LoggedOnUser -CimSession $CimSession
        }
        Else
        {
            $LogonSessions = Get-CimInstance -ClassName Win32_LogonSession
            $LogonUsers = Get-CimInstance -ClassName Win32_LoggedOnUser
        }
        
        $SessionUser = @{ }
        
        ForEach ($LogonUser in $LogonUsers)
        {
            $UserName = $LogonUser.Antecedent |
            Select-Object @{
                Name = "UserName";
                Expression = { "$($_.Domain)\$($_.Name)" }
            }
            
            $SessionID = $LogonUser.Dependent.LogonId
            $SessionUser[$SessionID] = $UserName.UserName
        }
        
        ForEach ($Session in $LogonSessions)
        {
            [Array] $LoggedOnUsers += [PsCustomObject] @{
                'Session' = $Session.LogonId;
                'User' = $SessionUser[$Session.LogonId];
                'Type' = $LogonType[$Session.LogonType.toString()];
                'Auth' = $Session.AuthenticationPackage;
                'StartTime' = $Session.StartTime;
            }
        }
    }
    
    End
    {
        Return $LoggedOnUsers
    }
}
