--[[
  LEGENDARY PARADISE v2.5 — COMMERCIAL EDITION
  Case Paradise Auto-Farm Script Hub
  © LegendaryRvx — All rights reserved
  
  KEY SYSTEM:
  - Admin code bypasses all checks
  - Lifetime keys: HWID-locked, $20, never expire
  - Daily keys: Generated via Linkvertise, 24h validity
  
  TO CONFIGURE:
  - Edit ADMIN_CODE, LIFETIME_KEYS, DAILY_KEYS below
  - For real backend, replace validateKey() with HTTP check
]]

-- ============================================================
-- KEY SYSTEM CONFIG (edit these for your distribution)
-- ============================================================
local ADMIN_CODE = "131208"
local SCRIPT_NAME = "LEGENDARY PARADISE"
local VERSION = "v2.5 COMMERCIAL"

-- Lifetime keys: {key = hwid} — HWID locked on first use
-- Set hwid="" to auto-lock on first activation
local LIFETIME_KEYS = {
 ["LP-LIFE-XXXX-0001"] = "",
 ["LP-LIFE-XXXX-0002"] = "",
}

-- Daily keys: {key = expiry_timestamp} — 24h validity
-- In production: generate these via Linkvertise callback + your API
local DAILY_KEYS = {
 ["LP-DAY-TEST-0001"] = os.time() + 86400,
}

-- Linkvertise config (user gets redirected here to get a daily key)
local LINKVERTISE_URL = "https://linkvertise.com/YOUR_ID/legendary-paradise"

-- ============================================================
-- HWID DETECTION
-- ============================================================
local function getHWID()
 local hwid = "UNKNOWN"
 pcall(function() hwid = game:GetService("RbxAnalyticsService"):GetClientId() end)
 if hwid == "UNKNOWN" then pcall(function() if gethwid then hwid = gethwid() end end) end
 if hwid == "UNKNOWN" then pcall(function() if getexecutorname then hwid = getexecutorname().."-"..tostring(game.PlaceId).."-"..tostring(game:GetService("Players").LocalPlayer.UserId) end end) end
 return hwid
end

-- ============================================================
-- KEY VALIDATION
-- ============================================================
local function validateKey(inputKey)
 -- Admin bypass
 if inputKey == ADMIN_CODE then
  return true, "admin", "ADMIN ACCESS GRANTED"
 end
 
 local hwid = getHWID()
 
 -- Check lifetime keys
 if LIFETIME_KEYS[inputKey] ~= nil then
  local storedHWID = LIFETIME_KEYS[inputKey]
  if storedHWID == "" then
   -- First activation: lock to this HWID
   LIFETIME_KEYS[inputKey] = hwid
   return true, "lifetime", "LIFETIME KEY ACTIVATED (HWID locked)"
  elseif storedHWID == hwid then
   return true, "lifetime", "LIFETIME KEY VALID"
  else
   return false, nil, "KEY ALREADY LOCKED TO ANOTHER DEVICE"
  end
 end
 
 -- Check daily keys
 if DAILY_KEYS[inputKey] ~= nil then
  if os.time() <= DAILY_KEYS[inputKey] then
   return true, "daily", "DAILY KEY VALID ("..math.floor((DAILY_KEYS[inputKey]-os.time())/3600).."h left)"
  else
   return false, nil, "KEY EXPIRED"
  end
 end
 
 return false, nil, "INVALID KEY"
end

-- ============================================================
-- KEY GUI
-- ============================================================
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local LP = Players.LocalPlayer

-- Clean old instances
pcall(function()
 if game:GetService("CoreGui"):FindFirstChild("LP_KeySystem") then game:GetService("CoreGui").LP_KeySystem:Destroy() end
 if game:GetService("CoreGui"):FindFirstChild("LegendaryParadiseUI") then game:GetService("CoreGui").LegendaryParadiseUI:Destroy() end
 if LP.PlayerGui:FindFirstChild("LP_KeySystem") then LP.PlayerGui.LP_KeySystem:Destroy() end
 if LP.PlayerGui:FindFirstChild("LegendaryParadiseUI") then LP.PlayerGui.LegendaryParadiseUI:Destroy() end
end)

local keySG = Instance.new("ScreenGui")
keySG.Name = "LP_KeySystem"
pcall(function() keySG.ResetOnSpawn = false end)
pcall(function() keySG.Parent = game:GetService("CoreGui") end)
if not keySG.Parent then pcall(function() keySG.Parent = LP.PlayerGui end) end

-- Colors for key system (black+red)
local KC = {
 bg = Color3.fromRGB(8, 8, 12),
 card = Color3.fromRGB(14, 14, 18),
 accent = Color3.fromRGB(220, 30, 30),
 accentDark = Color3.fromRGB(160, 20, 20),
 text = Color3.fromRGB(200, 200, 205),
 dim = Color3.fromRGB(100, 100, 110),
 white = Color3.fromRGB(255, 255, 255),
 input = Color3.fromRGB(20, 20, 26),
 green = Color3.fromRGB(0, 200, 70),
 red = Color3.fromRGB(220, 40, 40),
}

-- Fullscreen dimmer
local dimmer = Instance.new("Frame")
dimmer.Size = UDim2.new(1, 0, 1, 0)
dimmer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dimmer.BackgroundTransparency = 0.4
dimmer.BorderSizePixel = 0
dimmer.Parent = keySG

-- Key card
local keyCard = Instance.new("Frame")
keyCard.Size = UDim2.new(0, 340, 0, 280)
keyCard.Position = UDim2.new(0.5, -170, 0.5, -140)
keyCard.BackgroundColor3 = KC.card
keyCard.BorderSizePixel = 0
keyCard.Parent = keySG
pcall(function() Instance.new("UICorner", keyCard).CornerRadius = UDim.new(0, 12) end)

-- Title
local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, 0, 0, 36)
keyTitle.Position = UDim2.new(0, 0, 0, 10)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "LEGENDARY PARADISE"
keyTitle.TextColor3 = KC.accent
keyTitle.TextSize = 16
keyTitle.Font = Enum.Font.GothamBold
keyTitle.Parent = keyCard

local keyVer = Instance.new("TextLabel")
keyVer.Size = UDim2.new(1, 0, 0, 16)
keyVer.Position = UDim2.new(0, 0, 0, 40)
keyVer.BackgroundTransparency = 1
keyVer.Text = VERSION
keyVer.TextColor3 = KC.dim
keyVer.TextSize = 10
keyVer.Font = Enum.Font.Gotham
keyVer.Parent = keyCard

-- Key input
local keyInputFrame = Instance.new("Frame")
keyInputFrame.Size = UDim2.new(1, -40, 0, 34)
keyInputFrame.Position = UDim2.new(0, 20, 0, 70)
keyInputFrame.BackgroundColor3 = KC.input
keyInputFrame.BorderSizePixel = 0
keyInputFrame.Parent = keyCard
pcall(function() Instance.new("UICorner", keyInputFrame).CornerRadius = UDim.new(0, 8) end)

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -16, 1, 0)
keyInput.Position = UDim2.new(0, 8, 0, 0)
keyInput.BackgroundTransparency = 1
keyInput.Text = ""
keyInput.PlaceholderText = "Enter your key..."
keyInput.PlaceholderColor3 = KC.dim
keyInput.TextColor3 = KC.white
keyInput.TextSize = 12
keyInput.Font = Enum.Font.GothamBold
keyInput.ClearTextOnFocus = false
keyInput.Parent = keyInputFrame

-- Status label
local keyStatus = Instance.new("TextLabel")
keyStatus.Size = UDim2.new(1, -40, 0, 30)
keyStatus.Position = UDim2.new(0, 20, 0, 112)
keyStatus.BackgroundTransparency = 1
keyStatus.Text = ""
keyStatus.TextColor3 = KC.dim
keyStatus.TextSize = 10
keyStatus.Font = Enum.Font.Gotham
keyStatus.TextWrapped = true
keyStatus.Parent = keyCard

-- HWID display
local hwidLabel = Instance.new("TextLabel")
hwidLabel.Size = UDim2.new(1, -40, 0, 14)
hwidLabel.Position = UDim2.new(0, 20, 0, 140)
hwidLabel.BackgroundTransparency = 1
hwidLabel.Text = "HWID: "..string.sub(getHWID(), 1, 24).."..."
hwidLabel.TextColor3 = Color3.fromRGB(60, 60, 70)
hwidLabel.TextSize = 8
hwidLabel.Font = Enum.Font.Code
hwidLabel.TextXAlignment = Enum.TextXAlignment.Left
hwidLabel.Parent = keyCard

-- Activate button
local activateBtn = Instance.new("TextButton")
activateBtn.Size = UDim2.new(1, -40, 0, 36)
activateBtn.Position = UDim2.new(0, 20, 0, 164)
activateBtn.BackgroundColor3 = KC.accent
activateBtn.Text = "ACTIVATE"
activateBtn.TextColor3 = KC.white
activateBtn.TextSize = 13
activateBtn.Font = Enum.Font.GothamBold
activateBtn.BorderSizePixel = 0
activateBtn.Parent = keyCard
pcall(function() Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(0, 8) end)

