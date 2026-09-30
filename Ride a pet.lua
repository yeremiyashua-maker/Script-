-- [[ KYSU HUB - Ride a Pet v1.0V (Precise Real Base Ownership Detection, Visual Debug Line & Fresh Pathfinding Return) ]] --
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables globales de control
_G.AutoSteal = false
_G.AntiAfk = false
_G.EggESP = true
_G.AntiLag = false

local autoStealToken = 0
local activeTween = nil

-- Tabla de multi-selección de Eggs controlada por el usuario
local selectedEggsTable = {}

-- Estados internos blindados para Auto Steal
local autoStealState = "IDLE"
local currentStatusText = "Inactivo / Esperando"
local currentTargetName = "Ninguno"
local currentTargetValue = "N/A"

-- Lista Maestra Exacta del Mejor al Peor (25 Eggs Completos con Rareza y Prioridad)
local MASTER_EGG_CATALOG = {
    ["volcanic egg"] = {Name = "Volcanic Egg", Luck = "2.5T Luck", Rarity = "Ethereal", Priority = 1},
    ["cherub egg"] = {Name = "Cherub Egg", Luck = "1T Luck", Rarity = "Ethereal", Priority = 2},
    ["solaris egg"] = {Name = "Solaris Egg", Luck = "300B Luck", Rarity = "Ethereal", Priority = 3},
    ["blackhole egg"] = {Name = "Blackhole Egg", Luck = "100B Luck", Rarity = "Ethereal", Priority = 4},
    ["bloom egg"] = {Name = "Bloom Egg", Luck = "2B Luck", Rarity = "Divine", Priority = 5},
    ["galaxy egg"] = {Name = "Galaxy Egg", Luck = "1.5B Luck", Rarity = "Divine", Priority = 6},
    ["aurora egg"] = {Name = "Aurora Egg", Luck = "300M Luck", Rarity = "Divine", Priority = 7},
    ["soul egg"] = {Name = "Soul Egg", Luck = "7M Luck", Rarity = "Mythic", Priority = 8},
    ["sinister egg"] = {Name = "Sinister Egg", Luck = "3M Luck", Rarity = "Mythic", Priority = 9},
    ["flaming egg"] = {Name = "Flaming Egg", Luck = "1M Luck", Rarity = "Mythic", Priority = 10},
    ["dominus egg"] = {Name = "Dominus Egg", Luck = "700K Luck", Rarity = "Mythic", Priority = 11},
    ["skull egg"] = {Name = "Skull Egg", Luck = "250K Luck", Rarity = "Mythic", Priority = 12},
    ["crystal egg"] = {Name = "Crystal Egg", Luck = "150K Luck", Rarity = "Mythic", Priority = 13},
    ["golden egg"] = {Name = "Golden Egg", Luck = "30K Luck", Rarity = "Legendary", Priority = 14},
    ["glass egg"] = {Name = "Glass Egg", Luck = "10K Luck", Rarity = "Legendary", Priority = 15},
    ["ice egg"] = {Name = "Ice Egg", Luck = "3K Luck", Rarity = "Epic", Priority = 16},
    ["spime egg"] = {Name = "Spime Egg", Luck = "1K Luck", Rarity = "Epic", Priority = 17},
    ["flower egg"] = {Name = "Flower Egg", Luck = "750 Luck", Rarity = "Epic", Priority = 18},
    ["mushroom egg"] = {Name = "Mushroom Egg", Luck = "500 Luck", Rarity = "Epic", Priority = 19},
    ["leaf egg"] = {Name = "Leaf Egg", Luck = "200 Luck", Rarity = "Rare", Priority = 20},
    ["stone egg"] = {Name = "Stone Egg", Luck = "100 Luck", Rarity = "Rare", Priority = 21},
    ["easter egg"] = {Name = "Easter Egg", Luck = "50 Luck", Rarity = "Rare", Priority = 22},
    ["cracked egg"] = {Name = "Cracked Egg", Luck = "30 Luck", Rarity = "Rare", Priority = 23},
    ["brown egg"] = {Name = "Brown Egg", Luck = "5 Luck", Rarity = "Common", Priority = 24},
    ["white egg"] = {Name = "White Egg", Luck = "1 Luck", Rarity = "Common", Priority = 25}
}

local MASTER_EGG_LIST = {
    {Name = "Volcanic Egg", Luck = "2.5T Luck", Rarity = "Ethereal", Priority = 1},
    {Name = "Cherub Egg", Luck = "1T Luck", Rarity = "Ethereal", Priority = 2},
    {Name = "Solaris Egg", Luck = "300B Luck", Rarity = "Ethereal", Priority = 3},
    {Name = "Blackhole Egg", Luck = "100B Luck", Rarity = "Ethereal", Priority = 4},
    {Name = "Bloom Egg", Luck = "2B Luck", Rarity = "Divine", Priority = 5},
    {Name = "Galaxy Egg", Luck = "1.5B Luck", Rarity = "Divine", Priority = 6},
    {Name = "Aurora Egg", Luck = "300M Luck", Rarity = "Divine", Priority = 7},
    {Name = "Soul Egg", Luck = "7M Luck", Rarity = "Mythic", Priority = 8},
    {Name = "Sinister Egg", Luck = "3M Luck", Rarity = "Mythic", Priority = 9},
    {Name = "Flaming Egg", Luck = "1M Luck", Rarity = "Mythic", Priority = 10},
    {Name = "Dominus Egg", Luck = "700K Luck", Rarity = "Mythic", Priority = 11},
    {Name = "Skull Egg", Luck = "250K Luck", Rarity = "Mythic", Priority = 12},
    {Name = "Crystal Egg", Luck = "150K Luck", Rarity = "Mythic", Priority = 13},
    {Name = "Golden Egg", Luck = "30K Luck", Rarity = "Legendary", Priority = 14},
    {Name = "Glass Egg", Luck = "10K Luck", Rarity = "Legendary", Priority = 15},
    {Name = "Ice Egg", Luck = "3K Luck", Rarity = "Epic", Priority = 16},
    {Name = "Spime Egg", Luck = "1K Luck", Rarity = "Epic", Priority = 17},
    {Name = "Flower Egg", Luck = "750 Luck", Rarity = "Epic", Priority = 18},
    {Name = "Mushroom Egg", Luck = "500 Luck", Rarity = "Epic", Priority = 19},
    {Name = "Leaf Egg", Luck = "200 Luck", Rarity = "Rare", Priority = 20},
    {Name = "Stone Egg", Luck = "100 Luck", Rarity = "Rare", Priority = 21},
    {Name = "Easter Egg", Luck = "50 Luck", Rarity = "Rare", Priority = 22},
    {Name = "Cracked Egg", Luck = "30 Luck", Rarity = "Rare", Priority = 23},
    {Name = "Brown Egg", Luck = "5 Luck", Rarity = "Common", Priority = 24},
    {Name = "White Egg", Luck = "1 Luck", Rarity = "Common", Priority = 25}
}

