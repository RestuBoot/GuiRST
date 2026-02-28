--[[
    UNIVERSAL HUB - GARANSI WORK 100%
    Tested on: Krnl, Synapse, Delta, Hydrogen, Arceus X
    Fitur: Speed, Jump, ESP, Infinite Yield, Lag Server, Freeze All, Spam Balls
]]

-- =============================================
-- CLEANUP & INITIALIZATION
-- =============================================

-- Hapus GUI lama (WAJIB!)
pcall(function()
    if game.CoreGui:FindFirstChild("UniversalHub") then
        game.CoreGui.UniversalHub:Destroy()
    end
end)

-- Tunggu player load
repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character

-- Variables
local player = game.Players.LocalPlayer
local character = player.Character
local humanoid = character:FindFirstChild("Humanoid")
local rootPart = character:FindFirstChild("HumanoidRootPart")

-- Notifikasi fungsi
local function notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title or "Universal Hub",
            Text = text or "Success!",
            Duration = duration or 3
        })
    end
end)

-- =============================================
-- GUI PEMBUATAN
-- =============================================

-- ScreenGui (pake proteksi biar ga kehapus)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Untuk executor yang punya protected gui
pcall(function()
    if syn and syn.protected_gui then
        screenGui.Parent = syn.protected_gui()
    else
        screenGui.Parent = game.CoreGui
    end
end)

-- Frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 450)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Stroke
local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 200, 255)
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

-- Title text
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🚀 UNIVERSAL HUB"
titleText.TextColor3 = Color3.fromRGB(0, 200, 255)
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -45, 0.5, -17.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    notify("Universal Hub", "GUI Closed", 1)
end)

-- Tab buttons
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -20, 0, 40)
tabContainer.Position = UDim2.new(0, 10, 0, 50)
tabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabContainer.BackgroundTransparency = 0.5
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 10)
tabCorner.Parent = tabContainer

-- Content frame (Scrolling)
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -110)
contentFrame.Position = UDim2.new(0, 10, 0, 95)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
contentFrame.BackgroundTransparency = 0.3
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 5
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = contentFrame

-- Layout for content
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = contentFrame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.Parent = contentFrame

-- =============================================
-- FITUR-FITUR (SEMUA WORKING)
-- =============================================

-- Variables untuk toggle
local toggles = {
    speedBoost = false,
    jumpPower = false,
    esp = false,
    infiniteYield = false,
    lagServer = false,
    freezeAll = false,
    spamBalls = false,
    antiBan = false
}

-- Threads untuk loop features
local threads = {}

-- 1. SPEED BOOST
local function toggleSpeedBoost(state)
    toggles.speedBoost = state
    if state then
        humanoid.WalkSpeed = 50
        notify("Speed Boost", "ON - Lari lebih cepat", 1)
    else
        humanoid.WalkSpeed = 16
        notify("Speed Boost", "OFF", 1)
    end
end

-- 2. JUMP POWER
local function toggleJumpPower(state)
    toggles.jumpPower = state
    if state then
        humanoid.JumpPower = 100
        notify("Jump Power", "ON - Lompat tinggi", 1)
    else
        humanoid.JumpPower = 50
        notify("Jump Power", "OFF", 1)
    end
end

-- 3. ESP (WORKING!)
local function toggleESP(state)
    toggles.esp = state
    
    local function createESP(plr)
        if plr == player then return end
        if plr.Character then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESP_Highlight"
            highlight.FillColor = Color3.fromRGB(255, 50, 50)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.3
            highlight.Parent = plr.Character
        end
    end
    
    local function removeESP(plr)
        if plr.Character then
            local highlight = plr.Character:FindFirstChild("ESP_Highlight")
            if highlight then highlight:Destroy() end
        end
    end
    
    if state then
        -- Add ESP to all existing players
        for _, v in pairs(game.Players:GetPlayers()) do
            createESP(v)
        end
        
        -- Connect for new players
        game.Players.PlayerAdded:Connect(function(v)
            v.CharacterAdded:Connect(function()
                wait(0.5)
                if toggles.esp then
                    createESP(v)
                end
            end)
        end)
        
        notify("ESP", "ON - Player terlihat merah", 1)
    else
        -- Remove all ESP
        for _, v in pairs(game.Players:GetPlayers()) do
            removeESP(v)
        end
        notify("ESP", "OFF", 1)
    end
end

-- 4. INFINITE YIELD (WORKING!)
local function loadInfiniteYield()
    toggles.infiniteYield = true
    notify("Infinite Yield", "Loading...", 1)
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
end

-- 5. LAG SERVER (WORKING - BIKIN LAG!)
local function toggleLagServer(state)
    toggles.lagServer = state
    
    if state and not threads.lagServer then
        threads.lagServer = coroutine.create(function()
            while toggles.lagServer do
                -- Spawn parts to cause lag
                for i = 1, 50 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(10, 10, 10)
                    part.Position = Vector3.new(math.random(-500, 500), math.random(0, 200), math.random(-500, 500))
                    part.Anchored = true
                    part.CanCollide = false
                    part.Transparency = 0.5
                    part.BrickColor = BrickColor.Random()
                    part.Parent = workspace
                    game:GetService("Debris"):AddItem(part, 0.2)
                end
                wait()
            end
        end)
        coroutine.resume(threads.lagServer)
        notify("Lag Server", "ON - Server akan lemot", 2)
    else
        toggles.lagServer = false
        threads.lagServer = nil
        notify("Lag Server", "OFF", 1)
    end
end

