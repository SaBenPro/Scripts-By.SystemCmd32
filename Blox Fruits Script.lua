--==================================================
-- SystemCmd32 | Apple / Golden Apple / Chick Farm
-- FINAL MEGA FIX + MICRO HIT TREMOR
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

local character, hrp

--==================================================
-- CONSTANTS
--==================================================
local Y_OFFSET = 1
local BACK_OFFSET = 2.0
local STOP_UP_OFFSET = 8
local SNAP_DIST = 0.6

-- MICRO TREMOR
local TREMOR_POWER = 0.12
local TREMOR_SPEED = 18

--==================================================
-- CHARACTER
--==================================================
local function onCharacter(char)
	character = char
	hrp = char:WaitForChild("HumanoidRootPart", 5)

	if farmingType and lastCFrame then
		task.wait(0.15)
		hrp.CFrame = lastCFrame
	end
end

player.CharacterAdded:Connect(onCharacter)
if player.Character then
	onCharacter(player.Character)
end

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

-- TOP BAR
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
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
		or i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

--==================================================
-- BUTTON TEMPLATE
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

local btnApple  = createButton("🍎 Apple Farm")
local btnGolden = createButton("🌟 Golden Apple Farm")
local btnChick  = createButton("🐥 Chick Farm")

btnGolden.Visible = false
btnChick.Visible = false

local buttons = {btnApple, btnGolden, btnChick}
local types = {"Apple", "Golden Apple", "Chick"}
local index = 1

local function updateButtons()
	for i,b in ipairs(buttons) do
		b.Visible = (i == index)
	end
end
updateButtons()

-- ARROWS
local left = Instance.new("TextButton")
left.Size = UDim2.new(0,30,0,30)
left.Position = UDim2.new(0,20,1,-40)
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
right.Position = UDim2.new(1,-50,1,-40)
right.Parent = frame

left.MouseButton1Click:Connect(function()
	index = math.max(1, index-1)
	updateButtons()
end)

right.MouseButton1Click:Connect(function()
	index = math.min(#buttons, index+1)
	updateButtons()
end)

--==================================================
-- STOP ALL (ANTI FALL)
--==================================================
local function stopAll()
	farmingType = nil

	if character then
		for _,v in ipairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
	end

	if hrp then
		local origin = hrp.Position + Vector3.new(0, STOP_UP_OFFSET, 0)
		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {character}
		rayParams.FilterType = Enum.RaycastFilterType.Blacklist

		local ray = Workspace:Raycast(origin, Vector3.new(0,-50,0), rayParams)
		if ray then
			hrp.CFrame = CFrame.new(ray.Position + Vector3.new(0,3,0))
		else
			hrp.CFrame = hrp.CFrame + Vector3.new(0, STOP_UP_OFFSET, 0)
		end
	end

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
	if not folder then return nil end

	local list = {}
	for _,v in ipairs(folder:GetChildren()) do
		if v:IsA("Model") and v.Name == farmingType then
			table.insert(list, v)
		end
	end

	if #list == 0 then return nil end
	return list[math.random(#list)]
end

--==================================================
-- FARM CORE
--==================================================
task.spawn(function()
	while SCRIPT_RUNNING do
		if farmingType and hrp then
			local model = getTarget()
			if model then
				local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
				if part then
					lastCFrame = part.CFrame * CFrame.new(0, Y_OFFSET, BACK_OFFSET)
					hrp.CFrame = lastCFrame
				end
				while farmingType and model.Parent do
					task.wait(0.15)
				end
			end
		end
		task.wait(0.1)
	end
end)

--==================================================
-- NOCLIP + SNAP + MICRO TREMOR
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

	-- MICRO HIT TREMOR (vurmayı garanti eder)
	local t = tick()
	local tremorX = math.sin(t * TREMOR_SPEED) * TREMOR_POWER
	local tremorZ = math.cos(t * TREMOR_SPEED) * TREMOR_POWER
	hrp.CFrame = lastCFrame * CFrame.new(tremorX, 0, tremorZ)
end)

--==================================================
-- EMERGENCY STOP (T)
--==================================================
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.T then
		SCRIPT_RUNNING = false
		farmingType = nil
		gui:Destroy()
	end
end)
