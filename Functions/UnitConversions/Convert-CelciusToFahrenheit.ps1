<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Convert-CelciusToFahrenheit.ps1
	 Created on:   	10/1/2016 11:01 PM
	 Created by:   	Mike Sims
	 Changed on:   	10/1/2016
	 Changed by:   	Mike Sims
	 Version:     	1.0
	 History:      	
	===========================================================================
	.DESCRIPTION
		Convert-CelciusToFahrenheit Function
#>

Function Convert-CelciusToFahrenheit
{
    <#
        .SYNOPSIS
            Celcius to Fahrenheit
            
        .DESCRIPTION
            Convert Celcius to Fahrenheit
            
        .PARAMETER Celcius
            Temperature in Celcius.
            
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
        [Alias('C')]
        [System.Double] $Celcius
    )
    
    Begin
    {
        Set-StrictMode -Version 'Latest'
    }
    
    Process
    {
        $Fahrenheit = [Math]::Round((($Celcius * 1.8) + 32), 2)
    }
    
    End
    {
        Return $Fahrenheit
    }
}

New-Alias -Name 'CCTF' -Value 'Convert-CelciusToFahrenheit' -Description 'Convert Celcius to Fahrenheit' -Force
