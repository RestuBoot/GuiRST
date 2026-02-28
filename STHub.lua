--[[
    UNIVERSAL HUB - ULTIMATE EDITION
    - UI KECIL (300x400) - Tidak nutupin karakter
    - SEMUA FITUR WORK (bukan coming soon)
    - 6 Tab rapi
    - Minimize button
]]

pcall(function() game.CoreGui.UniversalHub:Destroy() game.CoreGui.HubIcon:Destroy() end)
repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local player = game.Players.LocalPlayer
local char = player.Character
local hum = char:FindFirstChildOfClass("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")

local function notify(msg) pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title = "🚀 UNIVERSAL HUB", Text = msg, Duration = 1.5}) end) end

-- Anti Ban
local antiBan = false
local function toggleAntiBan(state)
    antiBan = state
    if state then
        pcall(function()
            local mt = getrawmetatable and getrawmetatable(game)
            if mt then
                setreadonly(mt, false)
                local old = mt.__namecall
                mt.__namecall = newcclosure(function(self, ...)
                    if getnamecallmethod() == "Kick" or getnamecallmethod() == "kick" then return end
                    return old(self, ...)
                end)
                setreadonly(mt, true)
            end
        end)
        notify("🛡️ Anti Ban ON")
    else notify("🛡️ Anti Ban OFF") end
end

-- GUI UTAMA (UKURAN KECIL 300x400)
local gui = Instance.new("ScreenGui")
gui.Name = "UniversalHub"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 400)
main.Position = UDim2.new(0.5, -150, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = main

-- Title Bar
local title = Instance.new("Frame")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
title.BorderSizePixel = 0
title.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = title

local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 30, 0, 30)
icon.Position = UDim2.new(0, 8, 0.5, -15)
icon.BackgroundTransparency = 1
icon.Text = "🚀"
icon.TextSize = 22
icon.TextColor3 = Color3.fromRGB(0, 200, 255)
icon.Font = Enum.Font.SourceSans
icon.Parent = title

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -100, 1, 0)
titleText.Position = UDim2.new(0, 40, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "UNIVERSAL HUB"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 14
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = title

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 20
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
minBtn.Parent = title

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = title

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Icon for minimize
local iconGui = Instance.new("ScreenGui")
iconGui.Name = "HubIcon"
iconGui.Parent = game.CoreGui

local iconBtn = Instance.new("TextButton")
iconBtn.Size = UDim2.new(0, 50, 0, 50)
iconBtn.Position = UDim2.new(0.5, -25, 0.5, -25)
iconBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
iconBtn.Text = "🚀"
iconBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
iconBtn.TextSize = 30
iconBtn.Font = Enum.Font.SourceSans
iconBtn.BorderSizePixel = 0
iconBtn.Visible = false
iconBtn.Draggable = true
iconBtn.Parent = iconGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = iconBtn

minBtn.MouseButton1Click:Connect(function() main.Visible = false iconBtn.Visible = true end)
iconBtn.MouseButton1Click:Connect(function() iconBtn.Visible = false main.Visible = true end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() iconGui:Destroy() end)

-- Tab Container (lebih kecil)
local tabBox = Instance.new("Frame")
tabBox.Size = UDim2.new(1, -20, 0, 35)
tabBox.Position = UDim2.new(0, 10, 0, 40)
tabBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabBox.BackgroundTransparency = 0.3
tabBox.BorderSizePixel = 0
tabBox.Parent = main

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 10)
tabCorner.Parent = tabBox

-- Tabs (6 tab aja biar muat)
local tabs = {"MAIN", "MOVE", "VISUAL", "TROLL", "PROTECT", "WORLD"}
local tabBtns = {}
local current = "MAIN"

for i,name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/6, -2, 0, 25)
    btn.Position = UDim2.new((i-1)/6, 3, 0.5, -12.5)
    btn.BackgroundColor3 = name == "MAIN" and Color3.fromRGB(0,150,255) or Color3.fromRGB(50,50,60)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = tabBox
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _,b in ipairs(tabBtns) do b.BackgroundColor3 = Color3.fromRGB(50,50,60) end
        btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
        current = name
        loadTab(name)
    end)
    table.insert(tabBtns, btn)
