param([string]$file)

#waits until file is created
while (!(Test-Path "$file")) {
    Start-Sleep -Seconds 1
}

#listens to file
$previousLines = Get-Content $file
while ($true) {
  Start-Sleep -Seconds 1
  $currentLines = Get-Content $file

  if ($currentLines.Length -ne $previousLines.Length) {
    $modifiedLine = ($currentLines | Compare-Object $previousLines).InputObject
    Add-Content "repro.js" "$(Get-Date -Format HH:mm:ss)"
    Add-Content "repro.js" "$modifiedLine"
    $previousLines = $currentLines
  }
}