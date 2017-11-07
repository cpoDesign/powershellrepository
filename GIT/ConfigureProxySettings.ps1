
function UnsetGitProxy(){
  git config --global --unset http.proxy
}

function SetGitProxy
{
    Param(
        [Parameter( Mandatory = $true)]
        [string] $proxyName    
    )
{
  git config --global http.proxy $proxyName
}
