@echo off
echo Starting Claude Code to Azure GPT-5 Proxy...
echo WITH FULL TOOL SUPPORT (Read, Write, Bash, etc.)
echo.

REM Load Azure credentials from config.bat
if exist config.bat (
    call config.bat
) else (
    echo ERROR: config.bat not found!
    echo Please copy config.example.bat to config.bat and fill in your Azure credentials
    pause
    exit /b 1
)

echo ========================================
echo Proxy: http://127.0.0.1:5006
echo Model: Azure GPT-5
echo Tools: ENABLED (Read, Write, Bash, etc.)
echo ========================================
echo.
echo Keep this window open while using Claude Code extension
echo Press Ctrl+C to stop the proxy
echo.

python anthropic_to_azure_proxy.py

pause
