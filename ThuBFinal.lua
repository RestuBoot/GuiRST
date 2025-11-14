-- RstHUB - FINAL ALL-IN-ONE (LocalScript)
-- Put this LocalScript into StarterPlayerScripts (or upload to GitHub raw + loadstring)
-- GUI: compact, yellow-black, small square toggle with "≡"
-- Tabs: Players | Menu | Speed
-- Features: Teleport, ESP (name+distance+tracer), Infinite Jump, Noclip (fixed), Touch Fling (500), Anti Fall Damage, Ghost Mode (A), TP Aura

-- ===== Services =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ===== UI configuration =====
local UI = {
    Width = 260,
    Height = 320,
    Corner = 12,
    Accent = Color3.fromRGB(255,220,0), -- yellow
    Bg = Color3.fromRGB(245,230,200),   -- soft panel
    TextDark = Color3.fromRGB(30,30,30),
    TextLight = Color3.fromRGB(250,250,250),
    EspColor = Color3.fromRGB(255,240,0) -- yellow for ESP
}

-- ===== Helpers =====
local function create(class, props)
    local obj = Instance.new(class)
    if props then for k,v in pairs(props) do obj[k] = v end end
    return obj
end
local function clamp(v,a,b) if v<a then return a elseif v>b then return b else return v end end

local function dragify(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(clamp(startPos.X.Scale,0,1), startPos.X.Offset + delta.X, clamp(startPos.Y.Scale,0,1), startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ===== Create UI =====
local screenGui = create("ScreenGui", { Name = "RstHUB_GUI", Parent = PlayerGui, ResetOnSpawn = false })

-- small square toggle button with three horizontal lines
local toggleBtn = create("TextButton", {
    Parent = screenGui,
    Name = "OpenToggle",
    Size = UDim2.new(0,44,0,44),
    Position = UDim2.new(0,16,0.42,0),
    BackgroundColor3 = UI.Accent,
    Text = "≡",
    Font = Enum.Font.GothamBold,
    TextSize = 28,
    TextColor3 = UI.TextDark,
    BorderSizePixel = 0,
})
create("UICorner", { Parent = toggleBtn, CornerRadius = UDim.new(0,8) })
dragify(toggleBtn)

-- main panel
local main = create("Frame", {
    Parent = screenGui,
    Name = "MainPanel",
    Size = UDim2.new(0, UI.Width, 0, UI.Height),
    Position = UDim2.new(0.12,0,0.08,0),
    BackgroundColor3 = UI.Bg,
    Visible = false
})
create("UICorner", { Parent = main, CornerRadius = UDim.new(0,UI.Corner) })
dragify(main)

-- title + close
local title = create("TextLabel", { Parent = main, Size = UDim2.new(1,-20,0,36), Position = UDim2.new(0,10,0,8), BackgroundTransparency = 1, Text = "RstHUB - Main Panel", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = UI.TextDark, TextXAlignment = Enum.TextXAlignment.Left })
local closeBtn = create("TextButton", { Parent = main, Size = UDim2.new(0,28,0,24), Position = UDim2.new(1,-36,0,8), Text = "X", BackgroundColor3 = Color3.fromRGB(220,80,80), Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.new(1,1,1) })
create("UICorner", { Parent = closeBtn, CornerRadius = UDim.new(0,6) })
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

-- tabs
local tabHeader = create("Frame", { Parent = main, Size = UDim2.new(1,-20,0,40), Position = UDim2.new(0,10,0,52), BackgroundTransparency = 1 })
local function mkTab(text, pos)
    local b = create("TextButton", { Parent = tabHeader, Size = UDim2.new(0.33,-8,1,0), Position = UDim2.new(pos,4,0,0), BackgroundColor3 = Color3.fromRGB(255,250,240), Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = UI.TextDark })
    create("UICorner", { Parent = b, CornerRadius = UDim.new(0,8) })
    return b
end
local btnPlayers = mkTab("Players", 0)
local btnMenu = mkTab("Menu", 0.33)
local btnSpeed = mkTab("Speed", 0.66)

local content = create("Frame", { Parent = main, Size = UDim2.new(1,-20,1,-120), Position = UDim2.new(0,10,0,100), BackgroundTransparency = 1 })

-- Players tab
local playersFrame = create("Frame", { Parent = content, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = true })
local playersScroll = create("ScrollingFrame", { Parent = playersFrame, Size = UDim2.new(1,0,1,0), CanvasSize = UDim2.new(0,0,0,0), ScrollBarThickness = 8, BackgroundTransparency = 1 })
local playersLayout = create("UIListLayout", { Parent = playersScroll })
playersLayout.Padding = UDim.new(0,6)

local function clearList(parent)
    for _,c in ipairs(parent:GetChildren()) do
        if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
    end
end

local function createPlayerButton(plr)
    local btn = create("TextButton", { Parent = playersScroll, Size = UDim2.new(1,-12,0,40), BackgroundColor3 = UI.Accent, Text = plr.Name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = UI.TextDark })
    create("UICorner", { Parent = btn, CornerRadius = UDim.new(0,8) })
    btn.MouseButton1Click:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
            end)
        end
    end)
    return btn
