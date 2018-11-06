$cert = New-SelfSignedCertificate -CertStoreLocation cert:\localmachine\my -dnsname dev.domain.com
$pwd = ConvertTo-SecureString -String ‘passw0rd!’ -Force -AsPlainText
$path = 'cert:\localMachine\my\' + $cert.thumbprint 

Export-PfxCertificate -cert $path -FilePath c:\projects\ps\dev-domain-com.pfx -Password $pwd
