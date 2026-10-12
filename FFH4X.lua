-- VENOM XITERZ | AIM + ESP + RAGE
-- LocalScript: StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local RED = Color3.fromRGB(235,25,30)
local BG = Color3.fromRGB(15,15,18)
local ELEMENT = Color3.fromRGB(35,35,40)
local WHITE = Color3.fromRGB(240,240,245)
local GREEN = Color3.fromRGB(0,255,80)
local GRAY = Color3.fromRGB(145,145,155)

-- Todas as opções começam desligadas
local Config = {
    Aim = false,
    ShowFOV = false,
    FOV = 120,
    Line = false,
    Name = false,
    Health = false,
    Box = false,
    ScreenStop = false,
    ScreenStretched = false,
}

-- Jogadores da mesma equipe são ignorados.
-- Se qualquer um estiver sem equipe, as funções podem funcionar.
local function IsAlly(player)
    return player ~= LP
        and LP.Team ~= nil
        and player.Team ~= nil
        and player.Team == LP.Team
end

local old = PG:FindFirstChild("VenomXiterz")
if old then old:Destroy() end

local GUI = Instance.new("ScreenGui")
GUI.Name = "VenomXiterz"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.DisplayOrder = 100
GUI.Parent = PG

local function Make(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function Corner(obj, radius)
    Make("UICorner", {
        CornerRadius = UDim.new(0,radius or 5)
    },obj)
end

local Main = Make("Frame",{
    Size = UDim2.fromOffset(430,335),
    Position = UDim2.new(.5,-215,.5,-167),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
},GUI)
Corner(Main,8)

Make("UIStroke",{
    Color = RED,
    Thickness = 1.2,
},Main)

local Header = Make("Frame",{
    Size = UDim2.new(1,0,0,48),
    BackgroundColor3 = Color3.fromRGB(23,23,27),
    BorderSizePixel = 0,
},Main)
Corner(Header,8)

Make("TextLabel",{
    Position = UDim2.fromOffset(14,3),
    Size = UDim2.new(1,-65,0,25),
    BackgroundTransparency = 1,
    Text = "VENOM XITERZ",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left,
},Header)

Make("TextLabel",{
    Position = UDim2.fromOffset(15,27),
    Size = UDim2.new(1,-70,0,15),
    BackgroundTransparency = 1,
    Text = "AIMBOT / ESP / RAGE",
    TextColor3 = RED,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
},Header)

local Min = Make("TextButton",{
    Position = UDim2.new(1,-38,0,7),
    Size = UDim2.fromOffset(29,29),
    Text = "—",
    TextColor3 = WHITE,
    BackgroundColor3 = ELEMENT,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    BorderSizePixel = 0,
},Header)
Corner(Min,5)

-- Arrastar pelo cabeçalho
local dragging, dragStart, startPos
local dragInput

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position-dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,startPos.X.Offset+delta.X,
            startPos.Y.Scale,startPos.Y.Offset+delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local Tabs = Make("Frame",{
    Position = UDim2.fromOffset(12,57),
    Size = UDim2.new(1,-24,0,34),
    BackgroundTransparency = 1,
},Main)

local Content = Make("Frame",{
    Position = UDim2.fromOffset(12,99),
    Size = UDim2.new(1,-24,1,-111),
    BackgroundTransparency = 1,
},Main)

local Pages = {}

local function NewPage(name)
    local page = Make("Frame",{
        Name = name,
        Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1,
        Visible = false,
    },Content)
    Pages[name] = page
    return page
end

local function SelectTab(name)
    for n,page in pairs(Pages) do
        page.Visible = n == name
    end
    for _,b in ipairs(Tabs:GetChildren()) do
        if b:IsA("TextButton") then
            b.BackgroundColor3 = b.Name == name and RED or ELEMENT
        end
    end
end

for i,name in ipairs({"AIM","ESP","RAGE"}) do
    local b = Make("TextButton",{
        Name = name,
        Position = UDim2.new((i-1)/3,3,0,0),
        Size = UDim2.new(1/3,-6,1,0),
        BackgroundColor3 = ELEMENT,
        BorderSizePixel = 0,
        Text = name,
        TextColor3 = WHITE,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
    },Tabs)
    Corner(b,5)
    b.Activated:Connect(function()
        SelectTab(name)
    end)
end

local AimPage = NewPage("AIM")
local ESPPage = NewPage("ESP")
local RagePage = NewPage("RAGE")

local function Section(parent,text,y)
    Make("TextLabel",{
        Position = UDim2.fromOffset(5,y),
        Size = UDim2.new(1,-10,0,22),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = RED,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    },parent)
end

-- Toggles com quadradinhos
local function Toggle(parent,text,key,y)
    Make("TextLabel",{
        Position = UDim2.fromOffset(5,y),
        Size = UDim2.new(1,-42,0,28),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = WHITE,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    },parent)

    local button = Make("TextButton",{
        Position = UDim2.new(1,-25,0,y+6),
        Size = UDim2.fromOffset(16,16),
        BackgroundColor3 = Config[key] and RED or ELEMENT,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    },parent)

    Make("UIStroke",{
        Color = Config[key] and RED or GRAY,
        Thickness = 1,
    },button)

    button.Activated:Connect(function()
        Config[key] = not Config[key]
        button.BackgroundColor3 = Config[key] and RED or ELEMENT
        local stroke = button:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = Config[key] and RED or GRAY
        end
    end)
end

-- AIM
Section(AimPage,"AIMBOT SETTINGS",0)
Toggle(AimPage,"Aimbot (linha de visão)","Aim",27)
Toggle(AimPage,"Mostrar círculo FOV","ShowFOV",59)

local fovLabel = Make("TextLabel",{
    Position = UDim2.fromOffset(5,94),
    Size = UDim2.new(1,-10,0,22),
    BackgroundTransparency = 1,
    TextColor3 = WHITE,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    Text = "FOV: 120",
},AimPage)

local Slider = Make("Frame",{
    Position = UDim2.fromOffset(8,128),
    Size = UDim2.new(1,-16,0,6),
    BackgroundColor3 = ELEMENT,
    BorderSizePixel = 0,
},AimPage)
Corner(Slider,4)

local Fill = Make("Frame",{
    Size = UDim2.new((Config.FOV-30)/370,0,1,0),
    BackgroundColor3 = RED,
    BorderSizePixel = 0,
},Slider)
Corner(Fill,4)

local Knob = Make("TextButton",{
    AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.new((Config.FOV-30)/370,0,.5,0),
    Size = UDim2.fromOffset(15,15),
    BackgroundColor3 = WHITE,
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false,
},Slider)
Corner(Knob,8)

local sliding = false

local function SetFOV(x)
    local alpha = math.clamp(
        (x-Slider.AbsolutePosition.X)/Slider.AbsoluteSize.X,0,1
    )
    Config.FOV = math.floor(30+alpha*370)
    local value = (Config.FOV-30)/370
    Fill.Size = UDim2.new(value,0,1,0)
    Knob.Position = UDim2.new(value,0,.5,0)
    fovLabel.Text = "FOV: "..Config.FOV
end

Knob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
        SetFOV(input.Position.X)
    end
end)

