-- Servicios principales
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Limpieza segura de interfaces anteriores
if playerGui:FindFirstChild("OmegaHubGUI") then
    playerGui.OmegaHubGUI:Destroy()
end

local SAFE_ZONE = Vector3.new(545.3, 70.6, -367.9)

-- Las 4 coordenadas exactas de tus capturas
local WAYPOINTS = {
    Vector3.new(-492.4, 25.3, 5776.3),   -- 1: (Inicio)
    Vector3.new(-1602.0, 277.1, 5771.7), -- 2: (Jajaja)
    Vector3.new(-5622.9, 200.6, 5774.2), -- 3: (Lol)
    Vector3.new(-7763.7, 29.2, 5740.0)   -- 4: (Caer en las wins)
}

local autoRouteActive = false
local currentSpeed = 300

-- Creación del ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "OmegaHubGUI"
ScreenGui.Parent         = playerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn   = false

------------------------------------------------------------------
-- 🧸 INTRO / PANTALLA DE CARGA (5% AL 100%) FORZADA VISIBLE 🧸
------------------------------------------------------------------
local LoadingScreen = Instance.new("Frame")
LoadingScreen.Name             = "LoadingScreen"
LoadingScreen.Parent           = ScreenGui
LoadingScreen.BackgroundColor3 = Color3.fromRGB(38, 27, 21)
LoadingScreen.AnchorPoint      = Vector2.new(0.5, 0.5)
LoadingScreen.Position         = UDim2.new(0.5, 0, 0.5, 0)
LoadingScreen.Size             = UDim2.new(0, 300, 0, 160)
LoadingScreen.Visible          = true
Instance.new("UICorner", LoadingScreen).CornerRadius = UDim.new(0, 16)

local UIStrokeLoad = Instance.new("UIStroke")
UIStrokeLoad.Color     = Color3.fromRGB(130, 95, 75)
UIStrokeLoad.Thickness = 2.5
UIStrokeLoad.Parent    = LoadingScreen

-- Estrellitas decorativas en la carga
local LStar1 = Instance.new("TextLabel")
LStar1.Parent               = LoadingScreen
LStar1.BackgroundTransparency = 1
LStar1.Position             = UDim2.new(0, 12, 0, 12)
LStar1.Size                 = UDim2.new(0, 20, 0, 20)
LStar1.Font                 = Enum.Font.GothamBold
LStar1.Text                 = "⭐"
LStar1.TextSize             = 14

local LStar2 = Instance.new("TextLabel")
LStar2.Parent               = LoadingScreen
LStar2.BackgroundTransparency = 1
LStar2.Position             = UDim2.new(1, -32, 0, 12)
LStar2.Size                 = UDim2.new(0, 20, 0, 20)
LStar2.Font                 = Enum.Font.GothamBold
LStar2.Text                 = "⭐"
LStar2.TextSize             = 14

-- Título de carga con ositos
local LoadTitle = Instance.new("TextLabel")
LoadTitle.Parent               = LoadingScreen
LoadTitle.BackgroundTransparency = 1
LoadTitle.Position             = UDim2.new(0, 0, 0, 15)
LoadTitle.Size                 = UDim2.new(1, 0, 0, 30)
LoadTitle.Font                 = Enum.Font.GothamBold
LoadTitle.Text                 = "🧸 CARGANDO OMG HUB 🧸"
LoadTitle.TextSize             = 14
LoadTitle.TextColor3           = Color3.fromRGB(245, 230, 215)
LoadTitle.TextStrokeTransparency = 0.3
LoadTitle.TextStrokeColor3     = Color3.fromRGB(20, 12, 8)

