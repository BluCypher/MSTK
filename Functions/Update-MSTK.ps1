<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Update-MSTK.ps1
	 Created on:   	9/25/2016 5:44 PM
	 Created by:   	Mike Sims
	 Changed on:   	9/25/2016
	 Changed by:   	Mike Sims
	 Version:     	1.0
	 History:      	
     Repository:    git@github.com:BluCypher/MSTK.git
	===========================================================================
	.DESCRIPTION
		
#>

$OneTimePassword = 672858
Invoke-WebRequest -Uri 'https://github.com/BluCypher/MSTK/archive/master.zip' -Headers @{
    "Authorization" = "Basic $BasicCreds"; "X-Github-OTP" = $OneTimePassword
} -OutFile .\MSTK.zip

Expand-Archive -Path C:\Temp\githubDL\MSTK.zip -DestinationPath C:\Temp\githubDL\MSTK
