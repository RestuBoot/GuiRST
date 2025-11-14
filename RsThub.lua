-- RU16 / RstHUB - FULL BOX (LocalScript)
-- Put this LocalScript in StarterPlayerScripts (or execute as LocalScript)
-- Features: Toggle (draggable), Main GUI (draggable), Tabs (Teleport/ESP/Speed/Settings),
-- Teleport to players, ESP (name+box+outline), Speed slider (adjustable), Save positions (local only)

-- ===== Services =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local StarterGui = game:GetService("StarterGui")

-- ===== Helpers =====
local function dragify(frame)
    -- Generic drag function works for mouse & touch.
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

local function create(inst, props)
    local obj = Instance.new(inst)
    if props then
        for k, v in pairs(props) do obj[k] = v end
    end
    return obj
end

-- ===== Create ScreenGui =====
local screenGui = create("ScreenGui", {
    Name = "RU16_RstHUB",
    Parent = PlayerGui,
    ResetOnSpawn = false,
})
-- On some environments CoreGui required; we stick to PlayerGui for LocalScript.

-- ===== Toggle Button (small icon) =====
local toggle = create("TextButton", {
    Name = "ToggleBtn",
    Parent = screenGui,
    Size = UDim2.new(0, 44, 0, 44),
    Position = UDim2.new(0, 20, 0.4, 0),
    BackgroundColor3 = Color3.fromRGB(255, 223, 0),
    Text = "≡",
    TextColor3 = Color3.fromRGB(0,0,0),
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    AutoButtonColor = true,
    ClipsDescendants = false,
})
create("UICorner", {Parent = toggle, CornerRadius = UDim.new(0,8)})

-- Make toggle draggable too
dragify(toggle)

-- ===== Main Full Box Frame =====
local main = create("Frame", {
    Name = "MainBox",
    Parent = screenGui,
    Size = UDim2.new(0, 360, 0, 480),
    Position = UDim2.new(0.08, 0, 0.12, 0),
    BackgroundColor3 = Color3.fromRGB(255, 235, 160), -- soft yellow
    Visible = false,
})
create("UICorner", {Parent = main, CornerRadius = UDim.new(0,12)})

-- drag main
dragify(main)

