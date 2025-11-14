-- RU16 / RstHUB - FINAL (Single LocalScript, compact, yellow-black)
-- Place in StarterPlayerScripts
--  - Tabs: Players | Menu | Speed
--  - Players = teleport list (scroll)
--  - Menu = ESP, InfJump, Noclip (fixed), TouchFling (500), AntiFallDamage, GhostMode(A), TP Aura
--  - Speed = slider (16-100)
--  - Compact UI: width ~260, height ~300; rounded corners; theme yellow/black

-- ===== services & locals =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ===== UI settings =====
local UI = {
    Width = 260, Height = 300,
    Corner = 12,
    Accent = Color3.fromRGB(255,220,0),
    Bg = Color3.fromRGB(24,24,24),
    Text = Color3.fromRGB(255,255,255),
    EspColor = Color3.fromRGB(255,255,0)
}

-- ===== helpers =====
local function create(class, props)
    local obj = Instance.new(class)
    if props then for k,v in pairs(props) do obj[k] = v end end
    return obj
end
local function clamp(v,a,b) if v<a then return a elseif v>b then return b else return v end end

-- dragify helper (mouse + touch)
local function dragify(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

-- ===== ScreenGui & Toggle =====
local screenGui = create("ScreenGui", { Name = "RU16_RstHUB", Parent = PlayerGui, ResetOnSpawn = false })
local toggleBtn = create("TextButton", {
    Parent = screenGui, Name = "ToggleBtn",
    Size = UDim2.new(0,40,0,40), Position = UDim2.new(0,16,0.42,0),
    BackgroundColor3 = UI.Accent, Text = "≡", Font = Enum.Font.GothamBold, TextSize = 22, AutoButtonColor = true
})
create("UICorner", { Parent = toggleBtn, CornerRadius = UDim.new(0,8) })
dragify(toggleBtn)

-- ===== Main Panel (compact) =====
local main = create("Frame", {
    Parent = screenGui, Name = "MainPanel",
    Size = UDim2.new(0, UI.Width, 0, UI.Height), Position = UDim2.new(0.12,0,0.08,0),
    BackgroundColor3 = UI.Bg, Visible = false
})
create("UICorner", { Parent = main, CornerRadius = UDim.new(0,UI.Corner) })
dragify(main)

-- Title + close
local title = create("TextLabel", { Parent = main, Size = UDim2.new(1,-16,0,36), Position = UDim2.new(0,8,0,8), BackgroundTransparency = 1, Text = "RstHUB - Main Panel", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = UI.Text, TextXAlignment = Enum.TextXAlignment.Left })
local closeBtn = create("TextButton", { Parent = main, Size = UDim2.new(0,28,0,24), Position = UDim2.new(1, -36, 0, 8), Text = "X", Font = Enum.Font.GothamBold, TextSize = 14, BackgroundColor3 = Color3.fromRGB(200,50,50), TextColor3 = Color3.fromRGB(255,255,255) })
create("UICorner", { Parent = closeBtn, CornerRadius = UDim.new(0,6) })
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

-- Tabs header
local tabHeader = create("Frame", { Parent = main, Size = UDim2.new(1, -20, 0, 36), Position = UDim2.new(0,10,0,52), BackgroundTransparency = 1 })
local function mkTab(text, pos)
    local b = create("TextButton", { Parent = tabHeader, Size = UDim2.new(0.33, -6, 1, 0), Position = UDim2.new(pos, 4, 0, 0), BackgroundColor3 = Color3.fromRGB(46,46,46), Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = UI.Text })
    create("UICorner", { Parent = b, CornerRadius = UDim.new(0,6) })
    return b
end
local btnPlayers = mkTab("Players", 0)
local btnMenu = mkTab("Menu", 0.33)
local btnSpeed = mkTab("Speed", 0.66)

-- Content area
local content = create("Frame", { Parent = main, Size = UDim2.new(1,-20,1,-108), Position = UDim2.new(0,10,0,100), BackgroundTransparency = 1 })

-- ===== PLAYERS TAB =====
local playersFrame = create("Frame", { Parent = content, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = true })
local playersScroll = create("ScrollingFrame", { Parent = playersFrame, Size = UDim2.new(1,0,1,0), CanvasSize = UDim2.new(0,0,0,0), ScrollBarThickness = 8, BackgroundTransparency = 1 })
local playersLayout = create("UIListLayout", { Parent = playersScroll })
playersLayout.Padding = UDim.new(0,6)

local function clearChildren(container)
    for _,c in ipairs(container:GetChildren()) do if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end end end

local function createPlayerLine(plr)
    local btn = create("TextButton", {
        Parent = playersScroll, Size = UDim2.new(1,-10,0,40), BackgroundColor3 = UI.Accent, Text = plr.Name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(10,10,10)
    })
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
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then createPlayerLine(p) end
    end
    playersScroll.CanvasSize = UDim2.new(0,0,0, playersLayout.AbsoluteContentSize.Y + 10)
end
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()

-- ===== MENU TAB (scrollable) =====
local menuFrame = create("Frame", { Parent = content, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = false })
local menuScroll = create("ScrollingFrame", { Parent = menuFrame, Size = UDim2.new(1,0,1,0), CanvasSize = UDim2.new(0,0,0,0), ScrollBarThickness = 8, BackgroundTransparency = 1 })
local menuLayout = create("UIListLayout", { Parent = menuScroll })
menuLayout.Padding = UDim.new(0,6)

-- toggle-row helper (label left + small ON/OFF right - style A)
local function makeToggleRow(parent, labelText, startState)
    local row = create("Frame", { Parent = parent, Size = UDim2.new(1,-10,0,42), BackgroundTransparency = 1 })
    local lbl = create("TextLabel", { Parent = row, Size = UDim2.new(0.72,0,1,0), BackgroundTransparency = 1, Text = labelText, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = UI.Text })
    local tbtn = create("TextButton", { Parent = row, Size = UDim2.new(0.24, 0, 0.7, 0), Position = UDim2.new(0.72,6,0.15,0), BackgroundColor3 = startState and UI.Accent or Color3.fromRGB(220,220,220), Text = startState and "ON" or "OFF", Font = Enum.Font.Gotham, TextSize = 14 })
    create("UICorner", { Parent = tbtn, CornerRadius = UDim.new(0,6) })
    return row, tbtn
end

-- create toggles rows:
local espRow, espToggle = makeToggleRow(menuScroll, "ESP", false)
local infRow, infToggle = makeToggleRow(menuScroll, "Infinite Jump", false)
local noclipRow, noclipToggle = makeToggleRow(menuScroll, "Noclip", false)
local flingRow, flingToggle = makeToggleRow(menuScroll, "Touch Fling", false)
local antiRow, antiToggle = makeToggleRow(menuScroll, "Anti Fall Damage", false)
local ghostRow, ghostToggle = makeToggleRow(menuScroll, "Ghost Mode (A)", false)
local tpAuraRow, tpAuraToggle = makeToggleRow(menuScroll, "TP Aura (Nearest)", false)

-- extra UI for fling power display (fixed 500 default)
local flingInfo = create("TextLabel", { Parent = menuScroll, Size = UDim2.new(1,-10,0,22), BackgroundTransparency = 1, Text = "Fling Power: 500 (default)", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = UI.Text })
-- keep menu canvas updated when layout changes
menuLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    menuScroll.CanvasSize = UDim2.new(0,0,0, menuLayout.AbsoluteContentSize.Y + 12)
end)

