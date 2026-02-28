--[[
    UNIVERSAL HUB - FINAL FIXED EDITION
    =====================================
    ✅ Push & Fling WORK (BodyVelocity)
    ✅ No Fall Damage WORK (Heartbeat)
    ✅ Semua fitur tetap aktif setelah respawn
    ✅ Fitur baru: Freeze All, Trap Box, Earthquake
    ✅ UI kecil 300x400
]]

pcall(function() game.CoreGui.UniversalHub:Destroy() game.CoreGui.HubIcon:Destroy() end)
repeat task.wait() until game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local function getChar() return player.Character end
local function getHum() local c = getChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end

local function notify(msg) pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title = "🚀 UNIVERSAL HUB", Text = msg, Duration = 1.5}) end) end

-- ========== ANTI BAN ==========
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

-- ========== VARIABLES ==========
local features = {}
local threads = {}

-- ========== AUTO RE-APPLY SETELAH RESPAWN ==========
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    for name, enabled in pairs(features) do
        if enabled then
            if name == "speed" and getHum() then getHum().WalkSpeed = 50
            elseif name == "jump" and getHum() then getHum().JumpPower = 100
            elseif name == "infJump" and getHum() then
                if threads.infJump then threads.infJump:Disconnect() end
                threads.infJump = game:GetService("UserInputService").JumpRequest:Connect(function()
                    if features.infJump and getHum() then getHum():ChangeState("Jumping") end
                end)
            elseif name == "dblJump" then
                local jumped = false
                if threads.dblJump then threads.dblJump:Disconnect() end
                threads.dblJump = game:GetService("UserInputService").JumpRequest:Connect(function()
                    if features.dblJump and getHum() then
                        if getHum().FloorMaterial ~= Enum.Material.Air then jumped = false
                        elseif not jumped then jumped = true getHum():ChangeState("Jumping") end
                    end
                end)
            elseif name == "spin" then
                threads.spin = task.spawn(function()
                    while features.spin do
                        local r = getRoot()
                        if r then r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(15), 0) end
                        task.wait(0.03)
                    end
                end)
            elseif name == "rainbow" then
                threads.rainbow = task.spawn(function()
                    local h = 0
                    while features.rainbow do
                        h = (h + 0.01) % 1
                        local c = getChar()
                        if c then
                            for _,p in pairs(c:GetChildren()) do
                                if p:IsA("BasePart") then p.Color = Color3.fromHSV(h,1,1) end
                            end
                        end
                        task.wait(0.05)
                    end
                end)
            elseif name == "headless" then
                local c = getChar()
                if c then
                    local head = c:FindFirstChild("Head")
                    if head then head.Transparency = 1 head.MeshId = "http://www.roblox.com/asset/?id=0" end
                end
            elseif name == "zombie" and getHum() then
                getHum().WalkSpeed = 8
                getHum().JumpPower = 0
            elseif name == "god" and getHum() then
                getHum().MaxHealth = math.huge
                getHum().Health = math.huge
            end
        end
    end
    notify("🔄 Fitur reactivated!")
end)

-- ========== SPEED ==========
function toggleSpeed(state)
    features.speed = state
    if getHum() then getHum().WalkSpeed = state and 50 or 16 end
    notify("⚡ Speed " .. (state and "ON" or "OFF"))
end

-- ========== JUMP ==========
function toggleJump(state)
    features.jump = state
    if getHum() then getHum().JumpPower = state and 100 or 50 end
    notify("🦘 Jump " .. (state and "ON" or "OFF"))
end

-- ========== ESP ==========
function toggleESP(state)
    features.esp = state
    if state then
        local function addESP(p)
            if p ~= player and p.Character and not p.Character:FindFirstChild("ESP_Highlight") then
                local h = Instance.new("Highlight")
                h.Name = "ESP_Highlight"
                h.FillColor = Color3.fromRGB(255,50,50)
                h.FillTransparency = 0.3
                h.Parent = p.Character
            end
        end
        for _,v in pairs(game.Players:GetPlayers()) do addESP(v) end
        game.Players.PlayerAdded:Connect(function(v)
            v.CharacterAdded:Connect(function() task.wait(0.5) if features.esp then addESP(v) end end)
        end)
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

