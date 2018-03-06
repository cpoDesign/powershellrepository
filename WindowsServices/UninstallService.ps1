
Param(
  [string ]$serviceName = "MyService"
)

(Get-WmiObject -Class win32_service) | Where-Object {$_.Name -like "*$serviceName*" } | ForEach-Object{
    $_.StopService();
    $_.Delete();
}
