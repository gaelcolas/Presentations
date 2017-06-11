# Objects through pipelines and functions

Function Get-Rectangle {
    [CmdletBinding()]
    Param(
    [parameter(ValueFromPipelineByPropertyName=$true)]
    $x,
    [parameter(ValueFromPipelineByPropertyName=$true)] 
    $y,
    [parameter(ValueFromPipelineByPropertyName=$true)] 
    $width,
    [parameter(ValueFromPipelineByPropertyName=$true)] 
    $height
    )
    process {
        Write-host "### My x = $x"
        Write-host "### My y = $y"
        Write-host "### My Width = $width"
        Write-Host "### My height = $height`r`n"
        [System.Drawing.Rectangle]::new($x,$y,$width,$height)
    }
}
#break

$rectangle = New-object System.Drawing.Rectangle `
    -argumentlist 0,0,10,10

$rectangle | Get-Rectangle

[PSCustomObject]@{
    'x' = 0
    'y' = 0
    'width' = 33
    'height' = 44
} | Get-Rectangle

