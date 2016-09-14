<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Created on:   	2016-09-14 18:46
	 Created by:   	MikeL
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

Function Get-DotNetInstalledVersion
{
	$DotNetVersion = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
	Get-ItemProperty -name Version, Release -EA 0 |
	Where { $_.PSChildName -match '^(?!S)\p{L}' } |
	Select PSChildName, Version, Release
	
	Return $DotNetVersion
}
