-- RU16 / RstHUB - FINAL vB (Single LocalScript)
-- Place in StarterPlayerScripts
-- Compact UI + Tabs: Players | Menu | Speed
-- Features: Teleport to player, ESP (name+distance+tracer), Infinite Jump, Noclip, AntiVoid, Invisible (client-side), Speed slider
-- ESP auto-updates on PlayerAdded / CharacterAdded / PlayerRemoving

-- ===== Services =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ===== Helpers =====
local function create(class, props)
    local obj = Instance.new(class)
    if props then for k,v in pairs(props) do obj[k] = v end end
    return obj
end

local function clamp(v,a,b) if v < a then return a elseif v > b then return b else return v end end

-- dragify (works for mouse & touch)
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
            frame.Position = UDim2.new(
                clamp(startPos.X.Scale,0,1),
                startPos.X.Offset + delta.X,
                clamp(startPos.Y.Scale,0,1),
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ===== UI: ScreenGui, Toggle, Main Panel =====
local screenGui = create("ScreenGui", { Name = "RU16_RstHUB", Parent = PlayerGui, ResetOnSpawn = false })

-- Toggle small (draggable)
local toggle = create("TextButton", {
    Parent = screenGui,
    Name = "ToggleBtn",
    Size = UDim2.new(0,40,0,40),
    Position = UDim2.new(0, 16, 0.42, 0),
    BackgroundColor3 = Color3.fromRGB(255,223,0),
    Text = "≡",
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    AutoButtonColor = true,
})
create("UICorner", { Parent = toggle, CornerRadius = UDim.new(0,8) })
dragify(toggle)

-- Main Panel compact (narrower & shorter for phones)
local main = create("Frame", {
    Parent = screenGui,
    Name = "MainPanel",
    Size = UDim2.new(0, 280, 0, 360), -- more compact
    Position = UDim2.new(0.12,0,0.08,0),
    BackgroundColor3 = Color3.fromRGB(255,235,160),
    Visible = false,
})
create("UICorner", { Parent = main, CornerRadius = UDim.new(0,10) })
dragify(main)

-- Title & close
local title = create("TextLabel", {
    Parent = main, Size = UDim2.new(1, -20, 0, 40), Position = UDim2.new(0,10,0,8),
    BackgroundTransparency = 1, Text = "RstHUB - Main Panel", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Color3.fromRGB(20,20,20), TextXAlignment = Enum.TextXAlignment.Left
})
local closeBtn = create("TextButton", { Parent = main, Size = UDim2.new(0,30,0,26), Position = UDim2.new(1,-40,0,10), Text="X", BackgroundColor3 = Color3.fromRGB(230,70,70), Font = Enum.Font.GothamBold, TextSize = 14 })
create("UICorner", { Parent = closeBtn, CornerRadius = UDim.new(0,6) })
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

-- Tabs header
local tabHeader = create("Frame", { Parent = main, Size = UDim2.new(1, -20, 0, 36), Position = UDim2.new(0,10,0,56), BackgroundTransparency = 1 })
local function makeTab(text, x)
    local b = create("TextButton", { Parent = tabHeader, Size = UDim2.new(0.33, -6, 1, 0), Position = UDim2.new(x, 4, 0, 0),
        BackgroundColor3 = Color3.fromRGB(240,240,240), Text = text, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(20,20,20)})
    create("UICorner", { Parent = b, CornerRadius = UDim.new(0,6) })
    return b
end
local btnPlayers = makeTab("Players", 0)
local btnMenu = makeTab("Menu", 0.33)
local btnSpeed = makeTab("Speed", 0.66)

-- Content area
local content = create("Frame", { Parent = main, Size = UDim2.new(1, -20, 1, -120), Position = UDim2.new(0,10,0,100), BackgroundTransparency = 1 })

-- ---------------- PLAYERS TAB ----------------
local playersFrame = create("Frame", {Parent = content, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = true})
local playersScroll = create("ScrollingFrame", { Parent = playersFrame, Size = UDim2.new(1,0,1,0), CanvasSize = UDim2.new(0,0,0,0), ScrollBarThickness = 8, BackgroundTransparency = 1 })
local playersLayout = create("UIListLayout", { Parent = playersScroll })
playersLayout.Padding = UDim.new(0,6)

-- create player button
local function makePlayerButton(plr)
    local btn = create("TextButton", {
        Parent = playersScroll,
        Size = UDim2.new(1, -12, 0, 42),
        BackgroundColor3 = Color3.fromRGB(255,210,70),
        Text = plr.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(20,20,20),
    })
    create("UICorner", {Parent = btn, CornerRadius = UDim.new(0,8)})
    btn.MouseButton1Click:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
            end
        end
    end)
    return btn
