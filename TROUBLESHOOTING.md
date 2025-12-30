# Troubleshooting Guide

Common issues and their solutions.

---

## 🔴 Proxy Won't Start

### **Symptom:** Double-clicking `Start-ClaudeProxy.bat` shows error or closes immediately

**Possible Causes:**

1. **Python not installed or not in PATH**
   ```cmd
   python --version
   ```
   If error, install Python 3.8+ and add to PATH

2. **Missing dependencies**
   ```cmd
   pip install fastapi uvicorn httpx
   ```

3. **Port 5006 already in use**
   ```cmd
   netstat -ano | findstr :5006
   ```
   Kill the process or change port in config

4. **Config file missing**
   - Ensure `config.bat` exists (copy from `config.example.bat`)
   - Ensure it has your Azure credentials

---

## 🔴 Claude Code Shows "API Error: 404"

### **Full Error:**
```
API Error: 404 {"error":{"code":"DeploymentNotFound","message":"The API deployment xxx does not exist..."}}
```

**Cause:** Wrong deployment name

**Solution:**
1. Check your Azure Portal → OpenAI → Deployments
2. Copy the exact deployment name
3. Update `AZURE_OPENAI_DEPLOYMENT` in `config.bat`
4. Restart proxy

---

## 🔴 Claude Code Shows "API Error: 400"

### **Error: "Unsupported parameter: max_tokens"**

**Cause:** Using GPT-5 which requires `max_completion_tokens`

**Solution:** Already fixed in proxy! If you still see this, update your proxy file.

### **Error: "Unsupported value: messages[].role does not support 'function'"**

**Cause:** Old tool format

**Solution:** Already fixed in proxy to use `role: "tool"`

### **Error: "tools parameter not supported"**

**Cause:** Using o1 model which doesn't support tools

**Solution:** Switch to `gpt-5` or `gpt-4o` in config.bat

---

## 🔴 Proxy Shows "AZURE_ENDPOINT not set"

**Cause:** Environment variables not loaded

**Solution:**

**Option 1: Use Start-ClaudeProxy.bat**
- It loads variables from config.bat automatically

**Option 2: Set permanent variables**
```powershell
.\setup_environment.ps1
```
Then restart PC

**Option 3: Hardcode in proxy (not recommended)**
- Edit `anthropic_to_azure_proxy.py`
- Add values after "Azure credentials - hardcoded for local development"

---

## 🔴 "Thinking..." Forever / Very Slow

**Symptoms:**
- Claude Code shows "thinking..." for 5-10 minutes
- No response or very slow responses

**Causes & Solutions:**

1. **Check proxy window** - Should show activity
   - If no activity → Restart proxy
   - If errors shown → Fix the error

2. **Azure service issue**
   - Check Azure Portal for service health
   - Try different deployment/region

3. **Rate limiting**
   - Check Azure Portal → Metrics
   - Increase rate limits if needed

4. **Network issues**
   - Test: `curl https://your-azure-endpoint.cognitiveservices.azure.com`
   - Disable VPN if using
   - Check firewall settings

5. **Request too large**
   - Large file reads can take time
   - GPT-5 processes tools sequentially

---

## 🔴 Tools Not Working

### **Symptom:** Claude Code says "I don't have file access" or "I can't read files"

**Causes & Solutions:**

1. **VS Code settings wrong**
   ```json
   {
     "anthropic.baseUrl": "http://127.0.0.1:5006",  // ← Must be this
     "anthropic.apiKey": "dummy"
   }
   ```

2. **Proxy not running**
   - Ensure `Start-ClaudeProxy.bat` is running
   - Check: `curl http://127.0.0.1:5006/health`
   - Should return: `{"ok":true,"azure_configured":true}`

3. **Using o1 model**
   - o1 doesn't support tools
   - Switch to gpt-5 or gpt-4o

4. **Tool translation error**
   - Check proxy logs for errors
   - Restart proxy
   - Update proxy to latest version

---

## 🔴 "Connection Refused" Error

**Symptom:** Claude Code can't connect to proxy

**Solution:**

1. **Ensure proxy is running**
   ```cmd
   Start-ClaudeProxy.bat
   ```

2. **Check correct port**
   ```cmd
   curl http://127.0.0.1:5006/health
   ```

3. **Firewall blocking**
   - Windows Defender may block localhost
   - Add exception for Python

4. **Wrong URL in VS Code**
   - Must be: `http://127.0.0.1:5006`
   - NOT: `http://127.0.0.1:5006/v1`
   - NOT: `https://...`

---

## 🔴 Progress Not Showing

**Symptom:** Proxy window silent, no activity shown

**Cause:** Logging disabled

**Solution:** Already fixed! Update your proxy file from this package.

You should now see:
```
📨 Request received from Claude Code
🔧 Converting 17 tools (Read, Write, Bash, etc.)
✅ Tools ready, sending to Azure GPT-5...
```

---

## 🔴 Multiple Python Versions

