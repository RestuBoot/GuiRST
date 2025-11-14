-- RU16 / RstHUB - FINAL SINGLE FILE (LocalScript)
-- Place this LocalScript in StarterPlayerScripts
-- Compact UI, avatar toggle (circular), tabs: Players | Menu | Speed
-- Features: Teleport, ESP (name+distance+tracer), Infinite Jump, Noclip (fixed), Touch Fling(500), Anti Fall Damage, Ghost Mode (A), TP Aura

-- ===== Services =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ===== UI Config =====
local UI = {
    Width = 250,
    Height = 300,
    Corner = 12,
    Accent = Color3.fromRGB(255,220,0),
    Bg = Color3.fromRGB(20,20,20),
    Text = Color3.fromRGB(240,240,240),
    EspColor = Color3.fromRGB(255,255,0)
}

-- ===== Helpers =====
local function create(class, props)
    local obj = Instance.new(class)
    if props then for k,v in pairs(props) do obj[k] = v end end
    return obj
end
local function clamp(v,a,b) if v<a then return a elseif v>b then return b else return v end end

-- dragify working for mouse & touch
local function dragify(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(clamp(startPos.X.Scale,0,1), startPos.X.Offset + delta.X, clamp(startPos.Y.Scale,0,1), startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ===== ScreenGui & Avatar Toggle Button =====
local screenGui = create("ScreenGui", { Name = "RU16_RstHUB", Parent = PlayerGui, ResetOnSpawn = false })

-- Avatar Image Button (circular)
local avatarBtn = create("ImageButton", {
    Parent = screenGui,
    Name = "AvatarToggle",
    Size = UDim2.new(0,44,0,44),
    Position = UDim2.new(0,14,0.42,0),
    BackgroundColor3 = UI.Accent,
    BorderSizePixel = 0,
    ScaleType = Enum.ScaleType.Crop,
    Image = "rbxthumb://type=AvatarHeadShot&id="..tostring(LocalPlayer.UserId).."&w=420&h=420"
})
create("UICorner", {Parent = avatarBtn, CornerRadius = UDim.new(0,44)})
create("UICorner", {Parent = avatarBtn, CornerRadius = UDim.new(0,44)})
dragify(avatarBtn)

-- ===== Main Panel (compact) =====
local main = create("Frame", {
    Parent = screenGui, Name = "MainPanel",
    Size = UDim2.new(0, UI.Width, 0, UI.Height), Position = UDim2.new(0.12,0,0.08,0),
    BackgroundColor3 = UI.Bg, Visible = false
})
create("UICorner", { Parent = main, CornerRadius = UDim.new(0,UI.Corner) })
dragify(main)

-- Title & close
local title = create("TextLabel", { Parent = main, Size = UDim2.new(1,-16,0,36), Position = UDim2.new(0,8,0,8), BackgroundTransparency = 1, Text = "RstHUB - Main Panel", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = UI.Text, TextXAlignment = Enum.TextXAlignment.Left })
local closeBtn = create("TextButton", { Parent = main, Size = UDim2.new(0,28,0,24), Position = UDim2.new(1,-36,0,8), Text = "X", Font = Enum.Font.GothamBold, TextSize = 14, BackgroundColor3 = Color3.fromRGB(200,50,50), TextColor3 = Color3.fromRGB(255,255,255) })
create("UICorner", { Parent = closeBtn, CornerRadius = UDim.new(0,6) })
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

-- Tabs header
local tabHeader = create("Frame", { Parent = main, Size = UDim2.new(1,-20,0,36), Position = UDim2.new(0,10,0,52), BackgroundTransparency = 1 })
local function mkTab(text,pos)
    local b = create("TextButton", { Parent = tabHeader, Size = UDim2.new(0.33,-6,1,0), Position = UDim2.new(pos,4,0,0), BackgroundColor3 = Color3.fromRGB(46,46,46), Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = UI.Text })
    create("UICorner", { Parent = b, CornerRadius = UDim.new(0,6) })
    return b
end
local btnPlayers = mkTab("Players",0)
local btnMenu = mkTab("Menu",0.33)
local btnSpeed = mkTab("Speed",0.66)

-- Content area
local content = create("Frame", { Parent = main, Size = UDim2.new(1,-20,1,-108), Position = UDim2.new(0,10,0,100), BackgroundTransparency = 1 })

-- ===== Players tab =====
local playersFrame = create("Frame", { Parent = content, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = true })
local playersScroll = create("ScrollingFrame", { Parent = playersFrame, Size = UDim2.new(1,0,1,0), CanvasSize = UDim2.new(0,0,0,0), ScrollBarThickness = 8, BackgroundTransparency = 1 })
local playersLayout = create("UIListLayout", { Parent = playersScroll }) playersLayout.Padding = UDim.new(0,6)

local function clearChildren(container) for _,c in ipairs(container:GetChildren()) do if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end end end

local function makePlayerLine(plr)
    local btn = create("TextButton", { Parent = playersScroll, Size = UDim2.new(1,-10,0,40), BackgroundColor3 = UI.Accent, Text = plr.Name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(10,10,10) })
    create("UICorner", { Parent = btn, CornerRadius = UDim.new(0,8) })
    btn.MouseButton1Click:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
        end
    end)
    return btn
end

local function refreshPlayers()
    clearChildren(playersScroll)
    for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then makePlayerLine(p) end end
    playersScroll.CanvasSize = UDim2.new(0,0,0, playersLayout.AbsoluteContentSize.Y + 10)
end
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()

-- ===== Menu tab (scrollable) =====
local menuFrame = create("Frame", { Parent = content, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = false })
local menuScroll = create("ScrollingFrame", { Parent = menuFrame, Size = UDim2.new(1,0,1,0), CanvasSize = UDim2.new(0,0,0,0), ScrollBarThickness = 8, BackgroundTransparency = 1 })
local menuLayout = create("UIListLayout", { Parent = menuScroll }) menuLayout.Padding = UDim.new(0,6)

-- Toggle row helper (Label left + small ON/OFF right)
local function makeToggleRow(parent,labelText)
    local row = create("Frame",{ Parent = parent, Size = UDim2.new(1,-10,0,40), BackgroundTransparency = 1 })
    local label = create("TextLabel", { Parent = row, Size = UDim2.new(0.72,0,1,0), BackgroundTransparency = 1, Text = labelText, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = UI.Text })
    local tbtn = create("TextButton", { Parent = row, Size = UDim2.new(0.24,0,0.7,0), Position = UDim2.new(0.72,6,0.15,0), BackgroundColor3 = Color3.fromRGB(220,220,220), Text = "OFF", Font = Enum.Font.Gotham, TextSize = 14 })
    create("UICorner", { Parent = tbtn, CornerRadius = UDim.new(0,6) })
    return row, tbtn
end

local espRow, espToggle = makeToggleRow(menuScroll, "ESP")
local infRow, infToggle = makeToggleRow(menuScroll, "Infinite Jump")
local noclipRow, noclipToggle = makeToggleRow(menuScroll, "Noclip")
local flingRow, flingToggle = makeToggleRow(menuScroll, "Touch Fling")
local antiRow, antiToggle = makeToggleRow(menuScroll, "Anti Fall Damage")
local ghostRow, ghostToggle = makeToggleRow(menuScroll, "Ghost Mode (A)")
local tpRow, tpToggle = makeToggleRow(menuScroll, "TP Aura (Nearest)")

-- fling info
local flingInfo = create("TextLabel", { Parent = menuScroll, Size = UDim2.new(1,-10,0,20), BackgroundTransparency = 1, Text = "Fling Power: 500 (default)", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = UI.Text })

menuLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() menuScroll.CanvasSize = UDim2.new(0,0,0, menuLayout.AbsoluteContentSize.Y + 12) end)