Slider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
        SetFOV(input.Position.X)
    end
end)

UIS.InputChanged:Connect(function(input)
    if sliding and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        SetFOV(input.Position.X)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        sliding = false
    end
end)

-- ESP
Section(ESPPage,"ESP SETTINGS",0)
Toggle(ESPPage,"ESP LINE","Line",27)
Toggle(ESPPage,"ESP NOME","Name",59)
Toggle(ESPPage,"ESP VIDA","Health",91)
Toggle(ESPPage,"ESP BOX","Box",123)

-- RAGE
Section(RagePage,"RAGE SETTINGS",0)
Toggle(RagePage,"TELA PARADA","ScreenStop",27)
Toggle(RagePage,"TELA ESTICADA","ScreenStretched",59)

Make("TextLabel",{
    Position = UDim2.fromOffset(5,94),
    Size = UDim2.new(1,-10,0,42),
    BackgroundTransparency = 1,
    Text = "Tela esticada: aproximação visual pela câmera; não altera a resolução do aparelho.",
    TextColor3 = GRAY,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
},RagePage)

SelectTab("AIM")

-- MINIMIZAR
local minimized = false

Min.Activated:Connect(function()
    minimized = not minimized
    Tabs.Visible = not minimized
    Content.Visible = not minimized
    Main.Size = minimized
        and UDim2.fromOffset(190,48)
        or UDim2.fromOffset(430,335)
    Min.Text = minimized and "+" or "—"
end)

