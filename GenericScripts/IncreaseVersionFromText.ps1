
function IncreaseVersion($baseLineVersion){

    $versionArr = $baseLineVersion.split(".")
    $lastVersion = $versionArr[($versionArr.Length-1)]
    $lastVersion  = [int]$lastVersion + 1
    
    if ($versionArr.Length -le 1) {
        $final = $lastVersion
    }
    else {
        $arr = $versionArr[0..($versionArr.length - 2)]
        $final= "$($arr -join ".").$lastVersion"
        
    }
    
    return $final
}

write-host  (IncreaseVersion -baseLineVersion "3.1.89")
write-host  (IncreaseVersion -baseLineVersion "3")
write-host  (IncreaseVersion -baseLineVersion "3.8")