-- ===== Speed tab =====
local speedFrame = create("Frame",{ Parent = content, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = false })
create("TextLabel",{ Parent = speedFrame, Size = UDim2.new(1,-20,0,20), Position = UDim2.new(0,10,0,6), BackgroundTransparency = 1, Text = "WalkSpeed", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = UI.Text, TextXAlignment = Enum.TextXAlignment.Left })
local sliderBg = create("Frame", { Parent = speedFrame, Size = UDim2.new(1,-80,0,18), Position = UDim2.new(0,50,0,36), BackgroundColor3 = Color3.fromRGB(200,200,200) })
create("UICorner", { Parent = sliderBg, CornerRadius = UDim.new(0,6) })
local knob = create("Frame", { Parent = sliderBg, Size = UDim2.new(0.05,0,1,0), Position = UDim2.new(0,0,0,0), BackgroundColor3 = UI.Accent })
create("UICorner", { Parent = knob, CornerRadius = UDim.new(0,6) })
local minusBtn = create("TextButton", { Parent = speedFrame, Size = UDim2.new(0,34,0,26), Position = UDim2.new(0,8,0,32), Text = "-", Font = Enum.Font.GothamBold, TextSize = 18 })
create("UICorner", { Parent = minusBtn, CornerRadius = UDim.new(0,6) })
local plusBtn = create("TextButton", { Parent = speedFrame, Size = UDim2.new(0,34,0,26), Position = UDim2.new(1,-44,0,32), Text = "+", Font = Enum.Font.GothamBold, TextSize = 18 })
create("UICorner", { Parent = plusBtn, CornerRadius = UDim.new(0,6) })
local speedVal = create("TextLabel", { Parent = speedFrame, Size = UDim2.new(0,70,0,26), Position = UDim2.new(0.5,-35,0,32), BackgroundTransparency = 1, Text = "16", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = UI.Text })