-- ========== INFINITE YIELD ==========
function loadIY()
    notify("📦 Loading IY...")
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end)
end

-- ========== INFINITY JUMP ==========
function toggleInfJump(state)
    features.infJump = state
    if state then
        if threads.infJump then threads.infJump:Disconnect() end
        threads.infJump = game:GetService("UserInputService").JumpRequest:Connect(function()
            if features.infJump and getHum() then getHum():ChangeState("Jumping") end
        end)
        notify("🔁 Infinity Jump ON")
    else
        if threads.infJump then threads.infJump:Disconnect() end
        notify("🔁 Infinity Jump OFF")
    end
end

-- ========== DOUBLE JUMP ==========
function toggleDblJump(state)
    features.dblJump = state
    local jumped = false
    if state then
        if threads.dblJump then threads.dblJump:Disconnect() end
        threads.dblJump = game:GetService("UserInputService").JumpRequest:Connect(function()
            if features.dblJump and getHum() then
                if getHum().FloorMaterial ~= Enum.Material.Air then
                    jumped = false
                elseif not jumped then
                    jumped = true
                    getHum():ChangeState("Jumping")
                end
            end
        end)
        notify("2️⃣ Double Jump ON")
    else
        if threads.dblJump then threads.dblJump:Disconnect() end
        notify("2️⃣ Double Jump OFF")
    end
end

-- ========== SPIN ==========
function toggleSpin(state)
    features.spin = state
    if state then
        threads.spin = task.spawn(function()
            while features.spin do
                local r = getRoot()
                if r then r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(15), 0) end
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

-- ========== RAINBOW ==========
function toggleRainbow(state)
    features.rainbow = state
    if state then
        threads.rainbow = task.spawn(function()
            local h = 0
            while features.rainbow do
                h = (h + 0.01) % 1
                local c = getChar()
                if c then
                    for _,p in pairs(c:GetChildren()) do
                        if p:IsA("BasePart") then p.Color = Color3.fromHSV(h,1,1) end
                    end
                end
                task.wait(0.05)
            end
        end)
        notify("🌈 Rainbow ON")
    else
        features.rainbow = false
        threads.rainbow = nil
        local c = getChar()
        if c then
            for _,p in pairs(c:GetChildren()) do
                if p:IsA("BasePart") then p.Color = Color3.fromRGB(255,255,255) end
            end
        end
        notify("🌈 Rainbow OFF")
    end
end

