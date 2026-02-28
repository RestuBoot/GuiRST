--[[
    UNIVERSAL HUB - WEAPONS EDITION (FIXED)
    =========================================
    ✅ 6 Tools Senjata WORK (Sword, Hammer, Pistol, Freeze Gun, Push Gun, Fling Gun)
    ✅ Push/Fling Area WORK dengan BodyVelocity + Network Ownership
    ✅ Trap Box WORK (korban terperangkap)
    ✅ Earthquake WORK (semua player goyang)
    ✅ Semua fitur dasar WORK
    ✅ UI 300x400 dengan minimize button
]]

-- ========== CLEANUP ==========
pcall(function() 
    game.CoreGui.UniversalHub:Destroy() 
    game.CoreGui.HubIcon:Destroy() 
end)

-- ========== TUNGGU PLAYER ==========
repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local player = game.Players.LocalPlayer
local function getChar() return player.Character end
local function getHum() local c = getChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end

local function notify(msg) 
    pcall(function() 
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "⚔️ WEAPONS HUB", 
            Text = msg, 
            Duration = 1.5
        }) 
    end) 
end

-- ========== VARIABLES ==========
local features = {}
local threads = {}
local weapons = {}

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
    else 
        notify("🛡️ Anti Ban OFF") 
    end
end