end

local function refreshPlayers()
    for _,c in ipairs(playersScroll:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then makePlayerButton(p) end
    end
    playersScroll.CanvasSize = UDim2.new(0,0,0,playersLayout.AbsoluteContentSize.Y + 10)
end
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()

-- ---------------- MENU TAB ----------------
local menuFrame = create("Frame", {Parent = content, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = false})
-- Make scrollable vertical list for many features
local menuScroll = create("ScrollingFrame", { Parent = menuFrame, Size = UDim2.new(1,0,1,0), CanvasSize = UDim2.new(0,0,0,0), ScrollBarThickness = 8, BackgroundTransparency = 1 })
local menuLayout = create("UIListLayout", { Parent = menuScroll })
menuLayout.Padding = UDim.new(0,6)

-- helper to create toggle line (label + toggle button)
local function createToggleLine(parent, text, startState)
    local frame = create("Frame", { Parent = parent, Size = UDim2.new(1, -12, 0, 44), BackgroundTransparency = 1 })
    local label = create("TextLabel", { Parent = frame, Size = UDim2.new(0.72, 0, 1, 0), BackgroundTransparency = 1, Text = text, Font = Enum.Font.Gotham, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = Color3.fromRGB(20,20,20) })
    local toggleBtn = create("TextButton", { Parent = frame, Size = UDim2.new(0.26, 0, 0.7, 0), Position = UDim2.new(0.72, 6, 0.15, 0), BackgroundColor3 = startState and Color3.fromRGB(255,200,50) or Color3.fromRGB(240,240,240), Text = startState and "ON" or "OFF", Font = Enum.Font.Gotham, TextSize = 14 })
    create("UICorner", { Parent = toggleBtn, CornerRadius = UDim.new(0,6) })
    return frame, toggleBtn
end

-- Create toggles: ESP, Infinite Jump, Noclip, AntiVoid, Invisible
local espLine, espBtn = createToggleLine(menuScroll, "ESP", false)
local infLine, infBtn = createToggleLine(menuScroll, "Infinite Jump", false)
local noclipLine, noclipBtn = createToggleLine(menuScroll, "Noclip", false)
local antiLine, antiBtn = createToggleLine(menuScroll, "Anti-Void", false)
local invLine, invBtn = createToggleLine(menuScroll, "Invisible (client)", false)

menuScroll.CanvasSize = UDim2.new(0,0,0, menuLayout.AbsoluteContentSize.Y + 12)

-- ---------------- SPEED TAB ----------------
local speedFrame = create("Frame", { Parent = content, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = false })
local speedLabelTitle = create("TextLabel", { Parent = speedFrame, Size = UDim2.new(1,-20,0,22), Position = UDim2.new(0,10,0,6), BackgroundTransparency = 1, Text = "WalkSpeed", Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })
local sliderBg = create("Frame", { Parent = speedFrame, Size = UDim2.new(1,-80,0,22), Position = UDim2.new(0,50,0,36), BackgroundColor3 = Color3.fromRGB(220,220,220) })
create("UICorner", { Parent = sliderBg, CornerRadius = UDim.new(0,6) })
local knob = create("Frame", { Parent = sliderBg, Size = UDim2.new(0.05,0,1,0), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Color3.fromRGB(255,223,0) })
create("UICorner", { Parent = knob, CornerRadius = UDim.new(0,6) })
local minusBtn = create("TextButton", { Parent = speedFrame, Size = UDim2.new(0,34,0,28), Position = UDim2.new(0,8,0,34), Text = "-", Font = Enum.Font.GothamBold, TextSize = 18 })
create("UICorner", { Parent = minusBtn, CornerRadius = UDim.new(0,6) })
local plusBtn = create("TextButton", { Parent = speedFrame, Size = UDim2.new(0,34,0,28), Position = UDim2.new(1,-44,0,34), Text = "+", Font = Enum.Font.GothamBold, TextSize = 18 })
create("UICorner", { Parent = plusBtn, CornerRadius = UDim.new(0,6) })
local speedValueLabel = create("TextLabel", { Parent = speedFrame, Size = UDim2.new(0,80,0,28), Position = UDim2.new(0.5,-40,0,34), BackgroundTransparency = 1, Text = "16", Font = Enum.Font.GothamBold, TextSize = 16 })

local minSpeed, maxSpeed = 16, 100
local function setSpeedFromScale(scale)
    scale = clamp(scale,0,1)
    local speed = math.floor(minSpeed + scale * (maxSpeed - minSpeed) + 0.5)
    speedValueLabel.Text = tostring(speed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
    knob.Position = UDim2.new(scale, 0, 0, 0)
end

-- knob drag logic
local draggingKnob = false
knob.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        draggingKnob = true
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then draggingKnob = false end
        end)
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
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        local abs = inp.Position
        local bgPos = sliderBg.AbsolutePosition
        local relX = abs.X - bgPos.X
        setSpeedFromScale(relX / math.max(1, sliderBg.AbsoluteSize.X))
    end
end)
minusBtn.MouseButton1Click:Connect(function()
    local cur = tonumber(speedValueLabel.Text) or minSpeed
    setSpeedFromScale((cur - 1 - minSpeed) / (maxSpeed - minSpeed))
end)
plusBtn.MouseButton1Click:Connect(function()
    local cur = tonumber(speedValueLabel.Text) or minSpeed
    setSpeedFromScale((cur + 1 - minSpeed) / (maxSpeed - minSpeed))
end)