-- ========== PUSH (FIXED - BODYVELOCITY) ==========
function togglePush(state)
    features.push = state
    if state then
        threads.push = task.spawn(function()
            while features.push do
                local r = getRoot()
                if r then
                    for _,v in pairs(game.Players:GetPlayers()) do
                        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (v.Character.HumanoidRootPart.Position - r.Position).Magnitude
                            if dist < 10 then
                                local bv = Instance.new("BodyVelocity")
                                bv.MaxForce = Vector3.new(4000,4000,4000)
                                bv.Velocity = (v.Character.HumanoidRootPart.Position - r.Position).Unit * 150
                                bv.Parent = v.Character.HumanoidRootPart
                                game:GetService("Debris"):AddItem(bv, 0.2)
                            end
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

-- ========== FLING (FIXED - BODYVELOCITY) ==========
function toggleFling(state)
    features.fling = state
    if state then
        threads.fling = task.spawn(function()
            while features.fling do
                local r = getRoot()
                if r then
                    for _,v in pairs(game.Players:GetPlayers()) do
                        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (v.Character.HumanoidRootPart.Position - r.Position).Magnitude
                            if dist < 12 then
                                local bv = Instance.new("BodyVelocity")
                                bv.MaxForce = Vector3.new(10000,10000,10000)
                                bv.Velocity = Vector3.new(math.random(-500,500), math.random(200,500), math.random(-500,500))
                                bv.Parent = v.Character.HumanoidRootPart
                                game:GetService("Debris"):AddItem(bv, 0.3)
                            end
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

-- ========== FREEZE ALL (FITUR BARU) ==========
function toggleFreeze(state)
    features.freeze = state
    if state then
        threads.freeze = task.spawn(function()
            while features.freeze do
                for _,v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        v.Character.HumanoidRootPart.Anchored = true
                    end
                end
                task.wait(0.1)
            end
        end)
        notify("❄️ Freeze All ON")
    else
        features.freeze = false
        threads.freeze = nil
        for _,v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                v.Character.HumanoidRootPart.Anchored = false
            end
        end
        notify("❄️ Freeze All OFF")
    end
end

-- ========== TRAP BOX (FITUR BARU) ==========
function toggleTrap(state)
    features.trap = state
    if state then
        threads.trap = task.spawn(function()
            while features.trap do
                local r = getRoot()
                if r then
                    for _,v in pairs(game.Players:GetPlayers()) do
                        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (v.Character.HumanoidRootPart.Position - r.Position).Magnitude
                            if dist < 15 and not v.Character:FindFirstChild("TrapBox") then
                                local box = Instance.new("Part")
                                box.Name = "TrapBox"
                                box.Size = Vector3.new(10,10,10)
                                box.Position = v.Character.HumanoidRootPart.Position
                                box.Anchored = true
                                box.CanCollide = true
                                box.Transparency = 0.5
                                box.BrickColor = BrickColor.new("Really red")
                                box.Material = Enum.Material.Neon
                                box.Parent = workspace
                                
                                local box2 = box:Clone()
                                box2.Size = Vector3.new(8,8,8)
                                box2.Transparency = 0.3
                                box2.Parent = workspace
                                
                                game:GetService("Debris"):AddItem(box, 5)
                                game:GetService("Debris"):AddItem(box2, 5)
                                
                                v.Character.HumanoidRootPart.CFrame = box.CFrame
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)
        notify("📦 Trap Box ON")
    else
        features.trap = false
        threads.trap = nil
        notify("📦 Trap Box OFF")
    end
end

-- ========== EARTHQUAKE (FITUR BARU) ==========
function toggleEarthquake(state)
    features.quake = state
    if state then
        threads.quake = task.spawn(function()
            while features.quake do
                for i = 1, 30 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(5,5,5)
                    part.Position = Vector3.new(math.random(-500,500), math.random(0,100), math.random(-500,500))
                    part.Anchored = true
                    part.CanCollide = false
                    part.Transparency = 0.8
                    part.BrickColor = BrickColor.Random()
                    part.Parent = workspace
                    
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(0, 10000, 0)
                    bv.Velocity = Vector3.new(0, math.random(50, 200), 0)
                    bv.Parent = part
                    
                    game:GetService("Debris"):AddItem(part, 0.5)
                end
                
                -- Goyangin kamera semua player (efek visual)
                for _,v in pairs(game.Players:GetPlayers()) do
                    if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local pos = v.Character.HumanoidRootPart.Position
                        v.Character.HumanoidRootPart.CFrame = pos + Vector3.new(math.random(-2,2), math.random(-1,1), math.random(-2,2))
                    end
                end
                task.wait(0.2)
            end
        end)
        notify("🌋 Earthquake ON")
    else
        features.quake = false
        threads.quake = nil
        notify("🌋 Earthquake OFF")
    end
end

-- ========== HEADLESS ==========
function toggleHeadless(state)
    features.headless = state
    local c = getChar()
    if c then
        local head = c:FindFirstChild("Head")
        if head then
            head.Transparency = state and 1 or 0
            head.MeshId = state and "http://www.roblox.com/asset/?id=0" or ""
        end
    end
    notify("👻 Headless " .. (state and "ON" or "OFF"))
end

-- ========== ZOMBIE ==========
function toggleZombie(state)
    features.zombie = state
    local h = getHum()
    if h then
        h.WalkSpeed = state and 8 or 16
        h.JumpPower = state and 0 or 50
    end
    notify("🧟 Zombie " .. (state and "ON" or "OFF"))
end

-- ========== GOD MODE ==========
function toggleGod(state)
    features.god = state
    local h = getHum()
    if h then
        if state then
            h.MaxHealth = math.huge
            h.Health = math.huge
        else
            h.MaxHealth = 100
            h.Health = 100
        end
    end
    notify("👑 God Mode " .. (state and "ON" or "OFF"))
end

-- ========== AUTO RESPAWN ==========
function toggleRespawn(state)
    features.respawn = state
    if state then
        if threads.respawn then threads.respawn:Disconnect() end
        threads.respawn = player.CharacterAdded:Connect(function()
            task.wait(0.5)
            notify("🔄 Respawned")
        end)
        notify("🔄 Auto Respawn ON")
    else
        if threads.respawn then threads.respawn:Disconnect() end
        notify("🔄 Auto Respawn OFF")
    end
end

-- ========== TIME CHANGER ==========
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

-- ========== GRAVITY ==========
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

-- ========== NO FALL DAMAGE (FIXED) ==========
function toggleNoFall(state)
    features.nofall = state
    if state then
        threads.nofall = game:GetService("RunService").Heartbeat:Connect(function()
            if features.nofall and getHum() and getRoot() then
                if getHum().FloorMaterial == Enum.Material.Air and getRoot().Velocity.Y < -20 then
                    getRoot().Velocity = Vector3.new(getRoot().Velocity.X, 0, getRoot().Velocity.Z)
                end
            end
        end)
        notify("📉 No Fall Damage ON")
    else
        if threads.nofall then threads.nofall:Disconnect() end
        notify("📉 No Fall Damage OFF")
    end
end

-- ========== AUTO CLICK ==========
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

-- ========== GUI ==========
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

local tabs = {"MAIN", "MOVE", "TROLL", "PROTECT", "WORLD"}
local tabBtns = {}
local current = "MAIN"

for i,name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/5, -2, 0, 25)
    btn.Position = UDim2.new((i-1)/5, 3, 0.5, -12.5)
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
        createToggle("🌈", "Rainbow", toggleRainbow, 4)
        
    elseif tab == "TROLL" then
        createToggle("👊", "Push", togglePush, 1)
        createToggle("🌀", "Fling", toggleFling, 2)
        createToggle("❄️", "Freeze All", toggleFreeze, 3)
        createToggle("📦", "Trap Box", toggleTrap, 4)
        createToggle("🌋", "Earthquake", toggleEarthquake, 5)
        createToggle("👻", "Headless", toggleHeadless, 6)
        createToggle("🧟", "Zombie Walk", toggleZombie, 7)
        
    elseif tab == "PROTECT" then
        createToggle("👑", "God Mode", toggleGod, 1)
        createToggle("🔄", "Auto Respawn", toggleRespawn, 2)
        createToggle("🛡️", "Anti Ban", toggleAntiBan, 3)
        createToggle("📉", "No Fall", toggleNoFall, 4)
        
    elseif tab == "WORLD" then
        createToggle("⏰", "Time Changer", toggleTime, 1)
        createToggle("🌎", "Gravity", toggleGravity, 2)
        createToggle("🖱️", "Auto Click", toggleAutoClick, 3)
    end
end

loadTab("MAIN")
notify("✅ FINAL FIXED EDITION READY")
print("🚀 UNIVERSAL HUB - FINAL FIXED EDITION LOADED")