-- ===== SPEED TAB =====
local speedFrame = create("Frame", { Parent = content, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = false })
create("TextLabel", { Parent = speedFrame, Size = UDim2.new(1,-20,0,20), Position = UDim2.new(0,10,0,6), BackgroundTransparency = 1, Text = "WalkSpeed", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = UI.Text, TextXAlignment = Enum.TextXAlignment.Left })
local sliderBg = create("Frame", { Parent = speedFrame, Size = UDim2.new(1,-80,0,18), Position = UDim2.new(0,50,0,36), BackgroundColor3 = Color3.fromRGB(200,200,200) })
create("UICorner", { Parent = sliderBg, CornerRadius = UDim.new(0,6) })
local knob = create("Frame", { Parent = sliderBg, Size = UDim2.new(0.05,0,1,0), Position = UDim2.new(0,0,0,0), BackgroundColor3 = UI.Accent })
create("UICorner", { Parent = knob, CornerRadius = UDim.new(0,6) })
local minusBtn = create("TextButton", { Parent = speedFrame, Size = UDim2.new(0,34,0,26), Position = UDim2.new(0,8,0,32), Text = "-", Font = Enum.Font.GothamBold, TextSize = 18 })
create("UICorner", { Parent = minusBtn, CornerRadius = UDim.new(0,6) })
local plusBtn = create("TextButton", { Parent = speedFrame, Size = UDim2.new(0,34,0,26), Position = UDim2.new(1,-44,0,32), Text = "+", Font = Enum.Font.GothamBold, TextSize = 18 })
create("UICorner", { Parent = plusBtn, CornerRadius = UDim.new(0,6) })
local speedValLabel = create("TextLabel", { Parent = speedFrame, Size = UDim2.new(0,70,0,26), Position = UDim2.new(0.5, -35, 0, 32), BackgroundTransparency = 1, Text = "16", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = UI.Text })

