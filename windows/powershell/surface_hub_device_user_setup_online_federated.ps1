###Setup Surface Hub Account Script for Microsoft 365 AzureAD only account
###Using Online Deployment Device Account in an ADFS Federated Environment - https://docs.microsoft.com/en-gb/surface-hub/online-deployment-surface-hub-device-accounts
###Requires Available Office 365 E5 and Domestic Calling License
###For New Mailboxes, uncomment New-Mailbox under ###CREATE NEW USER
###AUTHOR Mahdi Hedhli - GoVanguard - 08-29-18###

###SETUP
Set-ExecutionPolicy RemoteSigned
$cred = Get-Credential
$credential=$cred
$org="YOURCOMPANY.onmicrosoft.com"
###CHANGE BELOW###
$rmalias="Room-NAME"
$rmname='Room - NAME (X seats)'
$newpass='C4angeM3!'
###CHANGE ABOVE###
$rm="$rmalias"
$rm+="@$org"
$easPolicy='SurfaceHubs'

###CREATE NEW USER | UNCOMMENT IF USER NOT CREATED PRIOR
#New-Mailbox -MicrosoftOnlineServicesID $rm -Alias $rmalias -Name $rmname -Room -EnableRoomMailboxAccount $true -RoomMailboxPassword (ConvertTo-SecureString -String $newpass -AsPlainText -Force)

###ASSIGN LICENSES & CONFIGURE PASSWORD EXPIRATION
#Install-Module AzureAD

Import-Module AzureAD

echo "If Import-Module AzureAD fails, relaunch elevated Powershell and uncomment Install-Module AzureAD"

Connect-AzureAD

Set-AzureADUser -ObjectId $rm -UsageLocation "US" -PasswordPolicies "DisablePasswordExpiration"

Get-AzureADSubscribedSku | Select Sku*,*Units

$E5License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$DCLicense = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense

$E5License.SkuId = "0dab259f-bf13-4952-b7f8-7db8f131b28d"
$DCLicense.SkuId = "c7df2760-2c81-4ef7-b578-5b5392b571df"

$AssignedLicenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$AssignedLicenses.AddLicenses = $E5License,$DCLicense
$AssignedLicenses.RemoveLicenses = @()

Set-AzureADUserLicense -ObjectId $rm  -AssignedLicenses $AssignedLicenses

#CONFIGURE EXCHANGE ONLINE
Connect-EXOPSSession
Set-CASMailbox $rm -ActiveSyncMailboxPolicy $easPolicy
Set-Mailbox -Identity $rm -type Room -EnableRoomMailboxAccount $true -RoomMailboxPassword (ConvertTo-SecureString $newpass -AsPlainText -Force)
#Set-CASMailbox $rm -ActiveSyncMailboxPolicy $easPolicy
Set-CalendarProcessing -Identity $rm -AutomateProcessing AutoAccept -AddOrganizerToSubject $false -AllowConflicts $false -DeleteComments $false -RemovePrivateProperty $false
Set-CalendarProcessing -Identity $rm -AddAdditionalResponse $true -AdditionalResponse "This is a Surface Hub Meeting room!"


#CONFIGURE SKYPE FOR BUSINESS ONLINE
Import-Module "C:\\Program Files\\Common Files\\Skype for Business Online\\Modules\\SkypeOnlineConnector\\SkypeOnlineConnector.psd1"
$cssess=New-CsOnlineSession
Import-PSSession $cssess -AllowClobber
$strRegistrarPool = (Get-CsTenant).RegistrarPool
#$strRegistrarPool = (Get-CsTenant).TenantPoolExstension
#$strRegistrarPool = $strRegistrarPool[0].Substring($strRegistrarPool[0].IndexOf(':') + 1)
Enable-CsMeetingRoom -Identity $rm -RegistrarPool $strRegistrarPool -SipAddressType EmailAddress
#Enable-CsMeetingRoom -Identity $rm -RegistrarPool $strRegistrarPool -SipAddressType UserPrincipalName

echo "Now Setup the Skype For Business Online Phone Number"


### NOTES
### Office365 SKUs
### 0dab259f-bf13-4952-b7f8-7db8f131b28d MCOPSTN1                           8 class LicenseUnitsDetail
### c7df2760-2c81-4ef7-b578-5b5392b571df ENTERPRISEPREMIUM                  4 class LicenseUnitsDetail