-- Get Key button (Linkvertise)
local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Size = UDim2.new(1, -40, 0, 28)
getKeyBtn.Position = UDim2.new(0, 20, 0, 208)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
getKeyBtn.Text = "GET A KEY (Linkvertise)"
getKeyBtn.TextColor3 = KC.accent
getKeyBtn.TextSize = 10
getKeyBtn.Font = Enum.Font.GothamBold
getKeyBtn.BorderSizePixel = 0
getKeyBtn.Parent = keyCard
pcall(function() Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0, 6) end)

getKeyBtn.MouseButton1Click:Connect(function()
 pcall(function() setclipboard(LINKVERTISE_URL) end)
 keyStatus.Text = "Link copied to clipboard! Complete it to get your key."
 keyStatus.TextColor3 = KC.accent
end)

-- Credits
local creditsLbl = Instance.new("TextLabel")
creditsLbl.Size = UDim2.new(1, 0, 0, 16)
creditsLbl.Position = UDim2.new(0, 0, 1, -20)
creditsLbl.BackgroundTransparency = 1
creditsLbl.Text = "© LegendaryRvx"
creditsLbl.TextColor3 = Color3.fromRGB(50, 50, 56)
creditsLbl.TextSize = 9
creditsLbl.Font = Enum.Font.Gotham
creditsLbl.Parent = keyCard

-- ============================================================
-- KEY ACTIVATION LOGIC
-- ============================================================
local keyValid = false
local keyType = nil

activateBtn.MouseButton1Click:Connect(function()
 local input = keyInput.Text
 if input == "" then
  keyStatus.Text = "Please enter a key!"
  keyStatus.TextColor3 = KC.red
  return
 end
 
 local valid, ktype, msg = validateKey(input)
 if valid then
  keyStatus.Text = msg
  keyStatus.TextColor3 = KC.green
  keyValid = true
  keyType = ktype
  wait(1)
  keySG:Destroy()
 else
  keyStatus.Text = msg
  keyStatus.TextColor3 = KC.red
  keyInput.Text = ""
 end
end)

-- Also allow Enter key
keyInput.FocusLost:Connect(function(enterPressed)
 if enterPressed then activateBtn.MouseButton1Click:Fire() end
end)

-- Wait for key validation
while not keyValid do wait(0.5) end

-- ============================================================
-- MAIN SCRIPT STARTS HERE (only runs after key validation)
-- ============================================================
print("[LP] "..VERSION.." loading... (Key: "..tostring(keyType)..")")

local isAdmin = (keyType == "admin")

local DL = {}
local function dlog(m)
 local s = "["..string.format("%.1f", os.clock()).."] "..tostring(m)
 table.insert(DL, s)
 if isAdmin then print("[LP] "..tostring(m)) end
end
dlog("=== "..VERSION.." ===")

-- Modules
local Items, Cases, LevelCalc, Rarities, UpgMod
pcall(function()
 local M = RS:FindFirstChild("Modules") or RS:WaitForChild("Modules", 3)
 if M then
  pcall(function() Items = require(M:WaitForChild("Items", 3)) end)
  pcall(function() Cases = require(M:WaitForChild("Cases", 3)) end)
  pcall(function() LevelCalc = require(M:WaitForChild("LevelCalculator", 3)) end)
  pcall(function() Rarities = require(M:WaitForChild("Rarities", 3)) end)
  pcall(function() UpgMod = require(M:WaitForChild("Upgrader", 3)) end)
  dlog("Modules OK")
 else dlog("NO Modules") end
end)

-- Remotes
local Rem = RS:FindFirstChild("Remotes") or RS:WaitForChild("Remotes", 5)
local ocR, slR, exR, cbR, abR, upR, urR, ccR, clR
if Rem then
 ocR = Rem:FindFirstChild("OpenCase")
 slR = Rem:FindFirstChild("Sell")
 exR = Rem:FindFirstChild("ExchangeEvent")
 cbR = Rem:FindFirstChild("CreateBattle")
 abR = Rem:FindFirstChild("AddBot")
 upR = Rem:FindFirstChild("Upgrade")
 urR = Rem:FindFirstChild("UpdateRewards")
 ccR = Rem:FindFirstChild("CheckCooldown")
 clR = Rem:FindFirstChild("ClaimLevelReward") or Rem:FindFirstChild("ClaimReward") or Rem:FindFirstChild("CollectLevelReward")
 dlog("Remotes OK")
end

-- Helper functions
local function gInv()
 local pd = LP:FindFirstChild("PlayerData")
 if not pd then return nil end
 return pd:FindFirstChild("Inventory")
end
local function gBal()
 local pd = LP:FindFirstChild("PlayerData")
 if not pd then return 0 end
 local c = pd:FindFirstChild("Currencies")
 if not c then return 0 end
 local b = c:FindFirstChild("Balance")
 return b and b.Value or 0
end
local function gLvl()
 if not LevelCalc or not LevelCalc.CalculateLevel then return 0 end
 local pd = LP:FindFirstChild("PlayerData")
 if not pd then return 0 end
 local c = pd:FindFirstChild("Currencies")
 if not c then return 0 end
 local e = c:FindFirstChild("Experience")
 if not e then return 0 end
 local ok, d = pcall(function() return LevelCalc.CalculateLevel(e.Value) end)
 if ok and d then return d.Level or 0 end
 return 0
end
local function gPrice(item)
 if not Items then return 0 end
 local ok, d = pcall(function() return Items[item.Name] end)
 if not ok or not d or not d.Wears then return 0 end
 local w = nil; pcall(function() w = item:GetAttribute("Wear") end)
 local stt = false; pcall(function() stt = item:GetAttribute("Stattrak") == true end)
 if not w or not d.Wears[w] then for wn in pairs(d.Wears) do w = wn; break end end
 if not w or not d.Wears[w] then return 0 end
 local wd = d.Wears[w]
 if stt then return wd.StatTrak or wd.Normal or 0 else return wd.Normal or wd.StatTrak or 0 end
end
local function getWear(item) local w = nil; pcall(function() w = item:GetAttribute("Wear") end); return w end
local function getST(item) local s = false; pcall(function() s = item:GetAttribute("Stattrak") == true end); return s end
local function getUUID(item) local u = nil; pcall(function() u = item:GetAttribute("UUID") end); return u end
local function getItemAttrs(item) local t = {}; pcall(function() for k, v in pairs(item:GetAttributes()) do t[k] = v end end); return t end

-- Group case detection
local GC = nil
if Cases then
 for id, d in pairs(Cases) do
  if type(d) == "table" then
   if d.GroupOnly == true then GC = id; break end
   if d.Name and string.lower(tostring(d.Name)):find("group") then GC = id; break end
  end
 end
end
dlog("GC=" .. (GC and tostring(GC) or "nil") .. " Bal=" .. tostring(gBal()) .. " Lv=" .. tostring(gLvl()))

-- Global flags
_G.LP_FARM = false; _G.LP_SELL = false; _G.LP_EVENT = false; _G.LP_LEVEL = false
_G.LP_EXCHANGE = false; _G.LP_GIFTS = false; _G.LP_UPGRADER = false
_G.LP_ANTIAFK = false; _G.LP_AUTOBATTLE = false; _G.LP_LEVELREWARDS = false
_G.LP_XPFARM = false
_G.LP_FARM_CASE = GC or "Free"
_G.LP_SELL_MAX = 50; _G.LP_KEEP_ABOVE_PRICE = 500
_G.LP_UPGRADER_MIN_PRICE = 0; _G.LP_UPGRADER_MAX_PRICE = 50; _G.LP_UPGRADER_MULT = 2; _G.LP_UPGRADER_MAX_MONEY = 5000
_G.LP_BATTLE_BUDGET = 500; _G.LP_BATTLE_MIN_BAL = 100
_G.LP_BATTLE_MODE = "CRAZY TERMINAL"; _G.LP_BATTLE_CASES = {}
_G.LP_XP_BUDGET = 500; _G.LP_XP_CASE = nil; _G.LP_XP_QTY = 5; _G.LP_XP_EARN_TARGET = 500; _G.LP_XP_EARN_CASE = GC or "Free"
local st = {sessions = 0, casesOpened = 0, earned = 0, sold = 0, upgAttempts = 0, upgWins = 0, upgLosses = 0, upgProfit = 0, upgSpent = 0, battlesPlayed = 0, battlesWon = 0, battlesLost = 0, battleProfit = 0, xpSpent = 0, xpCases = 0, xpEarned = 0, xpPhase = "idle", xpW = 0, xpL = 0}

-- Core functions
local function openCase(cid, qty)
 if not ocR then return false end
 qty = qty or 1
 local ok, r = pcall(function() return ocR:InvokeServer(cid, qty, false, false) end)
 dlog("OC(" .. tostring(cid) .. "x" .. qty .. "): ok=" .. tostring(ok) .. " r=" .. tostring(r))
 return ok and r ~= false
end
local function buildSellEntry(item)
 local a = getItemAttrs(item)
 return {Name = item.Name, UUID = a.UUID, Wear = a.Wear, Stattrak = a.Stattrak or false, TimeObtained = a.TimeObtained or 0, Serial = a.Serial or 0, Numbered = a.Numbered or false, Locked = a.Locked or false, Escrow = a.Escrow or false, JackpotEscrow = a.JackpotEscrow or false, JackpotRoundId = a.JackpotRoundId or ""}