end

local function refreshPlayers()
    clearList(playersScroll)
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then createPlayerButton(p) end
    end
    playersScroll.CanvasSize = UDim2.new(0,0,0, playersLayout.AbsoluteContentSize.Y + 12)
end
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()

-- Menu tab
local menuFrame = create("Frame", { Parent = content, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = false })
local menuScroll = create("ScrollingFrame", { Parent = menuFrame, Size = UDim2.new(1,0,1,0), CanvasSize = UDim2.new(0,0,0,0), ScrollBarThickness = 8, BackgroundTransparency = 1 })
local menuLayout = create("UIListLayout", { Parent = menuScroll }) menuLayout.Padding = UDim.new(0,8)

local function makeToggleRow(parent, labelText)
    local row = create("Frame", { Parent = parent, Size = UDim2.new(1,-12,0,44), BackgroundTransparency = 1 })
    local label = create("TextLabel", { Parent = row, Size = UDim2.new(0.72,0,1,0), BackgroundTransparency = 1, Text = labelText, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = UI.TextDark })
    local tbtn = create("TextButton", { Parent = row, Size = UDim2.new(0.26,0,0.66,0), Position = UDim2.new(0.72,8,0.17,0), BackgroundColor3 = Color3.fromRGB(230,230,230), Text = "OFF", Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = UI.TextDark })
    create("UICorner", { Parent = tbtn, CornerRadius = UDim.new(0,8) })
    return row, tbtn
end

-- create toggles
local espRow, espToggle = makeToggleRow(menuScroll, "ESP")
local infRow, infToggle = makeToggleRow(menuScroll, "Infinite Jump")
local noclipRow, noclipToggle = makeToggleRow(menuScroll, "Noclip")
local flingRow, flingToggle = makeToggleRow(menuScroll, "Touch Fling")
local antiRow, antiToggle = makeToggleRow(menuScroll, "Anti Fall Damage")
local ghostRow, ghostToggle = makeToggleRow(menuScroll, "Ghost Mode (A)")
local tpRow, tpToggle = makeToggleRow(menuScroll, "TP Aura (Nearest)")
local flingInfo = create("TextLabel", { Parent = menuScroll, Size = UDim2.new(1,-12,0,18), BackgroundTransparency = 1, Text = "Fling Power: 500 (default)", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = UI.TextDark })

menuLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    menuScroll.CanvasSize = UDim2.new(0,0,0, menuLayout.AbsoluteContentSize.Y + 12)
end)

-- Speed tab
local speedFrame = create("Frame", { Parent = content, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = false })
create("TextLabel", { Parent = speedFrame, Size = UDim2.new(1,-20,0,20), Position = UDim2.new(0,10,0,6), BackgroundTransparency = 1, Text = "WalkSpeed", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = UI.TextDark, TextXAlignment = Enum.TextXAlignment.Left })
local sliderBg = create("Frame", { Parent = speedFrame, Size = UDim2.new(1,-90,0,18), Position = UDim2.new(0,50,0,36), BackgroundColor3 = Color3.fromRGB(200,200,200) })
create("UICorner", { Parent = sliderBg, CornerRadius = UDim.new(0,6) })
local knob = create("Frame", { Parent = sliderBg, Size = UDim2.new(0.06,0,1,0), Position = UDim2.new(0,0,0,0), BackgroundColor3 = UI.Accent })
create("UICorner", { Parent = knob, CornerRadius = UDim.new(0,6) })
local minusBtn = create("TextButton", { Parent = speedFrame, Size = UDim2.new(0,34,0,26), Position = UDim2.new(0,8,0,32), Text = "-", Font = Enum.Font.GothamBold, TextSize = 18, BackgroundColor3 = Color3.fromRGB(240,240,240), TextColor3 = UI.TextDark })
create("UICorner", { Parent = minusBtn, CornerRadius = UDim.new(0,6) })
local plusBtn = create("TextButton", { Parent = speedFrame, Size = UDim2.new(0,34,0,26), Position = UDim2.new(1,-44,0,32), Text = "+", Font = Enum.Font.GothamBold, TextSize = 18, BackgroundColor3 = Color3.fromRGB(240,240,240), TextColor3 = UI.TextDark })
create("UICorner", { Parent = plusBtn, CornerRadius = UDim.new(0,6) })
local speedVal = create("TextLabel", { Parent = speedFrame, Size = UDim2.new(0,70,0,26), Position = UDim2.new(0.5,-35,0,32), BackgroundTransparency = 1, Text = "16", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = UI.TextDark })