local minSpeed, maxSpeed = 16, 100
local function setSpeedFromScale(scale)
    scale = clamp(scale,0,1)
    local speed = math.floor(minSpeed + scale * (maxSpeed - minSpeed) + 0.5)
    speedValLabel.Text = tostring(speed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
    knob.Position = UDim2.new(scale, 0, 0, 0)
end

-- knob drag logic
local draggingKnob = false
knob.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        draggingKnob = true
        inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then draggingKnob = false end end)
    end
end)
knob.InputChanged:Connect(function(inp)
    if draggingKnob and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
        local abs = inp.Position
        local bgPos = sliderBg.AbsolutePosition
        local relX = abs.X - bgPos.X
        setSpeedFromScale(relX / math.max(1, sliderBg.AbsoluteSize.X))
    end
end)
sliderBg.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        local abs = inp.Position
        local bgPos = sliderBg.AbsolutePosition
        local relX = abs.X - bgPos.X
        setSpeedFromScale(relX / math.max(1, sliderBg.AbsoluteSize.X))
    end
end)
minusBtn.MouseButton1Click:Connect(function()
    local cur = tonumber(speedValLabel.Text) or minSpeed
    setSpeedFromScale((cur - 1 - minSpeed) / (maxSpeed - minSpeed))
end)
plusBtn.MouseButton1Click:Connect(function()
    local cur = tonumber(speedValLabel.Text) or minSpeed
    setSpeedFromScale((cur + 1 - minSpeed) / (maxSpeed - minSpeed))
end)
setSpeedFromScale(0) -- default

-- tab switching
local function showTab(name)
    playersFrame.Visible = (name == "players")
    menuFrame.Visible = (name == "menu")
    speedFrame.Visible = (name == "speed")
    btnPlayers.BackgroundColor3 = (name=="players") and UI.Accent or Color3.fromRGB(46,46,46)
    btnMenu.BackgroundColor3    = (name=="menu")    and UI.Accent or Color3.fromRGB(46,46,46)
    btnSpeed.BackgroundColor3   = (name=="speed")   and UI.Accent or Color3.fromRGB(46,46,46)
end
btnPlayers.MouseButton1Click:Connect(function() showTab("players") end)
btnMenu.MouseButton1Click:Connect(function() showTab("menu") end)
btnSpeed.MouseButton1Click:Connect(function() showTab("speed") end)
showTab("players")

-- ===== FEATURE IMPLEMENTATIONS =====

-- ---------- ESP (robust auto-update) ----------
local espOn = false
local espColor = UI.EspColor
local billboards = {}  -- player -> BillboardGui
local tracers = {}     -- player -> Frame on screenGui

local function makeESPFor(plr)
    if not plr.Character then return end
    local head = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
    if not head then return end
    -- clean existing
    if billboards[plr] then billboards[plr]:Destroy() end
    if tracers[plr] and tracers[plr].Parent then tracers[plr]:Destroy() end

    -- billboard
    local bb = create("BillboardGui", { Adornee = head, Size = UDim2.new(0,140,0,22), AlwaysOnTop = true, ExtentsOffset = Vector3.new(0,1.6,0), Parent = head })
    local txt = create("TextLabel", { Parent = bb, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = plr.Name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = espColor })
    -- tracer
    local f = create("Frame", { Parent = screenGui, Size = UDim2.new(0,2,0,2), Position = UDim2.new(0,0,0,0), BackgroundColor3 = espColor, ZIndex = 50 })
    f.AnchorPoint = Vector2.new(0,0.5)
    billboards[plr] = bb
    tracers[plr] = f