-- Porcentaje dinámico
local PercentLabel = Instance.new("TextLabel")
PercentLabel.Parent               = LoadingScreen
PercentLabel.BackgroundTransparency = 1
PercentLabel.Position             = UDim2.new(0, 0, 0, 48)
PercentLabel.Size                 = UDim2.new(1, 0, 0, 30)
PercentLabel.Font                 = Enum.Font.GothamBold
PercentLabel.Text                 = "5%"
PercentLabel.TextSize             = 20
PercentLabel.TextColor3           = Color3.fromRGB(255, 220, 190)

-- Barra de carga fondo
local BarBg = Instance.new("Frame")
BarBg.Parent           = LoadingScreen
BarBg.BackgroundColor3 = Color3.fromRGB(55, 40, 31)
BarBg.Position         = UDim2.new(0.5, -120, 0, 95)
BarBg.Size             = UDim2.new(0, 240, 0, 14)
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

-- Barra de carga rellenándose
local BarFill = Instance.new("Frame")
BarFill.Parent           = BarBg
BarFill.BackgroundColor3 = Color3.fromRGB(180, 130, 100)
BarFill.Size             = UDim2.new(0.05, 0, 1, 0)
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

------------------------------------------------------------------
-- ELEMENTOS PRINCIPALES (Ocultos hasta que termine la intro)
------------------------------------------------------------------

-- Círculo Flotante Fijo
local CircleButton = Instance.new("ImageButton")
CircleButton.Name             = "CircleButton"
CircleButton.Parent           = ScreenGui
CircleButton.BackgroundColor3 = Color3.fromRGB(75, 55, 42)
CircleButton.Position         = UDim2.new(0.05, 0, 0.15, 0)
CircleButton.Size             = UDim2.new(0, 65, 0, 65)
CircleButton.Visible          = false
CircleButton.Image            = "rbxassetid://84658427883904"
Instance.new("UICorner", CircleButton).CornerRadius = UDim.new(1, 0)

local UIStrokeCircle = Instance.new("UIStroke")
UIStrokeCircle.Color     = Color3.fromRGB(130, 95, 75)
UIStrokeCircle.Thickness = 2.5
UIStrokeCircle.Parent    = CircleButton

local CircleLabel = Instance.new("TextLabel")
CircleLabel.Parent               = CircleButton
CircleLabel.BackgroundTransparency = 1
CircleLabel.Size                 = UDim2.new(1, 0, 1, 0)
CircleLabel.Font                 = Enum.Font.GothamBold
CircleLabel.Text                 = "OMG\nHUB"
CircleLabel.TextColor3           = Color3.fromRGB(245, 230, 215)
CircleLabel.TextSize             = 11

-- Ventana del Hub Decorada
local HubFrame = Instance.new("Frame")
HubFrame.Name             = "HubFrame"
HubFrame.Parent           = ScreenGui
HubFrame.BackgroundColor3 = Color3.fromRGB(48, 35, 28)
HubFrame.Position         = UDim2.new(0.5, -140, 0.5, -100)
HubFrame.Size             = UDim2.new(0, 280, 0, 140)
HubFrame.Visible          = false
Instance.new("UICorner", HubFrame).CornerRadius = UDim.new(0, 14)

local UIStrokeHub = Instance.new("UIStroke")
UIStrokeHub.Color         = Color3.fromRGB(140, 105, 80)
UIStrokeHub.Thickness     = 2.5
UIStrokeHub.Parent        = HubFrame

-- Estrellas decorativas internas (⭐)
local Star1 = Instance.new("TextLabel")
Star1.Parent               = HubFrame
Star1.BackgroundTransparency = 1
Star1.Position             = UDim2.new(0, 12, 0, 12)
Star1.Size                 = UDim2.new(0, 20, 0, 20)
Star1.Font                 = Enum.Font.GothamBold
Star1.Text                 = "⭐"
Star1.TextSize             = 14

local Star2 = Instance.new("TextLabel")
Star2.Parent               = HubFrame
Star2.BackgroundTransparency = 1
Star2.Position             = UDim2.new(1, -32, 0, 12)
Star2.Size                 = UDim2.new(0, 20, 0, 20)
Star2.Font                 = Enum.Font.GothamBold
Star2.Text                 = "⭐"
Star2.TextSize             = 14