local minSpeed, maxSpeed = 16, 100
local function setSpeed(scale)
    scale = clamp(scale,0,1)
    local val = math.floor(minSpeed + scale*(maxSpeed-minSpeed) + 0.5)
    speedVal.Text = tostring(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = val end)
    end
    knob.Position = UDim2.new(scale,0,0,0)
end

-- knob drag
local draggingKnob = false
knob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then draggingKnob=true i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then draggingKnob=false end end) end end)
knob.InputChanged:Connect(function(i) if draggingKnob and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local abs=i.Position local bg=sliderBg.AbsolutePosition local rel=abs.X-bg.X setSpeed(rel / math.max(1, sliderBg.AbsoluteSize.X)) end end)
sliderBg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then local abs=i.Position local bg=sliderBg.AbsolutePosition local rel=abs.X-bg.X setSpeed(rel / math.max(1, sliderBg.AbsoluteSize.X)) end end)
minusBtn.MouseButton1Click:Connect(function() local cur = tonumber(speedVal.Text) or minSpeed setSpeed((cur-1-minSpeed)/(maxSpeed-minSpeed)) end)
plusBtn.MouseButton1Click:Connect(function() local cur = tonumber(speedVal.Text) or minSpeed setSpeed((cur+1-minSpeed)/(maxSpeed-minSpeed)) end)
setSpeed(0)

-- tab switching
local function showTab(t)
    playersFrame.Visible = (t=="players")
    menuFrame.Visible = (t=="menu")
    speedFrame.Visible = (t=="speed")
    btnPlayers.BackgroundColor3 = (t=="players") and UI.Accent or Color3.fromRGB(255,250,240)
    btnMenu.BackgroundColor3 = (t=="menu") and UI.Accent or Color3.fromRGB(255,250,240)
    btnSpeed.BackgroundColor3 = (t=="speed") and UI.Accent or Color3.fromRGB(255,250,240)
end
btnPlayers.MouseButton1Click:Connect(function() showTab("players") end)
btnMenu.MouseButton1Click:Connect(function() showTab("menu") end)
btnSpeed.MouseButton1Click:Connect(function() showTab("speed") end)
showTab("players")

-- ===== Feature states & core logic =====

-- ---- ESP ----
local espOn = false
local billboards = {} -- player -> billboard
local tracers = {}    -- player -> screen Frame

local function safeDestroy(obj)
    if obj and obj.Parent then
        pcall(function() obj:Destroy() end)
    end
end

local function makeESPFor(plr)
    if not plr or plr == LocalPlayer then return end
    if not plr.Character then return end
    local head = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
    if not head then return end
    if billboards[plr] then safeDestroy(billboards[plr]) end
    if tracers[plr] then safeDestroy(tracers[plr]) end

    local bb = create("BillboardGui", {Adornee = head, Size = UDim2.new(0,160,0,22), AlwaysOnTop = true, ExtentsOffset = Vector3.new(0,1.6,0), Parent = head})
    local lbl = create("TextLabel", {Parent = bb, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = plr.Name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = UI.EspColor})
    local f = create("Frame", { Parent = screenGui, Size = UDim2.new(0,2,0,2), Position = UDim2.new(0,0,0,0), BackgroundColor3 = UI.EspColor, ZIndex = 50 })
    f.AnchorPoint = Vector2.new(0,0.5)
    billboards[plr] = bb
    tracers[plr] = f
end

