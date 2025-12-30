@echo off
REM Configuration template for Claude Code to Azure GPT-5 Proxy
REM Copy this file to config.bat and fill in your Azure credentials

REM Azure OpenAI Endpoint (from Azure Portal -> Your OpenAI Resource -> Keys & Endpoint)
set AZURE_OPENAI_ENDPOINT=https://your-resource-name.cognitiveservices.azure.com

REM Azure OpenAI API Key (from Azure Portal -> Your OpenAI Resource -> Keys & Endpoint)
set AZURE_OPENAI_API_KEY=your_azure_api_key_here

REM Azure OpenAI Deployment Name (the name you gave when deploying the model)
set AZURE_OPENAI_DEPLOYMENT=gpt-5

REM Azure OpenAI API Version (use latest)
set AZURE_OPENAI_API_VERSION=2025-01-01-preview

REM Optional: Proxy port (default 5006)
REM set ANTHROPIC_PROXY_PORT=5006
