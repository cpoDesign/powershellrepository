<# 
This script allows only modification of existing items, but does not allow adding newones
License: MIT
Author: pavel.svarc@cpodesign.com

Examples: 

UpdateJsonConfig.ps1 -templateParameters @{"ConnectionStrings"="myconnection1"; "ApplicationInsights.InstrumentationKey"="appInsightskey1"} -file "appsettings.Release.json" -outFile "appsettings.Release.json"
UpdateJsonConfig.ps1 -templateParameters @{"ConnectionStrings.DefaultConnection"="myconnection1"; "ApplicationInsights.InstrumentationKey"="appInsightskey1"} -file "appsettings.Release.json" -outFile "appsettings.Release.json"


#>
param(
  [parameter(Mandatory=$true)] $file,
  [parameter(Mandatory=$true)] $outFile,
  [parameter(Mandatory=$true)][hashtable] $templateParameters
)


# support function to set value for object
function SetValue($object, $key, $Value)
{
    $p1,$p2 = $key.Split(".")
    if($p2) { SetValue -object $object.$p1 -key $p2 -Value $Value }
    else { $object.$p1 = $Value }
}

try 
{
    $fileObj = Get-Content -Raw -Path $file | ConvertFrom-Json

    $params = $templateParameters.GetEnumerator() | ForEach-Object { 
  
        SetValue -object $fileObj -key $_.Key -Value $_.Value
    }

    $fileObj | ConvertTo-Json -Depth 100 | Out-File $outFile
}
catch
{
    Write-Output $Error[0].Exception
} 
