-- [[ Kysu Hub - Ultimate Masterpiece Edition v38 (Fixed: Opaque black coin box, normal solid white text, strict 61-stud murderer escape with exact slider speed, and optimized compact Discord tab size) ]] --
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Variables globales de estado compartidas
local walkSpeedValue = 16
local isWalkSpeedActive = false
local jumpPowerValue = 50
local isJumpPowerActive = false

-- ==========================================
-- 1. VENTANA DE DISCORD INICIAL (SÚPER DECORADA, HERMOSA Y CONECTADA)
-- ==========================================
local DiscordGui = Instance.new("ScreenGui")
DiscordGui.Name = "KysuHubDiscordGui"
pcall(function()
    if gethui then DiscordGui.Parent = gethui() else DiscordGui.Parent = CoreGui end
end)
if not DiscordGui.Parent then DiscordGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
DiscordGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
DiscordGui.IgnoreGuiInset = true

local DiscordHolder = Instance.new("Frame")
DiscordHolder.Parent = DiscordGui
DiscordHolder.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
DiscordHolder.BackgroundTransparency = 0.1
DiscordHolder.AnchorPoint = Vector2.new(0.5, 0.5)
DiscordHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
DiscordHolder.Size = UDim2.new(0, 480, 0, 290)
DiscordHolder.ZIndex = 100
DiscordHolder.ClipsDescendants = true

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 18)
DiscordCorner.Parent = DiscordHolder

local DiscordStroke = Instance.new("UIStroke")
DiscordStroke.Parent = DiscordHolder
DiscordStroke.Thickness = 3
DiscordStroke.Transparency = 0

local DiscordGradient = Instance.new("UIGradient")
DiscordGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 80)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 60, 0)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 80))
})
DiscordGradient.Parent = DiscordStroke

task.spawn(function()
    pcall(function()
        while task.wait(0.04) do
            for i = 0, 1, 0.02 do
                DiscordGradient.Offset = Vector2.new(i, 0)
                task.wait(0.04)
            end
        end
    end)
end)

local InnerGlow = Instance.new("Frame")
InnerGlow.Parent = DiscordHolder
InnerGlow.BackgroundColor3 = Color3.fromRGB(30, 12, 12)
InnerGlow.BackgroundTransparency = 0.4
InnerGlow.Size = UDim2.new(1, 0, 1, 0)
InnerGlow.ZIndex = 100

local InnerDiscordBox = Instance.new("Frame")
InnerDiscordBox.Parent = DiscordHolder
InnerDiscordBox.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
InnerDiscordBox.Position = UDim2.new(0, 20, 0, 20)
InnerDiscordBox.Size = UDim2.new(0, 84, 0, 84)
InnerDiscordBox.ZIndex = 101

local IDBoxCorner = Instance.new("UICorner")
IDBoxCorner.CornerRadius = UDim.new(0, 12)
IDBoxCorner.Parent = InnerDiscordBox

local IDBoxStroke = Instance.new("UIStroke")
IDBoxStroke.Parent = InnerDiscordBox
IDBoxStroke.Color = Color3.fromRGB(255, 80, 80)
IDBoxStroke.Thickness = 1.5

local DiscordAvatar = Instance.new("ImageLabel")
DiscordAvatar.Parent = InnerDiscordBox
DiscordAvatar.BackgroundTransparency = 1
DiscordAvatar.Position = UDim2.new(0.5, -32, 0.5, -32)
DiscordAvatar.Size = UDim2.new(0, 64, 0, 64)
DiscordAvatar.ZIndex = 102
DiscordAvatar.Image = "rbxassetid://72421786676251"

local DAICorner = Instance.new("UICorner")
DAICorner.CornerRadius = UDim.new(0, 10)
DAICorner.Parent = DiscordAvatar

local MembersLabel = Instance.new("TextLabel")
MembersLabel.Parent = DiscordHolder
MembersLabel.BackgroundTransparency = 1
MembersLabel.Position = UDim2.new(0, 118, 0, 22)
MembersLabel.Size = UDim2.new(0, 340, 0, 24)
MembersLabel.ZIndex = 101
MembersLabel.Font = Enum.Font.GothamBold
MembersLabel.Text = "    •          683 members online"
MembersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MembersLabel.TextSize = 14
MembersLabel.TextXAlignment = Enum.TextXAlignment.Left

local GreenDot = Instance.new("Frame")
GreenDot.Parent = MembersLabel
GreenDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
GreenDot.Position = UDim2.new(0, 28, 0.5, -4)
GreenDot.Size = UDim2.new(0, 10, 0, 10)
GreenDot.ZIndex = 102
local GDCorner = Instance.new("UICorner")
GDCorner.CornerRadius = UDim.new(1, 0)
GDCorner.Parent = GreenDot

local JoinLabel = Instance.new("TextLabel")
JoinLabel.Parent = DiscordHolder
JoinLabel.BackgroundTransparency = 1
JoinLabel.Position = UDim2.new(0, 118, 0, 52)
JoinLabel.Size = UDim2.new(0, 340, 0, 42)
JoinLabel.ZIndex = 101
JoinLabel.Font = Enum.Font.GothamMedium
JoinLabel.Text = "Únete a Kysu Hub para recibir actualizaciones directas y eventos exclusivos."
JoinLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
JoinLabel.TextSize = 12
JoinLabel.TextXAlignment = Enum.TextXAlignment.Left
JoinLabel.TextWrapped = true

local GiveawaysDiscordCard = Instance.new("Frame")
GiveawaysDiscordCard.Parent = DiscordHolder
GiveawaysDiscordCard.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
GiveawaysDiscordCard.Position = UDim2.new(0, 20, 0, 116)
GiveawaysDiscordCard.Size = UDim2.new(0, 440, 0, 84)
GiveawaysDiscordCard.ZIndex = 101

local GDCurve = Instance.new("UICorner")
GDCurve.CornerRadius = UDim.new(0, 10)
GDCurve.Parent = GiveawaysDiscordCard

local GDStroke = Instance.new("UIStroke")
GDStroke.Parent = GiveawaysDiscordCard
GDStroke.Color = Color3.fromRGB(255, 80, 80)
GDStroke.Thickness = 1.5

local GDTitle = Instance.new("TextLabel")
GDTitle.Parent = GiveawaysDiscordCard
GDTitle.BackgroundTransparency = 1
GDTitle.Position = UDim2.new(0, 12, 0, 10)
GDTitle.Size = UDim2.new(1, -24, 0, 20)
GDTitle.ZIndex = 102
GDTitle.Font = Enum.Font.GothamBold
GDTitle.Text = "🎉 ¡Giveaways de Godlys Activos 24/7 en Kysu Hub!"
GDTitle.TextColor3 = Color3.fromRGB(255, 120, 120)
GDTitle.TextSize = 12
GDTitle.TextXAlignment = Enum.TextXAlignment.Left

local GDDesc = Instance.new("TextLabel")
GDDesc.Parent = GiveawaysDiscordCard
GDDesc.BackgroundTransparency = 1
GDDesc.Position = UDim2.new(0, 12, 0, 32)
GDDesc.Size = UDim2.new(1, -24, 0, 44)
GDDesc.ZIndex = 102
GDDesc.Font = Enum.Font.GothamMedium
GDDesc.Text = "Participa ahora mismo en sorteos diarios de armas legendarias, Godlys y rangos exclusivos en nuestra comunidad. ¡No pierdas tu oportunidad!"
GDDesc.TextColor3 = Color3.fromRGB(210, 210, 210)
GDDesc.TextSize = 11
GDDesc.TextXAlignment = Enum.TextXAlignment.Left
GDDesc.TextWrapped = true

local CopyLinkDiscordBtn = Instance.new("TextButton")
CopyLinkDiscordBtn.Parent = DiscordHolder
CopyLinkDiscordBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 25)
CopyLinkDiscordBtn.Position = UDim2.new(0, 20, 0, 218)
CopyLinkDiscordBtn.Size = UDim2.new(0, 212, 0, 44)
CopyLinkDiscordBtn.ZIndex = 101
CopyLinkDiscordBtn.AutoButtonColor = false
CopyLinkDiscordBtn.Font = Enum.Font.GothamBold
CopyLinkDiscordBtn.Text = "Copy link Discord"
CopyLinkDiscordBtn.TextColor3 = Color3.fromRGB(255, 130, 130)
CopyLinkDiscordBtn.TextSize = 13

local CLDCorner = Instance.new("UICorner")
CLDCorner.CornerRadius = UDim.new(0, 10)
CLDCorner.Parent = CopyLinkDiscordBtn

local CLDStroke = Instance.new("UIStroke")
CLDStroke.Parent = CopyLinkDiscordBtn
CLDStroke.Color = Color3.fromRGB(255, 80, 80)
CLDStroke.Thickness = 1.5

CopyLinkDiscordBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard("https://discord.gg/WXq3b2CfY")
        end
    end)
    CopyLinkDiscordBtn.Text = "¡Enlace copiado con éxito!"
    task.delay(1.5, function()
        if CopyLinkDiscordBtn then CopyLinkDiscordBtn.Text = "Copy link Discord" end
    end)
end)

local OkDiscordBtn = Instance.new("TextButton")
OkDiscordBtn.Parent = DiscordHolder
OkDiscordBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
OkDiscordBtn.Position = UDim2.new(1, -232, 0, 218)
OkDiscordBtn.Size = UDim2.new(0, 212, 0, 44)
OkDiscordBtn.ZIndex = 101
OkDiscordBtn.AutoButtonColor = false
OkDiscordBtn.Font = Enum.Font.GothamBold
OkDiscordBtn.Text = "OK"
OkDiscordBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
OkDiscordBtn.TextSize = 14

local OkCorner = Instance.new("UICorner")
OkCorner.CornerRadius = UDim.new(0, 10)
OkCorner.Parent = OkDiscordBtn

local discordCompleted = false

-- ==========================================
-- 2. SECUENCIA EXACTA DE BIENVENIDA
-- ==========================================
local startupGui = Instance.new("ScreenGui")
startupGui.Name = "KysuHubStartupAnim"
pcall(function()
    if gethui then startupGui.Parent = gethui() else startupGui.Parent = CoreGui end
end)
if not startupGui.Parent then startupGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
startupGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
startupGui.IgnoreGuiInset = true

local startupHolder = Instance.new("Frame")
startupHolder.Parent = startupGui
startupHolder.BackgroundTransparency = 1
startupHolder.AnchorPoint = Vector2.new(0.5, 0.5)
startupHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
startupHolder.Size = UDim2.new(0, 350, 0, 120)

local startupText = Instance.new("TextLabel")
startupText.Parent = startupHolder
startupText.BackgroundTransparency = 1
startupText.Size = UDim2.new(1, 0, 0, 50)
startupText.Font = Enum.Font.GothamBold
startupText.Text = "Kysu Hub"
startupText.TextColor3 = Color3.fromRGB(255, 255, 255)
startupText.TextSize = 32
startupText.TextTransparency = 1

