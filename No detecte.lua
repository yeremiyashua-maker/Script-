-- Servicios necesarios
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui")

-- Limpiar interfaces anteriores para evitar duplicados
pcall(function()
    if playerGui:FindFirstChild("HumanoidRealGui") then playerGui.HumanoidRealGui:Destroy() end
    if CoreGui:FindFirstChild("HumanoidRealGui") then CoreGui.HumanoidRealGui:Destroy() end
end)

-- Interfaz visual segura y garantizada para celulares
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HumanoidRealGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local success, err = pcall(function()
    screenGui.Parent = CoreGui
end)
if not success then
    screenGui.Parent = playerGui
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 190, 0, 105)
mainFrame.Position = UDim2.new(0, 50, 0, 150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(138, 43, 226) -- Borde morado brillante
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Sistema táctil para mover el menú con el dedo en celular
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Botón Principal Estilizado (Morado con imagen exacta)
local button = Instance.new("ImageButton")
button.Name = "MoveButton"
button.Size = UDim2.new(0, 170, 0, 45)
button.Position = UDim2.new(0, 10, 0, 10)
button.BackgroundColor3 = Color3.fromRGB(110, 30, 200)
button.Image = "rbxassetid://77284014359434"
button.ScaleType = Enum.ScaleType.Fit
button.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = button

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "✨ IR A BASE [10]"
titleLabel.TextStrokeTransparency = 0.5
titleLabel.Parent = button

-- Panel inferior para modificar la velocidad real del humanoide (hasta 1000)
local speedBox = Instance.new("TextBox")
speedBox.Name = "SpeedBox"
speedBox.Size = UDim2.new(0, 170, 0, 32)
speedBox.Position = UDim2.new(0, 10, 0, 62)
speedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
speedBox.TextColor3 = Color3.fromRGB(0, 255, 128)
speedBox.TextSize = 13
speedBox.Font = Enum.Font.Code
speedBox.Text = "  300" -- Puedes poner el valor que quieras hasta 1000
speedBox.ClearTextOnFocus = false
speedBox.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedBox

local speedLabelText = Instance.new("TextLabel")
speedLabelText.Size = UDim2.new(0, 70, 0, 32)
speedLabelText.Position = UDim2.new(0, 15, 0, 62)
speedLabelText.BackgroundTransparency = 1
speedLabelText.TextColor3 = Color3.fromRGB(180, 180, 180)
speedLabelText.TextSize = 11
speedLabelText.Font = Enum.Font.Gotham
speedLabelText.Text = "Velocidad:"
speedLabelText.Parent = mainFrame

local enMovimiento = false

button.MouseButton1Click:Connect(function()
    if enMovimiento then return end
    
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    -- Ruta exacta solicitada
    local objetivoPart = workspace.World.Build.MainMap.Bases:GetChildren()[10]
    
    if not objetivoPart then
        titleLabel.Text = "¡BASE NO H."
        task.wait(1.5)
        titleLabel.Text = "✨ IR A BASE [10]"
        return
    end
    
    -- Obtener la velocidad configurada (máximo 1000)
    local velocidadElegida = tonumber(speedBox.Text) or 300
    if velocidadElegida <= 0 then velocidadElegida = 50 end
    if velocidadElegida > 1000 then velocidadElegida = 1000 end
    
    enMovimiento = true
    button.BackgroundColor3 = Color3.fromRGB(80, 20, 150)
    titleLabel.Text = "CORRIENDO..."
    
    -- Guardar velocidad anterior y aplicar la velocidad real al humanoide
    local velocidadAnterior = humanoid.WalkSpeed
    humanoid.WalkSpeed = velocidadElegida
    
    local destinoPos = objetivoPart.Position + Vector3.new(0, 3, 0)
    
    -- Bucle de movimiento nativo del Humanoid (:MoveTo) para que el servidor detecte carrera real
    local conexionMovimiento
    conexionMovimiento = RunService.RenderStepped:Connect(function()
        if humanoid and rootPart and objetivoPart then
            humanoid:MoveTo(destinoPos)
            -- Forzar que la velocidad se mantenga activa en cada cuadro contra bloqueos del juego
            humanoid.WalkSpeed = velocidadElegida
        end
    end)
    
    -- Esperar de manera inteligente hasta que el personaje llegue físicamente a la base
    local tiempoEspera = 0
    while (rootPart.Position - destinoPos).Magnitude > 6 and tiempoEspera < 25 do
        task.wait(0.1)
        tiempoEspera = tiempoEspera + 0.1
    end
    
    -- Desconectar el movimiento al llegar
    if conexionMovimiento then
        conexionMovimiento:Disconnect()
    end
    
    humanoid:MoveTo(rootPart.Position) -- Detener la orden de caminar
    
    -- Restaurar la velocidad original del jugador (o dejarla un momento si es necesario)
    task.wait(0.2)
    humanoid.WalkSpeed = velocidadAnterior
    
    enMovimiento = false
    button.BackgroundColor3 = Color3.fromRGB(110, 30, 200)
    titleLabel.Text = "✨ IR A BASE [10]"
end)
