# How to run Claude Code Cli with GPT or Any LLM Model - Complete Setup Package

**Use Claude Code extension with Azure GPT-5 instead of Anthropic API**

## 🎯 What This Does

This proxy allows you to use the **Claude Code VS Code extension** but route all requests to your **Azure OpenAI GPT-5 deployment**, so you:
- ✅ Use Azure credits instead of Anthropic API
- ✅ Get full tool support (Read, Write, Bash, Grep, etc.)
- ✅ Keep the excellent Claude Code extension UI
- ✅ Use GPT-5's intelligence for coding tasks

---

## 📦 Package Contents

```
claude_code_gpt/
├── README.md                          ← You are here
├── anthropic_to_azure_proxy.py        ← Main proxy server
├── Start-ClaudeProxy.bat              ← Windows startup script
├── setup_environment.ps1              ← One-time setup script
├── config.example.bat                 ← Configuration template
└── TROUBLESHOOTING.md                 ← Common issues and fixes
```

---

## 🚀 Quick Start (5 Minutes)

### **Step 1: Configure Your Azure Credentials**

1. Copy `config.example.bat` to `config.bat`:
   ```cmd
   copy config.example.bat config.bat
   ```

2. Edit `config.bat` and add your Azure credentials:
   ```batch
   set AZURE_OPENAI_ENDPOINT=https://your-resource.cognitiveservices.azure.com
   set AZURE_OPENAI_API_KEY=your_azure_api_key_here
   set AZURE_OPENAI_DEPLOYMENT=gpt-5
   set AZURE_OPENAI_API_VERSION=2025-01-01-preview
   ```

   **Where to find these:**
   - **Endpoint**: Azure Portal → Your OpenAI Resource → Keys & Endpoint
   - **API Key**: Same location as endpoint
   - **Deployment**: Name you gave when deploying the model (e.g., "gpt-5")
   - **API Version**: Use `2025-01-01-preview` (latest)

### **Step 2: Install Python Dependencies**

```powershell
pip install fastapi uvicorn httpx
```

### **Step 3: Configure Claude Code Extension**

1. Open VS Code
2. Open Settings (`Ctrl+,`)
3. Search for: `anthropic`
4. Set these values:
   - **Anthropic: Base Url**: `http://127.0.0.1:5006`
   - **Anthropic: Api Key**: `dummy` (any value works)

   Or add to your `settings.json`:
   ```json
   {
     "anthropic.baseUrl": "http://127.0.0.1:5006",
     "anthropic.apiKey": "dummy"
   }
   ```

### **Step 4: Start the Proxy**

Double-click: **`Start-ClaudeProxy.bat`**

You should see:
```
Starting Claude Code to Azure GPT-5 Proxy...
WITH FULL TOOL SUPPORT (Read, Write, Bash, etc.)
========================================
Proxy: http://127.0.0.1:5006
Model: Azure GPT-5
Tools: ENABLED (Read, Write, Bash, etc.)
========================================
```

### **Step 5: Use Claude Code!**

1. Open Claude Code extension in VS Code
2. Ask it to read files, write code, run commands, etc.
3. Watch the proxy window to see what it's doing

**It's working when you see:**
```
📨 Request received from Claude Code
🔧 Converting 17 tools (Read, Write, Bash, etc.)
✅ Tools ready, sending to Azure GPT-5...
✅ Response received from Azure GPT-5
🔧 GPT-5 wants to use 1 tools
   → Tool: Read
```

---

## 🔧 How It Works

```
┌─────────────────┐
│ Claude Code     │
│ VS Code Ext     │
└────────┬────────┘
         │ Anthropic Messages API format
         ↓
┌─────────────────┐
│  Proxy Server   │  ← Translates formats
│  (localhost)    │
└────────┬────────┘
         │ OpenAI Chat Completions format
         ↓
┌─────────────────┐
│ Azure GPT-5     │
│ OpenAI Endpoint │
└─────────────────┘
```

### **What the Proxy Translates:**

**Anthropic Format → OpenAI Format:**
- `messages` → `messages` (with format conversion)
- `tools` (Anthropic) → `tools` (OpenAI modern format)
- `tool_use` → `tool_calls` (function calling)
- `tool_result` → `role: "tool"` messages
- `max_tokens` → `max_completion_tokens`

