-- PREMIUM HUB V2
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- BLUR EFFECT
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PremiumHubV2"
gui.Parent = player:WaitForChild("PlayerGui")

-- MAIN FRAME
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 330, 0, 230)
main.Position = UDim2.new(0.5, -165, 0.5, -115)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0
main.Parent = gui
main.Active = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

-- TOP BAR
local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,45)
top.BackgroundColor3 = Color3.fromRGB(28,28,28)
top.BorderSizePixel = 0
top.Parent = main
Instance.new("UICorner", top).CornerRadius = UDim.new(0,18)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "Premium Hub V2"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = top

-- CONTENT
local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-45)
content.Position = UDim2.new(0,0,0,45)
content.BackgroundTransparency = 1
content.Parent = main

-- INFINITE JUMP BUTTON
local infJumpBtn = Instance.new("TextButton")
infJumpBtn.Size = UDim2.new(0.85,0,0,55)
infJumpBtn.Position = UDim2.new(0.075,0,0.2,0)
infJumpBtn.Text = "Infinite Jump: OFF"
infJumpBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
infJumpBtn.TextColor3 = Color3.new(1,1,1)
infJumpBtn.Font = Enum.Font.Gotham
infJumpBtn.TextScaled = true
infJumpBtn.Parent = content
Instance.new("UICorner", infJumpBtn).CornerRadius = UDim.new(0,14)

-- FLOATING BUTTON (MINIMIZED)
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0,60,0,60)
floatBtn.Position = UDim2.new(0,20,0.5,-30)
floatBtn.Text = "💎"
floatBtn.TextScaled = true
floatBtn.Visible = false
floatBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
floatBtn.Parent = gui
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1,0)

-- VARIABLES
local infJump = false
local minimized = false

-- INFINITE JUMP
UIS.JumpRequest:Connect(function()
	if infJump then
		local char = player.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

infJumpBtn.MouseButton1Click:Connect(function()
	infJump = not infJump
	if infJump then
		infJumpBtn.Text = "Infinite Jump: ON"
		TweenService:Create(infJumpBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0,170,255)}):Play()
	else
		infJumpBtn.Text = "Infinite Jump: OFF"
		TweenService:Create(infJumpBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
	end
end)

-- DRAG SYSTEM (PC + MOBILE)
local dragging = false
local dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch) then
		update(input)
	end
end)

-- MINIMIZE FUNCTION
local function minimize()
	minimized = true
	TweenService:Create(main, TweenInfo.new(0.4), {Size = UDim2.new(0,0,0,0)}):Play()
	TweenService:Create(blur, TweenInfo.new(0.4), {Size = 0}):Play()
	wait(0.4)
	main.Visible = false
	floatBtn.Visible = true
end

local function maximize()
	minimized = false
	main.Visible = true
	TweenService:Create(main, TweenInfo.new(0.4), {Size = UDim2.new(0,330,0,230)}):Play()
	TweenService:Create(blur, TweenInfo.new(0.4), {Size = 15}):Play()
	floatBtn.Visible = false
end

-- DOUBLE CLICK TOP BAR TO MINIMIZE
top.MouseButton1Click:Connect(function()
	if not minimized then
		minimize()
	end
end)

floatBtn.MouseButton1Click:Connect(function()
	maximize()
end)

-- INITIAL BLUR FADE IN
TweenService:Create(blur, TweenInfo.new(0.4), {Size = 15}):Play()