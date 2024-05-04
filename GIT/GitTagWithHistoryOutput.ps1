################################################################
# Creates a new tag if given and produces file with changes since last tag was created.
################################################################
# Support info for testing
# Adding historical tags: git tag -a 0.0.1 a59ad2a -m "adding historical tag"
# Created by CPO Design LTD
################################################################

[CmdletBinding(SupportsShouldProcess=$true)]
Param(
   [bool]$IncreaseMajor = $false,
   [bool]$IncreaseMinor = $true,
   [bool]$IncreasePatch = $false,
   [bool]$pushNewTag = $true,   
   # can be using file name or file name with path
   [string]$fileNameWithChangeHistory = "Release-notes.txt",
   [string]$currentVersionPrefix="V"
)


function GetCurrentTag{
    process{
        return $(git describe --tags --abbrev=0)
    }
}

$currentTagVersion = GetCurrentTag
$currentTagVersion  = $currentTagVersion.TrimStart($currentVersionPrefix)
Write-Host "Detected version: $currentTagVersion"

# test for having correct value
if ($currentTagVersion -and $currentTagVersion -eq ''){
    $currentTagVersion = "0.0.0"
    Write-Host "Failed to detect tag: $currentTagVersion"
}


[int]$Major, [int]$Minor, [int]$Patch  = $currentTagVersion.Split(".")

# bump version
    if ($IncreaseMajor) {
        $Major += 1;
    }

    if ($IncreaseMinor) {
        $Minor += 1;
    }

    if ($IncreasePatch) {
        $Patch += 1;
    }

$newTag = "${major}.${minor}.${patch}"
write-host $newTag

$listOfCommits = git log --pretty=format:"%h; author: %aN; date: %as; subject:%s%n`n" Head...$currentVersionPrefix$currentTagVersion

$listOfCommits |Out-File $fileNameWithChangeHistory


if ($pushNewTag -eq $true){
    Write-Host "Pushing a new tag: $newTag"
    New-Tag $newTag
    git push --tags
}
