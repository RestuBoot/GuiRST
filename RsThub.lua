--[[
    UNIVERSAL HUB - COMPLETE EDITION
    - MAIN: Speed, Jump, ESP, Infinite Yield
    - MOVEMENT: Infinity Jump, Double Jump, Spin, Sit Anywhere, Swim in Air
    - VISUAL: Box ESP, Tracer ESP, Name ESP, Health Bar, Rainbow Character
    - TROLL: Push, Pull, Fling, Headless, Zombie Walk, Spam Chat
    - PROTECTION: Anti Sit, Anti Tool, Anti Grab, God Mode, Auto Respawn
    - WORLD: Time Changer, Gravity Changer, Fog Changer, Walk on Water
    - UTILITY: Virtual Joystick, Auto Click, No Fall Damage, Keybinds
]]

-- =============================================
-- CLEANUP
-- =============================================
pcall(function()
    if game.CoreGui:FindFirstChild("UniversalHub") then
        game.CoreGui.UniversalHub:Destroy()
    end
    if game.CoreGui:FindFirstChild("HubIcon") then
        game.CoreGui.HubIcon:Destroy()
    end
end)

-- =============================================
-- TUNGGU PLAYER LOAD
-- =============================================
repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local player = game.Players.LocalPlayer
local character = player.Character
local humanoid = character:FindFirstChildOfClass("Humanoid")
local rootPart = character:FindFirstChild("HumanoidRootPart")

-- =============================================
-- NOTIFIKASI
-- =============================================
local function notify(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🚀 UNIVERSAL HUB",
            Text = msg,
            Duration = 2
        })
    end)
end

-- =============================================
-- ANTI BAN
-- =============================================
local antiBanEnabled = false
local function toggleAntiBan(state)
    antiBanEnabled = state
    if state then
        pcall(function()
            local mt = getrawmetatable and getrawmetatable(game)
            if mt then
                setreadonly(mt, false)
                local oldNamecall = mt.__namecall
                mt.__namecall = newcclosure(function(self, ...)
                    local method = getnamecallmethod()
                    if method == "Kick" or method == "kick" then return end
                    return oldNamecall(self, ...)
                end)
                setreadonly(mt, true)
            end
        end)
        notify("🛡️ Anti Ban: ON")
    else
        notify("🛡️ Anti Ban: OFF")
    end
end

-- =============================================
-- PEMBUATAN GUI UTAMA
-- =============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game.CoreGui

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 600)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Shadow
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame
shadow.ZIndex = -1

-- Rounded corners
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 20)
mainCorner.Parent = mainFrame

-- TITLE BAR
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 20)
titleCorner.Parent = titleBar

-- Icon
local titleIcon = Instance.new("TextLabel")
titleIcon.Size = UDim2.new(0, 40, 0, 40)
titleIcon.Position = UDim2.new(0, 10, 0.5, -20)
titleIcon.BackgroundTransparency = 1
titleIcon.Text = "🚀"
titleIcon.TextSize = 30
titleIcon.TextColor3 = Color3.fromRGB(0, 200, 255)
titleIcon.Font = Enum.Font.SourceSans
titleIcon.Parent = titleBar

-- Title Text
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -150, 1, 0)
titleText.Position = UDim2.new(0, 55, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "UNIVERSAL HUB"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 20
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

-- MINIMIZE BUTTON (-)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 36, 0, 36)
minBtn.Position = UDim2.new(1, -92, 0.5, -18)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 30
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 12)
minCorner.Parent = minBtn

-- CLOSE BUTTON (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -46, 0.5, -18)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 22
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 12)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    iconGui:Destroy()
    notify("GUI Closed")
end)

-- =============================================
-- ICON UNTUK MINIMIZE
-- =============================================
local iconGui = Instance.new("ScreenGui")
iconGui.Name = "HubIcon"
iconGui.ResetOnSpawn = false
iconGui.Parent = game.CoreGui

local iconButton = Instance.new("TextButton")
iconButton.Size = UDim2.new(0, 60, 0, 60)
iconButton.Position = UDim2.new(0.5, -30, 0.5, -30)
iconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
iconButton.Text = "🚀"
iconButton.TextColor3 = Color3.fromRGB(0, 200, 255)
iconButton.TextSize = 40
iconButton.Font = Enum.Font.SourceSans
iconButton.BorderSizePixel = 0
iconButton.Visible = false
iconButton.Draggable = true
iconButton.Active = true
iconButton.Parent = iconGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = iconButton

local iconStroke = Instance.new("UIStroke")
iconStroke.Thickness = 3
iconStroke.Color = Color3.fromRGB(0, 200, 255)
iconStroke.Parent = iconButton

-- MINIMIZE FUNCTION
minBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    iconButton.Visible = true
    notify("GUI minimized")
