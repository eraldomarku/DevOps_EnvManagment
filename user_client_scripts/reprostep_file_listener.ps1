param([string]$file,[string]$steps_filtered_file)

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
    $matches = [regex]::Match($modifiedLine, "name: '(.*?)'").Groups[1].Value
    if($matches){
      Add-Content "$steps_filtered_file" "$(Get-Date -Format HH:mm:ss)"
      Add-Content "$steps_filtered_file" "$matches"
    }
    $previousLines = $currentLines
  }
}