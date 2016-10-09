<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Convert-FahrenheitToKelvin.ps1
	 Created on:   	10/1/2016 11:13 PM
	 Created by:   	Mike Sims
	 Changed on:   	10/1/2016
	 Changed by:   	Mike Sims
	 Version:     	1.0
	 History:      	
	===========================================================================
	.DESCRIPTION
		Convert-FahrenheitToKelvin Function
#>

Function Convert-FahrenheitToKelvin
{
    <#
        .SYNOPSIS
            Fahrenheit to Kelvin
            
        .DESCRIPTION
            Convert Fahrenheit to Kelvin
            
        .PARAMETER Fahrenheit
            Temperature in Fahrenheit.
            
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
        [Alias('F')]
        [System.Double]$Fahrenheit
    )
    
    Begin
    {
        Set-StrictMode -Version 'Latest'
    }
    
    Process
    {
        $Kelvin = [Math]::Round(((($Fahrenheit - 32) * 5 / 9) + 273.15), 4)
    }
    
    End
    {
        Return $Kelvin
    }
}

New-Alias -Name 'CFTK' -Value 'Convert-FahrenheitToKelvin' -Description 'Convert Fahrenheit to Kelvin' -Force
