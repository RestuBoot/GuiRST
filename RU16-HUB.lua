-- RstHUB GUI Script
-- Dibuat untuk PlayerList custom, draggable + animasi

-- Hapus GUI lama kalau ada
if game.CoreGui:FindFirstChild("RstHUB") then
    game.CoreGui.RstHUB:Destroy()
end

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Buat ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "RstHUB"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Tombol toggle (kecil, bulat, draggable)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "Toggle"
toggleButton.Size = UDim2.new(0,40,0,40)
toggleButton.Position = UDim2.new(0.05,0,0.5,0)
toggleButton.Text = "≡"
toggleButton.TextSize = 18
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 221, 0)
toggleButton.TextColor3 = Color3.fromRGB(0,0,0)
toggleButton.BorderSizePixel = 0
toggleButton.Parent = gui
toggleButton.AutoButtonColor = true
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.AnchorPoint = Vector2.new(0.5,0.5)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.TextWrapped = true
toggleButton.BackgroundTransparency = 0.1
toggleButton.UICorner = Instance.new("UICorner", toggleButton)
toggleButton.UICorner.CornerRadius = UDim.new(1,0)

-- Frame utama (draggable + animasi buka/tutup)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,250,0,300)
mainFrame.Position = UDim2.new(0.5,-125,0.5,-150)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 221, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,12)

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "RstHUB PlayerList"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Parent = mainFrame

-- Scrolling list
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1,-10,1,-40)
scrollingFrame.Position = UDim2.new(0,5,0,35)
scrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollingFrame.Parent = mainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0,5)
UIListLayout.Parent = scrollingFrame

-- Template player label
local function createPlayerLabel(player)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-5,0,30)
    lbl.BackgroundColor3 = Color3.fromRGB(255,255,255)
    lbl.Text = player.Name
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 16
    lbl.TextColor3 = Color3.fromRGB(0,0,0)
    lbl.Parent = scrollingFrame
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0,8)
    return lbl
end

-- Fungsi update player list
local function updatePlayers()
    scrollingFrame:ClearAllChildren()
    UIListLayout.Parent = scrollingFrame
    for _,plr in ipairs(Players:GetPlayers()) do
        createPlayerLabel(plr)
    end
    scrollingFrame.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y+10)
end

-- Event join/leave
Players.PlayerAdded:Connect(updatePlayers)
Players.PlayerRemoving:Connect(updatePlayers)

-- Toggle animasi buka/tutup
local open = false
toggleButton.MouseButton1Click:Connect(function()
    open = not open
    if open then
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0,0,0,0)
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,250,0,300)}):Play()
        updatePlayers()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)}):Play()
        task.wait(0.3)
        mainFrame.Visible = false
    end
end)
