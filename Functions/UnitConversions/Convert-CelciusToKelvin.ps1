<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Convert-CelciusToKelvin.ps1
	 Created on:   	10/1/2016 11:09 PM
	 Created by:   	Mike Sims
	 Changed on:   	10/1/2016
	 Changed by:   	Mike Sims
	 Version:     	1.0
	 History:      	
	===========================================================================
	.DESCRIPTION
		Convert-CelciusToKelvin Function
#>

Function Convert-CelciusToKelvin
{
    <#
        .SYNOPSIS
            Celcius to Kelvin
            
        .DESCRIPTION
            Convert Celcius to Kelvin
            
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
        [System.Double]$Celcius
    )
    
    Begin
    {
        Set-StrictMode -Version 'Latest'
    }
    
    Process
    {
        $Kelvin = [Math]::Round(($Celcius + 273.15), 4)
    }
    
    End
    {
        Return $Kelvin
    }
}

New-Alias -Name 'CCTK' -Value 'Convert-CelciusToKelvin' -Description 'Convert Celcius to Kelvin' -Force
