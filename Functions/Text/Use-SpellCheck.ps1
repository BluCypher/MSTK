<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Use-SpellCheck.ps1
	 Created on:   	2016-09-17 22:04
	 Created by:   	Mike Sims
	 Changed on:   	2016-09-18
	 Changed by:   	Mike Sims
	 Version:     	1.1
	 History:      	1.0 - Initial Release
                    1.1 - Enabled Strict Mode
	===========================================================================
	.DESCRIPTION
		Use-SpellCheck Function
#>

Function Use-SpellCheck
{
    <#
        .SYNOPSIS
            Spell checks a text string
        
        .DESCRIPTION
            Use Microsoft cognitive services [Bing Spell Check] API request
            to spell check a text string
        
        .PARAMETER String
            The word or string to spell check.
        
        .PARAMETER ShowErrors
            Output [PSCustomObject] containing misspelled words and suggestions instead
            of an auto corrected [String].
        
        .PARAMETER RemoveSpecialChars
            Remove any non alphanumeric characters before spell checking.
        
        .PARAMETER SubscriptionKey
            The [Bing Spell Check] API subscription key used for spell check query.
        
        .EXAMPLE
            PS C:\> Use-SpellCheck -String 'Value1' -ShowErrors
        
        .OUTPUTS
            System.String
            System.Management.Automation.PSCustomObject
    
        .NOTES
            Bing Spell Check API Subscription Keys
            Account: MikeLSims@Live.com
            Key1: f5ea187faee74b7bac10144404aca9d3
            Key2: 8fd23960f7004571ba207aaad582c170
        
        .LINK
            https://www.microsoft.com/cognitive-services
            https://www.microsoft.com/cognitive-services/en-us/bing-spell-check-api
            https://www.microsoft.com/cognitive-services/en-US/subscriptions
    #>
    
    [CmdletBinding()]
    [OutputType([System.String])]
    
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
        [String] $String,
        [Switch] $ShowErrors,
        [Switch] $RemoveSpecialChars,
        [Parameter(DontShow = $True)]
        [Alias("Key")]
        [String] $SubscriptionKey = "f5ea187faee74b7bac10144404aca9d3"
    )
    
    Begin
    {
        Set-StrictMode -Version 'Latest'
    }
    
    Process
    {
        If ($RemoveSpecialChars)
        {
            $String = $String -Replace '[^A-z 0-9 /" "]', ''
        }
        
        Foreach ($SubString in $String)
        {
            $SplatInput = @{
                Uri = "https://api.cognitive.microsoft.com/bing/v5.0/spellcheck/?mode=proof"
                Method = 'Post'
            }
            
            $Headers = @{
                'Content-Type' = "application/x-www-form-urlencoded"
                'Ocp-Apim-Subscription-Key' = $SubscriptionKey
            }
            
            $Body = @{ 'text' = $SubString }
            
            Try
            {
                $SpellingErrors = (Invoke-RestMethod @SplatInput -Headers $Headers -Body $Body).FlaggedTokens
                
                $OutString = $String
                
                If ([Bool]($SpellingErrors))
                {
                    # Generate spell corrected string
                    Foreach ($SpellingError in $SpellingErrors)
                    {
                        If ($SpellingError.Type -eq 'UnknownToken')
                        {
                            $OutString = Foreach ($SubString in $SpellingError.Suggestions.Suggestion)
                            {
                                $OutString -Replace $SpellingError.Token, $SubString
                            }
                        }
                        Else # If REPEATED WORDS then replace the set by an instance of repetition
                        {
                            $OutString = $OutString -Replace "$($SpellingError.Token) $($SpellingError.Token) ", "$($SpellingError.Token) "
                        }
                    }
                    
                    If ($ShowErrors)
                    {
                        ForEach ($SpellingError in $SpellingErrors)
                        {
                            [Array] $OutErrors += [PsCustomObject] @{
                                'ErrorToken' = $SpellingError.Token;
                                'Suggestions' = $SpellingError.Suggestions.Suggestion;
                            }
                        }
                        
                        $SpellCheckOutput = $OutErrors
                    }
                    Else
                    {
                        $SpellCheckOutput = $OutString
                    }
                }
                Else
                {
                    $SpellCheckOutput = "No errors found in the String."
                }
            }
            Catch
            {
                $_.Exception.Response
                Return $_.Exception.Message
            }
        }
    }
    
    End
    {
        Return $SpellCheckOutput
    }
}

New-Alias -Name 'Spell' -Value 'Use-SpellCheck' -Description 'Spell Check' -Force
