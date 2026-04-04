<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>LEGENDARY PARADISE - Key System</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
  background: #0a0a0e;
  color: #ccc;
  font-family: 'Segoe UI', Arial, sans-serif;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}
.card {
  background: #111118;
  border: 1px solid #dc1e1e33;
  border-radius: 16px;
  padding: 40px;
  max-width: 440px;
  width: 90%;
  text-align: center;
  box-shadow: 0 0 40px #dc1e1e15;
}
.logo-img {
  width: 200px;
  height: auto;
  margin: 0 auto 8px auto;
  display: block;
  border-radius: 8px;
}
.version {
  color: #555;
  font-size: 11px;
  margin-bottom: 20px;
}
.hwid-section {
  margin-bottom: 24px;
}
.hwid-label {
  color: #888;
  font-size: 11px;
  margin-bottom: 8px;
  text-align: left;
}
.hwid-label span { color: #dc1e1e; font-weight: 600; }
.hwid-input {
  width: 100%;
  background: #0a0a0f;
  border: 2px solid #333;
  border-radius: 8px;
  padding: 10px 12px;
  color: #fff;
  font-size: 11px;
  font-family: 'Consolas', monospace;
  outline: none;
  transition: border-color 0.2s;
  box-sizing: border-box;
}
.hwid-input:focus { border-color: #dc1e1e; }
.hwid-input::placeholder { color: #444; }
.key-section { display: none; }
.label {
  color: #888;
  font-size: 12px;
  margin-bottom: 10px;
}
.key-box {
  background: #0a0a0f;
  border: 2px solid #dc1e1e;
  border-radius: 10px;
  padding: 16px 20px;
  font-family: 'Consolas', 'Courier New', monospace;
  font-size: 22px;
  font-weight: 700;
  color: #fff;
  letter-spacing: 3px;
  user-select: all;
  cursor: pointer;
  transition: all 0.2s;
  margin-bottom: 16px;
}
.key-box:hover {
  background: #dc1e1e15;
  border-color: #ff3333;
}
.copy-btn {
  background: #dc1e1e;
  color: #fff;
  border: none;
  border-radius: 8px;
  padding: 12px 32px;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s;
  letter-spacing: 1px;
}
.copy-btn:hover { background: #ff2222; transform: scale(1.03); }
.copy-btn.copied { background: #1a8a1a; }
.timer {
  color: #555;
  font-size: 11px;
  margin-top: 20px;
}
.timer span { color: #dc1e1e; font-weight: 600; }
.steps {
  margin-top: 24px;
  text-align: left;
  background: #0d0d12;
  border-radius: 8px;
  padding: 16px;
}
.steps p {
  color: #777;
  font-size: 11px;
  margin-bottom: 6px;
}
.steps p span { color: #dc1e1e; font-weight: 600; }
.footer {
  color: #333;
  font-size: 10px;
  margin-top: 24px;
}
</style>
</head>
<body>
<div class="card">
  <img src="https://raw.githubusercontent.com/LegendaryRvx/legendary-paradisev2/main/logo.png" alt="Legendary Paradise" class="logo-img">
  <div class="version">v2.5 COMMERCIAL — KEY SYSTEM</div>

  <div class="hwid-section">
    <div class="hwid-label"><span>STEP 1:</span> Paste your HWID from the script</div>
    <input class="hwid-input" id="hwidInput" type="text" placeholder="Paste your HWID here..." oninput="onHwidInput()">
    <div style="color:#555;font-size:10px;margin-top:6px;text-align:left;">
      Open the script in Roblox → your HWID appears below the key input box
    </div>
  </div>

  <div class="key-section" id="keySection">
    <div class="label">YOUR KEY (valid 24h)</div>
    <div class="key-box" id="keyDisplay" onclick="copyKey()">...</div>
    <button class="copy-btn" id="copyBtn" onclick="copyKey()">COPY KEY</button>
    <div class="timer">
      Expires in <span id="countdown">--:--:--</span> · New key every day
    </div>
  </div>
  
  <div class="steps">
    <p><span>1.</span> Execute the script in your executor</p>
    <p><span>2.</span> Copy your HWID from the key screen</p>
    <p><span>3.</span> Paste it above to get your personal key</p>
    <p><span>4.</span> Copy the key → paste in Roblox → ACTIVATE</p>
  </div>
  
  <div class="footer">© LegendaryRvx — Do not share this page directly</div>
</div>

<script>
const SECRET_SEED = "LP_LEGENDARY_2025_PARADISE";

function generateUserKey(hwid) {
  const now = new Date();
  const y = now.getUTCFullYear();
  const m = now.getUTCMonth() + 1;
  const d = now.getUTCDate();
  const dayCode = y * 10000 + m * 100 + d;

  const combined = SECRET_SEED + hwid;

  // Pass 1
  let hash = 0;
  for (let i = 0; i < combined.length; i++) {
    hash = (hash * 31 + combined.charCodeAt(i) + dayCode) % 999999;
  }

  // Pass 2 (reversed combined)
  const rev = combined.split("").reverse().join("");
  let hash2 = dayCode;
  for (let i = 0; i < rev.length; i++) {
    hash2 = (hash2 * 17 + rev.charCodeAt(i) + hash) % 999999;
  }

  return "LP-" + String(hash).padStart(6, '0') + "-" + String(hash2).padStart(6, '0');
}

function getTimeUntilMidnightUTC() {
  const now = new Date();
  const tomorrow = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate() + 1));
  const diff = tomorrow - now;
  const h = Math.floor(diff / 3600000);
  const m = Math.floor((diff % 3600000) / 60000);
  const s = Math.floor((diff % 60000) / 1000);
  return String(h).padStart(2,'0') + ":" + String(m).padStart(2,'0') + ":" + String(s).padStart(2,'0');
}

let currentKey = "";

function onHwidInput() {
  const hwid = document.getElementById("hwidInput").value.trim();
  const section = document.getElementById("keySection");
  if (hwid.length < 5) {
    section.style.display = "none";
    return;
  }
  currentKey = generateUserKey(hwid);
  document.getElementById("keyDisplay").textContent = currentKey;
  section.style.display = "block";
}

// Countdown
setInterval(() => {
  const el = document.getElementById("countdown");
  if (el) el.textContent = getTimeUntilMidnightUTC();
}, 1000);

function copyKey() {
  if (!currentKey) return;
  navigator.clipboard.writeText(currentKey).then(() => {
    const btn = document.getElementById("copyBtn");
    btn.textContent = "COPIED!";
    btn.classList.add("copied");
    setTimeout(() => {
      btn.textContent = "COPY KEY";
      btn.classList.remove("copied");
    }, 2000);
  });
}
</script>
</body>
</html>