local startupSub = Instance.new("TextLabel")
startupSub.Parent = startupHolder
startupSub.BackgroundTransparency = 1
startupSub.Position = UDim2.new(0, 0, 0, 55)
startupSub.Size = UDim2.new(1, 0, 0, 40)
startupSub.Font = Enum.Font.GothamMedium
startupSub.Text = "Disfruta del script"
startupSub.TextColor3 = Color3.fromRGB(180, 180, 180)
startupSub.TextSize = 14
startupSub.TextTransparency = 1

local welcomeFinished = false

local function runWelcomeSequence()
    task.spawn(function()
        TweenService:Create(startupText, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        TweenService:Create(startupSub, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        task.wait(2.2)
        TweenService:Create(startupText, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
        TweenService:Create(startupSub, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
        task.wait(0.6)
        startupGui:Destroy()
        welcomeFinished = true
    end)
end

pcall(function()
    local parentTarget = gethui and gethui() or CoreGui
    for _, child in ipairs(parentTarget:GetChildren()) do
        if child.Name == "KysuHubAbsoluteFinal" then child:Destroy() end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KysuHubAbsoluteFinal"
pcall(function()
    ScreenGui.Parent = gethui and gethui() or CoreGui
end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local HubMainMaster = Instance.new("Folder")
HubMainMaster.Name = "HubMainMaster"
HubMainMaster.Parent = ScreenGui

-- ==========================================
-- 3. COMPOSICIÓN SUPERIOR (LA RAYA EXACTA)
-- ==========================================
local MasterTopContainer = Instance.new("Frame")
MasterTopContainer.Name = "MasterTopContainer"
MasterTopContainer.Parent = HubMainMaster
MasterTopContainer.BackgroundTransparency = 1
MasterTopContainer.Position = UDim2.new(0.5, -145, 0.02, 0)
MasterTopContainer.Size = UDim2.new(0, 290, 0, 30)
MasterTopContainer.ZIndex = 10
MasterTopContainer.Visible = false

local MainHorizontalBar = Instance.new("Frame")
MainHorizontalBar.Name = "MainHorizontalBar"
MainHorizontalBar.Parent = MasterTopContainer
MainHorizontalBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainHorizontalBar.BackgroundTransparency = 0.25
MainHorizontalBar.Size = UDim2.new(1, 0, 1, 0)
MainHorizontalBar.ClipsDescendants = true
MainHorizontalBar.ZIndex = 11

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = MainHorizontalBar

local BarStroke = Instance.new("UIStroke")
BarStroke.Parent = MainHorizontalBar
BarStroke.Thickness = 2
BarStroke.Transparency = 0

local BarGradient = Instance.new("UIGradient")
BarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 80)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 60, 0)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 80))
})
BarGradient.Parent = BarStroke

task.spawn(function()
    pcall(function()
        while task.wait(0.5) do
            for i = 0, 1, 0.02 do
                BarGradient.Offset = Vector2.new(i, 0)
                task.wait(0.05)
            end
        end
    end)
end)

local RainContainer = Instance.new("Frame")
RainContainer.Name = "RainContainer"
RainContainer.Parent = MainHorizontalBar
RainContainer.BackgroundTransparency = 1
RainContainer.Size = UDim2.new(1, 0, 1, 0)
RainContainer.ZIndex = 12

task.spawn(function()
    local rng = Random.new()
    while true do
        task.wait(0.4)
        pcall(function()
            local drop = Instance.new("Frame")
            drop.Parent = RainContainer
            drop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            drop.BackgroundTransparency = rng:NextNumber(0.4, 0.8)
            local size = rng:NextInteger(2, 3)
            drop.Size = UDim2.new(0, size, 0, size)
            drop.Position = UDim2.new(rng:NextNumber(0.05, 0.95), 0, -0.2, 0)
            drop.ZIndex = 12
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = drop
            local fallDuration = rng:NextNumber(1.5, 2.5)
            local tw = TweenService:Create(drop, TweenInfo.new(fallDuration, Enum.EasingStyle.Linear), {
                Position = UDim2.new(drop.Position.X.Scale, 0, 1.2, 0)
            })
            tw:Play()
            tw.Completed:Connect(function() drop:Destroy() end)
        end)
    end
end)

local BarText = Instance.new("TextLabel")
BarText.Parent = MainHorizontalBar
BarText.BackgroundTransparency = 1
BarText.Size = UDim2.new(1, 0, 1, 0)
BarText.ZIndex = 15
BarText.Font = Enum.Font.GothamBold
BarText.Text = "Kysu Hub"
BarText.TextColor3 = Color3.fromRGB(255, 255, 255)
BarText.TextSize = 12
BarText.TextXAlignment = Enum.TextXAlignment.Center

local TouchButton = Instance.new("TextButton")
TouchButton.Name = "TouchButton"
TouchButton.Parent = MasterTopContainer
TouchButton.BackgroundTransparency = 1
TouchButton.Size = UDim2.new(1, 0, 1, 0)
TouchButton.AutoButtonColor = false
TouchButton.Text = ""
TouchButton.ZIndex = 25

-- ==========================================
-- 4. MENÚ PRINCIPAL (420x290)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = HubMainMaster
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -145)
MainFrame.Size = UDim2.new(0, 420, 0, 290)
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 30

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(40, 40, 40)

local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Header.Size = UDim2.new(1, 0, 0, 52)
Header.ZIndex = 31

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Parent = Header
HeaderStroke.Color = Color3.fromRGB(30, 30, 30)
HeaderStroke.Thickness = 1

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Parent = Header
AvatarImg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
AvatarImg.Position = UDim2.new(0, 12, 0.5, -17)
AvatarImg.Size = UDim2.new(0, 34, 0, 34)
AvatarImg.ZIndex = 32

task.spawn(function()
    pcall(function()
        AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    end)
end)

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImg

local AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Parent = AvatarImg
AvatarStroke.Color = Color3.fromRGB(240, 240, 240)
AvatarStroke.Thickness = 1.5

local NameLabel = Instance.new("TextLabel")
NameLabel.Parent = Header
NameLabel.BackgroundTransparency = 1
NameLabel.Position = UDim2.new(0, 58, 0, 9)
NameLabel.Size = UDim2.new(0, 200, 0, 18)
NameLabel.ZIndex = 32
NameLabel.Font = Enum.Font.GothamBold
NameLabel.Text = LocalPlayer.Name
NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLabel.TextSize = 13
NameLabel.TextXAlignment = Enum.TextXAlignment.Left

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Parent = Header
StatsLabel.BackgroundTransparency = 1
StatsLabel.Position = UDim2.new(0, 58, 0, 27)
StatsLabel.Size = UDim2.new(0, 200, 0, 14)
StatsLabel.ZIndex = 32
StatsLabel.Font = Enum.Font.GothamMedium
StatsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatsLabel.TextSize = 10
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    pcall(function()
        local lastUpdate = tick()
        local frames = 0
        RunService.RenderStepped:Connect(function()
            frames += 1
            if tick() - lastUpdate >= 1 then
                local fps = math.floor(frames / (tick() - lastUpdate))
                StatsLabel.Text = "FPS: " .. fps .. " | Kysu Hub (1.0v)"
                frames = 0
                lastUpdate = tick()
            end
        end)
    end)
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -14)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.ZIndex = 32
CloseBtn.AutoButtonColor = false
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
CloseBtn.TextSize = 13

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Parent = CloseBtn
CloseStroke.Color = Color3.fromRGB(60, 60, 60)
CloseStroke.Thickness = 1

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
            Size = UDim2.new(0, 420, 0, 290),
            Position = UDim2.new(0.5, -210, 0.5, -145)
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
-- 5. PESTAÑAS DEL MENÚ PRINCIPAL
-- ==========================================
local TabsBar = Instance.new("Frame")
TabsBar.Parent = MainFrame
TabsBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TabsBar.Position = UDim2.new(0, 12, 0, 62)
TabsBar.Size = UDim2.new(0, 110, 1, -74)
TabsBar.ZIndex = 31

local TabsCorner = Instance.new("UICorner")
TabsCorner.CornerRadius = UDim.new(0, 8)
TabsCorner.Parent = TabsBar

local TabsStroke = Instance.new("UIStroke")
TabsStroke.Parent = TabsBar
TabsStroke.Color = Color3.fromRGB(30, 30, 30)

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.Parent = TabsBar
TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabsLayout.Padding = UDim.new(0, 5)
TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local PagesContainer = Instance.new("Frame")
PagesContainer.Parent = MainFrame
PagesContainer.BackgroundTransparency = 1
PagesContainer.Position = UDim2.new(0, 132, 0, 62)
PagesContainer.Size = UDim2.new(1, -144, 1, -74)
PagesContainer.ZIndex = 31

local tabNames = {"Auto farm", "Player", "Configuration", "Tracker", "Discord"}
local pageFrames = {}

for i, tName in ipairs(tabNames) do
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = TabsBar
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 30)
    TabBtn.ZIndex = 32
    TabBtn.AutoButtonColor = false
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.Text = tName
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
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
    Page.ZIndex = 32
    Page.CanvasSize = UDim2.new(0, 0, 1.8, 0)
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    
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
                    TweenService:Create(child, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 20), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                end
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(240, 240, 240), TextColor3 = Color3.fromRGB(10, 10, 10)}):Play()
        end)
    end)
    
    if i == 1 then
        TabBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        TabBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
    end
end

-- ==========================================
-- 6. DETECCIÓN DE ROLES Y ESTADO
-- ==========================================
local function getRealMM2Role(player)
    local foundRole = nil
    pcall(function()
        if player:FindFirstChild("leaderstats") then
            local roleStat = player.leaderstats:FindFirstChild("Role") or player.leaderstats:FindFirstChild("Status")
            if roleStat then
                local val = string.lower(tostring(roleStat.Value))
                if string.find(val, "murder") or string.find(val, "asesino") then foundRole = "Assassin"
                elseif string.find(val, "sheriff") then foundRole = "Sheriff"
                elseif string.find(val, "innocent") or string.find(val, "inocente") then foundRole = "Innocent" end
            end
        end
        if not foundRole and player:FindFirstChild("Role") then
            local val = string.lower(tostring(player.Role.Value))
            if string.find(val, "murder") or string.find(val, "asesino") then foundRole = "Assassin"
            elseif string.find(val, "sheriff") then foundRole = "Sheriff"
            elseif string.find(val, "inocente") then foundRole = "Innocent" end
        end
        if not foundRole then
            local char = player.Character
            if char then
                if char:FindFirstChild("Knife") or char:FindFirstChild("MM2Knife") then foundRole = "Assassin"
                elseif char:FindFirstChild("Gun") or char:FindFirstChild("Revolver") then foundRole = "Sheriff" end
            end
        end
        if not foundRole then
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                if backpack:FindFirstChild("Knife") or backpack:FindFirstChild("MM2Knife") then foundRole = "Assassin"
                elseif backpack:FindFirstChild("Gun") or backpack:FindFirstChild("Revolver") then foundRole = "Sheriff" end
            end
        end
        if not foundRole and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then foundRole = "Innocent" end
        end
    end)
    return foundRole
end

local function getPlayerByRole(roleName)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                if getRealMM2Role(p) == roleName then return p end
            end
        end
    end
    return nil
end

local function isRoundActive()
    local active = false
    pcall(function()
        local assassin = getPlayerByRole("Assassin")
        local sheriff = getPlayerByRole("Sheriff")
        if assassin or sheriff then active = true end
    end)
    return active
