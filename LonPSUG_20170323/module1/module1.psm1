
Class Class1 {
    [string]$Property1 = 'Property1'
    [string]$Property2 = 'Property2'

    [string] Method1()
    {
        # Return behaves differently in classes
        Return $this.Property1
    }
}

Class Class11 : Class1 {

    [string] Method1()
    {
        Return $this.Property2
    }

}

#Dot sourcing another classes
. $PSScriptRoot\class2.ps1