**OpenAI Format → Anthropic Format:**
- `function_call` / `tool_calls` → `tool_use` blocks
- `content` → `content` blocks with type
- `finish_reason` → `stop_reason`
- Usage stats mapping

---

## 🔧 Advanced Configuration

### **Use a Different Model**

Edit the proxy file or set environment variable:
```python
AZURE_DEPLOYMENT = "gpt-4o"  # or "gpt-5", "o1", etc.
```

**Note:** `o1` models do NOT support tools, so Claude Code won't work with them.

### **Change Port**

Default port is 5006. To change:
```bash
set ANTHROPIC_PROXY_PORT=8080
```

### **Enable Debug Logging**

Uncomment debug lines in `anthropic_to_azure_proxy.py`:
```python
# print(f"[DEBUG] Converting {len(tools)} tools...")
```

### **Auto-Start on Windows Boot**

The setup script copies the proxy to your Startup folder, so it auto-starts when Windows boots.

To disable:
```cmd
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Start-ClaudeProxy.bat"
```

---

## 🛠️ Supported Tools

The proxy translates all Claude Code tools to Azure GPT-5:

✅ **File Operations:**
- `Read` - Read any file
- `Write` - Create new files
- `Edit` - Modify existing files
- `Glob` - Find files by pattern
- `NotebookEdit` - Edit Jupyter notebooks

✅ **Code Operations:**
- `Grep` - Search code
- `Bash` - Run terminal commands (including SSH, curl, git, docker)

✅ **Task Management:**
- `Task` - Spawn background tasks
- `TaskOutput` - Get task results
- `KillShell` - Kill running tasks

✅ **Planning & Organization:**
- `TodoWrite` - Manage todo lists
- `EnterPlanMode` / `ExitPlanMode` - Planning mode

✅ **Other:**
- `WebFetch` - Fetch web pages
- `WebSearch` - Search the web
- `AskUserQuestion` - Ask for clarification
- `Skill` - Run custom skills

---

## 📊 Performance

**Expected latency:**
- **Direct Anthropic API:** ~1-2 seconds per request
- **Via this proxy:** ~1.5-2.5 seconds per request
- **Overhead:** ~20-30% slower

**Why the slowdown?**
1. Extra network hop (localhost proxy)
2. Format translation overhead
3. Azure server location
4. Tool conversion processing

**Is it worth it?**
- ✅ Save money (use Azure credits)
- ✅ Full tool support working
- ✅ Excellent GPT-5 intelligence
- ⚠️ 20-30% slower (acceptable trade-off)

---

## 🐛 Troubleshooting

### **"API Error: 404 - DeploymentNotFound"**

**Problem:** Azure can't find your deployment.

**Solution:**
1. Check your deployment name in Azure Portal
2. Update `AZURE_OPENAI_DEPLOYMENT` in config.bat
3. Restart the proxy

### **"API Error: 400 - Unsupported parameter"**

**Problem:** Your model doesn't support a parameter.

