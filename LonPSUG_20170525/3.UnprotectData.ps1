# Import The ProtectedData module from Dave Wyatt
Import-Module ProtectedData

#Create a secure string password to encrypt (!Use Certificates in real life!)
$password = 'P@ss0rd' | ConvertTo-SecureString -AsPlainText -Force

#load Base64 data from file
$base64Data = gc -Raw .\EncryptedBooks.txt

# Convert the Base64 to bytes
$bytes = [System.Convert]::FromBase64String($base64Data)

# Transform those bytes to String
$xml = [System.Text.Encoding]::UTF8.GetString($bytes)

#Get that string back to ProtectedObject
$obj = [System.Management.Automation.PSSerializer]::Deserialize($xml)

# finally decrypt that object
$DecryptedObject = Unprotect-Data -InputObject $obj -Password $password

#What do we have?
$DecryptedObject


