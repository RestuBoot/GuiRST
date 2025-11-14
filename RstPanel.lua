-- RU16 / RstHUB - FINAL (Single LocalScript)
-- Place this LocalScript inside StarterPlayerScripts
-- Features: Toggle button (draggable), Main Panel (draggable), Tabs (Players/Menu/Speed),
-- Player Teleport (MoveTo), ESP (name+distance + tracer lines from bottom), Infinite Jump, Speed slider.

-- ===== Services & locals =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ===== helper create function =====
local function create(class, props)
    local obj = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            obj[k] = v
        end
    end
    return obj
end

-- ===== dragify (works for mouse & touch) =====
local function dragify(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                math.clamp(startPos.X.Scale, 0, 1),
                startPos.X.Offset + delta.X,
                math.clamp(startPos.Y.Scale, 0, 1),
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ===== ScreenGui =====
local screenGui = create("ScreenGui", { Name = "RU16_RstHUB", Parent = PlayerGui, ResetOnSpawn = false })

-- ===== Toggle Button (small yellow) =====
local toggle = create("TextButton", {
    Parent = screenGui,
    Name = "ToggleBtn",
    Size = UDim2.new(0, 44, 0, 44),
    Position = UDim2.new(0, 18, 0.4, 0),
    BackgroundColor3 = Color3.fromRGB(255, 223, 0),
    Text = "≡",
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    AutoButtonColor = true,
})
create("UICorner", { Parent = toggle, CornerRadius = UDim.new(0,8) })
dragify(toggle)

-- ===== Main Panel (full box but sized for phone) =====
local main = create("Frame", {
    Parent = screenGui,
    Name = "MainPanel",
    Size = UDim2.new(0, 320, 0, 420), -- slightly smaller for phone
    Position = UDim2.new(0.12, 0, 0.08, 0),
    BackgroundColor3 = Color3.fromRGB(255, 235, 160),
    Visible = false,
})
create("UICorner", { Parent = main, CornerRadius = UDim.new(0,12) })
dragify(main)

-- Title bar
local title = create("TextLabel", {
    Parent = main,
    Size = UDim2.new(1, -16, 0, 48),
    Position = UDim2.new(0, 8, 0, 6),
    BackgroundTransparency = 1,
    Text = "RstHUB - Main Panel",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = Color3.fromRGB(18,18,18),
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Close small X (optional)
local closeBtn = create("TextButton", {
    Parent = main,
    Size = UDim2.new(0,32,0,28),
    Position = UDim2.new(1, -44, 0, 8),
    BackgroundColor3 = Color3.fromRGB(230,70,70),
    Text = "X",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255,255,255),
})
create("UICorner", { Parent = closeBtn, CornerRadius = UDim.new(0,6) })
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

-- Tab header
local tabHeader = create("Frame", { Parent = main, Size = UDim2.new(1, -20, 0, 44), Position = UDim2.new(0, 10, 0, 62), BackgroundTransparency = 1 })
local function tabButton(text, posScale)
    local b = create("TextButton", {
        Parent = tabHeader,
        Size = UDim2.new(0.33, -8, 1, 0),
        Position = UDim2.new(posScale, 4, 0, 0),
        BackgroundColor3 = Color3.fromRGB(240,240,240),
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 15,
        TextColor3 = Color3.fromRGB(20,20,20),
    })
    create("UICorner", { Parent = b, CornerRadius = UDim.new(0,6) })
    return b
end

local btnPlayers = tabButton("Players", 0)
local btnMenu    = tabButton("Menu", 0.33)
local btnSpeed   = tabButton("Speed", 0.66)

-- Content container
local content = create("Frame", { Parent = main, Size = UDim2.new(1, -20, 1, -128), Position = UDim2.new(0, 10, 0, 118), BackgroundTransparency = 1 })

-- Players Tab
local playersFrame = create("Frame", { Parent = content, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = true })
local playersScroll = create("ScrollingFrame", {
    Parent = playersFrame,
    Size = UDim2.new(1,0,1,0),
    CanvasSize = UDim2.new(0,0,0,0),
    ScrollBarThickness = 8,
    BackgroundTransparency = 1,
})
local playersListLayout = create("UIListLayout", { Parent = playersScroll })
playersListLayout.Padding = UDim.new(0,6)

-- Menu Tab (contains ESP toggle & Infinite Jump toggle)
local menuFrame = create("Frame", { Parent = content, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = false })
-- ESP toggle button
local espToggle = create("TextButton", {
    Parent = menuFrame,
    Size = UDim2.new(1, -20, 0, 44),
    Position = UDim2.new(0, 10, 0, 6),
    BackgroundColor3 = Color3.fromRGB(255,220,80),
    Text = "ESP: OFF",
    Font = Enum.Font.Gotham,
    TextSize = 16,
})
create("UICorner", { Parent = espToggle, CornerRadius = UDim.new(0,8) })

-- Infinite Jump toggle
local infToggle = create("TextButton", {
    Parent = menuFrame,
    Size = UDim2.new(1, -20, 0, 44),
    Position = UDim2.new(0, 10, 0, 60),
    BackgroundColor3 = Color3.fromRGB(240,240,240),
    Text = "Infinite Jump: OFF",
    Font = Enum.Font.Gotham,
    TextSize = 16,
})
create("UICorner", { Parent = infToggle, CornerRadius = UDim.new(0,8) })

-- Speed Tab
local speedFrame = create("Frame", { Parent = content, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = false })
create("TextLabel", {
    Parent = speedFrame,
    Size = UDim2.new(1, -20, 0, 22),
    Position = UDim2.new(0, 10, 0, 6),
    BackgroundTransparency = 1,
    Text = "WalkSpeed:",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
})
-- slider background
local sliderBg = create("Frame", { Parent = speedFrame, Size = UDim2.new(1, -80, 0, 22), Position = UDim2.new(0, 50, 0, 36), BackgroundColor3 = Color3.fromRGB(220,220,220) })
create("UICorner", { Parent = sliderBg, CornerRadius = UDim.new(0,6) })
local knob = create("Frame", { Parent = sliderBg, Size = UDim2.new(0.05, 0, 1, 0), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Color3.fromRGB(255,223,0) })
create("UICorner", { Parent = knob, CornerRadius = UDim.new(0,6) })
local minusBtn = create("TextButton", { Parent = speedFrame, Size = UDim2.new(0,36,0,28), Position = UDim2.new(0, 8, 0, 34), Text = "-", Font = Enum.Font.GothamBold, TextSize = 18 })
create("UICorner", { Parent = minusBtn, CornerRadius = UDim.new(0,6) })
local plusBtn = create("TextButton", { Parent = speedFrame, Size = UDim2.new(0,36,0,28), Position = UDim2.new(1, -44, 0, 34), Text = "+", Font = Enum.Font.GothamBold, TextSize = 18 })
create("UICorner", { Parent = plusBtn, CornerRadius = UDim.new(0,6) })
local speedLabel = create("TextLabel", { Parent = speedFrame, Size = UDim2.new(0,80,0,28), Position = UDim2.new(0.5, -40, 0, 34), BackgroundTransparency = 1, Text = "16", Font = Enum.Font.GothamBold, TextSize = 16 })

-- ===== Tab switching =====
local function showTab(name)
    playersFrame.Visible = (name == "players")
    menuFrame.Visible = (name == "menu")
    speedFrame.Visible = (name == "speed")
    btnPlayers.BackgroundColor3 = (name=="players") and Color3.fromRGB(255,230,120) or Color3.fromRGB(240,240,240)
    btnMenu.BackgroundColor3    = (name=="menu")    and Color3.fromRGB(255,230,120) or Color3.fromRGB(240,240,240)
    btnSpeed.BackgroundColor3   = (name=="speed")   and Color3.fromRGB(255,230,120) or Color3.fromRGB(240,240,240)
end
btnPlayers.MouseButton1Click:Connect(function() showTab("players") end)
btnMenu.MouseButton1Click:Connect(function() showTab("menu") end)
btnSpeed.MouseButton1Click:Connect(function() showTab("speed") end)
showTab("players")

-- ===== Players list functions =====
local function clearContainer(container)
    for _,c in ipairs(container:GetChildren()) do
        if not c:IsA("UIListLayout") then
            c:Destroy()
        end
    end
end

local function createPlayerButton(plr)
    local btn = create("TextButton", {
        Parent = playersScroll,
        Size = UDim2.new(1, -10, 0, 44),
        BackgroundColor3 = Color3.fromRGB(255,210,70),
        Text = plr.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Color3.fromRGB(20,20,20),
    })
    create("UICorner", { Parent = btn, CornerRadius = UDim.new(0,8) })
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
    clearContainer(playersScroll)
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            createPlayerButton(p)
        end
    end
    playersScroll.CanvasSize = UDim2.new(0,0,0,playersListLayout.AbsoluteContentSize.Y + 12)
end

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()

-- ===== ESP implementation (name+distance via BillboardGui + tracer lines overlay) =====
local espOn = false
local espColor = Color3.fromRGB(255,255,0) -- standard yellow
local espBillboards = {}  -- map player -> billboard
local tracerFrames = {}   -- map player -> Frame (line) parented to screenGui

local function makeBillboardFor(plr)
    if not plr.Character then return end
    local head = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
    if not head then return end
    -- create billboard
    local bb = create("BillboardGui", {
        Adornee = head,
        Size = UDim2.new(0, 160, 0, 28),
        AlwaysOnTop = true,
        ExtentsOffset = Vector3.new(0, 1.5, 0),
        Parent = head,
    })
    local label = create("TextLabel", {
        Parent = bb,
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Text = plr.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = espColor,
    })
    -- add distance text as secondary label (we'll append to label.Text)
    espBillboards[plr] = bb
end

local function removeBillboard(plr)
    local bb = espBillboards[plr]
    if bb and bb.Parent then
        bb:Destroy()
    end
    espBillboards[plr] = nil
end

local function createTracerFor(plr)
    -- create a thin Frame parented to screenGui which we'll position/rotate on RenderStepped
    local f = create("Frame", {
        Parent = screenGui,
        Size = UDim2.new(0, 2, 0, 2),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = espColor,
        ZIndex = 50,
    })
    f.AnchorPoint = Vector2.new(0, 0.5) -- left-center is start
    tracerFrames[plr] = f
end

local function removeTracer(plr)
    local f = tracerFrames[plr]
    if f and f.Parent then f:Destroy() end
    tracerFrames[plr] = nil
end

local function enableESP()
    espOn = true
    -- create billboards and tracers for all players except local
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if p.Character and (p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")) then
                makeBillboardFor(p)
                createTracerFor(p)
            end
            -- ensure we listen to future CharacterAdded
            p.CharacterAdded:Connect(function()
                if espOn then
                    makeBillboardFor(p)
                    createTracerFor(p)
                end
            end)
        end
    end
end

local function disableESP()
    espOn = false
    for p,_ in pairs(espBillboards) do removeBillboard(p) end
    for p,_ in pairs(tracerFrames) do removeTracer(p) end
end

-- update billboard distance and tracer frame every frame
RunService.RenderStepped:Connect(function()
    if not espOn then return end
    local vpSize = Camera.ViewportSize
    local startX = vpSize.X * 0.5
    local startY = vpSize.Y -- bottom of screen
    for p, bb in pairs(espBillboards) do
        if p and p.Character and bb and bb.Parent then
            -- update distance
            local hrp = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Head")
            if hrp then
                local distance = (hrp.Position - (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Camera.CFrame.Position)).Magnitude
                local label = bb:FindFirstChildOfClass("TextLabel")
                if label then
                    label.Text = string.format("%s | %.1fm", p.Name, distance)
                    label.TextColor3 = espColor
                    label.TextStrokeTransparency = 0.5
                    label.TextStrokeColor3 = Color3.new(0,0,0)
                end
            end
        end
    end

    -- update tracers
    for p, f in pairs(tracerFrames) do
        if p and p.Character and f and f.Parent then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Head")
            if hrp then
                local onScreen, sx, sy = pcall(function() return Camera:WorldToViewportPoint(hrp.Position) end)
                if onScreen then
                    local vec = Camera:WorldToViewportPoint(hrp.Position)
                    local tx = vec.X
                    local ty = vec.Y
                    -- compute dx, dy from bottom-center to target
                    local dx = tx - startX
                    local dy = ty - startY
                    local len = math.sqrt(dx*dx + dy*dy)
                    if len < 4 then len = 4 end
                    local angle = math.deg(math.atan2(dy, dx))
                    f.Size = UDim2.new(0, math.clamp(len, 2, vpSize.X*2), 0, 2)
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
        end
    end
end)

-- Toggle ESP button behavior
espToggle.MouseButton1Click:Connect(function()
    if not espOn then
        enableESP()
        espToggle.Text = "ESP: ON"
        espToggle.BackgroundColor3 = Color3.fromRGB(255,200,50)
    else
        disableESP()
        espToggle.Text = "ESP: OFF"
        espToggle.BackgroundColor3 = Color3.fromRGB(240,240,240)
    end
end)

-- Clean up when player leaves (remove their objects)
Players.PlayerRemoving:Connect(function(plr)
    removeBillboard(plr)
    removeTracer(plr)
    refreshPlayers()
end)

-- ===== Infinite Jump =====
local infJump = false
infToggle.MouseButton1Click:Connect(function()
    infJump = not infJump
    infToggle.Text = infJump and "Infinite Jump: ON" or "Infinite Jump: OFF"
    infToggle.BackgroundColor3 = infJump and Color3.fromRGB(255,200,50) or Color3.fromRGB(240,240,240)
end)

-- JumpRequest handles spacebar/touch jump on client
UserInputService.JumpRequest:Connect(function()
    if infJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ===== Speed slider logic =====
local minSpeed, maxSpeed = 16, 100
local function setSpeedFromScale(scale)
    scale = math.clamp(scale, 0, 1)
    local newSpeed = math.floor(minSpeed + scale * (maxSpeed - minSpeed) + 0.5)
    speedLabel.Text = tostring(newSpeed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = newSpeed
    end
    knob.Position = UDim2.new(scale, 0, 0, 0)
end

-- knob drag
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
    if draggingKnob and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local absPos = inp.Position
        local bgPos = sliderBg.AbsolutePosition
        local relX = absPos.X - bgPos.X
        setSpeedFromScale(relX / math.max(1, sliderBg.AbsoluteSize.X))
    end
end)

sliderBg.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        local absPos = inp.Position
        local bgPos = sliderBg.AbsolutePosition
        local relX = absPos.X - bgPos.X
        setSpeedFromScale(relX / math.max(1, sliderBg.AbsoluteSize.X))
    end
end)

minusBtn.MouseButton1Click:Connect(function()
    local cur = tonumber(speedLabel.Text) or minSpeed
    setSpeedFromScale((cur - 1 - minSpeed) / (maxSpeed - minSpeed))
end)
plusBtn.MouseButton1Click:Connect(function()
    local cur = tonumber(speedLabel.Text) or minSpeed
    setSpeedFromScale((cur + 1 - minSpeed) / (maxSpeed - minSpeed))
end)

-- keep speed on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.4)
    local cur = tonumber(speedLabel.Text) or minSpeed
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = cur
    end
end)

-- initialize speed to default min
setSpeedFromScale(0)

-- ===== Toggle main open/close =====
toggle.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- ===== ensure refreshPlayers updates when UI opened =====
toggle.MouseButton1Click:Connect(function()
    if main.Visible then
        refreshPlayers()
    end
end)

-- ===== cleanup on script end / player leaving =====
LocalPlayer.AncestryChanged:Connect(function()
    if not LocalPlayer:IsDescendantOf(game) then
        disableESP()
    end
end)

-- End of script