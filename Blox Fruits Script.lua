--// SystemCmd32 | Bandit Farm | MOBILE + CHAT DELETE FINAL

--================ SERVICES =================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--================ CLEAN =================
if PlayerGui:FindFirstChild("SystemCmd32_GUI") then
	PlayerGui.SystemCmd32_GUI:Destroy()
end

--================ STATE =================
local FARMING = false
local ACTIVE = false
local DESTROYED = false

--================ CHAR =================
local function getChar()
	local c = player.Character or player.CharacterAdded:Wait()
	return c, c:WaitForChild("Humanoid"), c:WaitForChild("HumanoidRootPart")
end

--================ FULL RESET =================
local function fullDestroy()
	if DESTROYED then return end
	DESTROYED = true
	FARMING = false

	local char, hum, hrp = getChar()
	for _,v in ipairs(hrp:GetChildren()) do
		if v:IsA("BodyMover") then
			v:Destroy()
		end
	end

	hum.AutoRotate = true
	hum:ChangeState(Enum.HumanoidStateType.GettingUp)

	if PlayerGui:FindFirstChild("SystemCmd32_GUI") then
		PlayerGui.SystemCmd32_GUI:Destroy()
	end
end

--================ SAFE FLY =================
local function flyTo(cf)
	if not FARMING then return end
	local _, hum, hrp = getChar()

	hum.AutoRotate = false
	hum:ChangeState(Enum.HumanoidStateType.Physics)

	local bp = Instance.new("BodyPosition", hrp)
	bp.MaxForce = Vector3.new(1e9,1e9,1e9)
	bp.P = 90000
	bp.D = 2500

	local bg = Instance.new("BodyGyro", hrp)
	bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
	bg.P = 90000

	while FARMING and (hrp.Position - cf.Position).Magnitude > 1 do
		bp.Position = cf.Position
		bg.CFrame = CFrame.new(hrp.Position, cf.Position)
		task.wait(0.01)
	end

	bp:Destroy()
	bg:Destroy()
end

--================ COMBAT =================
local function equipCombat()
	local char, hum = getChar()
	local tool = player.Backpack:FindFirstChild("Combat") or char:FindFirstChild("Combat")
	if tool then hum:EquipTool(tool) end
end

local function clickFast()
	VIM:SendMouseButtonEvent(0,0,0,true,game,0)
	VIM:SendMouseButtonEvent(0,0,0,false,game,0)
end

--================ LIVE NPC =================
local function getAliveNPC()
	for _,npc in ipairs(workspace:WaitForChild("Enemies"):GetChildren()) do
		local hum = npc:FindFirstChildWhichIsA("Humanoid")
		local hrp = npc:FindFirstChild("HumanoidRootPart")
		if hum and hrp and hum.Health > 0 then
			return npc, hum, hrp
		end
	end
	return nil
end

--================ FARM =================
local function startFarm()
	if ACTIVE then return end
	ACTIVE = true

	local _,_,hrp = getChar()

	flyTo(hrp.CFrame + Vector3.new(0,25,0))
	flyTo(workspace.Map.Windmill:GetPivot())

	while FARMING do
		local npc, nh, nhrp = getAliveNPC()
		if not npc then task.wait(0.05) continue end

		nhrp.Anchored = true
		flyTo(nhrp.CFrame * CFrame.new(0,4,0))
		equipCombat()

		while FARMING do
			if not npc.Parent or nh.Health <= 0 then break end

			hrp.CFrame = CFrame.new(
				nhrp.Position + Vector3.new(0,4,0),
				nhrp.Position
			)

			clickFast()
			task.wait(0.05)
		end

		if nhrp and nhrp.Parent then
			nhrp.Anchored = false
		end
	end

	ACTIVE = false
end

--================ GUI =================
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "SystemCmd32_GUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.24,0.22)
frame.Position = UDim2.fromScale(0.38,0.35)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

local bar = Instance.new("Frame", frame)
bar.Size = UDim2.fromScale(1,0.25)
bar.BackgroundColor3 = Color3.fromRGB(5,5,5)
bar.BorderSizePixel = 0
Instance.new("UICorner", bar).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", bar)
title.Size = UDim2.fromScale(1,1)
title.BackgroundTransparency = 1
title.Text = "SystemCmd32"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.fromScale(0.9,0.35)
btn.Position = UDim2.fromScale(0.05,0.45)
btn.Text = "1. NPC: Bandit Farm"
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
btn.TextColor3 = Color3.new(1,1,1)
btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

--================ DRAG (MOUSE + TOUCH) =================
do
	local drag, startPos, startFrame
	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = true
			startPos = i.Position
			startFrame = frame.Position
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - startPos
			frame.Position = UDim2.fromScale(
				startFrame.X.Scale + d.X / workspace.CurrentCamera.ViewportSize.X,
				startFrame.Y.Scale + d.Y / workspace.CurrentCamera.ViewportSize.Y
			)
		end
	end)

	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = false
		end
	end)
end

--================ BUTTON =================
btn.MouseButton1Click:Connect(function()
	FARMING = not FARMING
	btn.Text = FARMING and "DURDUR" or "1. NPC: Bandit Farm"
	if FARMING then
		task.spawn(startFarm)
	end
end)

--================ EMERGENCY KEY =================
UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.T then
		fullDestroy()
	end
end)

--================ CHAT DELETE =================
player.Chatted:Connect(function(msg)
	if string.lower(msg) == "delete" then
		fullDestroy()
	end
end)
