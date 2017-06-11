if(!$PSScriptRoot) {
    pushd C:\src\Presentations\LonPSUG_20170323\
    $MyDir = $pwd.Path
} else {
    $MyDir = $PSScriptRoot
}

[class1] #fails
[class2] #fails

Import-Module $MyDir\module1

[class1] #fails
[class2] #fails

#oh yeah... I've read this!
Using module $MyDir\module1 

#But I'm sure.....
Test-Path $MyDir\module1

#Let's work around this...
[scriptblock]::Create(@"
    Using module $MyDir\module1
"@).Invoke()
    [class1]

#try again
[scriptblock]::Create(@"
    Using module $MyDir\module1
    [class1]
"@).Invoke()

# I got this!
[scriptblock]::Create(@"
    Using module $MyDir\module1
    [class1]
    [class2]
"@).Invoke()

#But Class2 is dot sourced in the PSM1, what's the .... difference?

#Lets try to copy it inside the PSM1 then.... and try the above again
##########


#What about that old SCOPE trick...
[scriptblock]::Create(@"
    Using module $MyDir\module1
    
"@) | Invoke-Expression
[class1]

#ok whatever...



#How to remove the Type from session?

#>>>> restart the Console/ISE.

