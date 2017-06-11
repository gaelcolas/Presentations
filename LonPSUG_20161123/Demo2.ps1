####### PSCustomObject v3

$object2 = New-Object PSCustomObject
$object2 | gm

#PS v3
$object3 = [PSCustomObject]@{
    'Prop1' = 'Value1'
    'Prop2' = 2
    'prop3' = [PSCustomObject]@{
        'b' = 'val1'
        'a' = 'val2'
    }
}

$object3
$object3.prop3

#remember
$object11
