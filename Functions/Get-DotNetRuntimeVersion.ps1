<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Created on:   	2016-09-14 18:46
	 Created by:   	Mike Sims
	 Filename:     	Get-DotNetRuntimeVersion.ps1
	===========================================================================
	.DESCRIPTION
		Get-DotNetRuntimeVersion Function
#>

<#
	.SYNOPSIS
		Returns .Net runtime version
	
	.DESCRIPTION
		Returns .Net runtime version for the current environment
	
	.NOTES
		
#>

Function Get-DotNetRuntimeVersion
{
	[CmdletBinding()]
	[OutputType([System.Version])]
	Param ()
	
	Return $PSVersionTable.CLRVersion
}
