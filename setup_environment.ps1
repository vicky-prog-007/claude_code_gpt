# Setup script for Claude Code to Azure GPT-5 Proxy
# This script sets up permanent user environment variables and auto-start

Write-Host "Setting up Claude Code to Azure GPT-5 Proxy..." -ForegroundColor Green
Write-Host ""

# Check if config.bat exists
if (-not (Test-Path "config.bat")) {
    Write-Host "ERROR: config.bat not found!" -ForegroundColor Red
    Write-Host "Please copy config.example.bat to config.bat and fill in your Azure credentials" -ForegroundColor Yellow
    pause
    exit 1
}

# Load config.bat values
Write-Host "Loading configuration from config.bat..." -ForegroundColor Cyan
$configContent = Get-Content "config.bat"
$endpoint = ($configContent | Select-String "AZURE_OPENAI_ENDPOINT=(.+)").Matches.Groups[1].Value
$apiKey = ($configContent | Select-String "AZURE_OPENAI_API_KEY=(.+)").Matches.Groups[1].Value
$deployment = ($configContent | Select-String "AZURE_OPENAI_DEPLOYMENT=(.+)").Matches.Groups[1].Value
$apiVersion = ($configContent | Select-String "AZURE_OPENAI_API_VERSION=(.+)").Matches.Groups[1].Value

# Validate values
if ([string]::IsNullOrWhiteSpace($endpoint) -or $endpoint -eq "https://your-resource-name.cognitiveservices.azure.com") {
    Write-Host "ERROR: Azure endpoint not configured in config.bat" -ForegroundColor Red
    pause
    exit 1
}

if ([string]::IsNullOrWhiteSpace($apiKey) -or $apiKey -eq "your_azure_api_key_here") {
    Write-Host "ERROR: Azure API key not configured in config.bat" -ForegroundColor Red
    pause
    exit 1
}

# Set permanent user environment variables
Write-Host "Setting permanent environment variables..." -ForegroundColor Cyan
[Environment]::SetEnvironmentVariable("AZURE_OPENAI_ENDPOINT", $endpoint, "User")
[Environment]::SetEnvironmentVariable("AZURE_OPENAI_API_KEY", $apiKey, "User")
[Environment]::SetEnvironmentVariable("AZURE_OPENAI_DEPLOYMENT", $deployment, "User")
[Environment]::SetEnvironmentVariable("AZURE_OPENAI_API_VERSION", $apiVersion, "User")

Write-Host "Environment variables set successfully!" -ForegroundColor Green
Write-Host ""

# Add to Windows Startup
Write-Host "Setting up auto-start on Windows boot..." -ForegroundColor Cyan
$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$batchFile = Join-Path $PSScriptRoot "Start-ClaudeProxy.bat"
$startupBatch = Join-Path $startupFolder "Start-ClaudeProxy.bat"

if (Test-Path $batchFile) {
    Copy-Item $batchFile $startupBatch -Force
    Write-Host "Proxy will now start automatically on Windows boot!" -ForegroundColor Green
} else {
    Write-Host "WARNING: Start-ClaudeProxy.bat not found in current directory" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Restart your computer (or log out and log back in)" -ForegroundColor White
Write-Host "2. The proxy will start automatically on next boot" -ForegroundColor White
Write-Host "3. Configure VS Code settings:" -ForegroundColor White
Write-Host "   - anthropic.baseUrl: http://127.0.0.1:5006" -ForegroundColor White
Write-Host "   - anthropic.apiKey: dummy" -ForegroundColor White
Write-Host ""

pause
