local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- Hapus GUI lama kalau ada
if CoreGui:FindFirstChild("UniversalGUI") then
    CoreGui:FindFirstChild("UniversalGUI"):Destroy()
end

-- Fungsi buat GUI
local function createButton(parent, text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 140, 0, 30)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    button.Font = Enum.Font.SourceSansBold
    button.Text = "☐ "..text
    button.TextSize = 14
    button.TextColor3 = Color3.new(0, 0, 0)
    button.Parent = parent

    local enabled = false
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        button.Text = (enabled and "☑ " or "☐ ") .. text
        callback(enabled)
    end)
end

-- Buat Frame utama
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "UniversalGUI"

local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 160)
mainFrame.Position = UDim2.new(0, 80, 0, 300)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true

-- WalkSpeed
createButton(mainFrame, "WalkSpeed", UDim2.new(0, 10, 0, 10), function(enabled)
    if enabled then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Infinite Jump
createButton(mainFrame, "Infinite Jump", UDim2.new(0, 150, 0, 10), function(enabled)
    if enabled then
        _G.infjump = true
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.infjump then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    else
        _G.infjump = false
    end
end)

-- Noclip
createButton(mainFrame, "Noclip", UDim2.new(0, 10, 0, 50), function(enabled)
    if enabled then
        _G.noclip = true
        RunService.Stepped:Connect(function()
            if _G.noclip and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        _G.noclip = false
    end
end)

-- Invisible
createButton(mainFrame, "Invisible", UDim2.new(0, 150, 0, 50), function(enabled)
    if enabled then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 1 then
                part.Transparency = 1
            end
        end
        if LocalPlayer.Character:FindFirstChild("Head") then
            LocalPlayer.Character.Head.face.Transparency = 1
        end
    else
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
        if LocalPlayer.Character:FindFirstChild("Head") then
            LocalPlayer.Character.Head.face.Transparency = 0
        end
    end
end)

-- Player ESP
createButton(mainFrame, "Player ESP", UDim2.new(0, 10, 0, 90), function(enabled)
    if enabled then
        _G.esp = true
        while _G.esp do
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("ESPBox") then
                    local billboard = Instance.new("BillboardGui", player.Character)
                    billboard.Name = "ESPBox"
                    billboard.Size = UDim2.new(0, 100, 0, 40)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true

                    local label = Instance.new("TextLabel", billboard)
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Text = player.Name .. " | " .. math.floor((player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude).."m"
                    label.TextColor3 = Color3.new(1, 1, 1)
                    label.BackgroundTransparency = 1
                    label.TextScaled = true
                end
            end
            wait(2)
        end
    else
        _G.esp = false
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESPBox") then
                player.Character:FindFirstChild("ESPBox"):Destroy()
            end
        end
    end
end)

-- Teleport
local selectedPlayer = nil
createButton(mainFrame, "Select Player", UDim2.new(0, 150, 0, 90), function()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    selectedPlayer = list[1] or nil
    print("Selected:", selectedPlayer)
end)

createButton(mainFrame, "Teleport", UDim2.new(0, 150, 0, 130), function()
    if selectedPlayer then
        local target = Players:FindFirstChild(selectedPlayer)
        if target and target.Character then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

-- Hide GUI Button
local hideBtn = Instance.new("TextButton", ScreenGui)
hideBtn.Size = UDim2.new(0, 100, 0, 30)
hideBtn.Position = UDim2.new(0, 5, 0, 270)
hideBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
hideBtn.Text = "Hide GUI"
hideBtn.TextColor3 = Color3.new(1, 1, 1)
hideBtn.Font = Enum.Font.SourceSansBold
hideBtn.TextSize = 14
hideBtn.Draggable = true
hideBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    hideBtn.Text = mainFrame.Visible and "Hide GUI" or "Show GUI"
end)