-- CÍRCULO FOV: redondo e desligado inicialmente
local FOVCircle = Make("Frame",{
    Name = "FOVCircle",
    AnchorPoint = Vector2.new(0.5,0.5),
    Position = UDim2.fromScale(0.5,0.5),
    Size = UDim2.fromOffset(Config.FOV*2,Config.FOV*2),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Visible = Config.ShowFOV,
},GUI)

Make("UICorner",{
    CornerRadius = UDim.new(0.5,0),
},FOVCircle)

Make("UIAspectRatioConstraint",{
    AspectRatio = 1,
},FOVCircle)

Make("UIStroke",{
    Color = RED,
    Thickness = 1.5,
},FOVCircle)

-- ESP DOS JOGADORES
local Drawings = {}

local function NewESP(player)
    local folder = Make("Folder",{
        Name = "ESP_"..player.UserId,
    },GUI)

    local box = Make("Frame",{
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
    },folder)

    Make("UIStroke",{
        Color = WHITE,
        Thickness = 1.3,
    },box)

    local healthBG = Make("Frame",{
        BackgroundColor3 = Color3.fromRGB(45,45,45),
        BorderSizePixel = 0,
        Visible = false,
    },folder)

    local health = Make("Frame",{
        BackgroundColor3 = GREEN,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0,1),
        Position = UDim2.fromScale(0,1),
        Size = UDim2.fromScale(1,1),
    },healthBG)

    local name = Make("TextLabel",{
        BackgroundTransparency = 1,
        TextColor3 = WHITE,
        TextStrokeTransparency = .2,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        Visible = false,
    },folder)

    local line = Make("Frame",{
        AnchorPoint = Vector2.new(.5,.5),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0,
        Visible = false,
    },folder)

    Drawings[player] = {
        Folder = folder,
        Box = box,
        HealthBG = healthBG,
        Health = health,
        Name = name,
        Line = line,
    }
end

local function HideESP(d)
    d.Box.Visible = false
    d.HealthBG.Visible = false
    d.Name.Visible = false
    d.Line.Visible = false
end

local function IsVisible(character,targetPart)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LP.Character}

    local origin = Camera.CFrame.Position
    local direction = targetPart.Position-origin
    local result = workspace:Raycast(origin,direction,params)

    return result ~= nil and result.Instance:IsDescendantOf(character)
end

local function GetScreenBounds(character)
    local cf,size = character:GetBoundingBox()
    local half = size/2
    local minX,minY = math.huge,math.huge
    local maxX,maxY = -math.huge,-math.huge
    local visible = false

    for x = -1,1,2 do
        for y = -1,1,2 do
            for z = -1,1,2 do
                local point = cf:PointToWorldSpace(Vector3.new(
                    half.X*x,half.Y*y,half.Z*z
                ))
                local v,onScreen = Camera:WorldToViewportPoint(point)

                if v.Z > 0 then
                    minX = math.min(minX,v.X)
                    minY = math.min(minY,v.Y)
                    maxX = math.max(maxX,v.X)
                    maxY = math.max(maxY,v.Y)
                    if onScreen then visible = true end
                end
            end
        end
    end

    if not visible or minX == math.huge then return nil end

    local width,height = maxX-minX,maxY-minY
    if width < 2 or height < 2 then return nil end
    return minX,minY,width,height
end

for _,player in ipairs(Players:GetPlayers()) do
    if player ~= LP then NewESP(player) end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LP then NewESP(player) end
end)

Players.PlayerRemoving:Connect(function(player)
    local d = Drawings[player]
    if d then d.Folder:Destroy() end
    Drawings[player] = nil
end)

-- AIM: alvo visível dentro do FOV
local function GetTarget()
    local center = Camera.ViewportSize/2
    local best,bestDistance = nil,Config.FOV

    for _,player in ipairs(Players:GetPlayers()) do
        if player ~= LP and not IsAlly(player) then
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if head and hum and hum.Health > 0 then
                local pos,onScreen = Camera:WorldToViewportPoint(head.Position)
                local distance = (
                    Vector2.new(pos.X,pos.Y)-center
                ).Magnitude

                if onScreen and distance < bestDistance
                and IsVisible(char,head) then
                    best = head
                    bestDistance = distance
                end
            end
        end
    end

    return best
end

