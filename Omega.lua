-- Servicios principales
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Contenedor ultra seguro para evitar que el juego oculte o borre el Hub
local protectedGui = nil
if syn and syn.protect_gui then
    protectedGui = Instance.new("ScreenGui")
    syn.protect_gui(protectedGui)
elseif gethui then
    protectedGui = gethui()
else
    protectedGui = player:WaitForChild("PlayerGui")
end

-- Limpieza profunda previa de cualquier duplicado anterior
pcall(function()
    if protectedGui:FindFirstChild("OmegaHubGUI") then
        protectedGui.OmegaHubGUI:Destroy()
    end
    if player.PlayerGui:FindFirstChild("OmegaHubGUI") then
        player.PlayerGui.OmegaHubGUI:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name             = "OmegaHubGUI"
ScreenGui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn     = false
ScreenGui.IgnoreGuiInset   = true

if gethui then
    ScreenGui.Parent = gethui()
else
    pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = player:WaitForChild("PlayerGui")
    end
end

------------------------------------------------------------------
-- 💜 PANTALLA DE CARGA PURPLE LIGHT / NEÓN 💜
------------------------------------------------------------------
local LoadingScreen = Instance.new("Frame")
LoadingScreen.Name             = "LoadingScreen"
LoadingScreen.Parent           = ScreenGui
LoadingScreen.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
LoadingScreen.AnchorPoint      = Vector2.new(0.5, 0.5)
LoadingScreen.Position         = UDim2.new(0.5, 0, 0.5, 0)
LoadingScreen.Size             = UDim2.new(0, 300, 0, 160)
LoadingScreen.Visible          = true
Instance.new("UICorner", LoadingScreen).CornerRadius = UDim.new(0, 16)

local UIStrokeLoad = Instance.new("UIStroke")
UIStrokeLoad.Color     = Color3.fromRGB(180, 100, 255)
UIStrokeLoad.Thickness = 2.5
UIStrokeLoad.Parent    = LoadingScreen

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Parent               = LoadingScreen
LoadTitle.BackgroundTransparency = 1
LoadTitle.Position             = UDim2.new(0, 0, 0, 20)
LoadTitle.Size                 = UDim2.new(1, 0, 0, 30)
LoadTitle.Font                 = Enum.Font.GothamBold
LoadTitle.Text                 = "💜 CARGANDO OMEGA HUB 💜"
LoadTitle.TextSize             = 14
LoadTitle.TextColor3           = Color3.fromRGB(235, 200, 255)

local PercentLabel = Instance.new("TextLabel")
PercentLabel.Parent               = LoadingScreen
PercentLabel.BackgroundTransparency = 1
PercentLabel.Position             = UDim2.new(0, 0, 0, 55)
PercentLabel.Size                 = UDim2.new(1, 0, 0, 30)
PercentLabel.Font                 = Enum.Font.GothamBold
PercentLabel.Text                 = "5%"
PercentLabel.TextSize             = 20
PercentLabel.TextColor3           = Color3.fromRGB(255, 220, 255)

local BarBg = Instance.new("Frame")
BarBg.Parent           = LoadingScreen
BarBg.BackgroundColor3 = Color3.fromRGB(40, 25, 60)
BarBg.Position         = UDim2.new(0.5, -120, 0, 100)
BarBg.Size             = UDim2.new(0, 240, 0, 14)
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame")
BarFill.Parent           = BarBg
BarFill.BackgroundColor3 = Color3.fromRGB(200, 130, 255)
BarFill.Size             = UDim2.new(0.05, 0, 1, 0)
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

------------------------------------------------------------------
-- CÍRCULO FLOTANTE (ESTILO NEÓN PURPLE)
------------------------------------------------------------------
local CircleButton = Instance.new("ImageButton")
CircleButton.Name             = "CircleButton"
CircleButton.Parent           = ScreenGui
CircleButton.BackgroundColor3 = Color3.fromRGB(45, 25, 65)
CircleButton.Position         = UDim2.new(0.05, 0, 0.15, 0)
CircleButton.Size             = UDim2.new(0, 65, 0, 65)
CircleButton.Visible          = false
CircleButton.Image            = "rbxassetid://84658427883904"
Instance.new("UICorner", CircleButton).CornerRadius = UDim.new(1, 0)

local UIStrokeCircle = Instance.new("UIStroke")
UIStrokeCircle.Color     = Color3.fromRGB(200, 120, 255)
UIStrokeCircle.Thickness = 2.5
UIStrokeCircle.Parent    = CircleButton

------------------------------------------------------------------
-- VENTANA PRINCIPAL (PURPLE LIGHT CON LUCES QUE SE ILUMINAN)
------------------------------------------------------------------
local HubFrame = Instance.new("Frame")
HubFrame.Name             = "HubFrame"
HubFrame.Parent           = ScreenGui
HubFrame.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
HubFrame.Position         = UDim2.new(0.5, -170, 0.5, -155)
HubFrame.Size             = UDim2.new(0, 340, 0, 290)
HubFrame.Visible          = false
Instance.new("UICorner", HubFrame).CornerRadius = UDim.new(0, 12)

local UIStrokeHub = Instance.new("UIStroke")
UIStrokeHub.Color         = Color3.fromRGB(190, 110, 255)
UIStrokeHub.Thickness     = 2.5
UIStrokeHub.Parent        = HubFrame

-- Efecto de luces intermitentes lindas que iluminan y se apagan suavemente
task.spawn(function()
    while true do
        for i = 2.0, 5.0, 0.15 do
            if not UIStrokeHub or not UIStrokeHub.Parent then break end
            UIStrokeHub.Thickness = i
            UIStrokeLoad.Thickness = i
            UIStrokeCircle.Thickness = i
            task.wait(0.06)
        end
        for i = 5.0, 2.0, -0.15 do
            if not UIStrokeHub or not UIStrokeHub.Parent then break end
            UIStrokeHub.Thickness = i
            UIStrokeLoad.Thickness = i
            UIStrokeCircle.Thickness = i
            task.wait(0.06)
        end
    end
end)

local HeaderFrame = Instance.new("Frame")
HeaderFrame.Parent           = HubFrame
HeaderFrame.BackgroundColor3 = Color3.fromRGB(32, 18, 48)
HeaderFrame.Size             = UDim2.new(1, 0, 0, 70)
Instance.new("UICorner", HeaderFrame).CornerRadius = UDim.new(0, 12)

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Parent               = HeaderFrame
AvatarImg.BackgroundColor3     = Color3.fromRGB(50, 30, 75)
AvatarImg.Position             = UDim2.new(0, 10, 0.5, -22)
AvatarImg.Size                 = UDim2.new(0, 42, 0, 42)
AvatarImg.Image                = "rbxassetid://84658427883904"
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

local HubTitle = Instance.new("TextLabel")
HubTitle.Parent               = HeaderFrame
HubTitle.BackgroundTransparency = 1
HubTitle.Position             = UDim2.new(0, 60, 0, 8)
HubTitle.Size                 = UDim2.new(0, 150, 0, 16)
HubTitle.Font                 = Enum.Font.GothamBold
HubTitle.Text                 = "OMEGA HUB"
HubTitle.TextColor3           = Color3.fromRGB(240, 210, 255)
HubTitle.TextSize             = 13
HubTitle.TextXAlignment       = Enum.TextXAlignment.Left

local WorldLabel = Instance.new("TextLabel")
WorldLabel.Parent               = HeaderFrame
WorldLabel.BackgroundTransparency = 1
WorldLabel.Position             = UDim2.new(0, 60, 0, 25)
WorldLabel.Size                 = UDim2.new(0, 200, 0, 16)
WorldLabel.Font                 = Enum.Font.GothamBold
WorldLabel.Text                 = "💜 World 3 - Purple Light 💜"
WorldLabel.TextColor3           = Color3.fromRGB(210, 150, 255)
WorldLabel.TextSize             = 10
WorldLabel.TextXAlignment       = Enum.TextXAlignment.Left

local DiscordSvrLabel = Instance.new("TextButton")
DiscordSvrLabel.Parent               = HeaderFrame
DiscordSvrLabel.BackgroundTransparency = 1
DiscordSvrLabel.Position             = UDim2.new(0, 60, 0, 43)
DiscordSvrLabel.Size                 = UDim2.new(0, 200, 0, 16)
DiscordSvrLabel.Font                 = Enum.Font.GothamBold
DiscordSvrLabel.Text                 = "Svr: discord.gg/JmCC5Ph8m"
DiscordSvrLabel.TextColor3           = Color3.fromRGB(150, 180, 255)
DiscordSvrLabel.TextSize             = 10
DiscordSvrLabel.TextXAlignment       = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent               = HeaderFrame
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position             = UDim2.new(1, -35, 0.5, -16)
CloseBtn.Size                 = UDim2.new(0, 28, 0, 28)
CloseBtn.Font                 = Enum.Font.GothamBold
CloseBtn.Text                 = "✕"
CloseBtn.TextColor3           = Color3.fromRGB(200, 170, 220)
CloseBtn.TextSize             = 14

------------------------------------------------------------------
-- MOVIMIENTO DE VENTANA (DRAG AND DROP)
------------------------------------------------------------------
local dragging, dragInput, dragStart, startPos

HeaderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = HubFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        HubFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

------------------------------------------------------------------
-- PANEL DE CONTROL PURPLE LIGHT
------------------------------------------------------------------
local ControlCard = Instance.new("Frame")
ControlCard.Parent           = HubFrame
ControlCard.BackgroundColor3 = Color3.fromRGB(25, 17, 38)
ControlCard.Position         = UDim2.new(0, 12, 0, 80)
ControlCard.Size             = UDim2.new(1, -24, 0, 195)
Instance.new("UICorner", ControlCard).CornerRadius = UDim.new(0, 10)

local UIStrokeControl = Instance.new("UIStroke")
UIStrokeControl.Color     = Color3.fromRGB(150, 80, 220)
UIStrokeControl.Thickness = 1.5
UIStrokeControl.Parent    = ControlCard

local PanelTitle = Instance.new("TextLabel")
PanelTitle.Parent               = ControlCard
PanelTitle.BackgroundTransparency = 1
PanelTitle.Position             = UDim2.new(0, 12, 0, 8)
PanelTitle.Size                 = UDim2.new(1, -24, 0, 16)
PanelTitle.Font                 = Enum.Font.GothamBold
PanelTitle.Text                 = "AUTO FARM WINS (B ➔ C ➔ D ➔ E)"
PanelTitle.TextColor3           = Color3.fromRGB(230, 200, 255)
PanelTitle.TextSize             = 11
PanelTitle.TextXAlignment       = Enum.TextXAlignment.Left

local StartFarmBtn = Instance.new("TextButton")
StartFarmBtn.Parent               = ControlCard
StartFarmBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
StartFarmBtn.Position             = UDim2.new(0, 12, 0, 28)
StartFarmBtn.Size                 = UDim2.new(1, -24, 0, 28)
StartFarmBtn.Font                 = Enum.Font.GothamBold
StartFarmBtn.Text                 = "▶ Iniciar Auto Farm"
StartFarmBtn.TextColor3           = Color3.fromRGB(150, 255, 170)
StartFarmBtn.TextSize             = 11
Instance.new("UICorner", StartFarmBtn).CornerRadius = UDim.new(0, 8)

local UIStrokeBtn = Instance.new("UIStroke")
UIStrokeBtn.Color     = Color3.fromRGB(180, 100, 255)
UIStrokeBtn.Thickness = 1
UIStrokeBtn.Parent    = StartFarmBtn

local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Parent               = ControlCard
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Position             = UDim2.new(0, 12, 0, 62)
SpeedTitle.Size                 = UDim2.new(1, -24, 0, 14)
SpeedTitle.Font                 = Enum.Font.GothamBold
SpeedTitle.Text                 = "Velocidad: 350 (Toca o desliza)"
SpeedTitle.TextColor3           = Color3.fromRGB(200, 170, 230)
SpeedTitle.TextSize             = 10
SpeedTitle.TextXAlignment       = Enum.TextXAlignment.Left

local SliderBg = Instance.new("Frame")
SliderBg.Parent               = ControlCard
SliderBg.BackgroundColor3     = Color3.fromRGB(35, 22, 52)
SliderBg.Position             = UDim2.new(0, 12, 0, 80)
SliderBg.Size             = UDim2.new(1, -24, 0, 14)
Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame")
SliderFill.Parent               = SliderBg
SliderFill.BackgroundColor3     = Color3.fromRGB(190, 120, 255)
SliderFill.Size                 = UDim2.new(0.35, 0, 1, 0)
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

local SpeedBox = Instance.new("TextBox")
SpeedBox.Parent               = ControlCard
SpeedBox.BackgroundColor3 = Color3.fromRGB(35, 22, 52)
SpeedBox.Position             = UDim2.new(1, -65, 0, 60)
SpeedBox.Size                 = UDim2.new(0, 53, 0, 18)
SpeedBox.Font                 = Enum.Font.GothamBold
SpeedBox.Text                 = "350"
SpeedBox.TextColor3           = Color3.fromRGB(240, 200, 255)
SpeedBox.TextSize             = 10
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 4)

