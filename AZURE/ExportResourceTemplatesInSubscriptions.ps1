$myPath = 'C:\Azure\Subscriptions\'
$subscription = 'Subscription'
$basePath = $myPath + $subscription + '\'
$output = $basePath + 'output.txt'
$ErrorActionPreference="SilentlyContinue"
 
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path $output -append
 
Get-AzureRmSubscription -SubscriptionName $subscription | Select-AzureRmSubscription
 
$allresgroup = Get-AzureRmResourceGroup;
 
foreach ($rg in $allresgroup)
{
    $rsname = $rg.ResourceGroupName 
    $fullpath = $basePath+$rsname+'.json'
    Export-AzureRmResourceGroup -ResourceGroupName $rsname -Path $fullpath -IncludeComments
    
}
 
Stop-Transcript
