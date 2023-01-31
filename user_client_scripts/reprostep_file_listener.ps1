param([string]$reprostep_file_js)

$file = "$reprostep_file_js"
$previousLines = Get-Content $file

while ($true) {
  Start-Sleep -Seconds 1
  $currentLines = Get-Content $file

  if ($currentLines.Length -ne $previousLines.Length) {
    $modifiedLine = ($currentLines | Compare-Object $previousLines).InputObject
    $modifiedLine = "$modifiedLine --- [$(Get-Date -Format HH:mm:ss)]"
    $index = $currentLines.IndexOf($modifiedLine)
    $currentLines[$index] = "+++ $modifiedLine"
    $currentLines | Set-Content $file
    $previousLines = $currentLines
  }
}