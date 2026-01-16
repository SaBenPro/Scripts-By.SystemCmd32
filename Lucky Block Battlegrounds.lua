-- // ESKİ SCRİPTİ TEMİZLE
local oldGui = game.CoreGui:FindFirstChild("SystemCmd32_Ultra")
if oldGui then oldGui:Destroy() end

-- // ANA AYARLAR
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SystemCmd32_Ultra"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- // ANA ÇERÇEVE
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 380)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(0, 255, 150)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- // BAŞLIK BARI
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner", TitleBar)
TitleCorner.CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "SYSTEM_CMD32 // v2.0"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
TitleLabel.Font = Enum.Font.Code
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- // KAPATMA BUTONU
local ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(0, 24, 0, 24)
ExitBtn.Position = UDim2.new(1, -30, 0.5, -12)
ExitBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ExitBtn.Text = "×"
ExitBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
ExitBtn.TextSize = 20
ExitBtn.Font = Enum.Font.SourceSansBold
ExitBtn.Parent = TitleBar

local ExitCorner = Instance.new("UICorner", ExitBtn)
ExitCorner.CornerRadius = UDim.new(1, 0)
ExitBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- // BUTON LİSTESİ
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 2
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 450)
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout", ContentFrame)
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- // BUTON OLUŞTURUCU
local function CreateBtn(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Text = " " .. text
    btn.Size = UDim2.new(1, -5, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Font = Enum.Font.Code
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = ContentFrame

    local BtnCorner = Instance.new("UICorner", btn)
    BtnCorner.CornerRadius = UDim.new(0, 6)

    local BtnStroke = Instance.new("UIStroke", btn)
    BtnStroke.Thickness = 1
    BtnStroke.Color = color
    BtnStroke.Transparency = 0.5

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        BtnStroke.Transparency = 0
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        BtnStroke.Transparency = 0.5
    end)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- // AKSİYONLAR
CreateBtn("SPAWN LUCKY BLOCK", Color3.fromRGB(200, 200, 200), function() game.ReplicatedStorage.SpawnLuckyBlock:FireServer() end)
CreateBtn("SPAWN SUPER BLOCK", Color3.fromRGB(255, 255, 100), function() game.ReplicatedStorage.SpawnSuperBlock:FireServer() end)
CreateBtn("SPAWN DIAMOND BLOCK", Color3.fromRGB(0, 200, 255), function() game.ReplicatedStorage.SpawnDiamondBlock:FireServer() end)
CreateBtn("SPAWN RAINBOW BLOCK", Color3.fromRGB(255, 0, 255), function() game.ReplicatedStorage.SpawnRainbowBlock:FireServer() end)
CreateBtn("SPAWN GALAXY BLOCK", Color3.fromRGB(100, 0, 255), function() game.ReplicatedStorage.SpawnGalaxyBlock:FireServer() end)

--- // FLY SYSTEM V3 // ---
local FlyEnabled = false
local FlySpeed = 60
local UserInputService = game:GetService("UserInputService")
local FlyBtn = CreateBtn("FLY SYSTEM V3: [OFF]", Color3.fromRGB(255, 50, 50), function() end)

FlyBtn.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    local lp = game.Players.LocalPlayer
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if FlyEnabled then
        FlyBtn.Text = " FLY SYSTEM V3: [ON]"
        FlyBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
        FlyBtn.UIStroke.Color = Color3.fromRGB(0, 255, 150)
        
        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.Name = "FlyVelocity"
        bodyVel.Velocity = Vector3.new(0, 0, 0)
        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel.Parent = hrp
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Name = "FlyGyro"
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.CFrame = hrp.CFrame
        bodyGyro.Parent = hrp
        
        char.Humanoid.PlatformStand = true
    else
        FlyBtn.Text = " FLY SYSTEM V3: [OFF]"
        FlyBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        FlyBtn.UIStroke.Color = Color3.fromRGB(255, 50, 50)
        
        if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
        if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
        char.Humanoid.PlatformStand = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if FlyEnabled then
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local camera = workspace.CurrentCamera
        
        if hrp and hrp:FindFirstChild("FlyVelocity") then
            local moveDir = Vector3.new(0,0,0)
            
            -- Kamera yönüne göre hareket (WASD)
            local look = camera.CFrame.LookVector
            local right = camera.CFrame.RightVector
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + look end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - look end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - right end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + right end
            
            -- E ve Q Yükseklik Ayarı
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            hrp.FlyVelocity.Velocity = moveDir.Unit * FlySpeed
            if moveDir.Magnitude == 0 then hrp.FlyVelocity.Velocity = Vector3.new(0,0,0) end
            hrp.FlyGyro.CFrame = camera.CFrame
        end
    end
end)

-- // SINIRSIZ CAN SİSTEMİ
local GodModeActive = false
local GodModeConnection = nil

-- God Mode butonu oluştur
local GodModeBtn = CreateBtn("GOD MODE: [OFF]", Color3.fromRGB(255, 50, 50), function() end)

GodModeBtn.MouseButton1Click:Connect(function()
    GodModeActive = not GodModeActive
    
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if GodModeActive then
        GodModeBtn.Text = " GOD MODE: [ON]"
        GodModeBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
        GodModeBtn.UIStroke.Color = Color3.fromRGB(0, 255, 150)
        
        -- Canı sürekli full tut
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            
            -- Her frame canı kontrol et
            GodModeConnection = game:GetService('RunService').RenderStepped:Connect(function()
                if humanoid and humanoid.Health < math.huge then
                    humanoid.Health = math.huge
                end
            end)
        end
        
        print("[GOD MODE] Sınırsız can AÇIK!")
    else
        GodModeBtn.Text = " GOD MODE: [OFF]"
        GodModeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        GodModeBtn.UIStroke.Color = Color3.fromRGB(255, 50, 50)
        
        -- God mode'u kapat
        if GodModeConnection then
            GodModeConnection:Disconnect()
            GodModeConnection = nil
        end
        
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
        
        print("[GOD MODE] Sınırsız can KAPALI!")
    end
end)

-- Karakter yeniden spawn olursa god mode'u tekrar aktif et
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    if GodModeActive then
        wait(0.5) -- Humanoid yüklenmesini bekle
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            print("[GOD MODE] Karakter yenilendi, sınırsız can yeniden aktif!")
        end
    end
end)

print("[SYSTEM_CMD32] Script yüklendi!")
