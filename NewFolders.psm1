Write-Host "The Powershell module is loading" -ForegroundColor Green
Function Get-NewFolders {


$Paths = Get-Content "C:\Powershell Scripts\NewFolders.txt"
ForEach ($path in $Paths)
 {
     $newPath = Join-Path "C:\Test new folders" -ChildPath $path
     New-Item $newPath -type Directory
     }
 } 