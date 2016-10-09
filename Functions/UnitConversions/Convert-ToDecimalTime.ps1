<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Convert-ToDecimalTime.ps1
	 Created on:   	10/4/2016 9:43 PM
	 Created by:   	Mike Sims
	 Changed on:   	10/4/2016
	 Changed by:   	Mike Sims
	 Version:     	1.0
	 History:      	
	===========================================================================
	.DESCRIPTION
		Convert-ToDecimalTime Function
#>

Function Convert-ToDecimalTime
{
    <#
        .SYNOPSIS
            Convert Timespan to Decimal Time
        
        .DESCRIPTION
            Convert Minutes, Hours, and Days to Decimal Hours
        
        .PARAMETER Minutes
            Duration Minutes.
        
        .PARAMETER Hours
            Duration Hours.
        
        .PARAMETER Days
            Duration Days.
        
        .NOTES
            
    #>
    
    [CmdletBinding(ConfirmImpact = 'None')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    
    Param
    (
        [Parameter(Position = 0)]
        [Alias("M")]
        [Int] $Minutes = 0,
        [Parameter(Position = 1)]
        [Alias("H")]
        [Int] $Hours = 0,
        [Parameter(Position = 2)]
        [Alias("D")]
        [Int] $Days = 0
    )
    
    Begin
    {
        Set-StrictMode -Version 'Latest'
    }
    
    Process
    {
        $DecimalTime = [Math]::Round((New-TimeSpan -Days $Days -Hours $Hours -Minutes $Minutes).TotalHours, 2)
        
        Set-Clipboard -Value $DecimalTime
        
        $Output = [PSCustomObject] @{ 'DecimalTime' = $DecimalTime }
    }
    
    End
    {
        Return $Output
    }
}

Set-Alias -Name dT -Value "Convert-ToDecimalTime" -Description "Convert Minutes, Hours, and Days to Decimal Hours."
