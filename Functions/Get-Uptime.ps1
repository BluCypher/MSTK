<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Created on:   	2016-09-14 18:46
	 Created by:   	Mike Sims
	 Filename:     	Get-Uptime.ps1
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
			HostName of a remote computer.
		
		.EXAMPLE
			PS C:\> Get-UpTime -ComputerName 'ComputerName'
		
		.NOTES
			
	#>
	
	[CmdletBinding()]
	[OutputType([System.TimeSpan])]
	Param
	(
		[Parameter(ValueFromPipeline = $True,
				   ValueFromPipelineByPropertyName = $True,
				   Position = 0)]
		[Alias('CN')]
		[System.String] $ComputerName
	)
	
	Begin
	{
		
	}
	
	Process
	{
		If ($ComputerName)
		{
			$LastBootUptime = (Get-CimInstance -ComputerName $ComputerName -ClassName Win32_OperatingSystem -Property LastBootUptime).LastBootUptime
		}
		Else
		{
			$ComputerName = "LocalHost"
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
