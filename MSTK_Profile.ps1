<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Created on:   	2016-09-14 17:18
	 Created by:   	Mike Sims
	 Filename:     	MSTK_Profile.ps1
	===========================================================================
	.DESCRIPTION
		
#>

Write-Host -Object "`n Loading Mike's ToolKit`n" -ForegroundColor Yellow

#region Variables
[Int32] $Global:LineNumber = 0
#endregion

#region Functions
# -> Bypass Execution Policy
Function Disable-ExecutionPolicy
{
	(
	$CTX = $ExecutionContext.GetType(
	).GetField(
	"_context", "nonpublic,instance"
	).GetValue(
	$ExecutionContext
	)
	).GetType(
	).GetField(
	"_authorizationManager", "nonpublic,instance"
	).SetValue(
	$CTX, (
	New-Object System.Management.Automation.AuthorizationManager "Microsoft.PowerShell"
	)
	)
}
#endregion

#region SessionPath
[Array]$SysPath = $Env:Path -Split ';'

$Folders = (Get-ChildItem $PSScriptRoot -Depth 1 -Directory | Where-Object { $_.Name -ne "Functions" }).FullName

ForEach ($Folder in $Folders)
{
	If ($SysPath -NotContains $Folder)
	{
		$Env:Path += ";$($Folder)"
	}
}
#endregion

#region Prompt
Function Prompt
{
	[System.Console]::ForegroundColor = 'Yellow'
	[System.Console]::Write(" [$("{0:D4}" -f ($Global:LineNumber))] ")
	[System.Console]::ForegroundColor = 'Green'
	[System.Console]::Write("$(([System.DateTime]::Now).ToString("s"))")
	[System.Console]::ForegroundColor = 'DarkGray'
	[System.Console]::Write(" $((Get-Location).Drive.Name):")
	[System.Console]::ForegroundColor = 'Gray'
	[System.Console]::Write(" $((Split-Path (Get-Location) -Leaf -Resolve).ToUpper()) ")
	[System.Console]::ResetColor()
	"PS> "
	
	$Global:LineNumber++
}
#endregion

#region Get Access Level
# Get Execution Policy
[String]$ExecutionPolicy = Get-ExecutionPolicy

# Get UAC Status
[Bool]$UACStatus = $False

[String]$RegistryKeyName = "Software\Microsoft\Windows\CurrentVersion\Policies\System"
[String]$RegistryKeyValue = "EnableLUA"

$RegistryHive = [Microsoft.Win32.RegistryHive]::LocalMachine
$RegistryView = [Microsoft.Win32.RegistryView]::Default
$RegistryKeyPermissionCheck = [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree

$RegistryKey = [Microsoft.Win32.RegistryKey]::OpenBaseKey($RegistryHive, $RegistryView)

try
{
	$RegistrySub = $RegistryKey.OpenSubKey($RegistryKeyName, $RegistryKeyPermissionCheck)
	$UACStatus = $RegistrySub.GetValue($RegistryKeyValue, 0)
}
catch [System.Management.Automation.MethodInvocationException]
{
	If ($_.FullyQualifiedErrorId -eq "SecurityException")
	{
		$UACStatus = $True
	}
}

# Get Security Level
$WindowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$WindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($WindowsIdentity)
[Bool]$IsAdmin = $WindowsPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
#endregion

#region Display Access Level
[System.Console]::Write(" UAC: ")

If ($UACStatus)
{
	[System.Console]::ForegroundColor = 'Green'
	[System.Console]::Write("Enabled")
}
Else
{
	[System.Console]::ForegroundColor = 'Red'
	[System.Console]::Write("Disabled")
}

[System.Console]::ResetColor()
[System.Console]::WriteLine()
[System.Console]::Write(" USR: ")

If ($IsAdmin)
{
	[System.Console]::ForegroundColor = 'Red'
	[System.Console]::Write("Administrator")
}
Else
{
	[System.Console]::ForegroundColor = 'Green'
	[System.Console]::Write("Standard")
}

[System.Console]::ResetColor()
[System.Console]::WriteLine()
[System.Console]::Write(" EXE: ")

Switch ($ExecutionPolicy)
{
	'Unrestricted' {
		[System.Console]::ForegroundColor = 'Yellow'
		[System.Console]::Write($ExecutionPolicy)
		Break
	}
	'Bypass' {
		[System.Console]::ForegroundColor = 'Red'
		[System.Console]::Write($ExecutionPolicy)
		Break
	}
	'AllSigned' {
		[System.Console]::ForegroundColor = 'Green'
		[System.Console]::Write($ExecutionPolicy)
		Break
	}
	'RemoteSigned' {
		[System.Console]::ForegroundColor = 'Green'
		[System.Console]::Write($ExecutionPolicy)
		Break
	}
	'Restricted' {
		[System.Console]::ForegroundColor = 'Green'
		[System.Console]::Write($ExecutionPolicy)
		Break
	}
	Default
	{
		[System.Console]::Write($ExecutionPolicy)
		Break
	}
}

[System.Console]::ResetColor()
[System.Console]::WriteLine("`n")
#endregion

Disable-ExecutionPolicy