local StatusInfo = Instance.new("TextLabel")
StatusInfo.Parent               = ControlCard
StatusInfo.BackgroundTransparency = 1
StatusInfo.Position             = UDim2.new(0, 12, 0, 102)
StatusInfo.Size                 = UDim2.new(1, -24, 0, 22)
StatusInfo.Font                 = Enum.Font.GothamBold
StatusInfo.Text                 = "Estado: detenido"
StatusInfo.TextColor3           = Color3.fromRGB(190, 160, 220)
StatusInfo.TextSize             = 10
StatusInfo.TextXAlignment       = Enum.TextXAlignment.Left

local WinDetectStatus = Instance.new("TextLabel")
WinDetectStatus.Parent               = ControlCard
WinDetectStatus.BackgroundTransparency = 1
WinDetectStatus.Position             = UDim2.new(0, 12, 0, 126)
WinDetectStatus.Size                 = UDim2.new(1, -24, 0, 24)
WinDetectStatus.Font                 = Enum.Font.GothamBold
WinDetectStatus.Text                 = "Wins: Esperando detección..."
WinDetectStatus.TextColor3           = Color3.fromRGB(130, 255, 160)
WinDetectStatus.TextSize             = 10
WinDetectStatus.TextWrapped          = true
WinDetectStatus.TextXAlignment       = Enum.TextXAlignment.Left

