# source: https://thehaseebahmed.medium.com/how-to-bulk-delete-keys-from-azure-app-configuration-4580a1ce834f

param (
    $Key = 'THIS WILL NOT MATCH WITH ANYTHING',
    $Subscription = '',
    $AppConfigName = ''
)

az account set -s $Subscription
Write-Host "Fetching all key-values..."
$configs = (az appconfig kv list -n $AppConfigName --all | ConvertFrom-Json)

Write-Host "Found $($configs.Length) configs, going to delete the following:"
$configsToDelete = New-Object System.Collections.Generic.List[System.Object]
For ($i=0; $i -lt $configs.Length; $i++) {
	$config = $configs[$i]
        if($config.key.contains($Key)){
            Write-Host "[$($config.label)] $($config.key)"
            $configsToDelete.add($config)
        }
}

Write-Host
Write-Host 'Press any key to delete or press Ctrl + C to cancel...'
Read-Host

For ($i=0; $i -lt $configsToDelete.Length; $i++) {
	$config = $configsToDelete[$i]
        if($config.key.contains($Key)){
            Write-Host "[$($config.label)] $($config.key)"
            az appconfig kv delete -n $AppConfigName --key $config.key --label $config.label
        }
}
