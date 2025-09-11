-- Ghost Menu Script Hub - Complete (TEMP + PERMA keys)
-- Versão final: Login com keys temporárias (14 dias) e permanentes (sem expirar)
-- Inclui hub completo com abas e templates (pronto para editar)
-- OBS: writefile/readfile/isfile/setclipboard/StarterGui:SetCore dependem do executor (Synapse, KRNL, etc.)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local mainColor = Color3.fromRGB(20, 20, 20)
local accentColor = Color3.fromRGB(200, 0, 0)
local sideColor = Color3.fromRGB(30, 30, 30)
local navColor = Color3.fromRGB(35, 39, 42)
local textColor = Color3.fromRGB(255,255,255)
local subTextColor = Color3.fromRGB(180,180,180)

local dragging, dragInput, dragStart, startPos

-- === SISTEMA DE KEYS ===
local TEMP_KEYS = { -- duram 14 dias
    "GHOST123",
    "VIPKEY456",
    "TESTE789",
}
local PERMA_KEYS = { -- nunca expiram
    "PERMA123",
    "VIPFOREVER",
}

local KEYFILE = "ghostmenu_key.txt" -- arquivo que o executor salva

local function writeKeyFile(content)
    if writefile then
        pcall(function() writefile(KEYFILE, tostring(content)) end)
    end
end

local function readKeyFile()
    if isfile and readfile then
        local ok, content = pcall(function() return readfile(KEYFILE) end)
        if ok then return content end
    end
    return nil
end

local function saveAccessTemp()
    local expireTime = os.time() + (14 * 24 * 60 * 60)
    writeKeyFile(tostring(expireTime))
end

local function saveAccessPerma()
    writeKeyFile("PERMANENT")
end

local function hasAccess()
    local content = readKeyFile()
    if not content then return false, nil end
    if content == "PERMANENT" then
        return true, "PERMANENT"
    end
    local expireTime = tonumber(content)
    if expireTime and os.time() < expireTime then
        return true, expireTime
    end
    return false, expireTime
end

local function isValidKey(input)
    for _,k in ipairs(TEMP_KEYS) do
        if input == k then return "TEMP" end
    end
    for _,k in ipairs(PERMA_KEYS) do
        if input == k then return "PERMA" end
    end
    return nil
end

-- === TEMPLATES E ABAS ===
local templates = {
    fly = "-- TEMPLATE: Fly script\\n-- Substitua por um script real\\nprint('Fly template')",
    esp = "-- TEMPLATE: ESP script\\nprint('ESP template')",
    aimlock = "-- TEMPLATE: Aimlock script\\nprint('Aimlock template')",
    petsimx_autoclaim = "-- TEMPLATE: Pet Sim X - AutoClaim\\nprint('PetSimX AutoClaim')",
    petsimx_autofarm = "-- TEMPLATE: Pet Sim X - AutoFarm\\nprint('PetSimX AutoFarm')",
    shindo_rboss = "-- TEMPLATE: Shindo Bossfarm\\nprint('Shindo Bossfarm')",
    kinglegacy_ops = "-- TEMPLATE: King Legacy OP\\nprint('King Legacy')",
    vbaop_tool = "-- TEMPLATE: VBA OP helper\\nprint('VBA OP')",
}

-- TABELA DE JOGOS E SUAS ABAS ESPECÍFICAS
local gameTabs = {
    [6284583030] = { -- Pet Simulator X
        {Name = "Pet Sim X", Content = "petsimx"},
    },
    [4520749081] = { -- Shindo Life
        {Name = "Shindo Life", Content = "shindo"},
    },
    [3475397644] = { -- King Legacy
        {Name = "KING LEGACY", Content = "kinglegacy"},
    },
    [9431156611] = { -- VBA OP (exemplo)
        {Name = "VBA OP", Content = "vbaop"},
    },
    -- Adicione outros jogos aqui
}

-- Abas gerais SEMPRE visíveis
local baseTabs = {
    {Name = "Credits", Content = "credits"},
    {Name = "SEARCH Scripts", Content = "search"},
    {Name = "General Use Scripts", Content = "general"},
    {Name = "Bug Reports", Content = "bugs"},
}

-- Função para montar as abas de acordo com o jogo
local function getTabsForCurrentGame()
    local tabs = {}
    for _,tab in ipairs(baseTabs) do table.insert(tabs, tab) end
    local specific = gameTabs[game.PlaceId]
    if specific then
        for _,tab in ipairs(specific) do table.insert(tabs, tab) end
    end
    return tabs