local minSpeed, maxSpeed = 16, 100
local function setSpeed(scale)
    scale = clamp(scale,0,1)
    local val = math.floor(minSpeed + scale*(maxSpeed-minSpeed) + 0.5)
    speedVal.Text = tostring(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
    knob.Position = UDim2.new(scale,0,0,0)
end

-- knob drag
local dragging = false
knob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging = true i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end) end end)
knob.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local abs=i.Position local bg=sliderBg.AbsolutePosition local rel=abs.X-bg.X setSpeed(rel / math.max(1, sliderBg.AbsoluteSize.X)) end end)
sliderBg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then local abs=i.Position local bg=sliderBg.AbsolutePosition local rel=abs.X-bg.X setSpeed(rel / math.max(1, sliderBg.AbsoluteSize.X)) end end)

minusBtn.MouseButton1Click:Connect(function() local cur=tonumber(speedVal.Text) or minSpeed setSpeed((cur-1-minSpeed)/(maxSpeed-minSpeed)) end)
plusBtn.MouseButton1Click:Connect(function() local cur=tonumber(speedVal.Text) or minSpeed setSpeed((cur+1-minSpeed)/(maxSpeed-minSpeed)) end)
setSpeed(0) -- default 16

-- tab switching
local function showTab(n)
    playersFrame.Visible = (n=="players")
    menuFrame.Visible = (n=="menu")
    speedFrame.Visible = (n=="speed")
    btnPlayers.BackgroundColor3 = (n=="players") and UI.Accent or Color3.fromRGB(46,46,46)
    btnMenu.BackgroundColor3 = (n=="menu") and UI.Accent or Color3.fromRGB(46,46,46)
    btnSpeed.BackgroundColor3 = (n=="speed") and UI.Accent or Color3.fromRGB(46,46,46)
end
btnPlayers.MouseButton1Click:Connect(function() showTab("players") end)
btnMenu.MouseButton1Click:Connect(function() showTab("menu") end)
btnSpeed.MouseButton1Click:Connect(function() showTab("speed") end)
showTab("players")

-- ===== FEATURES =====

-- ---------- ESP ----------
local espOn = false
local espColor = UI.EspColor
local billboards = {}
local tracers = {}