end

local function removeESPFor(plr)
    if billboards[plr] then if billboards[plr].Parent then billboards[plr]:Destroy() end billboards[plr] = nil end
    if tracers[plr] then if tracers[plr].Parent then tracers[plr]:Destroy() end tracers[plr] = nil end
end

local function enableESP()
    espOn = true
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if p.Character and (p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")) then
                makeESPFor(p)
            end
            p.CharacterAdded:Connect(function() task.wait(0.2) if espOn then makeESPFor(p) end end)
        end
    end
end

local function disableESP()
    espOn = false
    for p,_ in pairs(billboards) do removeESPFor(p) end
end

-- update render for distances & tracers
RunService.RenderStepped:Connect(function()
    if not espOn then return end
    local vp = Camera.ViewportSize
    local startX = vp.X * 0.5
    local startY = vp.Y
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
            removeESPFor(p)
        end
    end
    for p,f in pairs(tracers) do
        if p and p.Character and f and f.Parent then
            local target = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Head")
            if target then
                local onScreen, x, y = Camera:WorldToViewportPoint(target.Position)
                if onScreen then
                    local dx = x - startX
                    local dy = y - startY
                    local len = math.sqrt(dx*dx + dy*dy)
                    if len < 4 then len = 4 end
                    local angle = math.deg(math.atan2(dy, dx))
                    f.Size = UDim2.new(0, clamp(len,2, vp.X*2), 0, 2)
                    f.Position = UDim2.new(0, startX, 0, startY)
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
            removeESPFor(p)
        end
    end
end)

-- ensure auto-create on join/respawn
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() task.wait(0.2) if espOn and plr ~= LocalPlayer then makeESPFor(plr) end end)
end)
Players.PlayerRemoving:Connect(function(plr) removeESPFor(plr) refreshPlayers() end)

espToggle.MouseButton1Click:Connect(function()
    if not espOn then enableESP(); espToggle.Text = "ON"; espToggle.BackgroundColor3 = UI.Accent
    else disableESP(); espToggle.Text = "OFF"; espToggle.BackgroundColor3 = Color3.fromRGB(220,220,220) end
    menuScroll.CanvasSize = UDim2.new(0,0,0, menuLayout.AbsoluteContentSize.Y + 12)
end)

