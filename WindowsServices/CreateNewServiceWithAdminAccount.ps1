function CreateNewService()
{
   Param(
        $serviceName ='MyService',
        $serviceExePath = "c:\servicebinaries\MyService.exe"
    )

    $secpasswd = ConvertTo-SecureString "MyPassword" -AsPlainText -Force
    $mycreds = New-Object System.Management.Automation.PSCredential (".\LocalAdmin", $secpasswd)
    
    New-Service -name $serviceName -binaryPathName $serviceExePath -displayName $serviceName -startupType Automatic -credential $mycreds
}
