<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Created on:   	2016-09-14 15:45
	 Created by:   	Mike Sims
	 Filename:     	MSTK.psm1
	-------------------------------------------------------------------------
	 Module Name: MSTK
	===========================================================================
#>

# Dot-Source all Function Files
Get-ChildItem -Path "$PSScriptRoot\Functions\*.ps1" -Recurse | Where-Object { $_.FullName -NotMatch "Legacy" } | Foreach-Object { . $_.FullName }

# Dot-Source Legacy Function Files
If ($PSVersionTable.PSVersion.ToString() -lt 5.1) # Load if ConsoleHost version is less than 5.1
{
    Get-ChildItem -Path "$PSScriptRoot\Functions\Legacy\*.ps1" -Recurse | Foreach-Object { . $_.FullName }
}