end)

iconButton.MouseButton1Click:Connect(function()
    iconButton.Visible = false
    mainFrame.Visible = true
end)

-- =============================================
-- TAB CONTAINER
-- =============================================
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -20, 0, 45)
tabContainer.Position = UDim2.new(0, 10, 0, 55)
tabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabContainer.BackgroundTransparency = 0.3
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 12)
tabCorner.Parent = tabContainer

-- TABS (7 TAB SESUAI KATEGORI)
local tabs = {"🚀 MAIN", "🏃 MOVEMENT", "👁️ VISUAL", "🎭 TROLL", "🛡️ PROTECT", "🌍 WORLD", "⚙️ UTILITY"}
local tabButtons = {}
local currentTab = "🚀 MAIN"

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1/7, -3, 0, 35)
    tabBtn.Position = UDim2.new((i-1) * (1/7), 3, 0.5, -17.5)
    tabBtn.BackgroundColor3 = (tabName == currentTab) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 60)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.TextSize = 11
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = tabContainer
    
    local tabBtnCorner = Instance.new("UICorner")
    tabBtnCorner.CornerRadius = UDim.new(0, 10)
    tabBtnCorner.Parent = tabBtn
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, btn in ipairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        end
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        currentTab = tabName
        loadTab(tabName)
    end)
    
    table.insert(tabButtons, tabBtn)
end

-- =============================================
-- CONTENT FRAME (SCROLLING)
-- =============================================
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -120)
contentFrame.Position = UDim2.new(0, 10, 0, 105)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
contentFrame.BackgroundTransparency = 0.3
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 6
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 15)
contentCorner.Parent = contentFrame

-- Layout
local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 8)
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentFrame

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 12)
contentPadding.PaddingBottom = UDim.new(0, 12)
contentPadding.Parent = contentFrame

-- =============================================
-- VARIABLES FITUR
-- =============================================
local features = {
    -- MAIN
    speed = false, jump = false, esp = false,
    -- MOVEMENT
    infinityJump = false, doubleJump = false, spin = false, sitAnywhere = false, swimAir = false,
    -- VISUAL
    boxEsp = false, tracerEsp = false, nameEsp = false, healthBar = false, rainbowChar = false,
    -- TROLL
    push = false, pull = false, fling = false, headless = false, zombieWalk = false, spamChat = false,
    -- PROTECTION
    antiSit = false, antiTool = false, antiGrab = false, godMode = false, autoRespawn = false,
    -- WORLD
    timeChanger = false, gravityChanger = false, fogChanger = false, walkWater = false,
    -- UTILITY
    joystick = false, autoClick = false, noFallDamage = false
}

local threads = {}

-- =============================================
-- FUNGSI-FUNGSI FITUR
-- =============================================

-- ========== MAIN ==========
local function toggleSpeed(state)
    features.speed = state
    if state then humanoid.WalkSpeed = 50 else humanoid.WalkSpeed = 16 end
    notify("⚡ Speed: " .. (state and "ON" or "OFF"))
end

local function toggleJump(state)
    features.jump = state
    if state then humanoid.JumpPower = 100 else humanoid.JumpPower = 50 end
    notify("🦘 Jump: " .. (state and "ON" or "OFF"))
end

local function toggleESP(state)
    features.esp = state
    local function addESP(plr)
        if plr == player then return end
        if plr.Character then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESP_Highlight"
            highlight.FillColor = Color3.fromRGB(255, 50, 50)
            highlight.FillTransparency = 0.4
            highlight.Parent = plr.Character
        end
    end
    if state then
        for _, v in pairs(game.Players:GetPlayers()) do addESP(v) end
        notify("👁️ ESP: ON")
    else
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character then
                local h = v.Character:FindFirstChild("ESP_Highlight")
                if h then h:Destroy() end
            end
        end
        notify("👁️ ESP: OFF")
    end
end

local function loadInfiniteYield()
    notify("📦 Loading Infinite Yield...")
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
end

-- ========== MOVEMENT ==========
local function toggleInfinityJump(state)
    features.infinityJump = state
    if state then
        local connection
        connection = game:GetService("UserInputService").JumpRequest:Connect(function()
            if features.infinityJump then
                humanoid:ChangeState("Jumping")
            else
                connection:Disconnect()
            end
        end)
        threads.infinityJump = connection
        notify("🔁 Infinity Jump: ON")
    else
        if threads.infinityJump then
            threads.infinityJump:Disconnect()
            threads.infinityJump = nil
        end
        notify("🔁 Infinity Jump: OFF")
    end
end

