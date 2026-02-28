--[[
    UNIVERSAL HUB - FIXED EDITION
    ==============================
    🔐 Password: "CODEX2025"
    ✅ Semua fitur muncul
    ✅ ON/OFF berfungsi
    ✅ Clean thread management
    ✅ Tidak ada teks acak
]]

-- ========== PASSWORD SYSTEM ==========
local correctPassword = "CODEX2025"
local passwordAttempts = 0
local maxAttempts = 3

-- Hapus GUI lama
pcall(function()
    game.CoreGui:FindFirstChild("PasswordGui"):Destroy()
    game.CoreGui:FindFirstChild("MegaHub"):Destroy()
end)

-- GUI Password (sederhana)
local pwGui = Instance.new("ScreenGui")
pwGui.Name = "PasswordGui"
pwGui.Parent = game.CoreGui

local pwFrame = Instance.new("Frame")
pwFrame.Size = UDim2.new(0, 250, 0, 150)
pwFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
pwFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
pwFrame.BackgroundTransparency = 0.1
pwFrame.Active = true
pwFrame.Draggable = true
pwFrame.Parent = pwGui

local pwCorner = Instance.new("UICorner")
pwCorner.CornerRadius = UDim.new(0, 10)
pwCorner.Parent = pwFrame

local pwTitle = Instance.new("TextLabel")
pwTitle.Size = UDim2.new(1, 0, 0, 40)
pwTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
pwTitle.Text = "🔐 PASSWORD"
pwTitle.TextColor3 = Color3.new(1,1,1)
pwTitle.TextSize = 16
pwTitle.Font = Enum.Font.GothamBold
pwTitle.Parent = pwFrame

local pwInput = Instance.new("TextBox")
pwInput.Size = UDim2.new(0.8, 0, 0, 30)
pwInput.Position = UDim2.new(0.1, 0, 0.4, 0)
pwInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
pwInput.PlaceholderText = "Password..."
pwInput.Text = ""
pwInput.TextColor3 = Color3.new(1,1,1)
pwInput.Parent = pwFrame

local pwSubmit = Instance.new("TextButton")
pwSubmit.Size = UDim2.new(0.4, 0, 0, 30)
pwSubmit.Position = UDim2.new(0.3, 0, 0.65, 0)
pwSubmit.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
pwSubmit.Text = "MASUK"
pwSubmit.TextColor3 = Color3.new(1,1,1)
pwSubmit.Parent = pwFrame

pwSubmit.MouseButton1Click:Connect(function()
    if pwInput.Text == correctPassword then
        pwGui:Destroy()
        loadMainHub()
    else
        passwordAttempts = passwordAttempts + 1
        if passwordAttempts >= maxAttempts then
            pwGui:Destroy()
        else
            pwInput.Text = ""
            pwInput.PlaceholderText = "SALAH! (" .. passwordAttempts .. "/" .. maxAttempts .. ")"
        end
    end
end)

