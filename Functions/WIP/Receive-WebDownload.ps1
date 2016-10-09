<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Receive-WebDownload.ps1
	 Created on:   	10/2/2016 1:34 AM
	 Created by:   	Mike Sims
	 Changed on:   	10/2/2016
	 Changed by:   	Mike Sims
	 Version:     	1.0
	 History:      	
	===========================================================================
	.DESCRIPTION
		
#>

function Receive-WebDownload
{
<#
    .SYNOPSIS
        a
    
    .DESCRIPTION
        s
    
    .PARAMETER URI
        A description of the URI parameter.
    
    .PARAMETER Destination
        A description of the Destination parameter.
    
    .PARAMETER Header
        A description of the Header parameter.
    
    .PARAMETER URL
        A description of the URL parameter.
    
    .EXAMPLE
        PS C:\> Receive-WebDownload -URL $value1
    
    .NOTES
        Additional information about the function.
#>
    
    [CmdletBinding(ConfirmImpact = 'Low')]
    param
    (
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('URL')]
        [String]$URI,
        [Parameter(Mandatory = $true,
                   Position = 1)]
        [ValidateScript({ Test-Path (Split-Path $_ -Parent) })]
        [String]$Destination,
        [Parameter(Position = 2)]
        [Array[]]$AuthorizationHeader
    )
    
    Begin
    {
        Set-StrictMode -Version 'Latest'
        
        $WebClient = [System.Net.WebClient]::New()
        
        If ($Header)
        {
            ForEach ($Header in $AuthorizationHeader)
            {
                $WebClient.Headers.Add('Authorization', $Header)
            }
        }
    }
    
    Process
    {
        $WebClient.DownloadFile($URI, $Destination)
    }
    
    End
    {
        
    }
}
