-- Servicios principales
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Limpieza segura de interfaces anteriores
if playerGui:FindFirstChild("OmegaHubGUI") then
    playerGui.OmegaHubGUI:Destroy()
end

local SAFE_ZONE = Vector3.new(545.3, 70.6, -367.9)

-- Las 4 coordenadas exactas
local WAYPOINTS = {
    Vector3.new(-492.4, 25.3, 5776.3),   -- 1: (Inicio)
    Vector3.new(-1602.0, 277.1, 5771.7), -- 2: (Jajaja)
    Vector3.new(-5622.9, 200.6, 5774.2), -- 3: (Lol)
    Vector3.new(-7763.7, 29.2, 5740.0)   -- 4: (Caer en las wins)
}

local autoRouteActive = false
local currentSpeed = 300
local lastWaypointIndex = 1

-- Creación del ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "OmegaHubGUI"
ScreenGui.Parent         = playerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn   = false

------------------------------------------------------------------
-- 🧸 INTRO / PANTALLA DE CARGA (5% AL 100%) 🧸
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

local PercentLabel = Instance.new("TextLabel")
PercentLabel.Parent               = LoadingScreen
PercentLabel.BackgroundTransparency = 1
PercentLabel.Position             = UDim2.new(0, 0, 0, 48)
PercentLabel.Size                 = UDim2.new(1, 0, 0, 30)
PercentLabel.Font                 = Enum.Font.GothamBold
PercentLabel.Text                 = "5%"
PercentLabel.TextSize             = 20
PercentLabel.TextColor3           = Color3.fromRGB(255, 220, 190)

local BarBg = Instance.new("Frame")
BarBg.Parent           = LoadingScreen
BarBg.BackgroundColor3 = Color3.fromRGB(55, 40, 31)
BarBg.Position         = UDim2.new(0.5, -120, 0, 95)
BarBg.Size             = UDim2.new(0, 240, 0, 14)
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame")
BarFill.Parent           = BarBg
BarFill.BackgroundColor3 = Color3.fromRGB(180, 130, 100)
BarFill.Size             = UDim2.new(0.05, 0, 1, 0)
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

------------------------------------------------------------------
-- ELEMENTOS PRINCIPALES
------------------------------------------------------------------
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

-- Ventana principal del Hub
local HubFrame = Instance.new("Frame")
HubFrame.Name             = "HubFrame"
HubFrame.Parent           = ScreenGui
HubFrame.BackgroundColor3 = Color3.fromRGB(48, 35, 28)
HubFrame.Position         = UDim2.new(0.5, -150, 0.5, -110)
HubFrame.Size             = UDim2.new(0, 300, 0, 205)
HubFrame.Visible          = false
Instance.new("UICorner", HubFrame).CornerRadius = UDim.new(0, 14)

local UIStrokeHub = Instance.new("UIStroke")
UIStrokeHub.Color         = Color3.fromRGB(140, 105, 80)
UIStrokeHub.Thickness     = 2.5
UIStrokeHub.Parent        = HubFrame

-- Imagen de fondo integrada cubriendo sutilmente la pantalla del menú principal
local MenuBgImage = Instance.new("ImageLabel")
MenuBgImage.Parent               = HubFrame
MenuBgImage.BackgroundTransparency = 1
MenuBgImage.Position             = UDim2.new(0, 0, 0, 0)
MenuBgImage.Size                 = UDim2.new(1, 0, 1, 0)
MenuBgImage.Image                = "rbxassetid://84658427883904"
MenuBgImage.ImageTransparency    = 0.82
MenuBgImage.ZIndex               = 0

local Star1 = Instance.new("TextLabel")
Star1.Parent               = HubFrame
Star1.BackgroundTransparency = 1
Star1.Position             = UDim2.new(1, -32, 0, 12)
Star1.Size                 = UDim2.new(0, 20, 0, 20)
Star1.ZIndex               = 2
Star1.Font                 = Enum.Font.GothamBold
Star1.Text                 = "⭐"
Star1.TextSize             = 14

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent               = HubFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position             = UDim2.new(0, 15, 0, 12)
TitleLabel.Size                 = UDim2.new(1, -30, 0, 35)
TitleLabel.ZIndex               = 2
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

