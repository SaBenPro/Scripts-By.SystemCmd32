--==================================================
-- SystemCmd32 | Multi Farm
-- TP BEHIND (ULTIMATE HEIGHT BASED) + SNAP + MICRO TREMOR
--==================================================

--// Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--==================================================
-- STATES
--==================================================
local SCRIPT_RUNNING = true
local farmingType = nil
local lastCFrame = nil

local character, hrp, hum

--==================================================
-- CONSTANTS
--==================================================
local SNAP_DIST = 0.6
local TREMOR_POWER = 0.12
local TREMOR_SPEED = 18

--==================================================
-- CHARACTER
--==================================================
local function onCharacter(char)
	character = char
	hum = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart", 5)

	if farmingType and lastCFrame then
		task.wait(0.1)
		hrp.CFrame = lastCFrame
	end
end

player.CharacterAdded:Connect(onCharacter)
if player.Character then onCharacter(player.Character) end

--==================================================
-- GUI CLEAN
--==================================================
if PlayerGui:FindFirstChild("SystemCmd32_Farm") then
	PlayerGui.SystemCmd32_Farm:Destroy()
end

--==================================================
-- GUI
--==================================================
local gui = Instance.new("ScreenGui")
gui.Name = "SystemCmd32_Farm"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,260,0,170)
frame.Position = UDim2.new(0.05,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,36)
top.BackgroundColor3 = Color3.fromRGB(30,30,30)
top.BorderSizePixel = 0
top.Parent = frame
Instance.new("UICorner", top).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "SystemCmd32"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.Parent = top

--==================================================
-- DRAG
--==================================================
do
	local dragging, dragStart, startPos
	top.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1
		or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = i.Position
			startPos = frame.Position
		end
	end)

	top.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1
		or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if dragging then
			local delta = i.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

--==================================================
-- BUTTONS
--==================================================
local function createButton(text)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,200,0,42)
	b.Position = UDim2.new(0.5,-100,0,60)
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.Text = text.." : OFF"
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	b.Parent = frame
	return b
end

local buttons = {
	createButton("🍎 Apple Farm"),
	createButton("🌟 Golden Apple Farm"),
	createButton("🐥 Chick Farm"),
	createButton("🍊 Orange Farm"),
	createButton("🐂 Bull Farm"),
	createButton("💥 Brr Brr Patapim Farm"),
	createButton("✨ Lirili Larila Farm")
}

local types = {
	"Apple",
	"Golden Apple",
	"Chick",
	"Orange",
	"Bull",
	"Brrr Brr Patapim",
	"Lirili LariIa"
}

--==================================================
-- PAGE SYSTEM + OKLAR (GERİ GELDİ)
--==================================================
local index = 1
local function updateButtons()
	for i,b in ipairs(buttons) do
		b.Visible = (i == index)
	end
end
updateButtons()

local left = Instance.new("TextButton")
left.Size = UDim2.new(0,30,0,30)
left.Position = UDim2.new(0,15,1,-40)
left.Text = "<"
left.Font = Enum.Font.GothamBold
left.TextSize = 18
left.BackgroundColor3 = Color3.fromRGB(35,35,35)
left.TextColor3 = Color3.new(1,1,1)
left.BorderSizePixel = 0
left.Parent = frame
Instance.new("UICorner", left).CornerRadius = UDim.new(0,8)

local right = left:Clone()
right.Text = ">"
right.Position = UDim2.new(1,-45,1,-40)
right.Parent = frame

left.MouseButton1Click:Connect(function()
	index = math.max(1, index - 1)
	updateButtons()
end)

right.MouseButton1Click:Connect(function()
	index = math.min(#buttons, index + 1)
	updateButtons()
end)

--==================================================
-- STOP ALL
--==================================================
local function stopAll()
	farmingType = nil
	for _,b in ipairs(buttons) do
		b.Text = b.Text:match("(.+) :").." : OFF"
		b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	end
end

for i,b in ipairs(buttons) do
	b.MouseButton1Click:Connect(function()
		if farmingType == types[i] then
			stopAll()
		else
			stopAll()
			farmingType = types[i]
			b.Text = b.Text:match("(.+) :").." : ON"
			b.BackgroundColor3 = Color3.fromRGB(70,130,70)
		end
	end)
end

--==================================================
-- TARGET
--==================================================
local function getTarget()
	local folder = workspace:FindFirstChild("FirstWorldEnemies")
	if not folder then return end
	for _,v in ipairs(folder:GetChildren()) do
		if v:IsA("Model") and v.Name == farmingType then
			return v
		end
	end
end

--==================================================
-- 🔥 ULTIMATE TP BEHIND
--==================================================
local function tpBehindTarget(targetModel)
	if not targetModel or not hrp or not character then return end

	local tr = targetModel:FindFirstChild("HumanoidRootPart")
	if not tr then return end

	local _, charSize = character:GetBoundingBox()
	local charHeight = charSize.Y
	local targetHeight = tr.Size.Y

	local backDistance = math.clamp((charHeight * 0.55) + (targetHeight * 0.35), 2.5, 8)
	local yOffset = math.clamp(charHeight * 0.5, 1.5, 6)

	local backPos =
		tr.Position
		- tr.CFrame.LookVector * backDistance
		+ Vector3.new(0, yOffset, 0)

	hrp.CFrame = CFrame.new(backPos, tr.Position)
	lastCFrame = hrp.CFrame
end

--==================================================
-- FARM CORE
--==================================================
task.spawn(function()
	while SCRIPT_RUNNING do
		if farmingType and hrp then
			local model = getTarget()
			if model then
				tpBehindTarget(model)
				while farmingType and model.Parent do
					task.wait(0.15)
				end
			end
		end
		task.wait(0.1)
	end
end)

--==================================================
-- NOCLIP + SNAP + TREMOR
--==================================================
RunService.Heartbeat:Connect(function()
	if not farmingType or not hrp or not lastCFrame then return end

	for _,v in ipairs(character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end

	if (hrp.Position - lastCFrame.Position).Magnitude > SNAP_DIST then
		hrp.CFrame = lastCFrame
	end

	local t = tick()
	hrp.CFrame = lastCFrame * CFrame.new(
		math.sin(t * TREMOR_SPEED) * TREMOR_POWER,
		0,
		math.cos(t * TREMOR_SPEED) * TREMOR_POWER
	)
end)

--==================================================
-- EMERGENCY STOP (T)
--==================================================
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.T then
		SCRIPT_RUNNING = false
		gui:Destroy()
	end
end)
