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
Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 -Recurse | Foreach-Object { . $_.FullName }

# Set Aliases
