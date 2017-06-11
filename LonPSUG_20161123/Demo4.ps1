# PSTypeNames
#remember
$object3.GetType().ToString()
$object3 | gm

### Lets add a typeName
$object3 | Add-Member `
        -TypeName MyType

$object3.GetType().ToString()
$object3 | gm

### Other New v3 way
$object4 = [PSCustomObject]@{
    PSTypeName = 'MyType'
    'prop1' = 'val1'
    'prop2' = 'val2'
    }

$object4

$object4 | gm
$object4.GetType().ToString()

$object4.PSTypeNames
