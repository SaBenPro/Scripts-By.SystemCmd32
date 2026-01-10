-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- LocalPlayer FIX (executor-safe)
local Player = Players.LocalPlayer
while not Player do
	task.wait()
	Player = Players.LocalPlayer
end

-- PlayerGui FIX
local PlayerGui = Player:FindFirstChildOfClass("PlayerGui")
while not PlayerGui do
	task.wait()
	PlayerGui = Player:FindFirstChildOfClass("PlayerGui")
end

--================= LOGO =================
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

local t = Instance.new("TextLabel")
t.Parent = gui
t.Size = UDim2.fromScale(1,1)
t.BackgroundTransparency = 1
t.Text = "SystemCmd32"
t.Font = Enum.Font.GothamBlack
t.TextSize = 72
t.TextScaled = true
t.TextColor3 = Color3.fromRGB(255,60,60)
t.TextTransparency = 1
t.TextStrokeTransparency = 0.2

TweenService:Create(
	t,
	TweenInfo.new(1),
	{TextTransparency = 0}
):Play()

task.delay(4, function()
	TweenService:Create(
		t,
		TweenInfo.new(1.5),
		{TextTransparency = 1}
	):Play()
	task.delay(1.6, function()
		gui:Destroy()
	end)
end)

--================= HITBOX =================
local HeadSize = 18
local Enabled = true
local TeamCheck = false

RunService.RenderStepped:Connect(function()
	if not Enabled then return end

	local myTeam = Player.Team

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player and (not TeamCheck or plr.Team ~= myTeam) then
			local char = plr.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")

			if hrp then
				hrp.Size = Vector3.new(HeadSize, HeadSize, HeadSize)
				hrp.Transparency = 0.7
				hrp.Material = Enum.Material.Neon
				hrp.BrickColor = BrickColor.new("Really blue")
				hrp.CanCollide = false
			end
		end
	end
end)