local function makeESP(plr)
    if not plr.Character then return end
    local head = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
    if not head then return end
    if billboards[plr] then billboards[plr]:Destroy() end
    if tracers[plr] and tracers[plr].Parent then tracers[plr]:Destroy() end

    local bb = create("BillboardGui", { Adornee = head, Size = UDim2.new(0,140,0,22), AlwaysOnTop = true, ExtentsOffset = Vector3.new(0,1.6,0), Parent = head })
    local lbl = create("TextLabel", { Parent = bb, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = plr.Name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = espColor })
    local f = create("Frame", { Parent = screenGui, Size = UDim2.new(0,2,0,2), Position = UDim2.new(0,0,0,0), BackgroundColor3 = espColor, ZIndex = 50 })
    f.AnchorPoint = Vector2.new(0,0.5)
    billboards[plr] = bb
    tracers[plr] = f
end

local function removeESP(plr)
    if billboards[plr] then if billboards[plr].Parent then billboards[plr]:Destroy() end billboards[plr] = nil end
    if tracers[plr] then if tracers[plr].Parent then tracers[plr]:Destroy() end tracers[plr]=nil end
end

local function enableESP()
    espOn = true
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer then
            if p.Character and (p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")) then makeESP(p) end
            p.CharacterAdded:Connect(function() task.wait(0.2) if espOn then makeESP(p) end end)
        end
    end
end
local function disableESP()
    espOn = false
    for p,_ in pairs(billboards) do removeESP(p) end
end

RunService.RenderStepped:Connect(function()
    if not espOn then return end
    local vp = Camera.ViewportSize
    local sx = vp.X * 0.5
    local sy = vp.Y
    for p,bb in pairs(billboards) do
        if p and p.Character and bb and bb.Parent then
            local target = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Head")
            if target then
                local dist = (target.Position - (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Camera.CFrame.Position)).Magnitude
                local label = bb:FindFirstChildOfClass("TextLabel")
                if label then
                    label.Text = string.format("%s | %.1fm", p.Name, dist)
                    label.TextColor3 = espColor
                    label.TextStrokeTransparency = 0.6
                    label.TextStrokeColor3 = Color3.new(0,0,0)
                end
            end
        else
            removeESP(p)
        end
    end
    for p,f in pairs(tracers) do
        if p and p.Character and f and f.Parent then
            local target = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Head")
            if target then
                local onScreen, x, y = Camera:WorldToViewportPoint(target.Position)
                if onScreen then
                    local dx = x - sx
                    local dy = y - sy
                    local len = math.sqrt(dx*dx + dy*dy)
                    if len < 4 then len = 4 end
                    local angle = math.deg(math.atan2(dy, dx))
                    f.Size = UDim2.new(0, clamp(len,2, vp.X*2), 0, 2)
                    f.Position = UDim2.new(0, sx, 0, sy)
                    f.Rotation = angle
                    f.BackgroundColor3 = espColor
                    f.Visible = true
                else
                    f.Visible = false
                end
            else
                f.Visible = false
            end
        else
            removeESP(p)
        end
    end
end)

Players.PlayerAdded:Connect(function(plr) plr.CharacterAdded:Connect(function() task.wait(0.2) if espOn and plr~=LocalPlayer then makeESP(plr) end end) end)
Players.PlayerRemoving:Connect(function(plr) removeESP(plr) refreshPlayers() end)

-- esp toggle
espToggle.MouseButton1Click:Connect(function()
    if not espOn then enableESP() else disableESP() end
    espToggle.Text = espOn and "ON" or "OFF"
    espToggle.BackgroundColor3 = espOn and UI.Accent or Color3.fromRGB(220,220,220)
end)

-- ===== Infinite Jump =====
local infOn = false
infToggle.MouseButton1Click:Connect(function() infOn = not infOn infToggle.Text = infOn and "ON" or "OFF" infToggle.BackgroundColor3 = infOn and UI.Accent or Color3.fromRGB(220,220,220) end)
UserInputService.JumpRequest:Connect(function() if infOn then local c=LocalPlayer.Character if c and c:FindFirstChild("Humanoid") then c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end end)

-- ===== Noclip (fixed) =====
local noclipOn = false
local noclipBackup = {}
local function applyNoclip(state)
    noclipOn = state
    noclipToggle.Text = state and "ON" or "OFF"
    noclipToggle.BackgroundColor3 = state and UI.Accent or Color3.fromRGB(220,220,220)
    local char = LocalPlayer.Character
    if not char then return end
    if state then
        noclipBackup = {}
        for _,p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then noclipBackup[p] = p.CanCollide p.CanCollide = false end
        end
    else
        for part,orig in pairs(noclipBackup) do
            if part and part.Parent then part.CanCollide = orig end
        end
        noclipBackup = {}
        pcall(function() if char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end end)
    end
end
noclipToggle.MouseButton1Click:Connect(function() applyNoclip(not noclipOn) end)
LocalPlayer.CharacterAdded:Connect(function(c) task.wait(0.2) if noclipOn then applyNoclip(true) end end)

-- ===== Touch Fling (500) =====
local flingOn = false
local flingPower = 500
local touchConns = {}
local function onTouched(part)
    if not flingOn then return end
    local pl = Players:GetPlayerFromCharacter(part.Parent)
    if pl and pl~=LocalPlayer then
        local hrp = part.Parent:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function()
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(1e6,1e6,1e6)
                local dir = (hrp.Position - (LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and LocalPlayer.Character.PrimaryPart.Position or hrp.Position)).unit
                bv.Velocity = dir * flingPower + Vector3.new(0,60,0)
                bv.P = 1250
                bv.Parent = hrp
                Debris:AddItem(bv,0.45)
            end)
        end
    end
