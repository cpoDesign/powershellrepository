#based on source from:  https://techcommunity.microsoft.com/t5/Office-365/How-to-uploads-files-to-OneDrive-for-Business-using-Powershell/td-p/136332
$User = "testuser@domainname.com" 
$SiteURL = "https://test-my.sharepoint.com/personal/testuser_domainame_com";


$Folder = "C:\Users\Desktop\New folder"
#DocDocLibName is document libary name 
$DocLibName = "Documents"
$foldername = "Attachments"

#Add references to SharePoint client assemblies and authenticate to Office 365 site – required for CSOM
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"


$Password  = ConvertTo-SecureString ‘test1234’ -AsPlainText -Force


#Bind to site collection
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($User,$Password)


$Context.Credentials = $Creds

#Retrieve list
$List = $Context.Web.Lists.GetByTitle("$DocLibName")
$Context.Load($List)
$Context.Load($List.RootFolder)
$Context.ExecuteQuery()
$ServerRelativeUrlOfRootFolder = $List.RootFolder.ServerRelativeUrl
$uploadFolderUrl=  $ServerRelativeUrlOfRootFolder+"/"+$foldername




#Upload file
Foreach ($File in (dir $Folder -File))
{
$FileStream = New-Object IO.FileStream($File.FullName,[System.IO.FileMode]::Open)
$FileCreationInfo = New-Object Microsoft.SharePoint.Client.FileCreationInformation
$FileCreationInfo.Overwrite = $true
$FileCreationInfo.ContentStream = $FileStream
$FileCreationInfo.URL = $File
 if($foldername -eq $null)
  {
  $Upload = $List.RootFolder.Files.Add($FileCreationInfo)
  }
  Else
  {
   $targetFolder = $Context.Web.GetFolderByServerRelativeUrl($uploadFolderUrl)
   $Upload = $targetFolder.Files.Add($FileCreationInfo);
  }
#$Upload = $List.RootFolder.Files.Add($FileCreationInfo)
$Context.Load($Upload)
$Context.ExecuteQuery()
