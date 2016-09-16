<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Filename:     	Get-InstalledSoftware.ps1
	 Created on:   	2016-09-14 21:51
	 Created by:   	Mike Sims
	 Changed on:   	2016-09-15
	 Changed by:   	Mike Sims
	 Version:     	1.0
	 History:      	1.0 - Initial Release - No known bugs
	===========================================================================
	.DESCRIPTION
		Get-InstalledSoftware Function
#>

Function Get-InstalledSoftware
{
	<#
		.SYNOPSIS
			A brief description of the Get-InstalledSoftware function.
		
		.DESCRIPTION
			A detailed description of the Get-InstalledSoftware function.
		
		.PARAMETER ComputerName
			Target computer name
		
		.PARAMETER Credential
			Credentials for remote system
		
		.PARAMETER IncludeUsers
			Get user installed applications
		
		.EXAMPLE
			PS C:\> Get-InstalledSoftware -ComputerName 'ComputerName' -Credential (Get-Credential)
		
		.NOTES
			Additional information about the function.
	#>
	
	[CmdletBinding()]
	[OutputType([PsCustomObject])]
	
	Param
	(
		[Parameter(ValueFromPipeline = $True,
				   ValueFromPipelineByPropertyName = $True,
				   Position = 0)]
		[ValidateNotNullOrEmpty()]
		[Alias('CN')]
		[System.String] $ComputerName = [System.Environment]::MachineName,
		[Alias('Cred')]
		[System.Management.Automation.Credential()]
		$Credential = [System.Management.Automation.PSCredential]::Empty,
		[Alias('User')]
		[Switch] $IncludeUsers
	)
	
	Begin
	{
		Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
		
		Set-Variable -Name 'HKLM' -Value '2147483650' -Option Constant -Scope Local
		Set-Variable -Name 'HKU' -Value '2147483651' -Option Constant -Scope Local
		
		[Array] $SoftwareRootKeys = @(
			"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
			"SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
		)
		
		$ProgressParam = @{
			Activity = $MyInvocation.MyCommand
			Status = "Starting"
			CurrentOperation = ""
			PercentComplete = 0
		}
	}
	
	Process
	{
		Write-Verbose "Creating CIMSession to $ComputerName"
		
		$ProgressParam.CurrentOperation = "Creating CIMSession to $ComputerName"
		
		Write-Progress @ProgressParam
		
		$InstalledSoftware = @()
		
		Try
		{
			$CIMSessionParam = @{
				ComputerName = $ComputerName
				ErrorAction = "Stop"
			}
			
			If ($Credential.UserName)
			{
				$CIMSessionParam.Add("Credential", $Credential)
			}
			
			$ProgressParam.currentOperation = "Creating CIM session and class objects"
			Write-Progress @ProgressParam
			
			$CIMSession = New-CimSession @CIMSessionParam
			$CIMRegistry = Get-CimClass -Namespace root\default -Class StdRegProv -CimSession $CIMSession
			
		}
		Catch
		{
			Write-Warning "There was a problem creating a CIMSession to $ComputerName"
			Throw
		}
		
		Foreach ($SoftwareRootKey in $SoftwareRootKeys)
		{
			Write-Verbose "Querying $SoftwareRootKey"
			
			$ProgressParam.Status = "Querying $SoftwareRootKey"
			$ProgressParam.CurrentOperation = "EnumKey"
			
			Write-Progress @ProgressParam
			
			$CIMArgs = @{ hDefKey = $HKLM; sSubKeyName = $SoftwareRootKey }
			
			$CIMParam = @{
				cimclass = $CIMRegistry
				CimSession = $CIMSession
				Name = "EnumKey"
				Arguments = $CIMArgs
			}
			
			$SoftwareKeys = Invoke-CimMethod @CIMParam | Select-Object -ExpandProperty 'sNames' | Where-Object { $_ -NotMatch '(\.)?KB\d+' }
			
			$Int = 0
			
			$InstalledSoftware += ForEach ($SoftwareKey in $SoftwareKeys)
			{
				$Int++
				
				$ProgressParam.CurrentOperation = $_
				$ProgressParam.Status = "EnumValues $SoftwareRootKey"
				$PercentComplete = ($Int/$SoftwareKeys.count) * 100
				$ProgressParam.PercentComplete = $PercentComplete
				
				Write-Progress @ProgressParam
				
				$SoftwareKeyPath = "$SoftwareRootKey\$SoftwareKey"
				
				$CIMParam.Name = "EnumValues"
				$CIMParam.Arguments = @{ hDefKey = $HKLM; sSubKeyName = $SoftwareKeyPath }
				
				$SoftwareValues = Invoke-CimMethod @CIMParam
				
				ForEach ($SoftwareValue in $SoftwareValues)
				{
					$SoftwareHash = [Ordered] @{ Path = $SoftwareKeyPath }
					
					[Array] $Properties = @(
						"Displayname"
						"DisplayVersion"
						"Publisher"
						"InstallDate"
						"InstallLocation"
						"Comments"
						"UninstallString"
					)
					
					ForEach ($Property in $Properties)
					{
						$CIMParam.Name = "GetStringValue"
						$CIMParam.Arguments = @{ hDefKey = $HKLM; sSubKeyName = $SoftwareKeyPath; sValueName = $Property }
						$Value = Invoke-CimMethod @CIMParam
						$SoftwareHash.Add($Property, $($Value.sValue))
					}
					
					[PsCustomObject] $SoftwareHash
				}
			}
		}
		
		If ($IncludeUsers)
		{
			Write-Verbose "Getting data from HKEY_USERS"
			
			$ProgressParam.Status = "Getting data from HKEY_USERS"
			$ProgressParam.CurrentOperation = ""
			$ProgressParam.PercentComplete = 0
			
			Write-Progress @ProgressParam
			
			$CIMArgs = @{ hDefKey = $HKU; sSubKeyName = "" }
			
			$CIMParam = @{
				cimclass = $CIMRegistry
				CimSession = $CIMSession
				Name = "EnumKey"
				Arguments = $CIMArgs
			}
			
			$SoftwareKeys = Invoke-CimMethod @CIMParam | Select-Object -ExpandProperty sNames | Where-Object { $_ -notmatch "_Classes$" }
			
			$Int = 0
			
			$InstalledSoftware += ForEach ($SoftwareKey in $SoftwareKeys)
			{
				$Int++
				
				$PercentComplete = ($Int/$SoftwareKeys.count) * 100
				$ProgressParam.CurrentOperation = $SoftwareKey
				$ProgressParam.PercentComplete = $PercentComplete
				
				Write-Progress @ProgressParam
				
				$SoftwareRootKey = "$SoftwareKey\Software\Microsoft\Windows\CurrentVersion\Uninstall"
				
				Write-Verbose "Checking $SoftwareRootKey"
				
				$CIMParam.Arguments = @{ hDefKey = $HKU; sSubKeyName = $SoftwareRootKey }
				
				$UserSoftware = Invoke-CimMethod @CIMParam
				
				If ($UserSoftware.sNames)
				{
					$CIMParam.Arguments = @{ hDefKey = $HKU; sSubKeyName = $SoftwareRootKey }
					
					$SoftwareNames = Invoke-CimMethod @CIMParam
					
					If ($SoftwareNames.sNames)
					{
						Write-Verbose "Resolving $SoftwareKey"
						
						$WSManParamHash = @{
							resourceURI = "wmi/root/cimv2/Win32_SID?SID=$SoftwareKey"
							ComputerName = $CIMSession.ComputerName
							Credential = $Credential
						}
						
						$ResolveSID = Get-WSManInstance @WSManParamHash
						
						If ($ResolveSID.AccountName)
						{
							$Username = "$($ResolveSID.ReferencedDomainName)\$($ResolveSID.AccountName)"
						}
						Else
						{
							$Username = $SoftwareKey
						}
						
						ForEach ($SoftwareName in $SoftwareNames.sNames)
						{
							$SoftwareHash = [Ordered] @{ Username = $Username; Path = $SoftwareRootKey }
							
							Write-Verbose "Querying $SoftwareRootKey\$SoftwareName"
							
							[Array] $Properties = @(
								"Displayname"
								"DisplayVersion"
								"Publisher"
								"InstallDate"
								"InstallLocation"
								"Comments"
								"UninstallString"
							)
							
							ForEach ($Property in $Properties)
							{
								$CIMParam.Name = "GetStringValue"
								$CIMParam.Arguments = @{ hDefKey = $HKU; sSubKeyName = "$SoftwareRootKey\$SoftwareName"; sValueName = $Property }
								$Value = Invoke-CimMethod @CIMParam
								
								$SoftwareHash.Add($Property, $Value.sValue)
							}
							
							[PsCustomObject] $SoftwareHash
						}
					}
					
					Clear-Variable UserSoftware
				}
			}
		}
		
		$InstalledSoftware = $InstalledSoftware |
		Where-Object { $_.DisplayVersion } |
		Select-Object * -ExcludeProperty Path |
		Sort-Object Displayname
		
		Write-Verbose "Removing CIMSession"
		
		$ProgressParam.CurrentOperation = ""
		$ProgressParam.Status = "Removing CIMSession"
		
		Write-Progress @ProgressParam
		
		Remove-CimSession $CIMSession
	}
	
	End
	{
		$ProgressParam.Status = "Finished"
		
		Write-Progress @ProgressParam -Completed
		
		Write-Verbose -Message "Ending $($MyInvocation.Mycommand)"
		
		Return $InstalledSoftware
	}
}
