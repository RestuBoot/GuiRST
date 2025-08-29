-- Teleport GUI (Fix Teleport Bug + Scroll + Drag Button)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

-- Tombol Open (TP)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 60, 0, 30)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
ToggleBtn.TextColor3 = Color3.new(0,0,0)
ToggleBtn.Text = "TP"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16
ToggleBtn.Parent = ScreenGui
local UICorner1 = Instance.new("UICorner")
UICorner1.CornerRadius = UDim.new(0, 8)
UICorner1.Parent = ToggleBtn

-- Frame utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 12)
UICorner2.Parent = MainFrame

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
Title.Text = "Teleport Menu"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextColor3 = Color3.new(0,0,0)
Title.Parent = MainFrame
local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 8)
UICorner3.Parent = Title

-- Scroll list player
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, -10, 1, -45)
PlayerList.Position = UDim2.new(0,5,0,40)
PlayerList.CanvasSize = UDim2.new(0,0,0,0)
PlayerList.ScrollBarThickness = 6
PlayerList.BackgroundTransparency = 1
PlayerList.Parent = MainFrame
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = PlayerList
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Tombol Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 60, 0, 25)
CloseBtn.Position = UDim2.new(1, -65, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16
CloseBtn.Parent = MainFrame
local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(0, 8)
UICorner4.Parent = CloseBtn

-- Fungsi teleport
local function teleportToPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetHRP = targetPlayer.Character.HumanoidRootPart
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetHRP.CFrame + Vector3.new(0,3,0)
        end
    end
end

-- Tambahkan tombol player
local function addPlayerButton(player)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -6, 0, 28)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.TextColor3 = Color3.fromRGB(255, 200, 0)
    Btn.Text = player.Name
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 16
    Btn.Parent = PlayerList
    local UIC = Instance.new("UICorner")
    UIC.CornerRadius = UDim.new(0, 6)
    UIC.Parent = Btn

    -- Fix bug teleport hanya player paling atas
    Btn.MouseButton1Click:Connect(function()
        teleportToPlayer(player)
    end)

    player.AncestryChanged:Connect(function(_, parent)
        if not parent then Btn:Destroy() end
    end)
end

-- Refresh daftar player
local function refreshPlayers()
    for _, child in pairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then addPlayerButton(p) end
    end
    -- Update scroll tinggi sesuai jumlah
    PlayerList.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y+10)
end
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerList.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y+10)
end)

-- Event update pemain
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then addPlayerButton(p) end end)
Players.PlayerRemoving:Connect(function(p)
    for _, btn in pairs(PlayerList:GetChildren()) do
        if btn:IsA("TextButton") and btn.Text == p.Name then btn:Destroy() end
    end
    PlayerList.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y+10)
end)

-- Event tombol
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then refreshPlayers() end
end)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- Dragging untuk frame
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                 startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

makeDraggable(Title)     -- bisa drag frame lewat title
makeDraggable(ToggleBtn) -- tombol "TP" juga bisa digeser

print("Teleport GUI Fixed + Scroll + Drag Loaded!")
