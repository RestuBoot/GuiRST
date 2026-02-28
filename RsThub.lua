--[[
    UNIVERSAL SCRIPT UNTUK ALL DEVICE (PC & MOBILE)
    Responsive design, touch friendly, ukuran tombol besar
]]

-- Fungsi untuk deteksi device
local function isMobile()
    return game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled
end

local function isTablet()
    local viewportSize = game:GetService("Workspace").CurrentCamera.ViewportSize
    return viewportSize.X > 800 and isMobile()
end

-- Hapus GUI lama
if game.CoreGui:FindFirstChild("MobileHub") then
    game.CoreGui.MobileHub:Destroy()
end

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileHub"
screenGui.Parent = game.CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- Deteksi ukuran layar untuk responsive design
local viewportSize = workspace.CurrentCamera.ViewportSize
local isSmallScreen = viewportSize.X < 600

-- Ukuran responsive
local guiWidth = isSmallScreen and 350 or 500
local guiHeight = isSmallScreen and 450 or 550
local buttonHeight = isSmallScreen and 45 or 40
local fontSize = isSmallScreen and 16 or 14

-- Background blur (biar kelihatan modern)
local blur = Instance.new("Frame")
blur.Name = "BackgroundBlur"
blur.Size = UDim2.new(1, 0, 1, 0)
blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
blur.BackgroundTransparency = 0.5
blur.BorderSizePixel = 0
blur.Parent = screenGui

-- Frame Utama
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, guiWidth, 0, guiHeight)
mainFrame.Position = UDim2.new(0.5, -guiWidth/2, 0.5, -guiHeight/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 40)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = not isMobile() -- Mobile ga bisa drag biar ga error
mainFrame.Parent = screenGui

-- Rounded Corners
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 20)
mainCorner.Parent = mainFrame

-- Stroke
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(0, 200, 255)
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

-- Gradient background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 40, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 20, 30))
})
gradient.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, isSmallScreen and 50 or 45)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 35, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 20)
titleCorner.Parent = titleBar

-- Icon (menggunakan TextLabel dengan emoji)
local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, isSmallScreen and 40 or 35, 0, isSmallScreen and 40 or 35)
icon.Position = UDim2.new(0, 10, 0.5, - (isSmallScreen and 20 or 17.5))
icon.BackgroundTransparency = 1
icon.Text = "🚀"
icon.TextColor3 = Color3.fromRGB(0, 200, 255)
icon.TextSize = isSmallScreen and 30 or 25
icon.Font = Enum.Font.SourceSans
icon.Parent = titleBar

-- Title Text
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -120, 1, 0)
titleText.Position = UDim2.new(0, isSmallScreen and 55 or 50, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "UNIVERSAL HUB"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = isSmallScreen and 20 or 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

-- Version
local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(0, 100, 0, 20)
versionText.Position = UDim2.new(1, -110, 0, isSmallScreen and 28 or 25)
versionText.BackgroundTransparency = 1
versionText.Text = "v2.0 • Mobile"
versionText.TextColor3 = Color3.fromRGB(150, 150, 150)
versionText.TextSize = isSmallScreen and 12 or 10
versionText.Font = Enum.Font.Gotham
versionText.Parent = titleBar

-- Control Buttons (Close & Minimize)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, isSmallScreen and 40 or 35, 0, isSmallScreen and 40 or 35)
closeBtn.Position = UDim2.new(1, - (isSmallScreen and 50 or 45), 0.5, - (isSmallScreen and 20 or 17.5))
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = isSmallScreen and 24 or 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, isSmallScreen and 40 or 35, 0, isSmallScreen and 40 or 35)
minBtn.Position = UDim2.new(1, - (isSmallScreen and 100 or 90), 0.5, - (isSmallScreen and 20 or 17.5))
minBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = isSmallScreen and 30 or 25
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 10)
minCorner.Parent = minBtn

-- Tab Container
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, -20, 0, isSmallScreen and 60 or 50)
tabContainer.Position = UDim2.new(0, 10, 0, isSmallScreen and 55 or 50)
tabContainer.BackgroundColor3 = Color3.fromRGB(30, 40, 50)
tabContainer.BackgroundTransparency = 0.5
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabContainerCorner = Instance.new("UICorner")
tabContainerCorner.CornerRadius = UDim.new(0, 15)
tabContainerCorner.Parent = tabContainer

-- Content Container
local contentFrame = Instance.new("ScrollingFrame") -- Pake ScrollingFrame biar muat banyak konten
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -20, 1, - (isSmallScreen and 170 or 150))
contentFrame.Position = UDim2.new(0, 10, 0, isSmallScreen and 120 or 105)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 45)
contentFrame.BackgroundTransparency = 0.3
contentFrame.BorderSizePixel = 0
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ScrollBarThickness = isSmallScreen and 6 or 4
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 15)
contentCorner.Parent = contentFrame