end

local tabs = getTabsForCurrentGame()

local function makeButton(parent, text, posY, sizeX)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(sizeX or 0.7, 0, 0, 36)
    btn.Position = UDim2.new(0.15, 0, 0, posY)
    btn.BackgroundColor3 = accentColor
    btn.TextColor3 = textColor
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.BorderSizePixel = 0
    btn.Parent = parent
    return btn
end

local tabContents = {}

-- Credits
tabContents.credits = function(mainArea)
    for _,v in pairs(mainArea:GetChildren()) do v:Destroy() end
    local y = 40
    local b1 = makeButton(mainArea, "Discord Server (click to copy)", y); y = y + 50
    b1.MouseButton1Click:Connect(function()
        if setclipboard then pcall(function() setclipboard("https://discord.gg/ghostmenu") end) end
        b1.Text = "Copied!"
        wait(1)
        b1.Text = "Discord Server (click to copy)"
    end)
    local b2 = makeButton(mainArea, "If you need help DM SeuUser#0000", y); y = y + 50
    local b3 = makeButton(mainArea, "Credit To Everyone", y); y = y + 50
end

-- SEARCH
tabContents.search = function(mainArea)
    for _,v in pairs(mainArea:GetChildren()) do v:Destroy() end
    local title = Instance.new("TextLabel", mainArea)
    title.Text = "Pesquisar scripts (digite e pressione Enter)"
    title.Size = UDim2.new(1, -40, 0, 24)
    title.Position = UDim2.new(0, 20, 0, 20)
    title.BackgroundTransparency = 1
    title.TextColor3 = textColor
    title.Font = Enum.Font.SourceSans
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left

    local searchBox = Instance.new("TextBox", mainArea)
    searchBox.PlaceholderText = "Buscar... ex: pet, esp, fly"
    searchBox.Size = UDim2.new(0.6, 0, 0, 28)
    searchBox.Position = UDim2.new(0, 20, 0, 50)
    searchBox.BackgroundColor3 = navColor
    searchBox.TextColor3 = textColor
    searchBox.Font = Enum.Font.SourceSans
    searchBox.TextSize = 14
    searchBox.ClearTextOnFocus = false

    local resultsFrame = Instance.new("Frame", mainArea)
    resultsFrame.Size = UDim2.new(1, -40, 1, -120)
    resultsFrame.Position = UDim2.new(0, 20, 0, 90)
    resultsFrame.BackgroundTransparency = 1

    local function populateResults(filter)
        for _,c in pairs(resultsFrame:GetChildren()) do c:Destroy() end
        local y = 0
        filter = (filter or ""):lower()
        local function addResult(name, code)
            if filter == "" or string.find(name:lower(), filter) or string.find(code:lower(), filter) then
                local btn = Instance.new("TextButton", resultsFrame)
                btn.Text = name
                btn.Size = UDim2.new(0.9,0,0,34)
                btn.Position = UDim2.new(0.05,0,0, y)
                btn.BackgroundColor3 = accentColor
                btn.TextColor3 = textColor
                btn.Font = Enum.Font.SourceSansBold
                btn.TextSize = 14
                btn.BorderSizePixel = 0
                y = y + 40
                btn.MouseButton1Click:Connect(function()
                    if setclipboard then pcall(function() setclipboard(code) end) end
                    btn.Text = "Copiado!"
                    wait(1)
                    btn.Text = name
                end)
            end
        end

        addResult("Fly (template)", templates.fly)
        addResult("ESP (template)", templates.esp)
        addResult("Aimlock (template)", templates.aimlock)
        addResult("PetSimX - AutoClaim (template)", templates.petsimx_autoclaim)
        addResult("PetSimX - AutoFarm (template)", templates.petsimx_autofarm)
        addResult("Shindo Bossfarm (template)", templates.shindo_rboss)
        addResult("KingLegacy OP (template)", templates.kinglegacy_ops)
        addResult("VBA OP Tool (template)", templates.vbaop_tool)
    end

    populateResults("")
    searchBox.FocusLost:Connect(function(enter)
        if enter then populateResults(searchBox.Text or "") end
    end)
end