-- Título con los ositos 🧸 OMG HUB 🧸 y brillo dinámico
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent               = HubFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position             = UDim2.new(0, 0, 0, 12)
TitleLabel.Size                 = UDim2.new(1, 0, 0, 30)
TitleLabel.Font                 = Enum.Font.GothamBold
TitleLabel.Text                 = "🧸 OMG HUB 🧸"
TitleLabel.TextSize             = 16
TitleLabel.TextStrokeTransparency = 0.3
TitleLabel.TextStrokeColor3     = Color3.fromRGB(20, 12, 8)

task.spawn(function()
    while TitleLabel and TitleLabel.Parent do
        local t = tick() * 2
        local r = math.sin(t) * 0.5 + 0.5
        local g = math.sin(t + 2) * 0.5 + 0.5
        local b = math.sin(t + 4) * 0.5 + 0.5
        TitleLabel.TextColor3 = Color3.fromRGB(150 + (r * 105), 120 + (g * 135), 100 + (b * 155))
        task.wait(0.1)
    end
end)

-- Botón de la Ruta de 4 Puntos + Wins
local AutoRouteButton = Instance.new("TextButton")
AutoRouteButton.Parent           = HubFrame
AutoRouteButton.BackgroundColor3 = Color3.fromRGB(85, 62, 48)
AutoRouteButton.Position         = UDim2.new(0.5, -115, 0, 65)
AutoRouteButton.Size             = UDim2.new(0, 230, 0, 45)
AutoRouteButton.Font             = Enum.Font.GothamBold
AutoRouteButton.Text             = "🔂 Ruta (4 Puntos) + Win: OFF"
AutoRouteButton.TextColor3       = Color3.fromRGB(255, 235, 210)
AutoRouteButton.TextSize         = 12
Instance.new("UICorner", AutoRouteButton).CornerRadius = UDim.new(0, 8)

------------------------------------------------------------------
-- EJECUCIÓN DE LA ANIMACIÓN DE CARGA (5% A 100%)
------------------------------------------------------------------
task.spawn(function()
    for i = 5, 100, 5 do
        PercentLabel.Text = i .. "%"
        BarFill.Size = UDim2.new(i / 100, 0, 1, 0)
        task.wait(0.06)
    end
    
    task.wait(0.2)
    LoadingScreen:Destroy()
    CircleButton.Visible = true
    HubFrame.Visible = true
end)

------------------------------------------------------------------
-- FUNCIONALIDADES DEL HUB
------------------------------------------------------------------