-- ========== HUB UTAMA ==========
function loadMainHub()
    -- Tunggu player
    repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character
    
    local player = game.Players.LocalPlayer
    local function getChar() return player.Character end
    local function getHum() local c = getChar() return c and c:FindFirstChildOfClass("Humanoid") end
    local function getRoot() local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end
    
    local function notify(msg)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "⚡ FIXED HUB",
                Text = msg,
                Duration = 1
            })
        end)
    end
    
    -- Variables
    local features = {}
    local threads = {}
    local toggles = {}
    
    -- Cleanup function
    local function stopAll()
        for name, thread in pairs(threads) do
            if thread then
                if type(thread) == "thread" then
                    task.cancel(thread)
                elseif type(thread) == "RBXScriptConnection" then
                    thread:Disconnect()
                end
            end
        end
        threads = {}
    end
    
    -- ========== HORROR FEATURES ==========
    function toggleHeadless(state)
        features.headless = state
        local c = getChar()
        if c and c:FindFirstChild("Head") then
            c.Head.Transparency = state and 1 or 0
            c.Head.MeshId = state and "http://www.roblox.com/asset/?id=0" or ""
        end
        notify("👻 Headless " .. (state and "ON" or "OFF"))
    end
    
    function toggleZombie(state)
        features.zombie = state
        local h = getHum()
        if h then
            h.WalkSpeed = state and 8 or 16
            h.JumpPower = state and 0 or 50
        end
        notify("🧟 Zombie " .. (state and "ON" or "OFF"))
    end
    
    function toggleRedEyes(state)
        features.redEyes = state
        local c = getChar()
        if c and c:FindFirstChild("Head") then
            if state then
                if not c.Head:FindFirstChild("RedEye_L") then
                    local eye1 = Instance.new("Part")
                    eye1.Name = "RedEye_L"
                    eye1.Size = Vector3.new(0.3, 0.3, 0.3)
                    eye1.BrickColor = BrickColor.new("Really red")
                    eye1.Material = Enum.Material.Neon
                    eye1.Position = c.Head.Position + Vector3.new(-0.25, 0.2, 0.5)
                    eye1.Parent = c.Head
                    
                    local eye2 = Instance.new("Part")
                    eye2.Name = "RedEye_R"
                    eye2.Size = Vector3.new(0.3, 0.3, 0.3)
                    eye2.BrickColor = BrickColor.new("Really red")
                    eye2.Material = Enum.Material.Neon
                    eye2.Position = c.Head.Position + Vector3.new(0.25, 0.2, 0.5)
                    eye2.Parent = c.Head
                end
            else
                local e1 = c.Head:FindFirstChild("RedEye_L")
                local e2 = c.Head:FindFirstChild("RedEye_R")
                if e1 then e1:Destroy() end
                if e2 then e2:Destroy() end
            end
        end
        notify("👁️ Red Eyes " .. (state and "ON" or "OFF"))
    end
    
    function toggleBlood(state)
        features.blood = state
        if state then
            threads.blood = task.spawn(function()
                while features.blood do
                    local r = getRoot()
                    if r then
                        for i = 1, 5 do
                            local blood = Instance.new("Part")
                            blood.Size = Vector3.new(0.2, 0.2, 0.2)
                            blood.BrickColor = BrickColor.new("Bright red")
                            blood.Shape = Enum.PartType.Ball
                            blood.Position = r.Position + Vector3.new(math.random(-2,2), math.random(0,2), math.random(-2,2))
                            blood.Velocity = Vector3.new(math.random(-5,5), math.random(2,8), math.random(-5,5))
                            blood.Parent = workspace
                            game:GetService("Debris"):AddItem(blood, 0.5)
                        end
                    end
                    task.wait(0.2)
                end
            end)
        end
        notify("🩸 Blood " .. (state and "ON" or "OFF"))
    end
    
    function toggleDarkness(state)
        features.darkness = state
        if state then
            game.Lighting.Ambient = Color3.fromRGB(0,0,0)
            game.Lighting.Brightness = 0
            game.Lighting.ClockTime = 0
        else
            game.Lighting.Ambient = Color3.fromRGB(127,127,127)
            game.Lighting.Brightness = 1
            game.Lighting.ClockTime = 12
        end
        notify("🌑 Darkness " .. (state and "ON" or "OFF"))
    end
    
    function toggleScarySound(state)
        features.scarySound = state
        if state then
            threads.scarySound = task.spawn(function()
                while features.scarySound do
                    local s = Instance.new("Sound")
                    s.SoundId = "rbxassetid://9120386233"
                    s.Volume = 3
                    s.Parent = workspace
                    s:Play()
                    game:GetService("Debris"):AddItem(s, 2)
                    task.wait(3)
                end
            end)
        end
        notify("🔊 Scary Sound " .. (state and "ON" or "OFF"))
    end
    
    function toggleShakeCam(state)
        features.shakeCam = state
        if state then
            threads.shakeCam = task.spawn(function()
                local cam = workspace.CurrentCamera
                local orig = cam.CFrame
                while features.shakeCam do
                    cam.CFrame = orig * CFrame.new(math.random(-0.5,0.5), math.random(-0.5,0.5), math.random(-0.5,0.5))
                    task.wait(0.05)
                end
                cam.CFrame = orig
            end)
        end
        notify("📷 Shake Cam " .. (state and "ON" or "OFF"))
    end
    
    function toggleGhost(state)
        features.ghost = state
        local c = getChar()
        if c then
            for _, part in pairs(c:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = state and 0.7 or 0
                end
            end
        end
        notify("👻 Ghost " .. (state and "ON" or "OFF"))
    end
    
    function toggleJumpScare(state)
        features.jumpScare = state
        if state then
            threads.jumpScare = task.spawn(function()
                while features.jumpScare do
                    task.wait(math.random(5, 10))
                    local s = Instance.new("Sound")
                    s.SoundId = "rbxassetid://9120386233"
                    s.Volume = 8
                    s.Parent = workspace
                    s:Play()
                    game:GetService("Debris"):AddItem(s, 1)
                    
                    local flash = Instance.new("Part")
                    flash.Size = Vector3.new(5,5,5)
                    flash.Position = getRoot().Position
                    flash.BrickColor = BrickColor.new("White")
                    flash.Material = Enum.Material.Neon
                    flash.Anchored = true
                    flash.Parent = workspace
                    game:GetService("Debris"):AddItem(flash, 0.1)
                    
                    notify("😱 JUMP SCARE!")
                end
            end)
        end
        notify("😨 Jump Scare " .. (state and "ON" or "OFF"))
    end
    
    -- ========== MOVEMENT FEATURES ==========
    function toggleSpeed(state)
        features.speed = state
        local h = getHum()
        if h then h.WalkSpeed = state and 50 or 16 end
        notify("⚡ Speed " .. (state and "ON" or "OFF"))
    end
    
    function toggleJump(state)
        features.jump = state
        local h = getHum()
        if h then h.JumpPower = state and 100 or 50 end
        notify("🦘 Jump " .. (state and "ON" or "OFF"))
    end
    
    function toggleInfJump(state)
        features.infJump = state
        if state then
            threads.infJump = game:GetService("UserInputService").JumpRequest:Connect(function()
                if features.infJump and getHum() then
                    getHum():ChangeState("Jumping")
                end
            end)
        else
            if threads.infJump then
                threads.infJump:Disconnect()
                threads.infJump = nil
            end
        end
        notify("🔁 Infinity Jump " .. (state and "ON" or "OFF"))
    end
    
    function toggleSpin(state)
        features.spin = state
        if state then
            threads.spin = task.spawn(function()
                while features.spin do
                    local r = getRoot()
                    if r then
                        r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(20), 0)
                    end
                    task.wait(0.03)
                end
            end)
        else
            features.spin = false
        end
        notify("🌀 Spin " .. (state and "ON" or "OFF"))
    end
    
    function toggleNoClip(state)
        features.noclip = state
        if state then
            threads.noclip = game:GetService("RunService").Stepped:Connect(function()
                if features.noclip and getChar() then
                    for _, part in pairs(getChar():GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if threads.noclip then
                threads.noclip:Disconnect()
                threads.noclip = nil
            end
        end
        notify("🧱 NoClip " .. (state and "ON" or "OFF"))
    end
    
    function toggleFly(state)
        features.fly = state
        if state then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "Fly_BV"
            bv.MaxForce = Vector3.new(4000, 4000, 4000)
            bv.Velocity = Vector3.new(0,0,0)
            bv.Parent = getRoot()
            
            threads.fly = game:GetService("RunService").Heartbeat:Connect(function()
                if features.fly and getRoot() then
                    local move = Vector3.new(0,0,0)
                    local ui = game:GetService("UserInputService")
                    
                    if ui:IsKeyDown(Enum.KeyCode.W) then move = move + workspace.CurrentCamera.CFrame.LookVector end
                    if ui:IsKeyDown(Enum.KeyCode.S) then move = move - workspace.CurrentCamera.CFrame.LookVector end
                    if ui:IsKeyDown(Enum.KeyCode.A) then move = move - workspace.CurrentCamera.CFrame.RightVector end
                    if ui:IsKeyDown(Enum.KeyCode.D) then move = move + workspace.CurrentCamera.CFrame.RightVector end
                    if ui:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
                    if ui:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
                    
                    getRoot().Velocity = move * 40
                end
            end)
        else
            if threads.fly then threads.fly:Disconnect() end
            local bv = getRoot() and getRoot():FindFirstChild("Fly_BV")
            if bv then bv:Destroy() end
            if getRoot() then getRoot().Velocity = Vector3.new(0,0,0) end
        end
        notify("🕊️ Fly " .. (state and "ON" or "OFF"))
    end
    
    -- ========== VISUAL FEATURES ==========
    function toggleESP(state)
        features.esp = state
        if state then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and not v.Character:FindFirstChild("ESP") then
                    local h = Instance.new("Highlight")
                    h.Name = "ESP"
                    h.FillColor = Color3.fromRGB(255,50,50)
                    h.FillTransparency = 0.3
                    h.Parent = v.Character
                end
            end
        else
            for _, v in pairs(game.Players:GetPlayers()) do
                if v.Character then
                    local h = v.Character:FindFirstChild("ESP")
                    if h then h:Destroy() end
                end
            end
        end
        notify("👁️ ESP " .. (state and "ON" or "OFF"))
    end
    
    function toggleRainbow(state)
        features.rainbow = state
        if state then
            threads.rainbow = task.spawn(function()
                local h = 0
                while features.rainbow do
                    h = (h + 0.01) % 1
                    local c = getChar()
                    if c then
                        for _, p in pairs(c:GetChildren()) do
                            if p:IsA("BasePart") then
                                p.Color = Color3.fromHSV(h, 1, 1)
                            end
                        end
                    end
                    task.wait(0.05)
                end
            end)
        end
        notify("🌈 Rainbow " .. (state and "ON" or "OFF"))
    end
    
    -- ========== PROTECTION FEATURES ==========
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
    
    function toggleNoFall(state)
        features.nofall = state
        if state then
            threads.nofall = game:GetService("RunService").Heartbeat:Connect(function()
                if features.nofall and getHum() and getRoot() then
                    if getHum().FloorMaterial == Enum.Material.Air and getRoot().Velocity.Y < -15 then
                        getRoot().Velocity = Vector3.new(getRoot().Velocity.X, 0, getRoot().Velocity.Z)
                    end
                end
            end)
        else
            if threads.nofall then
                threads.nofall:Disconnect()
                threads.nofall = nil
            end
        end
        notify("📉 No Fall " .. (state and "ON" or "OFF"))
    end
    
    function toggleAntiKick(state)
        features.antikick = state
        if state then
            local mt = getrawmetatable and getrawmetatable(game)
            if mt then
                setreadonly(mt, false)
                local old = mt.__namecall
                mt.__namecall = newcclosure(function(self, ...)
                    local method = getnamecallmethod()
                    if method == "Kick" or method == "kick" then
                        return
                    end
                    return old(self, ...)
                end)
                setreadonly(mt, true)
            end
        end
        notify("🛡️ Anti Kick " .. (state and "ON" or "OFF"))
    end
    
    -- ========== WORLD FEATURES ==========
    function toggleTime(state)
        features.time = state
        if state then
            threads.time = task.spawn(function()
                local t = 0
                while features.time do
                    t = (t + 0.01) % 1
                    game.Lighting.ClockTime = t * 24
                    task.wait(0.1)
                end
            end)
        else
            features.time = false
            game.Lighting.ClockTime = 12
        end
        notify("⏰ Time " .. (state and "ON" or "OFF"))
    end
    
    function toggleGravity(state)
        features.gravity = state
        if state then
            threads.gravity = task.spawn(function()
                while features.gravity do
                    workspace.Gravity = 50 + math.random(-20, 50)
                    task.wait(0.3)
                end
                workspace.Gravity = 196.2
            end)
        else
            features.gravity = false
            workspace.Gravity = 196.2
        end
        notify("🌎 Gravity " .. (state and "ON" or "OFF"))
    end
    
    -- ========== UTILITY FEATURES ==========
    function toggleAutoClick(state)
        features.autoclick = state
        if state then
            threads.autoclick = task.spawn(function()
                while features.autoclick do
                    pcall(mouse1click)
                    task.wait(0.1)
                end
            end)
        end
        notify("🖱️ Auto Click " .. (state and "ON" or "OFF"))
    end
    
    function rejoinServer()
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end
    
    function serverHop()
        local suc, res = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100")
        end)
        
        if suc then
            local data = game:GetService("HttpService"):JSONDecode(res)
            local servers = {}
            for _, v in pairs(data.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(servers, v.id)
                end
            end
            if #servers > 0 then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
            end
        end
    end
    
    function loadIY()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
    
    -- ========== GUI ==========
    local gui = Instance.new("ScreenGui")
    gui.Name = "FixedHub"
    gui.Parent = game.CoreGui
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 300, 0, 400)
    main.Position = UDim2.new(0.5, -150, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    main.BackgroundTransparency = 0.1
    main.Active = true
    main.Draggable = true
    main.Parent = gui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = main
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    title.Text = "⚡ FIXED HUB"
    title.TextColor3 = Color3.new(1,1,1)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = main
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title
    
    -- Close button
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 25, 0, 25)
    close.Position = UDim2.new(1, -30, 0.5, -12.5)
    close.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    close.Text = "✕"
    close.TextColor3 = Color3.new(1,1,1)
    close.TextSize = 16
    close.Parent = title
    
    close.MouseButton1Click:Connect(function()
        stopAll()
        gui:Destroy()
    end)
    
    -- Tabs
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, -20, 0, 30)
    tabFrame.Position = UDim2.new(0, 10, 0, 40)
    tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    tabFrame.BackgroundTransparency = 0.3
    tabFrame.Parent = main
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabFrame
    
    local tabs = {"MAIN", "MOVE", "VISUAL", "PROTECT"}
    local tabBtns = {}
    local currentTab = "MAIN"
    
    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1/4, -3, 0, 22)
        btn.Position = UDim2.new((i-1)/4, 5, 0.5, -11)
        btn.BackgroundColor3 = name == "MAIN" and Color3.fromRGB(0,150,255) or Color3.fromRGB(50,50,60)
        btn.Text = name
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.Parent = tabFrame
        
        btn.MouseButton1Click:Connect(function()
            for _, b in ipairs(tabBtns) do
                b.BackgroundColor3 = Color3.fromRGB(50,50,60)
            end
            btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
            currentTab = name
            loadTab(name)
        end)
        table.insert(tabBtns, btn)
    end
    
    -- Content
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -90)
    content.Position = UDim2.new(0, 10, 0, 75)
    content.BackgroundTransparency = 1
    content.Parent = main
    
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 3)
    contentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = content
    
    -- Button creator
    function createToggle(icon, text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.Text = icon .. "  " .. text .. "  [OFF]"
        btn.TextColor3 = Color3.fromRGB(255, 100, 100)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextSize = 13
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        btn.Parent = content
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = btn
        
        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = icon .. "  " .. text .. "  [" .. (state and "ON" or "OFF") .. "]"
            btn.TextColor3 = state and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
            callback(state)
        end)
    end
    
    function createButton(icon, text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
        btn.Text = icon .. "  " .. text
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.Parent = content
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(callback)
    end
    
    function loadTab(tab)
        for _, v in pairs(content:GetChildren()) do
            if v:IsA("TextButton") then
                v:Destroy()
            end
        end
        
        if tab == "MAIN" then
            createToggle("👻", "Headless", toggleHeadless)
            createToggle("🧟", "Zombie", toggleZombie)
            createToggle("👁️", "Red Eyes", toggleRedEyes)
            createToggle("🩸", "Blood", toggleBlood)
            createToggle("🌑", "Darkness", toggleDarkness)
            createToggle("🔊", "Scary Sound", toggleScarySound)
            createToggle("📷", "Shake Cam", toggleShakeCam)
            createToggle("👻", "Ghost", toggleGhost)
            createToggle("😨", "Jump Scare", toggleJumpScare)
            
        elseif tab == "MOVE" then
            createToggle("⚡", "Speed", toggleSpeed)
            createToggle("🦘", "Jump", toggleJump)
            createToggle("🔁", "Infinity Jump", toggleInfJump)
            createToggle("🌀", "Spin", toggleSpin)
            createToggle("🧱", "NoClip", toggleNoClip)
            createToggle("🕊️", "Fly", toggleFly)
            
        elseif tab == "VISUAL" then
            createToggle("👁️", "ESP", toggleESP)
            createToggle("🌈", "Rainbow", toggleRainbow)
            
        elseif tab == "PROTECT" then
            createToggle("👑", "God Mode", toggleGod)
            createToggle("📉", "No Fall", toggleNoFall)
            createToggle("🛡️", "Anti Kick", toggleAntiKick)
            createToggle("⏰", "Time", toggleTime)
            createToggle("🌎", "Gravity", toggleGravity)
            createToggle("🖱️", "Auto Click", toggleAutoClick)
            createButton("🔄", "Rejoin", rejoinServer)
            createButton("🌐", "Server Hop", serverHop)
            createButton("📦", "IY", loadIY)
        end
    end
    
    loadTab("MAIN")
    notify("✅ FIXED HUB READY!")
    
    -- Handle respawn
    player.CharacterAdded:Connect(function()
        task.wait(1)
        -- Reapply features
        for name, state in pairs(features) do
            if state then
                if name == "headless" then toggleHeadless(true)
                elseif name == "zombie" then toggleZombie(true)
                elseif name == "redEyes" then toggleRedEyes(true)
                elseif name == "darkness" then toggleDarkness(true)
                elseif name == "ghost" then toggleGhost(true)
                elseif name == "speed" then toggleSpeed(true)
                elseif name == "jump" then toggleJump(true)
                elseif name == "noclip" then toggleNoClip(true)
                elseif name == "fly" then toggleFly(true)
                elseif name == "esp" then toggleESP(true)
                elseif name == "rainbow" then toggleRainbow(true)
                elseif name == "god" then toggleGod(true)
                elseif name == "nofall" then toggleNoFall(true)
                end
            end
        end
    end)
end