**Symptom:** `pip install` works but proxy still says "No module named httpx"

**Cause:** Multiple Python installations

**Solution:**

1. **Find which Python the proxy uses:**
   ```cmd
   where python
   ```

2. **Install to that specific Python:**
   ```cmd
   "C:\Users\vicky\AppData\Local\Programs\Python\Python312\python.exe" -m pip install fastapi uvicorn httpx
   ```

3. **Or update Start-ClaudeProxy.bat:**
   ```batch
   "C:\path\to\your\python.exe" anthropic_to_azure_proxy.py
   ```

---

## 🔴 Proxy Crashes / Stops Working

**Symptoms:**
- Proxy window closes
- Errors in proxy window
- Claude Code suddenly stops responding

**Solutions:**

1. **Check proxy logs** (before it closed)
   - Look for ERROR lines
   - Common: API key invalid, quota exceeded

2. **Azure quota exceeded**
   - Check Azure Portal → Metrics
   - Upgrade quota if needed

3. **Invalid API key**
   - Regenerate key in Azure Portal
   - Update config.bat

4. **Memory issue**
   - Restart proxy
   - Restart computer if needed

---

## 🔴 Streaming Not Working

**Symptom:** Claude Code doesn't show progressive responses

**Cause:** Streaming disabled or broken

**Solution:**
- Streaming is supported in the proxy
- Check if Claude Code extension supports it
- Try refreshing VS Code window

---

## 🔴 Auto-Start Not Working

**Symptom:** Proxy doesn't start on Windows boot

**Solution:**

1. **Check Startup folder:**
   ```cmd
   dir "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
   ```
   Should see `Start-ClaudeProxy.bat`

2. **If missing, copy it:**
   ```cmd
   copy Start-ClaudeProxy.bat "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\"
   ```

3. **Or use setup script:**
   ```powershell
   .\setup_environment.ps1
   ```

---

## 🔴 VS Code Can't Find Settings

**Symptom:** "anthropic.baseUrl" setting not found

**Cause:** Claude Code extension not installed or different version

**Solution:**

1. **Verify extension installed:**
   - VS Code → Extensions
   - Search: "claude code"
   - Install if missing

2. **Try alternate setting names:**
   ```json
   {
     "claude.apiUrl": "http://127.0.0.1:5006",
     "claude.apiKey": "dummy"
   }
   ```

3. **Or:**
   ```json
   {
     "anthropic.apiUrl": "http://127.0.0.1:5006",
     "anthropic.apiKey": "dummy"
   }
   ```

---

## 🔴 Desktop Icon Missing

**Symptom:** Can't find Start-ClaudeProxy.bat on Desktop

**Solution:**

1. **Check package folder:**
   ```
   C:\inputly_self_hosted\claude_code_gpt\Start-ClaudeProxy.bat
   ```

2. **Copy to Desktop:**
   ```cmd
   copy C:\inputly_self_hosted\claude_code_gpt\Start-ClaudeProxy.bat %USERPROFILE%\Desktop\
   ```

3. **Or create shortcut:**
   - Right-click Start-ClaudeProxy.bat
   - Send to → Desktop (create shortcut)

---

## 🔴 Performance Issues

**Symptom:** Proxy very slow (50%+ slower than direct Anthropic)

**Solutions:**

1. **Already optimized** - This package has logging optimized
   - Should be ~20-30% slower (acceptable)

2. **If still slow:**
   - Check network latency to Azure
   - Try different Azure region
   - Disable VPN
   - Check for rate limiting

3. **Compare timings:**
   - Direct Anthropic: 1-2 seconds
   - Via proxy: 1.5-2.5 seconds
   - If much worse, investigate network

---

## 🔴 Weird Characters in Logs

**Symptom:** Proxy logs show � or broken characters

**Cause:** Unicode encoding issue in Windows console

**Solution:**

1. **Change console encoding:**
   ```cmd
   chcp 65001
   ```

2. **Or ignore** - Doesn't affect functionality

---

## 🆘 Still Stuck?

**Debug Steps:**

1. **Test proxy directly:**
   ```powershell
   $headers = @{"Content-Type"="application/json"}
   $body = '{"messages":[{"role":"user","content":"test"}],"max_tokens":10}'
   Invoke-WebRequest -Uri http://127.0.0.1:5006/v1/messages -Method POST -Headers $headers -Body $body
   ```

2. **Check health endpoint:**
   ```cmd
   curl http://127.0.0.1:5006/health
   ```
   Should return: `{"ok":true,"azure_configured":true}`

3. **Review proxy code** - All logic is in `anthropic_to_azure_proxy.py`

4. **Check versions:**
   ```cmd
   python --version
   pip list | findstr fastapi
   pip list | findstr uvicorn
   pip list | findstr httpx
   ```

---

**Most issues are fixed by:**
1. ✅ Correct Azure credentials in config.bat
2. ✅ Correct VS Code settings
3. ✅ Proxy actually running
4. ✅ Using gpt-5 (not o1)