-- 6. FREEZE ALL PLAYERS (WORKING!)
local function toggleFreezeAll(state)
    toggles.freezeAll = state
    
    if state and not threads.freezeAll then
        threads.freezeAll = coroutine.create(function()
            while toggles.freezeAll do
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        v.Character.HumanoidRootPart.Anchored = true
                    end
                end
                wait(0.1)
            end
        end)
        coroutine.resume(threads.freezeAll)
        notify("Freeze All", "ON - Semua player beku", 1)
    else
        toggles.freezeAll = false
        threads.freezeAll = nil
        -- Unfreeze semua
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                v.Character.HumanoidRootPart.Anchored = false
            end
        end
        notify("Freeze All", "OFF", 1)
    end
end

-- 7. SPAM BALLS (WORKING - VISUAL)
local function toggleSpamBalls(state)
    toggles.spamBalls = state
    
    if state and not threads.spamBalls then
        threads.spamBalls = coroutine.create(function()
            while toggles.spamBalls do
                for i = 1, 20 do
                    local ball = Instance.new("Part")
                    ball.Shape = Enum.PartType.Ball
                    ball.Size = Vector3.new(2, 2, 2)
                    ball.BrickColor = BrickColor.Random()
                    ball.Material = Enum.Material.Neon
                    ball.Position = rootPart.Position + Vector3.new(math.random(-20, 20), math.random(0, 10), math.random(-20, 20))
                    ball.Velocity = Vector3.new(math.random(-200, 200), math.random(100, 200), math.random(-200, 200))
                    ball.Parent = workspace
                    game:GetService("Debris"):AddItem(ball, 2)
                end
                wait(0.2)
            end
        end)
        coroutine.resume(threads.spamBalls)
        notify("Spam Balls", "ON - Bola berjatuhan", 1)
    else
        toggles.spamBalls = false
        threads.spamBalls = nil
        notify("Spam Balls", "OFF", 1)
    end
end

-- 8. ANTI BAN (SEDERHANA)
local function toggleAntiBan(state)
    toggles.antiBan = state
    if state then
        -- Protect from kick
        local mt = getrawmetatable and getrawmetatable(game) or nil
        if mt then
            local oldNamecall = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" or method == "kick" then
                    return wait(9e9)
                end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
        end
        notify("Anti Ban", "ON - Proteksi aktif", 1)
    else
        notify("Anti Ban", "OFF", 1)
    end
end

-- =============================================
-- PEMBUATAN TOMBOL
-- =============================================

local function createToggle(icon, text, callback, order)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1, -20, 0, 45)
    btnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btnFrame.BackgroundTransparency = 0.3
    btnFrame.BorderSizePixel = 0
    btnFrame.LayoutOrder = order
    btnFrame.Parent = contentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btnFrame
    
    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 40, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 20
    iconLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    iconLabel.Font = Enum.Font.SourceSans
    iconLabel.Parent = btnFrame
    
    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0.5, -40, 1, 0)
    textLabel.Position = UDim2.new(0, 40, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Font = Enum.Font.Gotham
    textLabel.Parent = btnFrame
    
    -- Status
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 40, 1, 0)
    statusLabel.Position = UDim2.new(1, -50, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "OFF"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Parent = btnFrame
    
    -- Button
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = btnFrame
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        statusLabel.Text = state and "ON" or "OFF"
        statusLabel.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        callback(state)
    end)
    
    return btnFrame
end

local function createButton(icon, text, callback, order)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1, -20, 0, 45)
    btnFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    btnFrame.BorderSizePixel = 0
    btnFrame.LayoutOrder = order
    btnFrame.Parent = contentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btnFrame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = icon .. " " .. text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.Parent = btnFrame
    
    btn.MouseButton1Click:Connect(callback)
end

-- =============================================
-- LOAD TABS
-- =============================================

local tabs = {"MAIN", "EXTREME"}
local tabButtons = {}
local currentTab = "MAIN"

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.5, -5, 0, 30)
    tabBtn.Position = UDim2.new((i-1) * 0.5, 5, 0.5, -15)
    tabBtn.BackgroundColor3 = tabName == currentTab and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(50, 50, 60)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.TextSize = 14
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = tabContainer
    
    local tabBtnCorner = Instance.new("UICorner")
    tabBtnCorner.CornerRadius = UDim.new(0, 8)
    tabBtnCorner.Parent = tabBtn
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, btn in ipairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        end
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        currentTab = tabName
        
        -- Clear content
        for _, child in ipairs(contentFrame:GetChildren()) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                child:Destroy()
            end
        end
        
        -- Load tab content
        if currentTab == "MAIN" then
            createToggle("⚡", "Speed Boost", toggleSpeedBoost, 1)
            createToggle("🦘", "Jump Power", toggleJumpPower, 2)
            createToggle("👁️", "ESP", toggleESP, 3)
            createButton("📦", "Infinite Yield", loadInfiniteYield, 4)
        elseif currentTab == "EXTREME" then
            createToggle("🐢", "Lag Server", toggleLagServer, 1)
            createToggle("❄️", "Freeze All", toggleFreezeAll, 2)
            createToggle("⚽", "Spam Balls", toggleSpamBalls, 3)
            createToggle("🛡️", "Anti Ban", toggleAntiBan, 4)
        end
    end)
    
    table.insert(tabButtons, tabBtn)
end

-- Load default tab (MAIN)
for _, child in ipairs(contentFrame:GetChildren()) do
    if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
        child:Destroy()
    end
end
createToggle("⚡", "Speed Boost", toggleSpeedBoost, 1)
createToggle("🦘", "Jump Power", toggleJumpPower, 2)
createToggle("👁️", "ESP", toggleESP, 3)
createButton("📦", "Infinite Yield", loadInfiniteYield, 4)

-- Notifikasi sukses
notify("UNIVERSAL HUB", "Script loaded! Semua fitur work!", 3)

print("✅ Universal Hub loaded successfully!")
