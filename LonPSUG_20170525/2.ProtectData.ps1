# Import The ProtectedData module from Dave Wyatt
Import-Module ProtectedData

#Create a secure string password to encrypt (!Use Certificates in real life!)
$password = 'P@ss0rd' | ConvertTo-SecureString -AsPlainText -Force

#Create our object to Secure
$data = gc -raw '.\Books.xml'

#Encrypt Data
$securedData = Protect-Data -InputObject $data -Password $password

#This is how our Secure object looks like
$securedData | FL

#Serialize our SecureData object to XML (similar to Export-CliXml)
$xml = [System.Management.Automation.PSSerializer]::Serialize($securedData, 5)
#that xml representation of our secure object is a string
$xml.GetType().ToString()

#I could cast it to xml likeso
[xml]$xml

#lets Convert the xml string to Base 64
# first getting the bytes
$bytes = [System.Text.Encoding]::UTF8.GetBytes($xml)

# and encoding those to a Base54 string
$base64Data = [System.Convert]::ToBase64String($bytes)

#finally saving this to file
$base64Data | out-file EncryptedBooks.txt -Force

#Let's see this
Gc -Raw EncryptedBooks.txt
