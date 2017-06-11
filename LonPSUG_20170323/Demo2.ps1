#Demo2

#work around for modules...

# add the below to the psd1
# ScriptsToProcess = @('.\class2.ps1')

Import-Module C:\src\Presentations\LonPSUG_20170323\module1 -Force

[Class2]

#But obviously, it won't work for class1, unless you had it from before
[Class1]