end

local function bindTouchToCharacter(char)
    for _,part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(touchConns, part.Touched:Connect(onTouched))
        end
    end
end
local function unbindTouches()
    for _,c in ipairs(touchConns) do if c then c:Disconnect() end end
    touchConns = {}
end

local function setFling(state)
    flingOn = state
    flingToggle.Text = state and "ON" or "OFF"
    flingToggle.BackgroundColor3 = state and UI.Accent or Color3.fromRGB(220,220,220)
    unbindTouches()
    if state and LocalPlayer.Character then bindTouchToCharacter(LocalPlayer.Character) end
end
flingToggle.MouseButton1Click:Connect(function() setFling(not flingOn) end)
LocalPlayer.CharacterAdded:Connect(function(c) task.wait(0.2) if flingOn then bindTouchToCharacter(c) end end)

-- ===== Anti Fall Damage =====
local antiOn = false
local lastSafe = nil
antiToggle.MouseButton1Click:Connect(function() antiOn = not antiOn antiToggle.Text = antiOn and "ON" or "OFF" antiToggle.BackgroundColor3 = antiOn and UI.Accent or Color3.fromRGB(220,220,220) end)
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        if hum.FloorMaterial and hum.FloorMaterial ~= Enum.Material.Air and hum.Health > 0 then lastSafe = hrp.Position end
        if antiOn then
            if hrp.Position.Y < -60 then
                if lastSafe then hrp.CFrame = CFrame.new(lastSafe + Vector3.new(0,3,0)) else
                    local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
                    if spawn then hrp.CFrame = spawn.CFrame + Vector3.new(0,3,0) else hrp.CFrame = CFrame.new(0,5,0) end
                end
            end
            -- heal if very fast falling
            local vel = hrp.Velocity
            if vel and vel.Y < -80 and hum.Health > 0 then
                hum.Health = hum.MaxHealth
            end
        end
    end
end)