-- ==========================================
-- CREACIÓN SEGURA DE UI (CONTENEDOR BLINDADO)
-- ==========================================
pcall(function()
    local parentTarget = (gethui and gethui()) or CoreGui
    for _, child in ipairs(parentTarget:GetChildren()) do
        if child.Name == "KysuHubAbsoluteFinal" then
            child:Destroy()
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KysuHubAbsoluteFinal"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local successParent = pcall(function()
    if gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = CoreGui
    end
end)

if not successParent or not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ==========================================
-- BANNER DE BIENVENIDA ORIGINAL KYSUHUB
-- ==========================================
task.spawn(function()
    pcall(function()
        local WelcomeFrame = Instance.new("Frame")
        WelcomeFrame.Name = "WelcomeFrame"
        WelcomeFrame.Parent = ScreenGui
        WelcomeFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
        WelcomeFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        WelcomeFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        WelcomeFrame.Size = UDim2.new(0, 0, 0, 0)
        WelcomeFrame.BackgroundTransparency = 1
        WelcomeFrame.ZIndex = 500

        local wCorner = Instance.new("UICorner")
        wCorner.CornerRadius = UDim.new(0, 14)
        wCorner.Parent = WelcomeFrame

        local wStroke = Instance.new("UIStroke")
        wStroke.Parent = WelcomeFrame
        wStroke.Thickness = 2
        wStroke.Transparency = 1
        wStroke.Color = Color3.fromRGB(180, 110, 255)

        local wGrad = Instance.new("UIGradient")
        wGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 0, 150)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 0, 255)),
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 210, 255))
        })
        wGrad.Parent = wStroke

        local wText = Instance.new("TextLabel")
        wText.Parent = WelcomeFrame
        wText.BackgroundTransparency = 1
        wText.Size = UDim2.new(1, 0, 1, 0)
        wText.ZIndex = 501
        wText.Font = Enum.Font.GothamBold
        wText.Text = "WELCOME TO KYSUHUB"
        wText.TextColor3 = Color3.fromRGB(255, 255, 255)
        wText.TextSize = 16
        wText.TextTransparency = 1
        wText.TextXAlignment = Enum.TextXAlignment.Center

        local twIn = TweenService:Create(WelcomeFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 280, 0, 60),
            BackgroundTransparency = 0.15
        })
        local twTextIn = TweenService:Create(wText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0
        })
        local twStrokeIn = TweenService:Create(wStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 0
        })

        twIn:Play()
        twTextIn:Play()
        twStrokeIn:Play()
        twIn.Completed:Wait()

        task.wait(1.5)

        local twOut = TweenService:Create(WelcomeFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        local twTextOut = TweenService:Create(wText, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            TextTransparency = 1
        })
        local twStrokeOut = TweenService:Create(wStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1
        })

        twOut:Play()
        twTextOut:Play()
        twStrokeOut:Play()
        twOut.Completed:Wait()
        WelcomeFrame:Destroy()
    end)
end)

-- ==========================================
-- HEADER / CÍRCULO FLOTANTE SUPERIOR (ESTILO ORIGINAL KYSUHUB COMPACTO)
-- ==========================================
local MasterTopContainer = Instance.new("Frame")
MasterTopContainer.Name = "MasterTopContainer"
MasterTopContainer.Parent = ScreenGui
MasterTopContainer.BackgroundTransparency = 1
MasterTopContainer.Position = UDim2.new(0.5, -130, 0.04, 0)
MasterTopContainer.Size = UDim2.new(0, 260, 0, 32)
MasterTopContainer.ZIndex = 100

local MainHorizontalBar = Instance.new("Frame")
MainHorizontalBar.Name = "MainHorizontalBar"
MainHorizontalBar.Parent = MasterTopContainer
MainHorizontalBar.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
MainHorizontalBar.BackgroundTransparency = 0.2
MainHorizontalBar.Size = UDim2.new(1, 0, 1, 0)
MainHorizontalBar.ClipsDescendants = true
MainHorizontalBar.ZIndex = 101

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = MainHorizontalBar

local BarStroke = Instance.new("UIStroke")
BarStroke.Parent = MainHorizontalBar
BarStroke.Thickness = 2
BarStroke.Transparency = 0

local BarGradient = Instance.new("UIGradient")
BarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 150)),
    ColorSequenceKeypoint.new(0.30, Color3.fromRGB(255, 140, 0)),
    ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 210, 255)),
    ColorSequenceKeypoint.new(0.85, Color3.fromRGB(150, 0, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 150))
})
BarGradient.Parent = BarStroke

