-- Asegurarse de destruir cualquier interfaz anterior con el mismo nombre para evitar duplicados
local ExistingGui = game.CoreGui:FindFirstChild("byppas_Rayfield")
if ExistingGui then
    ExistingGui:Destroy()
end

local ExistingBillboard = workspace:FindFirstChild("byppas_Billboard")
if ExistingBillboard then
    ExistingBillboard:Destroy()
end

-- Cargar la librería Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Crear la ventana principal con el tema "AmberGlow" (Tonos cálidos, café dorado/ámbar elegante)
local Window = Rayfield:CreateWindow({
    Name = "byppas",
    LoadingTitle = "Cargando byppas...",
    LoadingSubtitle = "by byppas",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "byppas_config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinv",
        RememberJoins = true
    },
    KeySystem = false,
    Theme = "AmberGlow", -- Tema cálido/café elegante de Rayfield
})

-- Función para crear el texto encima del personaje (BillboardGui) con estilo estético
local function CreateBillboard()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head", 5)
    
    if head and not head:FindFirstChild("byppas_Billboard") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "byppas_Billboard"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "🧸byppas omega🧸"
        textLabel.TextColor3 = Color3.fromRGB(245, 222, 179) -- Tono trigo/crema brillante
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextStrokeTransparency = 0 -- Borde negro para legibilidad
        textLabel.Parent = billboard
    end
end

-- Activar el Billboard inicial y mantenerlo si el personaje reaparece
CreateBillboard()
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Head", 5)
    CreateBillboard()
end)

-- Crear pestaña principal
local Tab = Window:CreateTab("Scripts", 4483362458)

-- Opción 1: World 4
Tab:CreateButton({
    Name = "World 4",
    Callback = function()
        -- Destruir la interfaz de Rayfield por completo
        Rayfield:Destroy()
        
        -- Ejecutar el script de World 4
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yeremiyashua-maker/Script-/refs/heads/main/Script.lua"))()
    end,
})

-- Opción 2: World 3 (Remueve el título del avatar al ser presionado)
Tab:CreateButton({
    Name = "World 3",
    Callback = function()
        -- Destruir la interfaz de Rayfield por completo
        Rayfield:Destroy()
        
        -- Quitar el título del avatar tal como lo solicitaste
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Head") then
            local billboard = player.Character.Head:FindFirstChild("byppas_Billboard")
            if billboard then
                billboard:Destroy()
            end
        end
        
        -- Ejecutar el script de World 3
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yeremiyashua-maker/Script-/refs/heads/main/Omega.lua"))()
    end,
})

-- Cargar la configuración inicial de la UI
Rayfield:LoadConfiguration()
