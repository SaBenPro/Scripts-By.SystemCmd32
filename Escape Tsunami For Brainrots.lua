--// SystemCmd32 | FINAL YT RELEASE

--================ SERVICES =================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--================ SAFE GUARD =================
if PlayerGui:FindFirstChild("SystemCmd32_GUI") then
	return
end

--================ INTRO SPLASH =================
local splashGui = Instance.new("ScreenGui")
splashGui.Name = "SystemCmd32_Splash"
splashGui.ResetOnSpawn = false
splashGui.IgnoreGuiInset = true
splashGui.Parent = PlayerGui

local title = Instance.new("TextLabel")
title.Parent = splashGui
title.Size = UDim2.fromScale(1,1)
title.BackgroundTransparency = 1
title.Text = "SystemCmd32"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(170,120,255)
title.TextTransparency = 1
title.TextStrokeTransparency = 0.25

TweenService:Create(
	title,
	TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	{TextTransparency = 0}
):Play()

task.wait(3.5)

TweenService:Create(
	title,
	TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
	{TextTransparency = 1}
):Play()

task.wait(1.3)
splashGui:Destroy()

--================ MAIN GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "SystemCmd32_GUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,190)
frame.Position = UDim2.new(0.5,-130,0.5,-95)
frame.BackgroundColor3 = Color3.fromRGB(18,18,22)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(150,90,255)
stroke.Thickness = 1.5
stroke.Transparency = 0.35

local grad = Instance.new("UIGradient", frame)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,45)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,15))
}
grad.Rotation = 90

local header = Instance.new("TextLabel", frame)
header.Size = UDim2.new(1,0,0,38)
header.BackgroundTransparency = 1
header.Text = "SystemCmd32"
header.Font = Enum.Font.GothamBlack
header.TextSize = 22
header.TextColor3 = Color3.fromRGB(180,130,255)

--================ BUTTON MAKER =================
local function makeButton(txt, y, col)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0,210,0,42)
	b.Position = UDim2.new(0.5,-105,0,y)
	b.Text = txt
	b.Font = Enum.Font.GothamBold
	b.TextSize = 15
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = col
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)

	b.MouseEnter:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.15),{
			Size = UDim2.new(0,220,0,45)
		}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.15),{
			Size = UDim2.new(0,210,0,42)
		}):Play()
	end)

	return b
end

local btnErase = makeButton("Erase Tsunamis",55,Color3.fromRGB(200,60,60))
local btnSteal = makeButton("Steal Brainrot",110,Color3.fromRGB(150,80,255))

--================ ERASE TSUNAMI =================
local eraseOn=false
local eraseConn

local function clearTsunamis()
	local f=workspace:FindFirstChild("ActiveTsunamis")
	if not f then return end
	for _,v in ipairs(f:GetChildren()) do v:Destroy() end
end

btnErase.MouseButton1Click:Connect(function()
	eraseOn=not eraseOn
	if eraseOn then
		btnErase.BackgroundColor3=Color3.fromRGB(60,200,100)
		clearTsunamis()
		local f=workspace:FindFirstChild("ActiveTsunamis")
		if f then
			eraseConn=f.ChildAdded:Connect(function(o)
				task.wait()
				if eraseOn and o then o:Destroy() end
			end)
		end
	else
		btnErase.BackgroundColor3=Color3.fromRGB(200,60,60)
		if eraseConn then eraseConn:Disconnect() eraseConn=nil end
	end
end)

--================ UTILS =================
local function parseRate(t)
	if type(t)~="string" then return 0 end
	t=t:lower():gsub("[^%d%.km]","")
	local n,s=t:match("([%d%.]+)([km]?)")
	n=tonumber(n)
	if not n then return 0 end
	if s=="k" then return n*1000 end
	if s=="m" then return n*1000000 end
	return n
end

local BUSY=false

--================ STEAL =================
btnSteal.MouseButton1Click:Connect(function()
	if BUSY then return end
	BUSY=true

	local char=player.Character or player.CharacterAdded:Wait()
	local hrp=char:WaitForChild("HumanoidRootPart")

	local spawn=workspace:FindFirstChild("SpawnLocation1")
	local back=spawn and (spawn.CFrame+Vector3.new(0,3,0)) or hrp.CFrame

	hrp.CFrame=CFrame.new(2613.78,-2.79,-7.69)
	task.wait(0.65)
	for i=1,3 do RunService.Heartbeat:Wait() end

	local best,bestRate=nil,0
	local secret=workspace:FindFirstChild("ActiveBrainrots")
		and workspace.ActiveBrainrots:FindFirstChild("Secret")

	if secret then
		for _,m in ipairs(secret:GetChildren()) do
			local h=m:FindFirstChild("Handle")
			local r=h and h:FindFirstChild("StatsGui")
				and h.StatsGui:FindFirstChild("Frame")
				and h.StatsGui.Frame:FindFirstChild("Rate")
			if r then
				local v=parseRate(r.Text)
				if v>bestRate then bestRate=v best=m end
			end
		end
	end

	if best and best:FindFirstChild("Handle") then
		local h=best.Handle
		hrp.CFrame=h.CFrame*CFrame.new(0,0,-2)
		task.wait(0.25)

		local p=h:FindFirstChildWhichIsA("ProximityPrompt",true)
		if p then
			p.HoldDuration=0
			for i=1,3 do
				fireproximityprompt(p)
				task.wait(0.08)
			end
		end
	end

	task.wait(0.35)
	hrp.CFrame=back
	BUSY=false
end)

--================ FULL KILL =================
UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode==Enum.KeyCode.T then
		if eraseConn then eraseConn:Disconnect() end
		gui:Destroy()
	end
end)