local BarText = Instance.new("TextLabel")
BarText.Parent = MainHorizontalBar
BarText.BackgroundTransparency = 1
BarText.Size = UDim2.new(1, 0, 0, 13)
BarText.Position = UDim2.new(0, 0, 0, 2)
BarText.ZIndex = 105
BarText.Font = Enum.Font.GothamBold
BarText.Text = "KYSU HUB"
BarText.TextColor3 = Color3.fromRGB(255, 255, 255)
BarText.TextSize = 10
BarText.TextXAlignment = Enum.TextXAlignment.Center

local SubBarText = Instance.new("TextLabel")
SubBarText.Parent = MainHorizontalBar
SubBarText.BackgroundTransparency = 1
SubBarText.Size = UDim2.new(1, 0, 0, 15)
SubBarText.Position = UDim2.new(0, 0, 0, 15)
SubBarText.ZIndex = 105
SubBarText.Font = Enum.Font.GothamMedium
SubBarText.Text = "Ride a Pet | v1.0V (Haz clic para abrir)"
SubBarText.TextColor3 = Color3.fromRGB(210, 160, 255)
SubBarText.TextSize = 8
SubBarText.TextXAlignment = Enum.TextXAlignment.Center

local TouchButton = Instance.new("TextButton")
TouchButton.Name = "TouchButton"
TouchButton.Parent = MasterTopContainer
TouchButton.BackgroundTransparency = 1
TouchButton.Size = UDim2.new(1, 0, 1, 0)
TouchButton.AutoButtonColor = false
TouchButton.Text = ""
TouchButton.ZIndex = 110

-- ==========================================
-- MENÚ PRINCIPAL (ESTILO ORIGINAL RESTAURADO EN TAMAÑO MINI/COMPACTO)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -135)
MainFrame.Size = UDim2.new(0, 340, 0, 270)
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 200

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Thickness = 1.8
MainStroke.Color = Color3.fromRGB(140, 70, 220)

local GalaxyGradient = Instance.new("UIGradient")
GalaxyGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(50, 15, 85)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(22, 10, 40)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(6, 4, 12))
})
GalaxyGradient.Rotation = 90
GalaxyGradient.Parent = MainFrame

-- ==========================================
-- HEADER INTERNO
-- ==========================================
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
Header.Size = UDim2.new(1, 0, 0, 44)
Header.ZIndex = 205

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Parent = Header
HeaderStroke.Color = Color3.fromRGB(70, 35, 110)
HeaderStroke.Thickness = 1

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Parent = Header
AvatarImg.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
AvatarImg.Position = UDim2.new(0, 10, 0.5, -14)
AvatarImg.Size = UDim2.new(0, 28, 0, 28)
AvatarImg.ZIndex = 206

task.spawn(function()
    pcall(function()
        AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    end)
end)

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImg

local NameLabel = Instance.new("TextLabel")
NameLabel.Parent = Header
NameLabel.BackgroundTransparency = 1
NameLabel.Position = UDim2.new(0, 46, 0, 7)
NameLabel.Size = UDim2.new(0, 200, 0, 15)
NameLabel.ZIndex = 206
NameLabel.Font = Enum.Font.GothamBold
NameLabel.Text = LocalPlayer.Name
NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLabel.TextSize = 11
NameLabel.TextXAlignment = Enum.TextXAlignment.Left

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Parent = Header
StatsLabel.BackgroundTransparency = 1
StatsLabel.Position = UDim2.new(0, 46, 0, 22)
StatsLabel.Size = UDim2.new(0, 200, 0, 14)
StatsLabel.ZIndex = 206
StatsLabel.Font = Enum.Font.GothamMedium
StatsLabel.TextColor3 = Color3.fromRGB(190, 160, 230)
StatsLabel.TextSize = 9
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    pcall(function()
        local lastUpdate = tick()
        local frames = 0
        RunService.RenderStepped:Connect(function()
            frames += 1
            if tick() - lastUpdate >= 1 then
                local fps = math.floor(frames / (tick() - lastUpdate))
                StatsLabel.Text = "FPS: " .. fps .. " | Ride a Pet"
                frames = 0
                lastUpdate = tick()
            end
        end)
    end)
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 18, 40)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -12)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.ZIndex = 206
CloseBtn.AutoButtonColor = false
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
CloseBtn.TextSize = 12

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

local isMenuOpen = false
local isAnimating = false

local function toggleMenu(openState)
    if isAnimating then return end
    isAnimating = true
    isMenuOpen = openState
    
    if isMenuOpen then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        local tw = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 340, 0, 270),
            Position = UDim2.new(0.5, -170, 0.5, -135)
        })
        tw:Play()
        tw.Completed:Connect(function() isAnimating = false end)
    else
        local tw = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        tw:Play()
        tw.Completed:Connect(function()
            if not isMenuOpen then MainFrame.Visible = false end
            isAnimating = false
        end)
    end
end

CloseBtn.MouseButton1Click:Connect(function() toggleMenu(false) end)

-- ==========================================
-- PESTAÑAS (MAIN A LA IZQUIERDA | MUTATION VACÍA)
-- ==========================================
local TabsBar = Instance.new("Frame")
TabsBar.Parent = MainFrame
TabsBar.BackgroundColor3 = Color3.fromRGB(12, 8, 22)
TabsBar.Position = UDim2.new(0, 10, 0, 52)
TabsBar.Size = UDim2.new(0, 90, 1, -60)
TabsBar.ZIndex = 205

