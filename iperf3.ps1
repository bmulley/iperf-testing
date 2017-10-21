<#
  .SYNOPSIS
    This script will query a given iperf3 server and write its output to a text file.
    Author: Joe McCormack (@bmulley)

  .PARAMETER 

#>


begin {}
 
process {
$i=1
    While($i -lt 9999)
        {
            $i++
            Write-Host $i


rv test -ErrorAction SilentlyContinue
rv content -ErrorAction SilentlyContinue
rv port -ErrorAction SilentlyContinue
rv parallel -ErrorAction SilentlyContinue
rv testhost -ErrorAction SilentlyContinue
rv iperfremote -ErrorAction SilentlyContinue
rv iperflocal -ErrorAction SilentlyContinue
rv data -ErrorAction SilentlyContinue

$port=993
$parallel=10
$testarray=("74.128.78.51","13.82.91.69","10.115.40.6")
$iperfremote='\\execnet.afcdom1\fileshares\IT Files\AFG IT Security and Network Operations\iperf\*'
$iperflocal="$env:HOMEDRIVE\iperf\"
$output="$iperflocal\out.txt"
$hostname = hostname
$NetIF = (Get-NetConnectionProfile | Where-Object IPv4Connectivity -eq Internet | Select-Object InterfaceIndex)
$NetIP = (Get-NetIPConfiguration | Where-Object InterfaceIndex -eq $NetIF.InterfaceIndex | Select-Object IPv4Address)


mkdir $iperflocal -ErrorAction SilentlyContinue
copy $iperfremote $iperflocal -ErrorAction SilentlyContinue

Foreach($testhost in $testarray)
{
$data = get-date -Format G
$data = $data + ',' + $hostname
$data = $data + ',' + $NetIP.IPv4Address.IPaddress
$data = $data + ',' + $testhost
$content = & "$iperflocal\iperf3.exe" -c $testhost -p $port -P $parallel | Select-String "SUM\]\ \ \ 0\.00\-10" | Select-Object Line
foreach($line in $content) {
$found = $line -match 's\ *(\S*?)\ Mbi'
if ($found) {
    $test = $matches[1]
    $data = $data + ',' + $test
    }
}
$data >> $output

}
Start-Sleep -Seconds 300}}