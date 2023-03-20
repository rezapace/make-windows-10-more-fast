Get-ChildItem -Path "C:\Windows\Temp" *.* -Recurse | Remove-Item -Force -Recurse
Get-ChildItem -Path "C:\Users\R\AppData\Local\Temp" *.* -Recurse | Remove-Item -Force -Recurse
Get-ChildItem -Path "C:\Windows\Prefetch" *.* -Recurse | Remove-Item -Force -Recurse
Clear-RecycleBin -Force