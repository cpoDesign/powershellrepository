#Uninstall all azure powershell modules

get-module azure* -list | uninstall-module
