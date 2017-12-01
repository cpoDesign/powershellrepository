PARAM(
  [string] $dropPath  = "C:\Temp\",
  [string] $directoryName = "testing"
)

$myArray = @()

Get-ChildItem -Path $dropPath  -Recurse -Directory | %{   
     if ($_.FullName.ToLower().EndsWith($directoryName))
     {
         $myArray += "$($_.FullName)"
     }  
}

# sort to the higher path first
$myArray| sort { $_.value.length }  | select -expand value -first 1

foreach ($item in $myArray) {
    if ((Test-Path -Path $item )  -eq $true)
    {
        Remove-Item -Path  $item -Force -Recurse
        Write-Host "rm $($item)"
    }
}
