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
-- Ana Script
local HeadSize = 18
local IsDisabled = true
local IsTeamCheckEnabled = false 

game:GetService('RunService').RenderStepped:Connect(function()
    if IsDisabled then
        local localPlayer = game:GetService('Players').LocalPlayer
        if not localPlayer then return end
        
        local localPlayerTeam = localPlayer.Team
        
        for _, player in ipairs(game:GetService('Players'):GetPlayers()) do
            if player ~= localPlayer and (not IsTeamCheckEnabled or player.Team ~= localPlayerTeam) then
                local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.Size = Vector3.new(HeadSize, HeadSize, HeadSize)
                    humanoidRootPart.Transparency = 0.7
                    humanoidRootPart.BrickColor = BrickColor.new("Really blue")
                    humanoidRootPart.Material = Enum.Material.Neon
                    humanoidRootPart.CanCollide = false
                end
            end
        end
    end
end)
