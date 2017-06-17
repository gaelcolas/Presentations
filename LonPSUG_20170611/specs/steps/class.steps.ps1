Class FileProvider {
    hidden $Path

    FileProvider ($Path)
    {
        $this.Path = Get-Item $Path
        
        $Result = Get-ChildItem $path | ForEach-Object {
            if($_.PSisContainer) {
                $val = [scriptblock]::Create("[FileProvider]::new(`"$($_.FullName)`")")
                $this | Add-Member -MemberType ScriptProperty -Name $_.BaseName -Value $val
            }
            else {
                $val = $_.FullName
                $this | Add-Member -MemberType ScriptProperty -Name $_.BaseName -Value $val
            }
        }
    }
}