end

-- ==========================================
-- 7. DETECCIÓN DE COINS
-- ==========================================
local function getCachedCoins()
    local coins = {}
    pcall(function()
        local function inspectFolder(folder)
            for _, obj in ipairs(folder:GetChildren()) do
                local nameLower = string.lower(obj.Name)
                if string.find(nameLower, "coin") or string.find(nameLower, "spawn") or obj.Name == "CoinContainer" or obj.Name == "Coins" then
                    if obj:IsA("BasePart") and obj.Transparency < 1 then
                        table.insert(coins, obj)
                    else
                        for _, child in ipairs(obj:GetChildren()) do
                            if child:IsA("BasePart") and child.Transparency < 1 then
                                table.insert(coins, child)
                            end
                        end
                    end
                end
            end
        end
        inspectFolder(Workspace)
        local coinContainer = Workspace:FindFirstChild("CoinContainer") or Workspace:FindFirstChild("Coins")
        if coinContainer then inspectFolder(coinContainer) end
        
        local factory = Workspace:FindFirstChild("Factory")
        if factory then
            local fContainer = factory:FindFirstChild("CoinContainer")
            if fContainer then inspectFolder(fContainer) end
        end

        if #coins == 0 then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (string.find(string.lower(obj.Name), "coin") or obj.Name == "CoinVisual") and obj.Transparency < 1 then
                    table.insert(coins, obj)
                end
            end
        end
    end)
    return coins
end

-- ==========================================
-- 8. AUTO FARM & CUADRADO NEGRO SÓLIDO Y OPAGO (TEXTO BLANCO NORMAL)
-- ==========================================
local isAutoFarmActive = false
local autoFarmSpeedValue = 1.8
local coinsCollectedCount = 0
local trackerCoinsCount = 0
local trackerCountLabelRef = nil

local CounterGui = Instance.new("ScreenGui")
CounterGui.Name = "KysuHubCoinCounterGui"
pcall(function()
    if gethui then CounterGui.Parent = gethui() else CounterGui.Parent = CoreGui end
end)
if not CounterGui.Parent then CounterGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
CounterGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
CounterGui.IgnoreGuiInset = true

local CounterLabel = Instance.new("TextLabel")
CounterLabel.Parent = CounterGui
CounterLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CounterLabel.BackgroundTransparency = 0 -- 100% Sólido y opaco sin transparencia
CounterLabel.AnchorPoint = Vector2.new(0.5, 0)
CounterLabel.Position = UDim2.new(0.5, 0, 0.12, 0)
CounterLabel.Size = UDim2.new(0, 260, 0, 42)
CounterLabel.Visible = false
CounterLabel.ZIndex = 200
CounterLabel.Font = Enum.Font.GothamBold
CounterLabel.Text = "Monedas recolectadas: 0"
CounterLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Letra blanca normal
CounterLabel.TextSize = 13

local CLCorner = Instance.new("UICorner")
CLCorner.CornerRadius = UDim.new(0, 10)
CLCorner.Parent = CounterLabel

local CLStroke = Instance.new("UIStroke")
CLStroke.Parent = CounterLabel
CLStroke.Color = Color3.fromRGB(255, 255, 255)
CLStroke.Thickness = 1.5

-- Cuadrado negro elegante y opaco para mostrar el modelo exacto de la moneda real
local CoinModelBox = Instance.new("Frame")
CoinModelBox.Parent = CounterGui
CoinModelBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CoinModelBox.BackgroundTransparency = 0 -- 100% Sólido y opaco
CoinModelBox.Position = UDim2.new(0.5, 134, 0.12, 0)
CoinModelBox.Size = UDim2.new(0, 42, 0, 42)
CoinModelBox.Visible = false
CoinModelBox.ZIndex = 200

local CMBCorner = Instance.new("UICorner")
CMBCorner.CornerRadius = UDim.new(0, 10)
CMBCorner.Parent = CoinModelBox

local CMBStroke = Instance.new("UIStroke")
CMBStroke.Parent = CoinModelBox
CMBStroke.Color = Color3.fromRGB(255, 255, 255)
CMBStroke.Thickness = 1.5

local ViewportCoin = Instance.new("ViewportFrame")
ViewportCoin.Parent = CoinModelBox
ViewportCoin.BackgroundTransparency = 1
ViewportCoin.Size = UDim2.new(1, 0, 1, 0)
ViewportCoin.ZIndex = 201

local function getTargetCoinModelSample()
    local sample = nil
    pcall(function()
        local factory = Workspace:FindFirstChild("Factory")
        if factory then
            local cc = factory:FindFirstChild("CoinContainer")
            if cc then
                local children = cc:GetChildren()
                if children and #children >= 32 then
                    sample = children[32]
                elseif children and #children > 0 then
                    sample = children[1]
                end
            end
        end
        if not sample then
            local coins = getCachedCoins()
            if #coins > 0 then sample = coins[1] end
        end
    end)
    return sample
end

local function showCoinMessage(coinObj)
    pcall(function()
        CounterLabel.Text = "Monedas recolectadas: " .. coinsCollectedCount
        CounterLabel.Visible = true
        CounterLabel.TextTransparency = 0
        CounterLabel.BackgroundTransparency = 0
        
        ViewportCoin:ClearAllChildren()
        if coinObj and coinObj:IsA("BasePart") then
            local clone = coinObj:Clone()
            clone.Parent = ViewportCoin
            local cam = Instance.new("Camera")
            cam.Parent = ViewportCoin
            ViewportCoin.CurrentCamera = cam
            cam.CFrame = CFrame.new(clone.Position + Vector3.new(0, 0, 3.5), clone.Position)
        end
        CoinModelBox.Visible = true
        CoinModelBox.BackgroundTransparency = 0

        task.delay(1.3, function()
            if CounterLabel and CoinModelBox then
                TweenService:Create(CounterLabel, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
                TweenService:Create(CoinModelBox, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
                task.wait(0.5)
                CounterLabel.Visible = false
                CoinModelBox.Visible = false
            end
        end)
    end)
end

pcall(function()
    local autoFarmPage = pageFrames["Auto farm"]
    if autoFarmPage then
        local optionFrame = Instance.new("Frame")
        optionFrame.Name = "AutoFarmCoinsOption"
        optionFrame.Parent = autoFarmPage
        optionFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        optionFrame.Size = UDim2.new(1, -4, 0, 36)
        optionFrame.ZIndex = 33
        
        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 6)
        optCorner.Parent = optionFrame
        
        local optLabel = Instance.new("TextLabel")
        optLabel.Parent = optionFrame
        optLabel.BackgroundTransparency = 1
        optLabel.Position = UDim2.new(0, 10, 0, 0)
        optLabel.Size = UDim2.new(0.65, 0, 1, 0)
        optLabel.ZIndex = 34
        optLabel.Font = Enum.Font.GothamMedium
        optLabel.Text = "Auto farm coins"
        optLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        optLabel.TextSize = 11
        optLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Parent = optionFrame
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        toggleBtn.Position = UDim2.new(1, -65, 0.5, -12)
        toggleBtn.Size = UDim2.new(0, 56, 0, 24)
        toggleBtn.ZIndex = 34
        toggleBtn.AutoButtonColor = false
        toggleBtn.Text = ""
        
        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(1, 0)
        tCorner.Parent = toggleBtn
        
        local tStroke = Instance.new("UIStroke")
        tStroke.Parent = toggleBtn
        tStroke.Color = Color3.fromRGB(50, 50, 50)
        tStroke.Thickness = 1
        
        local circle = Instance.new("Frame")
        circle.Parent = toggleBtn
        circle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        circle.Position = UDim2.new(0, 2, 0.5, -10)
        circle.Size = UDim2.new(0, 20, 0, 20)
        circle.ZIndex = 35
        
        local cCorner = Instance.new("UICorner")
        cCorner.CornerRadius = UDim.new(1, 0)
        cCorner.Parent = circle
        
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Parent = toggleBtn
        statusLabel.BackgroundTransparency = 1
        statusLabel.Size = UDim2.new(1, 0, 1, 0)
        statusLabel.ZIndex = 36
        statusLabel.Font = Enum.Font.GothamBold
        statusLabel.Text = "OFF"
        statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        statusLabel.TextSize = 9

        local function getMurdererRoot()
            local assassinPlayer = getPlayerByRole("Assassin")
            if assassinPlayer and assassinPlayer.Character then
                local r = assassinPlayer.Character:FindFirstChild("HumanoidRootPart")
                local h = assassinPlayer.Character:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 then return r end
            end
            return nil
        end

        local function getBestSafeCoinOrEscape()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return nil end

            local mRoot = getMurdererRoot()
            local coins = getCachedCoins()
            local distToMurderer = mRoot and (root.Position - mRoot.Position).Magnitude or 999

            -- Lógica exacta: Si el asesino está a 61 studs o menos, busca la moneda más lejana
            if distToMurderer <= 61 then
                local bestCoin = nil
                local maxDist = -1
                for _, coin in ipairs(coins) do
                    if coin and coin.Parent and coin.Transparency < 1 then
                        local d = mRoot and (mRoot.Position - coin.Position).Magnitude or (root.Position - coin.Position).Magnitude
                        if d > maxDist then
                            maxDist = d
                            bestCoin = coin
                        end
                    end
                end
                if bestCoin then return bestCoin end
            else
                local bestCoin = nil
                local minDist = math.huge
                for _, coin in ipairs(coins) do
                    if coin and coin.Parent and coin.Transparency < 1 then
                        local d = (root.Position - coin.Position).Magnitude
                        if d < minDist then
                            minDist = d
                            bestCoin = coin
                        end
                    end
                end
                return bestCoin
            end
            return nil
        end

        task.spawn(function()
            while true do
                if isAutoFarmActive then
                    pcall(function()
                        local char = LocalPlayer.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                        if not char or not root or not hum or hum.Health <= 0 then
                            task.wait(1)
                            return
                        end

                        for _, p in ipairs(char:GetDescendants()) do
                            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.CanCollide = false end
                        end
                        root.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                        if root.Position.Y < -30 then
                            root.CFrame = CFrame.new(root.Position.X, 10, root.Position.Z)
                        end

                        local targetCoin = getBestSafeCoinOrEscape()
                        if targetCoin and targetCoin.Parent then
                            local targetPos = targetCoin.Position + Vector3.new(0, 1.2, 0)
                            local dist = (root.Position - targetPos).Magnitude
                            
                            -- Aplicación estricta de la velocidad del slider configurada por el usuario
                            local currentSpeedMult = math.clamp(autoFarmSpeedValue, 0.1, 1.8)
                            local baseTravelSpeed = 18 * currentSpeedMult
                            local travelTime = math.max(dist / baseTravelSpeed, 0.15)

                            local tween = TweenService:Create(root, TweenInfo.new(travelTime, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
                            tween:Play()

                            while tween.PlaybackState == Enum.PlaybackState.Playing and isAutoFarmActive and targetCoin.Parent do
                                RunService.Heartbeat:Wait()
                            end

                            if not targetCoin.Parent or (root.Position - targetPos).Magnitude < 6 then
                                coinsCollectedCount += 1
                                trackerCoinsCount += 1
                                if trackerCountLabelRef then
                                    trackerCountLabelRef.Text = "Monedas agarradas: " .. trackerCoinsCount
                                end
                                local sampleModel = getTargetCoinModelSample()
                                showCoinMessage(sampleModel)
                                task.wait(0.35)
                            end
                        else
                            task.wait(0.3)
                        end
                    end)
                else
                    pcall(function()
                        local char = LocalPlayer.Character
                        if char then
                            for _, p in ipairs(char:GetDescendants()) do
                                if p:IsA("BasePart") then p.CanCollide = true end
                            end
                            if char:FindFirstChild("HumanoidRootPart") then
                                char.HumanoidRootPart.CustomPhysicalProperties = nil
                            end
                        end
                    end)
                    task.wait(0.4)
                end
                task.wait(0.05)
            end
        end)

        toggleBtn.MouseButton1Click:Connect(function()
            isAutoFarmActive = not isAutoFarmActive
            if isAutoFarmActive then
                statusLabel.Text = "ON"
                statusLabel.TextColor3 = Color3.fromRGB(10, 10, 10)
                TweenService:Create(circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, -22, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                }):Play()
                TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                statusLabel.Text = "OFF"
                statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        for _, p in ipairs(char:GetDescendants()) do
                            if p:IsA("BasePart") then p.CanCollide = true end
                        end
                        if char:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CustomPhysicalProperties = nil
                        end
                    end
                end)
                TweenService:Create(circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 2, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                }):Play()
                TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            end
        end)
    end
end)

