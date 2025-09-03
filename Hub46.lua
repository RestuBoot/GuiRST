-- // Gui RST HUB Lengkap + Infinite Jump
-- // Script ini gabungan dari versi lama + tambahan fitur Infinite Jump
-- // By: RstHUB

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- GUI utama
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local PlayerList = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local ToggleButton = Instance.new("TextButton")
local InfJumpButton = Instance.new("TextButton")

-- Parent
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- MainFrame
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 221, 85) -- kuning
MainFrame.Size = UDim2.new(0, 220, 0, 300)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 12)

-- Title
Title.Parent = MainFrame
Title.Text = "RST HUB"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- Player List
PlayerList.Parent = MainFrame
PlayerList.Size = UDim2.new(1, -10, 0, 200)
PlayerList.Position = UDim2.new(0, 5, 0, 50)
PlayerList.BackgroundTransparency = 0.2
PlayerList.ScrollBarThickness = 6

UIListLayout.Parent = PlayerList
UIListLayout.SortOrder = Enum.SortOrder.Layout

-- Toggle Button (Open/Close GUI)
ToggleButton.Parent = ScreenGui
ToggleButton.Text = "RST"
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 221, 85)
ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14

local toggle = true
ToggleButton.MouseButton1Click:Connect(function()
    toggle = not toggle
    MainFrame.Visible = toggle
end)

-- Infinite Jump Button
InfJumpButton.Parent = MainFrame
InfJumpButton.Text = "Infinite Jump: OFF"
InfJumpButton.Size = UDim2.new(1, -20, 0, 30)
InfJumpButton.Position = UDim2.new(0, 10, 1, -40)
InfJumpButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
InfJumpButton.TextColor3 = Color3.fromRGB(0, 0, 0)
InfJumpButton.Font = Enum.Font.GothamBold
InfJumpButton.TextSize = 14

-- Infinite Jump Logic
local infJumpEnabled = false
InfJumpButton.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    if infJumpEnabled then
        InfJumpButton.Text = "Infinite Jump: ON"
        InfJumpButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    else
        InfJumpButton.Text = "Infinite Jump: OFF"
        InfJumpButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Fungsi Teleport ke Player
local function addPlayerButton(plr)
    if plr.Name ~= LocalPlayer.Name then
        local btn = Instance.new("TextButton")
        btn.Parent = PlayerList
        btn.Text = "Teleport: " .. plr.Name
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.MouseButton1Click:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") 
               and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
            end
        end)
    end
end

-- Auto-update Player List
Players.PlayerAdded:Connect(addPlayerButton)
for _, plr in pairs(Players:GetPlayers()) do
    addPlayerButton(plr)
end