local TabsCorner = Instance.new("UICorner")
TabsCorner.CornerRadius = UDim.new(0, 8)
TabsCorner.Parent = TabsBar

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.Parent = TabsBar
TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabsLayout.Padding = UDim.new(0, 4)
TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local PagesContainer = Instance.new("Frame")
PagesContainer.Parent = MainFrame
PagesContainer.BackgroundTransparency = 1
PagesContainer.Position = UDim2.new(0, 106, 0, 52)
PagesContainer.Size = UDim2.new(1, -114, 1, -60)
PagesContainer.ZIndex = 205

local tabNames = {"Main", "Mutation"}
local pageFrames = {}

for i, tName in ipairs(tabNames) do
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = TabsBar
    TabBtn.BackgroundColor3 = Color3.fromRGB(22, 16, 40)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 28)
    TabBtn.ZIndex = 206
    TabBtn.AutoButtonColor = false
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.Text = tName:upper()
    TabBtn.TextColor3 = Color3.fromRGB(190, 160, 230)
    TabBtn.TextSize = 10
    TabBtn.LayoutOrder = i
    
    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 6)
    TabBtnCorner.Parent = TabBtn
    
    local Page = Instance.new("ScrollingFrame")
    Page.Name = tName .. "Page"
    Page.Parent = PagesContainer
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = (i == 1)
    Page.ZIndex = 206
    Page.CanvasSize = UDim2.new(0, 0, 2.5, 0)
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(210, 160, 255)
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 6)
    
    pageFrames[tName] = Page
    
    TabBtn.MouseButton1Click:Connect(function()
        pcall(function()
            for name, p in pairs(pageFrames) do p.Visible = (name == tName) end
            for _, child in ipairs(TabsBar:GetChildren()) do
                if child:IsA("TextButton") then
                    TweenService:Create(child, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 16, 40), TextColor3 = Color3.fromRGB(190, 160, 230)}):Play()
                end
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 110, 255), TextColor3 = Color3.fromRGB(12, 8, 22)}):Play()
        end)
    end)
    
    if i == 1 then
        TabBtn.BackgroundColor3 = Color3.fromRGB(180, 110, 255)
        TabBtn.TextColor3 = Color3.fromRGB(12, 8, 22)
    end
end

-- ==========================================
-- CACHÉ CENTRAL Y DETECCIÓN EXHAUSTIVA DE LA BASE REAL DEL JUGADOR
-- ==========================================
local eggDetectionCache = {}
local cachedMyBase = nil
local lastBaseSearchTick = 0

local function findMyBaseSecurely()
    if cachedMyBase and cachedMyBase.Parent then return cachedMyBase end
    if tick() - lastBaseSearchTick < 3 and cachedMyBase then return cachedMyBase end
    lastBaseSearchTick = tick()

    local baseObj = nil
    local playerName = LocalPlayer.Name:lower()
    local playerIdStr = tostring(LocalPlayer.UserId)

    pcall(function()
        currentStatusText = "Buscando mi base..."
        local roots = {}
        local plotsFolder = workspace:FindFirstChild("Plots")
        if plotsFolder then table.insert(roots, plotsFolder) end
        local basesFolder = workspace:FindFirstChild("Bases")
        if basesFolder then table.insert(roots, basesFolder) end
        if #roots == 0 then table.insert(roots, workspace) end

        for _, root in ipairs(roots) do
            for _, plot in ipairs(root:GetChildren()) do
                local pNameL = plot.Name:lower()

                -- 1. Coincidencia directa por Nombre o UserId en el nombre del objeto Plot/Base
                if pNameL == playerName or pNameL:find(playerName) or pNameL == playerIdStr or pNameL:find(playerIdStr) then
                    baseObj = plot
                    break
                end

                -- 2. Atributos de propiedad (Owner, Player, UserId, Creator)
                local okAttr, ownerVal = pcall(function()
                    return plot:GetAttribute("Owner") or plot:GetAttribute("Player") or plot:GetAttribute("UserId") or plot:GetAttribute("Creator")
                end)
                if okAttr and ownerVal then
                    local ownerStr = tostring(ownerVal):lower()
                    if ownerStr == playerName or ownerStr == playerIdStr then
                        baseObj = plot
                        break
                    end
                end

                -- 3. Hijos internos (ObjectValue, StringValue, IntValue, BoolValue o sub-carpetas)
                for _, child in ipairs(plot:GetDescendants()) do
                    if child:IsA("ObjectValue") and child.Value == LocalPlayer then
                        baseObj = plot
                        break
                    elseif child:IsA("StringValue") or child:IsA("IntValue") then
                        local cNameL = child.Name:lower()
                        if cNameL == "owner" or cNameL == "player" or cNameL == "userid" or cNameL == "creator" then
                            local valStr = tostring(child.Value):lower()
                            if valStr == playerName or valStr == playerIdStr then
                                baseObj = plot
                                break
                            end
                        end
                    end
                end
                if baseObj then break end
            end
            if baseObj then break end
        end
    end)

    if baseObj then
        cachedMyBase = baseObj
        warn("[KYSU] Mi base encontrada:", baseObj:GetFullName())
        currentStatusText = "Base encontrada: " .. baseObj.Name
    else
        warn("[KYSU] No se encontró mi base")
        currentStatusText = "Buscando mi base..."
    end

    return baseObj
end

local function getBasePosition(baseObj)
    if not baseObj then return nil end
    local pos = nil
    pcall(function()
        if baseObj:IsA("BasePart") then
            pos = baseObj.Position
        elseif baseObj:IsA("Model") then
            if baseObj.PrimaryPart then
                pos = baseObj.PrimaryPart.Position
            else
                local ok, pivotPos = pcall(function() return baseObj:GetPivot().Position end)
                if ok and pivotPos then
                    pos = pivotPos
                else
                    local part = baseObj:FindFirstChildWhichIsA("BasePart", true)
                    if part then pos = part.Position end
                end
            end
        end
    end)
    if pos then
        warn("[KYSU] Base position:", pos)
    end
    return pos
