param([string]$url="https://www.zerohedge.com/")
# Config Content
$WebAddress = $url
Write-Output "Fetching $url"

# Config TTS
Add-Type -AssemblyName System.speech

# exit; # early for testing

# Process
$page = Invoke-WebRequest -Uri $WebAddress
# ( $page.ParsedHtml.getElementsByTagName('a') | Where{$_.rel -eq 'bookmark'})
# $Phrase = $page.ParsedHtml.getElementsByTagName('h2') | ForEach-Object {$_.innerText}
$links = $page.ParsedHtml.getElementsByTagName('a') | Where-Object{$_.rel -eq 'bookmark'} | ForEach-Object {$_.pathname}

# $links | ForEach-Object {Write-Output "http://www.zerohedge.com/$_" }

for ($i = 0; $i -lt $links.length; $i++) {
  $file_path = $links[$i]
  $link = "https://www.zerohedge.com/$file_path"
  Write-Output $link
  $page = Invoke-WebRequest -Uri $link

  $title = $page.ParsedHtml.getElementById('block-zerohedge-page-title') | ForEach-Object {$_.innerText}
  Write-Output $title

  $content = $page.ParsedHtml.getElementById('block-zerohedge-content') | ForEach-Object {$_.innerText}
  Write-Output $content

  # Output to file
  $wav_filename = $file_path -replace "/", "__"
  $wav_filepath = "./audio_files/$wav_filename.wav"
  Write-Output $wav_filepath
  $SpeechSynthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer
  $SpeechSynthesizer.Rate   = 1  # -10 to 10; -10 is slowest, 10 is fastest
  $SpeechSynthesizer.SetOutputToWaveFile($wav_filepath)
  $SpeechSynthesizer.Speak($title)
  $SpeechSynthesizer.Speak($content)
  $SpeechSynthesizer.Dispose()
  
  # Output to console
  $SpeechSynthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer
  $SpeechSynthesizer.Rate   = 1  # -10 to 10; -10 is slowest, 10 is fastest
  $SpeechSynthesizer.Speak($title)
  $SpeechSynthesizer.Speak($content)
  
  Start-Sleep -s 5
}

