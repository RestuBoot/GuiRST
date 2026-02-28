--[[
    UNIVERSAL HUB - GARANSI WORK 100% (VERSION FIX)
    Tested on: Codex, Krnl, Synapse, Delta, Hydrogen
]]

-- Hapus GUI lama
pcall(function() game.CoreGui.UniversalHub:Destroy() end)

-- Tunggu player
repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local player = game.Players.LocalPlayer
local char = player.Character
local humanoid = char:FindFirstChildOfClass("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")

-- Notifikasi
local function notify(txt)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Universal Hub",
            Text = txt,
            Duration = 2
        })
    end)
end

-- GUI
local lib = {}

-- Pastikan panggilan ke getrawmetatable tidak error
local mt = getrawmetatable and getrawmetatable(game) or nil
if mt then
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then
            return
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalHub"
screenGui.ResetOnSpawn = false
pcall(function()
    if syn and syn.protected_gui then
        screenGui.Parent = syn.protected_gui()
    else
        screenGui.Parent = game.CoreGui
    end
end)

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 400)
main.Position = UDim2.new(0.5, -160, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = main

-- Title
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🚀 UNIVERSAL HUB"
titleText.TextColor3 = Color3.fromRGB(0, 200, 255)
titleText.TextSize = 18
titleText.TextXAlignment = "Left"
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0.5, -15)
close.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.TextSize = 18
close.Font = Enum.Font.GothamBold
close.BorderSizePixel = 0
close.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Tab Container
local tabs = {"MAIN", "EXTREME"}
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 35)
tabFrame.Position = UDim2.new(0, 10, 0, 45)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabFrame.BackgroundTransparency = 0.3
tabFrame.BorderSizePixel = 0
tabFrame.Parent = main

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 10)
tabCorner.Parent = tabFrame

-- Content
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -20, 1, -100)
content.Position = UDim2.new(0, 10, 0, 85)
content.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
content.BackgroundTransparency = 0.3
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.AutomaticCanvasSize = "Y"
content.Parent = main

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 10)
contentCorner.Parent = content

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = "Center"
layout.SortOrder = "LayoutOrder"
layout.Parent = content

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.Parent = content

-- Variables
local toggles = {
    speed = false,
    jump = false,
    esp = false,
    iy = false,
    lag = false,
    freeze = false,
    balls = false
}

-- ========== FITUR ==========

-- Speed
local function toggleSpeed(v)
    toggles.speed = v
    humanoid.WalkSpeed = v and 50 or 16
    notify(v and "Speed ON" or "Speed OFF")
end

-- Jump
local function toggleJump(v)
    toggles.jump = v
    humanoid.JumpPower = v and 100 or 50
    notify(v and "Jump ON" or "Jump OFF")
end

-- ESP
local function toggleESP(v)
    toggles.esp = v
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            if v then
                local h = Instance.new("Highlight")
                h.Name = "ESP_Highlight"
                h.FillColor = Color3.fromRGB(255, 50, 50)
                h.FillTransparency = 0.4
                h.Parent = p.Character
            else
                local h = p.Character:FindFirstChildOfClass("Highlight")
                if h then h:Destroy() end
            end
        end
    end
    notify(v and "ESP ON" or "ESP OFF")
end