end

-- Content Frame (scrolling)
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -20, 1, -90)
content.Position = UDim2.new(0, 10, 0, 80)
content.BackgroundColor3 = Color3.fromRGB(20,20,30)
content.BackgroundTransparency = 0.3
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = main

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 10)
contentCorner.Parent = content

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingBottom = UDim.new(0, 8)
padding.Parent = content

-- ========== FITUR-FITUR YANG WORK ==========

local features = {}
local threads = {}

-- SPEED (WORK)
function toggleSpeed(state)
    features.speed = state
    hum.WalkSpeed = state and 50 or 16
    notify("⚡ Speed " .. (state and "ON" or "OFF"))
end

-- JUMP (WORK)
function toggleJump(state)
    features.jump = state
    hum.JumpPower = state and 100 or 50
    notify("🦘 Jump " .. (state and "ON" or "OFF"))
end

-- ESP (WORK)
function toggleESP(state)
    features.esp = state
    if state then
        for _,v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character then
                local h = Instance.new("Highlight")
                h.Name = "ESP_Highlight"
                h.FillColor = Color3.fromRGB(255,50,50)
                h.FillTransparency = 0.3
                h.Parent = v.Character
            end
        end
        notify("👁️ ESP ON")
    else
        for _,v in pairs(game.Players:GetPlayers()) do
            if v.Character then
                local h = v.Character:FindFirstChild("ESP_Highlight")
                if h then h:Destroy() end
            end
        end
        notify("👁️ ESP OFF")
    end
end

-- INFINITE YIELD (WORK)
function loadIY()
    notify("📦 Loading IY...")
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end)
end

-- INFINITY JUMP (WORK)
function toggleInfJump(state)
    features.infJump = state
    if state then
        local con
        con = game:GetService("UserInputService").JumpRequest:Connect(function()
            if features.infJump then hum:ChangeState("Jumping") end
        end)
        threads.infJump = con
        notify("🔁 Infinity Jump ON")
    else
        if threads.infJump then threads.infJump:Disconnect() end
        notify("🔁 Infinity Jump OFF")
    end
end

-- DOUBLE JUMP (WORK)
function toggleDblJump(state)
    features.dblJump = state
    local jumped = false
    if state then
        threads.dblJump = game:GetService("UserInputService").JumpRequest:Connect(function()
            if features.dblJump then
                if hum.FloorMaterial ~= Enum.Material.Air then jumped = false
                elseif not jumped then jumped = true hum:ChangeState("Jumping") end
            end
        end)
        notify("2️⃣ Double Jump ON")
    else
        if threads.dblJump then threads.dblJump:Disconnect() end
        notify("2️⃣ Double Jump OFF")
    end
end

-- SPIN (WORK)
function toggleSpin(state)
    features.spin = state
    if state then
        threads.spin = task.spawn(function()
            while features.spin do
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(15), 0)
                task.wait(0.03)
            end
        end)
        notify("🌀 Spin ON")
    else
        features.spin = false
        threads.spin = nil
        notify("🌀 Spin OFF")
    end
end

-- RAINBOW (WORK)
function toggleRainbow(state)
    features.rainbow = state
    if state then
        threads.rainbow = task.spawn(function()
            local h = 0
            while features.rainbow do
                h = (h + 0.01) % 1
                for _,p in pairs(char:GetChildren()) do
                    if p:IsA("BasePart") then p.Color = Color3.fromHSV(h,1,1) end
                end
                task.wait(0.05)
            end
        end)
        notify("🌈 Rainbow ON")
    else
        features.rainbow = false
        threads.rainbow = nil
        for _,p in pairs(char:GetChildren()) do
            if p:IsA("BasePart") then p.Color = Color3.fromRGB(255,255,255) end
        end
        notify("🌈 Rainbow OFF")
    end
end