end

local function isEggRobable(obj)
    if not obj or not obj.Parent then return false end
    local current = obj
    local insideOtherPlot = false
    local insideMyPlot = false
    local myBase = findMyBaseSecurely()

    while current and current ~= workspace and current ~= game do
        if current.Parent and (current.Parent.Name == "Plots" or current.Parent.Name == "Bases") then
            if myBase and current == myBase then
                insideMyPlot = true
            else
                insideOtherPlot = true
            end
            break
        end
        if myBase and current == myBase then
            insideMyPlot = true
            break
        end
        current = current.Parent
    end

    if insideOtherPlot or insideMyPlot then return false end
    return true
end

local function getPartPosition(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then
        return obj.Position
    elseif obj:IsA("Model") then
        if obj.PrimaryPart then return obj.PrimaryPart.Position end
        local ok, pos = pcall(function() return obj:GetPivot().Position end)
        if ok and pos then return pos end
        local part = obj:FindFirstChildWhichIsA("BasePart", true)
        if part then return part.Position end
    end
    return nil
end

local function identifyEggModel(obj)
    if not obj then return nil end
    local current = obj
    while current and current ~= workspace and current ~= game do
        local nameL = current.Name:lower()
        for catalogKey, info in pairs(MASTER_EGG_CATALOG) do
            if nameL == catalogKey or nameL:find(catalogKey) then
                return info, current
            end
        end
        current = current.Parent
    end
    return nil
end

local function registerEggObject(obj)
    pcall(function()
        local eggInfo, realTarget = identifyEggModel(obj)
        if eggInfo and realTarget and not eggDetectionCache[realTarget] then
            local pos = getPartPosition(realTarget)
            if pos then
                local robable = isEggRobable(realTarget)
                if robable then
                    eggDetectionCache[realTarget] = {
                        Object = realTarget,
                        Name = eggInfo.Name,
                        Luck = eggInfo.Luck,
                        Rarity = eggInfo.Rarity,
                        Priority = eggInfo.Priority,
                        Position = pos,
                        Robable = robable
                    }
                end
            end
        end
    end)
end

local function initEggDetectionSystem()
    pcall(function()
        local searchRoots = {}
        local plots = workspace:FindFirstChild("Plots")
        if plots then table.insert(searchRoots, plots) end
        local renderedEggs = workspace:FindFirstChild("RenderedEggs")
        if renderedEggs then table.insert(searchRoots, renderedEggs) end
        local prePlotEggs = workspace:FindFirstChild("Pre Plot Eggs")
        if prePlotEggs then table.insert(searchRoots, prePlotEggs) end

        if #searchRoots == 0 then
            table.insert(searchRoots, workspace)
        end

        for _, root in ipairs(searchRoots) do
            for _, obj in ipairs(root:GetDescendants()) do
                registerEggObject(obj)
            end
            root.DescendantAdded:Connect(function(descendant)
                registerEggObject(descendant)
            end)
            root.DescendantRemoving:Connect(function(descendant)
                if eggDetectionCache[descendant] then
                    eggDetectionCache[descendant] = nil
                end
            end)
        end
    end)
end

task.spawn(initEggDetectionSystem)

-- ==========================================
-- SISTEMA DE INTERACCIÓN REAL Y COMPROBACIÓN DE GRAB ROBUSTA
-- ==========================================
local function verifyAndPerformEggGrab(eggObj)
    if not eggObj or not eggObj.Parent then return false end
    local grabbedSuccess = false

    pcall(function()
        local prompt = eggObj:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt then
            fireproximityprompt(prompt)
            task.wait(0.05)
            grabbedSuccess = true
        end

        local clickDet = eggObj:FindFirstChildWhichIsA("ClickDetector", true)
        if clickDet then
            fireclickdetector(clickDet)
            task.wait(0.05)
            grabbedSuccess = true
        end

        local part = eggObj:IsA("BasePart") and eggObj or eggObj:FindFirstChildWhichIsA("BasePart", true)
        if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 0)
            task.wait(0.05)
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 1)
            task.wait(0.05)
            grabbedSuccess = true
        end
    end)

    return grabbedSuccess
end

local function cancelActiveTween()
    if activeTween then
        pcall(function() activeTween:Cancel() end)
        activeTween = nil
    end
end

-- ==========================================
-- LÍNEA VISUAL DE DEBUG Y PATHFINDING DE REGRESO
-- ==========================================
local debugBeamPart = nil

local function createDebugLineToTarget(startPos, endPos)
    pcall(function()
        if debugBeamPart then debugBeamPart:Destroy() end
        debugBeamPart = Instance.new("Part")
        debugBeamPart.Name = "KysuDebugBeam"
        debugBeamPart.Anchored = true
        debugBeamPart.CanCollide = false
        debugBeamPart.Transparency = 0.3
        debugBeamPart.Color = Color3.fromRGB(0, 255, 255)
        debugBeamPart.Material = Enum.Material.Neon
        
        local distance = (startPos - endPos).Magnitude
        debugBeamPart.Size = Vector3.new(0.2, 0.2, distance)
        debugBeamPart.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -distance / 2)
        debugBeamPart.Parent = workspace
        
        task.delay(5, function()
            if debugBeamPart then
                debugBeamPart:Destroy()
                debugBeamPart = nil
            end
        end)
    end)
end