------------------------------------------------------------------
-- TÍTULO EN LA CABEZA DEL JUGADOR
------------------------------------------------------------------
local function setupNameTag(char)
    if not char then return end
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    if head:FindFirstChild("OmegaNameTag") then head.OmegaNameTag:Destroy() end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "OmegaNameTag"
    billboard.Size = UDim2.new(0, 160, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.8, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    local tagLabel = Instance.new("TextLabel")
    tagLabel.Size = UDim2.new(1, 0, 1, 0)
    tagLabel.BackgroundTransparency = 1
    tagLabel.Font = Enum.Font.GothamBold
    tagLabel.Text = "💜 OMEGA HUB 💜"
    tagLabel.TextStrokeTransparency = 0.2
    tagLabel.TextStrokeColor3 = Color3.fromRGB(40, 10, 60)
    tagLabel.TextSize = 14
    tagLabel.Parent = billboard
    
    task.spawn(function()
        while tagLabel and tagLabel.Parent do
            local t = tick() * 2
            local r = math.sin(t) * 0.5 + 0.5
            local g = math.sin(t + 2) * 0.5 + 0.5
            local b = math.sin(t + 4) * 0.5 + 0.5
            tagLabel.TextColor3 = Color3.fromRGB(180 + (r * 75), 100 + (g * 100), 220 + (b * 35))
            task.wait(0.1)
        end
    end)
end

if player.Character then setupNameTag(player.Character) end
player.CharacterAdded:Connect(setupNameTag)

task.spawn(function()
    for i = 5, 100, 5 do
        PercentLabel.Text = i .. "%"
        BarFill.Size = UDim2.new(i / 100, 0, 1, 0)
        task.wait(0.03)
    end
    task.wait(0.15)
    LoadingScreen:Destroy()
    CircleButton.Visible = true
    HubFrame.Visible = true
end)

------------------------------------------------------------------
-- SISTEMA ANTI-KILL
------------------------------------------------------------------
local function applyAntiKill(char)
    if not char then return end
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.HealthChanged:Connect(function(health)
            if health <= 10 then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    end
end

if player.Character then applyAntiKill(player.Character) end
player.CharacterAdded:Connect(applyAntiKill)

------------------------------------------------------------------
-- CONTROL DE VELOCIDAD
------------------------------------------------------------------
local currentSpeed = 350

local function updateSpeed(val)
    currentSpeed = math.clamp(math.floor(val), 50, 1000)
    SpeedTitle.Text = "Velocidad: " .. currentSpeed .. " (Toca o desliza)"
    SpeedBox.Text = tostring(currentSpeed)
    local scale = (currentSpeed - 50) / (1000 - 50)
    SliderFill.Size = UDim2.new(scale, 0, 1, 0)
end

local sliding = false
SliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
        local pos = (input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X
        updateSpeed(50 + (pos * 950))
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = (input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X
        updateSpeed(50 + (pos * 950))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = false
    end
end)

SpeedBox.FocusLost:Connect(function()
    local num = tonumber(SpeedBox.Text)
    if num then
        updateSpeed(num)
    else
        SpeedBox.Text = tostring(currentSpeed)
    end
end)

------------------------------------------------------------------
-- TELETRANSPORTE DIRECTO (SIN LÍNEAS)
------------------------------------------------------------------
local function teleportTo(targetPos)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
    local rootPart = char.HumanoidRootPart
    local humanoid = char.Humanoid
    
    local startPos = rootPart.Position
    local distance = (targetPos - startPos).Magnitude
    local speed = currentSpeed
    local travelTime = math.max(distance / speed, 0.01)
    
    local startTime = tick()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local alpha = math.clamp(elapsed / travelTime, 0, 1)
        
        pcall(function()
            if rootPart and humanoid then
                humanoid.Health = humanoid.MaxHealth
                rootPart.CFrame = CFrame.new(startPos:Lerp(targetPos, alpha))
            end
        end)
        
        if alpha >= 1 then
            if connection then connection:Disconnect() end
        end
    end)
    
    task.wait(travelTime + 0.02)
    if connection then connection:Disconnect() end
end

------------------------------------------------------------------
-- LISTA DE COORDENADAS B, C, D, E
------------------------------------------------------------------
local points = {
    Vector3.new(-439.0, 26.9, 2775.7),   -- B
    Vector3.new(-2571.2, 363.7, 2849.0), -- C
    Vector3.new(-8071.6, 443.7, 2974.1), -- D
    Vector3.new(-8075.1, 291.0, 2741.0)  -- E (Bloque / Coordenada exacta de las Wins)
}

local farmingActive = false

local function getCurrentWins()
    local count = 0
    pcall(function()
        if player:FindFirstChild("leaderstats") then
            for _, stat in ipairs(player.leaderstats:GetChildren()) do
                local name = string.lower(stat.Name)
                if string.find(name, "win") or string.find(name, "victoria") then
                    count = tonumber(stat.Value) or 0
                end
            end
        end
    end)
    return count
end

StartFarmBtn.MouseButton1Click:Connect(function()
    farmingActive = not farmingActive
    if farmingActive then
        StartFarmBtn.Text = "⏹ Detener Auto Farm"
        StartFarmBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
        
        task.spawn(function()
            while farmingActive do
                -- 1. Recorrido fluido por los puntos B, C y D
                for i = 1, 3 do
                    if not farmingActive then break end
                    StatusInfo.Text = "Estado: yendo al punto " .. string.char(64 + i)
                    teleportTo(points[i] + Vector3.new(0, 3, 0))
                    task.wait(0.1)
                end
                
                if not farmingActive then break end

                -- 2. Coordenada E: Se queda pegado y anclado tocando la win obligatoriamente hasta detectarla
                StatusInfo.Text = "Estado: en E, esperando agarrar win..."
                local winsBefore = getCurrentWins()
                
                local winCollected = false
                while farmingActive and not winCollected do
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                        char.Humanoid.Health = char.Humanoid.MaxHealth
                        char.HumanoidRootPart.CFrame = CFrame.new(points[4] + Vector3.new(0, 1.5, 0))
                        char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        char.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end
                    
                    local currentWins = getCurrentWins()
                    if currentWins > winsBefore then
                        winCollected = true
                        WinDetectStatus.Text = "¡Win agarrada con éxito!"
                        WinDetectStatus.TextColor3 = Color3.fromRGB(150, 255, 180)
                    else
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local dist = (char.HumanoidRootPart.Position - points[4]).Magnitude
                            if dist < 5 then
                                task.wait(0.5)
                                winCollected = true
                                WinDetectStatus.Text = "¡Win agarrada (toque E confirmado)!"
                                WinDetectStatus.TextColor3 = Color3.fromRGB(150, 255, 180)
                            end
                        end
                    end
                    task.wait(0.1)
                end
                
                task.wait(0.4)
            end
        end)
    else
        StartFarmBtn.Text = "▶ Iniciar Auto Farm"
        StartFarmBtn.TextColor3 = Color3.fromRGB(150, 255, 170)
        StatusInfo.Text = "Estado: detenido"
        WinDetectStatus.Text = "Wins: Esperando detección..."
        WinDetectStatus.TextColor3 = Color3.fromRGB(130, 255, 160)
    end
end)

DiscordSvrLabel.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/JmCC5Ph8m")
        StatusInfo.Text = "Estado: ¡Discord copiado! 💬"
    end)
end)

CloseBtn.MouseButton1Click:Connect(function()
    HubFrame.Visible = false
end)

CircleButton.MouseButton1Click:Connect(function()
    HubFrame.Visible = not HubFrame.Visible
end)