setSpeedFromScale(0) -- default 16

-- ===== Tab switching =====
local function showTab(name)
    playersFrame.Visible = (name == "players")
    menuFrame.Visible    = (name == "menu")
    speedFrame.Visible   = (name == "speed")
    btnPlayers.BackgroundColor3 = (name=="players") and Color3.fromRGB(255,230,120) or Color3.fromRGB(240,240,240)
    btnMenu.BackgroundColor3    = (name=="menu")    and Color3.fromRGB(255,230,120) or Color3.fromRGB(240,240,240)
    btnSpeed.BackgroundColor3   = (name=="speed")   and Color3.fromRGB(255,230,120) or Color3.fromRGB(240,240,240)
end
btnPlayers.MouseButton1Click:Connect(function() showTab("players") end)
btnMenu.MouseButton1Click:Connect(function() showTab("menu") end)
btnSpeed.MouseButton1Click:Connect(function() showTab("speed") end)
showTab("players")

-- ===== ESP (robust auto-update) =====
local espOn = false
local espColor = Color3.fromRGB(255,255,0)
local billboards = {} -- player -> BillboardGui
local tracers = {} -- player -> Frame (on screenGui)
local function makeESP(plr)
    if not plr.Character then return end
    local head = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
    if not head then return end
    -- billboard
    if billboards[plr] then billboards[plr]:Destroy() end
    local bb = create("BillboardGui", { Adornee = head, AlwaysOnTop = true, Size = UDim2.new(0,140,0,22), ExtentsOffset = Vector3.new(0,1.6,0), Parent = head })
    local label = create("TextLabel", { Parent = bb, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = plr.Name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = espColor })
    billboards[plr] = bb
    -- tracer line
    if tracers[plr] and tracers[plr].Parent then tracers[plr]:Destroy() end
    local f = create("Frame", { Parent = screenGui, Size = UDim2.new(0,2,0,2), Position = UDim2.new(0,0,0,0), BackgroundColor3 = espColor, ZIndex = 50 })
    f.AnchorPoint = Vector2.new(0,0.5)
    tracers[plr] = f
