<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Convert-KelvinToCelcius.ps1
	 Created on:   	10/1/2016 11:11 PM
	 Created by:   	Mike Sims
	 Changed on:   	10/1/2016
	 Changed by:   	Mike Sims
	 Version:     	1.0
	 History:      	
	===========================================================================
	.DESCRIPTION
		Convert-KelvinToCelcius Function
#>

Function Convert-KelvinToCelcius
{
    <#
        .SYNOPSIS
            Kelvin to Celcius
            
        .DESCRIPTION
            Convert Kelvin to Celcius
            
        .PARAMETER Kelvin
            Temperature in Kelvin.
            
        .NOTES
            
    #>
    
    [CmdletBinding(ConfirmImpact = 'None')]
    [OutputType([System.Double])]
    
    Param
    (
        [Parameter(
                   Mandatory = $True,
                   ValueFromPipeline = $True,
                   ValueFromPipelineByPropertyName = $True,
                   Position = 0
                   )
        ]
        [ValidateNotNullOrEmpty()]
        [Alias('K')]
        [System.Double]$Kelvin
    )
    
    Begin
    {
        Set-StrictMode -Version 'Latest'
    }
    
    Process
    {
        $Celcius = [Math]::Round(($Kelvin - 273.15), 2)
    }
    
    End
    {
        Return $Celcius
    }
}

New-Alias -Name 'CKTC' -Value 'Convert-KelvinToCelcius' -Description 'Convert Kelvin to Celcius' -Force
