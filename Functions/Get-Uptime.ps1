<# 
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Get-Uptime.ps1
	 Created on:   	2016-09-14 18:46
	 Created by:   	Mike Sims
	 Changed on:   	2016-09-15
	 Changed by:   	Mike Sims
	 Version:     	1.2
	 History:      	1.0 - Initial Release - No known bugs
                    1.1 - Now creates CIM session and accepts alternative credentials
                    1.2 - Enabled Strict Mode
	===========================================================================
	.DESCRIPTION
		Get-UpTime Function
#>

Function Get-UpTime
{
    <#
        .SYNOPSIS
            Returns uptime information of a local or remote system.
        
        .DESCRIPTION
            Returns uptime information of a local or remote system.
        
        .PARAMETER ComputerName
            Hostname of a remote system.
        
        .PARAMETER Credential
            Credentials for remote system.
        
        .EXAMPLE
            PS C:\> Get-UpTime -ComputerName 'ComputerName'
        
        .EXAMPLE
            PS C:\> Get-UpTime -ComputerName 'ComputerName' -Credential (Get-Credential)
        
        .NOTES
            
    #>
    
    [CmdletBinding()]
    [OutputType([System.TimeSpan])]
    
    Param
    (
        [Parameter(ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true,
                   Position = 0)]
        [Alias('CN')]
        [System.String] $ComputerName = [System.Environment]::MachineName,
        [Alias('Cred')]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty
    )
    
    Begin
    {
        Set-StrictMode -Version 'Latest'
                
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
            $LastBootUptime = (Get-CimInstance -ClassName Win32_OperatingSystem -Property LastBootUptime -CimSession $CimSession).LastBootUptime
        }
        Else
        {
            $LastBootUptime = (Get-CimInstance -ClassName Win32_OperatingSystem -Property LastBootUptime).LastBootUptime
        }
        
        $TimeSpan = [System.DateTime]::Now - $LastBootUptime
        
        [Array] $UpTime += [PsCustomObject] @{
            'ComputerName' = $ComputerName;
            'LastBootUptime' = $LastBootUptime;
            'Days' = $TimeSpan.Days;
            'Hours' = $TimeSpan.Hours;
            'Minutes' = $TimeSpan.Minutes;
            'Seconds' = $TimeSpan.Seconds;
            'Milliseconds' = $TimeSpan.Milliseconds;
            'Ticks' = $TimeSpan.Ticks;
            'TotalDays' = $TimeSpan.TotalDays;
            'TotalHours' = $TimeSpan.TotalHours;
            'TotalMinutes' = $TimeSpan.TotalMinutes;
            'TotalSeconds' = $TimeSpan.TotalSeconds;
            'TotalMilliseconds' = $TimeSpan.TotalMilliseconds;
        }
    }
    
    End
    {
        Return $Uptime
    }
}

New-Alias -Name 'Uptime' -Value 'Get-UpTime' -Description 'Get uptime of local or remote system'
