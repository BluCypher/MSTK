<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Update-MSTK.ps1
	 Created on:   	9/25/2016 5:44 PM
	 Created by:   	Mike Sims
	 Changed on:   	9/25/2016
	 Changed by:   	Mike Sims
	 Version:     	1.1
	 History:      	1.0 - Initial Release - So known bugs!
                    1.1 - Bug Zapper Edition
     Repository:    git@github.com:BluCypher/MSTK.git
	===========================================================================
	.DESCRIPTION
		Update-MSTK Function
#>

Function Update-MSTK
{
    <#
        .SYNOPSIS
            Update MSTK module.
        
        .DESCRIPTION
            Update module from BluCypher\MSTK GitHub repository.
        
        .EXAMPLE
            PS C:\> Update-MSTK
        
        .NOTES
            Additional information about the function.
    #>
    
    [CmdletBinding()]
    
    Param (
        $Destination = (Get-Module -Name MSTK).ModuleBase.ToUpper(),
        $AccessToken = "2806fad5b7b3e9de9a74f19e25f1b37ccf7ea71b",
        $URI = "https://github.com/BluCypher/MSTK/archive/master.zip",
        $TempFolder = "$($Env:TEMP)\$([GUID]::NewGuid().Guid)",
        $TempFile = "$($Env:TEMP)\$(([System.DateTime]::Now).ToString("yyyyMMddhhmmss"))_$($MyInvocation.MyCommand.Name).zip"
    )
    
    Begin
    {
        [Void][Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem")
        
        $AccessTokenBase64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($AccessToken)"))
        
        $WebClient = [System.Net.WebClient]::New()
        $WebClient.Headers.Add('Authorization', 'Basic ' + $AccessTokenBase64)
    }
    
    Process
    {
        $WebClient.DownloadFile($URI, $TempFile)
        
        [System.IO.Compression.ZipFile]::ExtractToDirectory($TempFile, $TempFolder)
        
        If ([System.IO.Directory]::Exists($Destination))
        {
            [System.IO.Directory]::Delete($Destination, $True)
        }
        
        [Void] (& { [System.IO.Directory]::Delete("$TempFolder\MSTK-master\.git") } *>&1)
        [Void] (& { [System.IO.File]::Delete("$TempFolder\MSTK-master\.gitattributes") } *>&1)
        [Void] (& { [System.IO.File]::Delete("$TempFolder\MSTK-master\.gitignore") } *>&1)
        
        [System.IO.Directory]::Move("$TempFolder\MSTK-master", $Destination)
    }
    
    End
    {
        [Void] (& { [System.IO.File]::Delete($TempFile) } *>&1)
        [Void] (& { [System.IO.Directory]::Delete($TempFolder, $True) } *>&1)
    }
}

New-Alias -Name 'uMSTK' -Value 'Update-MSTK' -Description 'Update MSTK Module'