-- Infinite Yield
local function loadIY()
    toggles.iy = true
    notify("Loading IY...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end

-- Lag Server
local lagThread
local function toggleLag(v)
    toggles.lag = v
    if v then
        lagThread = task.spawn(function()
            while toggles.lag do
                for i = 1, 30 do
                    local p = Instance.new("Part")
                    p.Size = Vector3.new(5,5,5)
                    p.Position = Vector3.new(math.random(-200,200), math.random(10,100), math.random(-200,200))
                    p.Anchored = true
                    p.CanCollide = false
                    p.Transparency = 0.8
                    p.Parent = workspace
                    task.spawn(function() task.wait(0.5) p:Destroy() end)
                end
                task.wait()
            end
        end)
    else
        toggles.lag = false
        if lagThread then task.cancel(lagThread) end
    end
    notify(v and "Lag Server ON" or "Lag Server OFF")
end

-- Freeze All
local freezeThread
local function toggleFreeze(v)
    toggles.freeze = v
    if v then
        freezeThread = task.spawn(function()
            while toggles.freeze do
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.Anchored = true
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        toggles.freeze = false
        if freezeThread then task.cancel(freezeThread) end
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Anchored = false
            end
        end
    end
    notify(v and "Freeze All ON" or "Freeze All OFF")
end

-- Spam Balls
local ballsThread
local function toggleBalls(v)
    toggles.balls = v
    if v then
        ballsThread = task.spawn(function()
            while toggles.balls do
                for i = 1, 15 do
                    local b = Instance.new("Part")
                    b.Shape = "Ball"
                    b.Size = Vector3.new(2,2,2)
                    b.BrickColor = BrickColor.Random()
                    b.Material = "Neon"
                    b.Position = root.Position + Vector3.new(math.random(-20,20), math.random(0,10), math.random(-20,20))
                    b.Velocity = Vector3.new(math.random(-150,150), math.random(50,150), math.random(-150,150))
                    b.Parent = workspace
                    task.spawn(function() task.wait(2) b:Destroy() end)
                end
                task.wait(0.2)
            end
        end)
    else
        toggles.balls = false
        if ballsThread then task.cancel(ballsThread) end
    end
    notify(v and "Spam Balls ON" or "Spam Balls OFF")
end

-- ========== UI BUILD ==========

local function createToggle(icon, text, callback, order)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.LayoutOrder = order
    frame.Parent = content

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 8)
    fCorner.Parent = frame

    local ic = Instance.new("TextLabel")
    ic.Size = UDim2.new(0, 40, 1, 0)
    ic.BackgroundTransparency = 1
    ic.Text = icon
    ic.TextSize = 20
    ic.TextColor3 = Color3.fromRGB(0, 200, 255)
    ic.Font = Enum.Font.SourceSans
    ic.Parent = frame

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0.5, -40, 1, 0)
    txt.Position = UDim2.new(0, 40, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = text
    txt.TextColor3 = Color3.new(1,1,1)
    txt.TextXAlignment = "Left"
    txt.Font = Enum.Font.Gotham
    txt.TextSize = 14
    txt.Parent = frame

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0, 40, 1, 0)
    status.Position = UDim2.new(1, -50, 0, 0)
    status.BackgroundTransparency = 1
    status.Text = "OFF"
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
    status.Font = Enum.Font.GothamBold
    status.TextSize = 12
    status.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        status.Text = state and "ON" or "OFF"
        status.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        callback(state)
    end)
end

local function createButton(icon, text, callback, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    btn.Text = icon .. " " .. text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = content

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

-- Tabs
local tabBtns = {}
local currentTab = "MAIN"

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -5, 0, 25)
    btn.Position = UDim2.new((i-1) * 0.5, 5, 0.5, -12.5)
    btn.BackgroundColor3 = name == "MAIN" and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(50, 50, 60)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = tabFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(tabBtns) do
            b.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        currentTab = name

        -- Clear content
        for _, v in ipairs(content:GetChildren()) do
            if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
                v:Destroy()
            end
        end

        -- Load content
        if currentTab == "MAIN" then
            createToggle("⚡", "Speed Boost", toggleSpeed, 1)
            createToggle("🦘", "Jump Power", toggleJump, 2)
            createToggle("👁️", "ESP", toggleESP, 3)
            createButton("📦", "Infinite Yield", loadIY, 4)
        else
            createToggle("🐢", "Lag Server", toggleLag, 1)
            createToggle("❄️", "Freeze All", toggleFreeze, 2)
            createToggle("⚽", "Spam Balls", toggleBalls, 3)
        end
    end)

    table.insert(tabBtns, btn)
end

-- Load MAIN tab by default
createToggle("⚡", "Speed Boost", toggleSpeed, 1)
createToggle("🦘", "Jump Power", toggleJump, 2)
createToggle("👁️", "ESP", toggleESP, 3)
createButton("📦", "Infinite Yield", loadIY, 4)

notify("✅ Script Loaded!")
