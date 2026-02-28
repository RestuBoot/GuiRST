--[[
    UNIVERSAL HUB - MEGA EDITION (LENGKAP)
    =======================================
    🔐 Password: "CODEX2025"
    ✅ 52 FITUR + GUI LENGKAP!
]]

-- ========== PASSWORD SYSTEM ==========
local correctPassword = "CODEX2025"
local passwordAttempts = 0
local maxAttempts = 3

-- GUI Password
local pwGui = Instance.new("ScreenGui")
pwGui.Name = "PasswordGui"
pwGui.ResetOnSpawn = false
pwGui.Parent = game.CoreGui

local pwFrame = Instance.new("Frame")
pwFrame.Size = UDim2.new(0, 300, 0, 200)
pwFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
pwFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
pwFrame.BackgroundTransparency = 0.1
pwFrame.Active = true
pwFrame.Draggable = true
pwFrame.Parent = pwGui

local pwCorner = Instance.new("UICorner")
pwCorner.CornerRadius = UDim.new(0, 15)
pwCorner.Parent = pwFrame

local pwTitle = Instance.new("TextLabel")
pwTitle.Size = UDim2.new(1, 0, 0, 40)
pwTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
pwTitle.Text = "🔐 MASUKKAN PASSWORD"
pwTitle.TextColor3 = Color3.new(1,1,1)
pwTitle.TextSize = 16
pwTitle.Font = Enum.Font.GothamBold
pwTitle.Parent = pwFrame

local pwInput = Instance.new("TextBox")
pwInput.Size = UDim2.new(0.8, 0, 0, 35)
pwInput.Position = UDim2.new(0.1, 0, 0.4, 0)
pwInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
pwInput.PlaceholderText = "Password..."
pwInput.Text = ""
pwInput.TextColor3 = Color3.new(1,1,1)
pwInput.Parent = pwFrame

local pwSubmit = Instance.new("TextButton")
pwSubmit.Size = UDim2.new(0.4, 0, 0, 35)
pwSubmit.Position = UDim2.new(0.3, 0, 0.65, 0)
pwSubmit.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
pwSubmit.Text = "MASUK"
pwSubmit.TextColor3 = Color3.new(1,1,1)
pwSubmit.Parent = pwFrame

local pwStatus = Instance.new("TextLabel")
pwStatus.Size = UDim2.new(1, 0, 0, 30)
pwStatus.Position = UDim2.new(0, 0, 0.85, 0)
pwStatus.BackgroundTransparency = 1
pwStatus.Text = "Masukkan password"
pwStatus.TextColor3 = Color3.fromRGB(150,150,150)
pwStatus.TextSize = 12
pwStatus.Parent = pwFrame

pwSubmit.MouseButton1Click:Connect(function()
    if pwInput.Text == correctPassword then
        pwStatus.Text = "✅ BERHASIL!"
        pwStatus.TextColor3 = Color3.fromRGB(100,255,100)
        task.wait(1)
        pwGui:Destroy()
        loadMainHub()
    else
        passwordAttempts = passwordAttempts + 1
        if passwordAttempts >= maxAttempts then
            pwStatus.Text = "❌ TERLALU BANYAK SALAH!"
            pwStatus.TextColor3 = Color3.fromRGB(255,100,100)
            task.wait(2)
            pwGui:Destroy()
        else
            pwStatus.Text = "❌ SALAH! (" .. passwordAttempts .. "/" .. maxAttempts .. ")"
            pwStatus.TextColor3 = Color3.fromRGB(255,100,100)
        end
    end
end)

