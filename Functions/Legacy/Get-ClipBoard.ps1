<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Get-ClipBoard.ps1
	 Created on:   	2016-09-20 22:25
	 Created by:   	Mike Sims
	 Changed on:   	2016-09-20
	 Changed by:   	Mike Sims
	 Version:     	1.0
	 History:      	1.0 - Initial Release
	===========================================================================
	.DESCRIPTION
		Gets text from the system clipboard.
        Legacy function for pre PowerShell 5.1 systems.
#>

Function Get-ClipBoard
{
    <#
        .SYNOPSIS
            Gets text from the system clipboard.
        
        .DESCRIPTION
            Gets text from the system clipboard.
        
        .EXAMPLE
            PS C:\> Get-ClipBoard
        
        .NOTES
            Legacy function for pre PowerShell 5.1 systems.
    #>
    
    [CmdletBinding()]
    [OutputType([System.String])]
    
    Param ()
    
    Begin
    {
        Set-StrictMode -Version 'Latest'
        
        [Void] (& { [System.Reflection.Assembly]::LoadWithPartialName('PresentationCore') } *>&1)
    }
    
    Process
    {
        $Clipboard = [System.Windows.Clipboard]::GetText()
    }
    
    End
    {
        Return $Clipboard
    }
}
