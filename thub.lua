--// NEBULA HUB

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

pcall(function()
    game.CoreGui:FindFirstChild("NebulaUI"):Destroy()
end)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- MAIN
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0,320,0,220)
Main.Position = UDim2.new(0.5,-160,0.5,-110)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0
Main.Active = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

local Stroke = Instance.new("UIStroke")
Stroke.Parent = Main
Stroke.Color = Color3.fromRGB(60,60,60)

-- TOPBAR
local Topbar = Instance.new("Frame")
Topbar.Parent = Main
Topbar.Size = UDim2.new(1,0,0,45)
Topbar.BackgroundColor3 = Color3.fromRGB(28,28,28)
Topbar.BorderSizePixel = 0

Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0,18)

local Fix = Instance.new("Frame")
Fix.Parent = Topbar
Fix.Size = UDim2.new(1,0,0,20)
Fix.Position = UDim2.new(0,0,1,-20)
Fix.BackgroundColor3 = Color3.fromRGB(28,28,28)
Fix.BorderSizePixel = 0

-- TITLE
local Title = Instance.new("TextLabel")
Title.Parent = Topbar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,1,0)
Title.Font = Enum.Font.GothamBold
Title.Text = "NEBULA HUB"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 20

-- MINIMIZE BUTTON
local Minimize = Instance.new("TextButton")
Minimize.Parent = Topbar
Minimize.Size = UDim2.new(0,30,0,30)
Minimize.Position = UDim2.new(1,-40,0.5,-15)
Minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
Minimize.Text = "-"
Minimize.Font = Enum.Font.GothamBold
Minimize.TextColor3 = Color3.fromRGB(255,255,255)
Minimize.TextSize = 18
Minimize.BorderSizePixel = 0

Instance.new("UICorner", Minimize).CornerRadius = UDim.new(1,0)

-- OPEN BUTTON
local OpenButton = Instance.new("TextButton")
OpenButton.Parent = ScreenGui
OpenButton.Size = UDim2.new(0,55,0,55)
OpenButton.Position = UDim2.new(0,20,0.5,0)
OpenButton.BackgroundColor3 = Color3.fromRGB(20,20,20)
OpenButton.Text = "☰"
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextColor3 = Color3.fromRGB(255,255,255)
OpenButton.TextSize = 24
OpenButton.Visible = false
OpenButton.BorderSizePixel = 0

Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1,0)

-- LABEL
local Label = Instance.new("TextLabel")
Label.Parent = Main
Label.BackgroundTransparency = 1
Label.Position = UDim2.new(0,20,0,70)
Label.Size = UDim2.new(0,200,0,30)
Label.Font = Enum.Font.GothamSemibold
Label.Text = "Infinite Jump"
Label.TextColor3 = Color3.fromRGB(255,255,255)
Label.TextSize = 18
Label.TextXAlignment = Enum.TextXAlignment.Left

-- TOGGLE
local Toggle = Instance.new("TextButton")
Toggle.Parent = Main
Toggle.Size = UDim2.new(0,80,0,35)
Toggle.Position = UDim2.new(1,-100,0,67)
Toggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
Toggle.Text = "OFF"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextColor3 = Color3.fromRGB(255,255,255)
Toggle.TextSize = 16
Toggle.BorderSizePixel = 0

Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1,0)

-- STATUS
local Status = Instance.new("TextLabel")
Status.Parent = Main
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0,20,0,120)
Status.Size = UDim2.new(1,-40,0,30)
Status.Font = Enum.Font.Gotham
Status.Text = "Status : Disabled"
Status.TextColor3 = Color3.fromRGB(180,180,180)
Status.TextSize = 15
Status.TextXAlignment = Enum.TextXAlignment.Left

-- INFINITE JUMP
local InfiniteJump = false

Toggle.MouseButton1Click:Connect(function()

    InfiniteJump = not InfiniteJump

    if InfiniteJump then
        Toggle.Text = "ON"
        Toggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
        Status.Text = "Status : Enabled"
    else
        Toggle.Text = "OFF"
        Toggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
        Status.Text = "Status : Disabled"
    end
end)

UIS.JumpRequest:Connect(function()

    if InfiniteJump then
        local Character = Player.Character

        if Character and Character:FindFirstChildOfClass("Humanoid") then
            Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- HIDE UI
Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenButton.Visible = true
end)

-- SHOW UI
OpenButton.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenButton.Visible = false
end)

-- DRAG SYSTEM

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart

    Main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

Topbar.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Topbar.InputChanged:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then

        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)

    if input == dragInput and dragging then
        update(input)
    end
end)