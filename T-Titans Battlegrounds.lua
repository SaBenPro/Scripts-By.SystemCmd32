-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

--================= LOGO =================
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
t.TextStrokeTransparency = 0.2
t.TextScaled = true

TweenService:Create(
	t,
	TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
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

--================= HITBOX SCRIPT =================
local HeadSize = 18
local Enabled = true
local TeamCheck = false

RunService.RenderStepped:Connect(function()
	if not Enabled then return end

	local localTeam = Player.Team

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player and (not TeamCheck or plr.Team ~= localTeam) then
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