-- ==========================================
-- 8.1. DETECTOR INDEPENDIENTE EN TIEMPO REAL
-- ==========================================
task.spawn(function()
    local lastCoinPositions = {}
    while true do
        pcall(function()
            local coins = getCachedCoins()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                for _, coin in ipairs(coins) do
                    if coin and coin.Parent then
                        local coinId = tostring(coin:GetFullName())
                        local pos = coin.Position
                        if lastCoinPositions[coinId] == nil then
                            lastCoinPositions[coinId] = pos
                        else
                            if (root.Position - pos).Magnitude < 10 then
                                coinsCollectedCount += 1
                                trackerCoinsCount += 1
                                if trackerCountLabelRef then
                                    trackerCountLabelRef.Text = "Monedas agarradas: " .. trackerCoinsCount
                                end
                                local sampleModel = getTargetCoinModelSample()
                                showCoinMessage(sampleModel)
                                lastCoinPositions[coinId] = nil
                                task.wait(0.5)
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.3)
    end
end)

-- ==========================================
-- 8.2. AUTO FARM SPEED SLIDER
-- ==========================================
pcall(function()
    local autoFarmPage = pageFrames["Auto farm"]
    if autoFarmPage then
        local speedContainer = Instance.new("Frame")
        speedContainer.Name = "AutoFarmSpeedOption"
        speedContainer.Parent = autoFarmPage
        speedContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        speedContainer.Size = UDim2.new(1, -4, 0, 42)
        speedContainer.ZIndex = 33

        local scCorner = Instance.new("UICorner")
        scCorner.CornerRadius = UDim.new(0, 6)
        scCorner.Parent = speedContainer

        local scLabel = Instance.new("TextLabel")
        scLabel.Parent = speedContainer
        scLabel.BackgroundTransparency = 1
        scLabel.Position = UDim2.new(0, 10, 0, 2)
        scLabel.Size = UDim2.new(1, -20, 0, 18)
        scLabel.ZIndex = 34
        scLabel.Font = Enum.Font.GothamMedium
        scLabel.Text = "Speed: 1.8"
        scLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        scLabel.TextSize = 10
        scLabel.TextXAlignment = Enum.TextXAlignment.Left

        local sliderBar = Instance.new("Frame")
        sliderBar.Parent = speedContainer
        sliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        sliderBar.Position = UDim2.new(0, 10, 0, 26)
        sliderBar.Size = UDim2.new(1, -20, 0, 8)
        sliderBar.ZIndex = 34

        local sbCorner = Instance.new("UICorner")
        sbCorner.CornerRadius = UDim.new(1, 0)
        sbCorner.Parent = sliderBar

        local sliderFill = Instance.new("Frame")
        sliderFill.Parent = sliderBar
        sliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderFill.Size = UDim2.new(1, 0, 1, 0)
        sliderFill.ZIndex = 35

        local sfCorner = Instance.new("UICorner")
        sfCorner.CornerRadius = UDim.new(1, 0)
        sfCorner.Parent = sliderFill

        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Parent = sliderBar
        sliderBtn.BackgroundTransparency = 1
        sliderBtn.Size = UDim2.new(1, 0, 1, 0)
        sliderBtn.ZIndex = 36
        sliderBtn.Text = ""

        local draggingSlider = false
        sliderBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = true
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                pcall(function()
                    local pos = input.Position.X
                    local absPos = sliderBar.AbsolutePosition.X
                    local absSize = sliderBar.AbsoluteSize.X
                    local rel = math.clamp((pos - absPos) / absSize, 0, 1)
                    autoFarmSpeedValue = rel * 1.8
                    sliderFill.Size = UDim2.new(autoFarmSpeedValue / 1.8, 0, 1, 0)
                    scLabel.Text = string.format("Speed: %.1f", autoFarmSpeedValue)
                end)
            end
        end)
    end
end)

-- ==========================================
-- 8.3. AUTO GRAB GUN
-- ==========================================
local isAutoCrabActive = false

pcall(function()
    local autoFarmPage = pageFrames["Auto farm"]
    if autoFarmPage then
        local crabOptionFrame = Instance.new("Frame")
        crabOptionFrame.Name = "AutoCrabOption"
        crabOptionFrame.Parent = autoFarmPage
        crabOptionFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        crabOptionFrame.Size = UDim2.new(1, -4, 0, 36)
        crabOptionFrame.ZIndex = 33
        
        local crabCorner = Instance.new("UICorner")
        crabCorner.CornerRadius = UDim.new(0, 6)
        crabCorner.Parent = crabOptionFrame
        
        local crabLabel = Instance.new("TextLabel")
        crabLabel.Parent = crabOptionFrame
        crabLabel.BackgroundTransparency = 1
        crabLabel.Position = UDim2.new(0, 10, 0, 0)
        crabLabel.Size = UDim2.new(0.65, 0, 1, 0)
        crabLabel.ZIndex = 34
        crabLabel.Font = Enum.Font.GothamMedium
        crabLabel.Text = "Auto grab gun"
        crabLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        crabLabel.TextSize = 11
        crabLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local crabToggleBtn = Instance.new("TextButton")
        crabToggleBtn.Parent = crabOptionFrame
        crabToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        crabToggleBtn.Position = UDim2.new(1, -65, 0.5, -12)
        crabToggleBtn.Size = UDim2.new(0, 56, 0, 24)
        crabToggleBtn.ZIndex = 34
        crabToggleBtn.AutoButtonColor = false
        crabToggleBtn.Text = ""
        
        local ctCorner = Instance.new("UICorner")
        ctCorner.CornerRadius = UDim.new(1, 0)
        ctCorner.Parent = crabToggleBtn
        
        local ctStroke = Instance.new("UIStroke")
        ctStroke.Parent = crabToggleBtn
        ctStroke.Color = Color3.fromRGB(50, 50, 50)
        ctStroke.Thickness = 1
        
        local crabCircle = Instance.new("Frame")
        crabCircle.Parent = crabToggleBtn
        crabCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        crabCircle.Position = UDim2.new(0, 2, 0.5, -10)
        crabCircle.Size = UDim2.new(0, 20, 0, 20)
        crabCircle.ZIndex = 35
        
        local ccCorner = Instance.new("UICorner")
        ccCorner.CornerRadius = UDim.new(1, 0)
        ccCorner.Parent = crabCircle
        
        local crabStatus = Instance.new("TextLabel")
        crabStatus.Parent = crabToggleBtn
        crabStatus.BackgroundTransparency = 1
        crabStatus.Size = UDim2.new(1, 0, 1, 0)
        crabStatus.ZIndex = 36
        crabStatus.Font = Enum.Font.GothamBold
        crabStatus.Text = "OFF"
        crabStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
        crabStatus.TextSize = 9

        local function isSheriffDead()
            local sheriffPlayer = getPlayerByRole("Sheriff")
            if not sheriffPlayer then return true end
            local char = sheriffPlayer.Character
            if not char then return true end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return true end
            return false
        end

        local function findDroppedGunPart()
            local foundPart = nil
            pcall(function()
                for _, obj in ipairs(Workspace:GetChildren()) do
                    local nameLower = string.lower(obj.Name)
                    if obj.Name == "GunDrop" or obj.Name == "Drop" or string.find(nameLower, "gundrop") then
                        if obj:IsA("BasePart") then foundPart = obj
                        elseif obj:IsA("Model") then foundPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart") end
                        break
                    end
                end
                if not foundPart then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        local nameLower = string.lower(obj.Name)
                        if (obj.Name == "GunDrop" or obj.Name == "Drop") and not obj:FindFirstAncestorOfClass("Player") then
                            if obj:IsA("BasePart") then foundPart = obj
                            elseif obj:IsA("Model") then foundPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart") end
                            break
                        end
                    end
                end
            end)
            return foundPart
        end

        task.spawn(function()
            while true do
                if isAutoCrabActive then
                    pcall(function()
                        if isSheriffDead() then
                            local gunPart = findDroppedGunPart()
                            if gunPart then
                                local char = LocalPlayer.Character
                                local root = char and char:FindFirstChild("HumanoidRootPart")
                                local hum = char and char:FindFirstChildOfClass("Humanoid")
                                if root and hum and hum.Health > 0 then
                                    local originalCF = root.CFrame
                                    root.CFrame = gunPart.CFrame + Vector3.new(0, 3, 0)
                                    task.wait(0.6)
                                    root.CFrame = originalCF
                                    task.wait(4)
                                end
                            end
                        end
                    end)
                end
                task.wait(1.5)
            end
        end)

        crabToggleBtn.MouseButton1Click:Connect(function()
            isAutoCrabActive = not isAutoCrabActive
            if isAutoCrabActive then
                crabStatus.Text = "ON"
                crabStatus.TextColor3 = Color3.fromRGB(10, 10, 10)
                TweenService:Create(crabCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, -22, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                }):Play()
                TweenService:Create(crabToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                crabStatus.Text = "OFF"
                crabStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
                TweenService:Create(crabCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 2, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                }):Play()
                TweenService:Create(crabToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            end
        end)
    end
end)

-- ==========================================
-- 9. PESTAÑA PLAYER: ESP & AIMBOT
-- ==========================================
local isEspPlayersActive = false
local isAimbotActive = false
local aimbotRadiusValue = 13

local AimbotFovGui = Instance.new("ScreenGui")
AimbotFovGui.Name = "KysuHubAimbotFovGui"
pcall(function()
    if gethui then AimbotFovGui.Parent = gethui() else AimbotFovGui.Parent = CoreGui end
end)
if not AimbotFovGui.Parent then AimbotFovGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
AimbotFovGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AimbotFovGui.IgnoreGuiInset = true