end
local function sellItems(items)
 if not slR then return false end
 local batch = {}
 for _, item in ipairs(items) do table.insert(batch, buildSellEntry(item)) end
 local ok, r = pcall(function() return slR:InvokeServer(batch) end)
 dlog("Sell(" .. #batch .. "): ok=" .. tostring(ok) .. " r=" .. tostring(r))
 return ok
end
local function sellOne(item) return sellItems({item}) end
local function findUpgradeTarget(srcPrice, mult)
 if not Items then return nil end
 local tp = srcPrice * mult; local bestK, bestN, bestW, bestP, bestST, bestDiff = nil, nil, nil, nil, false, math.huge
 for key, data in pairs(Items) do
  if type(data) == "table" and data.Wears then
   local name = data.Name or key
   for wn, wd in pairs(data.Wears) do
    if wd.Normal and wd.Normal > 0 then
     local d = math.abs(wd.Normal - tp); if d < bestDiff then bestK = key; bestN = name; bestW = wn; bestP = wd.Normal; bestST = false; bestDiff = d end
    end
    if wd.StatTrak and wd.StatTrak > 0 then
     local d = math.abs(wd.StatTrak - tp); if d < bestDiff then bestK = key; bestN = name; bestW = wn; bestP = wd.StatTrak; bestST = true; bestDiff = d end
    end
   end
  end
 end
 if bestK then return {Key = bestK, Instance = bestN, Name = bestN, Wear = bestW, Price = bestP, Stattrak = bestST} end
 return nil
end
local function doUpgrade(item, mult)
 if not upR then return false, "no upR" end
 local p = gPrice(item); if p <= 0 then return false, "no price" end
 local target = findUpgradeTarget(p, mult)
 if not target then return false, "no target" end
 local entry = buildSellEntry(item)
 dlog("Upg: " .. item.Name .. " $" .. p .. " x" .. mult .. " -> " .. target.Name .. " $" .. target.Price)
 local ok, r = pcall(function() upR:FireServer({entry}, target) end)
 dlog("  FireServer: ok=" .. tostring(ok) .. " r=" .. tostring(r))
 return ok, r
end

-- ============================================================
-- GUI — BLACK + RED THEME
-- ============================================================
pcall(function()
 if game:GetService("CoreGui"):FindFirstChild("LegendaryParadiseUI") then game:GetService("CoreGui").LegendaryParadiseUI:Destroy() end
 if LP.PlayerGui:FindFirstChild("LegendaryParadiseUI") then LP.PlayerGui.LegendaryParadiseUI:Destroy() end
end)

local sg = Instance.new("ScreenGui"); sg.Name = "LegendaryParadiseUI"
pcall(function() sg.ResetOnSpawn = false end)
pcall(function() sg.Parent = game:GetService("CoreGui") end)
if not sg.Parent then pcall(function() sg.Parent = LP.PlayerGui end) end

-- COLOR SCHEME: BLACK + RED
local C = {
 bg = Color3.fromRGB(8, 8, 12),
 sb = Color3.fromRGB(14, 14, 18),
 tb = Color3.fromRGB(16, 16, 20),
 cd = Color3.fromRGB(18, 18, 24),
 ac = Color3.fromRGB(220, 30, 30),       -- RED accent
 ton = Color3.fromRGB(220, 30, 30),      -- Toggle ON = red
 tof = Color3.fromRGB(40, 40, 48),       -- Toggle OFF = dark
 tx = Color3.fromRGB(200, 200, 205),
 td = Color3.fromRGB(100, 100, 110),
 tw = Color3.fromRGB(255, 255, 255),
 rd = Color3.fromRGB(180, 30, 30),
 bl = Color3.fromRGB(220, 30, 30),       -- Buttons also red
 pu = Color3.fromRGB(180, 0, 40),
 or2 = Color3.fromRGB(200, 50, 20),
 gn = Color3.fromRGB(180, 30, 30),
 lb = Color3.fromRGB(6, 6, 8),
}

-- Main frame
local mn = Instance.new("Frame"); mn.Name = "Main"; mn.Size = UDim2.new(0, 500, 0, 400); mn.Position = UDim2.new(0.5, -250, 0.5, -200); mn.BackgroundColor3 = C.bg; mn.BorderSizePixel = 0
pcall(function() mn.Active = true end); pcall(function() mn.Draggable = true end)
mn.Parent = sg; pcall(function() Instance.new("UICorner", mn).CornerRadius = UDim.new(0, 10) end)

-- Red accent line at top
local acLine = Instance.new("Frame"); acLine.Size = UDim2.new(1, 0, 0, 2); acLine.Position = UDim2.new(0, 0, 0, 0); acLine.BackgroundColor3 = C.ac; acLine.BorderSizePixel = 0; acLine.ZIndex = 5; acLine.Parent = mn

-- Top bar
local topb = Instance.new("Frame"); topb.Size = UDim2.new(1, 0, 0, 30); topb.BackgroundColor3 = C.tb; topb.BorderSizePixel = 0; topb.Parent = mn
pcall(function() Instance.new("UICorner", topb).CornerRadius = UDim.new(0, 10) end)
local tbf = Instance.new("Frame", topb); tbf.Size = UDim2.new(1, 0, 0, 10); tbf.Position = UDim2.new(0, 0, 1, -10); tbf.BackgroundColor3 = C.tb; tbf.BorderSizePixel = 0

local tl = Instance.new("TextLabel"); tl.Size = UDim2.new(1, -70, 1, 0); tl.Position = UDim2.new(0, 10, 0, 0); tl.BackgroundTransparency = 1; tl.Text = "LEGENDARY PARADISE"; tl.TextColor3 = C.ac; tl.TextSize = 12; tl.Font = Enum.Font.GothamBold; tl.TextXAlignment = Enum.TextXAlignment.Left; tl.Parent = topb

-- Key type badge
local badge = Instance.new("TextLabel"); badge.Size = UDim2.new(0, 60, 0, 14); badge.Position = UDim2.new(0.5, -30, 0.5, -7); badge.BackgroundColor3 = isAdmin and Color3.fromRGB(220, 170, 0) or C.ac; badge.Text = string.upper(tostring(keyType)); badge.TextColor3 = Color3.fromRGB(0, 0, 0); badge.TextSize = 8; badge.Font = Enum.Font.GothamBold; badge.BorderSizePixel = 0; badge.Parent = topb
pcall(function() Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 4) end)

local xb = Instance.new("TextButton"); xb.Size = UDim2.new(0, 24, 0, 20); xb.Position = UDim2.new(1, -30, 0, 5); xb.BackgroundColor3 = C.rd; xb.Text = "X"; xb.TextColor3 = C.tw; xb.TextSize = 11; xb.Font = Enum.Font.GothamBold; xb.BorderSizePixel = 0; xb.Parent = topb
pcall(function() Instance.new("UICorner", xb).CornerRadius = UDim.new(0, 5) end)
xb.MouseButton1Click:Connect(function() sg:Destroy() end)

local mmb = Instance.new("TextButton"); mmb.Size = UDim2.new(0, 24, 0, 20); mmb.Position = UDim2.new(1, -58, 0, 5); mmb.BackgroundColor3 = Color3.fromRGB(40, 40, 48); mmb.Text = "_"; mmb.TextColor3 = C.tx; mmb.TextSize = 11; mmb.Font = Enum.Font.GothamBold; mmb.BorderSizePixel = 0; mmb.Parent = topb
pcall(function() Instance.new("UICorner", mmb).CornerRadius = UDim.new(0, 5) end)
local bf = Instance.new("Frame"); bf.Size = UDim2.new(1, 0, 1, -30); bf.Position = UDim2.new(0, 0, 0, 30); bf.BackgroundTransparency = 1; bf.Parent = mn
mmb.MouseButton1Click:Connect(function() bf.Visible = not bf.Visible; mn.Size = bf.Visible and UDim2.new(0, 500, 0, 400) or UDim2.new(0, 500, 0, 30) end)

-- Sidebar
local sbar = Instance.new("Frame"); sbar.Size = UDim2.new(0, 85, 1, 0); sbar.BackgroundColor3 = C.sb; sbar.BorderSizePixel = 0; sbar.Parent = bf
pcall(function() Instance.new("UICorner", sbar).CornerRadius = UDim.new(0, 8) end)
local ca = Instance.new("Frame"); ca.Size = UDim2.new(1, -90, 1, -4); ca.Position = UDim2.new(0, 88, 0, 2); ca.BackgroundTransparency = 1; ca.Parent = bf

-- TABS: No Debug tab in commercial
local tP, tB, aT = {}, {}, nil
local tD = {{"Dash"}, {"Auto"}, {"Battle"}, {"Upgr"}, {"Config"}}
-- Admin gets extra Exploit tab
if isAdmin then table.insert(tD, 4, {"Exploit"}) end

local function swT(n)
 aT = n
 for k, p in pairs(tP) do p.Visible = (k == n) end
 for k, b in pairs(tB) do
  if k == n then b.BackgroundColor3 = C.ac; b.TextColor3 = Color3.fromRGB(0, 0, 0)
  else b.BackgroundColor3 = Color3.fromRGB(24, 24, 30); b.TextColor3 = C.tx end
 end
end
for i, d in ipairs(tD) do
 local b = Instance.new("TextButton"); b.Size = UDim2.new(1, -8, 0, 22); b.Position = UDim2.new(0, 4, 0, 3 + (i - 1) * 26); b.BackgroundColor3 = Color3.fromRGB(24, 24, 30); b.Text = d[1]; b.TextColor3 = C.tx; b.TextSize = 9; b.Font = Enum.Font.GothamBold; b.BorderSizePixel = 0; b.Parent = sbar
 pcall(function() Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6) end)
 tB[d[1]] = b; b.MouseButton1Click:Connect(function() swT(d[1]) end)
