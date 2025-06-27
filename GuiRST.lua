
-- GuiRST.lua - Versi Universal & Stabil
-- Dibuat oleh ChatGPT & RestuBoot
-- Fitur: Infinite Jump, ESP Nama, Teleport ke Pemain, Sembunyikan Karakter, GUI Mobile Friendly

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local cam = workspace.CurrentCamera

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "GuiRST"
gui.ResetOnSpawn = false

-- Tombol tampilkan GUI
local showBtn = Instance.new("TextButton", gui)
showBtn.Size = UDim2.new(0, 100, 0, 30)
showBtn.Position = UDim2.new(0, 10, 0, 10)
showBtn.Text = "Tampilkan GUI"
showBtn.Visible = false
showBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
showBtn.TextColor3 = Color3.new(1, 1, 1)
showBtn.TextScaled = true

-- Frame utama GUI
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 350)
frame.Position = UDim2.new(0, 10, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "GuiRST Universal"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.TextScaled = true

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.new(1, -20, 0, 30)
hideBtn.Position = UDim2.new(0, 10, 0, 35)
hideBtn.Text = "Sembunyikan GUI"
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

-- Scrollable area
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -20, 1, -80)
scroll.Position = UDim2.new(0, 10, 0, 70)
scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
scroll.ScrollBarThickness = 6
scroll.BackgroundColor3 = Color3.fromRGB(35,35,35)
scroll.BorderSizePixel = 0

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)

-- Fungsi buat tombol keren
local function makeButton(text, color, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 45)
	container.BackgroundColor3 = Color3.fromRGB(50,50,50)

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
makeButton("Infinite Jump: Nonaktif", Color3.fromRGB(100,255,100), function(btn)
	infJump = not infJump
	btn.Text = infJump and "Infinite Jump: Aktif" or "Infinite Jump: Nonaktif"
end)

UIS.JumpRequest:Connect(function()
	if infJump then
		local h = char:FindFirstChildOfClass("Humanoid")
		if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

-- ESP Nama Pemain
local espActive = false
makeButton("ESP: Nonaktif", Color3.fromRGB(255,255,100), function(btn)
	espActive = not espActive
	btn.Text = espActive and "ESP: Aktif" or "ESP: Nonaktif"

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
			local existing = plr.Character.Head:FindFirstChild("GuiRST_ESP")
			if existing then existing:Destroy() end

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

-- Teleport ke pemain (input manual)
local inputBox = Instance.new("TextBox", scroll)
inputBox.Size = UDim2.new(1, 0, 0, 40)
inputBox.PlaceholderText = "Ketik Nama Pemain"
inputBox.Text = ""
inputBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
inputBox.TextColor3 = Color3.new(1,1,1)
inputBox.TextScaled = true

makeButton("Teleport ke Pemain", Color3.fromRGB(0,170,255), function()
	local target = Players:FindFirstChild(inputBox.Text)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
	end
end)

-- Sembunyikan/Munculkan Karakter
local invisible = false
makeButton("Sembunyikan Diriku", Color3.fromRGB(255,80,150), function(btn)
	invisible = not invisible
	btn.Text = invisible and "Munculkan Diriku" or "Sembunyikan Diriku"
	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") or part:IsA("Decal") then
			part.Transparency = invisible and 1 or 0
		elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
			part.Handle.Transparency = invisible and 1 or 0
		end
	end
end)
