# More fun with Credential?

$credentialToSecure = (Get-Credential)

Import-Module ProtectedData
$password = 'P@ss0rd' | ConvertTo-SecureString -AsPlainText -Force
$securedCredObject = Protect-Data -InputObject $credentialToSecure -Password $password
$xml = [System.Management.Automation.PSSerializer]::Serialize($securedCredObject, 5)
$bytes = [System.Text.Encoding]::UTF8.GetBytes($xml)
$base64Data = [System.Convert]::ToBase64String($bytes)
$base64Data | out-file EncryptedCreds.txt -Force

# Lets decrypt
#Decrypt Data
$base64 = Gc -Raw EncryptedCreds.txt
$bytes = [System.Convert]::FromBase64String($base64)
$xml = [System.Text.Encoding]::UTF8.GetString($bytes)
$obj = [System.Management.Automation.PSSerializer]::Deserialize($xml)
$DecryptedCred = Unprotect-Data -InputObject $obj -Password $password

$DecryptedCred
$DecryptedCred.GetNetworkCredential().Password

