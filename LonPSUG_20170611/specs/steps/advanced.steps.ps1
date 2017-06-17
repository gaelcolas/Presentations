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