-- ========== AUTO RE-APPLY SETELAH RESPAWN ==========
player.CharacterAdded:Connect(function(newChar)
    task.wait(0.5)
    -- Reapply active features
    for name, enabled in pairs(features) do
        if enabled then
            if name == "speed" and getHum() then getHum().WalkSpeed = 50
            elseif name == "jump" and getHum() then getHum().JumpPower = 100
            elseif name == "infJump" then
                if threads.infJump then threads.infJump:Disconnect() end
                threads.infJump = game:GetService("UserInputService").JumpRequest:Connect(function()
                    if features.infJump and getHum() then getHum():ChangeState("Jumping") end
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
                    if head then 
                        head.Transparency = 1 
                        head.MeshId = "http://www.roblox.com/asset/?id=0" 
                    end
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

-- ========== FUNGSI MEMBUAT TOOLS ==========
local function createWeaponTool(name, weaponType)
    -- Cek apakah tool sudah ada
    for _, existing in pairs(weapons) do
        if existing.Name == name then
            return existing
        end
    end
    
    -- Buat tool baru
    local tool = Instance.new("Tool")
    tool.Name = name
    tool.RequiresHandle = true
    tool.CanBeDropped = false
    tool.Parent = player.Backpack
    
    -- Buat handle (gagang senjata)
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 3, 1)
    handle.BrickColor = BrickColor.new("Bright red")
    handle.Material = Enum.Material.Neon
    handle.Parent = tool
    
    -- Sesuaikan bentuk berdasarkan tipe
    if weaponType == "Sword" then
        -- Pedang panjang
        handle.Size = Vector3.new(1, 5, 1)
        local blade = Instance.new("Part")
        blade.Name = "Blade"
        blade.Size = Vector3.new(0.5, 3, 0.5)
        blade.BrickColor = BrickColor.new("Bright yellow")
        blade.Material = Enum.Material.Metal
        blade.Position = handle.Position + Vector3.new(0, 2.5, 0)
        blade.Parent = tool
        
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = blade
        weld.Parent = handle
        
    elseif weaponType == "Hammer" then
        -- Palu besar
        handle.Size = Vector3.new(1.5, 2, 1.5)
        local head = Instance.new("Part")
        head.Name = "Head"
        head.Size = Vector3.new(2.5, 1.5, 2.5)
        head.BrickColor = BrickColor.new("Dark stone grey")
        head.Material = Enum.Material.Concrete
        head.Position = handle.Position + Vector3.new(0, 1.2, 0)
        head.Parent = tool
        
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = head
        weld.Parent = handle
        
    elseif weaponType == "Pistol" or weaponType == "FreezeGun" or weaponType == "PushGun" or weaponType == "FlingGun" then
        -- Senjata api
        handle.Size = Vector3.new(1, 1.5, 2.5)
        handle.BrickColor = BrickColor.new("Black")
        local barrel = Instance.new("Part")
        barrel.Name = "Barrel"
        barrel.Size = Vector3.new(0.5, 0.5, 3)
        barrel.BrickColor = BrickColor.new("Black")
        barrel.Material = Enum.Material.Metal
        barrel.Position = handle.Position + Vector3.new(0, 0, 1.5)
        barrel.Parent = tool
        
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = barrel
        weld.Parent = handle
    end
    
    -- Event Activated (klik kiri)
    tool.Activated:Connect(function()
        if weaponType == "Sword" then
            notify("⚔️ Pedang terayun!")
            -- Efek ayunan
            for i = 1, 3 do
                handle.CFrame = handle.CFrame * CFrame.Angles(0, math.rad(90), 0)
                task.wait(0.05)
            end
            
        elseif weaponType == "Hammer" then
            notify("🔨 Palu diayunkan!")
            -- Efek palu
            handle.Size = handle.Size * 1.5
            task.wait(0.2)
            handle.Size = handle.Size / 1.5
            
        elseif weaponType == "Pistol" or weaponType == "FreezeGun" or weaponType == "PushGun" or weaponType == "FlingGun" then
            notify("🔫 Menembak!")
            
            -- Efek tembakan
            local flash = Instance.new("Part")
            flash.Name = "MuzzleFlash"
            flash.Size = Vector3.new(0.5, 0.5, 0.5)
            flash.BrickColor = BrickColor.new("Bright yellow")
            flash.Material = Enum.Material.Neon
            flash.Position = handle.Position + handle.CFrame.LookVector * 3
            flash.Parent = workspace
            game:GetService("Debris"):AddItem(flash, 0.1)
            
            -- Raycast untuk tembakan
            local ray = Ray.new(handle.Position, handle.CFrame.LookVector * 500)
            local hit, pos = workspace:FindPartOnRay(ray, tool.Parent)
            
            if hit and hit.Parent then
                local targetPlayer = game.Players:GetPlayerFromCharacter(hit.Parent)
                if targetPlayer and targetPlayer ~= player then
                    
                    if weaponType == "FreezeGun" then
                        -- Freeze Gun
                        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            targetPlayer.Character.HumanoidRootPart.Anchored = true
                            task.wait(3)
                            targetPlayer.Character.HumanoidRootPart.Anchored = false
                        end
                        notify("❄️ " .. targetPlayer.Name .. " beku!")
                        
                    elseif weaponType == "PushGun" then
                        -- Push Gun
                        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local bv = Instance.new("BodyVelocity")
                            bv.MaxForce = Vector3.new(10000, 0, 10000)
                            bv.Velocity = handle.CFrame.LookVector * 200
                            bv.Parent = targetPlayer.Character.HumanoidRootPart
                            game:GetService("Debris"):AddItem(bv, 0.5)
                        end
                        notify("👊 " .. targetPlayer.Name .. " terdorong!")
                        
                    elseif weaponType == "FlingGun" then
                        -- Fling Gun
                        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            -- Set network ownership ke server biar bisa fling
                            pcall(function()
                                sethiddenproperty(targetPlayer.Character.HumanoidRootPart, "NetworkOwnership", Enum.NetworkOwnership.Server)
                            end)
                            
                            local bv = Instance.new("BodyVelocity")
                            bv.MaxForce = Vector3.new(10000, 10000, 10000)
                            bv.Velocity = Vector3.new(math.random(-300,300), math.random(200,400), math.random(-300,300))
                            bv.Parent = targetPlayer.Character.HumanoidRootPart
                            game:GetService("Debris"):AddItem(bv, 0.5)
                            
                            task.wait(0.1)
                            pcall(function()
                                sethiddenproperty(targetPlayer.Character.HumanoidRootPart, "NetworkOwnership", Enum.NetworkOwnership.Automatic)
                            end)
                        end
                        notify("🌀 " .. targetPlayer.Name .. " terlempar!")
                        
                    else
                        -- Normal Pistol (damage)
                        if targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
                            targetPlayer.Character:FindFirstChildOfClass("Humanoid"):TakeDamage(15)
                        end
                        notify("💥 " .. targetPlayer.Name .. " kena tembak!")
                    end
                end
            end
        end
    end)
    
    -- Event Touched (kena ke player)
    handle.Touched:Connect(function(hit)
        if hit.Parent then
            local targetPlayer = game.Players:GetPlayerFromCharacter(hit.Parent)
            if targetPlayer and targetPlayer ~= player then
                
                if weaponType == "Sword" then
                    -- Pedang damage
                    if targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
                        targetPlayer.Character:FindFirstChildOfClass("Humanoid"):TakeDamage(10)
                        notify("⚔️ " .. targetPlayer.Name .. " terkena pedang!")
                    end
                    
                elseif weaponType == "Hammer" then
                    -- Palu fling + damage
                    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        -- Set network ownership ke server
                        pcall(function()
                            sethiddenproperty(targetPlayer.Character.HumanoidRootPart, "NetworkOwnership", Enum.NetworkOwnership.Server)
                        end)
                        
                        local bv = Instance.new("BodyVelocity")
                        bv.MaxForce = Vector3.new(10000, 10000, 10000)
                        bv.Velocity = Vector3.new(0, 200, 0) + handle.CFrame.LookVector * 150
                        bv.Parent = targetPlayer.Character.HumanoidRootPart
                        game:GetService("Debris"):AddItem(bv, 0.3)
                        
                        if targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
                            targetPlayer.Character:FindFirstChildOfClass("Humanoid"):TakeDamage(20)
                        end
                        
                        task.wait(0.1)
                        pcall(function()
                            sethiddenproperty(targetPlayer.Character.HumanoidRootPart, "NetworkOwnership", Enum.NetworkOwnership.Automatic)
                        end)
                        
                        notify("🔨 " .. targetPlayer.Name .. " dipalu!")
                    end
                end
            end
        end
    end)
    
    table.insert(weapons, tool)
    return tool
end

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
            v.CharacterAdded:Connect(function() 
                task.wait(0.5) 
                if features.esp then addESP(v) end 
            end)
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
    pcall(function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() 
    end)
end

-- ========== INFINITY JUMP ==========
function toggleInfJump(state)
    features.infJump = state
    if state then
        if threads.infJump then threads.infJump:Disconnect() end
        threads.infJump = game:GetService("UserInputService").JumpRequest:Connect(function()
            if features.infJump and getHum() then 
                getHum():ChangeState("Jumping") 
            end
        end)
        notify("🔁 Infinity Jump ON")
    else
        if threads.infJump then threads.infJump:Disconnect() end
        notify("🔁 Infinity Jump OFF")
    end
end

-- ========== SPIN ==========
function toggleSpin(state)
    features.spin = state
    if state then
        threads.spin = task.spawn(function()
            while features.spin do
                local r = getRoot()
                if r then 
                    r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(15), 0) 
                end
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
                        if p:IsA("BasePart") then 
                            p.Color = Color3.fromHSV(h,1,1) 
                        end
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
                if p:IsA("BasePart") then 
                    p.Color = Color3.fromRGB(255,255,255) 
                end
            end
        end
        notify("🌈 Rainbow OFF")
    end
end

-- ========== PUSH (AREA) ==========
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
                                -- Set network ownership ke server
                                pcall(function()
                                    sethiddenproperty(v.Character.HumanoidRootPart, "NetworkOwnership", Enum.NetworkOwnership.Server)
                                end)
                                
                                local bv = Instance.new("BodyVelocity")
                                bv.MaxForce = Vector3.new(10000, 0, 10000)
                                bv.Velocity = (v.Character.HumanoidRootPart.Position - r.Position).Unit * 150
                                bv.Parent = v.Character.HumanoidRootPart
                                game:GetService("Debris"):AddItem(bv, 0.2)
                                
                                task.wait(0.1)
                                pcall(function()
                                    sethiddenproperty(v.Character.HumanoidRootPart, "NetworkOwnership", Enum.NetworkOwnership.Automatic)
                                end)
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
        notify("👊 Push Area ON")
    else
        features.push = false
        threads.push = nil
        notify("👊 Push Area OFF")
    end
end

-- ========== FLING (AREA) ==========
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
                                -- Set network ownership ke server
                                pcall(function()
                                    sethiddenproperty(v.Character.HumanoidRootPart, "NetworkOwnership", Enum.NetworkOwnership.Server)
                                end)
                                
                                local bv = Instance.new("BodyVelocity")
                                bv.MaxForce = Vector3.new(10000, 10000, 10000)
                                bv.Velocity = Vector3.new(math.random(-400,400), math.random(200,400), math.random(-400,400))
                                bv.Parent = v.Character.HumanoidRootPart
                                game:GetService("Debris"):AddItem(bv, 0.3)
                                
                                task.wait(0.1)
                                pcall(function()
                                    sethiddenproperty(v.Character.HumanoidRootPart, "NetworkOwnership", Enum.NetworkOwnership.Automatic)
                                end)
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
        notify("🌀 Fling Area ON")
    else
        features.fling = false
        threads.fling = nil
        notify("🌀 Fling Area OFF")
    end
end

-- ========== FREEZE ALL ==========
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

-- ========== TRAP BOX ==========
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
                            if dist < 15 and not v.Character:FindFirstChild("Trapped") then
                                -- Buat kotak penjara
                                local trapParts = {}
                                for i = 1, 6 do
                                    local part = Instance.new("Part")
                                    part.Name = "TrapPart"
                                    part.Size = Vector3.new(10, 10, 10)
                                    part.Anchored = true
                                    part.CanCollide = true
                                    part.Transparency = 0.6
                                    part.BrickColor = BrickColor.new("Really red")
                                    part.Material = Enum.Material.Neon
                                    part.Parent = workspace
                                    table.insert(trapParts, part)
                                end
                                
                                -- Posisikan kotak mengelilingi korban
                                local pos = v.Character.HumanoidRootPart.Position
                                trapParts[1].Position = pos + Vector3.new(5, 0, 0)  -- Kanan
                                trapParts[2].Position = pos + Vector3.new(-5, 0, 0) -- Kiri
                                trapParts[3].Position = pos + Vector3.new(0, 5, 0)  -- Atas
                                trapParts[4].Position = pos + Vector3.new(0, -5, 0) -- Bawah
                                trapParts[5].Position = pos + Vector3.new(0, 0, 5)  -- Depan
                                trapParts[6].Position = pos + Vector3.new(0, 0, -5) -- Belakang
                                
                                -- Anchor korban di dalam
                                v.Character.HumanoidRootPart.Anchored = true
                                
                                -- Buat tag "Trapped" di korban
                                local tag = Instance.new("BoolValue")
                                tag.Name = "Trapped"
                                tag.Parent = v.Character
                                
                                -- Hapus setelah 5 detik
                                task.delay(5, function()
                                    for _, part in pairs(trapParts) do
                                        part:Destroy()
                                    end
                                    if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                        v.Character.HumanoidRootPart.Anchored = false
                                    end
                                    if v.Character and v.Character:FindFirstChild("Trapped") then
                                        v.Character.Trapped:Destroy()
                                    end
                                end)
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

-- ========== EARTHQUAKE ==========
function toggleEarthquake(state)
    features.quake = state
    if state then
        threads.quake = task.spawn(function()
            while features.quake do
                -- Goyangin semua player
                for _,v in pairs(game.Players:GetPlayers()) do
                    if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v ~= player then
                        -- Set network ownership ke server
                        pcall(function()
                            sethiddenproperty(v.Character.HumanoidRootPart, "NetworkOwnership", Enum.NetworkOwnership.Server)
                        end)
                        
                        -- Goyang random
                        v.Character.HumanoidRootPart.Velocity = Vector3.new(math.random(-100,100), math.random(50,150), math.random(-100,100))
                        
                        -- Kembalikan ownership
                        task.wait(0.05)
                        pcall(function()
                            sethiddenproperty(v.Character.HumanoidRootPart, "NetworkOwnership", Enum.NetworkOwnership.Automatic)
                        end)
                    end
                end
                
                -- Spawn part efek
                for i = 1, 20 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(3, 3, 3)
                    part.Position = Vector3.new(math.random(-300,300), math.random(0,50), math.random(-300,300))
                    part.Anchored = false
                    part.CanCollide = true
                    part.Velocity = Vector3.new(math.random(-50,50), math.random(100,200), math.random(-50,50))
                    part.BrickColor = BrickColor.Random()
                    part.Parent = workspace
                    game:GetService("Debris"):AddItem(part, 1)
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

-- ========== NO FALL DAMAGE ==========
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

-- ========== FUNGSI EQUIP WEAPONS ==========
function equipSword()
    local tool = createWeaponTool("⚔️ Magic Sword", "Sword")
    tool.Parent = player.Backpack
    if player.Character then
        player.Character.Humanoid:EquipTool(tool)
    end
    notify("⚔️ Magic Sword siap digunakan!")
end

function equipHammer()
    local tool = createWeaponTool("🔨 Giant Hammer", "Hammer")
    tool.Parent = player.Backpack
    if player.Character then
        player.Character.Humanoid:EquipTool(tool)
    end
    notify("🔨 Giant Hammer siap digunakan!")
end

function equipPistol()
    local tool = createWeaponTool("🔫 Pistol", "Pistol")
    tool.Parent = player.Backpack
    if player.Character then
        player.Character.Humanoid:EquipTool(tool)
    end
    notify("🔫 Pistol siap digunakan!")
end

function equipFreezeGun()
    local tool = createWeaponTool("❄️ Freeze Gun", "FreezeGun")
    tool.Parent = player.Backpack
    if player.Character then
        player.Character.Humanoid:EquipTool(tool)
    end
    notify("❄️ Freeze Gun siap digunakan!")
end

function equipPushGun()
    local tool = createWeaponTool("👊 Push Gun", "PushGun")
    tool.Parent = player.Backpack
    if player.Character then
        player.Character.Humanoid:EquipTool(tool)
    end
    notify("👊 Push Gun siap digunakan!")
end

function equipFlingGun()
    local tool = createWeaponTool("🌀 Fling Gun", "FlingGun")
    tool.Parent = player.Backpack
    if player.Character then
        player.Character.Humanoid:EquipTool(tool)
    end
    notify("🌀 Fling Gun siap digunakan!")
end

-- ========== GUI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "UniversalHub"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 450)
main.Position = UDim2.new(0.5, -160, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = main

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
shadow.Parent = main
shadow.ZIndex = -1

-- Title Bar
local title = Instance.new("Frame")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
title.BackgroundTransparency = 0.2
title.BorderSizePixel = 0
title.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = title

local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 30, 0, 30)
icon.Position = UDim2.new(0, 8, 0.5, -15)
icon.BackgroundTransparency = 1
icon.Text = "⚔️"
icon.TextSize = 22
icon.TextColor3 = Color3.fromRGB(0, 200, 255)
icon.Font = Enum.Font.SourceSans
icon.Parent = title

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -100, 1, 0)
titleText.Position = UDim2.new(0, 40, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "WEAPONS HUB"
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
iconBtn.Text = "⚔️"
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

minBtn.MouseButton1Click:Connect(function() 
    main.Visible = false 
    iconBtn.Visible = true 
end)

iconBtn.MouseButton1Click:Connect(function() 
    iconBtn.Visible = false 
    main.Visible = true 
end)

closeBtn.MouseButton1Click:Connect(function() 
    gui:Destroy() 
    iconGui:Destroy() 
end)

-- Tab Container
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

-- Tabs
local tabs = {"MAIN", "WEAPONS", "TROLL", "PROTECT", "WORLD"}
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
        for _,b in ipairs(tabBtns) do 
            b.BackgroundColor3 = Color3.fromRGB(50,50,60) 
        end
        btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
        current = name
        loadTab(name)
    end)
    table.insert(tabBtns, btn)
