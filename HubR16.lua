-- FULL SCRIPT: Stylish, Compact & Draggable Teleport GUI for Roblox

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Create ScreenGui container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

-- TP Button (small corner button)
local TPButton = Instance.new("TextButton")
TPButton.Size = UDim2.new(0, 60, 0, 30)
TPButton.Position = UDim2.new(0.02, 0, 0.2, 0)
TPButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
TPButton.Text = "TP"
TPButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TPButton.Font = Enum.Font.SourceSansBold
TPButton.TextSize = 16
TPButton.Parent = ScreenGui
local tpCorner = Instance.new("UICorner", TPButton)
tpCorner.CornerRadius = UDim.new(0, 8)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
local frameCorner = Instance.new("UICorner", MainFrame)
frameCorner.CornerRadius = UDim.new(0, 12)

-- Title Bar (drag area)
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
TitleBar.Text = "Teleport Menu"
TitleBar.Font = Enum.Font.SourceSansBold
TitleBar.TextSize = 18
TitleBar.TextColor3 = Color3.fromRGB(0, 0, 0)
TitleBar.Parent = MainFrame
local titleCorner = Instance.new("UICorner", TitleBar)
titleCorner.CornerRadius = UDim.new(0, 8)

-- Scroll Frame for player list
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, -10, 1, -45)
PlayerList.Position = UDim2.new(0, 5, 0, 40)
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.ScrollBarThickness = 6
PlayerList.BackgroundTransparency = 1
PlayerList.Parent = MainFrame
local listLayout = Instance.new("UIListLayout", PlayerList)
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Close Button "X"
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 60, 0, 25)
CloseBtn.Position = UDim2.new(1, -65, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(1, 1, 1)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16
CloseBtn.Parent = MainFrame
local closeCorner = Instance.new("UICorner", CloseBtn)
closeCorner.CornerRadius = UDim.new(0, 8)

-- Teleport function
local function teleportToPlayer(player)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:MoveTo(hrp.Position + Vector3.new(0, 3, 0))
        end
    end
end

-- Function to add player button
local function addPlayerButton(player)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = player.Name
    btn.TextColor3 = Color3.fromRGB(255, 200, 0)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = PlayerList
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)

    -- bind click
    btn.MouseButton1Click:Connect(function()
        teleportToPlayer(player)
    end)

    -- remove when player leaves
    player.AncestryChanged:Connect(function(_, parent)
        if not parent then
            btn:Destroy()
        end
    end)
end

-- Refresh list
local function refreshPlayers()
    -- clear
    for _, child in ipairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    -- re-add
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            addPlayerButton(plr)
        end
    end
end

-- Auto-update canvas size for scrolling
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

-- Player added/removed
Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then
        addPlayerButton(plr)
    end
end)
Players.PlayerRemoving:Connect(function(plr)
    refreshPlayers()
end)

-- Toggle GUI display
TPButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        refreshPlayers()
    end
end)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Drag helper function
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
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
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Enable dragging
makeDraggable(MainFrame, TitleBar)
makeDraggable(TPButton)

print("Teleport GUI fully loaded — stylish, scrollable, draggable, and functional!")