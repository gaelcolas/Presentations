Given 'the Property mapping and splatting' {
<#
OBJECT Property  |  COMMAND Parameter
                 |
        A        |           A
        B        |           B
        C        |           C
                 |           D
                 |           E
#>

function mycmd {
    [cmdletBinding()]
    Param(
        [parameter(
            ValueFromPipelineByPropertyName
        )]
        [int]
        $a,

        [parameter(
             ValueFromPipelineByPropertyName
        )]
        $b,

        [parameter(
             ValueFromPipelineByPropertyName
        )]
        $c,

        $d,
        $e
    )
    $a,$b,$c,$d,$e -join ';'
}

try { @{a=1;b=2;c=3} | mycmd -ea Stop } catch {}

[PSCustomObject]@{a=1;b=2;c=3} | mycmd

{ mycmd @{a=1;b=2;c=3} -ea Stop  } | Should throw

$params = @{a=1;b=2;c=3}
mycmd @params

}


Given 'a process object with ETS' {
    # “What is PowerShell?” The PSObject layer and the Extended and Adapted Type Systems
    # are the heart of what make PowerShell what it is – a shell for all objects.
    # All objects comprise a) data and b) ways of interacting with and via that data
    # PowerShell wraps the underlying object in a PSObject.
    #https://blogs.msdn.microsoft.com/besidethepoint/2011/11/22/psobject-and-the-adapted-and-extended-type-systems-ats-and-ets/
    
    #Adapts attributes and methods from the underlying framework into first-class members 
    Get-WMIObject Win32_Process | Get-Member -View Base # Members of underlying .NET object only
    Get-WMIObject Win32_Process | Get-Member -View Adapted # Members of object as adapted by PowerShell

    #The first command returns a view of the members of the object as they would
    # appear in a .NET application. The second command returns a view of the members
    # exposed by default in PowerShell – an adapted view of the object.

}

Given 'the ETS-added properties' {
    
    #Based on type, PS auto-supplement the base .Net type
    get-process lsass | Gm CPU,Company,Path
    
    gwmi win32_process -Filter "name='lsass.exe'" | select CPU,Company,Path

}

Given 'the Extended type data' {
    #Types.ps1xml
    #Update-TypeData

    #Datetime example
    ((Get-Date) | gm datetime).definition
    (Get-Date).datetime

    code "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\DotNetTypes.format.ps1xml"
    #search DateTime

    #https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.core/about/about_types.ps1xml
    #Example: Adding an Age Member to FileInfo Objects
}

Given 'the formating of objects' {#
    #hashtable
    @{a=1;b=2;c=3;d=4}

    #Custom Object
    [PSCustomObject]@{a=1;b=2;c=3;d=4}

    [PSCustomObject]@{PSTypeName='System.String';a=1;b=2;c=3;d=4}

    ([PSCustomObject]@{PSTypeName='System.String';a=1;b=2;c=3;d=4}).GetType().ToString()

    [PSCustomObject]@{a=1;b=2;c=3;d=4}

    [PSCustomObject]@{a=1;b=2;c=3;d=4;e=5}


}

Given 'the module EZOut, we are covered' {
    Import-Module EZOut

    1..10 | % ([PSCustomObject]@{
        PSTypeName = 'PSUG.Awesomeness'
        id = [guid]::newGuid()
        name = 'say my name'
        int = 42
        animal = 'meerkat'
        status = 'pending'
        zonename = 'monster'
    })
    $typeName = 'PSUG.Awesomeness'
    Write-FormatView -TypeName $typeName -Property id,name,status,zonename | Out-FormatData | Out-file -FilePath ".\$typeName.Format.ps1xml" -Force
    Update-FormatData ".\$typeName.Format.ps1xml"

    1..10 | % ([PSCustomObject]@{
        PSTypeName = 'PSUG.Awesomeness'
        id = [guid]::newGuid()
        name = 'say my name'
        int = 42
        animal = 'meerkat'
        status = 'pending'
        zonename = 'monster'
    })
}

Given 'The other trick of PSTypeName' {
        
    function Test-Stuff {
        Param(
            [Parameter(
                ValueFromPipeline
            )]
            [PSTypeName('PSUG.Awesomeness')]
            $InputObject
        )
        process {
            $InputObject
        }
    }

    ([PSCustomObject]@{
        PSTypeName = 'PSUG.Awesomeness'
        id = [guid]::newGuid()
        name = 'say my name'
        int = 42
        animal = 'meerkat'
        status = 'pending'
        zonename = 'monster'
    }) | Test-Stuff

    ([PSCustomObject]@{
        PSTypeName = 'MONSTER'

        id = [guid]::newGuid()
        name = 'say my name'
        int = 42
        animal = 'meerkat'
        status = 'pending'
        zonename = 'monster'
    }) | Test-Stuff
    


    #oh, and it's a collection ([PSCustomObject]@{
        PSTypeName = 'MONSTER'

        id = [guid]::newGuid()
        name = 'say my name'
        int = 42
        animal = 'meerkat'
        status = 'pending'
        zonename = 'monster'
    }).PSObject.PSTypeNames
}