local function navigateWithPathfinding(targetPosition)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return false end
    local hrp = char.HumanoidRootPart
    local humanoid = char.Humanoid

    -- CREAR PATH NUEVO SIN REUTILIZAR CACHÉ VIEJA
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true
    })
    
    local success, err = pcall(function()
        path:ComputeAsync(hrp.Position, targetPosition)
    end)
    
    if not success or path.Status ~= Enum.PathStatus.Success then
        warn("[KYSU] Pathfinding failed:", path.Status)
        humanoid:MoveTo(targetPosition)
        return true
    end

    local waypoints = path:GetWaypoints()
    for _, waypoint in ipairs(waypoints) do
        if not _G.AutoSteal then return false end
        if waypoint.Action == Enum.PathWaypointAction.Jump then humanoid.Jump = true end
        humanoid:MoveTo(waypoint.Position)
        local reached = false
        local conn
        conn = humanoid.MoveToFinished:Connect(function() reached = true; if conn then conn:Disconnect() end end)
        local timeout = tick() + 3
        while not reached and tick() < timeout and _G.AutoSteal do
            if (hrp.Position - waypoint.Position).Magnitude < 4 then break end
            task.wait(0.05)
        end
        if conn then conn:Disconnect() end
    end
    return true
end

-- ==========================================
-- SECUENCIA OBLIGATORIA DE AUTO STEAL
-- ==========================================
local function runAutoStealLoop(token)
    while _G.AutoSteal and autoStealToken == token do
        task.wait(0.4)
        pcall(function()
            local anySelected = false
            for _, _ in pairs(selectedEggsTable) do
                anySelected = true
                break
            end

            if not anySelected then
                currentStatusText = "0 Eggs seleccionados (Inactivo)"
                task.wait(1)
                return
            end

            if autoStealState ~= "IDLE" and autoStealState ~= "SEARCHING_EGG" then return end
            autoStealState = "SEARCHING_EGG"
            currentStatusText = "Buscando eggs..."

            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

            local targetEggData = nil
            local highestPriority = 9999

            for _, eggData in pairs(eggDetectionCache) do
                if eggData.Object and eggData.Object.Parent and eggData.Robable then
                    if selectedEggsTable[eggData.Name] == true then
                        if eggData.Priority < highestPriority then
                            highestPriority = eggData.Priority
                            targetEggData = eggData
                        end
                    end
                end
            end

            if not targetEggData then
                currentStatusText = "Esperando eggs seleccionados..."
                task.wait(1)
                return
            end

            currentTargetName = targetEggData.Name
            currentTargetValue = targetEggData.Luck

            local eggPos = getPartPosition(targetEggData.Object)
            if eggPos and _G.AutoSteal and autoStealToken == token then
                local hrp = char.HumanoidRootPart
                autoStealState = "GOING_TO_EGG"
                currentStatusText = "Yendo al egg..."

                cancelActiveTween()
                activeTween = TweenService:Create(hrp, TweenInfo.new(math.clamp((hrp.Position - eggPos).Magnitude / 65, 0.4, 3.0), Enum.EasingStyle.Linear), {CFrame = CFrame.new(eggPos + Vector3.new(0, 3, 0))})
                activeTween:Play()
                activeTween.Completed:Wait()

                if not _G.AutoSteal or autoStealToken ~= token then return end

                autoStealState = "GRABBING_EGG"
                currentStatusText = "Quedándose en el egg e intentando agarrar..."
                
                local confirmedGrab = false
                while _G.AutoSteal and autoStealToken == token and targetEggData.Object and targetEggData.Object.Parent do
                    confirmedGrab = verifyAndPerformEggGrab(targetEggData.Object)
                    if confirmedGrab then
                        task.wait(0.15)
                        if not targetEggData.Object.Parent or (getPartPosition(targetEggData.Object) == nil) then
                            break
                        end
                    end
                    task.wait(0.25)
                end

                if not _G.AutoSteal or autoStealToken ~= token then return end

                cancelActiveTween()

                autoStealState = "GOING_TO_COORDINATE"
                currentStatusText = "Yendo a coordenada exacta..."
                local targetCoord = Vector3.new(140.45, 40316.43, 923.19)
                hrp.CFrame = CFrame.new(targetCoord)
                task.wait(0.3)

                -- DESPUÉS DEL TP, DETECTAR BASE REAL, MOSTRAR LÍNEA VISUAL Y CAMINAR POR PATHFINDING
                autoStealState = "RETURNING_TO_BASE"
                currentStatusText = "Buscando mi base..."
                
                local baseObj = nil
                while not baseObj and _G.AutoSteal and autoStealToken == token do
                    baseObj = findMyBaseSecurely()
                    if not baseObj then
                        task.wait(0.5)
                    end
                end

                if baseObj and _G.AutoSteal and autoStealToken == token then
                    local basePos = getBasePosition(baseObj)
                    if basePos then
                        currentStatusText = "Regresando a mi base..."
                        createDebugLineToTarget(hrp.Position, basePos)
                        
                        -- Reiniciar caché de waypoints locales para forzar cálculo fresco
                        local successPath = navigateWithPathfinding(basePos)
                        if successPath then
                            currentStatusText = "Base alcanzada"
                            task.wait(0.5)
                        end
                    end
                end

                autoStealState = "SEARCHING_EGG"
            end
        end)
    end
end

