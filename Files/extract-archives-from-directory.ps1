#Extract files from multiple zips

param(
$path = "C:\Temp\Archive\Source",
$destination = "C:\Temp\Archive\Target"
)

Remove-Item $destination -Force -Recurse

foreach($file in  get-childitem -path $path -recurse -filter "*.zip" ){
 $targetDir = Join-Path -Path $destination -childPath "$([System.IO.Path]::GetFileName($file.BaseName).ToString())"
 New-Item -ItemType Directory -Path $targetDir -Force
 Expand-Archive -path $file.FullName -DestinationPath "$targetDir" -Force -Verbose
}
