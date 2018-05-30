# Installs all fonts from given directory

[string] $FontDirectoryPath = $PSScriptRoot

$FONTS = 0x14;
$ObjShell = New-Object -ComObject Shell.Application;
$ObjFolder = $ObjShell.Namespace($FONTS);

$CopyOptions = 4 + 16;
$CopyFlag = [String]::Format("{0:x}", $CopyOptions);

foreach($File in $(Get-ChildItem -Path $FontDirectoryPath -Filter "*.ttf"))
{    
    If (Test-Path "c:\windows\fonts\$($File.name)")
    { 
        Write-Verbose "Font:$($File.name) already exists" -Verbose
    }
    Else
    {
        Write-Verbose "Installing Font:$($File.name)" -Verbose
        $CopyFlag = [String]::Format("{0:x}", $CopyOptions);
        $ObjFolder.CopyHere($File.fullname, $CopyOptions);

        New-ItemProperty -Name $File.fullname -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $File 
        Write-Verbose "Installation of the font:$($File.name) completed" -Verbose
    }
}
