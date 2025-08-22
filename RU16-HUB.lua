-- RstHUB dengan Teleport ke Pemain
-- By RestuBoot

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RstHUB"
ScreenGui.Parent = game:GetService("CoreGui")

-- Buat Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
Title.Text = "RstHUB - Teleport"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Scrolling untuk daftar pemain
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, -10, 1, -40)
PlayerList.Position = UDim2.new(0, 5, 0, 35)
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.ScrollBarThickness = 6
PlayerList.BackgroundColor3 = Color3.fromRGB(240, 240, 200)
PlayerList.BorderSizePixel = 0
PlayerList.Parent = MainFrame

-- Template Button untuk pemain
local function CreatePlayerButton(player)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 30)
    Btn.Position = UDim2.new(0, 5, 0, (#PlayerList:GetChildren()-1) * 35)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 150)
    Btn.Text = player.Name
    Btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 16
    Btn.Parent = PlayerList

    Btn.MouseButton1Click:Connect(function()
        local LocalPlayer = game.Players.LocalPlayer
        if LocalPlayer.Character and player.Character then
            LocalPlayer.Character:MoveTo(player.Character.PrimaryPart.Position + Vector3.new(2,0,2))
        end
    end)
end

-- Update daftar pemain
local function RefreshPlayers()
    PlayerList:ClearAllChildren()
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            CreatePlayerButton(p)
        end
    end
    PlayerList.CanvasSize = UDim2.new(0,0,0,#game.Players:GetPlayers()*35)
end

-- Event update otomatis
game.Players.PlayerAdded:Connect(RefreshPlayers)
game.Players.PlayerRemoving:Connect(RefreshPlayers)

-- Pertama kali dijalankan
RefreshPlayers()
