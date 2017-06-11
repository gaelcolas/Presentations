#PowerShell Objects and Properties

$null | Get-Member

$text = "This is what you see"
$text | Get-member

#######

$object1 = New-Object PSObject
$object1 | Get-Member
[PSObject]@{'a'='b'}

########
$object1 | Add-member `
    -MemberType NoteProperty `
    -Name Prop1 `
    -Value 'Value1' `
    -PassThru |
    Add-member `
    -MemberType NoteProperty `
    -Name Prop2 `
    -Value 2

$object1 | gm

#other way to add properties:
$object11 = New-Object PSObject `
   -Property @{
        'b'='val1'
        'a' = 'val2' }

$object11 | FL
$object11 | gm

##Accessing properties
$object1.Prop1
## Property Type
$object1.Prop1 | gm