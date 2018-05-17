$FileName =''
$OldLine = ''
$NewLine = ''
$Drives = Get-PSDrive -PSProvider FileSystem
foreach ($Drive in $Drives) {
    Push-Location $Drive.Root
        Get-ChildItem -Filter "$FileName" -Recurse | ForEach { 
            (Get-Content $_.FullName).Replace($OldLine, $NewLine) | Out-File $_.FullName
        }
    Pop-Location
}
