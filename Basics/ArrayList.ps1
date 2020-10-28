# define array of items
$arr = New-Object System.Collections.ArrayList
$arr+= @{ name = 'Fred';Value = 36; }
$arr+= @{ name = 'Joe'; Value = 32; }

# loop through array
for ($i=0; $i -lt $arr.length; $i++) {
	$arr[$i]['name']
}


#alternative way

$allRecords = @()
$allRecords+=([pscustomobject]@{Name='function1';Url='https://function1'})
$allRecords+=([pscustomobject]@{Name='function2';Url='https://function2'})

#access properties using foreach
foreach( $row in $allRecords ){

	Write-Host $row.Name
}

# list items
$allRecords | Format-List
