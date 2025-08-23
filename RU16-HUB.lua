-- RstHUB GUI Full Revisi (Toggle Button kecil)

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RstHUB"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Tombol Open/Close (kecil seperti icon)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(0, 50, 0, 200)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 223, 0)
toggleButton.Text = "≡"
toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 20
toggleButton.Parent = screenGui
toggleButton.Draggable = true
toggleButton.Active = true

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 8)
UICornerBtn.Parent = toggleButton

-- Main Frame (GUI Utama)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 223, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui
mainFrame.Draggable = true
mainFrame.Active = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = mainFrame

-- Scroll Player List
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, -10, 1, -10)
playerList.Position = UDim2.new(0, 5, 0, 5)
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.ScrollBarThickness = 6
playerList.BackgroundTransparency = 1
playerList.Parent = mainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = playerList
UIListLayout.Padding = UDim.new(0, 5)

-- Fungsi tambah tombol pemain
local function addPlayerButton(plr)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 200)
    btn.Text = plr.Name
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = playerList

    btn.MouseButton1Click:Connect(function()
        local lp = game.Players.LocalPlayer
        if lp.Character and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(2,0,0))
        end
    end)
end

-- Tambahkan player yang sudah ada
for _,plr in ipairs(game.Players:GetPlayers()) do
    if plr ~= game.Players.LocalPlayer then
        addPlayerButton(plr)
    end
end

-- Update saat player join
game.Players.PlayerAdded:Connect(function(plr)
    if plr ~= game.Players.LocalPlayer then
        addPlayerButton(plr)
    end
end)

-- Update saat player keluar
game.Players.PlayerRemoving:Connect(function(plr)
    for _,btn in ipairs(playerList:GetChildren()) do
        if btn:IsA("TextButton") and btn.Text == plr.Name then
            btn:Destroy()
        end
    end
end)

-- Fungsi Open/Close
local isOpen = false
toggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    mainFrame.Visible = isOpen
end)
