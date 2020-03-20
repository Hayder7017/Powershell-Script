Write-Host "The Powershell module is loading" -ForegroundColor Green
Function Get-FSRMfileScreenhayals {


$Paths = Get-Content "\\hayals-file01\ReadOnly\NetworkFolders.txt"
ForEach ($path in $Paths)
 {
     New-FSRMfileScreen $path -Template "Block Audio and Video Files" 
     }
 }