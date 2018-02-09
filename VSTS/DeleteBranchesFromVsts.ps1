Param(
   [string]$user = "",
   [string]$token = "myAccessToken",
   [string]$repositoryId = "24ab111-1111-bbbb-cccc-dd185613c636",
   [string]$vstsProjectUrl = "https://cpodesign.visualstudio.com"
)

# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))

# construct url links
$uri = "$vstsProjectUrl/_apis/git/repositories/$repositoryId/refs/heads" #newone
$removeUrl = "$vstsProjectUrl/_apis/git/repositories/$repositoryId/refs?api-version=1.0"

# Invoke the REST call and capture the results
$results = Invoke-RestMethod -Uri $uri -Method Get -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

$myArray = @()

($results.value)|foreach{
# if we need filter    
# | where-object {$_.behindCount -gt 3000} 
 
if( $_.isLocked -ne "True" -and $_.name -notlike "*refs/heads/*master"){
    Write-Host "Removing branch: $($_.name)"
    
    $myObject = New-Object System.Object
    $myObject | Add-Member -type NoteProperty -name Name -Value $_.name
    $myObject | Add-Member -type NoteProperty -name newObjectId -Value "0000000000000000000000000000000000000000"
    $myObject | Add-Member -type NoteProperty -name oldObjectId -Value $_.objectId
    
    $myArray += $myObject
 }
}

Write-Host "Found {$($myArray.Length)} branches from total $($results.count) that will be removed"

If ($myArray.Length -gt 0){
    $body = ($myArray | ConvertTo-Json -Depth 10)
    
    #hack for one item as that is now represented as array when rendered. it works for 2 or more items
    if ($myArray -eq 1){
        $body = "[$body]"
    }

    Write-Host $body
    Invoke-RestMethod -Uri $removeUrl -Method Post -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Body $body
}
else{
    Write-Host "No branches match filter criteria"
}
