Given 'we have CIM and WMI Objects' {
    Get-CimInstance -ClassName Win32_ComputerSystem | gm

    #TypeName: Microsoft.Management.Infrastructure.CimInstance#root/cimv2/Win32_ComputerSystem
    #https://msdn.microsoft.com/en-us/library/microsoft.management.infrastructure.ciminstance(v=vs.85).aspx
    #https://blogs.msdn.microsoft.com/powershell/2012/08/24/introduction-to-cim-cmdlets/
    <#
        CIM: Common Information Model (CIM) is the DMTF standard [DSP0004] for describing the structure and behavior of managed resources such as storage, network, or software components.

        WMI: Windows Management Instrumentation (WMI) is a CIM server that implements the CIM standard on Windows.

        WS-Man: WS-Management (WS-Man) protocol is a SOAP-based, firewall-friendly protocol for management clients to communicate with CIM servers.

        WinRM: Windows Remote Management (WinRM) is the Microsoft implementation of the WS-Man protocol on Windows.
    #>
}

Given 'we have Net objects' {
    $R1 = [drawing.rectangle]::new(3,2,0,0)
    $R1.getType().ToString()
    #System.Drawing.Rectangle

    $R2 = New-Object -TypeName drawing.rectangle -ArgumentList 3,2,0,0

    $R1 -eq $R2
    $R2.X = 4
    $R1 -eq $R2

    #######################
    # and PowerShell objects are stil .Net objects

    ([PSCustomObject]@{}).getType().ToString()
    #System.Management.Automation.PSCustomObject

    #but
    [PSCustomObject]@{a=1} -eq [PSCustomObject]@{a=1}

    diff ([PSCustomObject]@{a=1;b=2})  ([PSCustomObject]@{a=1;b=2}) -property a,b -includeEqual
    #or
    diff ([PSCustomObject]@{a=1;b=2})  ([PSCustomObject]@{a=1;b=5}) -property ([PSCustomObject]@{a=1;b=2}).PSObject.properties.name -includeEqual
    
}

Given 'we have other type of objects' {
    #https://msdn.microsoft.com/en-us/powershell/scripting/getting-started/cookbooks/creating-.net-and-com-objects--new-object-
    $WshShell = New-Object -ComObject WScript.Shell
    $WshShell | gm
}




###### OOP


Given 'we have Classes in CS or PS' {
#https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.utility/add-type
$Source = @"
namespace psug {
    public class Person {
        public Person(string firstName, string lastName)
        {
            FirstName = firstName;
            LastName = lastName;
        }

        public string FirstName { get; set; }
        public string LastName { get; set; }
    }
}
"@
try {
    Add-Type -TypeDefinition $source -Language CSharp -EA stop
} catch {'Will throw if type exists already in session'}

$objNet = [psug.Person]::new('bar','fu')
$objNet | gm
#TypeName: psug.Person

#PSv5 class
Class PSPerson {
    [string]$firstName
    [string]$Lastname
    PSPerson ([string]$firstName,[String]$Lastname){
        $this.firstName = $firstName
        $this.lastName = $Lastname
    }
}

$objPS = [psperson]::new('bar','fu')
$objPS | gm
#TypeName: PSPerson

# CS convenient to call unmanaged APIs, like Win32 API (P/Invoke)
#http://www.leeholmes.com/blog/2009/01/19/powershell-pinvoke-walkthrough/
#http://pinvoke.net/

}

Given 'objects are instantiations of Class' {
    #the PSv5 class
    Class Blah {
        [string]$Property
        Blah() {
            #default constructor
            $this.Property = 'value of property'
        }
    }

    #the Type blah
    [blah].GetType().ToString()

    #The instance of class Blah gives an object
    $obj = [blah]::new()

    #the variable named obj 'stores' the value (the instance)
    get-variable Obj

    #the variable actually reference the instance
    $obj = $null
    # de-referencing (completely) the object will 'destroy' it (dispose)
    # the .Net Garbage Collector will clear it up when it'll feel like it
    # or you can 'force it'
    [System.GC]::Collect()

    #lets see
    
    $g1 = [guid]::NewGuid()
    $g1

    $g2 = $g1

    $g1 = $null

    $g2
    remove-variable g2
}


Given 'we have Type and Type Accelerators' {
    #https://blogs.technet.microsoft.com/heyscriptingguy/2013/07/08/use-powershell-to-find-powershell-type-accelerators/

    #Type accelerator is an alias for a dotnet type
    [PSCustomObject] -eq [System.Management.Automation.PSCustomObject]
    # $false
    [psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::get['pscustomobject'].ToString()
    #System.Management.Automation.PSObject
    [pscustomobject] -eq [System.Management.Automation.PSObject]
    # $true

    { [System.Management.Automation.PSCustomObject]@{a=1} } | Should throw
    # Error

    [System.Management.Automation.PSObject]@{a=1}
    # works

    #Another type accelerator: [adsi]
    [psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::get['adsi'].ToString()

    # System.Management.Automation.PSCustomObject is an implementation detail
    # https://stackoverflow.com/questions/35894272/powershell-type-accelerators-psobject-vs-pscustomobject
}

###### Members

Given 'an instance of an object' {
    $obj = Get-Process | Select -first 1

    #lets display in the console
    $obj

    #What does that do?
    $obj | Out-Default

    #Let's see what it's got
    $obj | Format-List -property *
    
}

Given 'its different members' {
    $obj = Get-Process | Select -first 1

    #what are those?
    $obj | Get-Member

    #sooo
    $obj | Get-Member | Select -expandProperty MemberType | select -unique
    # AliasProperty
    # Event
    # Method
    # NoteProperty
    # Property
    # PropertySet
    # ScriptProperty
}

Given 'You can create your own object in PS' {

    #The old, slow, and unreadable way
    $obj = New-Object PSobject
    $obj | Add-Member -memberType NoteProperty -name a -value 1

    # Display that object
    $obj

    #Chain those with PassThru

    $obj2 = $obj | Add-Member -memberType NoteProperty -name b -value 2 -passThru |
                   Add-Member -memberType NoteProperty -name c -value 3 -passThru

    # or the beauty
    $obj = [PSCustomObject]@{
        a = 1
        b = 2
        c = 3
    }

    $obj

    #or with a class
    Class Obj {
        $a
        $b
        $c
        Obj () {
            $this.a = 1
            $this.b = 2
            $this.c = 3
        }
    }

    $objClass = [Obj]::New()

    #Spot the difference
    $objClass | gm
    $obj | gm

    #property vs NoteProperty
}