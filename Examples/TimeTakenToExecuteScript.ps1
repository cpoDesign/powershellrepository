$startMs = (Get-Date).Millisecond
# your code here
$stopMs = (Get-Date).Millisecond
Write-Host "Script took $($stopMs - $startMs) milliseconds to run"
