<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Get-DotNetInstalledVersion.ps1
	 Created on:   	2016-09-14 18:46
	 Created by:   	Mike Sims
	 Changed on:   	2016-09-15
	 Changed by:   	Mike Sims
	 Version:     	1.1
	 History:      	1.0 - Initial Release - No known bugs
                    1.1 - Enabled Strict Mode
	===========================================================================
	.DESCRIPTION
		Get-DotNetInstalledVersion Function
#>

Function Get-DotNetInstalledVersion
{
	<#
		.SYNOPSIS
			Returns Installed .Net Versions
		
		.DESCRIPTION
			Returns Installed .Net Versions
		
		.NOTES
			
	#>
	
	[CmdletBinding()]
	[OutputType([PsCustomObject])]
	Param ()
    
    Set-StrictMode -Version 'Latest'
    
	$DotNetVersion = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
	Get-ItemProperty -name Version, Release -EA 0 |
	Where-Object { $_.PSChildName -match '^(?!S)\p{L}' } |
	Select-Object PSChildName, Version, Release
	
	Return $DotNetVersion
}
