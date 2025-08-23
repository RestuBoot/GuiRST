-- RstHUB GUI Script with draggable main GUI, player list, and teleport buttons local Players = game:GetService("Players") local player = Players.LocalPlayer local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui local screenGui = Instance.new("ScreenGui") screenGui.Name = "RstHUB_GUI" screenGui.Parent = playerGui

-- Main Frame local mainFrame = Instance.new("Frame") mainFrame.Name = "MainFrame" mainFrame.Size = UDim2.new(0, 300, 0, 400) mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200) mainFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Yellow mainFrame.AnchorPoint = Vector2.new(0.5, 0.5) mainFrame.Parent = screenGui mainFrame.BackgroundTransparency = 0.1 mainFrame.ClipsDescendants = true mainFrame.BorderSizePixel = 0

-- UICorner for rounded edges local uiCorner = Instance.new("UICorner") uiCorner.CornerRadius = UDim.new(0, 12) uiCorner.Parent = mainFrame

-- Header Label with name local headerLabel = Instance.new("TextLabel") headerLabel.Size = UDim2.new(1, 0, 0, 30) headerLabel.Position = UDim2.new(0, 0, 0, 0) headerLabel.BackgroundTransparency = 1 headerLabel.Text = "RST HUB" headerLabel.Font = Enum.Font.SourceSansBold headerLabel.TextSize = 18 headerLabel.TextColor3 = Color3.fromRGB(0, 0, 0) headerLabel.Parent = mainFrame

-- Toggle Button (small) local toggleButton = Instance.new("TextButton") toggleButton.Size = UDim2.new(0, 30, 0, 30) toggleButton.Position = UDim2.new(1, -35, 0, 5) toggleButton.Text = "" toggleButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0) toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner") toggleCorner.CornerRadius = UDim.new(0, 5) toggleCorner.Parent = toggleButton

local isVisible = true

toggleButton.MouseButton1Click:Connect(function() isVisible = not isVisible mainFrame.Visible = isVisible end)

-- Player list frame local playerListFrame = Instance.new("ScrollingFrame") playerListFrame.Size = UDim2.new(1, -20, 1, -40) playerListFrame.Position = UDim2.new(0, 10, 0, 35) playerListFrame.BackgroundTransparency = 1 playerListFrame.ScrollBarThickness = 6 playerListFrame.Parent = mainFrame

local uiLayout = Instance.new("UIListLayout") uiLayout.Padding = UDim.new(0, 5) uiLayout.SortOrder = Enum.SortOrder.LayoutOrder uiLayout.Parent = playerListFrame

-- Function to create teleport button for each player local function addPlayerButton(p) local button = Instance.new("TextButton") button.Size = UDim2.new(1, 0, 0, 30) button.BackgroundColor3 = Color3.fromRGB(200, 200, 200) button.TextColor3 = Color3.fromRGB(0, 0, 0) button.Text = p.Name button.Parent = playerListFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 5)
buttonCorner.Parent = button

button.MouseButton1Click:Connect(function()
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
    end
end)

end

-- Track players dynamically local playerButtons = {}

local function refreshPlayers() -- Clear frame for _, btn in pairs(playerButtons) do btn:Destroy() end playerButtons = {}

for _, p in pairs(Players:GetPlayers()) do
    if p ~= player then
        local btn = addPlayerButton(p)
        table.insert(playerButtons, btn)
    end
end

end

Players.PlayerAdded:Connect(function(p) refreshPlayers() end)

Players.PlayerRemoving:Connect(function(p) refreshPlayers() end)

-- Initial population refreshPlayers()

-- Draggable Function local UserInputService = game:GetService("UserInputService") local dragging = false local dragInput, mousePos, framePos

local function update(input) local delta = input.Position - mousePos mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y) end

headerLabel.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true mousePos = input.Position framePos = mainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)

headerLabel.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)

UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