-- General
tabContents.general = function(mainArea)
    for _,v in pairs(mainArea:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end

    local b1 = makeButton(mainArea, "Fly (copiar template)")
    b1.MouseButton1Click:Connect(function()
        if setclipboard then pcall(function() setclipboard(templates.fly) end) end
        b1.Text = "Copied!"
        wait(1)
        b1.Text = "Fly (copiar template)"
    end)
    local b2 = makeButton(mainArea, "ESP (copiar template)")
    b2.MouseButton1Click:Connect(function()
        if setclipboard then pcall(function() setclipboard(templates.esp) end) end
        b2.Text = "Copied!"
        wait(1)
        b2.Text = "ESP (copiar template)"
    end)
    local b3 = makeButton(mainArea, "Aimlock (copiar template)")
    b3.MouseButton1Click:Connect(function()
        if setclipboard then pcall(function() setclipboard(templates.aimlock) end) end
        b3.Text = "Copied!"
        wait(1)
        b3.Text = "Aimlock (copiar template)"
    end)
end

-- Bugs
tabContents.bugs = function(mainArea)
    for _,v in pairs(mainArea:GetChildren()) do v:Destroy() end
    local label = Instance.new("TextLabel", mainArea)
    label.Text = "Reporte de Bugs (isso só copia o reporte pro clipboard local para você postar no discord)"
    label.Size = UDim2.new(1, -40, 0, 40)
    label.Position = UDim2.new(0, 20, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = textColor
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextWrapped = true

    local txt = Instance.new("TextBox", mainArea)
    txt.Size = UDim2.new(1, -40, 0, 120)
    txt.Position = UDim2.new(0, 20, 0, 70)
    txt.BackgroundColor3 = navColor
    txt.TextColor3 = textColor
    txt.Font = Enum.Font.SourceSans
    txt.ClearTextOnFocus = false
    txt.Text = "Descreva o bug, passos para reproduzir, jogo/servidor, prints (links) etc."

    local sendBtn = Instance.new("TextButton", mainArea)
    sendBtn.Text = "Copiar reporte (colar no Discord)"
    sendBtn.Size = UDim2.new(0.6,0,0,36)
    sendBtn.Position = UDim2.new(0.2,0,0,200)
    sendBtn.BackgroundColor3 = accentColor
    sendBtn.TextColor3 = textColor
    sendBtn.Font = Enum.Font.SourceSansBold
    sendBtn.MouseButton1Click:Connect(function()
        local content = txt.Text or ""
        if setclipboard then pcall(function() setclipboard(content) end) end
        sendBtn.Text = "Copiado!"
        wait(1)
        sendBtn.Text = "Copiar reporte (colar no Discord)"
    end)
end

-- PetSimX
tabContents.petsimx = function(mainArea)
    for _,v in pairs(mainArea:GetChildren()) do v:Destroy() end
    local y = 40
    local b1 = makeButton(mainArea, "AutoClaim (copiar template)", y); y = y + 50
    b1.MouseButton1Click:Connect(function()
        if setclipboard then pcall(function() setclipboard(templates.petsimx_autoclaim) end) end
        b1.Text = "Copied!"
        wait(1)
        b1.Text = "AutoClaim (copiar template)"
    end)
    local b2 = makeButton(mainArea, "AutoFarm (copiar template)", y); y = y + 50
    b2.MouseButton1Click:Connect(function()
        if setclipboard then pcall(function() setclipboard(templates.petsimx_autofarm) end) end
        b2.Text = "Copied!"
        wait(1)
        b2.Text = "AutoFarm (copiar template)"
    end)
end

-- VBA OP
tabContents.vbaop = function(mainArea)
    for _,v in pairs(mainArea:GetChildren()) do v:Destroy() end
    local y = 40
    local b1 = makeButton(mainArea, "VBA OP Tool (copiar template)", y); y = y + 50
    b1.MouseButton1Click:Connect(function()
        if setclipboard then pcall(function() setclipboard(templates.vbaop_tool) end) end
        b1.Text = "Copied!"
        wait(1)
        b1.Text = "VBA OP Tool (copiar template)"
    end)
    local info = Instance.new("TextLabel", mainArea)
    info.Text = "Coloque aqui scripts específicos do servidor/versão quando quiser."
    info.Size = UDim2.new(1, -40, 0, 40)
    info.Position = UDim2.new(0, 20, 0, 120)
    info.BackgroundTransparency = 1
    info.TextColor3 = subTextColor
    info.Font = Enum.Font.SourceSans
    info.TextSize = 14
end

-- Shindo
tabContents.shindo = function(mainArea)
    for _,v in pairs(mainArea:GetChildren()) do v:Destroy() end
    local y = 40
    local b1 = makeButton(mainArea, "Shindo Bossfarm (copiar template)", y); y = y + 50
    b1.MouseButton1Click:Connect(function()
        if setclipboard then pcall(function() setclipboard(templates.shindo_rboss) end) end
        b1.Text = "Copied!"
        wait(1)
        b1.Text = "Shindo Bossfarm (copiar template)"
    end)
end

-- King Legacy
tabContents.kinglegacy = function(mainArea)
    for _,v in pairs(mainArea:GetChildren()) do v:Destroy() end
    local y = 40
    local b1 = makeButton(mainArea, "King Legacy OP (copiar template)", y); y = y + 50
    b1.MouseButton1Click:Connect(function()
        if setclipboard then pcall(function() setclipboard(templates.kinglegacy_ops) end) end
        b1.Text = "Copied!"
        wait(1)
        b1.Text = "King Legacy OP (copiar template)"
    end)
end

-- === FUNÇÃO ABRIR HUB ===
local function abrirHub()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GhostMenuHub"
    screenGui.Parent = player.PlayerGui
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 540, 0, 370)
    mainFrame.Position = UDim2.new(0.5, -270, 0.5, -185)
    mainFrame.BackgroundColor3 = mainColor
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true

    local topBar = Instance.new("Frame", mainFrame)
    topBar.Size = UDim2.new(1, 0, 0, 32)
    topBar.BackgroundColor3 = accentColor
    topBar.BorderSizePixel = 0

    local title = Instance.new("TextLabel", topBar)
    title.Text = "Ghost Menu Script Hub V1.0"
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = textColor
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left

    local minBtn = Instance.new("TextButton", topBar)
    minBtn.Text = "_"
    minBtn.Size = UDim2.new(0, 32, 0, 32)
    minBtn.Position = UDim2.new(1, -64, 0, 0)
    minBtn.BackgroundColor3 = accentColor
    minBtn.TextColor3 = textColor
    minBtn.Font = Enum.Font.SourceSansBold
    minBtn.TextSize = 24
    minBtn.BorderSizePixel = 0

    local closeBtn = Instance.new("TextButton", topBar)
    closeBtn.Text = "X"
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -32, 0, 0)
    closeBtn.BackgroundColor3 = accentColor
    closeBtn.TextColor3 = textColor
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 20
    closeBtn.BorderSizePixel = 0

    local avatarBar = Instance.new("Frame", mainFrame)
    avatarBar.Size = UDim2.new(0, 60, 1, -32)
    avatarBar.Position = UDim2.new(0, 0, 0, 32)
    avatarBar.BackgroundColor3 = sideColor
    avatarBar.BorderSizePixel = 0

    local avatarCircle = Instance.new("Frame", avatarBar)
    avatarCircle.Size = UDim2.new(0, 40, 0, 40)
    avatarCircle.Position = UDim2.new(0.5, -20, 0, 16)
    avatarCircle.BackgroundColor3 = accentColor
    avatarCircle.BorderSizePixel = 0
    avatarCircle.ClipsDescendants = true
    local uicorner = Instance.new("UICorner", avatarCircle)
    uicorner.CornerRadius = UDim.new(1,0)

    local avatarLetter = Instance.new("TextLabel", avatarCircle)
    avatarLetter.Text = string.sub(player.Name,1,1):upper()
    avatarLetter.Size = UDim2.new(1, 0, 1, 0)
    avatarLetter.BackgroundTransparency = 1
    avatarLetter.TextColor3 = textColor
    avatarLetter.Font = Enum.Font.SourceSansBold
    avatarLetter.TextSize = 24

    local navCol = Instance.new("Frame", mainFrame)
    navCol.Size = UDim2.new(0, 160, 1, -32)
    navCol.Position = UDim2.new(0, 60, 0, 32)
    navCol.BackgroundColor3 = navColor
    navCol.BorderSizePixel = 0

    local authLabel = Instance.new("TextLabel", navCol)
    authLabel.Text = "Ghost Menu"
    authLabel.Size = UDim2.new(1, 0, 0, 28)
    authLabel.Position = UDim2.new(0, 0, 0, 10)
    authLabel.BackgroundTransparency = 1
    authLabel.TextColor3 = subTextColor
    authLabel.Font = Enum.Font.SourceSansBold
    authLabel.TextSize = 15
    authLabel.TextXAlignment = Enum.TextXAlignment.Left

    local navBar = Instance.new("ScrollingFrame", navCol)
    navBar.Size = UDim2.new(1, 0, 1, -60)
    navBar.Position = UDim2.new(0, 0, 0, 38)
    navBar.BackgroundTransparency = 1
    navBar.BorderSizePixel = 0
    navBar.CanvasSize = UDim2.new(0, 0, 0, 400)
    navBar.ScrollBarThickness = 6
    navBar.ScrollBarImageColor3 = accentColor

    local navLayout = Instance.new("UIListLayout", navBar)
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Padding = UDim.new(0, 2)

    local mainArea = Instance.new("ScrollingFrame", mainFrame)
    mainArea.Size = UDim2.new(1, -220, 1, -32)
    mainArea.Position = UDim2.new(0, 220, 0, 32)
    mainArea.BackgroundTransparency = 1
    mainArea.Name = "MainArea"
    mainArea.CanvasSize = UDim2.new(0, 0, 0, 600) -- ajuste conforme necessário
    mainArea.ScrollBarThickness = 8
    mainArea.ScrollBarImageColor3 = accentColor
    mainArea.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local layout = Instance.new("UIListLayout", mainArea)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)

    local profileFrame = Instance.new("Frame", navCol)
    profileFrame.Size = UDim2.new(1, 0, 0, 48)
    profileFrame.Position = UDim2.new(0, 0, 1, -48)
    profileFrame.BackgroundColor3 = sideColor
    profileFrame.BorderSizePixel = 0

    local profileAvatar = Instance.new("ImageLabel", profileFrame)
    profileAvatar.Size = UDim2.new(0, 32, 0, 32)
    profileAvatar.Position = UDim2.new(0, 8, 0, 8)
    profileAvatar.BackgroundTransparency = 1
    profileAvatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=420&height=420&format=png"
    local profileCorner = Instance.new("UICorner", profileAvatar)
    profileCorner.CornerRadius = UDim.new(1,0)

    local profileName = Instance.new("TextLabel", profileFrame)
    profileName.Text = player.Name
    profileName.Size = UDim2.new(1, -70, 0, 20)
    profileName.Position = UDim2.new(0, 44, 0, 8)
    profileName.BackgroundTransparency = 1
    profileName.TextColor3 = textColor
    profileName.Font = Enum.Font.SourceSansBold
    profileName.TextSize = 14
    profileName.TextXAlignment = Enum.TextXAlignment.Left

    local profileTag = Instance.new("TextLabel", profileFrame)
    profileTag.Text = "#1234"
    profileTag.Size = UDim2.new(1, -70, 0, 16)
    profileTag.Position = UDim2.new(0, 44, 0, 24)
    profileTag.BackgroundTransparency = 1
    profileTag.TextColor3 = subTextColor
    profileTag.Font = Enum.Font.SourceSans
    profileTag.TextSize = 12
    profileTag.TextXAlignment = Enum.TextXAlignment.Left

    local gear = Instance.new("ImageLabel", profileFrame)
    gear.Size = UDim2.new(0, 18, 0, 18)
    gear.Position = UDim2.new(1, -26, 0, 15)
    gear.BackgroundTransparency = 1
    gear.Image = "rbxassetid://6031068438"
    gear.ImageColor3 = subTextColor

    -- validade no rodapé (se houver)
    do
        local access, expire = hasAccess()
        if access then
            local expireLabel = Instance.new("TextLabel", profileFrame)
            if expire == "PERMANENT" then
                expireLabel.Text = "Validade: Permanente"
            else
                expireLabel.Text = "Validade: " .. os.date("%d/%m/%Y", expire)
            end
            expireLabel.Size = UDim2.new(1, -10, 0, 14)
            expireLabel.Position = UDim2.new(0, 5, 1, -14)
            expireLabel.BackgroundTransparency = 1
            expireLabel.TextColor3 = subTextColor
            expireLabel.Font = Enum.Font.SourceSans
            expireLabel.TextSize = 12
            expireLabel.TextXAlignment = Enum.TextXAlignment.Left
        end
    end

    local function selectTab(tabContent)
        for _,btn in pairs(navBar:GetChildren()) do
            if btn:IsA("TextButton") then
                if btn.Name == tabContent then
                    btn.BackgroundColor3 = accentColor
                    btn.TextColor3 = textColor
                else
                    btn.BackgroundColor3 = navColor
                    btn.TextColor3 = subTextColor
                end
            end
        end
        if tabContents[tabContent] then
            tabContents[tabContent](mainArea)
        else
            for _,v in pairs(mainArea:GetChildren()) do v:Destroy() end
            local label = Instance.new("TextLabel", mainArea)
            label.Text = "Conteúdo da aba: "..tabContent
            label.Size = UDim2.new(1, -40, 0, 40)
            label.Position = UDim2.new(0, 20, 0, 40)
            label.BackgroundTransparency = 1
            label.TextColor3 = textColor
            label.Font = Enum.Font.SourceSans
            label.TextSize = 16
            label.TextWrapped = true
        end
    end

    for _,tab in ipairs(tabs) do
        local btn = Instance.new("TextButton", navBar)
        btn.Name = tab.Content -- agora usa o Content como identificador
        btn.Text = "# " .. tab.Name
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = navColor
        btn.TextColor3 = subTextColor
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 16
        btn.BorderSizePixel = 0
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.MouseButton1Click:Connect(function()
            selectTab(tab.Content)
        end)
    end

    selectTab(tabs[1].Content)

    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        avatarBar.Visible = not minimized
        navCol.Visible = not minimized
        mainArea.Visible = not minimized
        if minimized then
            mainFrame.Size = UDim2.new(0, 540, 0, 32)
        else
            mainFrame.Size = UDim2.new(0, 540, 0, 370)
        end
    end)
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- === TELA DE LOGIN (estilo Discord) ===
local function criarLoginDiscordStyle()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DiscordLogin"
    screenGui.Parent = player.PlayerGui
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 540, 0, 370)
    mainFrame.Position = UDim2.new(0.5, -270, 0.5, -185)
    mainFrame.BackgroundColor3 = mainColor
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true

    local topBar = Instance.new("Frame", mainFrame)
    topBar.Size = UDim2.new(1, 0, 0, 32)
    topBar.BackgroundColor3 = accentColor
    topBar.BorderSizePixel = 0

    local title = Instance.new("TextLabel", topBar)
    title.Text = "Ghost Menu | discord.gg/ghostmenu"
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = textColor
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left

    local avatarBar = Instance.new("Frame", mainFrame)
    avatarBar.Size = UDim2.new(0, 60, 1, -32)
    avatarBar.Position = UDim2.new(0, 0, 0, 32)
    avatarBar.BackgroundColor3 = sideColor
    avatarBar.BorderSizePixel = 0

    local avatarCircle = Instance.new("Frame", avatarBar)
    avatarCircle.Size = UDim2.new(0, 40, 0, 40)
    avatarCircle.Position = UDim2.new(0.5, -20, 0, 16)
    avatarCircle.BackgroundColor3 = accentColor
    avatarCircle.BorderSizePixel = 0
    avatarCircle.ClipsDescendants = true
    local uicorner = Instance.new("UICorner", avatarCircle)
    uicorner.CornerRadius = UDim.new(1,0)

    local avatarLetter = Instance.new("TextLabel", avatarCircle)
    avatarLetter.Text = string.sub(player.Name,1,1):upper()
    avatarLetter.Size = UDim2.new(1, 0, 1, 0)
    avatarLetter.BackgroundTransparency = 1
    avatarLetter.TextColor3 = textColor
    avatarLetter.Font = Enum.Font.SourceSansBold
    avatarLetter.TextSize = 24

    local navCol = Instance.new("Frame", mainFrame)
    navCol.Size = UDim2.new(0, 160, 1, -32)
    navCol.Position = UDim2.new(0, 60, 0, 32)
    navCol.BackgroundColor3 = navColor
    navCol.BorderSizePixel = 0

    local authLabel = Instance.new("TextLabel", navCol)
    authLabel.Text = "Authentication"
    authLabel.Size = UDim2.new(1, 0, 0, 28)
    authLabel.Position = UDim2.new(0, 0, 0, 10)
    authLabel.BackgroundTransparency = 1
    authLabel.TextColor3 = subTextColor
    authLabel.Font = Enum.Font.SourceSansBold
    authLabel.TextSize = 15
    authLabel.TextXAlignment = Enum.TextXAlignment.Left

    local loginLabel = Instance.new("TextLabel", navCol)
    loginLabel.Text = "# Login"
    loginLabel.Size = UDim2.new(1, -18, 0, 28)
    loginLabel.Position = UDim2.new(0, 10, 0, 38)
    loginLabel.BackgroundTransparency = 1
    loginLabel.TextColor3 = textColor
    loginLabel.Font = Enum.Font.SourceSansBold
    loginLabel.TextSize = 17
    loginLabel.TextXAlignment = Enum.TextXAlignment.Left

    local helpLabel = Instance.new("TextButton", navCol)
    helpLabel.Text = "# Help"
    helpLabel.Size = UDim2.new(1, -18, 0, 28)
    helpLabel.Position = UDim2.new(0, 10, 0, 66)
    helpLabel.BackgroundTransparency = 1
    helpLabel.TextColor3 = subTextColor
    helpLabel.Font = Enum.Font.SourceSans
    helpLabel.TextSize = 17
    helpLabel.TextXAlignment = Enum.TextXAlignment.Left
    helpLabel.BorderSizePixel = 0
    helpLabel.AutoButtonColor = true

    local profileFrame = Instance.new("Frame", navCol)
    profileFrame.Size = UDim2.new(1, 0, 0, 48)
    profileFrame.Position = UDim2.new(0, 0, 1, -48)
    profileFrame.BackgroundColor3 = sideColor
    profileFrame.BorderSizePixel = 0

    local profileAvatar = Instance.new("ImageLabel", profileFrame)
    profileAvatar.Size = UDim2.new(0, 32, 0, 32)
    profileAvatar.Position = UDim2.new(0, 8, 0, 8)
    profileAvatar.BackgroundTransparency = 1
    profileAvatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=420&height=420&format=png"
    local profileCorner = Instance.new("UICorner", profileAvatar)
    profileCorner.CornerRadius = UDim.new(1,0)

    local profileName = Instance.new("TextLabel", profileFrame)
    profileName.Text = player.Name
    profileName.Size = UDim2.new(1, -70, 0, 20)
    profileName.Position = UDim2.new(0, 44, 0, 8)
    profileName.BackgroundTransparency = 1
    profileName.TextColor3 = textColor
    profileName.Font = Enum.Font.SourceSansBold
    profileName.TextSize = 14
    profileName.TextXAlignment = Enum.TextXAlignment.Left

    local profileTag = Instance.new("TextLabel", profileFrame)
    profileTag.Text = "#1234"
    profileTag.Size = UDim2.new(1, -70, 0, 16)
    profileTag.Position = UDim2.new(0, 44, 0, 24)
    profileTag.BackgroundTransparency = 1
    profileTag.TextColor3 = subTextColor
    profileTag.Font = Enum.Font.SourceSans
    profileTag.TextSize = 12
    profileTag.TextXAlignment = Enum.TextXAlignment.Left

    local mainArea = Instance.new("Frame", mainFrame)
    mainArea.Size = UDim2.new(1, -220, 1, -32)
    mainArea.Position = UDim2.new(0, 220, 0, 32)
    mainArea.BackgroundTransparency = 1
    mainArea.Name = "MainArea"

    local loginTitle = Instance.new("TextLabel", mainArea)
    loginTitle.Text = "# Login"
    loginTitle.Size = UDim2.new(1, -32, 0, 32)
    loginTitle.Position = UDim2.new(0, 16, 0, 10)
    loginTitle.BackgroundTransparency = 1
    loginTitle.TextColor3 = textColor
    loginTitle.Font = Enum.Font.SourceSansBold
    loginTitle.TextSize = 20
    loginTitle.TextXAlignment = Enum.TextXAlignment.Left

    local enterKeyLabel = Instance.new("TextLabel", mainArea)
    enterKeyLabel.Text = "Enter Key"
    enterKeyLabel.Size = UDim2.new(1, -32, 0, 20)
    enterKeyLabel.Position = UDim2.new(0, 16, 0, 48)
    enterKeyLabel.BackgroundTransparency = 1
    enterKeyLabel.TextColor3 = subTextColor
    enterKeyLabel.Font = Enum.Font.SourceSans
    enterKeyLabel.TextSize = 15
    enterKeyLabel.TextXAlignment = Enum.TextXAlignment.Left

    local keyBox = Instance.new("TextBox", mainArea)
    keyBox.PlaceholderText = "Type key here! Press Enter"
    keyBox.Size = UDim2.new(1, -32, 0, 32)
    keyBox.Position = UDim2.new(0, 16, 0, 70)
    keyBox.BackgroundColor3 = navColor
    keyBox.TextColor3 = textColor
    keyBox.Font = Enum.Font.SourceSans
    keyBox.TextSize = 15
    keyBox.ClearTextOnFocus = false
    keyBox.BorderSizePixel = 0

    local tryKey = Instance.new("TextButton", mainArea)
    tryKey.Text = "Try Key"
    tryKey.Size = UDim2.new(1, -32, 0, 32)
    tryKey.Position = UDim2.new(0, 16, 0, 110)
    tryKey.BackgroundColor3 = accentColor
    tryKey.TextColor3 = textColor
    tryKey.Font = Enum.Font.SourceSansBold
    tryKey.TextSize = 16
    tryKey.BorderSizePixel = 0

    local othersLabel = Instance.new("TextLabel", mainArea)
    othersLabel.Text = "Others"
    othersLabel.Size = UDim2.new(1, -32, 0, 18)
    othersLabel.Position = UDim2.new(0, 16, 0, 150)
    othersLabel.BackgroundTransparency = 1
    othersLabel.TextColor3 = subTextColor
    othersLabel.Font = Enum.Font.SourceSans
    othersLabel.TextSize = 14
    othersLabel.TextXAlignment = Enum.TextXAlignment.Left

    local discordBtn = Instance.new("TextButton", mainArea)
    discordBtn.Text = "Join Discord Server"
    discordBtn.Size = UDim2.new(1, -32, 0, 32)
    discordBtn.Position = UDim2.new(0, 16, 0, 172)
    discordBtn.BackgroundColor3 = accentColor
    discordBtn.TextColor3 = textColor
    discordBtn.Font = Enum.Font.SourceSansBold
    discordBtn.TextSize = 16
    discordBtn.BorderSizePixel = 0

    local freeKeyBtn = Instance.new("TextButton", mainArea)
    freeKeyBtn.Text = "Get Free Key"
    freeKeyBtn.Size = UDim2.new(1, -32, 0, 32)
    freeKeyBtn.Position = UDim2.new(0, 16, 0, 212)
    freeKeyBtn.BackgroundColor3 = accentColor
    freeKeyBtn.TextColor3 = textColor
    freeKeyBtn.Font = Enum.Font.SourceSansBold
    freeKeyBtn.TextSize = 16
    freeKeyBtn.BorderSizePixel = 0

    local permKeyBtn = Instance.new("TextButton", mainArea)
    permKeyBtn.Text = "Purchase Permanent Key"
    permKeyBtn.Size = UDim2.new(1, -32, 0, 32)
    permKeyBtn.Position = UDim2.new(0, 16, 0, 252)
    permKeyBtn.BackgroundColor3 = accentColor
    permKeyBtn.TextColor3 = textColor
    permKeyBtn.Font = Enum.Font.SourceSansBold
    permKeyBtn.TextSize = 16
    permKeyBtn.BorderSizePixel = 0

    tryKey.MouseButton1Click:Connect(function()
        local input = keyBox.Text or ""
        local res = isValidKey(input)
        if res == "TEMP" then
            saveAccessTemp()
            screenGui:Destroy()
            abrirHub()
        elseif res == "PERMA" then
            saveAccessPerma()
            screenGui:Destroy()
            abrirHub()
        else
            tryKey.Text = "Invalid Key!"
            tryKey.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
            wait(1.5)
            tryKey.Text = "Try Key"
            tryKey.BackgroundColor3 = accentColor
        end
    end)

    discordBtn.MouseButton1Click:Connect(function()
        if setclipboard then pcall(function() setclipboard("https://discord.gg/ghostmenu") end) end
        discordBtn.Text = "Copied!"
        wait(1)
        discordBtn.Text = "Join Discord Server"
    end)

    freeKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then pcall(function() setclipboard("https://ghostmenu.com/getkey") end) end
        freeKeyBtn.Text = "Copied!"
        wait(1)
        freeKeyBtn.Text = "Get Free Key"
    end)

    permKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then pcall(function() setclipboard("https://ghostmenu.com/buykey") end) end
        permKeyBtn.Text = "Copied!"
        wait(1)
        permKeyBtn.Text = "Purchase Permanent Key"
    end)

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- === INICIALIZAÇÃO ===
local access, expire = hasAccess()
if access then
    abrirHub()
    -- notificação
    local s = game:GetService("StarterGui")
    pcall(function()
        if expire == "PERMANENT" then
            if s.SetCore then s:SetCore("SendNotification", {Title = "Ghost Menu", Text = "Acesso Permanente liberado!", Duration = 5}) end
        else
            if s.SetCore then s:SetCore("SendNotification", {Title = "Ghost Menu", Text = "Acesso válido até "..os.date("%d/%m/%Y", expire), Duration = 5}) end
        end
    end)
else
    criarLoginDiscordStyle()
end

-- FIM DO ARQUIVO
