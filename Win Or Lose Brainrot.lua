-- Oyuna başlar başlamaz çalıştır
-- T = script kapat
-- E = temizle
-- Q + Sol Tık = manuel işaret

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

--================ GUI =================
do
	local gui = Instance.new("ScreenGui")
	gui.ResetOnSpawn = false
	gui.Parent = Player:WaitForChild("PlayerGui")

	local t = Instance.new("TextLabel")
	t.Parent = gui
	t.Size = UDim2.fromScale(1,1)
	t.BackgroundTransparency = 1
	t.Text = "SystemCmd32"
	t.Font = Enum.Font.GothamBlack
	t.TextSize = 72
	t.TextColor3 = Color3.fromRGB(255,60,60)
	t.TextTransparency = 1

	TweenService:Create(t,TweenInfo.new(1),{TextTransparency=0}):Play()
	task.delay(4,function()
		TweenService:Create(t,TweenInfo.new(1.5),{TextTransparency=1}):Play()
		task.delay(1.6,function() gui:Destroy() end)
	end)
end

--================ CORE =================
local scriptEnabled = true
local markedObjects = {}
local observedCards = {}
local NORMAL_IMAGE = nil

--================ UTILS =================
local function isRed(c)
	return c.R > 0.6 and c.G < 0.4 and c.B < 0.4
end

local function markObject(o)
	if not scriptEnabled or markedObjects[o] then return end

	local h = Instance.new("Highlight")
	h.FillColor = Color3.fromRGB(255,0,0)
	h.OutlineColor = Color3.fromRGB(255,255,255)
	h.FillTransparency = 0.35
	h.Adornee = o
	h.Parent = o

	markedObjects[o] = h
end

local function clearAll()
	for _,h in pairs(markedObjects) do
		if h then h:Destroy() end
	end
	table.clear(markedObjects)
end

--================ INPUT =================
Mouse.Button1Down:Connect(function()
	if scriptEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Q) then
		local t = Mouse.Target
		if t then
			markObject(t:FindFirstAncestorOfClass("Model") or t)
		end
	end
end)

UserInputService.InputBegan:Connect(function(i,g)
	if g or not scriptEnabled then return end

	if i.KeyCode == Enum.KeyCode.E then
		clearAll()
	elseif i.KeyCode == Enum.KeyCode.T then
		clearAll()
		scriptEnabled = false
	end
end)

--================ CARD WATCH =================
local function watchCard(m)
	if observedCards[m] then return end
	observedCards[m] = true

	task.spawn(function()
		local r = m:WaitForChild("RootPart",5)
		if not r then return end

		local g = r:FindFirstChildWhichIsA("SurfaceGui",true)
		if not g then return end

		local i = g:FindFirstChild("CardImage",true)
		if not i or not i:IsA("ImageLabel") then return end

		if not NORMAL_IMAGE then
			NORMAL_IMAGE = i.Image
		end

		i:GetPropertyChangedSignal("Image"):Connect(function()
			if scriptEnabled and i.Image ~= "" and i.Image ~= NORMAL_IMAGE then
				markObject(m)
			end
		end)

		i:GetPropertyChangedSignal("ImageColor3"):Connect(function()
			if scriptEnabled and isRed(i.ImageColor3) then
				markObject(m)
			end
		end)
	end)
end

--================ OPTİMİZE SCAN =================
local SCAN_DELAY = 0.8 -- 🔥 eskisi 0.4 → yarı yük

task.spawn(function()
	while scriptEnabled do
		for _,v in ipairs(workspace:GetDescendants()) do
			if v:IsA("Model") and v.Name == "CardModel" then
				if not observedCards[v] then
					watchCard(v)
				end
			end
		end
		task.wait(SCAN_DELAY)
	end
end)