-- Buat tabs
local tabs = {
    {name = "🏠 MAIN", icon = "🏠"},
    {name = "⚔️ COMBAT", icon = "⚔️"},
    {name = "🎮 GAME", icon = "🎮"},
    {name = "⚙️ SET", icon = "⚙️"}
}

local tabButtons = {}
local currentTab = "🏠 MAIN"

-- Grid layout untuk tabs
local tabWidth = (tabContainer.AbsoluteSize.X - 30) / #tabs
for i, tab in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = tab.name
    tabBtn.Size = UDim2.new(0, tabWidth, 0, isSmallScreen and 45 or 40)
    tabBtn.Position = UDim2.new(0, 10 + ((i-1) * (tabWidth + 5)), 0, isSmallScreen and 8 or 5)
    tabBtn.BackgroundColor3 = tab.name == currentTab and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(45, 55, 65)
    tabBtn.Text = isSmallScreen and tab.icon or tab.name
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.TextSize = isSmallScreen and 24 or 14
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = tabContainer

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 12)
    tabCorner.Parent = tabBtn

    tabBtn.MouseButton1Click:Connect(function()
        for _, btn in ipairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(45, 55, 65)
        end
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        currentTab = tab.name
        
        -- Clear content
        for _, child in ipairs(contentFrame:GetChildren()) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                child:Destroy()
            end
        end
        
        LoadTabContent(currentTab, contentFrame, isSmallScreen)
    end)

    table.insert(tabButtons, tabBtn)
end

-- Layout untuk content (biar rapi)
local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 10)
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentFrame

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 10)
contentPadding.PaddingBottom = UDim.new(0, 10)
contentPadding.Parent = contentFrame

-- Fungsi untuk load konten per tab
function LoadTabContent(tab, parent, isMobile)
    if tab == "🏠 MAIN" then
        CreateBigButton(parent, "🌟 TELEPORT SPAWN", "Pindah ke spawn", function()
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
                ShowNotification("✅ Teleport berhasil!")
            end
        end, 1, isMobile)
        
        CreateBigButton(parent, "⚡ SPEED BOOST", "Kecepatan lari 50", function()
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 50
                ShowNotification("✅ Speed Boost ON!")
            end
        end, 2, isMobile)
        
        CreateBigButton(parent, "🦘 JUMP POWER", "Lompat tinggi 100", function()
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = 100
                ShowNotification("✅ Jump Power ON!")
            end
        end, 3, isMobile)
        
    elseif tab == "⚔️ COMBAT" then
        CreateBigButton(parent, "🔫 INFINITE YIELD", "Load admin commands", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
            ShowNotification("✅ Infinite Yield loaded!")
        end, 1, isMobile)
        
        CreateToggle(parent, "🎯 AIMBOT", false, function(state)
            ShowNotification("Aimbot: " .. (state and "ON" or "OFF"))
        end, 2, isMobile)
        
        CreateToggle(parent, "👁️ ESP", false, function(state)
            ShowNotification("ESP: " .. (state and "ON" or "OFF"))
        end, 3, isMobile)
        
    elseif tab == "🎮 GAME" then
        CreateBigButton(parent, "🎯 AUTO FARM", "Auto farm otomatis", function()
            ShowNotification("Auto Farm started!")
        end, 1, isMobile)
        
        CreateSlider(parent, "🎚️ FOV", 30, 120, 70, function(value)
            -- Update FOV
        end, 2, isMobile)
        
    elseif tab == "⚙️ SET" then
        CreateLabel(parent, "⚙️ PENGATURAN", 1, isMobile)
        
        CreateToggle(parent, "📱 MODE MOBILE", isMobile, function(state)
            ShowNotification("Mode Mobile: " .. (state and "ON" or "OFF"))
        end, 2, isMobile)
        
        CreateBigButton(parent, "🔄 REJOIN GAME", "Keluar dan masuk lagi", function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end, 3, isMobile)
        
        CreateBigButton(parent, "❌ EXIT SCRIPT", "Tutup semua", function()
            screenGui:Destroy()
        end, 4, isMobile)
    end
    
    -- Update canvas size
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
end

