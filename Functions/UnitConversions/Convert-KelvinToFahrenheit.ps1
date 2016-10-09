<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Convert-KelvinToFahrenheit.ps1
	 Created on:   	10/1/2016 11:16 PM
	 Created by:   	Mike Sims
	 Changed on:   	10/1/2016
	 Changed by:   	Mike Sims
	 Version:     	1.0
	 History:      	
	===========================================================================
	.DESCRIPTION
		Convert-KelvinToFahrenheit Function
#>

Function Convert-KelvinToFahrenheit
{
    <#
        .SYNOPSIS
            Kelvin to Fahrenheit
            
        .DESCRIPTION
            Convert Kelvin to Fahrenheit
            
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
        $Fahrenheit = [Math]::Round(((($Kelvin - 273.15) * 1.8000) + 32), 2)
    }
    
    End
    {
        Return $Fahrenheit
    }
}

New-Alias -Name 'CKTF' -Value 'Convert-KelvinToFahrenheit' -Description 'Convert Kelvin to Fahrenheit' -Force