end
for _, d in ipairs(tD) do
 local s = Instance.new("ScrollingFrame"); s.Size = UDim2.new(1, 0, 1, 0); s.BackgroundTransparency = 1; s.BorderSizePixel = 0; s.ScrollBarThickness = 4; s.ScrollBarImageColor3 = C.ac; s.CanvasSize = UDim2.new(0, 0, 0, 2000); s.Visible = false; s.Parent = ca
 local l = Instance.new("UIListLayout"); l.SortOrder = Enum.SortOrder.LayoutOrder; l.Padding = UDim.new(0, 3); l.Parent = s
 pcall(function() l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() s.CanvasSize = UDim2.new(0, 0, 0, l.AbsoluteContentSize.Y + 10) end) end)
 local p = Instance.new("UIPadding"); p.PaddingLeft = UDim.new(0, 3); p.PaddingRight = UDim.new(0, 3); p.PaddingTop = UDim.new(0, 3); p.Parent = s
 tP[d[1]] = s
end

-- UI Helpers
local function mSec(p, t, o) local l = Instance.new("TextLabel"); l.Size = UDim2.new(1, 0, 0, 16); l.BackgroundTransparency = 1; l.Text = "— " .. t .. " —"; l.TextColor3 = C.ac; l.TextSize = 9; l.Font = Enum.Font.GothamBold; l.LayoutOrder = o or 0; l.Parent = p end
local function mLbl(p, t, o) local l = Instance.new("TextLabel"); l.Size = UDim2.new(1, 0, 0, 14); l.BackgroundTransparency = 1; l.Text = t; l.TextColor3 = C.tx; l.TextSize = 9; l.Font = Enum.Font.Gotham; l.TextXAlignment = Enum.TextXAlignment.Left; l.TextWrapped = true; l.LayoutOrder = o or 0; l.Parent = p; return l end
local function mTog(p, lt, fl, co, o)
 local r = Instance.new("Frame"); r.Size = UDim2.new(1, 0, 0, 24); r.BackgroundColor3 = C.cd; r.BorderSizePixel = 0; r.LayoutOrder = o or 0; r.Parent = p
 pcall(function() Instance.new("UICorner", r).CornerRadius = UDim.new(0, 6) end)
 local l = Instance.new("TextLabel"); l.Size = UDim2.new(1, -50, 1, 0); l.Position = UDim2.new(0, 6, 0, 0); l.BackgroundTransparency = 1; l.Text = lt; l.TextColor3 = C.tx; l.TextSize = 9; l.Font = Enum.Font.Gotham; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r
 local b = Instance.new("TextButton"); b.Size = UDim2.new(0, 38, 0, 16); b.Position = UDim2.new(1, -42, 0.5, -8); b.BorderSizePixel = 0; b.TextSize = 9; b.Font = Enum.Font.GothamBold; b.Parent = r
 pcall(function() Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5) end)
 local function rf() if _G[fl] then b.BackgroundColor3 = co or C.ton; b.Text = "ON"; b.TextColor3 = C.tw else b.BackgroundColor3 = C.tof; b.Text = "OFF"; b.TextColor3 = C.td end end
 b.MouseButton1Click:Connect(function() _G[fl] = not _G[fl]; rf(); dlog(fl .. "=" .. ((_G[fl]) and "ON" or "OFF")) end); rf()
end
local function mBtn(p, t, c, cb, o) local b = Instance.new("TextButton"); b.Size = UDim2.new(1, 0, 0, 24); b.BackgroundColor3 = c or C.bl; b.Text = t; b.TextColor3 = C.tw; b.TextSize = 9; b.Font = Enum.Font.GothamBold; b.BorderSizePixel = 0; b.LayoutOrder = o or 0; b.Parent = p; pcall(function() Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6) end); b.MouseButton1Click:Connect(cb); return b end
local function mInput(p, lbl, def, gkey, o)
 local r = Instance.new("Frame"); r.Size = UDim2.new(1, 0, 0, 22); r.BackgroundColor3 = C.cd; r.BorderSizePixel = 0; r.LayoutOrder = o or 0; r.Parent = p
 pcall(function() Instance.new("UICorner", r).CornerRadius = UDim.new(0, 6) end)
 local l = Instance.new("TextLabel"); l.Size = UDim2.new(0, 95, 1, 0); l.Position = UDim2.new(0, 6, 0, 0); l.BackgroundTransparency = 1; l.Text = lbl; l.TextColor3 = C.tx; l.TextSize = 9; l.Font = Enum.Font.Gotham; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r
 local tb2 = Instance.new("TextBox"); tb2.Size = UDim2.new(1, -103, 1, -4); tb2.Position = UDim2.new(0, 99, 0, 2); tb2.BackgroundColor3 = Color3.fromRGB(24, 24, 30); tb2.Text = tostring(def); tb2.TextColor3 = C.ac; tb2.TextSize = 9; tb2.Font = Enum.Font.GothamBold; tb2.BorderSizePixel = 0; tb2.ClearTextOnFocus = false; tb2.Parent = r
 pcall(function() Instance.new("UICorner", tb2).CornerRadius = UDim.new(0, 4) end)
 tb2.FocusLost:Connect(function() _G[gkey] = tonumber(tb2.Text) or def end)
 return tb2
end
local logQ, logLbl = {}, nil
local function log(m) dlog(m); table.insert(logQ, tostring(m)); if #logQ > 10 then table.remove(logQ, 1) end; if logLbl then logLbl.Text = table.concat(logQ, "\n") end end

-- ============================================================
-- DASH TAB
-- ============================================================
pcall(function()
 local pg = tP["Dash"]
 mSec(pg, "LEGENDARY PARADISE " .. VERSION, 1)
 if isAdmin then
  local al = mLbl(pg, "ADMIN MODE ACTIVE", 2); al.TextColor3 = Color3.fromRGB(220, 170, 0); al.Font = Enum.Font.GothamBold
 end
 mSec(pg, "PLAYER", 3); local il = mLbl(pg, "...", 4)
 mSec(pg, "STATS", 7); local sl = mLbl(pg, "...", 8)
 mSec(pg, "LIVE LOG", 9)
 local lb = Instance.new("Frame"); lb.Size = UDim2.new(1, 0, 0, 120); lb.BackgroundColor3 = C.lb; lb.BorderSizePixel = 0; lb.LayoutOrder = 10; lb.Parent = pg
 pcall(function() Instance.new("UICorner", lb).CornerRadius = UDim.new(0, 6) end)
 logLbl = Instance.new("TextLabel"); logLbl.Size = UDim2.new(1, -6, 1, -4); logLbl.Position = UDim2.new(0, 3, 0, 2); logLbl.BackgroundTransparency = 1; logLbl.Text = "..."; logLbl.TextColor3 = Color3.fromRGB(220, 80, 80); logLbl.TextSize = 8; logLbl.Font = Enum.Font.Code; logLbl.TextXAlignment = Enum.TextXAlignment.Left; logLbl.TextYAlignment = Enum.TextYAlignment.Top; logLbl.TextWrapped = true; logLbl.Parent = lb
 coroutine.resume(coroutine.create(function() while wait(2) do pcall(function()
  il.Text = "Lv:" .. tostring(gLvl()) .. " $" .. tostring(math.floor(gBal()))
  local xpS = ""; if _G.LP_XPFARM then xpS = " | XP:" .. st.xpPhase .. " $" .. math.floor(st.xpSpent) .. "/$" .. _G.LP_XP_BUDGET end
  sl.Text = "S:" .. st.sessions .. " C:" .. st.casesOpened .. " Sold:" .. st.sold .. " $" .. math.floor(st.earned) .. xpS
 end) end end))
end)

