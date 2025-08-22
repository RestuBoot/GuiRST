-- RstHUB GUI Script
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RstHUB"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Tombol untuk buka GUI
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 120, 0, 40)
openButton.Position = UDim2.new(0, 20, 0, 200)
openButton.Text = "Open RstHUB"
openButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
openButton.TextColor3 = Color3.new(0, 0, 0)
openButton.Parent = screenGui

-- Frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 150)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(255, 223, 0)
title.Text = "RstHUB - Teleport Menu"
title.TextColor3 = Color3.new(0, 0, 0)
title.Parent = mainFrame

-- ScrollFrame untuk daftar pemain
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.Parent = mainFrame

-- Template untuk tombol player
local function createPlayerButton(player)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = player.Name
    btn.BackgroundColor3 = Color3.fromRGB(240, 240, 0)
    btn.TextColor3 = Color3.new(0, 0, 0)
    btn.Parent = scroll

    btn.MouseButton1Click:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0)
            end
        end
    end)

    return btn
end

-- Update daftar pemain
local function updatePlayerList()
    scroll:ClearAllChildren()
    local y = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = createPlayerButton(plr)
            btn.Position = UDim2.new(0, 5, 0, y)
            y = y + 40
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- Event jika pemain join/keluar
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Tombol open GUI
openButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    updatePlayerList()
end)
