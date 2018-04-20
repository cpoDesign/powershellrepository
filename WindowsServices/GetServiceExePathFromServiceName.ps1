function GetServiceExePathFromServiceName{
    Param(
    [string] $service
    )

    $serviceObj = gwmi -class Win32_Service | ? {$_.Name -eq $service} 
    $path = ($serviceObj | Select -Expand PathName) -replace "(.+exe).*", '$1'
    return $path
}
