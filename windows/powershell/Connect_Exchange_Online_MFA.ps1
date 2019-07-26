#Download the One Click Powershell App via Internet Exploder because Microsoft
$IE=new-object -com internetexplorer.application
$IE.navigate2("https://cmdletpswmodule.blob.core.windows.net/exopsmodule/Microsoft.Online.CSE.PSModule.Client.application")
$IE.visible=$true

#Prompt for Exchange Online Admin
$EXOAdmin = Read-Host -Prompt 'Input the Exchange Online Username (IE:user@domain.com)'

#Connect to Exchange Online
$CreateEXOPSSession = (Get-ChildItem -Path $env:userprofile -Filter CreateExoPSSession.ps1 -Recurse -ErrorAction SilentlyContinue -Force | Select -Last 1).DirectoryName

. "$CreateEXOPSSession\CreateExoPSSession.ps1"

Connect-EXOPSSession -UserPrincipalName $EXOAdmin

#By Mahdi Hedhli | GoVanguard.com
#If this doesn't work for you try: https://www.powershellgallery.com/packages/Load-ExchangeMFA/1.1/Content/Load-ExchangeMFA.ps1
#Connect to Exchange Online with MFA: https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/connect-to-exchange-online-powershell/mfa-connect-to-exchange-online-powershell?view=exchange-ps