-- Title bar
local titleBar = create("Frame", {
    Parent = main,
    Size = UDim2.new(1, 0, 0, 48),
    Position = UDim2.new(0,0,0,0),
    BackgroundTransparency = 1,
})
local titleLabel = create("TextLabel", {
    Parent = titleBar,
    Size = UDim2.new(1, -16, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    Text = "RstHUB - Full Box",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = Color3.fromRGB(15,15,15),
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Tab header
local tabHeader = create("Frame", {
    Parent = main,
    Size = UDim2.new(1, -20, 0, 40),
    Position = UDim2.new(0, 10, 0, 48),
    BackgroundTransparency = 1,
})
local function makeTabButton(text, xScale)
    return create("TextButton", {
        Parent = tabHeader,
        Size = UDim2.new(0.33, -8, 1, 0),
        Position = UDim2.new(xScale, 4, 0, 0),
        BackgroundColor3 = Color3.fromRGB(240,240,240),
        Text = text,
        Font = Enum.Font.Gotham,
        TextColor3 = Color3.fromRGB(20,20,20),
        TextSize = 16,
    })
end

local btnPlayers = makeTabButton("Players", 0)
local btnFitur   = makeTabButton("Fitur", 0.33)
local btnSpeed   = makeTabButton("Speed", 0.66)

-- Content area (below tabs)
local contentArea = create("Frame", {
    Parent = main,
    Size = UDim2.new(1, -20, 1, -110),
    Position = UDim2.new(0, 10, 0, 100),
    BackgroundTransparency = 1,
})

-- ===== Players Tab =====
local playersFrame = create("Frame", {
    Parent = contentArea,
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Visible = true,
})

local playersScroll = create("ScrollingFrame", {
    Parent = playersFrame,
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0,0,0,0),
    CanvasSize = UDim2.new(0,0,0,0),
    ScrollBarThickness = 8,
    BackgroundTransparency = 1,
})
local playersListLayout = create("UIListLayout", {Parent = playersScroll})
playersListLayout.Padding = UDim.new(0,6)

local function clearChildren(parent)
    for _,c in ipairs(parent:GetChildren()) do
        if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then
            c:Destroy()
        end
    end
end

local function createPlayerLine(plr)
    local btn = create("TextButton", {
        Parent = playersScroll,
        Size = UDim2.new(1, -10, 0, 48),
        BackgroundColor3 = Color3.fromRGB(255, 210, 70),
        Text = plr.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Color3.fromRGB(20,20,20),
    })
    create("UICorner", {Parent = btn, CornerRadius = UDim.new(0,8)})

    btn.MouseButton1Click:Connect(function()
        -- Teleport (client-side MoveTo)
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(2,0,0)
            end
        end
    end)
end

local function refreshPlayersList()
    clearChildren(playersScroll)
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            createPlayerLine(p)
        end
    end
    playersScroll.CanvasSize = UDim2.new(0, 0, 0, playersListLayout.AbsoluteContentSize.Y + 12)
end

Players.PlayerAdded:Connect(function() refreshPlayersList() end)
Players.PlayerRemoving:Connect(function() refreshPlayersList() end)
refreshPlayersList()

-- ===== Fitur Tab (ESP) =====
local fiturFrame = create("Frame", {
    Parent = contentArea,
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Visible = false,
})

-- Controls: ESP Toggle, options
local espToggle = create("TextButton", {
    Parent = fiturFrame,
    Size = UDim2.new(1, -10, 0, 44),
    Position = UDim2.new(0,5,0,0),
    BackgroundColor3 = Color3.fromRGB(255,220,80),
    Text = "Toggle ESP (Name + Box)",
    Font = Enum.Font.Gotham,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(10,10,10),
})
create("UICorner", {Parent = espToggle, CornerRadius = UDim.new(0,8)})

local espColorLabel = create("TextLabel", {
    Parent = fiturFrame,
    Size = UDim2.new(1, -10, 0, 28),
    Position = UDim2.new(0,5,0,54),
    BackgroundTransparency = 1,
    Text = "ESP Color:",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(15,15,15),
    TextXAlignment = Enum.TextXAlignment.Left,
})
local espColorInput = create("TextBox", {
    Parent = fiturFrame,
    Size = UDim2.new(1, -10, 0, 32),
    Position = UDim2.new(0,5,0,84),
    BackgroundColor3 = Color3.fromRGB(250,250,250),
    PlaceholderText = "e.g. 255,50,50",
    Text = "255,50,50",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(0,0,0),
})
create("UICorner", {Parent = espColorInput, CornerRadius = UDim.new(0,6)})

local espBoxToggle = create("TextButton", {
    Parent = fiturFrame,
    Size = UDim2.new(1, -10, 0, 36),
    Position = UDim2.new(0,5,0,126),
    BackgroundColor3 = Color3.fromRGB(240,240,240),
    Text = "Toggle Box Outline",
    Font = Enum.Font.Gotham,
    TextSize = 14,
})
create("UICorner", {Parent = espBoxToggle, CornerRadius = UDim.new(0,6)})

-- ESP implementation helpers
local espEnabled = false
local espBoxEnabled = true
local espColor = Color3.fromRGB(255,50,50)
local espObjects = {} -- map player -> {billboard, box}

local function parseColorText(txt)
    local r,g,b = txt:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
    if r and g and b then
        return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
    end
    return nil
end

local function createESPForPlayer(plr)
    if not plr.Character then return end
    -- clean existing
    if espObjects[plr] then
        if espObjects[plr].billboard then espObjects[plr].billboard:Destroy() end
        if espObjects[plr].box then espObjects[plr].box:Destroy() end
        espObjects[plr] = nil
    end

    local char = plr.Character
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not head then return end

    -- Billboard name
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RU16ESP_Billboard"
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 120, 0, 24)
    billboard.ExtentsOffset = Vector3.new(0, 1.5, 0)
    billboard.Parent = head

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = plr.Name
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextColor3 = espColor
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.new(0,0,0)

    -- Box (BoxHandleAdornment) anchored to head
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "RU16ESP_Box"
    box.Adornee = head
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = head.Size + Vector3.new(1.2, 2.2, 1.2)
    box.Color = espColor
    box.Transparency = 0.5
    box.Parent = workspace

    espObjects[plr] = {billboard = billboard, box = box}
end

local function removeESPForPlayer(plr)
    local e = espObjects[plr]
    if e then
        if e.billboard and e.billboard.Parent then e.billboard:Destroy() end
        if e.box and e.box.Parent then e.box:Destroy() end
        espObjects[plr] = nil
    end
end

local function updateESPAll()
    for p,_ in pairs(espObjects) do
        removeESPForPlayer(p)
    end
    if not espEnabled then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            createESPForPlayer(p)
        end
    end
end

espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    updateESPAll()
end)

