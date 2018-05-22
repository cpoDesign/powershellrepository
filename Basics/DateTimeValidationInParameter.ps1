function Process{
    Param(
        [ValidatePattern("^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$")]    
        [Parameter(Mandatory = $false)]
        [string] $validDateTIme = $null
    )

    Write-Host $validDateTIme

}

Process

Process -validDateTIme "2013-05-09 12:13:14"

# will fail
Process -validDateTIme "2013-05-09"                                    