-- ===== Infinite Jump =====
local infOn = false
infToggle.MouseButton1Click:Connect(function()
    infOn = not infOn
    infToggle.Text = infOn and "ON" or "OFF"
    infToggle.BackgroundColor3 = infOn and UI.Accent or Color3.fromRGB(220,220,220)
end)
UserInputService.JumpRequest:Connect(function()
    if infOn then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ===== Noclip (fixed) =====
local noclipOn = false
local noclipBackup = {} -- part -> original CanCollide
local function applyNoclip(state)
    noclipOn = state
    noclipToggle.Text = state and "ON" or "OFF"
    noclipToggle.BackgroundColor3 = state and UI.Accent or Color3.fromRGB(220,220,220)
    local char = LocalPlayer.Character
    if not char then return end
    if state then
        -- store and set CanCollide false
        noclipBackup = {}
        for _,part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                noclipBackup[part] = part.CanCollide
                part.CanCollide = false
            end
        end
    else
        -- restore states
        for part,orig in pairs(noclipBackup) do
            if part and part.Parent then
                part.CanCollide = orig
            end
        end
        noclipBackup = {}
        -- ensure humanoid stable
        pcall(function()
            if char:FindFirstChild("Humanoid") then
                char.Humanoid.PlatformStand = false
            end
        end)
    end
end
noclipToggle.MouseButton1Click:Connect(function() applyNoclip(not noclipOn) end)
LocalPlayer.CharacterAdded:Connect(function(char) task.wait(0.2) if noclipOn then applyNoclip(true) end end)

-- ===== Touch Fling (attempt client-side) =====
local flingOn = false
local flingPower = 500
local activeFlingConns = {} -- store touched connections

local function onPartTouched(part)
    -- only try fling if ON and touched part belongs to other player
    if not flingOn then return end
    local toucher = part
    local pl = Players:GetPlayerFromCharacter(part.Parent)
    if pl and pl ~= LocalPlayer then
        -- try to fling their HumanoidRootPart if exists
        local targetHRP = part.Parent:FindFirstChild("HumanoidRootPart")
        if targetHRP then
            -- attempt to apply velocity; may not replicate in some games/FE
            pcall(function()
                -- quick BodyVelocity approach (temporary)
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                bv.Velocity = (targetHRP.Position - (LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and LocalPlayer.Character.PrimaryPart.Position or targetHRP.Position)).unit * flingPower + Vector3.new(0, 60, 0)
                bv.P = 1250
                bv.Parent = targetHRP
                -- auto cleanup
                game:GetService("Debris"):AddItem(bv, 0.45)
            end)
        end
    end
end

local function enableTouchFling(state)
    flingOn = state
    flingToggle.Text = state and "ON" or "OFF"
    flingToggle.BackgroundColor3 = state and UI.Accent or Color3.fromRGB(220,220,220)
    -- connect or disconnect
    -- remove existing conns
    for _,c in ipairs(activeFlingConns) do
        if c then c:Disconnect() end
    end
    activeFlingConns = {}
    if state then
        -- connect to every basepart of local character to detect touch
        if LocalPlayer.Character then
            for _,part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    local conn = part.Touched:Connect(onPartTouched)
                    table.insert(activeFlingConns, conn)
                end
            end
        end
        -- rebind on respawn
        LocalPlayer.CharacterAdded:Connect(function(char)
            task.wait(0.2)
            if flingOn then
                for _,part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local conn = part.Touched:Connect(onPartTouched)
                        table.insert(activeFlingConns, conn)
                    end
                end
            end
        end)
    end
end

flingToggle.MouseButton1Click:Connect(function()
    enableTouchFling(not flingOn)
end)

-- ===== Anti Fall Damage (universal) =====
local antiOn = false
local lastSafePos = nil
local function setAntiFall(state)
    antiOn = state
    antiToggle.Text = state and "ON" or "OFF"
    antiToggle.BackgroundColor3 = state and UI.Accent or Color3.fromRGB(220,220,220)
end
antiToggle.MouseButton1Click:Connect(function() setAntiFall(not antiOn) end)

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        -- update safe pos when on floor/material not air
        if hum.FloorMaterial and hum.FloorMaterial ~= Enum.Material.Air and hum.Health > 0 then
            lastSafePos = hrp.Position
        end
        if antiOn then
            -- if too low Y (fall) or in state falling then try prevent damage
            if hrp.Position.Y < -60 then
                if lastSafePos then
                    hrp.CFrame = CFrame.new(lastSafePos + Vector3.new(0,3,0))
                else
                    -- fallback to spawn or a safe high point
                    local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
                    if spawn then hrp.CFrame = spawn.CFrame + Vector3.new(0,3,0) else hrp.CFrame = CFrame.new(0,5,0) end
                end
            end
            -- naive anti-fall-damage: if humanoid falling state and will hit hard, reset health
            -- We approximate by checking Y velocity high negative near ground
            if hum.Health > 0 then
                local vel = hrp.Velocity
                if vel.Y < -80 then
                    -- strong fall detected; heal
                    hum.Health = hum.MaxHealth
                end
            end
        end
    end
end)

-- ===== Ghost Mode (A) - client side invisibility =====
local ghostOn = false
local ghostBackup = {} -- part -> {transparency, cancollide}
local function setGhost(state)
    ghostOn = state
    ghostToggle.Text = state and "ON" or "OFF"
    ghostToggle.BackgroundColor3 = state and UI.Accent or Color3.fromRGB(220,220,220)
    local char = LocalPlayer.Character
    if not char then return end
    if state then
        ghostBackup = {}
        for _,desc in ipairs(char:GetDescendants()) do
            if desc:IsA("BasePart") then
                ghostBackup[desc] = {trans = desc.Transparency, cancollide = desc.CanCollide}
                desc.Transparency = 1
                desc.CanCollide = false
            elseif desc:IsA("Decal") or desc:IsA("Texture") then
                ghostBackup[desc] = {trans = desc.Transparency}
                desc.Transparency = 1
            elseif desc:IsA("BillboardGui") or desc:IsA("SurfaceGui") then
                -- hide local attachments if any
                ghostBackup[desc] = {parent = desc.Parent}
                desc.Parent = nil
            end
        end
    else
        for part,data in pairs(ghostBackup) do
            if part and part.Parent then
                if data.trans ~= nil then part.Transparency = data.trans end
                if data.cancollide ~= nil then part.CanCollide = data.cancollide end
            else
                -- if was GUI removed, we cannot always reparent reliably
                -- ignore
            end
        end
        ghostBackup = {}
    end