-- ============================================================
-- AUTO TAB
-- ============================================================
pcall(function()
 local pg = tP["Auto"]
 mSec(pg, "AUTO FARM", 1); mTog(pg, "Auto Farm", "LP_FARM", C.ac, 2)
 local fcl = mLbl(pg, "Case: " .. tostring(_G.LP_FARM_CASE), 3); fcl.TextColor3 = C.ac
 local acn = {}
 if Cases then for id, d in pairs(Cases) do if type(d) == "table" and d.Name then table.insert(acn, {id = id, name = d.Name, price = d.Price or 0}) end end; table.sort(acn, function(a, b) return a.price < b.price end) end
 local fcf = Instance.new("Frame"); fcf.Size = UDim2.new(1, 0, 0, 65); fcf.BackgroundColor3 = Color3.fromRGB(12, 12, 16); fcf.BorderSizePixel = 0; fcf.LayoutOrder = 4; fcf.Parent = pg
 pcall(function() Instance.new("UICorner", fcf).CornerRadius = UDim.new(0, 6) end)
 local fcs = Instance.new("ScrollingFrame"); fcs.Size = UDim2.new(1, -4, 1, -4); fcs.Position = UDim2.new(0, 2, 0, 2); fcs.BackgroundTransparency = 1; fcs.BorderSizePixel = 0; fcs.ScrollBarThickness = 3; fcs.CanvasSize = UDim2.new(0, 0, 0, #acn * 18 + 8); fcs.Parent = fcf
 local fcL = Instance.new("UIListLayout"); fcL.SortOrder = Enum.SortOrder.LayoutOrder; fcL.Padding = UDim.new(0, 1); fcL.Parent = fcs
 local fcBs = {}
 for idx, e in ipairs(acn) do
  local sel = (e.id == _G.LP_FARM_CASE)
  local fb = Instance.new("TextButton"); fb.Size = UDim2.new(1, -4, 0, 16); fb.BackgroundColor3 = sel and C.ac or C.cd; fb.Text = e.name .. (e.price > 0 and (" $" .. e.price) or " FREE"); fb.TextColor3 = sel and Color3.fromRGB(0, 0, 0) or C.tx; fb.TextSize = 8; fb.Font = Enum.Font.Gotham; fb.TextXAlignment = Enum.TextXAlignment.Left; fb.BorderSizePixel = 0; fb.LayoutOrder = idx; fb.Parent = fcs
  pcall(function() Instance.new("UICorner", fb).CornerRadius = UDim.new(0, 4) end)
  fcBs[e.id] = fb
  fb.MouseButton1Click:Connect(function() _G.LP_FARM_CASE = e.id; fcl.Text = "Case: " .. e.name; for k, v in pairs(fcBs) do if k == e.id then v.BackgroundColor3 = C.ac; v.TextColor3 = Color3.fromRGB(0, 0, 0) else v.BackgroundColor3 = C.cd; v.TextColor3 = C.tx end end end)
 end
 mSec(pg, "AUTO SELL", 10); mTog(pg, "Auto Sell", "LP_SELL", C.or2, 11)
 mInput(pg, "Keep above $", 500, "LP_KEEP_ABOVE_PRICE", 12)
 mInput(pg, "Max sell/cy", 50, "LP_SELL_MAX", 13)
 mSec(pg, "XP FARM", 14); mTog(pg, "XP Farm", "LP_XPFARM", Color3.fromRGB(220, 30, 80), 15)
 local xpSl = mLbl(pg, "XP: idle | W:0 L:0 | Spent:$0", 16); xpSl.TextColor3 = Color3.fromRGB(220, 100, 120)
 mInput(pg, "Min balance $", 500, "LP_XP_BUDGET", 17)
 mInput(pg, "Cases/open", 5, "LP_XP_QTY", 18)
 mInput(pg, "Earn target $", 500, "LP_XP_EARN_TARGET", 19)
 local xpCl = mLbl(pg, "XP Case: (auto)", 20); xpCl.TextColor3 = C.ac
 local xpBs = {}
 local acnXP = {}
 if Cases then for id, d in pairs(Cases) do if type(d) == "table" and d.Name and d.Price and d.Price > 0 and d.Price <= 100 then table.insert(acnXP, {id = id, name = d.Name, price = d.Price}) end end; table.sort(acnXP, function(a, b) return a.price < b.price end) end
 if #acnXP > 0 and not _G.LP_XP_CASE then _G.LP_XP_CASE = acnXP[1].id end
 xpCl.Text = "XP Case: " .. ((_G.LP_XP_CASE and tostring(_G.LP_XP_CASE)) or "auto")
 local xpFr = Instance.new("Frame"); xpFr.Size = UDim2.new(1, 0, 0, 55); xpFr.BackgroundColor3 = Color3.fromRGB(12, 12, 16); xpFr.BorderSizePixel = 0; xpFr.LayoutOrder = 21; xpFr.Parent = pg
 pcall(function() Instance.new("UICorner", xpFr).CornerRadius = UDim.new(0, 6) end)
 local xpSc = Instance.new("ScrollingFrame"); xpSc.Size = UDim2.new(1, -4, 1, -4); xpSc.Position = UDim2.new(0, 2, 0, 2); xpSc.BackgroundTransparency = 1; xpSc.BorderSizePixel = 0; xpSc.ScrollBarThickness = 3; xpSc.CanvasSize = UDim2.new(0, 0, 0, #acnXP * 18 + 8); xpSc.Parent = xpFr
 local xpLL = Instance.new("UIListLayout"); xpLL.SortOrder = Enum.SortOrder.LayoutOrder; xpLL.Padding = UDim.new(0, 1); xpLL.Parent = xpSc
 for idx, e in ipairs(acnXP) do
  local sel = (e.id == _G.LP_XP_CASE)
  local xb2 = Instance.new("TextButton"); xb2.Size = UDim2.new(1, -4, 0, 16); xb2.BackgroundColor3 = sel and C.ac or C.cd; xb2.Text = e.name .. " $" .. e.price; xb2.TextColor3 = sel and Color3.fromRGB(0, 0, 0) or C.tx; xb2.TextSize = 8; xb2.Font = Enum.Font.Gotham; xb2.TextXAlignment = Enum.TextXAlignment.Left; xb2.BorderSizePixel = 0; xb2.LayoutOrder = idx; xb2.Parent = xpSc
  pcall(function() Instance.new("UICorner", xb2).CornerRadius = UDim.new(0, 4) end)
  xpBs[e.id] = xb2
  xb2.MouseButton1Click:Connect(function() _G.LP_XP_CASE = e.id; xpCl.Text = "XP Case: " .. e.name; for k, v in pairs(xpBs) do if k == e.id then v.BackgroundColor3 = C.ac; v.TextColor3 = Color3.fromRGB(0, 0, 0) else v.BackgroundColor3 = C.cd; v.TextColor3 = C.tx end end end)
 end
 local earnCl = mLbl(pg, "Earn Case: " .. tostring(_G.LP_XP_EARN_CASE), 22); earnCl.TextColor3 = C.ac
 local earnBs = {}
 local earnFr = Instance.new("Frame"); earnFr.Size = UDim2.new(1, 0, 0, 45); earnFr.BackgroundColor3 = Color3.fromRGB(12, 12, 16); earnFr.BorderSizePixel = 0; earnFr.LayoutOrder = 23; earnFr.Parent = pg
 pcall(function() Instance.new("UICorner", earnFr).CornerRadius = UDim.new(0, 6) end)
 local earnSc = Instance.new("ScrollingFrame"); earnSc.Size = UDim2.new(1, -4, 1, -4); earnSc.Position = UDim2.new(0, 2, 0, 2); earnSc.BackgroundTransparency = 1; earnSc.BorderSizePixel = 0; earnSc.ScrollBarThickness = 3; earnSc.CanvasSize = UDim2.new(0, 0, 0, #acn * 18 + 8); earnSc.Parent = earnFr
 local earnLL = Instance.new("UIListLayout"); earnLL.SortOrder = Enum.SortOrder.LayoutOrder; earnLL.Padding = UDim.new(0, 1); earnLL.Parent = earnSc
 for idx, e in ipairs(acn) do
  local sel2 = (e.id == _G.LP_XP_EARN_CASE)
  local eb = Instance.new("TextButton"); eb.Size = UDim2.new(1, -4, 0, 16); eb.BackgroundColor3 = sel2 and C.ac or C.cd; eb.Text = e.name .. (e.price > 0 and (" $" .. e.price) or " FREE"); eb.TextColor3 = sel2 and Color3.fromRGB(0, 0, 0) or C.tx; eb.TextSize = 8; eb.Font = Enum.Font.Gotham; eb.TextXAlignment = Enum.TextXAlignment.Left; eb.BorderSizePixel = 0; eb.LayoutOrder = idx; eb.Parent = earnSc
  pcall(function() Instance.new("UICorner", eb).CornerRadius = UDim.new(0, 4) end)
  earnBs[e.id] = eb
  eb.MouseButton1Click:Connect(function() _G.LP_XP_EARN_CASE = e.id; earnCl.Text = "Earn Case: " .. e.name; for k, v in pairs(earnBs) do if k == e.id then v.BackgroundColor3 = C.ac; v.TextColor3 = Color3.fromRGB(0, 0, 0) else v.BackgroundColor3 = C.cd; v.TextColor3 = C.tx end end end)
 end
 coroutine.resume(coroutine.create(function() while wait(1) do pcall(function() xpSl.Text = "XP: " .. st.xpPhase .. " | W:" .. st.xpW .. " L:" .. st.xpL .. " | $" .. math.floor(st.xpSpent) .. " spent | Bal:$" .. math.floor(gBal()) end) end end))
 mSec(pg, "AUTO LEVEL (old)", 24); mTog(pg, "Auto Level", "LP_LEVEL", C.ac, 25)
 mSec(pg, "EXTRAS", 26); mTog(pg, "Level Rewards", "LP_LEVELREWARDS", C.ac, 27); mTog(pg, "Events", "LP_EVENT", C.pu, 28); mTog(pg, "Exchange", "LP_EXCHANGE", C.ac, 29); mTog(pg, "Gifts", "LP_GIFTS", C.ac, 30)
 mBtn(pg, "ALL ON", C.ac, function() _G.LP_FARM = true; _G.LP_SELL = true; _G.LP_EVENT = true; _G.LP_LEVEL = true; _G.LP_EXCHANGE = true; _G.LP_GIFTS = true; _G.LP_LEVELREWARDS = true; _G.LP_XPFARM = true; log("All ON"); swT("Auto") end, 33)
 mBtn(pg, "ALL OFF", C.rd, function() _G.LP_FARM = false; _G.LP_SELL = false; _G.LP_EVENT = false; _G.LP_LEVEL = false; _G.LP_EXCHANGE = false; _G.LP_GIFTS = false; _G.LP_LEVELREWARDS = false; _G.LP_XPFARM = false; log("All OFF"); swT("Auto") end, 34)
end)

-- ============================================================
-- BATTLE TAB
-- ============================================================
pcall(function()
 local pg = tP["Battle"]
 local acn2 = {}
 if Cases then for id, d in pairs(Cases) do if type(d) == "table" and d.Name and d.ForBattles then table.insert(acn2, {id = id, name = d.Name, price = d.Price or 0}) end end; table.sort(acn2, function(a, b) return a.price < b.price end) end
 local bm = {"CLASSIC", "TERMINAL", "CRAZY TERMINAL", "SHARED", "JESTER", "JACKPOT", "CRAZY JACKPOT"}
 mSec(pg, "CASES (multi)", 1)
 local scl = mLbl(pg, "Selected: 0", 2); scl.TextColor3 = C.ac
 local htl = mLbl(pg, "L-click +1 | R-click -1", 2); htl.TextSize = 7; htl.TextColor3 = Color3.fromRGB(100, 100, 110)
 local function updSel() local n = 0; for _, c in pairs(_G.LP_BATTLE_CASES) do n = n + c end; scl.Text = "Selected: " .. n end
 local function updBtn(cb, e) local c = _G.LP_BATTLE_CASES[e.id] or 0; if c > 0 then cb.BackgroundColor3 = C.ac; cb.TextColor3 = Color3.fromRGB(0, 0, 0); cb.Text = e.name .. " $" .. e.price .. " x" .. c else cb.BackgroundColor3 = C.cd; cb.TextColor3 = C.tx; cb.Text = e.name .. " $" .. e.price end end
 local clf = Instance.new("Frame"); clf.Size = UDim2.new(1, 0, 0, 90); clf.BackgroundColor3 = Color3.fromRGB(12, 12, 16); clf.BorderSizePixel = 0; clf.LayoutOrder = 3; clf.Parent = pg
 pcall(function() Instance.new("UICorner", clf).CornerRadius = UDim.new(0, 6) end)
 local csc = Instance.new("ScrollingFrame"); csc.Size = UDim2.new(1, -4, 1, -4); csc.Position = UDim2.new(0, 2, 0, 2); csc.BackgroundTransparency = 1; csc.BorderSizePixel = 0; csc.ScrollBarThickness = 3; csc.CanvasSize = UDim2.new(0, 0, 0, math.max(300, #acn2 * 20)); csc.Parent = clf
 local cL = Instance.new("UIListLayout"); cL.SortOrder = Enum.SortOrder.LayoutOrder; cL.Padding = UDim.new(0, 1); cL.Parent = csc
 local cBs = {}
 for idx, e in ipairs(acn2) do
  local cb = Instance.new("TextButton"); cb.Size = UDim2.new(1, -4, 0, 18); cb.BackgroundColor3 = C.cd; cb.Text = e.name .. " $" .. e.price; cb.TextColor3 = C.tx; cb.TextSize = 8; cb.Font = Enum.Font.Gotham; cb.TextXAlignment = Enum.TextXAlignment.Left; cb.BorderSizePixel = 0; cb.LayoutOrder = idx; cb.Parent = csc
  pcall(function() Instance.new("UICorner", cb).CornerRadius = UDim.new(0, 4) end)
  table.insert(cBs, {btn = cb, name = e.name, id = e.id, price = e.price})
  cb.MouseButton1Click:Connect(function()
   _G.LP_BATTLE_CASES[e.id] = (_G.LP_BATTLE_CASES[e.id] or 0) + 1; updBtn(cb, e); updSel()
  end)
  cb.MouseButton2Click:Connect(function()
   local c = (_G.LP_BATTLE_CASES[e.id] or 0) - 1; if c <= 0 then _G.LP_BATTLE_CASES[e.id] = nil else _G.LP_BATTLE_CASES[e.id] = c end; updBtn(cb, e); updSel()
  end)
 end
 mBtn(pg, "Select ALL", C.ac, function() for _, e in ipairs(cBs) do _G.LP_BATTLE_CASES[e.id] = 1; updBtn(e.btn, e) end; updSel() end, 4)
 mBtn(pg, "Clear ALL", C.rd, function() _G.LP_BATTLE_CASES = {}; for _, e in ipairs(cBs) do updBtn(e.btn, e) end; updSel() end, 5)
 mSec(pg, "MODE", 6)
 local mf = Instance.new("Frame"); mf.Size = UDim2.new(1, 0, 0, 48); mf.BackgroundTransparency = 1; mf.LayoutOrder = 7; mf.Parent = pg
 local mBs = {}
 for i, m in ipairs(bm) do
  local col = math.ceil(i / 4); local row = ((i - 1) % 4)
  local mb2 = Instance.new("TextButton"); mb2.Size = UDim2.new(0.245, -2, 0, 20); mb2.Position = UDim2.new(row * 0.25, 1, 0, (col - 1) * 24); mb2.BackgroundColor3 = (m == "CRAZY TERMINAL") and C.ac or C.cd; mb2.Text = m; mb2.TextColor3 = (m == "CRAZY TERMINAL") and Color3.fromRGB(0, 0, 0) or C.tx; mb2.TextSize = 7; mb2.Font = Enum.Font.GothamBold; mb2.BorderSizePixel = 0; mb2.Parent = mf
  pcall(function() Instance.new("UICorner", mb2).CornerRadius = UDim.new(0, 5) end)
  mBs[m] = mb2
  mb2.MouseButton1Click:Connect(function() _G.LP_BATTLE_MODE = m; for k, v in pairs(mBs) do if k == m then v.BackgroundColor3 = C.ac; v.TextColor3 = Color3.fromRGB(0, 0, 0) else v.BackgroundColor3 = C.cd; v.TextColor3 = C.tx end end end)
 end
 mBtn(pg, "CREATE BATTLE", C.ac, function()
  local cids = {}; for id, cnt in pairs(_G.LP_BATTLE_CASES) do for _i = 1, cnt do table.insert(cids, tostring(id)) end end
  if #cids == 0 then log("Select cases!"); return end
  if not cbR then log("No cbR!"); return end
  local bal1 = gBal()
  dlog("Battle: " .. #cids .. " cases mode=" .. _G.LP_BATTLE_MODE)
  local ok, bid = pcall(function() return cbR:InvokeServer(cids, 2, _G.LP_BATTLE_MODE, false) end)
  dlog("CB: ok=" .. tostring(ok) .. " bid=" .. tostring(bid))
  if ok and bid and abR then
   wait(0.6); pcall(function() abR:FireServer(tonumber(bid), LP) end)
   st.battlesPlayed = st.battlesPlayed + 1
   log("Battle #" .. st.battlesPlayed .. " waiting...")
   wait(12)
   local bal2 = gBal(); local diff = bal2 - bal1
   if diff > 0 then st.battlesWon = st.battlesWon + 1; st.battleProfit = st.battleProfit + diff; log("WIN +$" .. math.floor(diff))
   else st.battlesLost = st.battlesLost + 1; st.battleProfit = st.battleProfit + diff; log("LOSS $" .. math.floor(diff)) end
  end
 end, 8)
 mSec(pg, "AUTO BATTLE", 10); mTog(pg, "Auto Battle", "LP_AUTOBATTLE", C.pu, 11)
 mInput(pg, "Budget $", 500, "LP_BATTLE_BUDGET", 12)
 mInput(pg, "Min Bal $", 100, "LP_BATTLE_MIN_BAL", 13)
 mSec(pg, "STATS", 16); local bsl = mLbl(pg, "P:0 W:0 L:0 $0", 17)
 mBtn(pg, "Reset", C.rd, function() st.battlesPlayed = 0; st.battlesWon = 0; st.battlesLost = 0; st.battleProfit = 0 end, 18)
 coroutine.resume(coroutine.create(function() while wait(2) do pcall(function() bsl.Text = "P:" .. st.battlesPlayed .. " W:" .. st.battlesWon .. " L:" .. st.battlesLost .. " $" .. math.floor(st.battleProfit) end) end end))
end)

-- ============================================================
-- UPGR TAB
-- ============================================================
pcall(function()
 local pg = tP["Upgr"]
 mSec(pg, "UPGRADER", 1); mTog(pg, "Auto Upgrader", "LP_UPGRADER", C.or2, 2)
 mSec(pg, "MULT", 4)
 local mBs2 = {}; local mr2 = Instance.new("Frame"); mr2.Size = UDim2.new(1, 0, 0, 22); mr2.BackgroundTransparency = 1; mr2.LayoutOrder = 5; mr2.Parent = pg
 for i, m in ipairs({2, 3, 5, 10}) do
  local b = Instance.new("TextButton"); b.Size = UDim2.new(0.24, -3, 1, 0); b.Position = UDim2.new((i - 1) * 0.25, 2, 0, 0); b.BackgroundColor3 = m == 2 and C.ac or C.cd; b.Text = m .. "x"; b.TextColor3 = m == 2 and Color3.fromRGB(0, 0, 0) or C.tx; b.TextSize = 9; b.Font = Enum.Font.GothamBold; b.BorderSizePixel = 0; b.Parent = mr2
  pcall(function() Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5) end); mBs2[m] = b
  b.MouseButton1Click:Connect(function() _G.LP_UPGRADER_MULT = m; for k, v in pairs(mBs2) do if k == m then v.BackgroundColor3 = C.ac; v.TextColor3 = Color3.fromRGB(0, 0, 0) else v.BackgroundColor3 = C.cd; v.TextColor3 = C.tx end end end)
 end
 mSec(pg, "LIMITS", 6)
 mInput(pg, "Max money $", 5000, "LP_UPGRADER_MAX_MONEY", 7)
 mInput(pg, "Min item $", 0, "LP_UPGRADER_MIN_PRICE", 8)
 mInput(pg, "Max item $", 50, "LP_UPGRADER_MAX_PRICE", 9)
 mSec(pg, "STATS", 10); local us = mLbl(pg, "A:0 W:0 L:0 $0", 11)
 mBtn(pg, "Reset", C.rd, function() st.upgAttempts = 0; st.upgWins = 0; st.upgLosses = 0; st.upgProfit = 0; st.upgSpent = 0 end, 12)
 coroutine.resume(coroutine.create(function() while wait(2) do pcall(function() us.Text = "A:" .. st.upgAttempts .. " W:" .. st.upgWins .. " L:" .. st.upgLosses .. " $" .. math.floor(st.upgProfit) .. " Sp:$" .. math.floor(st.upgSpent) end) end end))
end)

-- ============================================================
-- EXPLOIT TAB (admin only)
-- ============================================================
if isAdmin then
 pcall(function()
  local pg = tP["Exploit"]
  mSec(pg, "ADMIN TOOLS (visual only)", 1)
  mBtn(pg, "Money $999k (visual)", C.ac, function() pcall(function() local pd = LP:FindFirstChild("PlayerData"); local c = pd and pd:FindFirstChild("Currencies"); local b = c and c:FindFirstChild("Balance"); if b then b.Value = 999999; log("$999k visual") end end) end, 2)
  mBtn(pg, "Tickets 9999 (visual)", C.pu, function() pcall(function() local pd = LP:FindFirstChild("PlayerData"); local c = pd and c:FindFirstChild("Currencies"); local t = c and c:FindFirstChild("Tickets"); if t then t.Value = 9999; log("Tix visual") end end) end, 3)
 end)
end

-- ============================================================
-- CONFIG TAB
-- ============================================================
pcall(function()
 local pg = tP["Config"]
 mSec(pg, "GENERAL", 1); mTog(pg, "Anti-AFK", "LP_ANTIAFK", C.ac, 2)
 mSec(pg, "INFO", 4)
 mLbl(pg, SCRIPT_NAME .. " " .. VERSION, 5)
 mLbl(pg, "Key: " .. string.upper(tostring(keyType)), 6)
 mLbl(pg, "HWID: " .. string.sub(getHWID(), 1, 20) .. "...", 7)
 mLbl(pg, "© LegendaryRvx", 8)
 mBtn(pg, "Destroy GUI", C.rd, function() sg:Destroy() end, 9)
 -- Admin: show debug log
 if isAdmin then
  mSec(pg, "ADMIN DEBUG", 10)
  local dbgF = Instance.new("Frame"); dbgF.Size = UDim2.new(1, 0, 0, 140); dbgF.BackgroundColor3 = Color3.fromRGB(5, 5, 8); dbgF.BorderSizePixel = 0; dbgF.LayoutOrder = 11; dbgF.Parent = pg
  pcall(function() Instance.new("UICorner", dbgF).CornerRadius = UDim.new(0, 6) end)
  local dbgBox = Instance.new("TextBox"); dbgBox.Size = UDim2.new(1, -6, 1, -6); dbgBox.Position = UDim2.new(0, 3, 0, 3); dbgBox.BackgroundTransparency = 1; dbgBox.Text = table.concat(DL, "\n"); dbgBox.TextColor3 = Color3.fromRGB(220, 80, 80); dbgBox.TextSize = 7; dbgBox.Font = Enum.Font.Code; dbgBox.TextXAlignment = Enum.TextXAlignment.Left; dbgBox.TextYAlignment = Enum.TextYAlignment.Top; dbgBox.TextWrapped = true; dbgBox.ClearTextOnFocus = false; dbgBox.MultiLine = true; dbgBox.TextEditable = false; dbgBox.Parent = dbgF
  mBtn(pg, "REFRESH LOG", C.ac, function() dbgBox.Text = table.concat(DL, "\n") end, 12)
  coroutine.resume(coroutine.create(function() while wait(5) do pcall(function() dbgBox.Text = table.concat(DL, "\n") end) end end))
 end
end)

swT("Dash")
log(VERSION .. " loaded $" .. math.floor(gBal()) .. " Lv" .. tostring(gLvl()))
log("Key: " .. string.upper(tostring(keyType)) .. " | Farm: " .. tostring(_G.LP_FARM_CASE))

-- ============================================================
-- QUICK SELL HELPER
-- ============================================================
local function quickSell()
 if not slR then return end
 pcall(function()
  local inv = gInv(); if not inv then return end
  local kp = _G.LP_KEEP_ABOVE_PRICE or 500; local batch = {}
  for _, it in ipairs(inv:GetChildren()) do
   if #batch >= 30 then break end
   if not it:GetAttribute("Locked") then local p = gPrice(it); if p > 0 and p < kp then table.insert(batch, it) end end
  end
  if #batch > 0 then
   local entries = {}; for _, item in ipairs(batch) do table.insert(entries, buildSellEntry(item)) end
   pcall(function() slR:InvokeServer(entries) end)
   st.sold = st.sold + #batch
  end
 end)
end

-- ============================================================
-- LEVEL REWARDS ENGINE
-- ============================================================
local lvlCases = {"LEVEL10", "LEVEL20", "LEVEL30", "LEVEL40", "LEVEL50", "LEVEL60", "LEVEL70", "LEVEL80", "LEVEL90", "LEVELS100", "LEVELS110", "LEVELS120"}
local lvlThresholds = {LEVEL10 = 10, LEVEL20 = 20, LEVEL30 = 30, LEVEL40 = 40, LEVEL50 = 50, LEVEL60 = 60, LEVEL70 = 70, LEVEL80 = 80, LEVEL90 = 90, LEVELS100 = 100, LEVELS110 = 110, LEVELS120 = 120}
local lvlCooldowns = {}
_G.LP_LEVEL_ACTIVE = false

-- P0: Level rewards
coroutine.resume(coroutine.create(function()
 while wait(10) do
  if _G.LP_LEVELREWARDS and ocR and ccR then
   pcall(function()
    local pLvl = gLvl()
    local now = os.time()
    local eligible = {}
    for _, lv in ipairs(lvlCases) do
     local req = lvlThresholds[lv] or 999
     if req <= pLvl then table.insert(eligible, lv) end
    end
    if #eligible == 0 then return end
    local ready = {}
    for _, lv in ipairs(eligible) do
     local cdEnd = lvlCooldowns[lv] or 0
     if cdEnd > now then
      -- still on cooldown
     else
      local ok2, r2 = pcall(function() return ccR:InvokeServer(lv) end)
      dlog("LVL CC(" .. lv .. "): " .. tostring(r2))
      if ok2 and type(r2) == "number" and r2 > now then
       lvlCooldowns[lv] = r2
      elseif ok2 and (r2 == 0 or r2 == true or r2 == false or (type(r2) == "number" and r2 <= now)) then
       table.insert(ready, lv)
      else
       lvlCooldowns[lv] = now + 120
      end
      wait(0.5)
     end
    end
    if #ready == 0 then return end
    log("LVL: " .. #ready .. " cases ready, pausing farm...")
    _G.LP_LEVEL_ACTIVE = true
    wait(2)
    for i, lv in ipairs(ready) do
     if not _G.LP_LEVELREWARDS then break end
     local curLvl = gLvl()
     local req = lvlThresholds[lv] or 999
     if req > curLvl then break end
     log("LVL opening " .. lv .. " (" .. i .. "/" .. #ready .. ")")
     local ok, r = pcall(function() return ocR:InvokeServer(lv, 1, false, false) end)
     if ok and r and r ~= false and r ~= "" and r ~= 0 then
      log("LEVEL " .. lv .. " OPENED!")
      st.casesOpened = st.casesOpened + 1
      quickSell()
     else
      lvlCooldowns[lv] = os.time() + 600
     end
     if Rem then
      wait(1)
      for _, rn in ipairs({"ClaimLevelReward", "ClaimReward", "CollectLevelReward", "CollectReward", "RedeemReward"}) do
       local rm = Rem:FindFirstChild(rn)
       if rm then pcall(function() rm:InvokeServer(lv) end); pcall(function() rm:FireServer(lv) end) end
      end
     end
     if i < #ready then wait(10) end
    end
    _G.LP_LEVEL_ACTIVE = false
    log("LVL: cycle done, farm resumed")
   end)
  end
 end
end))

-- ============================================================
-- P1-P4: XP FARM / EARN / FARM / BATTLES
-- ============================================================
coroutine.resume(coroutine.create(function()
 while wait(0.2) do
  if not _G.LP_LEVEL_ACTIVE then
  pcall(function()
   -- P3: XP FARM
   if _G.LP_XPFARM then
    local minBal = _G.LP_XP_BUDGET or 500
    local xpCase = _G.LP_XP_CASE
    local xpQty = _G.LP_XP_QTY or 5
    if not xpCase then
     if Cases then for id, d in pairs(Cases) do if type(d) == "table" and d.Price and d.Price > 0 and d.Price <= 100 then xpCase = id; break end end end
     if xpCase then _G.LP_XP_CASE = xpCase end
    end
    if xpCase then
     local bal = gBal()
     local casePrice = 0
     if Cases and Cases[xpCase] and Cases[xpCase].Price then casePrice = Cases[xpCase].Price end
     local costPerOpen = casePrice * xpQty; if costPerOpen <= 0 then costPerOpen = xpQty end
     if bal > minBal and bal >= costPerOpen then
      st.xpPhase = "SPENDING"
      local bal1 = gBal()
      local ok = openCase(xpCase, xpQty)
      wait(0.2); local bal2 = gBal(); local cost = bal1 - bal2
      if cost > 0 then st.xpSpent = st.xpSpent + cost end
      if ok then st.xpCases = st.xpCases + xpQty; st.xpW = st.xpW + 1 else st.xpL = st.xpL + 1 end
      st.casesOpened = st.casesOpened + xpQty
      quickSell()
      return
     end
    end
   end
   -- P3.5: EARN CASES
   if _G.LP_XPFARM or (_G.LP_FARM and not _G.LP_XPFARM) then
    local earnCase = _G.LP_XP_EARN_CASE or GC or "Free"
    if _G.LP_FARM and not _G.LP_XPFARM then earnCase = _G.LP_FARM_CASE or GC or "Free" end
    if _G.LP_XPFARM then st.xpPhase = "EARNING" end
    local casePrice = 0
    if Cases and Cases[earnCase] and Cases[earnCase].Price then casePrice = Cases[earnCase].Price end
    local eq = (casePrice <= 0) and 5 or 1
    local ebal1 = gBal()
    local ok = openCase(earnCase, eq)
    if not ok then
     if eq > 1 then ok = openCase(earnCase, 1); eq = 1 end
    end
    wait(0.2); quickSell(); wait(0.1)
    local ebal2 = gBal(); local diff = ebal2 - ebal1
    if diff > 0 and _G.LP_XPFARM then st.xpEarned = st.xpEarned + diff end
    st.casesOpened = st.casesOpened + eq
    if _G.LP_FARM and not _G.LP_XPFARM then st.sessions = st.sessions + 1 end
    return
   end
   -- P4: AUTO BATTLE
   if _G.LP_AUTOBATTLE and cbR and abR then
    local mb = _G.LP_BATTLE_MIN_BAL or 100; local bal = gBal()
    if bal - mb >= 10 then
     local cids = {}; for id, cnt in pairs(_G.LP_BATTLE_CASES) do for _i = 1, cnt do table.insert(cids, tostring(id)) end end
     if #cids == 0 and Cases then
      local cn = {}; for id, d in pairs(Cases) do if type(d) == "table" and d.Price and d.Price > 0 and d.ForBattles then table.insert(cn, {id = id, price = d.Price}) end end
      table.sort(cn, function(a, b) return a.price < b.price end)
      local lim = math.min(_G.LP_BATTLE_BUDGET or 500, bal - mb)
      for _, c in ipairs(cn) do if c.price <= lim * 0.5 then table.insert(cids, tostring(c.id)) end end
     end
     if #cids > 0 then
      local bal1 = gBal()
      local ok, bid = pcall(function() return cbR:InvokeServer(cids, 2, _G.LP_BATTLE_MODE or "CRAZY TERMINAL", false) end)
      if ok and bid then
       wait(0.6); pcall(function() abR:FireServer(tonumber(bid), LP) end)
       st.battlesPlayed = st.battlesPlayed + 1; wait(12)
       local bal2 = gBal(); local diff = bal2 - bal1
       if diff > 0 then st.battlesWon = st.battlesWon + 1; st.battleProfit = st.battleProfit + diff; log("AB W +$" .. math.floor(diff))
       else st.battlesLost = st.battlesLost + 1; st.battleProfit = st.battleProfit + diff; log("AB L $" .. math.floor(diff)) end
      end
     end
    end
   end
  end)
  end -- if not LP_LEVEL_ACTIVE
 end
end))

-- ============================================================
-- AUTO SELL (independent)
-- ============================================================
coroutine.resume(coroutine.create(function()
 while wait(2) do
  if _G.LP_SELL then
   pcall(function()
    local inv = gInv(); if not inv then return end
    local kp = _G.LP_KEEP_ABOVE_PRICE or 500; local mx = _G.LP_SELL_MAX or 50
    local batch = {}
    for _, i in ipairs(inv:GetChildren()) do
     if #batch >= mx then break end
     if not i:GetAttribute("Locked") then local p = gPrice(i); if p > 0 and p < kp then table.insert(batch, i) end end
    end
    if #batch > 0 then
     local entries = {}; for _, item in ipairs(batch) do table.insert(entries, buildSellEntry(item)) end
     local bal1 = gBal(); pcall(function() slR:InvokeServer(entries) end); wait(0.5); local bal2 = gBal()
     if bal2 > bal1 then st.earned = st.earned + (bal2 - bal1); st.sold = st.sold + #batch; log("Sold " .. #batch .. " +$" .. math.floor(bal2 - bal1))
     else for _, item in ipairs(batch) do if not _G.LP_SELL then break end; sellOne(item); wait(0.3) end end
    end
   end); wait(3)
  end
 end
end))

-- ============================================================
-- EVENTS (independent — TP to meteorites)
-- ============================================================
coroutine.resume(coroutine.create(function()
 while wait(1) do
  if _G.LP_EVENT then
   pcall(function()
    local met = WS:FindFirstChild("Meteorites") or WS:FindFirstChild("Events") or WS:FindFirstChild("Meteors")
    if not met then return end
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local origPos = hrp.CFrame
    for _, m in ipairs(met:GetChildren()) do
     if not _G.LP_EVENT then break end
     pcall(function()
      local pos = nil
      if m:IsA("BasePart") then pos = m.CFrame
      elseif m:IsA("Model") and m.PrimaryPart then pos = m.PrimaryPart.CFrame
      elseif m:IsA("Model") then
       local p = m:FindFirstChildWhichIsA("BasePart", true)
       if p then pos = p.CFrame end
      end
      if pos then hrp.CFrame = pos + Vector3.new(0, 3, 0); wait(0.3) end
      local cd = m:FindFirstChild("ClickDetector")
      if cd then fireclickdetector(cd) end
      local pp = m:FindFirstChild("ProximityPrompt")
      if pp then fireproximityprompt(pp) end
      pcall(function() firetouchinterest(hrp, m, 0); wait(0.1); firetouchinterest(hrp, m, 1) end)
     end)
     wait(0.3)
    end
    pcall(function() if hrp and origPos then hrp.CFrame = origPos end end)
   end); wait(5)
  end
 end
end))

-- ============================================================
-- EXCHANGE / GIFTS (independent)
-- ============================================================
coroutine.resume(coroutine.create(function()
 while wait(1) do if _G.LP_EXCHANGE and exR then pcall(function() exR:FireServer() end); wait(10) end end
end))
coroutine.resume(coroutine.create(function()
 while wait(1) do
  if _G.LP_GIFTS then
   pcall(function()
    if urR then
     for i = 1, 9 do
      pcall(function() urR:InvokeServer("Gift" .. i) end)
      wait(0.5)
     end
     dlog("GIFTS: claimed Gift1-Gift9")
    end
   end); wait(60)
  end
 end
end))

-- ============================================================
-- UPGRADER (independent)
-- ============================================================
coroutine.resume(coroutine.create(function()
 while wait(1) do
  if _G.LP_UPGRADER and upR then
   pcall(function()
    local maxM = _G.LP_UPGRADER_MAX_MONEY or 5000
    if st.upgSpent >= maxM then wait(5); return end
    local inv = gInv(); if not inv then return end
    local best = nil; local bp = math.huge
    local mn2 = _G.LP_UPGRADER_MIN_PRICE or 0; local mx = _G.LP_UPGRADER_MAX_PRICE or 50
    for _, i in ipairs(inv:GetChildren()) do
     if not i:GetAttribute("Locked") then
      local p = gPrice(i); if p >= mn2 and p <= mx and p > 0 and p < bp then bp = p; best = i end
     end
    end
    if best then
     if st.upgSpent + bp > maxM then wait(3); return end
     local m = _G.LP_UPGRADER_MULT or 2; local bal1 = gBal()
     st.upgAttempts = st.upgAttempts + 1; st.upgSpent = st.upgSpent + bp
     local ok, r = doUpgrade(best, m)
     dlog("AutoUpg: ok=" .. tostring(ok) .. " r=" .. tostring(r))
     wait(1.5); local bal2 = gBal(); local diff = bal2 - bal1
     if diff > 0 then st.upgWins = st.upgWins + 1; st.upgProfit = st.upgProfit + diff; log("Upg W +$" .. math.floor(diff))
     else st.upgLosses = st.upgLosses + 1; st.upgProfit = st.upgProfit + diff; log("Upg L") end
    end
   end); wait(2)
  end
 end
end))

-- ============================================================
-- ANTI-AFK
-- ============================================================
coroutine.resume(coroutine.create(function()
 while wait(1) do if _G.LP_ANTIAFK then pcall(function() local vu = game:GetService("VirtualUser"); vu:CaptureController(); vu:ClickButton2(Vector2.new()) end); wait(30) end end
end))

log("Ready! — " .. SCRIPT_NAME .. " " .. VERSION)
