$file = Join-Path $PSScriptRoot '..\assets\sounds\breath_phase.wav'
$file = [System.IO.Path]::GetFullPath($file)

New-Item -ItemType Directory -Force -Path ([System.IO.Path]::GetDirectoryName($file)) | Out-Null

$sampleRate = 44100
$duration = 0.09
$frequency = 880.0
$samples = [int]($sampleRate * $duration)
$bitsPerSample = 16
$channels = 1
$blockAlign = $channels * ($bitsPerSample / 8)
$byteRate = $sampleRate * $blockAlign
$dataSize = $samples * $blockAlign

$stream = [System.IO.File]::Open($file, [System.IO.FileMode]::Create)
$writer = New-Object System.IO.BinaryWriter($stream)

$writer.Write([System.Text.Encoding]::ASCII.GetBytes("RIFF"))
$writer.Write([int](36 + $dataSize))
$writer.Write([System.Text.Encoding]::ASCII.GetBytes("WAVE"))
$writer.Write([System.Text.Encoding]::ASCII.GetBytes("fmt "))
$writer.Write([int]16)
$writer.Write([int16]1)
$writer.Write([int16]$channels)
$writer.Write([int]$sampleRate)
$writer.Write([int]$byteRate)
$writer.Write([int16]$blockAlign)
$writer.Write([int16]$bitsPerSample)
$writer.Write([System.Text.Encoding]::ASCII.GetBytes("data"))
$writer.Write([int]$dataSize)

for ($i = 0; $i -lt $samples; $i++) {
  $t = $i / $sampleRate
  if ($t -lt 0.015) {
    $envelope = $t / 0.015
  } elseif ($t -gt ($duration - 0.025)) {
    $envelope = [Math]::Max(0.0, ($duration - $t) / 0.025)
  } else {
    $envelope = 1.0
  }

  $value = [Math]::Sin(2.0 * [Math]::PI * $frequency * $t) * 0.28 * $envelope
  $sample = [int16]([Math]::Round($value * 32767))
  $writer.Write($sample)
}

$writer.Close()