local FovCircleFrame = Instance.new("Frame")
FovCircleFrame.Parent = AimbotFovGui
FovCircleFrame.BackgroundTransparency = 1
FovCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FovCircleFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FovCircleFrame.Size = UDim2.new(0, 416, 0, 416)
FovCircleFrame.Visible = false
FovCircleFrame.ZIndex = 50

local FovCircleStroke = Instance.new("UIStroke")
FovCircleStroke.Parent = FovCircleFrame
FovCircleStroke.Color = Color3.fromRGB(0, 210, 255)
FovCircleStroke.Thickness = 1.5
FovCircleStroke.Transparency = 0.2

local FovCircleCorner = Instance.new("UICorner")
FovCircleCorner.CornerRadius = UDim.new(1, 0)
FovCircleCorner.Parent = FovCircleFrame

pcall(function()
    local playerPage = pageFrames["Player"]
    if playerPage then
        local espOptionFrame = Instance.new("Frame")
        espOptionFrame.Name = "EspPlayersOption"
        espOptionFrame.Parent = playerPage
        espOptionFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        espOptionFrame.Size = UDim2.new(1, -4, 0, 36)
        espOptionFrame.ZIndex = 33
        
        local espOptCorner = Instance.new("UICorner")
        espOptCorner.CornerRadius = UDim.new(0, 6)
        espOptCorner.Parent = espOptionFrame
        
        local espOptLabel = Instance.new("TextLabel")
        espOptLabel.Parent = espOptionFrame
        espOptLabel.BackgroundTransparency = 1
        espOptLabel.Position = UDim2.new(0, 10, 0, 0)
        espOptLabel.Size = UDim2.new(0.65, 0, 1, 0)
        espOptLabel.ZIndex = 34
        espOptLabel.Font = Enum.Font.GothamMedium
        espOptLabel.Text = "Esp players"
        espOptLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        espOptLabel.TextSize = 11
        espOptLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local espToggleBtn = Instance.new("TextButton")
        espToggleBtn.Parent = espOptionFrame
        espToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        espToggleBtn.Position = UDim2.new(1, -65, 0.5, -12)
        espToggleBtn.Size = UDim2.new(0, 56, 0, 24)
        espToggleBtn.ZIndex = 34
        espToggleBtn.AutoButtonColor = false
        espToggleBtn.Text = ""
        
        local etCorner = Instance.new("UICorner")
        etCorner.CornerRadius = UDim.new(1, 0)
        etCorner.Parent = espToggleBtn
        
        local etStroke = Instance.new("UIStroke")
        etStroke.Parent = espToggleBtn
        etStroke.Color = Color3.fromRGB(50, 50, 50)
        etStroke.Thickness = 1
        
        local espCircle = Instance.new("Frame")
        espCircle.Parent = espToggleBtn
        espCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        espCircle.Position = UDim2.new(0, 2, 0.5, -10)
        espCircle.Size = UDim2.new(0, 20, 0, 20)
        espCircle.ZIndex = 35
        
        local ecCorner = Instance.new("UICorner")
        ecCorner.CornerRadius = UDim.new(1, 0)
        ecCorner.Parent = espCircle
        
        local espStatusLabel = Instance.new("TextLabel")
        espStatusLabel.Parent = espToggleBtn
        espStatusLabel.BackgroundTransparency = 1
        espStatusLabel.Size = UDim2.new(1, 0, 1, 0)
        espStatusLabel.ZIndex = 36
        espStatusLabel.Font = Enum.Font.GothamBold
        espStatusLabel.Text = "OFF"
        espStatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        espStatusLabel.TextSize = 9
        
        espToggleBtn.MouseButton1Click:Connect(function()
            isEspPlayersActive = not isEspPlayersActive
            if isEspPlayersActive then
                espStatusLabel.Text = "ON"
                espStatusLabel.TextColor3 = Color3.fromRGB(10, 10, 10)
                TweenService:Create(espCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, -22, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                }):Play()
                TweenService:Create(espToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                espStatusLabel.Text = "OFF"
                espStatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                TweenService:Create(espCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 2, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                }):Play()
                TweenService:Create(espToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            end
        end)

        local aimOptionFrame = Instance.new("Frame")
        aimOptionFrame.Name = "AimbotOption"
        aimOptionFrame.Parent = playerPage
        aimOptionFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        aimOptionFrame.Size = UDim2.new(1, -4, 0, 36)
        aimOptionFrame.ZIndex = 33
        
        local aimOptCorner = Instance.new("UICorner")
        aimOptCorner.CornerRadius = UDim.new(0, 6)
        aimOptCorner.Parent = aimOptionFrame
        
        local aimOptLabel = Instance.new("TextLabel")
        aimOptLabel.Parent = aimOptionFrame
        aimOptLabel.BackgroundTransparency = 1
        aimOptLabel.Position = UDim2.new(0, 10, 0, 0)
        aimOptLabel.Size = UDim2.new(0.65, 0, 1, 0)
        aimOptLabel.ZIndex = 34
        aimOptLabel.Font = Enum.Font.GothamMedium
        aimOptLabel.Text = "Aimbot"
        aimOptLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        aimOptLabel.TextSize = 11
        aimOptLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local aimToggleBtn = Instance.new("TextButton")
        aimToggleBtn.Parent = aimOptionFrame
        aimToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        aimToggleBtn.Position = UDim2.new(1, -65, 0.5, -12)
        aimToggleBtn.Size = UDim2.new(0, 56, 0, 24)
        aimToggleBtn.ZIndex = 34
        aimToggleBtn.AutoButtonColor = false
        aimToggleBtn.Text = ""
        
        local atCorner = Instance.new("UICorner")
        atCorner.CornerRadius = UDim.new(1, 0)
        atCorner.Parent = aimToggleBtn
        
        local atStroke = Instance.new("UIStroke")
        atStroke.Parent = aimToggleBtn
        atStroke.Color = Color3.fromRGB(50, 50, 50)
        atStroke.Thickness = 1
        
        local aimCircle = Instance.new("Frame")
        aimCircle.Parent = aimToggleBtn
        aimCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        aimCircle.Position = UDim2.new(0, 2, 0.5, -10)
        aimCircle.Size = UDim2.new(0, 20, 0, 20)
        aimCircle.ZIndex = 35
        
        local acCorner = Instance.new("UICorner")
        acCorner.CornerRadius = UDim.new(1, 0)
        acCorner.Parent = aimCircle
        
        local aimStatusLabel = Instance.new("TextLabel")
        aimStatusLabel.Parent = aimToggleBtn
        aimStatusLabel.BackgroundTransparency = 1
        aimStatusLabel.Size = UDim2.new(1, 0, 1, 0)
        aimStatusLabel.ZIndex = 36
        aimStatusLabel.Font = Enum.Font.GothamBold
        aimStatusLabel.Text = "OFF"
        aimStatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        aimStatusLabel.TextSize = 9

        local rangeContainer = Instance.new("Frame")
        rangeContainer.Name = "AimbotRangeOption"
        rangeContainer.Parent = playerPage
        rangeContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        rangeContainer.Size = UDim2.new(1, -4, 0, 42)
        rangeContainer.ZIndex = 33

        local rcCorner = Instance.new("UICorner")
        rcCorner.CornerRadius = UDim.new(0, 6)
        rcCorner.Parent = rangeContainer

        local rcLabel = Instance.new("TextLabel")
        rcLabel.Parent = rangeContainer
        rcLabel.BackgroundTransparency = 1
        rcLabel.Position = UDim2.new(0, 10, 0, 2)
        rcLabel.Size = UDim2.new(1, -20, 0, 18)
        rcLabel.ZIndex = 34
        rcLabel.Font = Enum.Font.GothamMedium
        rcLabel.Text = "Circle Size: 13"
        rcLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        rcLabel.TextSize = 10
        rcLabel.TextXAlignment = Enum.TextXAlignment.Left

        local sliderBarR = Instance.new("Frame")
        sliderBarR.Parent = rangeContainer
        sliderBarR.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        sliderBarR.Position = UDim2.new(0, 10, 0, 26)
        sliderBarR.Size = UDim2.new(1, -20, 0, 8)
        sliderBarR.ZIndex = 34

        local sbrCorner = Instance.new("UICorner")
        sbrCorner.CornerRadius = UDim.new(1, 0)
        sbrCorner.Parent = sliderBarR

        local sliderFillR = Instance.new("Frame")
        sliderFillR.Parent = sliderBarR
        sliderFillR.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderFillR.Size = UDim2.new(13 / 20, 0, 1, 0)
        sliderFillR.ZIndex = 35

        local sfrCorner = Instance.new("UICorner")
        sfrCorner.CornerRadius = UDim.new(1, 0)
        sfrCorner.Parent = sliderFillR

        local sliderBtnR = Instance.new("TextButton")
        sliderBtnR.Parent = sliderBarR
        sliderBtnR.BackgroundTransparency = 1
        sliderBtnR.Size = UDim2.new(1, 0, 1, 0)
        sliderBtnR.ZIndex = 36
        sliderBtnR.Text = ""

        local draggingRange = false
        sliderBtnR.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingRange = true
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingRange = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if draggingRange and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                pcall(function()
                    local pos = input.Position.X
                    local absPos = sliderBarR.AbsolutePosition.X
                    local absSize = sliderBarR.AbsoluteSize.X
                    local rel = math.clamp((pos - absPos) / absSize, 0, 1)
                    aimbotRadiusValue = math.max(1, math.floor(rel * 20))
                    sliderFillR.Size = UDim2.new(aimbotRadiusValue / 20, 0, 1, 0)
                    rcLabel.Text = string.format("Circle Size: %d", aimbotRadiusValue)
                    
                    local pixelDiameter = aimbotRadiusValue * 16 * 2
                    FovCircleFrame.Size = UDim2.new(0, pixelDiameter, 0, pixelDiameter)
                end)
            end
        end)

        aimToggleBtn.MouseButton1Click:Connect(function()
            isAimbotActive = not isAimbotActive
            if isAimbotActive then
                aimStatusLabel.Text = "ON"
                aimStatusLabel.TextColor3 = Color3.fromRGB(10, 10, 10)
                FovCircleFrame.Visible = true
                local pixelDiameter = aimbotRadiusValue * 16 * 2
                FovCircleFrame.Size = UDim2.new(0, pixelDiameter, 0, pixelDiameter)
                TweenService:Create(aimCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, -22, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                }):Play()
                TweenService:Create(aimToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                aimStatusLabel.Text = "OFF"
                aimStatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                FovCircleFrame.Visible = false
                TweenService:Create(aimCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 2, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                }):Play()
                TweenService:Create(aimToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            end
        end)
    end
end)

local espFolder = Workspace:FindFirstChild("KysuHubEspFolder") or Instance.new("Folder", Workspace)
espFolder.Name = "KysuHubEspFolder"

local EspGuiContainer = Instance.new("ScreenGui")
EspGuiContainer.Name = "KysuHubEspGuiContainer"
pcall(function()
    if gethui then EspGuiContainer.Parent = gethui() else EspGuiContainer.Parent = CoreGui end
end)
if not EspGuiContainer.Parent then EspGuiContainer.Parent = LocalPlayer:WaitForChild("PlayerGui") end
EspGuiContainer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
EspGuiContainer.IgnoreGuiInset = true

