<#
source from: https://www.yobyot.com/aws/how-to-manage-windows-ebs-volume-snapshots-with-powershell/2015/05/18/

Copyright 2015 Air11 Technology LLC
 
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
 
    http://www.apache.org/licenses/LICENSE-2.0
 
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. #>
 
 
<# Create snapshots of production EBS volumes attached to Windows using custom tags and then delete old snapshots based on age.
    This script:
     1). Uses a hash table that maps EBS volumes to the corresponding Windows drive letter
     2). Creates a custom tag for EBS snapshots
     3). Uses the Sysinternals sync utility to flush the Windows disk cache to the volume, eliminating the need to offline volumes before snapshots
     4). Snapshots the volumes with custom tags
     5). Retrieves all snapshots with the specified custom tag and deletes them based on their age.
    Alex Neihaus 2015-05-13
#>
 
 
<# The following hash table must reflect the current state of the instance's drives. To determine the 
     current mappings, you will need to access the AWS console and work from the volume id to the 
     mount point inside windows, then using Disk Manager from the disk number that maps to that mount 
     point to the assigned drive letter. FWIW, I thought hard about automating this but decided against it
     as there are too many moving parts for reliable operation. 
   
#>
Import-Module AWSPowerShell
$hashTable = @{"vol-11111111" = "L"; ` # key =  EBS volume to be snapshotted; item = Windows Drive letter
               "vol-22222222" = "M";
               }
 
foreach ($hashKey in $hashTable.Keys) {
    $tags = @()
    $t1 = New-Object Amazon.EC2.Model.Tag
    $t1.Key = "Name"
    $t1.Value = "Snapshot of hot-standby volume $hashKey; Windows drive: $($hashTable.Item($hashKey)): {0:s}" -f (get-date)
    $tags += $t1
 
    $t2 = New-Object Amazon.EC2.Model.Tag
    $t2.Key = "HotStandbySnapshotDate"
    $t2.Value = "{0:s}" -f (get-date)
    $tags += $t2
          
    # Force Windows to write all data to the disk using Sysinternals Sync utility, which was installed in %windir%\system32. See https://technet.microsoft.com/en-us/sysinternals/bb897438.aspx
    sync.exe $($hashTable.Item($hashKey)) | Out-Null
 
    $snapshot = New-EC2Snapshot -VolumeId $hashKey -Description "Snapshot of hot-standby volume $hashKey; Windows drive $($hashTable.Item($hashKey))"
 
    # If AWS does NOT return an error, tag the snapshot and log it
    if ( !($AWSHistory.LastCommand.LastServiceResponse.StatusCode -eq "BadRequest") ) { # See http://docs.aws.amazon.com/sdkfornet1/latest/apidocs/html/P_Amazon_EC2_AmazonEC2Exception_StatusCode.htm. Essentially, HTTP 400
        New-EC2Tag -Resources $snapshot.SnapshotId -Tags $tags 
        "Most recent snapshot: $($snapshot.SnapshotID) created on $($t2.Value)" | Out-File -FilePath D:\Snapshot-logs\$hashkey.log # Just log the most recent snapshot
    }
    Else {
        "Snapshot failed for $hashKey failed at $($t2.Value)" | Out-File -FilePath "D:\Snapshot-logs\SNAPSHOT-FAILURE.log"
        Exit
    }
}
 
<# Now find snapshots that we want to remove based on their age #>
$t3 = New-Object Amazon.EC2.Model.Filter
$t3.Name = "tag:HotStandbySnapshotDate"
$t3.Values = "*"
 
 Get-EC2Tag -Filter $t3 | ForEach-Object {
    $duration =  New-TimeSpan -Start $_.Value -End (get-date)
    $snapshot = $_.ResourceId
    if ($duration.Days -ge 7) { # Change 
        "Snapshot $snapshot was created on {0:D} and is {1:N2} days old and will be deleted" -f $_.Value, $duration.Days  | Write-Host
        Remove-EC2Snapshot -SnapshotId $snapshot -Force
        }
    else {
        "Snapshot $snapshot was created on {0:D} and is {1:N2} days old and will not be deleted" -f $_.Value, $duration.Days  | Write-Host
        }
}