espBoxToggle.MouseButton1Click:Connect(function()
    espBoxEnabled = not espBoxEnabled
    -- show/hide box by destroying or recreating (BoxHandleAdornment respects 'espBoxEnabled')
    if not espBoxEnabled then
        for p,obj in pairs(espObjects) do
            if obj.box then
                obj.box:Destroy()
                obj.box = nil
            end
        end
    else
        updateESPAll()
    end
end)

espColorInput.FocusLost:Connect(function(enter)
    local col = parseColorText(espColorInput.Text)
    if col then
        espColor = col
        -- update current labels and boxes
        for p,obj in pairs(espObjects) do
            if obj.billboard and obj.billboard:FindFirstChildOfClass("TextLabel") then
                obj.billboard.TextLabel.TextColor3 = espColor
            end
            if obj.box then
                obj.box.Color = espColor
            end
        end
    else
        -- invalid input; reset to previous string
        espColorInput.Text = string.format("%d,%d,%d", math.floor(espColor.R*255), math.floor(espColor.G*255), math.floor(espColor.B*255))
    end
end)

-- Keep ESP updated when characters spawn/die
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() if espEnabled then createESPForPlayer(plr) end end)
end)
Players.PlayerRemoving:Connect(function(plr) removeESPForPlayer(plr) end)

-- ===== Speed Tab =====
local speedFrame = create("Frame", {
    Parent = contentArea,
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Visible = false,
})
-- Label
create("TextLabel", {
    Parent = speedFrame,
    Size = UDim2.new(1, -10, 0, 24),
    Position = UDim2.new(0,5,0,2),
    BackgroundTransparency = 1,
    Text = "WalkSpeed (drag knob or use +/-):",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(20,20,20),
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Slider background
local sliderBg = create("Frame", {
    Parent = speedFrame,
    Size = UDim2.new(1, -60, 0, 22),
    Position = UDim2.new(0, 30, 0, 40),
    BackgroundColor3 = Color3.fromRGB(220,220,220),
})
create("UICorner", {Parent = sliderBg, CornerRadius = UDim.new(0,6)})
-- Slider knob
local knob = create("Frame", {
    Parent = sliderBg,
    Size = UDim2.new(0.05, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(255,223,0),
})
create("UICorner", {Parent = knob, CornerRadius = UDim.new(0,6)})

-- Buttons +/- and label
local minusBtn = create("TextButton", {
    Parent = speedFrame,
    Size = UDim2.new(0,28,0,28),
    Position = UDim2.new(0,2,0,36),
    Text = "-",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    BackgroundColor3 = Color3.fromRGB(240,240,240),
})
create("UICorner", {Parent = minusBtn, CornerRadius = UDim.new(0,6)})

local plusBtn = create("TextButton", {
    Parent = speedFrame,
    Size = UDim2.new(0,28,0,28),
    Position = UDim2.new(1, -30, 0,36),
    Text = "+",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    BackgroundColor3 = Color3.fromRGB(240,240,240),
})
create("UICorner", {Parent = plusBtn, CornerRadius = UDim.new(0,6)})

local speedLabel = create("TextLabel", {
    Parent = speedFrame,
    Size = UDim2.new(0, 80, 0, 28),
    Position = UDim2.new(0.5, -40, 0, 36),
    BackgroundTransparency = 1,
    Text = "16",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(15,15,15),
})

local minSpeed = 16
local maxSpeed = 80
local function setSpeedFromScale(scale)
    scale = math.clamp(scale, 0, 1)
    local newSpeed = math.floor(minSpeed + scale * (maxSpeed - minSpeed) + 0.5)
    speedLabel.Text = tostring(newSpeed)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = newSpeed
    end
    knob.Position = UDim2.new(scale, 0, 0, 0)
end

-- dragging knob
local draggingKnob = false
knob.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        draggingKnob = true
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then
                draggingKnob = false
            end
        end)
    end
end)
knob.InputChanged:Connect(function(inp)
    if draggingKnob and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local absPos = inp.Position
        local bgPos = sliderBg.AbsolutePosition
        local relX = absPos.X - bgPos.X
        local scale = relX / sliderBg.AbsoluteSize.X
        setSpeedFromScale(scale)
    end
end)

-- Allow clicking on sliderBg to set directly
sliderBg.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        local absPos = inp.Position
        local bgPos = sliderBg.AbsolutePosition
        local relX = absPos.X - bgPos.X
        setSpeedFromScale(relX / sliderBg.AbsoluteSize.X)
    end
end)

