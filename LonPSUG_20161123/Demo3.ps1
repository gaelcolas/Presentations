# Methods
$object3 | Add-member `
    -MemberType ScriptMethod `
    -Name MyMethod `
    -Value {
    param($input)
        Write-Host $input
        Write-Host $this.prop1
    }

$object3.MyMethod
#remember
$object3.Prop1
###

$object3.MyMethod("Thanks SapienTech for the Pizzas")

