Describe 'Basic Object Concepts' {
    It 'Should create a .Net object of rectangle' {
        $rectangle = $( [drawing.rectangle]::new(4,4,4,4) )
        $rectangle | Should BeOfType [Drawing.rectangle]
    }


    It 'Creates a WScript.Shell COM object' {
        $WshShell = New-Object -ComObject WScript.Shell
        $WshShell.GetType().Name | Should Be '__ComObject'
    }

    It 'Creates a C# Class halfDay in namespace PSUG with a property difficulty of type string settable in ctor' {
        #Write your code here
        $src = @"
        namespace psug {
            public class halfDay {
            public halfDay(string difficulty)
            {
                Difficulty = difficulty;
            }

            public string Difficulty { get; set; }
            }
        }
"@
        try {
            Add-Type -TypeDefinition $src -Language CSharp -EA stop
        } catch {'Will throw if type exists already in session'}
        
        { [psug.halfDay]::new('300') } | Should not Throw
    }

    It 'Creates a PSv5 Class Dog with a property size of type int' {
        Class Dog {
            [int]$size
            Dog ($size) {
                $this.size = $size
            }
        }

        {[Dog]::new(4)} | Should Not throw
        [Dog]::new(6).size | should be 6
    }

    It 'Gives the matching type accelerator for PSObject' {
        #change the typename value here
        $TypeName = '[PSCustomObject]'
        
        ([scriptblock]::create($TypeName).Invoke()[0] ).ToString() | Should be 'System.Management.Automation.PSObject'
        $TypeName | Should not be '[PSobject]'
    }

    It 'List the type of properties from a process object' {
         $obj = Get-Process | Select -first 1
         $listProperties = @('Property','...')
         $listProperties = @('AliasProperty','Event','Method','NoteProperty','Property','PropertySet','ScriptProperty')
         diff ($obj | Get-Member | Select -expandProperty MemberType | select -unique) $listProperties | should beNullOrEmpty
    }

    It 'Creates a CustomObject with property a = 1, b = 2, c = 3' {
        $object = ([PSCustomObject]@{a=1;b=2;c=3})
        $object.a | should be 1
        $object.b | should be 2
        $object.c | should be 3
    }
}
