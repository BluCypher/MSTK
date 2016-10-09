<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Get-DotNetRuntimeVersion.ps1
	 Created on:   	2016-09-14 18:46
	 Created by:   	Mike Sims
	 Changed on:   	2016-09-15
	 Changed by:   	Mike Sims
	 Version:     	1.1
	 History:      	1.0 - Initial Release - No known bugs
                    1.1 - Enabled Strict Mode
	===========================================================================
	.DESCRIPTION
		Get-DotNetRuntimeVersion Function
#>

Function Get-DotNetRuntimeVersion
{
	<#
		.SYNOPSIS
			Returns .Net runtime version
		
		.DESCRIPTION
			Returns .Net runtime version for the current environment
		
		.NOTES
			
	#>
	
	[CmdletBinding()]
	[OutputType([System.Version])]
	Param ()
    
    Set-StrictMode -Version 'Latest'
    
	Return $PSVersionTable.CLRVersion
}
