-- SCRİPTİN ÇALIŞMASI İÇİN ELİNİZE "ICE" KAZMASINI ALIN, DİĞER KAZMALARLA UYUMLU DEĞİLDİR!
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

--==================================================
--====================== GUI =======================
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LuckyMegaUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.fromScale(0.35,0.4)
Frame.Position = UDim2.fromScale(0.33,0.3)
Frame.BackgroundColor3 = Color3.fromRGB(15,15,20)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,18)

local Stroke = Instance.new("UIStroke", Frame)
Stroke.Color = Color3.fromRGB(0,170,255)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.fromScale(1,0.18)
Title.BackgroundTransparency = 1
Title.Text = "LUCKY CONTROL"
Title.TextColor3 = Color3.fromRGB(0,200,255)
Title.Font = Enum.Font.GothamBlack
Title.TextScaled = true

local Close = Instance.new("TextButton", Frame)
Close.Size = UDim2.fromScale(0.1,0.18)
Close.Position = UDim2.fromScale(0.9,0)
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(255,80,80)
Close.Font = Enum.Font.GothamBlack
Close.TextScaled = true
Close.BackgroundTransparency = 1

local function makeBtn(text,y,color)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromScale(0.8,0.18)
	b.Position = UDim2.fromScale(0.1,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = color
	b.Parent = Frame
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
	return b
end

local RareBtn   = makeBtn("RARE",0.28,Color3.fromRGB(0,170,255))
local SecretBtn = makeBtn("SECRET",0.50,Color3.fromRGB(170,0,255))
local MythicBtn = makeBtn("MYTHIC",0.72,Color3.fromRGB(255,170,0))

--==================================================
--===================== CORE =======================
--==================================================

local function farmBlock(blockName)
	local char = Player.Character or Player.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")

	local oldCF = hrp.CFrame

	-- ICE GARANTİ
	local tool = Player.Backpack:FindFirstChild("Ice") or char:FindFirstChild("Ice")
	if tool and tool.Parent ~= char then
		hum:EquipTool(tool)
		repeat task.wait() until tool.Parent == char
	end

	-- BLOCK BUL
	local folder = workspace:FindFirstChild("LuckyBlocks")
	if not folder then return end

	local blocks = {}
	for _,m in ipairs(folder:GetDescendants()) do
		if m:IsA("Model") and m.Name == blockName and m.PrimaryPart then
			table.insert(blocks,m)
		end
	end
	if #blocks == 0 then return end

	local block = blocks[math.random(#blocks)]
	local lockCF = block.PrimaryPart.CFrame + Vector3.new(0,5,0)
	local lockPos = lockCF.Position -- 🔒 HAFIZAYA ALINAN KONUM

	hrp.CFrame = lockCF

	local phase = "BREAK" -- BREAK / AFTER / FREE

	-- FLING + YATAY KİLİT (KIRILSA BİLE DEVAM)
	local lockConn
	lockConn = RunService.Heartbeat:Connect(function()
		if phase == "FREE" then return end

		local pos = hrp.Position
		local horizDist = Vector3.new(pos.X,0,pos.Z) - Vector3.new(lockPos.X,0,lockPos.Z)

		if horizDist.Magnitude > 3 then
			hrp.AssemblyLinearVelocity = Vector3.zero
			hrp.Velocity = Vector3.zero

			if phase == "BREAK" then
				-- TAM KİLİT
				hrp.CFrame = CFrame.new(lockPos)
			elseif phase == "AFTER" then
				-- SADECE X-Z (Y SERBEST)
				hrp.CFrame = CFrame.new(lockPos.X, pos.Y, lockPos.Z)
			end
		end
	end)

	-- AUTO HIT
	local hitConn = RunService.Heartbeat:Connect(function()
		if block.Parent and tool and tool.Parent == char then
			tool:Activate()
		end
	end)

	-- BLOCK KIRILANA KADAR
	repeat task.wait(0.1) until not block.Parent

	if hitConn then hitConn:Disconnect() end

	-- 🔒 BLOCK GİTTİ AMA KONUM HÂLÂ KİLİTLİ
	phase = "AFTER"

	-- PROMPT %100 GELENE KADAR BEKLE
	task.wait(2)

	local prompt
	for i = 1,50 do
		for _,pp in ipairs(workspace:GetDescendants()) do
			if pp:IsA("ProximityPrompt") and pp.Enabled then
				if (pp.Parent.Position - hrp.Position).Magnitude < 15 then
					prompt = pp
					break
				end
			end
		end
		if prompt then break end
		task.wait(0.1)
	end

	-- ❗ PROMPT YAPILMADAN SERBEST YOK
	if prompt then
		prompt:InputHoldBegin()
		task.wait(0.5)
		prompt:InputHoldEnd()
		task.wait(0.3)

		-- ARTIK SERBEST
		phase = "FREE"
		if lockConn then lockConn:Disconnect() end
		hrp.CFrame = oldCF
	end
end

--==================================================
--================== BUTTONS =======================
--==================================================

RareBtn.MouseButton1Click:Connect(function()
	farmBlock("Epic Block")
end)

SecretBtn.MouseButton1Click:Connect(function()
	farmBlock("Secret Block")
end)

MythicBtn.MouseButton1Click:Connect(function()
	farmBlock("Mythic Block")
end)

Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
	script:Destroy()
end)