local function removeESPFor(plr)
    if billboards[plr] then safeDestroy(billboards[plr]) billboards[plr] = nil end
    if tracers[plr] then safeDestroy(tracers[plr]) tracers[plr] = nil end
end

local function enableESP()
    espOn = true
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and (p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")) then
            makeESPFor(p)
        end
        p.CharacterAdded:Connect(function() task.wait(0.15) if espOn then makeESPFor(p) end end)
    end
end

local function disableESP()
    espOn = false
    for p,_ in pairs(billboards) do removeESPFor(p) end
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
                local pos = target.Position
                local dist = math.floor(((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position) and (pos - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) or (pos - Camera.CFrame.Position).Magnitude)
                local label = bb:FindFirstChildOfClass("TextLabel")
                if label then
                    label.Text = string.format("%s | %dm", p.Name, dist)
                    label.TextColor3 = UI.EspColor
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
                    local dx = x - sx
                    local dy = y - sy
                    local len = math.sqrt(dx*dx + dy*dy)
                    if len < 4 then len = 4 end
                    local angle = math.deg(math.atan2(dy, dx))
                    f.Size = UDim2.new(0, clamp(len, 2, vp.X*2), 0, 2)
                    f.Position = UDim2.new(0, sx, 0, sy)
                    f.Rotation = angle
                    f.BackgroundColor3 = UI.EspColor
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

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() task.wait(0.15) if espOn and plr~=LocalPlayer then makeESPFor(plr) end end)
    refreshPlayers()
end)
Players.PlayerRemoving:Connect(function(plr) removeESPFor(plr) refreshPlayers() end)

espToggle.MouseButton1Click:Connect(function()
    if not espOn then enableESP() else disableESP() end
    espToggle.Text = espOn and "ON" or "OFF"
    espToggle.BackgroundColor3 = espOn and UI.Accent or Color3.fromRGB(230,230,230)
end)

-- ---- Infinite Jump ----
local infOn = false
infToggle.MouseButton1Click:Connect(function()
    infOn = not infOn
    infToggle.Text = infOn and "ON" or "OFF"
    infToggle.BackgroundColor3 = infOn and UI.Accent or Color3.fromRGB(230,230,230)
end)
UserInputService.JumpRequest:Connect(function()
    if infOn then
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("Humanoid") then
            pcall(function() c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
        end
    end
end)

-- ---- Noclip (fixed, robust) ----
local noclipOn = false
local noclipBackup = {} -- [part] = bool

local function getParts(char)
    local parts = {}
    if not char then return parts end
    for _,d in ipairs(char:GetDescendants()) do
        if d:IsA("BasePart") then parts[#parts+1] = d end
    end
    return parts
end

local function applyNoclip(state)
    noclipOn = state
    noclipToggle.Text = state and "ON" or "OFF"
    noclipToggle.BackgroundColor3 = state and UI.Accent or Color3.fromRGB(230,230,230)
    local char = LocalPlayer.Character
    if not char then return end
    if state then
        noclipBackup = {}
        for _,part in ipairs(getParts(char)) do
            if not noclipBackup[part] then
                noclipBackup[part] = part.CanCollide
                pcall(function() part.CanCollide = false end)
            end
        end
    else
        -- restore prior values
        for part,orig in pairs(noclipBackup) do
            if part and part.Parent then
                pcall(function() part.CanCollide = orig end)
            end
        end
        noclipBackup = {}
        -- ensure any new parts are set to default true to avoid sticking false
        for _,p in ipairs(getParts(char)) do
            if p and p.Parent and p.CanCollide == false then
                pcall(function() p.CanCollide = true end)
            end
        end
    end
end

noclipToggle.MouseButton1Click:Connect(function() applyNoclip(not noclipOn) end)
LocalPlayer.CharacterAdded:Connect(function(c) task.wait(0.2) if noclipOn and c then -- ensure newly added parts have collision disabled
    for _,part in ipairs(getParts(c)) do
        if not noclipBackup[part] then noclipBackup[part] = part.CanCollide end
        pcall(function() part.CanCollide = false end)
    end end end)

-- ---- Touch Fling (managed binds) ----
local flingOn = false
local flingPower = 500
local touchConnections = {}

local function onTouch(part)
    if not flingOn then return end
    local pl = Players:GetPlayerFromCharacter(part.Parent)
    if pl and pl ~= LocalPlayer then
        local hrp = part.Parent:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function()
                local bv = Instance.new("BodyVelocity")
 