-- Helper Functions dengan ukuran mobile-friendly
function CreateBigButton(parent, text, description, callback, order, isMobile)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1, -20, 0, isMobile and 80 or 70)
    btnFrame.BackgroundColor3 = Color3.fromRGB(35, 45, 55)
    btnFrame.BackgroundTransparency = 0.2
    btnFrame.BorderSizePixel = 0
    btnFrame.LayoutOrder = order
    btnFrame.Parent = parent

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 15)
    btnCorner.Parent = btnFrame

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 1
    btnStroke.Color = Color3.fromRGB(0, 200, 255)
    btnStroke.Transparency = 0.7
    btnStroke.Parent = btnFrame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = btnFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, isMobile and 30 or 25)
    title.Position = UDim2.new(0, 15, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = isMobile and 18 or 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.Parent = btnFrame

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -35, 0, isMobile and 25 or 20)
    desc.Position = UDim2.new(0, 15, 0, isMobile and 45 or 40)
    desc.BackgroundTransparency = 1
    desc.Text = description
    desc.TextColor3 = Color3.fromRGB(150, 150, 150)
    desc.TextSize = isMobile and 14 or 12
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Font = Enum.Font.Gotham
    desc.Parent = btnFrame

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, isMobile and 30 or 25, 0, isMobile and 30 or 25)
    arrow.Position = UDim2.new(1, - (isMobile and 45 or 40), 0.5, - (isMobile and 15 or 12.5))
    arrow.BackgroundTransparency = 1
    arrow.Text = "→"
    arrow.TextColor3 = Color3.fromRGB(0, 200, 255)
    arrow.TextSize = isMobile and 24 or 20
    arrow.Font = Enum.Font.GothamBold
    arrow.Parent = btnFrame

    btn.MouseButton1Click:Connect(callback)
    
    -- Efek klik
    btn.MouseButton1Down:Connect(function()
        btnFrame.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        task.wait(0.1)
        btnFrame.BackgroundColor3 = Color3.fromRGB(35, 45, 55)
    end)
end

function CreateToggle(parent, text, default, callback, order, isMobile)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, isMobile and 60 or 50)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 45, 55)
    toggleFrame.BackgroundTransparency = 0.2
    toggleFrame.BorderSizePixel = 0
    toggleFrame.LayoutOrder = order
    toggleFrame.Parent = parent

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 15)
    toggleCorner.Parent = toggleFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, -20, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = isMobile and 18 or 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = toggleFrame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, isMobile and 70 or 60, 0, isMobile and 35 or 30)
    toggleBtn.Position = UDim2.new(1, - (isMobile and 90 or 80), 0.5, - (isMobile and 17.5 or 15))
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = isMobile and 16 or 14
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = toggleFrame

    local toggleCorner2 = Instance.new("UICorner")
    toggleCorner2.CornerRadius = UDim.new(0, 15)
    toggleCorner2.Parent = toggleBtn

    local state = default
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)
        toggleBtn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

function CreateSlider(parent, text, min, max, default, callback, order, isMobile)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, isMobile and 80 or 70)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 45, 55)
    sliderFrame.BackgroundTransparency = 0.2
    sliderFrame.BorderSizePixel = 0
    sliderFrame.LayoutOrder = order
    sliderFrame.Parent = parent

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 15)
    sliderCorner.Parent = sliderFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 0, isMobile and 25 or 20)
    label.Position = UDim2.new(0, 15, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = isMobile and 16 or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = sliderFrame

    -- Slider sederhana (bisa dikembangkan)
    local value = default
    callback(value)
end

function CreateLabel(parent, text, order, isMobile)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, isMobile and 40 or 30)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(0, 200, 255)
    label.TextSize = isMobile and 20 or 18
    label.Font = Enum.Font.GothamBold
    label.LayoutOrder = order
    label.Parent = parent
end

-- Fungsi notifikasi
function ShowNotification(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Universal Hub",
        Text = msg,
        Duration = 2,
        Icon = "rbxassetid://0"
    })
end

-- Load default tab
LoadTabContent("🏠 MAIN", contentFrame, isSmallScreen)

-- Minimize functionality
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, guiWidth, 0, isSmallScreen and 55 or 50)
        contentFrame.Visible = false
        tabContainer.Visible = false
        minBtn.Text = "□"
    else
        mainFrame.Size = UDim2.new(0, guiWidth, 0, guiHeight)
        contentFrame.Visible = true
        tabContainer.Visible = true
        minBtn.Text = "−"
    end
end)

-- Notifikasi awal
ShowNotification("✅ Script loaded! Mobile ready!")

-- Tambahkan dukungan touch untuk mobile
local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled then
    -- Perbesar area sentuh untuk semua button
    for _, btn in ipairs(screenGui:DescendantInstances()) do
        if btn:IsA("TextButton") then
            btn.AutoButtonColor = false
            btn.Selected = false
        end
    end
end
