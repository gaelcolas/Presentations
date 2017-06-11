#requires -module startDemo

pushd $PSScriptRoot
. ..\kill.ps1
&"C:\Program Files\Docker\Docker\Docker for Windows.exe"
start-sleep 60
docker run --rm -d --name rabbitmq -p 5671:5671 -p 5672:5672 -p 15671:15671 -p 15672:15672 rabbitmq:3-management
Start-Demo ./Demo1_A.txt
Start-Demo ./demo2.txt