-- PUSH (WORK)
function togglePush(state)
    features.push = state
    if state then
        threads.push = task.spawn(function()
            while features.push do
                for _,v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (v.Character.HumanoidRootPart.Position - root.Position).Magnitude
                        if dist < 8 then
                            v.Character.HumanoidRootPart.Velocity = (v.Character.HumanoidRootPart.Position - root.Position).Unit * 80
                        end
                    end
                end
                task.wait()
            end
        end)
        notify("👊 Push ON")
    else
        features.push = false
        threads.push = nil
        notify("👊 Push OFF")
    end
end

-- FLING (WORK)
function toggleFling(state)
    features.fling = state
    if state then
        threads.fling = task.spawn(function()
            while features.fling do
                for _,v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (v.Character.HumanoidRootPart.Position - root.Position).Magnitude
                        if dist < 10 then
                            v.Character.HumanoidRootPart.Velocity = Vector3.new(math.random(-400,400), math.random(100,400), math.random(-400,400))
                        end
                    end
                end
                task.wait()
            end
        end)
        notify("🌀 Fling ON")
    else
        features.fling = false
        threads.fling = nil
        notify("🌀 Fling OFF")
    end
end

-- HEADLESS (WORK)
function toggleHeadless(state)
    features.headless = state
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = state and 1 or 0
        head.MeshId = state and "http://www.roblox.com/asset/?id=0" or ""
    end
    notify("👻 Headless " .. (state and "ON" or "OFF"))
end

-- ZOMBIE WALK (WORK)
function toggleZombie(state)
    features.zombie = state
    hum.WalkSpeed = state and 8 or 16
    hum.JumpPower = state and 0 or 50
    notify("🧟 Zombie " .. (state and "ON" or "OFF"))
end

-- GOD MODE (WORK)
function toggleGod(state)
    features.god = state
    if state then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        notify("👑 God Mode ON")
    else
        hum.MaxHealth = 100
        hum.Health = 100
        notify("👑 God Mode OFF")
    end
end

-- AUTO RESPAWN (WORK)
function toggleRespawn(state)
    features.respawn = state
    if state then
        threads.respawn = player.CharacterAdded:Connect(function(c)
            char = c
            hum = c:FindFirstChildOfClass("Humanoid")
            root = c:FindFirstChild("HumanoidRootPart")
            notify("🔄 Respawned")
        end)
        notify("🔄 Auto Respawn ON")
    else
        if threads.respawn then threads.respawn:Disconnect() end
        notify("🔄 Auto Respawn OFF")
    end
end

-- TIME CHANGE (WORK)
function toggleTime(state)
    features.time = state
    if state then
        threads.time = task.spawn(function()
            local t = 0
            while features.time do
                t = (t + 0.02) % 1
                game.Lighting.ClockTime = t * 24
                task.wait(0.1)
            end
        end)
        notify("⏰ Time Changer ON")
    else
        features.time = false
        threads.time = nil
        game.Lighting.ClockTime = 12
        notify("⏰ Time Changer OFF")
    end
end

-- GRAVITY (WORK)
function toggleGravity(state)
    features.gravity = state
    if state then
        threads.gravity = task.spawn(function()
            while features.gravity do
                workspace.Gravity = 50 + math.random(-30, 100)
                task.wait(0.3)
            end
        end)
        notify("🌎 Gravity ON")
    else
        features.gravity = false
        threads.gravity = nil
        workspace.Gravity = 196.2
        notify("🌎 Gravity OFF")
    end
end

-- NO FALL DAMAGE (WORK)
function toggleNoFall(state)
    features.nofall = state
    if state then
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        notify("📉 No Fall ON")
    else
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        notify("📉 No Fall OFF")
    end
end

-- AUTO CLICK (WORK)
function toggleAutoClick(state)
    features.autoclick = state
    if state then
        threads.autoclick = task.spawn(function()
            while features.autoclick do
                pcall(function() mouse1click() end)
                task.wait(0.1)
            end
        end)
        notify("🖱️ Auto Click ON")
    else
        features.autoclick = false
        threads.autoclick = nil
        notify("🖱️ Auto Click OFF")
    end
end