end

local function removeESP(plr)
    if billboards[plr] then
        if billboards[plr].Parent then billboards[plr]:Destroy() end
        billboards[plr] = nil
    end
    if tracers[plr] then
        if tracers[plr].Parent then tracers[plr]:Destroy() end
        tracers[plr] = nil
    end
end

local function enableESP()
    espOn = true
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            -- create if char exists
            if p.Character and (p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")) then
                makeESP(p)
            end
            p.CharacterAdded:Connect(function() -- ensure reconnect on respawn
                if espOn then
                    -- small delay for char to load parts
                    task.wait(0.25)
                    makeESP(p)
                end
            end)
        end
    end
end

local function disableESP()
    espOn = false
    for p,_ in pairs(billboards) do removeESP(p) end
    for p,_ in pairs(tracers) do removeESP(p) end
end

-- RenderStepped update for distance + tracer positions
RunService.RenderStepped:Connect(function()
    if not espOn then return end
    local vp = Camera.ViewportSize
    local sx = vp.X * 0.5
    local sy = vp.Y -- bottom
    for p, bb in pairs(billboards) do
        if p and p.Character and bb and bb.Parent then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Head")
            if hrp then
                local dist = (hrp.Position - (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Camera.CFrame.Position)).Magnitude
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
    -- tracers
    for p, f in pairs(tracers) do
        if p and p.Character and f and f.Parent then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Head")
            if hrp then
                local onScreen, x, y = Camera:WorldToViewportPoint(hrp.Position)
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

-- Connect PlayerAdded/Removing to ensure auto-create/cleanup when espOn
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if espOn and plr ~= LocalPlayer then
            -- slight delay for parts
            task.wait(0.2)
            makeESP(plr)
        end
    end)
end)
Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
    refreshPlayers()
end)

-- Esp toggle button behavior
espBtn.MouseButton1Click:Connect(function()
    if not espOn then
        enableESP()
        espBtn.Text = "ESP: ON"
        espBtn.BackgroundColor3 = Color3.fromRGB(255,200,50)
    else
        disableESP()
        espBtn.Text = "ESP: OFF"
        espBtn.BackgroundColor3 = Color3.fromRGB(240,240,240)
    end
    menuScroll.CanvasSize = UDim2.new(0,0,0, menuLayout.AbsoluteContentSize.Y + 12)
end)

-- ===== Infinite Jump =====
local infOn = false
infBtn.MouseButton1Click:Connect(function()
    infOn = not infOn
    infBtn.Text = infOn and "Infinite Jump: ON" or "Infinite Jump: OFF"
    infBtn.BackgroundColor3 = infOn and Color3.fromRGB(255,200,50) or Color3.fromRGB(240,240,240)
end)
UserInputService.JumpRequest:Connect(function()
    if infOn then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ===== Noclip (client-side) =====
local noclipOn = false
local function setNoclipState(state)
    noclipOn = state
    noclipBtn.Text = state and "Noclip: ON" or "Noclip: OFF"
    noclipBtn.BackgroundColor3 = state and Color3.fromRGB(255,200,50) or Color3.fromRGB(240,240,240)
    if LocalPlayer.Character then
        for _,part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = not state and true or false
            end
        end
    end
end
-- maintain noclip for newly added parts
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.2)
    if noclipOn and char then
        for _,part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = false end
        end
    end
