--// NEBULA X HUB
--// Mobile & PC Supported
--// Modern Roblox Executor UI
--// Features:
--// Infinite Jump
--// WalkSpeed
--// Fly
--// Noclip
--// FullBright
--// Rejoin
--// Anti AFK
--// Draggable UI
--// Hide/Show UI

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer

pcall(function()
	game.CoreGui:FindFirstChild("NebulaXHub"):Destroy()
end)

-- GUI

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaXHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- MAIN

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0,340,0,420)
Main.Position = UDim2.new(0.5,-170,0.5,-210)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.BorderSizePixel = 0
Main.Active = true

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,18)

local Stroke = Instance.new("UIStroke",Main)
Stroke.Color = Color3.fromRGB(60,60,60)

-- TOPBAR

local Topbar = Instance.new("Frame")
Topbar.Parent = Main
Topbar.Size = UDim2.new(1,0,0,45)
Topbar.BackgroundColor3 = Color3.fromRGB(24,24,24)
Topbar.BorderSizePixel = 0

Instance.new("UICorner",Topbar).CornerRadius = UDim.new(0,18)

local Fix = Instance.new("Frame")
Fix.Parent = Topbar
Fix.Size = UDim2.new(1,0,0,18)
Fix.Position = UDim2.new(0,0,1,-18)
Fix.BackgroundColor3 = Color3.fromRGB(24,24,24)
Fix.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = Topbar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,1,0)
Title.Font = Enum.Font.GothamBold
Title.Text = "NEBULA X HUB"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 20

-- MINIMIZE BUTTON

local Minimize = Instance.new("TextButton")
Minimize.Parent = Topbar
Minimize.Size = UDim2.new(0,28,0,28)
Minimize.Position = UDim2.new(1,-38,0.5,-14)
Minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
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
OpenButton.BackgroundColor3 = Color3.fromRGB(18,18,18)
OpenButton.Text = "☰"
OpenButton.TextColor3 = Color3.new(1,1,1)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 24
OpenButton.Visible = false
OpenButton.BorderSizePixel = 0

Instance.new("UICorner",OpenButton).CornerRadius = UDim.new(1,0)

-- SCROLLING FRAME

local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = Main
Scroll.Position = UDim2.new(0,0,0,50)
Scroll.Size = UDim2.new(1,0,1,-50)
Scroll.CanvasSize = UDim2.new(0,0,0,700)
Scroll.ScrollBarThickness = 3
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0,10)

local Padding = Instance.new("UIPadding")
Padding.Parent = Scroll
Padding.PaddingTop = UDim.new(0,12)
Padding.PaddingLeft = UDim.new(0,12)

-- FUNCTION CREATE TOGGLE

local function CreateToggle(text,callback)

	local Frame = Instance.new("Frame")
	Frame.Parent = Scroll
	Frame.Size = UDim2.new(1,-24,0,50)
	Frame.BackgroundColor3 = Color3.fromRGB(26,26,26)
	Frame.BorderSizePixel = 0

	Instance.new("UICorner",Frame).CornerRadius = UDim.new(0,12)

	local Label = Instance.new("TextLabel")
	Label.Parent = Frame
	Label.BackgroundTransparency = 1
	Label.Position = UDim2.new(0,15,0,0)
	Label.Size = UDim2.new(0.6,0,1,0)
	Label.Font = Enum.Font.GothamSemibold
	Label.Text = text
	Label.TextColor3 = Color3.new(1,1,1)
	Label.TextSize = 16
	Label.TextXAlignment = Enum.TextXAlignment.Left

	local Toggle = Instance.new("TextButton")
	Toggle.Parent = Frame
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

-- INFINITE JUMP

local InfiniteJump = false

CreateToggle("Infinite Jump",function(v)
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

-- SPEED

CreateToggle("WalkSpeed 50",function(v)

	local Character = Player.Character
	if Character and Character:FindFirstChildOfClass("Humanoid") then

		if v then
			Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 50
		else
			Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
		end
	end
end)

-- NOCLIP

local Noclip = false

CreateToggle("Noclip",function(v)
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

-- FULLBRIGHT

local OldBrightness = Lighting.Brightness

CreateToggle("FullBright",function(v)

	if v then

		Lighting.Brightness = 5
		Lighting.ClockTime = 12
		Lighting.FogEnd = 100000

	else

		Lighting.Brightness = OldBrightness
	end
end)

-- FLY

local Flying = false
local FlyBV

CreateToggle("Fly",function(v)

	Flying = v

	local Character = Player.Character
	if not Character then return end

	local HRP = Character:FindFirstChild("HumanoidRootPart")

	if v then

		FlyBV = Instance.new("BodyVelocity")
		FlyBV.MaxForce = Vector3.new(9e9,9e9,9e9)
		FlyBV.Velocity = Vector3.new(0,0,0)
		FlyBV.Parent = HRP

	else

		if FlyBV then
			FlyBV:Destroy()
		end
	end
end)

RunService.RenderStepped:Connect(function()

	if Flying and FlyBV and Player.Character then

		local HRP = Player.Character:FindFirstChild("HumanoidRootPart")

		if HRP then

			local Velocity = Vector3.zero

			if UIS:IsKeyDown(Enum.KeyCode.W) then
				Velocity = Velocity + workspace.CurrentCamera.CFrame.LookVector
			end

			if UIS:IsKeyDown(Enum.KeyCode.S) then
				Velocity = Velocity - workspace.CurrentCamera.CFrame.LookVector
			end

			if UIS:IsKeyDown(Enum.KeyCode.A) then
				Velocity = Velocity - workspace.CurrentCamera.CFrame.RightVector
			end

			if UIS:IsKeyDown(Enum.KeyCode.D) then
				Velocity = Velocity + workspace.CurrentCamera.CFrame.RightVector
			end

			FlyBV.Velocity = Velocity * 60
		end
	end
end)

-- ANTI AFK

CreateToggle("Anti AFK",function(v)

	if v then

		local VirtualUser = game:GetService("VirtualUser")

		Player.Idled:Connect(function()

			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	end
end)

-- REJOIN BUTTON

local Rejoin = Instance.new("TextButton")
Rejoin.Parent = Scroll
Rejoin.Size = UDim2.new(1,-24,0,50)
Rejoin.BackgroundColor3 = Color3.fromRGB(35,35,35)
Rejoin.Text = "Rejoin Server"
Rejoin.Font = Enum.Font.GothamBold
Rejoin.TextColor3 = Color3.new(1,1,1)
Rejoin.TextSize = 16
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

-- MAIN DRAG

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

-- OPEN BUTTON DRAG

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