-- ==========================================
-- ESP LIGERO CONSUMIENDO CACHÉ
-- ==========================================
task.spawn(function()
    local activeDrawings = {}
    local rarityColors = {
        ["Ethereal"] = Color3.fromRGB(255, 50, 255),
        ["Divine"] = Color3.fromRGB(0, 180, 255),
        ["Mythic"] = Color3.fromRGB(255, 80, 0),
        ["Legendary"] = Color3.fromRGB(255, 200, 0),
        ["Epic"] = Color3.fromRGB(150, 0, 255),
        ["Rare"] = Color3.fromRGB(0, 120, 255),
        ["Common"] = Color3.fromRGB(180, 180, 180)
    }

    while true do
        if not _G.EggESP then
            for obj, drawing in pairs(activeDrawings) do
                if drawing then drawing.Visible = false; drawing:Remove() end
            end
            activeDrawings = {}
            task.wait(0.5)
        else
            pcall(function()
                local presentObjectsMap = {}
                for _, eData in pairs(eggDetectionCache) do
                    local obj = eData.Object
                    if obj and obj.Parent then
                        presentObjectsMap[obj] = eData
                        if not activeDrawings[obj] then
                            local textDraw = Drawing.new("Text")
                            textDraw.Visible = false
                            textDraw.Center = true
                            textDraw.Outline = true
                            textDraw.Size = 13
                            activeDrawings[obj] = textDraw
                        end
                        local drawing = activeDrawings[obj]
                        local pos = getPartPosition(obj)
                        if drawing and pos then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(pos + Vector3.new(0, 3, 0))
                            if onScreen then
                                drawing.Position = Vector2.new(screenPos.X, screenPos.Y)
                                drawing.Text = eData.Name .. "  " .. eData.Luck
                                drawing.Color = rarityColors[eData.Rarity] or Color3.fromRGB(255, 255, 255)
                                drawing.Visible = true
                            else
                                drawing.Visible = false
                            end
                        end
                    end
                end
                for obj, drawing in pairs(activeDrawings) do
                    if not presentObjectsMap[obj] or not obj.Parent then
                        if drawing then drawing.Visible = false; drawing:Remove() end
                        activeDrawings[obj] = nil
                    end
                end
            end)
            task.wait(0.3)
        end
    end
end)