-- Medidor de Velocidad
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent               = HubFrame
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position             = UDim2.new(0, 15, 0, 58)
SpeedLabel.Size                 = UDim2.new(1, -30, 0, 20)
SpeedLabel.ZIndex               = 2
SpeedLabel.Font                 = Enum.Font.GothamBold
SpeedLabel.Text                 = "Velocidad Auto Farm: " .. currentSpeed
SpeedLabel.TextColor3           = Color3.fromRGB(245, 230, 215)
SpeedLabel.TextSize             = 11

local SpeedMinus = Instance.new("TextButton")
SpeedMinus.Parent               = HubFrame
SpeedMinus.BackgroundColor3     = Color3.fromRGB(70, 50, 38)
SpeedMinus.Position             = UDim2.new(0, 15, 0, 82)
SpeedMinus.Size                 = UDim2.new(0, 60, 0, 25)
SpeedMinus.ZIndex               = 2
SpeedMinus.Font                 = Enum.Font.GothamBold
SpeedMinus.Text                 = "- 50"
SpeedMinus.TextColor3           = Color3.fromRGB(255, 235, 210)
SpeedMinus.TextSize             = 11
Instance.new("UICorner", SpeedMinus).CornerRadius = UDim.new(0, 6)

local SpeedPlus = Instance.new("TextButton")
SpeedPlus.Parent               = HubFrame
SpeedPlus.BackgroundColor3     = Color3.fromRGB(70, 50, 38)
SpeedPlus.Position             = UDim2.new(0, 85, 0, 82)
SpeedPlus.Size                 = UDim2.new(0, 60, 0, 25)
SpeedPlus.ZIndex               = 2
SpeedPlus.Font                 = Enum.Font.GothamBold
SpeedPlus.Text                 = "+ 50"
SpeedPlus.TextColor3           = Color3.fromRGB(255, 235, 210)
SpeedPlus.TextSize             = 11
Instance.new("UICorner", SpeedPlus).CornerRadius = UDim.new(0, 6)

local SpeedStatus = Instance.new("TextLabel")
SpeedStatus.Parent               = HubFrame
SpeedStatus.BackgroundTransparency = 1
SpeedStatus.Position             = UDim2.new(0, 155, 0, 82)
SpeedStatus.Size                 = UDim2.new(0, 130, 0, 25)
SpeedStatus.ZIndex               = 2
SpeedStatus.Font                 = Enum.Font.GothamBold
SpeedStatus.Text                 = "(Normal)"
SpeedStatus.TextColor3           = Color3.fromRGB(200, 170, 140)
SpeedStatus.TextSize             = 10

-- Botón de la Ruta
local AutoRouteButton = Instance.new("TextButton")
AutoRouteButton.Parent           = HubFrame
AutoRouteButton.BackgroundColor3 = Color3.fromRGB(85, 62, 48)
AutoRouteButton.Position         = UDim2.new(0, 15, 0, 118)
AutoRouteButton.Size             = UDim2.new(0, 270, 0, 42)
AutoRouteButton.ZIndex           = 2
AutoRouteButton.Font             = Enum.Font.GothamBold
AutoRouteButton.Text             = "🔂 Ruta (4 Puntos) + Win: OFF"
AutoRouteButton.TextColor3       = Color3.fromRGB(255, 235, 210)
AutoRouteButton.TextSize         = 12
Instance.new("UICorner", AutoRouteButton).CornerRadius = UDim.new(0, 8)

-- Estado de Inmortalidad
local GodStatusLabel = Instance.new("TextLabel")
GodStatusLabel.Parent               = HubFrame
GodStatusLabel.BackgroundTransparency = 1
GodStatusLabel.Position             = UDim2.new(0, 15, 0, 168)
GodStatusLabel.Size                 = UDim2.new(1, -30, 0, 25)
GodStatusLabel.ZIndex               = 2
GodStatusLabel.Font                 = Enum.Font.GothamBold
GodStatusLabel.Text                 = "🛡️ Inmortalidad & Anti-Muerte: ACTIVO 🛡️"
GodStatusLabel.TextColor3           = Color3.fromRGB(120, 255, 140)
GodStatusLabel.TextSize             = 10