local function setupNameTag(char)
    if not char then return end
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    
    if head:FindFirstChild("OmegaNameTag") then
        head.OmegaNameTag:Destroy()
    end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "OmegaNameTag"
    billboard.Size = UDim2.new(0, 140, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    local tagLabel = Instance.new("TextLabel")
    tagLabel.Size = UDim2.new(1, 0, 1, 0)
    tagLabel.BackgroundTransparency = 1
    tagLabel.Font = Enum.Font.GothamBold
    tagLabel.Text = "🧸 OMG HUB 🧸"
    tagLabel.TextStrokeTransparency = 0.2
    tagLabel.TextStrokeColor3 = Color3.fromRGB(50, 30, 0)
    tagLabel.TextSize = 14
    tagLabel.Parent = billboard
    
    task.spawn(function()
        while tagLabel and tagLabel.Parent do
            local t = tick() * 2
            local r = math.sin(t) * 0.5 + 0.5
            local g = math.sin(t + 2) * 0.5 + 0.5
            local b = math.sin(t + 4) * 0.5 + 0.5
            tagLabel.TextColor3 = Color3.fromRGB(150 + (r * 105), 120 + (g * 135), 100 + (b * 155))
            task.wait(0.1)
        end
    end)
end

if player.Character then
    setupNameTag(player.Character)
end
player.CharacterAdded:Connect(setupNameTag)

local function showPopup(text)
    pcall(function()
        local alertGui = Instance.new("Frame")
        alertGui.Size = UDim2.new(0, 260, 0, 50)
        alertGui.Position = UDim2.new(0.5, -130, 0, -70)
        alertGui.BackgroundColor3 = Color3.fromRGB(48, 35, 28)
        alertGui.Parent = ScreenGui
        Instance.new("UICorner", alertGui).CornerRadius = UDim.new(0, 8)
        
        local alertText = Instance.new("TextLabel")
        alertText.Size = UDim2.new(1, -10, 1, 0)
        alertText.Position = UDim2.new(0, 5, 0, 0)
        alertText.BackgroundTransparency = 1
        alertText.Font = Enum.Font.GothamBold
        alertText.Text = text
        alertText.TextColor3 = Color3.fromRGB(245, 230, 215)
        alertText.TextSize = 11
        alertText.Parent = alertGui
        
        alertGui:TweenPosition(UDim2.new(0.5, -130, 0, 15), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        task.delay(1.5, function()
            if alertGui then alertGui:Destroy() end
        end)
    end)
end

local function teleportDirectTo(targetPos)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = char.HumanoidRootPart
    
    local startPos = rootPart.Position
    local distance = (targetPos - startPos).Magnitude
    local timeTaken = math.max(distance / currentSpeed, 0.05)
    
    local startTime = tick()
    while tick() - startTime < timeTaken do
        if not autoRouteActive or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then break end
        local alpha = (tick() - startTime) / timeTaken
        rootPart.CFrame = CFrame.new(startPos:Lerp(targetPos, alpha))
        
        pcall(function()
            if player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
            end
        end)
        
        task.wait()
    end
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
    end
end

local function touchWinParts()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = char.HumanoidRootPart
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = string.lower(obj.Name)
            if string.find(name, "win") or string.find(name, "victoria") or string.find(name, "regresar") or string.find(name, "touch") then
                if (obj.Position - rootPart.Position).Magnitude < 35 then
                    firetouchinterest(rootPart, obj, 0)
                    task.wait(0.05)
                    firetouchinterest(rootPart, obj, 1)
                end
            end
        end
    end
end

-- Bucle principal de la ruta
task.spawn(function()
    while true do
        if autoRouteActive then
            for i, pos in ipairs(WAYPOINTS) do
                if not autoRouteActive then break end
                local desc = ""
                if i == 1 then desc = "1 (Inicio)"
                elseif i == 2 then desc = "2 (Jajaja)"
                elseif i == 3 then desc = "3 (Lol)"
                elseif i == 4 then desc = "4 (Caer en wins)" end
                
                showPopup("📍 Punto " .. desc)
                teleportDirectTo(pos)
                task.wait(0.05)
            end
            
            if autoRouteActive then
                showPopup("🏆 Reclamando Wins sin reiniciar bucle 🏆")
                touchWinParts()
                task.wait(0.5)
                teleportDirectTo(SAFE_ZONE)
                task.wait(1)
            end
        end
        task.wait(0.2)
    end
end)

-- Botón de la Ruta
AutoRouteButton.MouseButton1Click:Connect(function()
    autoRouteActive = not autoRouteActive
    if autoRouteActive then
        AutoRouteButton.Text = "🔂 Ruta (4 Puntos) + Win: ON"
        AutoRouteButton.BackgroundColor3 = Color3.fromRGB(115, 82, 60)
    else
        AutoRouteButton.Text = "🔂 Ruta (4 Puntos) + Win: OFF"
        AutoRouteButton.BackgroundColor3 = Color3.fromRGB(85, 62, 48)
    end
end)

-- Círculo Fijo para abrir y cerrar el menú
CircleButton.MouseButton1Click:Connect(function()
    HubFrame.Visible = not HubFrame.Visible
end)