local persistentEspObjects = {}
local persistentEspLabels = {}

local function cleanupEsp()
    for _, obj in pairs(persistentEspObjects) do pcall(function() obj:Destroy() end) end
    for _, lbl in pairs(persistentEspLabels) do pcall(function() lbl:Destroy() end) end
    persistentEspObjects = {}
    persistentEspLabels = {}
    espFolder:ClearAllChildren()
end

RunService.Heartbeat:Connect(function()
    if not isEspPlayersActive or not isRoundActive() then
        if next(persistentEspObjects) ~= nil then cleanupEsp() end
        return
    end
    pcall(function()
        local localChar = LocalPlayer.Character
        local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
        if not localRoot then cleanupEsp() return end
        
        local activePlayersWithRoles = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                local root = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if root and humanoid and humanoid.Health > 0 and root.Position.Y > -50 then
                    local realRole = getRealMM2Role(p)
                    if realRole then activePlayersWithRoles[p] = {char = char, root = root, role = realRole} end
                end
            end
        end
        
        for p, container in pairs(persistentEspObjects) do
            if not activePlayersWithRoles[p] then
                pcall(function() container:Destroy() end)
                persistentEspObjects[p] = nil
                if persistentEspLabels[p] then
                    pcall(function() persistentEspLabels[p]:Destroy() end)
                    persistentEspLabels[p] = nil
                end
            end
        end
        
        for p, data in pairs(activePlayersWithRoles) do
            local roleColor = Color3.fromRGB(0, 255, 0)
            if data.role == "Sheriff" then roleColor = Color3.fromRGB(0, 150, 255)
            elseif data.role == "Assassin" then roleColor = Color3.fromRGB(255, 0, 0) end
            
            local container = persistentEspObjects[p]
            local textLabel = persistentEspLabels[p]

            if not container or not container.Parent then
                container = Instance.new("Folder")
                container.Name = "Esp_" .. p.Name
                container.Parent = espFolder
                
                local linePart = Instance.new("Part")
                linePart.Name = "LinePart"
                linePart.Size = Vector3.new(0.1, 0.1, 0.1)
                linePart.Transparency = 1
                linePart.Anchored = true
                linePart.CanCollide = false
                linePart.Parent = container
                
                local att0 = Instance.new("Attachment", linePart)
                local att1 = Instance.new("Attachment")
                att0.Parent = localRoot
                att1.Parent = data.root
                
                local lineBeam = Instance.new("Beam")
                lineBeam.Name = "Beam"
                lineBeam.Attachment0 = att0
                lineBeam.Attachment1 = att1
                lineBeam.Width0 = 0.08
                lineBeam.Width1 = 0.08
                lineBeam.FaceCamera = true
                lineBeam.Color = ColorSequence.new(roleColor)
                lineBeam.Parent = container
                
                local highlight = Instance.new("Highlight")
                highlight.Name = "Highlight"
                highlight.Adornee = data.char
                highlight.FillColor = roleColor
                highlight.FillTransparency = 0.6
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.OutlineTransparency = 0.2
                highlight.Parent = container
                
                persistentEspObjects[p] = container

                textLabel = Instance.new("TextLabel")
                textLabel.Parent = EspGuiContainer
                textLabel.BackgroundTransparency = 1
                textLabel.Font = Enum.Font.GothamBold
                textLabel.TextColor3 = roleColor
                textLabel.TextSize = 12
                textLabel.TextStrokeTransparency = 0.5
                textLabel.Size = UDim2.new(0, 120, 0, 25)
                textLabel.AnchorPoint = Vector2.new(0.5, 1)
                persistentEspLabels[p] = textLabel
            else
                local beam = container:FindFirstChild("Beam")
                if beam then beam.Color = ColorSequence.new(roleColor) end
                local highlight = container:FindFirstChild("Highlight")
                if highlight then highlight.FillColor = roleColor end
            end

            if textLabel and data.root then
                local cam = Workspace.CurrentCamera
                local dist = math.floor((localRoot.Position - data.root.Position).Magnitude)
                local screenPos, onScreen = cam:WorldToViewportPoint(data.root.Position + Vector3.new(0, 3, 0))
                if onScreen then
                    textLabel.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
                    textLabel.Text = p.Name .. " [" .. dist .. " studs]"
                    textLabel.Visible = true
                else
                    textLabel.Visible = false
                end
            end
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        if not isAimbotActive then return end
        local murderPlayer = getPlayerByRole("Assassin")
        if not murderPlayer or not murderPlayer.Character then return end
        
        local mRoot = murderPlayer.Character:FindFirstChild("HumanoidRootPart")
        local mHum = murderPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not mRoot or not mHum or mHum.Health <= 0 then return end
        
        local cam = Workspace.CurrentCamera
        if not cam then return end
        
        local screenPos, onScreen = cam:WorldToViewportPoint(mRoot.Position)
        if onScreen then
            local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
            local murderPos2D = Vector2.new(screenPos.X, screenPos.Y)
            local distFromCenter = (murderPos2D - center).Magnitude
            local pixelRadius = aimbotRadiusValue * 16

            if distFromCenter <= pixelRadius then
                cam.CFrame = CFrame.new(cam.CFrame.Position, mRoot.Position)
            end
        end
    end)
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if isWalkSpeedActive then hum.WalkSpeed = walkSpeedValue
                elseif hum.WalkSpeed > 100 then hum.WalkSpeed = 16 end
                if isJumpPowerActive then
                    pcall(function() hum.JumpPower = jumpPowerValue end)
                    pcall(function() hum.JumpHeight = jumpPowerValue / 4 end)
                end
            end
        end
    end)
end)

-- ==========================================
-- 10. CONFIGURATION: WALKSPEED, JUMPPOWER & ANTI FLING
-- ==========================================
local isAntiFlingActive = false

