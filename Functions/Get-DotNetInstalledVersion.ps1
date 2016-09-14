<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Created on:   	2016-09-14 18:46
	 Created by:   	Mike Sims
	 Filename:     	Get-DotNetInstalledVersion.ps1
	===========================================================================
	.DESCRIPTION
		Get-DotNetInstalledVersion Function
#>

<#
	.SYNOPSIS
		Returns Installed .Net Versions
	
	.DESCRIPTION
		Returns Installed .Net Versions
	
	.NOTES
		
#>

Function Get-DotNetInstalledVersion
{
	[CmdletBinding()]
	[OutputType([PsCustomObject])]
	Param ()
	
	$DotNetVersion = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
	Get-ItemProperty -name Version, Release -EA 0 |
	Where-Object { $_.PSChildName -match '^(?!S)\p{L}' } |
	Select-Object PSChildName, Version, Release
	
	Return $DotNetVersion
}
