# define array of items
$arr = New-Object System.Collections.ArrayList
$arr+= @{ name = 'Fred';Value = 36; }
$arr+= @{ name = 'Joe'; Value = 32; }

# loop through array
for ($i=0; $i -lt $arr.length; $i++) {
	$arr[$i]['name']
}
