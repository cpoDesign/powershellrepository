#Guide how to implement: https://docs.microsoft.com/en-us/azure/key-vault/key-vault-get-started

$subscriptionName = "MySubscription"
$location = 'West Europe'
$resourceGroupName = 'TestResourceGroup'
$TestValutName = 'TestingKeyValut'


$valut = Get-AzureRmKeyVault -VaultName $TestValutName

if ($valut -eq $null) {
    Set-AzureRmContext -SubscriptionName $subscriptionName
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
    New-AzureRmKeyVault -VaultName $TestValutName -ResourceGroupName $resourceGroupName -Location $location
}


$valutKey = 'Password'
$valutValue = 'Pa$$w0rd'

#Insert 
$encryptedValue = ConvertTo-SecureString $valutValue -AsPlainText -Force
$secret = Set-AzureKeyVaultSecret -VaultName $TestValutName -Name $valutKey -SecretValue $encryptedValue

#get the ID:

write-host "Secret id stored is: $($secret.Id)"

$secretValue = (get-azurekeyvaultsecret -vaultName $TestValutName -name $valutKey).SecretValueText

Write-Host "For key $($valutKey) expected value: $($valutValue) and retrieved was: $($secretValue)"