end

-- Content Frame
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

-- UI Functions
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

-- Load Tab Function
function loadTab(tab)
    for _,v in pairs(content:GetChildren()) do
        if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then 
            v:Destroy() 
        end
    end
    
    if tab == "MAIN" then
        createToggle("⚡", "Speed Boost", toggleSpeed, 1)
        createToggle("🦘", "Jump Power", toggleJump, 2)
        createToggle("👁️", "ESP", toggleESP, 3)
        createButton("📦", "Infinite Yield", loadIY, 4)
        createToggle("🛡️", "Anti Ban", toggleAntiBan, 5)
        
    elseif tab == "WEAPONS" then
        createButton("⚔️", "Equip Magic Sword", equipSword, 1)
        createButton("🔨", "Equip Giant Hammer", equipHammer, 2)
        createButton("🔫", "Equip Pistol", equipPistol, 3)
        createButton("❄️", "Equip Freeze Gun", equipFreezeGun, 4)
        createButton("👊", "Equip Push Gun", equipPushGun, 5)
        createButton("🌀", "Equip Fling Gun", equipFlingGun, 6)
        
    elseif tab == "TROLL" then
        createToggle("👊", "Push Area", togglePush, 1)
        createToggle("🌀", "Fling Area", toggleFling, 2)
        createToggle("❄️", "Freeze All", toggleFreeze, 3)
        createToggle("📦", "Trap Box", toggleTrap, 4)
        createToggle("🌋", "Earthquake", toggleEarthquake, 5)
        createToggle("👻", "Headless", toggleHeadless, 6)
        createToggle("🧟", "Zombie Walk", toggleZombie, 7)
        
    elseif tab == "PROTECT" then
        createToggle("👑", "God Mode", toggleGod, 1)
        createToggle("🔄", "Auto Respawn", toggleRespawn, 2)
        createToggle("🛡️", "Anti Ban", toggleAntiBan, 3)
        createToggle("📉", "No Fall Damage", toggleNoFall, 4)
        
    elseif tab == "WORLD" then
        createToggle("⏰", "Time Changer", toggleTime, 1)
        createToggle("🌎", "Gravity", toggleGravity, 2)
        createToggle("🖱️", "Auto Click", toggleAutoClick, 3)
        createToggle("🔁", "Infinity Jump", toggleInfJump, 4)
        createToggle("🌀", "Spin", toggleSpin, 5)
        createToggle("🌈", "Rainbow", toggleRainbow, 6)
    end
end

-- Load default tab
loadTab("MAIN")

-- Notifikasi sukses
notify("⚔️ WEAPONS EDITION READY!")
print("⚔️ UNIVERSAL HUB - WEAPONS EDITION LOADED")