-- ==========================================
-- CONSTRUCCIÓN DE CONTROLES EN MAIN PAGE (ESTILO ORIGINAL COMPACTO)
-- ==========================================
local mainPage = pageFrames["Main"]
if mainPage then
    local optionFrame = Instance.new("Frame")
    optionFrame.Parent = mainPage
    optionFrame.BackgroundColor3 = Color3.fromRGB(24, 18, 42)
    optionFrame.Size = UDim2.new(1, -6, 0, 42)
    optionFrame.ZIndex = 210

    local optCorner = Instance.new("UICorner")
    optCorner.CornerRadius = UDim.new(0, 8)
    optCorner.Parent = optionFrame

    local optStroke = Instance.new("UIStroke")
    optStroke.Parent = optionFrame
    optStroke.Color = Color3.fromRGB(80, 40, 130)
    optStroke.Thickness = 1

    local optLabel = Instance.new("TextLabel")
    optLabel.Parent = optionFrame
    optLabel.BackgroundTransparency = 1
    optLabel.Position = UDim2.new(0, 12, 0, 0)
    optLabel.Size = UDim2.new(0.6, 0, 1, 0)
    optLabel.ZIndex = 211
    optLabel.Font = Enum.Font.GothamBold
    optLabel.Text = "Auto Steal"
    optLabel.TextColor3 = Color3.fromRGB(245, 230, 255)
    optLabel.TextSize = 12
    optLabel.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = optionFrame
    toggleBtn.BackgroundColor3 = Color3.fromRGB(12, 8, 22)
    toggleBtn.Position = UDim2.new(1, -70, 0.5, -12)
    toggleBtn.Size = UDim2.new(0, 58, 0, 24)
    toggleBtn.ZIndex = 211
    toggleBtn.AutoButtonColor = false
    toggleBtn.Text = ""

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn

    local circle = Instance.new("Frame")
    circle.Parent = toggleBtn
    circle.BackgroundColor3 = Color3.fromRGB(180, 140, 220)
    circle.Position = UDim2.new(0, 3, 0.5, -9)
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.ZIndex = 212

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = circle

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = toggleBtn
    statusLabel.BackgroundTransparency = 1
    statusLabel.Size = UDim2.new(1, 0, 1, 0)
    statusLabel.ZIndex = 213
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Text = "OFF"
    statusLabel.TextColor3 = Color3.fromRGB(180, 150, 200)
    statusLabel.TextSize = 9

    toggleBtn.MouseButton1Click:Connect(function()
        _G.AutoSteal = not _G.AutoSteal
        autoStealToken = autoStealToken + 1
        if _G.AutoSteal then
            statusLabel.Text = "ON"
            statusLabel.TextColor3 = Color3.fromRGB(12, 8, 22)
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Color3.fromRGB(12, 8, 22)}):Play()
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 110, 255)}):Play()
            task.spawn(function() runAutoStealLoop(autoStealToken) end)
        else
            statusLabel.Text = "OFF"
            statusLabel.TextColor3 = Color3.fromRGB(180, 150, 200)
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(180, 140, 220)}):Play()
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(12, 8, 22)}):Play()
            cancelActiveTween()
            autoStealState = "IDLE"
        end
    end)

    local selectEggsHeader = Instance.new("TextLabel")
    selectEggsHeader.Parent = mainPage
    selectEggsHeader.BackgroundTransparency = 1
    selectEggsHeader.Size = UDim2.new(1, -6, 0, 24)
    selectEggsHeader.ZIndex = 210
    selectEggsHeader.Font = Enum.Font.GothamBold
    selectEggsHeader.Text = "✨ SELECT EGGS (25) ✨"
    selectEggsHeader.TextColor3 = Color3.fromRGB(210, 160, 255)
    selectEggsHeader.TextSize = 11
    selectEggsHeader.TextXAlignment = Enum.TextXAlignment.Center

    local selectorScrollContainer = Instance.new("ScrollingFrame")
    selectorScrollContainer.Parent = mainPage
    selectorScrollContainer.BackgroundColor3 = Color3.fromRGB(18, 12, 30)
    selectorScrollContainer.Size = UDim2.new(1, -6, 0, 150)
    selectorScrollContainer.ZIndex = 210
    selectorScrollContainer.CanvasSize = UDim2.new(0, 0, 0, (25 * 38) + 12)
    selectorScrollContainer.ScrollBarThickness = 2
    selectorScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(180, 110, 255)

    local selScrollCorner = Instance.new("UICorner")
    selScrollCorner.CornerRadius = UDim.new(0, 8)
    selScrollCorner.Parent = selectorScrollContainer

    local selScrollStroke = Instance.new("UIStroke")
    selScrollStroke.Parent = selectorScrollContainer
    selScrollStroke.Color = Color3.fromRGB(80, 40, 130)
    selScrollStroke.Thickness = 1

    local selLayout = Instance.new("UIListLayout")
    selLayout.Parent = selectorScrollContainer
    selLayout.SortOrder = Enum.SortOrder.LayoutOrder
    selLayout.Padding = UDim.new(0, 5)
    selLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    for _, eInfo in ipairs(MASTER_EGG_LIST) do
        local eggRow = Instance.new("Frame")
        eggRow.Parent = selectorScrollContainer
        eggRow.BackgroundColor3 = Color3.fromRGB(24, 16, 40)
        eggRow.Size = UDim2.new(1, -10, 0, 34)
        eggRow.ZIndex = 211

        local erC = Instance.new("UICorner")
        erC.CornerRadius = UDim.new(0, 6)
        erC.Parent = eggRow

        local erStroke = Instance.new("UIStroke")
        erStroke.Parent = eggRow
        erStroke.Color = Color3.fromRGB(50, 30, 80)
        erStroke.Thickness = 1

        local eNameLbl = Instance.new("TextLabel")
        eNameLbl.Parent = eggRow
        eNameLbl.BackgroundTransparency = 1
        eNameLbl.Position = UDim2.new(0, 10, 0, 2)
        eNameLbl.Size = UDim2.new(0.65, 0, 0, 15)
        eNameLbl.ZIndex = 212
        eNameLbl.Font = Enum.Font.GothamBold
        eNameLbl.Text = "🥚 " .. eInfo.Name
        eNameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        eNameLbl.TextSize = 10
        eNameLbl.TextXAlignment = Enum.TextXAlignment.Left

        local eSubLbl = Instance.new("TextLabel")
        eSubLbl.Parent = eggRow
        eSubLbl.BackgroundTransparency = 1
        eSubLbl.Position = UDim2.new(0, 10, 0, 17)
        eSubLbl.Size = UDim2.new(0.65, 0, 0, 14)
        eSubLbl.ZIndex = 212
        eSubLbl.Font = Enum.Font.GothamMedium
        eSubLbl.Text = eInfo.Luck .. " • " .. string.upper(eInfo.Rarity)
        eSubLbl.TextColor3 = Color3.fromRGB(190, 150, 230)
        eSubLbl.TextSize = 8
        eSubLbl.TextXAlignment = Enum.TextXAlignment.Left

        local checkBtn = Instance.new("TextButton")
        checkBtn.Parent = eggRow
        checkBtn.BackgroundColor3 = Color3.fromRGB(12, 8, 22)
        checkBtn.Position = UDim2.new(1, -30, 0.5, -9)
        checkBtn.Size = UDim2.new(0, 18, 0, 18)
        checkBtn.ZIndex = 212
        checkBtn.AutoButtonColor = false
        checkBtn.Text = ""

        local cbC = Instance.new("UICorner")
        cbC.CornerRadius = UDim.new(0, 4)
        cbC.Parent = checkBtn

        local checkMark = Instance.new("TextLabel")
        checkMark.Parent = checkBtn
        checkMark.BackgroundTransparency = 1
        checkMark.Size = UDim2.new(1, 0, 1, 0)
        checkMark.ZIndex = 213
        checkMark.Font = Enum.Font.GothamBold
        checkMark.Text = "✓"
        checkMark.TextColor3 = Color3.fromRGB(12, 8, 22)
        checkMark.TextSize = 10
        checkMark.Visible = false

        checkBtn.MouseButton1Click:Connect(function()
            if selectedEggsTable[eInfo.Name] then
                selectedEggsTable[eInfo.Name] = nil
                checkMark.Visible = false
                TweenService:Create(checkBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(12, 8, 22)}):Play()
                TweenService:Create(erStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(50, 30, 80)}):Play()
            else
                selectedEggsTable[eInfo.Name] = true
                checkMark.Visible = true
                TweenService:Create(checkBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(100, 255, 120)}):Play()
                TweenService:Create(erStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(180, 110, 255)}):Play()
            end
        end)
    end
end

-- ==========================================
-- ARRASTRE Y APERTURA DEL BOTÓN FLOTANTE
-- ==========================================
pcall(function()
    local dragging = false
    local touchBeganPos = Vector2.new(0, 0)
    local initialContainerPos = UDim2.new(0, 0, 0, 0)
    local maxDragDistance = 0
    local activeInputObject = nil

    TouchButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            activeInputObject = input
            touchBeganPos = input.Position
            initialContainerPos = MasterTopContainer.Position
            maxDragDistance = 0
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == activeInputObject then
            local currentPos = input.Position
            local delta = Vector2.new(currentPos.X, currentPos.Y) - touchBeganPos
            maxDragDistance = delta.Magnitude
            MasterTopContainer.Position = UDim2.new(initialContainerPos.X.Scale, initialContainerPos.X.Offset + delta.X, initialContainerPos.Y.Scale, initialContainerPos.Y.Offset + delta.Y)
        end
    end)

    local function handleEnd(input)
        if dragging and input == activeInputObject then
            if maxDragDistance < 15 then toggleMenu(not isMenuOpen) end
            dragging = false
            activeInputObject = nil
        end
    end

    UserInputService.InputEnded:Connect(handleEnd)
    TouchButton.InputEnded:Connect(handleEnd)
end)
