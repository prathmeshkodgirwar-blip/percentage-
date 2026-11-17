$port = 8080
$htmlPath = Join-Path $PSScriptRoot "index.html"

# Get local IPv4
$ip = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -eq "Up" }).IPv4Address.IPAddress
if (-not $ip) {
    $ip = (ipconfig | Select-String "IPv4 Address.*: ([\d\.]+)" | ForEach-Object { $_.Matches[0].Groups[1].Value } | Select-Object -First 1)
}
if (-not $ip) { $ip = "localhost" }

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Percentage Splitter - Mobile Wi-Fi Server             " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Make sure your phone is connected to the same Wi-Fi network!" -ForegroundColor Yellow
Write-Host ""
Write-Host "On your mobile phone, open Chrome or Safari and visit:" -ForegroundColor White
Write-Host "   👉 http://$($ip):$port" -ForegroundColor Green -BackgroundColor Black
Write-Host ""
Write-Host "Press Ctrl + C in this window to stop the server anytime." -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://*:$port/")

try {
    $listener.Start()
} catch {
    # If wildcard binding requires admin, fall back to localhost prefix
    Write-Host "Note: Standard listener starting on http://localhost:$port/" -ForegroundColor Yellow
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add("http://+:$port/")
    try {
        $listener.Start()
    } catch {
        $listener = New-Object System.Net.HttpListener
        $listener.Prefixes.Add("http://localhost:$port/")
        $listener.Start()
    }
}

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $response = $context.Response
        
        $content = [System.IO.File]::ReadAllBytes($htmlPath)
        $response.ContentType = "text/html; charset=utf-8"
        $response.ContentLength64 = $content.Length
        $response.OutputStream.Write($content, 0, $content.Length)
        $response.Close()
    } catch {
        # continue listening on transient error
    }
}
