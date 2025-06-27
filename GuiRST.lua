-- GuiRST.lua (Professional Version) by RestuBoot x ChatGPT
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local cam = workspace.CurrentCamera

player.CharacterAdded:Connect(function(c)
    char = c
end)

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "GuiRST"
gui.ResetOnSpawn = false

local showBtn = Instance.new("TextButton", gui)
showBtn.Size = UDim2.new(0, 100, 0, 30)
showBtn.Position = UDim2.new(0, 10, 0, 10)
showBtn.Text = "📂 Show GUI"
showBtn.Visible = false
showBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
showBtn.TextColor3 = Color3.new(1, 1, 1)
showBtn.TextScaled = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 400)
frame.Position = UDim2.new(0, 10, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "✨ GuiRST Professional"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.TextScaled = true

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.new(1, -20, 0, 30)
hideBtn.Position = UDim2.new(0, 10, 0, 35)
hideBtn.Text = "❌ Hide GUI"
hideBtn.BackgroundColor3 = Color3.fromRGB(120,120,120)
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.TextScaled = true

hideBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	showBtn.Visible = true
end)

showBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	showBtn.Visible = false
end)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -20, 1, -80)
scroll.Position = UDim2.new(0, 10, 0, 70)
scroll.CanvasSize = UDim2.new(0, 0, 0, 700)
scroll.ScrollBarThickness = 6
scroll.BackgroundColor3 = Color3.fromRGB(35,35,35)
scroll.BorderSizePixel = 0

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)

local function makeButton(text, color, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 45)
	container.BackgroundColor3 = Color3.fromRGB(50,50,50)
	container.BackgroundTransparency = 0.2

	local line = Instance.new("Frame", container)
	line.Size = UDim2.new(1, 0, 0, 2)
	line.Position = UDim2.new(0, 0, 1, -2)
	line.BackgroundColor3 = color or Color3.fromRGB(255,255,255)

	local btn = Instance.new("TextButton", container)
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.Text = text
	btn.BackgroundTransparency = 1
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextScaled = true
	btn.Parent = container
	container.Parent = scroll

	btn.MouseButton1Click:Connect(function()
		callback(btn)
	end)
end

-- Infinite Jump
local UIS = game:GetService("UserInputService")
local infJump = false
makeButton("🚀 Infinite Jump: OFF", Color3.fromRGB(100,255,100), function(btn)
	infJump = not infJump
	btn.Text = infJump and "🚀 Infinite Jump: ON" or "🚀 Infinite Jump: OFF"
end)

UIS.JumpRequest:Connect(function()
	if infJump and char:FindFirstChildOfClass("Humanoid") then
		char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- ESP Name Only
local espActive = false
makeButton("👁️ ESP: OFF", Color3.fromRGB(255,255,100), function(btn)
	espActive = not espActive
	btn.Text = espActive and "👁️ ESP: ON" or "👁️ ESP: OFF"

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
			local old = plr.Character.Head:FindFirstChild("GuiRST_ESP")
			if old then old:Destroy() end

			if espActive then
				local tag = Instance.new("BillboardGui", plr.Character.Head)
				tag.Name = "GuiRST_ESP"
				tag.Size = UDim2.new(0,100,0,20)
				tag.AlwaysOnTop = true
				local lbl = Instance.new("TextLabel", tag)
				lbl.Size = UDim2.new(1, 0, 1, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = plr.Name
				lbl.TextColor3 = Color3.new(1,1,1)
				lbl.TextScaled = true
			end
		end
	end
end)

-- Teleport to Player
local inputBox = Instance.new("TextBox", scroll)
inputBox.Size = UDim2.new(1, 0, 0, 40)
inputBox.PlaceholderText = "🧍 Type Player Name"
inputBox.Text = ""
inputBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
inputBox.TextColor3 = Color3.new(1,1,1)
inputBox.TextScaled = true

makeButton("🧍 Teleport to Player", Color3.fromRGB(0,170,255), function()
	local target = Players:FindFirstChild(inputBox.Text)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		char:WaitForChild("HumanoidRootPart").CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
	end
end)

-- Hide Character
local invisible = false
makeButton("👻 Hide Character", Color3.fromRGB(255,80,150), function(btn)
	invisible = not invisible
	btn.Text = invisible and "👻 Show Character" or "👻 Hide Character"
	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") or part:IsA("Decal") then
			part.Transparency = invisible and 1 or 0
		elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
			part.Handle.Transparency = invisible and 1 or 0
		end
	end
end)

-- Fly
local flying = false
makeButton("🛫 Fly: OFF", Color3.fromRGB(180,180,255), function(btn)
	flying = not flying
	btn.Text = flying and "🛫 Fly: ON" or "🛫 Fly: OFF"
end)

local RunService = game:GetService("RunService")
local speed = 50
RunService.RenderStepped:Connect(function()
	if flying and char and char:FindFirstChild("HumanoidRootPart") then
		local root = char.HumanoidRootPart
		if not root:FindFirstChild("BodyGyro") then
			local gyro = Instance.new("BodyGyro", root)
			gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
			gyro.P = 10000
			gyro.CFrame = cam.CFrame

			local bv = Instance.new("BodyVelocity", root)
			bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			bv.Velocity = Vector3.new(0, 0, 0)
		end

		local move = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end

		local bv = root:FindFirstChildOfClass("BodyVelocity")
		if bv then
			bv.Velocity = move.Unit * speed
		end
	else
		if char and char:FindFirstChild("HumanoidRootPart") then
			local root = char.HumanoidRootPart
			if root:FindFirstChild("BodyGyro") then root.BodyGyro:Destroy() end
			if root:FindFirstChild("BodyVelocity") then root.BodyVelocity:Destroy() end
		end
	end
end)