## source: https://stackoverflow.com/questions/4533570/in-powershell-how-do-i-split-a-large-binary-file
function split($inFile,  $outPrefix, [Int32] $bufSize){

 

  $stream = [System.IO.File]::OpenRead($inFile)

  $chunkNum = 1

  $barr = New-Object byte[] $bufSize

 

  while( $bytesRead = $stream.Read($barr,0,$bufsize)){

    $outFile = "$outPrefix$chunkNum"

    $ostream = [System.IO.File]::OpenWrite($outFile)

    $ostream.Write($barr,0,$bytesRead);

    $ostream.close();

    echo "wrote $outFile"

    $chunkNum += 1

  }

}

 

 

function stitch($infilePrefix, $outFile) {


    $ostream = [System.Io.File]::OpenWrite($outFile)

    $chunkNum = 1

    $infileName = "$infilePrefix$chunkNum"

 

    $offset = 0

 

    while(Test-Path $infileName) {

        $bytes = [System.IO.File]::ReadAllBytes($infileName)

        $ostream.Write($bytes, 0, $bytes.Count)

        Write-Host "read $infileName"

        $chunkNum += 1

        $infileName = "$infilePrefix$chunkNum"

    }

 

    $ostream.close();

} 

 