-- ===== Ghost Mode (A) client-side invis =====
local ghostOn = false
local ghostBackup = {}
local function setGhost(state)
    ghostOn = state
    ghostToggle.Text = state and "ON" or "OFF"
    ghostToggle.BackgroundColor3 = state and UI.Accent or Color3.fromRGB(220,220,220)
    local char = LocalPlayer.Character
    if not char then return end
    if state then
        ghostBackup = {}
        for _,d in ipairs(char:GetDescendants()) do
            if d:IsA("BasePart") then
                ghostBackup[d] = {trans = d.Transparency, coll = d.CanCollide}
                d.Transparency = 1
                d.CanCollide = false
            elseif d:IsA("Decal") or d:IsA("Texture") then
                ghostBackup[d] = {trans = d.Transparency}
                d.Transparency = 1
            elseif d:IsA("BillboardGui") or d:IsA("SurfaceGui") then
                ghostBackup[d] = {parent = d.Parent}
                d.Parent = nil
            end
        end
    else
        for part,data in pairs(ghostBackup) do
            if part and part.Parent then
                if data.trans ~= nil then part.Transparency = data.trans end
                if data.coll ~= nil then part.CanCollide = data.coll end
            end
        end
        ghostBackup = {}
    end
end
ghostToggle.MouseButton1Click:Connect(function() setGhost(not ghostOn) end)
LocalPlayer.CharacterAdded:Connect(function() task.wait(0.3) if ghostOn then setGhost(true) end end)

-- ===== TP Aura (nearest) =====
local tpOn = false
local tpRange = 60
local tpDelay = 0.45
local tpThread = nil
local function setTpAura(state)
    tpOn = state
    tpToggle.Text = state and "ON" or "OFF"
    tpToggle.BackgroundColor3 = state and UI.Accent or Color3.fromRGB(220,220,220)
    if state then
        if tpThread then return end
        tpThread = task.spawn(function()
            while tpOn do
                task.wait(tpDelay)
                local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
                if not myPos then goto cont end
                local best, bd = nil, math.huge
                for _,p in ipairs(Players:GetPlayers()) do
                    if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local d = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
                        if d < bd and d <= tpRange then best,bd = p,d end
                    end
                end
                if best and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and best.Character and best.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = best.Character.HumanoidRootPart.CFrame + Vector3.new(1.5,0,0)
                end
                ::cont::
            end
            tpThread = nil
        end)
    else
        tpOn = false
    end
end
tpToggle.MouseButton1Click:Connect(function() setTpAura(not tpOn) end)

-- ===== UI update for scrolls and initial visuals =====
playersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() playersScroll.CanvasSize = UDim2.new(0,0,0, playersLayout.AbsoluteContentSize.Y + 10) end)
menuLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() menuScroll.CanvasSize = UDim2.new(0,0,0, menuLayout.AbsoluteContentSize.Y + 12) end)
menuScroll.CanvasSize = UDim2.new(0,0,0, menuLayout.AbsoluteContentSize.Y + 12)
playersScroll.CanvasSize = UDim2.new(0,0,0, playersLayout.AbsoluteContentSize.Y + 10)

-- Helpers set visuals
local function setToggleVisual(btn, state)
    pcall(function() btn.Text = state and "ON" or "OFF" btn.BackgroundColor3 = state and UI.Accent or Color3.fromRGB(220,220,220) end)
end

-- initialize visuals
setToggleVisual(espToggle, espOn)
setToggleVisual(infToggle, infOn)
setToggleVisual(noclipToggle, noclipOn)
setToggleVisual(flingToggle, flingOn)
setToggleVisual(antiToggle, antiOn)
setToggleVisual(ghostToggle, ghostOn)
setToggleVisual(tpToggle, tpOn)

-- ensure reapply on respawn
LocalPlayer.CharacterAdded:Connect(function(c) task.wait(0.35) if noclipOn then applyNoclip(true) end if ghostOn then setGhost(true) end if flingOn then setFling(true) end end)

-- toggle main via avatar button
avatarBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    if main.Visible then refreshPlayers() end
end)

-- cleanup when leaving
LocalPlayer.AncestryChanged:Connect(function()
    if not LocalPlayer:IsDescendantOf(game) then
        disableESP()
        unbindTouches()
        for p,_ in pairs(billboards) do removeESP(p) end
        for p,_ in pairs(tracers) do removeESP(p) end
    end
end)

-- End of script