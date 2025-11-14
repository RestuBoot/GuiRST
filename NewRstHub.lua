-- RstHUB GUI (Full Rewrite)
-- Fitur: Toggle button kecil, GUI draggable, menu teleport ke pemain, dynamic list, dan main GUI bisa di-hide

--// SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RstHUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

--// TOGGLE BUTTON (Kecil)
local Toggle = Instance.new("TextButton")
Toggle.Name = "ToggleButton"
Toggle.Size = UDim2.new(0, 45, 0, 45)
Toggle.Position = UDim2.new(0, 15, 0.4, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(255, 223, 0)
Toggle.Text = "≡"
Toggle.TextScaled = true
Toggle.BackgroundTransparency = 0.1
Toggle.BorderSizePixel = 0
Toggle.Parent = ScreenGui

--// MAIN GUI
local Main = Instance.new("Frame")
Main.Name = "MainGUI"
Main.Size = UDim2.new(0, 300, 0, 350)
Main.Position = UDim2.new(0.1, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(255, 230, 120)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui

--// DRAG FEATURE
local UIS = game:GetService("UserInputService")
local dragging = false
local dragStart, startPos

local function dragify(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

dragify(Main)

draggable = false
-- Toggle is NOT draggable

--// TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "RstHUB - Teleport Menu"
Title.TextScaled = true
Title.Parent = Main

--// PLAYER LIST HOLDER
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 5
Scroll.Parent = Main

--// UPDATE PLAYER LIST
local function updatePlayers()
    Scroll:ClearAllChildren()
    local y = 0

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 40)
            Btn.Position = UDim2.new(0, 5, 0, y)
            Btn.BackgroundColor3 = Color3.fromRGB(250, 210, 50)
            Btn.Text = plr.Name
            Btn.TextScaled = true
            Btn.Parent = Scroll

            Btn.MouseButton1Click:Connect(function()
                local char = LocalPlayer.Character
                local target = plr.Character
                if char and target and target:FindFirstChild("HumanoidRootPart") then
                    char:MoveTo(target.HumanoidRootPart.Position + Vector3.new(0, 2, 0))
                end
            end)

            y = y + 45
        end
    end

    Scroll.CanvasSize = UDim2.new(0, 0, 0, y)
end

Players.PlayerAdded:Connect(updatePlayers)
Players.PlayerRemoving:Connect(updatePlayers)
updatePlayers()

--// TOGGLE BUTTON ACTION
Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- ESP FEATURE
local espEnabled = false
local function createESP(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "RstESP"
        billboard.Size = UDim2.new(0,100,0,25)
        billboard.Adornee = player.Character.Head
        billboard.AlwaysOnTop = true

        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.Text = player.Name
        label.TextColor3 = Color3.new(1,1,0)
        label.TextScaled = true

        billboard.Parent = player.Character
    end
end

local function removeESP(player)
    if player.Character and player.Character:FindFirstChild("RstESP") then
        player.Character.RstESP:Destroy()
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= lp then
            if espEnabled then
                createESP(plr)
            else
                removeESP(plr)
            end
        end
    end
end

-- SPEED BOOST FEATURE
local speedEnabled = false
local function toggleSpeed()
    speedEnabled = not speedEnabled
    local char = lp.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speedEnabled and 40 or 16
    end
end

-- ADD BUTTONS
local espBtn = Instance.new("TextButton", mainFrame)
espBtn.Size = UDim2.new(1, -10, 0, 30)
espBtn.Position = UDim2.new(0,5,0,200)
espBtn.Text = "Toggle ESP"
espBtn.BackgroundColor3 = Color3.fromRGB(255,220,0)
espBtn.TextScaled = true
espBtn.MouseButton1Click:Connect(toggleESP)

local speedBtn = Instance.new("TextButton", mainFrame)
speedBtn.Size = UDim2.new(1, -10, 0, 30)
speedBtn.Position = UDim2.new(0,5,0,240)
speedBtn.Text = "Speed Boost"
speedBtn.BackgroundColor3 = Color3.fromRGB(255,220,0)
speedBtn.TextScaled = true
speedBtn.MouseButton1Click:Connect(toggleSpeed)


-- UPDATED ESP COLOR + OUTLINE
local espColor = Color3.fromRGB(255, 50, 50)
local function createESP(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "RstESP"
        billboard.Size = UDim2.new(0,150,0,40)
        billboard.Adornee = player.Character.Head
        billboard.AlwaysOnTop = true

        local outline = Instance.new("TextLabel", billboard)
        outline.Size = UDim2.new(1,0,1,0)
        outline.BackgroundTransparency = 1
        outline.Text = player.Name
        outline.TextColor3 = Color3.new(0,0,0)
        outline.TextScaled = true
        outline.ZIndex = 1

        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.Text = player.Name
        label.TextColor3 = espColor
        label.TextScaled = true
        label.ZIndex = 2

        billboard.Parent = player.Character
    end
end

-- SPEED SLIDER UI
local speedFrame = Instance.new("Frame", mainFrame)
speedFrame.Size = UDim2.new(1, -10, 0, 60)
speedFrame.Position = UDim2.new(0,5,0,280)
speedFrame.BackgroundTransparency = 1

local sliderBg = Instance.new("Frame", speedFrame)
sliderBg.Size = UDim2.new(1,0,0,10)
sliderBg.Position = UDim2.new(0,0,0,25)
sliderBg.BackgroundColor3 = Color3.fromRGB(200,200,200)
sliderBg.BorderSizePixel = 0

local slider = Instance.new("Frame", sliderBg)
slider.Size = UDim2.new(0,20,0,20)
slider.Position = UDim2.new(0,0,-0.5,0)
slider.BackgroundColor3 = Color3.fromRGB(255,220,0)
slider.BorderSizePixel = 0
slider.Active = true
slider.Draggable = true

local maxSpeed = 80
local function updateSpeed()
    local p = slider.Position.X.Scale
    local newSpeed = 16 + p * (maxSpeed - 16)
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = newSpeed
    end
end

slider:GetPropertyChangedSignal("Position"):Connect(updateSpeed)

-- TAB MENU SYSTEM (BASIC)
local tabs = Instance.new("Frame", mainFrame)
tabs.Size = UDim2.new(1,0,0,30)
tabs.Position = UDim2.new(0,0,0,0)
tabs.BackgroundTransparency = 1

local tabPlayers = Instance.new("TextButton", tabs)
tabPlayers.Size = UDim2.new(0.33,0,1,0)
tabPlayers.Text = "Players"

local tabFitur = Instance.new("TextButton", tabs)
tabFitur.Size = UDim2.new(0.33,0,1,0)
tabFitur.Position = UDim2.new(0.33,0,0,0)
tabFitur.Text = "Fitur"

local tabSettings = Instance.new("TextButton", tabs)
tabSettings.Size = UDim2.new(0.33,0,1,0)
tabSettings.Position = UDim2.new(0.66,0,0,0)
tabSettings.Text = "Settings"

