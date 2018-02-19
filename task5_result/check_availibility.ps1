$url = 'http://localhost:5000'
$req = [system.Net.WebRequest]::Create($url)
cd "C:\Applications\Dev\MusicStore"
$latestPath = Get-ChildItem -Path $root | Where-Object {$_.PSIsContainer} | Sort-Object LastWriteTime -Descending | Select-Object -First 1
cd $latestPath
start dotnet MusicStore.dll
echo "Started loading"
Start-Sleep -s 20
try {
    $res = $req.GetResponse()
} 
catch [System.Net.WebException] {
    $res = $_.Exception.Response
}
if ([int]$res.StatusCode -eq 200) {
    echo "Site is UP"
    echo "Shut down application"
    Stop-Process -Name "dotnet"
} else {
echo "Site is DOWN"
}