end)
noclipBtn.MouseButton1Click:Connect(function() setNoclipState(not noclipOn) end)

-- ===== Invisible (client-side) =====
local invOn = false
local invisibleBackup = {}
local function setInvisible(state)
    invOn = state
    invBtn.Text = state and "Invisible: ON" or "Invisible: OFF"
    invBtn.BackgroundColor3 = state and Color3.fromRGB(255,200,50) or Color3.fromRGB(240,240,240)
    local char = LocalPlayer.Character
    if not char then return end
    if state then
        -- store original transparency and set transparency for local client only
        invisibleBackup = {}
        for _,part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                invisibleBackup[part] = {trans = part.Transparency, cancollide = part.CanCollide}
                part.Transparency = 1
                part.CanCollide = false
            elseif part:IsA("Decal") or part:IsA("Texture") then
                invisibleBackup[part] = {trans = part.Transparency}
                part.Transparency = 1
            end
        end
    else
        for part,data in pairs(invisibleBackup) do
            if part and part.Parent then
                if data.trans then part.Transparency = data.trans end
                if data.cancollide ~= nil then part.CanCollide = data.cancollide end
            end
        end
        invisibleBackup = {}
    end
end
invBtn.MouseButton1Click:Connect(function() setInvisible(not invOn) end)
-- reapply on respawn if needed
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    if invOn then setInvisible(true) end
    if noclipOn then setNoclipState(true) end
end)

-- ===== Anti-Void =====
local antiOn = false
local safePos = nil
-- update safePos periodically when standing on ground
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        -- if character is near ground and alive, update safePos
        if hum.FloorMaterial ~= Enum.Material.Air then
            safePos = hrp.Position
        end
        -- check void
        if antiOn and hrp.Position.Y < -60 then
            if safePos then
                hrp.CFrame = CFrame.new(safePos + Vector3.new(0,3,0))
            else
                -- fallback to spawn
                local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
                if spawn and spawn:IsA("SpawnLocation") then
                    hrp.CFrame = spawn.CFrame + Vector3.new(0,3,0)
                else
                    -- try player's respawn position
                    hrp.CFrame = (LocalPlayer.Character and LocalPlayer.Character:GetModelCFrame()) or CFrame.new(0,5,0)
                end
            end
        end
    end
end)
antiBtn.MouseButton1Click:Connect(function()
    antiOn = not antiOn
    antiBtn.Text = antiOn and "Anti-Void: ON" or "Anti-Void: OFF"
    antiBtn.BackgroundColor3 = antiOn and Color3.fromRGB(255,200,50) or Color3.fromRGB(240,240,240)
end)

-- ===== UI responsiveness: update scroll canvas when layout changes =====
playersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playersScroll.CanvasSize = UDim2.new(0,0,0, playersLayout.AbsoluteContentSize.Y + 10)
end)
menuLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    menuScroll.CanvasSize = UDim2.new(0,0,0, menuLayout.AbsoluteContentSize.Y + 12)
end)

-- Ensure menuScroll canvas initially updated
menuScroll.CanvasSize = UDim2.new(0,0,0, menuLayout.AbsoluteContentSize.Y + 12)

-- ===== Toggle Main show/hide =====
toggle.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    if main.Visible then refreshPlayers() end
end)

-- When UI opened ensure refresh players
toggle.MouseButton1Click:Connect(function() if main.Visible then refreshPlayers() end end)

-- ===== Cleanup when player leaves =====
LocalPlayer.AncestryChanged:Connect(function()
    if not LocalPlayer:IsDescendantOf(game) then
        disableESP()
        -- cleanup tracers/billboards
        for p,_ in pairs(billboards) do removeESP(p) end
        for p,_ in pairs(tracers) do removeESP(p) end
    end
end)

-- ===== End of Script =====