end
ghostToggle.MouseButton1Click:Connect(function() setGhost(not ghostOn) end)
LocalPlayer.CharacterAdded:Connect(function() task.wait(0.35) if ghostOn then setGhost(true) end end)

-- ===== TP Aura (nearest) =====
local tpAuraOn = false
local tpAuraRange = 60
local tpAuraDelay = 0.45
local tpAuraRunning = false
local function setTpAura(state)
    tpAuraOn = state
    tpAuraToggle.Text = state and "ON" or "OFF"
    tpAuraToggle.BackgroundColor3 = state and UI.Accent or Color3.fromRGB(220,220,220)
    if state and not tpAuraRunning then
        tpAuraRunning = true
        spawn(function()
            while tpAuraOn do
                task.wait(tpAuraDelay)
                -- find nearest player
                local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
                if not myPos then goto cont end
                local best, bestDist = nil, math.huge
                for _,p in ipairs(Players:GetPlayers()) do
                    if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local d = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
                        if d < bestDist and d <= tpAuraRange then best = p; bestDist = d end
                    end
                end
                if best and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and best.Character and best.Character:FindFirstChild("HumanoidRootPart") then
                    -- teleport near target quickly
                    LocalPlayer.Character.HumanoidRootPart.CFrame = best.Character.HumanoidRootPart.CFrame + Vector3.new(1.5,0,0)
                end
                ::cont::
            end
            tpAuraRunning = false
        end)
    end
end
tpAuraToggle.MouseButton1Click:Connect(function() setTpAura(not tpAuraOn) end)

-- ===== UI responsiveness for scrolls =====
playersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() playersScroll.CanvasSize = UDim2.new(0,0,0, playersLayout.AbsoluteContentSize.Y + 10) end)
menuLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() menuScroll.CanvasSize = UDim2.new(0,0,0, menuLayout.AbsoluteContentSize.Y + 12) end)

-- ===== ensure toggles states persist visually on respawn =====
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.35)
    if noclipOn then applyNoclip(true) end
    if ghostOn then setGhost(true) end
    if flingOn then enableTouchFling(true) end
end)

-- ===== refresh players when toggled open =====
toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    if main.Visible then refreshPlayers() end
end)

-- ===== initial canvas sizes =====
menuScroll.CanvasSize = UDim2.new(0,0,0, menuLayout.AbsoluteContentSize.Y + 12)
playersScroll.CanvasSize = UDim2.new(0,0,0, playersLayout.AbsoluteContentSize.Y + 10)

-- ===== helpers to ensure toggles looking correct initially =====
local function setToggleVisual(btn, state)
    btn.Text = state and "ON" or "OFF"
    btn.BackgroundColor3 = state and UI.Accent or Color3.fromRGB(220,220,220)
end
setToggleVisual(espToggle, espOn)
setToggleVisual(infToggle, infOn)
setToggleVisual(noclipToggle, noclipOn)
setToggleVisual(flingToggle, flingOn)
setToggleVisual(antiToggle, antiOn)
setToggleVisual(ghostToggle, ghostOn)
setToggleVisual(tpAuraToggle, tpAuraOn)

-- ===== Cleanup when leaving =====
LocalPlayer.AncestryChanged:Connect(function()
    if not LocalPlayer:IsDescendantOf(game) then
        -- cleanup esp
        for p,_ in pairs(billboards) do removeESPFor(p) end
        for p,_ in pairs(tracers) do removeESPFor(p) end
        -- cleanup fling conns
        for _,c in ipairs(activeFlingConns) do if c then c:Disconnect() end end
    end
end)

-- ===== End of script =====