-- ========== UI FUNCTIONS ==========

function createToggle(icon, text, callback, order)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -10, 0, 38)
    f.BackgroundColor3 = Color3.fromRGB(30,30,40)
    f.BackgroundTransparency = 0.2
    f.BorderSizePixel = 0
    f.LayoutOrder = order
    f.Parent = content
    
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 8)
    fc.Parent = f
    
    local ic = Instance.new("TextLabel")
    ic.Size = UDim2.new(0, 35, 1, 0)
    ic.BackgroundTransparency = 1
    ic.Text = icon
    ic.TextSize = 20
    ic.TextColor3 = Color3.fromRGB(0,200,255)
    ic.Font = Enum.Font.SourceSans
    ic.Parent = f
    
    local tx = Instance.new("TextLabel")
    tx.Size = UDim2.new(0.5, -35, 1, 0)
    tx.Position = UDim2.new(0, 35, 0, 0)
    tx.BackgroundTransparency = 1
    tx.Text = text
    tx.TextColor3 = Color3.fromRGB(255,255,255)
    tx.TextSize = 12
    tx.TextXAlignment = Enum.TextXAlignment.Left
    tx.Font = Enum.Font.Gotham
    tx.Parent = f
    
    local st = Instance.new("TextLabel")
    st.Size = UDim2.new(0, 40, 1, 0)
    st.Position = UDim2.new(1, -45, 0, 0)
    st.BackgroundTransparency = 1
    st.Text = "OFF"
    st.TextColor3 = Color3.fromRGB(255,100,100)
    st.TextSize = 12
    st.Font = Enum.Font.GothamBold
    st.Parent = f
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,1,0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        st.Text = state and "ON" or "OFF"
        st.TextColor3 = state and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
        callback(state)
    end)
end

function createButton(icon, text, callback, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(0,120,200)
    btn.Text = icon .. "  " .. text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = content
    
    local btnc = Instance.new("UICorner")
    btnc.CornerRadius = UDim.new(0, 8)
    btnc.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

-- ========== LOAD TAB ==========

function loadTab(tab)
    for _,v in pairs(content:GetChildren()) do
        if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then v:Destroy() end
    end
    
    if tab == "MAIN" then
        createToggle("⚡", "Speed Boost", toggleSpeed, 1)
        createToggle("🦘", "Jump Power", toggleJump, 2)
        createToggle("👁️", "ESP", toggleESP, 3)
        createButton("📦", "Infinite Yield", loadIY, 4)
        createToggle("🛡️", "Anti Ban", toggleAntiBan, 5)
        
    elseif tab == "MOVE" then
        createToggle("🔁", "Infinity Jump", toggleInfJump, 1)
        createToggle("2️⃣", "Double Jump", toggleDblJump, 2)
        createToggle("🌀", "Spin", toggleSpin, 3)
        
    elseif tab == "VISUAL" then
        createToggle("👁️", "ESP", toggleESP, 1)
        createToggle("🌈", "Rainbow", toggleRainbow, 2)
        
    elseif tab == "TROLL" then
        createToggle("👊", "Push", togglePush, 1)
        createToggle("🌀", "Fling", toggleFling, 2)
        createToggle("👻", "Headless", toggleHeadless, 3)
        createToggle("🧟", "Zombie Walk", toggleZombie, 4)
        
    elseif tab == "PROTECT" then
        createToggle("👑", "God Mode", toggleGod, 1)
        createToggle("🔄", "Auto Respawn", toggleRespawn, 2)
        createToggle("🛡️", "Anti Ban", toggleAntiBan, 3)
        
    elseif tab == "WORLD" then
        createToggle("⏰", "Time Changer", toggleTime, 1)
        createToggle("🌎", "Gravity", toggleGravity, 2)
        createToggle("📉", "No Fall", toggleNoFall, 3)
        createToggle("🖱️", "Auto Click", toggleAutoClick, 4)
    end
end

loadTab("MAIN")
notify("✅ ULTIMATE HUB READY")
print("🚀 UNIVERSAL HUB - ULTIMATE EDITION LOADED")