pcall(function()
    local configPage = pageFrames["Configuration"]
    if configPage then
        local antiFlingFrame = Instance.new("Frame")
        antiFlingFrame.Name = "AntiFlingOption"
        antiFlingFrame.Parent = configPage
        antiFlingFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        antiFlingFrame.Size = UDim2.new(1, -4, 0, 36)
        antiFlingFrame.ZIndex = 33
        
        local afCorner = Instance.new("UICorner")
        afCorner.CornerRadius = UDim.new(0, 6)
        afCorner.Parent = antiFlingFrame
        
        local afLabel = Instance.new("TextLabel")
        afLabel.Parent = antiFlingFrame
        afLabel.BackgroundTransparency = 1
        afLabel.Position = UDim2.new(0, 10, 0, 0)
        afLabel.Size = UDim2.new(0.65, 0, 1, 0)
        afLabel.ZIndex = 34
        afLabel.Font = Enum.Font.GothamMedium
        afLabel.Text = "Anti fling"
        afLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        afLabel.TextSize = 11
        afLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local afToggle = Instance.new("TextButton")
        afToggle.Parent = antiFlingFrame
        afToggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        afToggle.Position = UDim2.new(1, -65, 0.5, -12)
        afToggle.Size = UDim2.new(0, 56, 0, 24)
        afToggle.ZIndex = 34
        afToggle.AutoButtonColor = false
        afToggle.Text = ""
        
        local aftCorner = Instance.new("UICorner")
        aftCorner.CornerRadius = UDim.new(1, 0)
        aftCorner.Parent = afToggle
        
        local aftStroke = Instance.new("UIStroke")
        aftStroke.Parent = afToggle
        aftStroke.Color = Color3.fromRGB(50, 50, 50)
        aftStroke.Thickness = 1
        
        local afCircle = Instance.new("Frame")
        afCircle.Parent = afToggle
        afCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        afCircle.Position = UDim2.new(0, 2, 0.5, -10)
        afCircle.Size = UDim2.new(0, 20, 0, 20)
        afCircle.ZIndex = 35
        
        local afcCorner = Instance.new("UICorner")
        afcCorner.CornerRadius = UDim.new(1, 0)
        afcCorner.Parent = afCircle
        
        local afStatus = Instance.new("TextLabel")
        afStatus.Parent = afToggle
        afStatus.BackgroundTransparency = 1
        afStatus.Size = UDim2.new(1, 0, 1, 0)
        afStatus.ZIndex = 36
        afStatus.Font = Enum.Font.GothamBold
        afStatus.Text = "OFF"
        afStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
        afStatus.TextSize = 9

        afToggle.MouseButton1Click:Connect(function()
            isAntiFlingActive = not isAntiFlingActive
            if isAntiFlingActive then
                afStatus.Text = "ON"
                afStatus.TextColor3 = Color3.fromRGB(10, 10, 10)
                TweenService:Create(afCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, -22, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                }):Play()
                TweenService:Create(afToggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                afStatus.Text = "OFF"
                afStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
                TweenService:Create(afCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 2, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                }):Play()
                TweenService:Create(afToggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            end
        end)

        local wsFrame = Instance.new("Frame")
        wsFrame.Name = "WalkSpeedOption"
        wsFrame.Parent = configPage
        wsFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        wsFrame.Size = UDim2.new(1, -4, 0, 64)
        wsFrame.ZIndex = 33

        local wsCorner = Instance.new("UICorner")
        wsCorner.CornerRadius = UDim.new(0, 6)
        wsCorner.Parent = wsFrame

        local wsLabel = Instance.new("TextLabel")
        wsLabel.Parent = wsFrame
        wsLabel.BackgroundTransparency = 1
        wsLabel.Position = UDim2.new(0, 10, 0, 4)
        wsLabel.Size = UDim2.new(0.6, 0, 0, 22)
        wsLabel.ZIndex = 34
        wsLabel.Font = Enum.Font.GothamMedium
        wsLabel.Text = "WalkSpeed: 16"
        wsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        wsLabel.TextSize = 11
        wsLabel.TextXAlignment = Enum.TextXAlignment.Left

        local wsToggle = Instance.new("TextButton")
        wsToggle.Parent = wsFrame
        wsToggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        wsToggle.Position = UDim2.new(1, -65, 0, 6)
        wsToggle.Size = UDim2.new(0, 56, 0, 24)
        wsToggle.ZIndex = 34
        wsToggle.AutoButtonColor = false
        wsToggle.Text = ""

        local wstCorner = Instance.new("UICorner")
        wstCorner.CornerRadius = UDim.new(1, 0)
        wstCorner.Parent = wsToggle

        local wstStroke = Instance.new("UIStroke")
        wstStroke.Parent = wsToggle
        wstStroke.Color = Color3.fromRGB(50, 50, 50)
        wstStroke.Thickness = 1

        local wsCircle = Instance.new("Frame")
        wsCircle.Parent = wsToggle
        wsCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        wsCircle.Position = UDim2.new(0, 2, 0.5, -10)
        wsCircle.Size = UDim2.new(0, 20, 0, 20)
        wsCircle.ZIndex = 35

        local wscCorner = Instance.new("UICorner")
        wscCorner.CornerRadius = UDim.new(1, 0)
        wscCorner.Parent = wsCircle

        local wsStatus = Instance.new("TextLabel")
        wsStatus.Parent = wsToggle
        wsStatus.BackgroundTransparency = 1
        wsStatus.Size = UDim2.new(1, 0, 1, 0)
        wsStatus.ZIndex = 36
        wsStatus.Font = Enum.Font.GothamBold
        wsStatus.Text = "OFF"
        wsStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
        wsStatus.TextSize = 9

        local sliderBarWS = Instance.new("Frame")
        sliderBarWS.Parent = wsFrame
        sliderBarWS.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        sliderBarWS.Position = UDim2.new(0, 10, 0, 42)
        sliderBarWS.Size = UDim2.new(1, -20, 0, 8)
        sliderBarWS.ZIndex = 34

        local sbwsCorner = Instance.new("UICorner")
        sbwsCorner.CornerRadius = UDim.new(1, 0)
        sbwsCorner.Parent = sliderBarWS

        local sliderFillWS = Instance.new("Frame")
        sliderFillWS.Parent = sliderBarWS
        sliderFillWS.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderFillWS.Size = UDim2.new(16 / 150, 0, 1, 0)
        sliderFillWS.ZIndex = 35

        local sfwsCorner = Instance.new("UICorner")
        sfwsCorner.CornerRadius = UDim.new(1, 0)
        sfwsCorner.Parent = sliderFillWS

        local sliderBtnWS = Instance.new("TextButton")
        sliderBtnWS.Parent = sliderBarWS
        sliderBtnWS.BackgroundTransparency = 1
        sliderBtnWS.Size = UDim2.new(1, 0, 1, 0)
        sliderBtnWS.ZIndex = 36
        sliderBtnWS.Text = ""

        local draggingWS = false
        sliderBtnWS.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingWS = true
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingWS = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if draggingWS and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                pcall(function()
                    local pos = input.Position.X
                    local absPos = sliderBarWS.AbsolutePosition.X
                    local absSize = sliderBarWS.AbsoluteSize.X
                    local rel = math.clamp((pos - absPos) / absSize, 0, 1)
                    walkSpeedValue = math.floor(16 + rel * 134)
                    sliderFillWS.Size = UDim2.new((walkSpeedValue - 16) / 134, 0, 1, 0)
                    wsLabel.Text = string.format("WalkSpeed: %d", walkSpeedValue)
                end)
            end
        end)

        wsToggle.MouseButton1Click:Connect(function()
            isWalkSpeedActive = not isWalkSpeedActive
            if isWalkSpeedActive then
                wsStatus.Text = "ON"
                wsStatus.TextColor3 = Color3.fromRGB(10, 10, 10)
                TweenService:Create(wsCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10), BackgroundColor3 = Color3.fromRGB(10, 10, 10)}):Play()
                TweenService:Create(wsToggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                wsStatus.Text = "OFF"
                wsStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
                TweenService:Create(wsCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10), BackgroundColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                TweenService:Create(wsToggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            end
        end)

        local jpFrame = Instance.new("Frame")
        jpFrame.Name = "JumpPowerOption"
        jpFrame.Parent = configPage
        jpFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        jpFrame.Size = UDim2.new(1, -4, 0, 64)
        jpFrame.ZIndex = 33

        local jpCorner = Instance.new("UICorner")
        jpCorner.CornerRadius = UDim.new(0, 6)
        jpCorner.Parent = jpFrame

        local jpLabel = Instance.new("TextLabel")
        jpLabel.Parent = jpFrame
        jpLabel.BackgroundTransparency = 1
        jpLabel.Position = UDim2.new(0, 10, 0, 4)
        jpLabel.Size = UDim2.new(0.6, 0, 0, 22)
        jpLabel.ZIndex = 34
        jpLabel.Font = Enum.Font.GothamMedium
        jpLabel.Text = "JumpPower: 50"
        jpLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        jpLabel.TextSize = 11
        jpLabel.TextXAlignment = Enum.TextXAlignment.Left

        local jpToggle = Instance.new("TextButton")
        jpToggle.Parent = jpFrame
        jpToggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        jpToggle.Position = UDim2.new(1, -65, 0, 6)
        jpToggle.Size = UDim2.new(0, 56, 0, 24)
        jpToggle.ZIndex = 34
        jpToggle.AutoButtonColor = false
        jpToggle.Text = ""

        local jptCorner = Instance.new("UICorner")
        jptCorner.CornerRadius = UDim.new(1, 0)
        jptCorner.Parent = jpToggle

        local jptStroke = Instance.new("UIStroke")
        jptStroke.Parent = jpToggle
        jptStroke.Color = Color3.fromRGB(50, 50, 50)
        jptStroke.Thickness = 1

        local jpCircle = Instance.new("Frame")
        jpCircle.Parent = jpToggle
        jpCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        jpCircle.Position = UDim2.new(0, 2, 0.5, -10)
        jpCircle.Size = UDim2.new(0, 20, 0, 20)
        jpCircle.ZIndex = 35

        local jpcCorner = Instance.new("UICorner")
        jpcCorner.CornerRadius = UDim.new(1, 0)
        jpcCorner.Parent = jpCircle

        local jpStatus = Instance.new("TextLabel")
        jpStatus.Parent = jpToggle
        jpStatus.BackgroundTransparency = 1
        jpStatus.Size = UDim2.new(1, 0, 1, 0)
        jpStatus.ZIndex = 36
        jpStatus.Font = Enum.Font.GothamBold
        jpStatus.Text = "OFF"
        jpStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
        jpStatus.TextSize = 9

        local sliderBarJP = Instance.new("Frame")
        sliderBarJP.Parent = jpFrame
        sliderBarJP.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        sliderBarJP.Position = UDim2.new(0, 10, 0, 42)
        sliderBarJP.Size = UDim2.new(1, -20, 0, 8)
        sliderBarJP.ZIndex = 34

        local sbjpCorner = Instance.new("UICorner")
        sbjpCorner.CornerRadius = UDim.new(1, 0)
        sbjpCorner.Parent = sliderBarJP

        local sliderFillJP = Instance.new("Frame")
        sliderFillJP.Parent = sliderBarJP
        sliderFillJP.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderFillJP.Size = UDim2.new(50 / 250, 0, 1, 0)
        sliderFillJP.ZIndex = 35

        local sfjpCorner = Instance.new("UICorner")
        sfjpCorner.CornerRadius = UDim.new(1, 0)
        sfjpCorner.Parent = sliderFillJP

        local sliderBtnJP = Instance.new("TextButton")
        sliderBtnJP.Parent = sliderBarJP
        sliderBtnJP.BackgroundTransparency = 1
        sliderBtnJP.Size = UDim2.new(1, 0, 1, 0)
        sliderBtnJP.ZIndex = 36
        sliderBtnJP.Text = ""

        local draggingJP = false
        sliderBtnJP.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingJP = true
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingJP = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if draggingJP and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                pcall(function()
                    local pos = input.Position.X
                    local absPos = sliderBarJP.AbsolutePosition.X
                    local absSize = sliderBarJP.AbsoluteSize.X
                    local rel = math.clamp((pos - absPos) / absSize, 0, 1)
                    jumpPowerValue = math.floor(50 + rel * 200)
                    sliderFillJP.Size = UDim2.new((jumpPowerValue - 50) / 200, 0, 1, 0)
                    jpLabel.Text = string.format("JumpPower: %s", tostring(jumpPowerValue))
                end)
            end
        end)

        jpToggle.MouseButton1Click:Connect(function()
            isJumpPowerActive = not isJumpPowerActive
            if isJumpPowerActive then
                jpStatus.Text = "ON"
                jpStatus.TextColor3 = Color3.fromRGB(10, 10, 10)
                TweenService:Create(jpCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10), BackgroundColor3 = Color3.fromRGB(10, 10, 10)}):Play()
                TweenService:Create(jpToggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                jpStatus.Text = "OFF"
                jpStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
                TweenService:Create(jpCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10), BackgroundColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                TweenService:Create(jpToggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            end
        end)
    end
end)