-- ========== HUB UTAMA (LENGKAP DENGAN GUI) ==========
function loadMainHub()
    -- Tunggu player
    repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character
    local player = game.Players.LocalPlayer
    local function getChar() return player.Character end
    local function getHum() local c = getChar() return c and c:FindFirstChildOfClass("Humanoid") end
    local function getRoot() local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end

    -- Notifikasi
    local function notify(msg)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "🔥 MEGA HUB",
                Text = msg,
                Duration = 1.5
            })
        end)
    end

    -- Variables untuk toggle
    local features = {}
    local threads = {}

    -- ========== 1. HORROR FEATURES ==========
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
                    for i = 1, 10 do
                        local blood = Instance.new("Part")
                        blood.Size = Vector3.new(0.2, 0.2, 0.2)
                        blood.BrickColor = BrickColor.new("Bright red")
                        blood.Shape = Enum.PartType.Ball
                        blood.Position = getRoot().Position + Vector3.new(math.random(-3,3), math.random(0,3), math.random(-3,3))
                        blood.Velocity = Vector3.new(math.random(-10,10), math.random(5,15), math.random(-10,10))
                        blood.Parent = workspace
                        game:GetService("Debris"):AddItem(blood, 1)
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
            game.Lighting.FogEnd = 50
            game.Lighting.FogColor = Color3.fromRGB(0,0,0)
        else
            game.Lighting.Ambient = Color3.fromRGB(127,127,127)
            game.Lighting.Brightness = 1
            game.Lighting.ClockTime = 12
            game.Lighting.FogEnd = 100000
        end
        notify("🌑 Darkness " .. (state and "ON" or "OFF"))
    end

    function toggleScarySound(state)
        features.scarySound = state
        if state then
            threads.scarySound = task.spawn(function()
                local sounds = {
                    "rbxassetid://9120386233",
                    "rbxassetid://9119439489",
                    "rbxassetid://166113339",
                }
                while features.scarySound do
                    local s = Instance.new("Sound")
                    s.SoundId = sounds[math.random(1, #sounds)]
                    s.Volume = 5
                    s.Parent = workspace
                    s:Play()
                    game:GetService("Debris"):AddItem(s, 3)
                    task.wait(2)
                end
            end)
        end
        notify("🔊 Scary Sound " .. (state and "ON" or "OFF"))
    end

    function toggleScreamFace(state)
        features.screamFace = state
        local c = getChar()
        if c and c:FindFirstChild("Head") then
            if state then
                local decal = Instance.new("Decal")
                decal.Name = "ScreamFace"
                decal.Texture = "rbxassetid://166113339"
                decal.Face = Enum.NormalId.Front
                decal.Parent = c.Head
            else
                local d = c.Head:FindFirstChild("ScreamFace")
                if d then d:Destroy() end
            end
        end
        notify("😱 Scream Face " .. (state and "ON" or "OFF"))
    end

    function toggleShakeCam(state)
        features.shakeCam = state
        if state then
            threads.shakeCam = task.spawn(function()
                local cam = workspace.CurrentCamera
                local orig = cam.CFrame
                while features.shakeCam do
                    cam.CFrame = orig * CFrame.new(math.random(-1,1), math.random(-1,1), math.random(-1,1))
                    task.wait(0.03)
                end
                cam.CFrame = orig
            end)
        end
        notify("📷 Shake Cam " .. (state and "ON" or "OFF"))
    end

    function toggleChaseMusic(state)
        features.chaseMusic = state
        if state then
            threads.chaseMusic = Instance.new("Sound")
            threads.chaseMusic.SoundId = "rbxassetid://1837609904"
            threads.chaseMusic.Volume = 5
            threads.chaseMusic.Looped = true
            threads.chaseMusic.Parent = workspace
            threads.chaseMusic:Play()
        else
            if threads.chaseMusic then
                threads.chaseMusic:Stop()
                threads.chaseMusic:Destroy()
            end
        end
        notify("🎵 Chase Music " .. (state and "ON" or "OFF"))
    end

    function toggleInvertColors(state)
        features.invertColors = state
        if state then
            threads.invertColors = task.spawn(function()
                local hue = 0
                while features.invertColors do
                    hue = (hue + 0.02) % 1
                    game.Lighting.Ambient = Color3.fromHSV(hue, 1, 0.5)
                    task.wait(0.1)
                end
                game.Lighting.Ambient = Color3.fromRGB(127,127,127)
            end)
        end
        notify("🎨 Invert Colors " .. (state and "ON" or "OFF"))
    end

    function toggleFloatingHead(state)
        features.floatingHead = state
        local c = getChar()
        if c and c:FindFirstChild("Head") then
            if state then
                c.Head.Anchored = true
                threads.floatingHead = task.spawn(function()
                    while features.floatingHead do
                        c.Head.CFrame = c.Head.CFrame * CFrame.new(0, math.sin(tick()*2)/5, 0)
                        task.wait()
                    end
                end)
            else
                c.Head.Anchored = false
            end
        end
        notify("🎭 Floating Head " .. (state and "ON" or "OFF"))
    end

    function toggleGhost(state)
        features.ghost = state
        local c = getChar()
        if c then
            for _, part in pairs(c:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = state and 0.8 or 0
                end
            end
        end
        notify("👻 Ghost Mode " .. (state and "ON" or "OFF"))
    end

    function toggleBloodRain(state)
        features.bloodRain = state
        if state then
            threads.bloodRain = task.spawn(function()
                while features.bloodRain do
                    local pos = getRoot().Position
                    for i = 1, 20 do
                        local drop = Instance.new("Part")
                        drop.Size = Vector3.new(0.2, 0.5, 0.2)
                        drop.BrickColor = BrickColor.new("Bright red")
                        drop.Position = pos + Vector3.new(math.random(-15,15), 20, math.random(-15,15))
                        drop.Velocity = Vector3.new(0, -50, 0)
                        drop.Parent = workspace
                        game:GetService("Debris"):AddItem(drop, 2)
                    end
                    task.wait(0.2)
                end
            end)
        end
        notify("🌧️ Blood Rain " .. (state and "ON" or "OFF"))
    end

    function toggleWhisper(state)
        features.whisper = state
        if state then
            threads.whisper = task.spawn(function()
                while features.whisper do
                    local s = Instance.new("Sound")
                    s.SoundId = "rbxassetid://166113339"
                    s.Volume = 2
                    s.Parent = workspace
                    s:Play()
                    game:GetService("Debris"):AddItem(s, 1)
                    task.wait(3)
                end
            end)
        end
        notify("🤫 Whisper " .. (state and "ON" or "OFF"))
    end

    function toggleJumpScare(state)
        features.jumpScare = state
        if state then
            threads.jumpScare = task.spawn(function()
                while features.jumpScare do
                    task.wait(math.random(5, 15))
                    local s = Instance.new("Sound")
                    s.SoundId = "rbxassetid://9120386233"
                    s.Volume = 10
                    s.Parent = workspace
                    s:Play()
                    game:GetService("Debris"):AddItem(s, 2)
                    
                    local flash = Instance.new("Part")
                    flash.Size = Vector3.new(10,10,10)
                    flash.Position = getRoot().Position
                    flash.BrickColor = BrickColor.new("White")
                    flash.Material = Enum.Material.Neon
                    flash.Anchored = true
                    flash.Parent = workspace
                    game:GetService("Debris"):AddItem(flash, 0.1)
                    
                    notify("😨 JUMP SCARE!")
                end
            end)
        end
        notify("😨 Jump Scare " .. (state and "ON" or "OFF"))
    end

    -- ========== 2. MOVEMENT FEATURES ==========
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
            if threads.infJump then threads.infJump:Disconnect() end
        end
        notify("🔁 Infinity Jump " .. (state and "ON" or "OFF"))
    end

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
            if threads.noclip then threads.noclip:Disconnect() end
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
                    
                    getRoot().Velocity = move * 50
                end
            end)
        else
            if threads.fly then threads.fly:Disconnect() end
            local bv = getRoot():FindFirstChild("Fly_BV")
            if bv then bv:Destroy() end
        end
        notify("🕊️ Fly " .. (state and "ON" or "OFF"))
    end

    function toggleSwimAir(state)
        features.swimAir = state
        local h = getHum()
        if h then
            if state then
                h:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
                h:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
            else
                h:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            end
        end
        notify("🏊 Swim in Air " .. (state and "ON" or "OFF"))
    end

    -- ========== 3. VISUAL FEATURES ==========
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
                v.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    if features.esp then addESP(v) end
                end)
            end)
        else
            for _,v in pairs(game.Players:GetPlayers()) do
                if v.Character then
                    local h = v.Character:FindFirstChild("ESP_Highlight")
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
                        for _,p in pairs(c:GetChildren()) do
                            if p:IsA("BasePart") then p.Color = Color3.fromHSV(h,1,1) end
                        end
                    end
                    task.wait(0.05)
                end
            end)
        end
        notify("🌈 Rainbow " .. (state and "ON" or "OFF"))
    end

    function toggleNameESP(state)
        features.nameESP = state
        if state then
            for _,v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "NameESP"
                    bill.Size = UDim2.new(0, 100, 0, 30)
                    bill.AlwaysOnTop = true
                    bill.Parent = v.Character.Head
                    
                    local name = Instance.new("TextLabel")
                    name.Size = UDim2.new(1,0,1,0)
                    name.BackgroundTransparency = 1
                    name.Text = v.Name
                    name.TextColor3 = Color3.fromRGB(255,255,255)
                    name.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                    name.TextStrokeTransparency = 0
                    name.Parent = bill
                end
            end
        else
            for _,v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("Head") then
                    local bill = v.Character.Head:FindFirstChild("NameESP")
                    if bill then bill:Destroy() end
                end
            end
        end
        notify("🏷️ Name ESP " .. (state and "ON" or "OFF"))
    end

    function toggleTracer(state)
        features.tracer = state
        if state then
            threads.tracer = game:GetService("RunService").RenderStepped:Connect(function()
                if features.tracer then
                    for _,v in pairs(game.Players:GetPlayers()) do
                        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local line = Instance.new("Part")
                            line.Name = "Tracer"
                            line.Size = Vector3.new(0.1, 0.1, (getRoot().Position - v.Character.HumanoidRootPart.Position).Magnitude)
                            line.CFrame = CFrame.lookAt(getRoot().Position, v.Character.HumanoidRootPart.Position) * CFrame.new(0, 0, -line.Size.Z/2)
                            line.Anchored = true
                            line.CanCollide = false
                            line.BrickColor = BrickColor.new("Bright red")
                            line.Material = Enum.Material.Neon
                            line.Parent = workspace
                            game:GetService("Debris"):AddItem(line, 0.1)
                        end
                    end
                end
            end)
        end
        notify("📍 Tracer ESP " .. (state and "ON" or "OFF"))
    end

    function toggleBoxESP(state)
        features.boxESP = state
        if state then
            threads.boxESP = game:GetService("RunService").RenderStepped:Connect(function()
                if features.boxESP then
                    for _,v in pairs(game.Players:GetPlayers()) do
                        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local size = v.Character:GetExtentsSize()
                            local box = Instance.new("Part")
                            box.Name = "BoxESP"
                            box.Size = size
                            box.CFrame = v.Character.HumanoidRootPart.CFrame
                            box.Anchored = true
                            box.CanCollide = false
                            box.Transparency = 0.7
                            box.BrickColor = BrickColor.new("Bright red")
                            box.Material = Enum.Material.Neon
                            box.Parent = workspace
                            game:GetService("Debris"):AddItem(box, 0.1)
                        end
                    end
                end
            end)
        end
        notify("📦 Box ESP " .. (state and "ON" or "OFF"))
    end

    function toggleHealthBar(state)
        features.healthBar = state
        if state then
            for _,v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChildOfClass("Humanoid") then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "HealthBar"
                    bill.Size = UDim2.new(0, 50, 0, 5)
                    bill.AlwaysOnTop = true
                    bill.Parent = v.Character.Head
                    
                    local bar = Instance.new("Frame")
                    bar.Size = UDim2.new(v.Character:FindFirstChildOfClass("Humanoid").Health / v.Character:FindFirstChildOfClass("Humanoid").MaxHealth, 0, 1, 0)
                    bar.BackgroundColor3 = Color3.fromRGB(0,255,0)
                    bar.Parent = bill
                    
                    local bg = Instance.new("Frame")
                    bg.Size = UDim2.new(1,0,1,0)
                    bg.BackgroundColor3 = Color3.fromRGB(100,0,0)
                    bg.Parent = bill
                    bar.Parent = bill
                end
            end
        else
            for _,v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("Head") then
                    local hb = v.Character.Head:FindFirstChild("HealthBar")
                    if hb then hb:Destroy() end
                end
            end
        end
        notify("❤️ Health Bar " .. (state and "ON" or "OFF"))
    end

    function toggleDistance(state)
        features.distance = state
        if state then
            for _,v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "DistanceESP"
                    bill.Size = UDim2.new(0, 80, 0, 30)
                    bill.AlwaysOnTop = true
                    bill.Parent = v.Character.Head
                    
                    local dist = Instance.new("TextLabel")
                    dist.Size = UDim2.new(1,0,1,0)
                    dist.BackgroundTransparency = 1
                    dist.Text = "0m"
                    dist.TextColor3 = Color3.fromRGB(255,255,0)
                    dist.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                    dist.TextStrokeTransparency = 0
                    dist.Parent = bill
                    
                    task.spawn(function()
                        while features.distance and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and getRoot() do
                            local d = math.floor((v.Character.HumanoidRootPart.Position - getRoot().Position).Magnitude)
                            dist.Text = d .. "m"
                            task.wait(0.1)
                        end
                    end)
                end
            end
        else
            for _,v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("Head") then
                    local d = v.Character.Head:FindFirstChild("DistanceESP")
                    if d then d:Destroy() end
                end
            end
        end
        notify("📏 Distance ESP " .. (state and "ON" or "OFF"))
    end

    -- ========== 4. TROLL FEATURES ==========
    function toggleGiantHead(state)
        features.giantHead = state
        local c = getChar()
        if c and c:FindFirstChild("Head") then
            if state then
                c.Head.Size = Vector3.new(4, 4, 4)
                c.Head.MeshId = "http://www.roblox.com/asset/?id=0"
            else
                c.Head.Size = Vector3.new(2, 1, 1)
            end
        end
        notify("🗿 Giant Head " .. (state and "ON" or "OFF"))
    end

    function toggleTinyBody(state)
        features.tinyBody = state
        local c = getChar()
        if c then
            for _, part in pairs(c:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "Head" then
                    part.Size = state and part.Size/3 or part.Size*3
                end
            end
        end
        notify("🐜 Tiny Body " .. (state and "ON" or "OFF"))
    end

    function toggleLongNeck(state)
        features.longNeck = state
        local c = getChar()
        if c and c:FindFirstChild("Head") and c:FindFirstChild("Torso") then
            if state then
                c.Head.Position = c.Torso.Position + Vector3.new(0, 5, 0)
            end
        end
        notify("🦒 Long Neck " .. (state and "ON" or "OFF"))
    end

    function toggleUpsideDown(state)
        features.upsideDown = state
        local c = getChar()
        if c and c:FindFirstChild("HumanoidRootPart") then
            if state then
                c.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(180), 0, 0)
            end
        end
        notify("🙃 Upside Down " .. (state and "ON" or "OFF"))
    end

    function toggleSpinbot(state)
        features.spinbot = state
        if state then
            threads.spinbot = task.spawn(function()
                while features.spinbot do
                    local c = getChar()
                    if c and c:FindFirstChild("HumanoidRootPart") then
                        c.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(30), 0)
                    end
                    task.wait(0.03)
                end
            end)
        end
        notify("🌀 Spinbot " .. (state and "ON" or "OFF"))
    end

    function toggleFakeLag(state)
        features.fakeLag = state
        if state then
            threads.fakeLag = task.spawn(function()
                while features.fakeLag do
                    local c = getChar()
                    if c and c:FindFirstChild("HumanoidRootPart") then
                        c.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame + Vector3.new(math.random(-2,2), 0, math.random(-2,2))
                    end
                    task.wait(0.1)
                end
            end)
        end
        notify("🐢 Fake Lag " .. (state and "ON" or "OFF"))
    end

    function toggleChatSpam(state)
        features.chatSpam = state
        if state then
            threads.chatSpam = task.spawn(function()
                local msgs = {"🔥 MEGA HUB", "💀 TROLL", "🎉 GG", "👋 EZ", "🤡 LOL"}
                while features.chatSpam do
                    local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
                    if chat and chat:FindFirstChild("SayMessageRequest") then
                        chat.SayMessageRequest:FireServer(msgs[math.random(1, #msgs)], "All")
                    end
                    task.wait(1)
                end
            end)
        end
        notify("💬 Chat Spam " .. (state and "ON" or "OFF"))
    end

    function toggleSoundSpam(state)
        features.soundSpam = state
        if state then
            threads.soundSpam = task.spawn(function()
                while features.soundSpam do
                    local s = Instance.new("Sound")
                    s.SoundId = "rbxassetid://9120386233"
                    s.Volume = 5
                    s.Parent = workspace
                    s:Play()
                    game:GetService("Debris"):AddItem(s, 2)
                    task.wait(0.3)
                end
            end)
        end
        notify("🔊 Sound Spam " .. (state and "ON" or "OFF"))
    end

    -- ========== 5. PROTECTION FEATURES ==========
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
                    if getHum().FloorMaterial == Enum.Material.Air and getRoot().Velocity.Y < -20 then
                        getRoot().Velocity = Vector3.new(getRoot().Velocity.X, 0, getRoot().Velocity.Z)
                    end
                end
            end)
        else
            if threads.nofall then threads.nofall:Disconnect() end
        end
        notify("📉 No Fall " .. (state and "ON" or "OFF"))
    end

    function toggleAutoRespawn(state)
        features.respawn = state
        if state then
            threads.respawn = player.CharacterAdded:Connect(function()
                task.wait(0.5)
                notify("🔄 Respawned")
            end)
        else
            if threads.respawn then threads.respawn:Disconnect() end
        end
        notify("🔄 Auto Respawn " .. (state and "ON" or "OFF"))
    end

    function toggleAntiKick(state)
        features.antikick = state
        if state then
            local mt = getrawmetatable and getrawmetatable(game)
            if mt then
                setreadonly(mt, false)
                local old = mt.__namecall
                mt.__namecall = newcclosure(function(self, ...)
                    if getnamecallmethod() == "Kick" or getnamecallmethod() == "kick" then
                        return
                    end
                    return old(self, ...)
                end)
                setreadonly(mt, true)
            end
        end
        notify("🛡️ Anti Kick " .. (state and "ON" or "OFF"))
    end

    -- ========== 6. WORLD FEATURES ==========
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
                game.Lighting.ClockTime = 12
            end)
        end
        notify("⏰ Time Changer " .. (state and "ON" or "OFF"))
    end

    function toggleGravity(state)
        features.gravity = state
        if state then
            threads.gravity = task.spawn(function()
                while features.gravity do
                    workspace.Gravity = 50 + math.random(-30, 100)
                    task.wait(0.3)
                end
                workspace.Gravity = 196.2
            end)
        end
        notify("🌎 Gravity " .. (state and "ON" or "OFF"))
    end

    function toggleFog(state)
        features.fog = state
        if state then
            threads.fog = task.spawn(function()
                while features.fog do
                    game.Lighting.FogEnd = 50 + math.random(0, 200)
                    task.wait(0.5)
                end
                game.Lighting.FogEnd = 100000
            end)
        end
        notify("🌫️ Fog " .. (state and "ON" or "OFF"))
    end

    function toggleSkybox(state)
        features.skybox = state
        if state then
            local skies = {
                "rbxassetid://125879757",
                "rbxassetid://168572417",
                "rbxassetid://142777456"
            }
            local sky = Instance.new("Sky")
            sky.SkyboxBk = skies[math.random(1, #skies)]
            sky.SkyboxDn = skies[math.random(1, #skies)]
            sky.SkyboxFt = skies[math.random(1, #skies)]
            sky.SkyboxLf = skies[math.random(1, #skies)]
            sky.SkyboxRt = skies[math.random(1, #skies)]
            sky.SkyboxUp = skies[math.random(1, #skies)]
            sky.Parent = game.Lighting
            threads.skybox = sky
        else
            if threads.skybox then threads.skybox:Destroy() end
        end
        notify("☁️ Skybox " .. (state and "ON" or "OFF"))
    end

    function toggleNeonWorld(state)
        features.neon = state
        if state then
            threads.neon = task.spawn(function()
                while features.neon do
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("BasePart") and not v.Parent:IsA("Player") then
                            v.Material = Enum.Material.Neon
                        end
                    end
                    task.wait(2)
                end
            end)
        end
        notify("💡 Neon World " .. (state and "ON" or "OFF"))
    end

    -- ========== 7. UTILITY FEATURES ==========
    function toggleAutoClick(state)
        features.autoclick = state
        if state then
            threads.autoclick = task.spawn(function()
                while features.autoclick do
                    pcall(function() mouse1click() end)
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
        local servers = {}
        local suc, res = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100")
        end)
        
        if suc then
            local data = game:GetService("HttpService"):JSONDecode(res)
            for _, v in pairs(data.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(servers, v.id)
                end
            end
        end
        
        if #servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
        else
            notify("❌ No servers available")
        end
    end

    function loadIY()
        notify("📦 Loading IY...")
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
    end

    -- ========== GUI UTAMA ==========
    local gui = Instance.new("ScreenGui")
    gui.Name = "MegaHub"
    gui.Parent = game.CoreGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 350, 0, 500)
    main.Position = UDim2.new(0.5, -175, 0.5, -250)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    main.BackgroundTransparency = 0.1
    main.Active = true
    main.Draggable = true
    main.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = main

    local title = Instance.new("Frame")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    title.BorderSizePixel = 0
    title.Parent = main

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = title

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 10, 0.5, -15)
    icon.BackgroundTransparency = 1
    icon.Text = "🔥"
    icon.TextSize = 22
    icon.TextColor3 = Color3.fromRGB(0, 200, 255)
    icon.Font = Enum.Font.SourceSans
    icon.Parent = title

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 45, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "MEGA HUB"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 18
    titleText.TextXAlignment = "Left"
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = title

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -40, 0.5, -15)
    close.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    close.Text = "✕"
    close.TextColor3 = Color3.new(1,1,1)
    close.TextSize = 18
    close.Font = Enum.Font.GothamBold
    close.Parent = title

    close.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- Tabs
    local tabBox = Instance.new("Frame")
    tabBox.Size = UDim2.new(1, -20, 0, 40)
    tabBox.Position = UDim2.new(0, 10, 0, 45)
    tabBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    tabBox.BackgroundTransparency = 0.3
    tabBox.BorderSizePixel = 0
    tabBox.Parent = main

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 10)
    tabCorner.Parent = tabBox

    local tabs = {"HORROR", "MOVE", "VISUAL", "TROLL", "PROTECT", "WORLD", "UTILITY"}
    local tabBtns = {}
    local current = "HORROR"

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1/7, -2, 0, 30)
        btn.Position = UDim2.new((i-1)/7, 3, 0.5, -15)
        btn.BackgroundColor3 = name == current and Color3.fromRGB(0,150,255) or Color3.fromRGB(50,50,60)
        btn.Text = name
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextSize = 10
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.Parent = tabBox
        
        btn.MouseButton1Click:Connect(function()
            for _, b in ipairs(tabBtns) do
                b.BackgroundColor3 = Color3.fromRGB(50,50,60)
            end
            btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
            current = name
            loadTab(name)
        end)
        
        table.insert(tabBtns, btn)
    end

    -- Content
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -20, 1, -100)
    content.Position = UDim2.new(0, 10, 0, 90)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 5
    content.AutomaticCanvasSize = "Y"
    content.Parent = main

    -- Helper functions
    function createToggle(icon, text, callback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 35)
        f.BackgroundTransparency = 1
        f.Parent = content
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Position = UDim2.new(0, 5, 0, 2)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.Text = icon .. "  " .. text .. "  [OFF]"
        btn.TextColor3 = Color3.fromRGB(255, 100, 100)
        btn.TextXAlignment = "Left"
        btn.TextSize = 12
        btn.Font = Enum.Font.Gotham
        btn.Parent = f
        
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
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Position = UDim2.new(0, 5, 0, 2)
        btn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
        btn.Text = icon .. "  " .. text
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold
        btn.Parent = content
        
        btn.MouseButton1Click:Connect(callback)
    end

    -- Load tab function
    function loadTab(tab)
        for _, v in pairs(content:GetChildren()) do
            if not v:IsA("UIListLayout") then v:Destroy() end
        end
        
        if tab == "HORROR" then
            createToggle("👻", "Headless", toggleHeadless)
            createToggle("🧟", "Zombie Walk", toggleZombie)
            createToggle("👁️", "Red Eyes", toggleRedEyes)
            createToggle("🩸", "Blood Effect", toggleBlood)
            createToggle("🌑", "Darkness", toggleDarkness)
            createToggle("🔊", "Scary Sound", toggleScarySound)
            createToggle("😱", "Screaming Face", toggleScreamFace)
            createToggle("📷", "Shake Camera", toggleShakeCam)
            createToggle("🎵", "Chase Music", toggleChaseMusic)
            createToggle("🎨", "Invert Colors", toggleInvertColors)
            createToggle("🎭", "Floating Head", toggleFloatingHead)
            createToggle("👻", "Ghost Mode", toggleGhost)
            createToggle("🌧️", "Blood Rain", toggleBloodRain)
            createToggle("🤫", "Whisper", toggleWhisper)
            createToggle("😨", "Jump Scare", toggleJumpScare)
            
        elseif tab == "MOVE" then
            createToggle("⚡", "Speed Boost", toggleSpeed)
            createToggle("🦘", "Jump Power", toggleJump)
            createToggle("🔁", "Infinity Jump", toggleInfJump)
            createToggle("🌀", "Spin", toggleSpin)
            createToggle("🧱", "NoClip", toggleNoClip)
            createToggle("🕊️", "Fly", toggleFly)
            createToggle("🏊", "Swim in Air", toggleSwimAir)
            
        elseif tab == "VISUAL" then
            createToggle("👁️", "ESP", toggleESP)
            createToggle("🌈", "Rainbow", toggleRainbow)
            createToggle("🏷️", "Name ESP", toggleNameESP)
            createToggle("📍", "Tracer ESP", toggleTracer)
            createToggle("📦", "Box ESP", toggleBoxESP)
            createToggle("❤️", "Health Bar", toggleHealthBar)
            createToggle("📏", "Distance ESP", toggleDistance)
            
        elseif tab == "TROLL" then
            createToggle("👻", "Headless", toggleHeadless)
            createToggle("🧟", "Zombie", toggleZombie)
            createToggle("🗿", "Giant Head", toggleGiantHead)
            createToggle("🐜", "Tiny Body", toggleTinyBody)
            createToggle("🦒", "Long Neck", toggleLongNeck)
            createToggle("🙃", "Upside Down", toggleUpsideDown)
            createToggle("🌀", "Spinbot", toggleSpinbot)
            createToggle("🐢", "Fake Lag", toggleFakeLag)
            createToggle("💬", "Chat Spam", toggleChatSpam)
            createToggle("🔊", "Sound Spam", toggleSoundSpam)
            
        elseif tab == "PROTECT" then
            createToggle("👑", "God Mode", toggleGod)
            createToggle("📉", "No Fall", toggleNoFall)
            createToggle("🔄", "Auto Respawn", toggleAutoRespawn)
            createToggle("🛡️", "Anti Kick", toggleAntiKick)
            
        elseif tab == "WORLD" then
            createToggle("⏰", "Time Changer", toggleTime)
            createToggle("🌎", "Gravity", toggleGravity)
            createToggle("🌫️", "Fog", toggleFog)
            createToggle("☁️", "Skybox", toggleSkybox)
            createToggle("💡", "Neon World", toggleNeonWorld)
            
        elseif tab == "UTILITY" then
            createToggle("🖱️", "Auto Click", toggleAutoClick)
            createButton("🔄", "Rejoin Server", rejoinServer)
            createButton("🌐", "Server Hop", serverHop)
            createButton("📦", "Infinite Yield", loadIY)
        end
    end

    loadTab("HORROR")
    notify("🔥 MEGA HUB READY! 52 FITUR!")
    print("🔥 UNIVERSAL HUB - MEGA EDITION LOADED")
end