-- RAGE: direção do joystick e efeito visual aproximado
local lastHumanoid
local lastAutoRotate
local OriginalCameraFOV

RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera
    if not Camera then return end

    local viewport = Camera.ViewportSize
    FOVCircle.Position = UDim2.fromOffset(viewport.X/2,viewport.Y/2)
    FOVCircle.Size = UDim2.fromOffset(Config.FOV*2,Config.FOV*2)
    FOVCircle.Visible = Config.ShowFOV

    -- Aproximação de tela esticada; restaura o FOV ao desligar
    if Config.ScreenStretched then
        if not OriginalCameraFOV then
            OriginalCameraFOV = Camera.FieldOfView
        end
        Camera.FieldOfView = 85
    elseif OriginalCameraFOV then
        Camera.FieldOfView = OriginalCameraFOV
        OriginalCameraFOV = nil
    end

    -- Vira o personagem na direção de movimento do joystick
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if Config.ScreenStop and hum and root then
        if lastHumanoid ~= hum then
            if lastHumanoid and lastAutoRotate ~= nil then
                lastHumanoid.AutoRotate = lastAutoRotate
            end
            lastHumanoid = hum
            lastAutoRotate = hum.AutoRotate
        end

        hum.AutoRotate = false
        local direction = hum.MoveDirection

        if direction.Magnitude > .05 then
            local flat = Vector3.new(direction.X,0,direction.Z)
            root.CFrame = CFrame.lookAt(
                root.Position,root.Position+flat
            )
        end
    else
        if lastHumanoid then
            lastHumanoid.AutoRotate = lastAutoRotate
            lastHumanoid = nil
            lastAutoRotate = nil
        end
    end

    -- AIM
    if Config.Aim then
        local target = GetTarget()
        if target then
            Camera.CFrame = CFrame.lookAt(
                Camera.CFrame.Position,target.Position
            )
        end
    end

    -- ESP
    for player,d in pairs(Drawings) do
        if IsAlly(player) then
            HideESP(d)
            continue
        end

        local character = player.Character
        local head = character and character:FindFirstChild("Head")
        local targetHum = character
            and character:FindFirstChildOfClass("Humanoid")

        if not character or not head or not targetHum
        or targetHum.Health <= 0 then
            HideESP(d)
            continue
        end

        local x,y,w,h = GetScreenBounds(character)
        if not x then
            HideESP(d)
            continue
        end

        if Config.Box then
            d.Box.Visible = true
            d.Box.Position = UDim2.fromOffset(x,y)
            d.Box.Size = UDim2.fromOffset(w,h)
        else
            d.Box.Visible = false
        end

        if Config.Health then
            d.HealthBG.Visible = true
            d.HealthBG.Position = UDim2.fromOffset(x-6,y)
            d.HealthBG.Size = UDim2.fromOffset(4,h)
            d.Health.Size = UDim2.new(
                1,0,math.clamp(
                    targetHum.Health/targetHum.MaxHealth,0,1
                ),0
            )
        else
            d.HealthBG.Visible = false
        end

        if Config.Name then
            d.Name.Visible = true
            d.Name.Text = player.DisplayName
            d.Name.Position = UDim2.fromOffset(x,y-20)
            d.Name.Size = UDim2.fromOffset(w,18)
        else
            d.Name.Visible = false
        end

        if Config.Line then
            local pos,onScreen =
                Camera:WorldToViewportPoint(head.Position)
            d.Line.Visible = onScreen and pos.Z > 0

            if d.Line.Visible then
                local start = Vector2.new(viewport.X/2,0)
                local finish = Vector2.new(pos.X,pos.Y)
                local delta = finish-start

                d.Line.Position = UDim2.fromOffset(
                    (start.X+finish.X)/2,
                    (start.Y+finish.Y)/2
                )
                d.Line.Size = UDim2.fromOffset(delta.Magnitude,1)
                d.Line.Rotation = math.deg(
                    math.atan2(delta.Y,delta.X)
                )
            end
        else
            d.Line.Visible = false
        end
    end
end)

-- Restaura configurações ao encerrar o script
GUI.Destroying:Connect(function()
    if lastHumanoid and lastAutoRotate ~= nil then
        lastHumanoid.AutoRotate = lastAutoRotate
    end
    if Camera and OriginalCameraFOV then
        Camera.FieldOfView = OriginalCameraFOV
    end
end)
