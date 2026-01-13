-- // ESKİ SCRİPTİ TEMİZLE
local oldGui = game.CoreGui:FindFirstChild("SystemCmd32_Ultra")
if oldGui then oldGui:Destroy() end

-- // ANA AYARLAR
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SystemCmd32_Ultra"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- // ANA ÇERÇEVE (GLASSMORPHISM STYLE)
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

-- // BAŞLIK BARINI OLUŞTUR
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

-- // BUTON LİSTESİ (KAYDIRILABİLİR)
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 2
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 350)
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout", ContentFrame)
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- // BUTON OLUŞTURUCU FONKSİYON
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

    -- Hover Efektleri
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

-- // HITBOX SİSTEMİ
local HitboxEnabled = false
local HeadSize = 20

local HitboxBtn = CreateBtn("HITBOX SYSTEM: [OFF]", Color3.fromRGB(255, 50, 50), function() end)

HitboxBtn.MouseButton1Click:Connect(function()
    HitboxEnabled = not HitboxEnabled
    if HitboxEnabled then
        HitboxBtn.Text = " HITBOX SYSTEM: [ON]"
        HitboxBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
        HitboxBtn.UIStroke.Color = Color3.fromRGB(0, 255, 150)
    else
        HitboxBtn.Text = " HITBOX SYSTEM: [OFF]"
        HitboxBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        HitboxBtn.UIStroke.Color = Color3.fromRGB(255, 50, 50)
    end
end)

game:GetService('RunService').RenderStepped:Connect(function()
    local localPlayer = game:GetService('Players').LocalPlayer
    for _, player in ipairs(game:GetService('Players'):GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if HitboxEnabled then
                    hrp.Size = Vector3.new(HeadSize, HeadSize, HeadSize)
                    hrp.Transparency = 0.7
                    hrp.BrickColor = BrickColor.new("Really blue")
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                else
                    -- Kapatınca orijinal boyuta döner
                    if hrp.Size ~= Vector3.new(2, 2, 1) then
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.CanCollide = true
                    end
                end
            end
        end
    end
end)