-- ==========================================
-- 11. PESTAÑA TRACKER
-- ==========================================
pcall(function()
    local trackerPage = pageFrames["Tracker"]
    if trackerPage then
        local trackerCard = Instance.new("Frame")
        trackerCard.Name = "TrackerTabCard"
        trackerCard.Parent = trackerPage
        trackerCard.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        trackerCard.Size = UDim2.new(1, -4, 0, 56)
        trackerCard.ZIndex = 33

        local tcCorner = Instance.new("UICorner")
        tcCorner.CornerRadius = UDim.new(0, 8)
        tcCorner.Parent = trackerCard

        local tcStroke = Instance.new("UIStroke")
        tcStroke.Parent = trackerCard
        tcStroke.Color = Color3.fromRGB(255, 255, 255)
        tcStroke.Thickness = 1.5

        local trackerTitle = Instance.new("TextLabel")
        trackerTitle.Parent = trackerCard
        trackerTitle.BackgroundTransparency = 1
        trackerTitle.Position = UDim2.new(0, 12, 0, 8)
        trackerTitle.Size = UDim2.new(1, -24, 0, 16)
        trackerTitle.ZIndex = 34
        trackerTitle.Font = Enum.Font.GothamBold
        trackerTitle.Text = "📊 Tracker [Auto Farm & Manual]"
        trackerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        trackerTitle.TextSize = 11
        trackerTitle.TextXAlignment = Enum.TextXAlignment.Left

        trackerCountLabelRef = Instance.new("TextLabel")
        trackerCountLabelRef.Parent = trackerCard
        trackerCountLabelRef.BackgroundTransparency = 1
        trackerCountLabelRef.Position = UDim2.new(0, 12, 0, 28)
        trackerCountLabelRef.Size = UDim2.new(1, -24, 0, 18)
        trackerCountLabelRef.ZIndex = 34
        trackerCountLabelRef.Font = Enum.Font.GothamMedium
        trackerCountLabelRef.Text = "Monedas agarradas: 0"
        trackerCountLabelRef.TextColor3 = Color3.fromRGB(180, 180, 180)
        trackerCountLabelRef.TextSize = 10
        trackerCountLabelRef.TextXAlignment = Enum.TextXAlignment.Left

        local antiAfkCard = Instance.new("Frame")
        antiAfkCard.Name = "AntiAfkTabCard"
        antiAfkCard.Parent = trackerPage
        antiAfkCard.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        antiAfkCard.Size = UDim2.new(1, -4, 0, 56)
        antiAfkCard.ZIndex = 33

        local aacCorner = Instance.new("UICorner")
        aacCorner.CornerRadius = UDim.new(0, 8)
        aacCorner.Parent = antiAfkCard

        local aacStroke = Instance.new("UIStroke")
        aacStroke.Parent = antiAfkCard
        aacStroke.Color = Color3.fromRGB(255, 255, 255)
        aacStroke.Thickness = 1.5

        local antiAfkTitle = Instance.new("TextLabel")
        antiAfkTitle.Parent = antiAfkCard
        antiAfkTitle.BackgroundTransparency = 1
        antiAfkTitle.Position = UDim2.new(0, 12, 0, 8)
        antiAfkTitle.Size = UDim2.new(0.65, 0, 0, 18)
        antiAfkTitle.ZIndex = 34
        antiAfkTitle.Font = Enum.Font.GothamBold
        antiAfkTitle.Text = "🛡️ Anti-AFK 24/7"
        antiAfkTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        antiAfkTitle.TextSize = 11
        antiAfkTitle.TextXAlignment = Enum.TextXAlignment.Left

        local antiAfkDesc = Instance.new("TextLabel")
        antiAfkDesc.Parent = antiAfkCard
        antiAfkDesc.BackgroundTransparency = 1
        antiAfkDesc.Position = UDim2.new(0, 12, 0, 28)
        antiAfkDesc.Size = UDim2.new(0.65, 0, 0, 18)
        antiAfkDesc.ZIndex = 34
        antiAfkDesc.Font = Enum.Font.GothamMedium
        antiAfkDesc.Text = "Evita desconexión por inactividad"
        antiAfkDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
        antiAfkDesc.TextSize = 9
        antiAfkDesc.TextXAlignment = Enum.TextXAlignment.Left

        local afkToggleBtn = Instance.new("TextButton")
        afkToggleBtn.Parent = antiAfkCard
        afkToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        afkToggleBtn.Position = UDim2.new(1, -65, 0.5, -12)
        afkToggleBtn.Size = UDim2.new(0, 56, 0, 24)
        afkToggleBtn.ZIndex = 34
        afkToggleBtn.AutoButtonColor = false
        afkToggleBtn.Text = ""

        local atcCorner = Instance.new("UICorner")
        atcCorner.CornerRadius = UDim.new(1, 0)
        atcCorner.Parent = afkToggleBtn

        local atcStroke = Instance.new("UIStroke")
        atcStroke.Parent = afkToggleBtn
        atcStroke.Color = Color3.fromRGB(50, 50, 50)
        atcStroke.Thickness = 1

        local afkCircle = Instance.new("Frame")
        afkCircle.Parent = afkToggleBtn
        afkCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        afkCircle.Position = UDim2.new(0, 2, 0.5, -10)
        afkCircle.Size = UDim2.new(0, 20, 0, 20)
        afkCircle.ZIndex = 35

        local afkcCorner = Instance.new("UICorner")
        afkcCorner.CornerRadius = UDim.new(1, 0)
        afkcCorner.Parent = afkCircle

        local afkStatusLabel = Instance.new("TextLabel")
        afkStatusLabel.Parent = afkToggleBtn
        afkStatusLabel.BackgroundTransparency = 1
        afkStatusLabel.Size = UDim2.new(1, 0, 1, 0)
        afkStatusLabel.ZIndex = 36
        afkStatusLabel.Font = Enum.Font.GothamBold
        afkStatusLabel.Text = "OFF"
        afkStatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        afkStatusLabel.TextSize = 9

        local isAntiAfkActive = false

        afkToggleBtn.MouseButton1Click:Connect(function()
            isAntiAfkActive = not isAntiAfkActive
            if isAntiAfkActive then
                afkStatusLabel.Text = "ON"
                afkStatusLabel.TextColor3 = Color3.fromRGB(10, 10, 10)
                TweenService:Create(afkCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, -22, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                }):Play()
                TweenService:Create(afkToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                afkStatusLabel.Text = "OFF"
                afkStatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                TweenService:Create(afkCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 2, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                }):Play()
                TweenService:Create(afkToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            end
        end)

        task.spawn(function()
            pcall(function()
                local vu = game:GetService("VirtualUser")
                LocalPlayer.Idled:Connect(function()
                    if isAntiAfkActive then
                        pcall(function()
                            vu:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
                            task.wait(1)
                            vu:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
                        end)
                    end
                end)
            end)
        end)

        task.spawn(function()
            while true do
                if isAntiAfkActive then
                    pcall(function()
                        local virtualService = game:GetService("VirtualInputManager")
                        if virtualService then
                            virtualService:SendKeyEvent(true, Enum.KeyCode.Unknown, false, game)
                            task.wait(0.2)
                            virtualService:SendKeyEvent(false, Enum.KeyCode.Unknown, false, game)
                        end
                    end)
                end
                task.wait(300)
            end
        end)
    end
end)

-- ==========================================
-- 12. PESTAÑA DISCORD (COMPACTA Y OPTIMIZADA)
-- ==========================================
pcall(function()
    local discordMenuPage = pageFrames["Discord"]
    if discordMenuPage then
        local discCard = Instance.new("Frame")
        discCard.Name = "DiscordTabCard"
        discCard.Parent = discordMenuPage
        discCard.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        discCard.Size = UDim2.new(1, -4, 0, 155) -- Tamaño más compacto y equilibrado
        discCard.ZIndex = 33

        local dcCorner = Instance.new("UICorner")
        dcCorner.CornerRadius = UDim.new(0, 10)
        dcCorner.Parent = discCard

        local dcStroke = Instance.new("UIStroke")
        dcStroke.Parent = discCard
        dcStroke.Color = Color3.fromRGB(255, 80, 80)
        dcStroke.Thickness = 1.5

        local menuDiscImgBox = Instance.new("Frame")
        menuDiscImgBox.Parent = discCard
        menuDiscImgBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        menuDiscImgBox.Position = UDim2.new(0, 10, 0, 10)
        menuDiscImgBox.Size = UDim2.new(0, 40, 0, 40)
        menuDiscImgBox.ZIndex = 34

        local mdiCorner = Instance.new("UICorner")
        mdiCorner.CornerRadius = UDim.new(0, 8)
        mdiCorner.Parent = menuDiscImgBox

        local mdiImg = Instance.new("ImageLabel")
        mdiImg.Parent = menuDiscImgBox
        mdiImg.BackgroundTransparency = 1
        mdiImg.Position = UDim2.new(0.5, -16, 0.5, -16)
        mdiImg.Size = UDim2.new(0, 32, 0, 32)
        mdiImg.ZIndex = 35
        mdiImg.Image = "rbxassetid://72421786676251"

        local mdiiCorner = Instance.new("UICorner")
        mdiiCorner.CornerRadius = UDim.new(0, 6)
        mdiiCorner.Parent = mdiImg

        local titleLabelRef = Instance.new("TextLabel")
        titleLabelRef.Parent = discCard
        titleLabelRef.BackgroundTransparency = 1
        titleLabelRef.Position = UDim2.new(0, 58, 0, 10)
        titleLabelRef.Size = UDim2.new(1, -68, 0, 16)
        titleLabelRef.ZIndex = 34
        titleLabelRef.Font = Enum.Font.GothamBold
        titleLabelRef.Text = "Kysu Hub"
        titleLabelRef.TextColor3 = Color3.fromRGB(255, 120, 120)
        titleLabelRef.TextSize = 12
        titleLabelRef.TextXAlignment = Enum.TextXAlignment.Left

        local membersRef = Instance.new("TextLabel")
        membersRef.Parent = discCard
        membersRef.BackgroundTransparency = 1
        membersRef.Position = UDim2.new(0, 58, 0, 28)
        membersRef.Size = UDim2.new(1, -68, 0, 16)
        membersRef.ZIndex = 34
        membersRef.Font = Enum.Font.GothamBold
        membersRef.Text = "    •          683 members online"
        membersRef.TextColor3 = Color3.fromRGB(255, 255, 255)
        membersRef.TextSize = 9.5
        membersRef.TextXAlignment = Enum.TextXAlignment.Left

        local greenDotTab = Instance.new("Frame")
        greenDotTab.Parent = membersRef
        greenDotTab.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        greenDotTab.Position = UDim2.new(0, 20, 0.5, -3.5)
        greenDotTab.Size = UDim2.new(0, 7, 0, 7)
        greenDotTab.ZIndex = 35
        local gdtCorner = Instance.new("UICorner")
        gdtCorner.CornerRadius = UDim.new(1, 0)
        gdtCorner.Parent = greenDotTab

        local tabCopyBtn = Instance.new("TextButton")
        tabCopyBtn.Parent = discCard
        tabCopyBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 25)
        tabCopyBtn.Position = UDim2.new(0, 10, 0, 60)
        tabCopyBtn.Size = UDim2.new(1, -20, 0, 32)
        tabCopyBtn.ZIndex = 34
        tabCopyBtn.AutoButtonColor = false
        tabCopyBtn.Font = Enum.Font.GothamBold
        tabCopyBtn.Text = "Copy link Discord"
        tabCopyBtn.TextColor3 = Color3.fromRGB(255, 130, 130)
        tabCopyBtn.TextSize = 11

        local tcbCorner = Instance.new("UICorner")
        tcbCorner.CornerRadius = UDim.new(0, 6)
        tcbCorner.Parent = tabCopyBtn

        local tcbStroke = Instance.new("UIStroke")
        tcbStroke.Parent = tabCopyBtn
        tcbStroke.Color = Color3.fromRGB(255, 80, 80)
        tcbStroke.Thickness = 1.2

        tabCopyBtn.MouseButton1Click:Connect(function()
            pcall(function()
                if setclipboard then
                    setclipboard("https://discord.gg/WXq3b2CfY")
                end
            end)
            tabCopyBtn.Text = "¡Enlace copiado al portapapeles!"
            task.delay(1.5, function()
                if tabCopyBtn then tabCopyBtn.Text = "Copy link Discord" end
            end)
        end)

        local footerNote = Instance.new("TextLabel")
        footerNote.Parent = discCard
        footerNote.BackgroundTransparency = 1
        footerNote.Position = UDim2.new(0, 10, 0, 100)
        footerNote.Size = UDim2.new(1, -20, 0, 42)
        footerNote.ZIndex = 34
        footerNote.Font = Enum.Font.GothamMedium
        footerNote.Text = "Únete a nuestra comunidad para participar en sorteos diarios de Godlys y eventos exclusivos."
        footerNote.TextColor3 = Color3.fromRGB(180, 180, 180)
        footerNote.TextSize = 9.5
        footerNote.TextXAlignment = Enum.TextXAlignment.Center
        footerNote.TextWrapped = true
    end
end)

-- ==========================================
-- 13. VALIDACIÓN DE DISCORD INICIAL Y SECUENCIA
-- ==========================================
OkDiscordBtn.MouseButton1Click:Connect(function()
    local twOut = TweenService:Create(DiscordHolder, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    })
    twOut:Play()
    twOut.Completed:Connect(function()
        DiscordGui:Destroy()
        discordCompleted = true
        runWelcomeSequence()
        task.spawn(function()
            while not welcomeFinished do task.wait(0.1) end
            MasterTopContainer.Visible = true
        end)
    end)
end)

-- ==========================================
-- 14. SISTEMA TÁCTIL Y DE ARRASTRE
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
            
            MasterTopContainer.Position = UDim2.new(
                initialContainerPos.X.Scale, 
                initialContainerPos.X.Offset + delta.X, 
                initialContainerPos.Y.Scale, 
                initialContainerPos.Y.Offset + delta.Y
            )
        end
    end)

    local function handleEnd(input)
        if dragging and input == activeInputObject then
            if maxDragDistance < 15 then
                toggleMenu(not isMenuOpen)
            end
            dragging = false
            activeInputObject = nil
        end
    end

    UserInputService.InputEnded:Connect(handleEnd)
    TouchButton.InputEnded:Connect(handleEnd)
end)
