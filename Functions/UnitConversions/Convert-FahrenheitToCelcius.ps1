<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Convert-FahrenheitToCelcius.ps1
	 Created on:   	10/1/2016 10:48 PM
	 Created by:   	Mike Sims
	 Changed on:   	10/1/2016
	 Changed by:   	Mike Sims
	 Version:     	1.0
	 History:      	
	===========================================================================
	.DESCRIPTION
		Convert-FahrenheitToCelcius Function
#>

Function Convert-FahrenheitToCelcius
{
    <#
        .SYNOPSIS
            Fahrenheit to Celcius
            
        .DESCRIPTION
            Convert Fahrenheit to Celcius
            
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
        [System.Double] $Fahrenheit
    )
    
    Begin
    {
        Set-StrictMode -Version 'Latest'
    }
    
    Process
    {
        $Celcius = [Math]::Round((($Fahrenheit - 32) / 1.8), 2)
    }
    
    End
    {
        Return $Celcius
    }
}

New-Alias -Name 'CFTC' -Value 'Convert-FahrenheitToCelcius' -Description 'Convert Fahrenheit to Celcius' -Force