**Solution:**
- If using `o1`: Switch to `gpt-5` (o1 doesn't support tools)
- If using old model: Update to latest API version

### **"Connection refused" or proxy won't start**

**Solution:**
1. Check if port 5006 is already in use: `netstat -ano | findstr :5006`
2. Kill the process or change port
3. Ensure Python dependencies installed: `pip install fastapi uvicorn httpx`

### **"Proxy is too slow"**

**Solution:**
1. Check your internet connection to Azure
2. Try a different Azure region (closer to you)
3. Disable any VPN/proxy
4. Check if you're hitting rate limits

### **"Tools not working / Claude Code says no file access"**

**Problem:** Tool translation issue or VS Code settings wrong.

**Solution:**
1. Verify VS Code settings: `anthropic.baseUrl` = `http://127.0.0.1:5006`
2. Restart VS Code
3. Check proxy logs for errors
4. Ensure proxy is running

### **"Seeing 'thinking...' forever"**

**Problem:** Request taking too long or stuck.

**Solution:**
1. Check proxy window - you should see activity
2. If no activity, restart proxy
3. Check Azure Portal for service issues
4. Try reducing request complexity

---

## 🔐 Security Notes

**Important:**
- ✅ Proxy runs on `localhost` only (not exposed to internet)
- ✅ No API keys stored in code (use environment variables)
- ✅ Config.bat excluded from git (.gitignore)
- ⚠️ Don't commit `config.bat` to version control
- ⚠️ Don't share your Azure API keys

---

## 📝 Files Explained

### **anthropic_to_azure_proxy.py**
Main proxy server. Translates between Anthropic Messages API and Azure OpenAI Chat Completions API.

**Key functions:**
- `/v1/messages` - Main endpoint for Claude Code requests
- `/v1/messages/count_tokens` - Token counting
- `/api/event_logging/batch` - Telemetry (ignored)
- `/health` - Health check

### **Start-ClaudeProxy.bat**
Windows batch script to start the proxy with environment variables loaded.

### **setup_environment.ps1**
PowerShell script to set permanent Windows user environment variables.

### **config.example.bat**
Template for your Azure credentials. Copy to `config.bat` and fill in your values.

---

## 🆘 Support

**If something goes wrong:**

1. **Check proxy logs** - Look at the proxy window for errors
2. **Check Claude Code output** - VS Code Output panel → Claude Code
3. **Test manually**: `curl http://127.0.0.1:5006/health`
4. **Read TROUBLESHOOTING.md** - Common issues and fixes

**Common issues:**
- Wrong API keys → Update config.bat
- Wrong deployment name → Check Azure Portal
- Port conflict → Change port or kill other process
- Missing dependencies → Run `pip install fastapi uvicorn httpx`

---

## 📊 Cost Comparison

### **Anthropic API Pricing:**
- Claude Sonnet: $3 per 1M input tokens, $15 per 1M output tokens

### **Azure OpenAI Pricing:**
- GPT-5: Varies by region and commitment
- Typically cheaper with Azure credits/commitments

### **Which is better?**
- Use **Azure** if you have credits or commitments
- Use **Anthropic direct** if you want absolute best performance

---

## 🎓 Advanced Topics

### **Adding Support for Other Models**

To add support for other Azure models, edit the proxy:

```python
AZURE_DEPLOYMENT = os.getenv("AZURE_OPENAI_DEPLOYMENT", "your-model")
```

**Models that work:**
- ✅ gpt-5
- ✅ gpt-4o
- ✅ gpt-4-turbo
- ❌ o1 (no tool support)
- ❌ o1-mini (no tool support)

### **Using with Multiple Deployments**

You can set different deployments for different tasks by modifying the proxy to read deployment from request metadata.

### **Streaming Support**

The proxy supports streaming responses. Claude Code will receive tokens as they're generated.

---

## 📚 Technical Details

### **Anthropic Messages API Format**
```json
{
  "model": "claude-sonnet-4-5",
  "messages": [...],
  "max_tokens": 4096,
  "tools": [
    {
      "name": "Read",
      "description": "Read files",
      "input_schema": {...}
    }
  ]
}
```

### **Azure OpenAI Chat Completions Format**
```json
{
  "messages": [...],
  "max_completion_tokens": 4096,
  "tools": [
    {
      "type": "function",
      "function": {
        "name": "Read",
        "description": "Read files",
        "parameters": {...}
      }
    }
  ]
}
```

### **Tool Use Translation**

**Anthropic tool_use:**
```json
{
  "type": "tool_use",
  "id": "toolu_123",
  "name": "Read",
  "input": {"file_path": "..."}
}
```

**OpenAI tool_calls:**
```json
{
  "id": "call_123",
  "type": "function",
  "function": {
    "name": "Read",
    "arguments": "{\"file_path\": \"...\"}"
  }
}
```

---

## 🎉 Success!

If you see this in the proxy window, everything is working:

```
📨 Request received from Claude Code
🔧 Converting 17 tools (Read, Write, Bash, etc.)
✅ Tools ready, sending to Azure GPT-5...
✅ Response received from Azure GPT-5
🔧 GPT-5 wants to use 2 tools
   → Tool: Read
   → Tool: Write
```

And Claude Code is using Azure GPT-5 with full tool support! 🚀

---

## 📄 License

This is a proxy tool for personal/development use. Ensure compliance with:
- Anthropic Terms of Service
- Azure OpenAI Terms of Service
- OpenAI Usage Policies

---

**Questions? Issues? Check TROUBLESHOOTING.md or review the code!**