minusBtn.MouseButton1Click:Connect(function()
    local cur = tonumber(speedLabel.Text) or 16
    setSpeedFromScale((cur - 1 - minSpeed) / (maxSpeed - minSpeed))
end)
plusBtn.MouseButton1Click:Connect(function()
    local cur = tonumber(speedLabel.Text) or 16
    setSpeedFromScale((cur + 1 - minSpeed) / (maxSpeed - minSpeed))
end)

-- Reset speed on character respawn to current slider value
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local cur = tonumber(speedLabel.Text) or 16
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = cur
    end
end)

-- ===== Settings Tab =====
local settingsFrame = create("Frame", {
    Parent = contentArea,
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Visible = false,
})
-- Save positions (simple local storage using SetCoreGuiEnabled not persistent across sessions)
create("TextLabel", {
    Parent = settingsFrame,
    Size = UDim2.new(1, -10, 0, 20),
    Position = UDim2.new(0,5,0,6),
    BackgroundTransparency = 1,
    Text = "Settings (temporary):",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(15,15,15),
    TextXAlignment = Enum.TextXAlignment.Left,
})
local closeBtn = create("TextButton", {
    Parent = main,
    Size = UDim2.new(0, 36, 0, 28),
    Position = UDim2.new(1, -44, 0, 8),
    BackgroundColor3 = Color3.fromRGB(230,80,80),
    Text = "X",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255,255,255),
})
create("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(0,6)})
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

-- ===== Tab switching logic =====
local function showTab(which)
    playersFrame.Visible = (which == "players")
    fiturFrame.Visible = (which == "fitur")
    speedFrame.Visible = (which == "speed")
    settingsFrame.Visible = (which == "settings")
    -- update visuals
    btnPlayers.BackgroundColor3 = (which == "players") and Color3.fromRGB(255,230,120) or Color3.fromRGB(240,240,240)
    btnFitur.BackgroundColor3   = (which == "fitur") and Color3.fromRGB(255,230,120) or Color3.fromRGB(240,240,240)
    btnSpeed.BackgroundColor3   = (which == "speed") and Color3.fromRGB(255,230,120) or Color3.fromRGB(240,240,240)
end

btnPlayers.MouseButton1Click:Connect(function() showTab("players") end)
btnFitur.MouseButton1Click:Connect(function() showTab("fitur") end)
btnSpeed.MouseButton1Click:Connect(function() showTab("speed") end)
-- Provide a way to go to settings (small button)
local settingsBtn = create("TextButton", {Parent = main, Size = UDim2.new(0, 80, 0, 28), Position = UDim2.new(1, -90, 0, 8), Text = "Settings", BackgroundColor3 = Color3.fromRGB(240,240,240)})
create("UICorner", {Parent = settingsBtn, CornerRadius = UDim.new(0,6)})
settingsBtn.MouseButton1Click:Connect(function() showTab("settings") end)

showTab("players") -- default

-- ===== Toggle action =====
toggle.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- ===== Init defaults =====
-- set default esp color text
espColorInput.Text = string.format("%d,%d,%d", 255, 50, 50)

-- Ensure knob position corresponds to default 16 speed
setSpeedFromScale(0) -- min speed

-- Clean up on close / leaving: remove ESP adornments created
local function cleanupESP()
    for p,obj in pairs(espObjects) do
        if obj.billboard and obj.billboard.Parent then obj.billboard:Destroy() end
        if obj.box and obj.box.Parent then obj.box:Destroy() end
    end
    espObjects = {}
end

LocalPlayer.AncestryChanged:Connect(function()
    if not LocalPlayer:IsDescendantOf(game) then
        cleanupESP()
    end
end)

-- Final: make sure UI is scaled nicely for small devices
-- (you can tweak sizes manually if needed)