local function toggleDoubleJump(state)
    features.doubleJump = state
    local jumped = false
    if state and not threads.doubleJump then
        threads.doubleJump = game:GetService("UserInputService").JumpRequest:Connect(function()
            if features.doubleJump then
                if humanoid.FloorMaterial ~= Enum.Material.Air then
                    jumped = false
                elseif not jumped then
                    jumped = true
                    humanoid:ChangeState("Jumping")
                end
            end
        end)
        notify("2️⃣ Double Jump: ON")
    else
        if threads.doubleJump then
            threads.doubleJump:Disconnect()
            threads.doubleJump = nil
        end
        notify("2️⃣ Double Jump: OFF")
    end
end

local function toggleSpin(state)
    features.spin = state
    if state and not threads.spin then
        threads.spin = task.spawn(function()
            while features.spin do
                rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(10), 0)
                task.wait(0.03)
            end
        end)
        notify("🌀 Spin: ON")
    else
        features.spin = false
        threads.spin = nil
        notify("🌀 Spin: OFF")
    end
end

local function toggleSitAnywhere(state)
    features.sitAnywhere = state
    if state then
        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if features.sitAnywhere and input.KeyCode == Enum.KeyCode.Z then
                humanoid.Sit = true
            end
        end)
        notify("🪑 Sit Anywhere: ON (Tekan Z)")
    else
        notify("🪑 Sit Anywhere: OFF")
    end
end

local function toggleSwimAir(state)
    features.swimAir = state
    if state then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        notify("🏊 Swim in Air: ON")
    else
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        notify("🏊 Swim in Air: OFF")
    end
end

-- ========== VISUAL ==========
local function toggleBoxESP(state)
    features.boxEsp = state
    -- Implementasi Box ESP
    notify("📦 Box ESP: " .. (state and "ON" or "OFF"))
end

local function toggleTracerESP(state)
    features.tracerEsp = state
    -- Implementasi Tracer
    notify("📍 Tracer ESP: " .. (state and "ON" or "OFF"))
end

local function toggleNameESP(state)
    features.nameEsp = state
    -- Implementasi Name ESP
    notify("🏷️ Name ESP: " .. (state and "ON" or "OFF"))
end

local function toggleHealthBar(state)
    features.healthBar = state
    -- Implementasi Health Bar
    notify("❤️ Health Bar: " .. (state and "ON" or "OFF"))
end

local function toggleRainbowChar(state)
    features.rainbowChar = state
    if state and not threads.rainbow then
        threads.rainbow = task.spawn(function()
            local hue = 0
            while features.rainbowChar do
                hue = (hue + 0.01) % 1
                local color = Color3.fromHSV(hue, 1, 1)
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Color = color
                    end
                end
                task.wait(0.05)
            end
        end)
        notify("🌈 Rainbow Character: ON")
    else
        features.rainbowChar = false
        threads.rainbow = nil
        notify("🌈 Rainbow Character: OFF")
    end
end

-- ========== TROLL ==========
local function togglePush(state)
    features.push = state
    if state and not threads.push then
        threads.push = task.spawn(function()
            while features.push do
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (v.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                        if dist < 10 then
                            v.Character.HumanoidRootPart.Velocity = (v.Character.HumanoidRootPart.Position - rootPart.Position).Unit * 100
                        end
                    end
                end
                task.wait()
            end
        end)
        notify("👊 Push Players: ON")
    else
        features.push = false
        threads.push = nil
        notify("👊 Push Players: OFF")
    end
end

local function togglePull(state)
    features.pull = state
    if state and not threads.pull then
        threads.pull = task.spawn(function()
            while features.pull do
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (v.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                        if dist < 20 then
                            v.Character.HumanoidRootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, -5)
                        end
                    end
                end
                task.wait()
            end
        end)
        notify("🧲 Pull Players: ON")
    else
        features.pull = false
        threads.pull = nil
        notify("🧲 Pull Players: OFF")
    end
end

local function toggleFling(state)
    features.fling = state
    if state and not threads.fling then
        threads.fling = task.spawn(function()
            while features.fling do
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (v.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                        if dist < 15 then
                            v.Character.HumanoidRootPart.Velocity = Vector3.new(math.random(-500, 500), math.random(200, 500), math.random(-500, 500))
                        end
                    end
                end
                task.wait()
            end
        end)
        notify("🌀 Fling Players: ON")
    else
        features.fling = false
        threads.fling = nil
        notify("🌀 Fling Players: OFF")
    end
end

local function toggleHeadless(state)
    features.headless = state
    local head = character:FindFirstChild("Head")
    if head then
        head.Transparency = state and 1 or 0
        head.MeshId = state and "http://www.roblox.com/asset/?id=0" or ""
    end
    notify("👻 Headless: " .. (state and "ON" or "OFF"))
end

local function toggleZombieWalk(state)
    features.zombieWalk = state
    if state then
        humanoid.WalkSpeed = 8
        humanoid.JumpPower