------------------------------------------------------------------
-- ANIMACIÓN DE CARGA (5% A 100%)
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
-- INMORTALIDAD Y RESURRECCIÓN EXACTA EN EL WAYPOINT ACTUAL
------------------------------------------------------------------
local function applyGodMode(char)
    if not char then return end
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        
        humanoid.HealthChanged:Connect(function()
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        
        humanoid.Died:Connect(function()
            task.wait(0.1)
            player.CharacterAdded:Wait()
            task.wait(0.5)
            local newChar = player.Character
            if newChar and newChar:FindFirstChild("HumanoidRootPart") then
                newChar.HumanoidRootPart.CFrame = CFrame.new(WAYPOINTS[lastWaypointIndex])
            end
        end)
    end
end

if player.Character then
    applyGodMode(player.Character)
end
player.CharacterAdded:Connect(applyGodMode)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            if root.Position.Y < -50 then
                root.CFrame = CFrame.new(WAYPOINTS[lastWaypointIndex])
            end
        end
    end)
end)

------------------------------------------------------------------
-- CONTROLES Y FUNCIONES
------------------------------------------------------------------
SpeedMinus.MouseButton1Click:Connect(function()
    currentSpeed = math.clamp(currentSpeed - 50, 50, 2000)
    SpeedLabel.Text = "Velocidad Auto Farm: " .. currentSpeed
    if currentSpeed < 200 then SpeedStatus.Text = "(Lento/Seguro)"
    elseif currentSpeed <= 500 then SpeedStatus.Text = "(Normal)"
    else SpeedStatus.Text = "(¡Ultra Rápido!)" end
end)

SpeedPlus.MouseButton1Click:Connect(function()
    currentSpeed = math.clamp(currentSpeed + 50, 50, 2000)
    SpeedLabel.Text = "Velocidad Auto Farm: " .. currentSpeed
    if currentSpeed < 200 then SpeedStatus.Text = "(Lento/Seguro)"
    elseif currentSpeed <= 500 then SpeedStatus.Text = "(Normal)"
    else SpeedStatus.Text = "(¡Ultra Rápido!)" end
end)

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

local function checkWaypoint1Empty()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    local rootPart = char.HumanoidRootPart
    
    local foundSomething = false
    for _, part in ipairs(Workspace:GetPartsInPart(rootPart)) do
        if part and part.Parent ~= char then
            foundSomething = true
            break
        end
    end
    return not foundSomething
end

local function touchWinParts()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = char.HumanoidRootPart
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = string.lower(obj.Name)
            if string.find(name, "win") or string.find(name, "victoria") or string.find(name, "regresar") or string.find(name, "touch") then
                if (obj.Position - rootPart.Position).Magnitude < 40 then
                    firetouchinterest(rootPart, obj, 0)
                    task.wait(0.05)
                    firetouchinterest(rootPart, obj, 1)
                end
            end
        end
    end
end

-- Bucle principal del auto farm ajustado para reiniciar ciclo limpiamente tras las wins
task.spawn(function()
    while true do
        if autoRouteActive then
            for i, pos in ipairs(WAYPOINTS) do
                if not autoRouteActive then break end
                lastWaypointIndex = i
                
                local desc = ""
                if i == 1 then desc = "1 (Inicio)"
                elseif i == 2 then desc = "2 (Jajaja)"
                elseif i == 3 then desc = "3 (Lol)"
                elseif i == 4 then desc = "4 (Caer en wins)" end
                
                showPopup("📍 Punto " .. desc)
                teleportDirectTo(pos)
                task.wait(0.05)
                
                if i == 1 and checkWaypoint1Empty() then
                    showPopup("⚠️ Zona vacía en Punto 1, reintentando...")
                    task.wait(0.3)
                end
            end
            
            if autoRouteActive then
                showPopup("🏆 Reclamando Wins y Reiniciando Bucle 🏆")
                touchWinParts()
                task.wait(0.4)
                -- Al agarrar las wins, se salta directo al punto 1 (reiniciando el bucle orgánicamente sin sacarte al vacío)
                lastWaypointIndex = 1
                teleportDirectTo(WAYPOINTS[1])
                task.wait(0.5)
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
