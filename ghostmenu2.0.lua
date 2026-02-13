-- Roblox Lua: Menu visual idêntico à imagem, apenas aba Aimbot e painel Attack

print("[DEBUG] Script carregado e executando!")

-- Bypass simples: em modo SANDBOX bloqueia qualquer envio para RemoteEvents/Functions
local BypassEnabled = true

local function fireServerBypass(remote, ...)
    -- Em modo sanitizado, não enviamos chamadas ao servidor para evitar bans/comportamento indevido
    pcall(function()
        print("[SANDBOX] Remote call blocked:", remote and (remote.Name or tostring(remote)) or "nil")
    end)
    return nil
end

-- Antes de criar o menu:
local player = game:GetService("Players").LocalPlayer
-- Defaults globais
local FOV_RADIUS = 120
local fovCircleColor = Color3.fromRGB(255, 40, 40)
local fovCircle = nil
-- Estado/shared defaults
local targetsOption = "Knocked, Bots"
local selectedBone = nil
local selectedPlayer = nil
local selectedWeapon = nil
local function getOrCreateMenu()
    local gui = player.PlayerGui:FindFirstChild("FortniteMenu")
    if gui then
        return gui
    end
    -- Criação do menu normalmente
    gui = Instance.new("ScreenGui")
    gui.Name = "FortniteMenu"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true -- ignora a barra superior do Roblox
    gui.DisplayOrder = 9999 -- sempre no topo
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global -- zindex global para sobrepor tudo
    gui.Parent = player.PlayerGui
    return gui
end

local gui = getOrCreateMenu()

-- Janela principal (ainda maior)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 820, 0, 520)
main.Position = UDim2.new(0.5, -410, 0.5, -260)
main.Visible = false -- Começa oculto
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- preto
main.BorderSizePixel = 0
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Parent = gui

-- Visual moderno para a janela principal: gradiente e contorno sutil
-- (Visuals para o frame principal definidos mais abaixo)

-- Services para animações
local TweenService = game:GetService("TweenService")
local tweenInfoFast = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfoMed = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function showMenu()
    if main.Visible then return end
    main.Position = UDim2.new(0.5, -410, 0.3, -260)
    main.BackgroundTransparency = 1
    main.Visible = true
    TweenService:Create(main, tweenInfoMed, {Position = UDim2.new(0.5, -410, 0.5, -260), BackgroundTransparency = 0}):Play()
end

-- Helper seguro para Drawing (alguns ambientes não expõem Drawing API)
local function safeDrawingNew(kind)
    if type(Drawing) ~= "table" or type(Drawing.new) ~= "function" then
        return nil
    end
    local ok, obj = pcall(function() return Drawing.new(kind) end)
    if ok and obj then return obj end
    return nil
end

local function safeRemoveDrawing(obj)
    if not obj then return end
    pcall(function()
        if obj.Remove then obj:Remove() elseif obj.remove then obj:remove() end
    end)
end

local function hideMenu()
    if not main.Visible then return end
    local tw = TweenService:Create(main, tweenInfoFast, {Position = UDim2.new(0.5, -410, 0.2, -260), BackgroundTransparency = 1})
    tw:Play()
    tw.Completed:Connect(function()
        main.Visible = false
    end)
end

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = main

-- Visual polish: gradient and border for main
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 1
mainStroke.Color = Color3.fromRGB(50,50,50)
mainStroke.Parent = main
local mainGrad = Instance.new("UIGradient")
mainGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24,24,28)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20,20,24)),
}
mainGrad.Rotation = 0
mainGrad.Parent = main

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Ghost Menu by creator Magnata 2.0"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 40, 40) -- vermelho
title.Parent = main

-- Ajuste visual do título (barra superior com fundo)
title.BackgroundTransparency = 0
title.BackgroundColor3 = Color3.fromRGB(16,16,18)
title.TextColor3 = Color3.fromRGB(140,220,255)
title.TextXAlignment = Enum.TextXAlignment.Center

-- Aba lateral
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 110, 1, -36)
sidebar.Position = UDim2.new(0, 0, 0, 36)
sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- base preta
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 8)
sidebarCorner.Parent = sidebar

-- Gradient e contorno neon sutil para visual moderno
local sidebarGrad = Instance.new("UIGradient")
sidebarGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12,12,14)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(24,24,28)),
})
sidebarGrad.Rotation = 20
sidebarGrad.Parent = sidebar

local sidebarStroke = Instance.new("UIStroke")
sidebarStroke.Thickness = 1
sidebarStroke.Color = Color3.fromRGB(0, 200, 255)
sidebarStroke.Transparency = 0.9
sidebarStroke.Parent = sidebar

-- Botão Aimbot
local aimbotBtn = Instance.new("TextButton")
aimbotBtn.Size = UDim2.new(1, 0, 0, 48)
aimbotBtn.Position = UDim2.new(0, 0, 0, 0)
aimbotBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- preto
aimbotBtn.BorderSizePixel = 0
aimbotBtn.Text = ""
aimbotBtn.AutoButtonColor = false
aimbotBtn.Parent = sidebar

-- Icon image for aimbot button
-- Glyph for aimbot button (symbol-only)
local aimbotGlyph = Instance.new("TextLabel")
aimbotGlyph.Size = UDim2.new(0, 32, 0, 32)
aimbotGlyph.Position = UDim2.new(0.5, -16, 0.5, -16)
aimbotGlyph.BackgroundTransparency = 1
aimbotGlyph.BorderSizePixel = 0
aimbotGlyph.Text = "💀"
aimbotGlyph.Font = Enum.Font.GothamBold
aimbotGlyph.TextSize = 20
aimbotGlyph.TextColor3 = Color3.fromRGB(0,0,0)
aimbotGlyph.TextXAlignment = Enum.TextXAlignment.Center
aimbotGlyph.Parent = aimbotBtn

local aimbotBtnCorner = Instance.new("UICorner")
aimbotBtnCorner.CornerRadius = UDim.new(0, 8)
aimbotBtnCorner.Parent = aimbotBtn
-- hover
aimbotBtn.MouseEnter:Connect(function()
    pcall(function()
        TweenService:Create(aimbotBtn, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(64,64,68)}):Play()
        pcall(function() TweenService:Create(aimbotGlyph, tweenInfoFast, {TextColor3 = Color3.fromRGB(255,255,255)}):Play() end)
    end)
end)
aimbotBtn.MouseLeave:Connect(function()
    pcall(function()
        TweenService:Create(aimbotBtn, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
        pcall(function() TweenService:Create(aimbotGlyph, tweenInfoFast, {TextColor3 = Color3.fromRGB(0,0,0)}):Play() end)
    end)
end)

-- Accent à esquerda do botão (indicador ativo/hover)
local aimbotAccent = Instance.new("Frame")
aimbotAccent.Size = UDim2.new(0, 4, 1, 0)
aimbotAccent.Position = UDim2.new(0, 0, 0, 0)
aimbotAccent.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
aimbotAccent.BorderSizePixel = 0
aimbotAccent.BackgroundTransparency = 1
aimbotAccent.Parent = aimbotBtn

local aimbotAccentCorner = Instance.new("UICorner")
aimbotAccentCorner.CornerRadius = UDim.new(0, 2)
aimbotAccentCorner.Parent = aimbotAccent

aimbotBtn.MouseEnter:Connect(function()
    pcall(function()
        TweenService:Create(aimbotAccent, tweenInfoFast, {BackgroundTransparency = 0}):Play()
        pcall(function() TweenService:Create(aimbotGlyph, tweenInfoFast, {TextColor3 = Color3.fromRGB(255,255,255)}):Play() end)
    end)
end)
aimbotBtn.MouseLeave:Connect(function()
    pcall(function()
        TweenService:Create(aimbotAccent, tweenInfoFast, {BackgroundTransparency = 1}):Play()
        pcall(function() TweenService:Create(aimbotGlyph, tweenInfoFast, {TextColor3 = Color3.fromRGB(0,0,0)}):Play() end)
    end)
end)

-- Botões adicionais na aba lateral
local function makeSidebarBtn(name, icon, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 48)
    btn.Position = UDim2.new(0, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = btn

    -- Icon (ImageLabel) with fallback to glyph TextLabel
    local iconLabel = Instance.new("ImageLabel")
    iconLabel.Size = UDim2.new(0, 32, 0, 32)
    iconLabel.Position = UDim2.new(0.5, -16, 0.5, -16)
    iconLabel.BackgroundTransparency = 1
    iconLabel.BorderSizePixel = 0
    iconLabel.ImageColor3 = Color3.fromRGB(0,0,0)
    iconLabel.Parent = btn

    if type(icon) == "string" and string.find(icon, "rbxassetid") then
        iconLabel.Image = icon
        iconLabel.ImageColor3 = Color3.fromRGB(0,0,0)
    else
        -- fallback: use small TextLabel to render glyph
        iconLabel.Image = ""
        local glyph = Instance.new("TextLabel")
        glyph.Size = UDim2.new(1, 0, 1, 0)
        glyph.Position = UDim2.new(0, 0, 0, 0)
        glyph.BackgroundTransparency = 1
        glyph.Text = icon or ""
        glyph.Font = Enum.Font.GothamBold
        glyph.TextSize = 18
        glyph.TextColor3 = Color3.fromRGB(0,0,0)
        glyph.TextXAlignment = Enum.TextXAlignment.Center
        glyph.Parent = iconLabel
    end

    -- No text label: sidebar uses icons only

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0,4,1,0)
    accent.Position = UDim2.new(0,0,0,0)
    accent.BackgroundColor3 = Color3.fromRGB(0,200,255)
    accent.BorderSizePixel = 0
    accent.BackgroundTransparency = 1
    accent.Parent = btn

    btn.MouseEnter:Connect(function()
        pcall(function()
            TweenService:Create(btn, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(64,64,68)}):Play()
            TweenService:Create(accent, tweenInfoFast, {BackgroundTransparency = 0}):Play()
            pcall(function() TweenService:Create(iconLabel, tweenInfoFast, {ImageColor3 = Color3.fromRGB(255,255,255)}):Play() end)
            local g = iconLabel:FindFirstChildOfClass("TextLabel")
            if g then pcall(function() TweenService:Create(g, tweenInfoFast, {TextColor3 = Color3.fromRGB(255,255,255)}):Play() end) end
        end)
    end)
    btn.MouseLeave:Connect(function()
        pcall(function()
            TweenService:Create(btn, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
            TweenService:Create(accent, tweenInfoFast, {BackgroundTransparency = 1}):Play()
            pcall(function() TweenService:Create(iconLabel, tweenInfoFast, {ImageColor3 = Color3.fromRGB(0,0,0)}):Play() end)
            local g = iconLabel:FindFirstChildOfClass("TextLabel")
            if g then pcall(function() TweenService:Create(g, tweenInfoFast, {TextColor3 = Color3.fromRGB(0,0,0)}):Play() end) end
        end)
    end)

    return btn, accent, iconLabel
end

-- Função utilitária para selecionar aba (apenas Aimbot)
local function selectAimbotTab()
    pcall(function() TweenService:Create(aimbotAccent, tweenInfoFast, {BackgroundTransparency = 0}):Play() end)
    attackPanel.Visible = true
end

-- Painel Attack (Aimbot) - área grande à esquerda (ajustado)
local attackPanel = Instance.new("Frame")
attackPanel.Size = UDim2.new(0, 340, 1, -56)
attackPanel.Position = UDim2.new(0, 120, 0, 46)
attackPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
attackPanel.BorderSizePixel = 0
attackPanel.Parent = main

local attackCorner = Instance.new("UICorner")
attackCorner.CornerRadius = UDim.new(0, 8)
attackCorner.Parent = attackPanel

local border = Instance.new("UIStroke")
border.Thickness = 1
border.Color = Color3.fromRGB(40,40,40)
border.Parent = attackPanel

-- Gradiente animado sutil no painel Attack para aparência tecnológica
local attackGrad = Instance.new("UIGradient")
attackGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18,18,22)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30,30,36)),
})
attackGrad.Rotation = 0
attackGrad.Parent = attackPanel

spawn(function()
    local rot = 0
    while attackPanel and attackPanel.Parent do
        rot = (rot + 90) % 360
        pcall(function() TweenService:Create(attackGrad, tweenInfoMed, {Rotation = rot}):Play() end)
        wait(2.6)
    end
end)

-- Scroll para Attack
local attackScroll = Instance.new("ScrollingFrame")
attackScroll.Size = UDim2.new(1, 0, 1, -28)
attackScroll.Position = UDim2.new(0, 0, 0, 28)
attackScroll.BackgroundTransparency = 1
attackScroll.BorderSizePixel = 0
attackScroll.CanvasSize = UDim2.new(0, 0, 0, 1100)
attackScroll.ScrollBarThickness = 4
attackScroll.Parent = attackPanel

local attackTitle = Instance.new("TextLabel")
attackTitle.Size = UDim2.new(1, 0, 0, 28)
attackTitle.Position = UDim2.new(0, 0, 0, 0)
attackTitle.BackgroundTransparency = 1
attackTitle.Text = "Attack"
attackTitle.Font = Enum.Font.GothamBold
attackTitle.TextSize = 16
attackTitle.TextColor3 = Color3.fromRGB(255,255,255)
attackTitle.Parent = attackPanel

-- Painel Weapon Mods (direita, topo) (ajustado)
local weaponPanel = Instance.new("Frame")
weaponPanel.Size = UDim2.new(0, 300, 0, 180)
weaponPanel.Position = UDim2.new(0, 480, 0, 46)
weaponPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
weaponPanel.BorderSizePixel = 0
weaponPanel.Parent = main

local weaponCorner = Instance.new("UICorner")
weaponCorner.CornerRadius = UDim.new(0, 8)
weaponCorner.Parent = weaponPanel

local weaponBorder = Instance.new("UIStroke")
weaponBorder.Thickness = 1
weaponBorder.Color = Color3.fromRGB(40,40,40)
weaponBorder.Parent = weaponPanel

-- Visual moderno para Weapon Panel
local weaponGrad = Instance.new("UIGradient")
weaponGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22,22,26)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30,30,36)),
})
weaponGrad.Rotation = 0
weaponGrad.Parent = weaponPanel

local weaponAccent = Instance.new("UIStroke")
weaponAccent.Thickness = 1
weaponAccent.Color = Color3.fromRGB(10,160,220)
weaponAccent.Transparency = 0.92
weaponAccent.Parent = weaponPanel

spawn(function()
    local r = 0
    while weaponPanel and weaponPanel.Parent do
        r = (r + 60) % 360
        pcall(function() TweenService:Create(weaponGrad, tweenInfoMed, {Rotation = r}):Play() end)
        wait(3)
    end
end)

local weaponScroll = Instance.new("ScrollingFrame")
weaponScroll.Size = UDim2.new(1, 0, 1, -28)
weaponScroll.Position = UDim2.new(0, 0, 0, 28)
weaponScroll.BackgroundTransparency = 1
weaponScroll.BorderSizePixel = 0
weaponScroll.CanvasSize = UDim2.new(0, 0, 0, 500)
weaponScroll.ScrollBarThickness = 4
weaponScroll.Parent = weaponPanel

local weaponTitle = Instance.new("TextLabel")
weaponTitle.Size = UDim2.new(1, 0, 0, 28)
weaponTitle.Position = UDim2.new(0, 0, 0, 0)
weaponTitle.BackgroundTransparency = 1
weaponTitle.Text = "Weapon Mods"
weaponTitle.Font = Enum.Font.GothamBold
weaponTitle.TextSize = 16
weaponTitle.TextColor3 = Color3.fromRGB(255,255,255)
weaponTitle.Parent = weaponPanel

-- Painel Visuals (substitui texto por símbolos e controles visuais)
local visualsPanel = Instance.new("Frame")
visualsPanel.Size = UDim2.new(0, 300, 0, 180)
visualsPanel.Position = UDim2.new(0, 480, 0, 46)
visualsPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
visualsPanel.BorderSizePixel = 0
visualsPanel.Parent = main
visualsPanel.Visible = false

local visualsCorner = Instance.new("UICorner")
visualsCorner.CornerRadius = UDim.new(0, 8)
visualsCorner.Parent = visualsPanel

local visualsBorder = Instance.new("UIStroke")
visualsBorder.Thickness = 1
visualsBorder.Color = Color3.fromRGB(40,40,40)
visualsBorder.Parent = visualsPanel

local visualsScroll = Instance.new("ScrollingFrame")
visualsScroll.Size = UDim2.new(1, 0, 1, -28)
visualsScroll.Position = UDim2.new(0, 0, 0, 28)
visualsScroll.BackgroundTransparency = 1
visualsScroll.BorderSizePixel = 0
visualsScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
visualsScroll.ScrollBarThickness = 4
visualsScroll.Parent = visualsPanel

local visualsTitle = Instance.new("TextLabel")
visualsTitle.Size = UDim2.new(1, 0, 0, 28)
visualsTitle.Position = UDim2.new(0, 0, 0, 0)
visualsTitle.BackgroundTransparency = 1
visualsTitle.Text = "Visuals"
visualsTitle.Font = Enum.Font.GothamBold
visualsTitle.TextSize = 16
visualsTitle.TextColor3 = Color3.fromRGB(140,220,255)
visualsTitle.Parent = visualsPanel

-- Painel Misc (aba inferior direita)
local miscPanel = Instance.new("Frame")
miscPanel.Size = UDim2.new(0, 300, 0, 260)
miscPanel.Position = UDim2.new(0, 480, 0, 236)
miscPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
miscPanel.BorderSizePixel = 0
miscPanel.Parent = main
miscPanel.Visible = false

local miscCorner = Instance.new("UICorner")
miscCorner.CornerRadius = UDim.new(0, 8)
miscCorner.Parent = miscPanel

local miscBorder = Instance.new("UIStroke")
miscBorder.Thickness = 1
miscBorder.Color = Color3.fromRGB(40,40,40)
miscBorder.Parent = miscPanel

local miscScroll = Instance.new("ScrollingFrame")
miscScroll.Size = UDim2.new(1, 0, 1, -28)
miscScroll.Position = UDim2.new(0, 0, 0, 28)
miscScroll.BackgroundTransparency = 1
miscScroll.BorderSizePixel = 0
miscScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
miscScroll.ScrollBarThickness = 4
miscScroll.Parent = miscPanel

local miscTitle = Instance.new("TextLabel")
miscTitle.Size = UDim2.new(1, 0, 0, 28)
miscTitle.Position = UDim2.new(0, 0, 0, 0)
miscTitle.BackgroundTransparency = 1
miscTitle.Text = "Misc"
miscTitle.Font = Enum.Font.GothamBold
miscTitle.TextSize = 16
miscTitle.TextColor3 = Color3.fromRGB(140,220,255)
miscTitle.Parent = miscPanel

-- Painel Settings (direita, abaixo de Weapon Mods, mais abaixo)
local settingsPanel = Instance.new("Frame")
settingsPanel.Size = UDim2.new(0, 300, 0, 260)
settingsPanel.Position = UDim2.new(0, 480, 0, 236)
settingsPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
settingsPanel.BorderSizePixel = 0
settingsPanel.Parent = main

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 8)
settingsCorner.Parent = settingsPanel

local settingsBorder = Instance.new("UIStroke")
settingsBorder.Thickness = 1
settingsBorder.Color = Color3.fromRGB(40,40,40)
settingsBorder.Parent = settingsPanel

-- Visual moderno para Settings Panel
local settingsGrad = Instance.new("UIGradient")
settingsGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,24)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(28,28,32)),
})
settingsGrad.Rotation = 0
settingsGrad.Parent = settingsPanel

local settingsAccent = Instance.new("UIStroke")
settingsAccent.Thickness = 1
settingsAccent.Color = Color3.fromRGB(10,160,220)
settingsAccent.Transparency = 0.92
settingsAccent.Parent = settingsPanel

spawn(function()
    local r = 0
    while settingsPanel and settingsPanel.Parent do
        r = (r + 45) % 360
        pcall(function() TweenService:Create(settingsGrad, tweenInfoMed, {Rotation = r}):Play() end)
        wait(2.6)
    end
end)

local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Size = UDim2.new(1, 0, 1, -28)
settingsScroll.Position = UDim2.new(0, 0, 0, 28)
settingsScroll.BackgroundTransparency = 1
settingsScroll.BorderSizePixel = 0
settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 700)
settingsScroll.ScrollBarThickness = 4
settingsScroll.Parent = settingsPanel


local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, 0, 0, 28)
settingsTitle.Position = UDim2.new(0, 0, 0, 0)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "Settings"
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 16
settingsTitle.TextColor3 = Color3.fromRGB(140,220,255)
settingsTitle.Parent = settingsPanel

-- Botão X para fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -40, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(32,32,32)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.TextColor3 = Color3.fromRGB(140, 220, 255)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = main
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
    pcall(function()
        TweenService:Create(closeBtn, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(48,48,48)}):Play()
        TweenService:Create(closeBtn, tweenInfoFast, {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
    end)
end)
closeBtn.MouseLeave:Connect(function()
    pcall(function()
        TweenService:Create(closeBtn, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(32,32,32)}):Play()
        TweenService:Create(closeBtn, tweenInfoFast, {TextColor3 = Color3.fromRGB(140, 220, 255)}):Play()
    end)
end)


closeBtn.MouseButton1Click:Connect(function()
    if main and main.Parent then
        main:Destroy()
    end
end)


-- Drag do menu (arrastar pelo título)
if title and title.Parent then
    title.Active = true
end
local dragging, dragInput, dragStart, startPos
local UIS = game:GetService("UserInputService")
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle menu com Insert
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        print("[DEBUG] Tecla Insert pressionada!")
        if main and main.Parent then
            print("[DEBUG] main existe e tem Parent!")
            if main.Visible then hideMenu() else showMenu() end
        else
            print("[DEBUG] main ou main.Parent não existem!")
        end
    end
end)

-- Funções utilitárias para UI interativa
local function createCheckbox(parent, x, y, labelText, checkedDefault, callback)
    local checked = checkedDefault
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 140, 0, 22)
    label.Position = UDim2.new(0, x, 0, y)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
        local box = Instance.new("TextButton") -- Create the checkbox button
    box.Size = UDim2.new(0, 22, 0, 22)
    box.Position = UDim2.new(0, x+202, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    box.BorderSizePixel = 0
    box.Text = ""
    box.AutoButtonColor = false
    box.Parent = parent
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = box
    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1
    boxStroke.Color = Color3.fromRGB(18,18,20)
    boxStroke.Transparency = 0.9
    boxStroke.Parent = box
    local check = Instance.new("Frame")
    check.Size = UDim2.new(0, 14, 0, 14)
    check.Position = UDim2.new(0, 4, 0, 4)
    check.BackgroundColor3 = checked and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(24,24,28)
    check.BorderSizePixel = 0
    check.Parent = box
    local checkCorner = Instance.new("UICorner")
    checkCorner.CornerRadius = UDim.new(0, 2)
    checkCorner.Parent = check
    local boxCornerInternal = Instance.new("UICorner")
    boxCornerInternal.CornerRadius = UDim.new(0, 6)
    boxCornerInternal.Parent = box
    local boxStrokeInternal = Instance.new("UIStroke")
    boxStrokeInternal.Thickness = 1
    boxStrokeInternal.Color = Color3.fromRGB(18,18,20)
    boxStrokeInternal.Transparency = 0.9
    boxStrokeInternal.Parent = box
    box.MouseButton1Click:Connect(function()
        checked = not checked
    check.BackgroundColor3 = checked and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(24,24,28)
        if callback then callback(checked) end
    end)
    -- hover effect
    box.MouseEnter:Connect(function()
        pcall(function()
            TweenService:Create(box, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(34,34,40)}):Play()
        end)
    end)
    box.MouseLeave:Connect(function()
        pcall(function()
            TweenService:Create(box, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(24,24,28)}):Play()
        end)
    end)
    return box, function() return checked end
end

local function createDropdown(parent, x, y, labelText, options, selectedIndex, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 120, 0, 22)
    label.Position = UDim2.new(0, x, 0, y)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    local box = Instance.new("TextButton")
    box.Size = UDim2.new(0, 160, 0, 26)
    box.Position = UDim2.new(0, x+122, 0, y-2)
    box.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    box.BorderSizePixel = 0
    box.Text = ""
    box.AutoButtonColor = false
    box.Parent = parent
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, -24, 1, 0)
    valueLabel.Position = UDim2.new(0, 8, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = options[selectedIndex]
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.Parent = box
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 18, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.Font = Enum.Font.Gotham
    arrow.TextSize = 14
    arrow.TextColor3 = Color3.fromRGB(120,120,120)
    arrow.Parent = box
    local dropdownOpen = false
    local dropdownFrame
    box.MouseButton1Click:Connect(function()
        if dropdownOpen then
            if dropdownFrame then dropdownFrame:Destroy() end
            dropdownOpen = false
            return
        end
        dropdownOpen = true
        -- Frame para rolagem
        dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(0, 160, 0, math.min(#options, 8)*24)
        dropdownFrame.Position = UDim2.new(0, x+122, 0, y+24)
        dropdownFrame.BackgroundColor3 = Color3.fromRGB(32,32,36)
        dropdownFrame.BorderSizePixel = 0
        dropdownFrame.ZIndex = 10
        dropdownFrame.Parent = parent
        local ddCorner = Instance.new("UICorner")
        ddCorner.CornerRadius = UDim.new(0,6)
        ddCorner.Parent = dropdownFrame
        local ddStroke = Instance.new("UIStroke")
        ddStroke.Thickness = 1
        ddStroke.Color = Color3.fromRGB(16,16,18)
        ddStroke.Transparency = 0.9
        ddStroke.Parent = dropdownFrame
        local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.CanvasSize = UDim2.new(0, 0, 0, math.max(#options*24, math.min(#options,8)*24))
        scroll.ScrollBarThickness = 4
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ZIndex = 11
        scroll.Parent = dropdownFrame
        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 24)
            optBtn.Position = UDim2.new(0, 0, 0, (i-1)*24)
            optBtn.BackgroundColor3 = Color3.fromRGB(32,32,36)
            optBtn.Text = opt
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextSize = 14
            optBtn.TextColor3 = Color3.fromRGB(180,180,200)
            optBtn.BorderSizePixel = 0
            optBtn.ZIndex = 12
            optBtn.Parent = scroll
            optBtn.MouseButton1Click:Connect(function()
                valueLabel.Text = opt
                selectedIndex = i
                if callback then callback(i, opt) end
                dropdownFrame:Destroy()
                dropdownOpen = false
            end)
        end
    end)
    -- hover for dropdown box
    box.MouseEnter:Connect(function()
        pcall(function() TweenService:Create(box, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(36,36,44)}):Play() end)
    end)
    box.MouseLeave:Connect(function()
        pcall(function() TweenService:Create(box, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(24,24,28)}):Play() end)
    end)
    return box, function() return options[selectedIndex] end
end

local function createSlider(parent, x, y, labelText, value, min, max, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 140, 0, 20)
    label.Position = UDim2.new(0, x, 0, y)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
        local bar = Instance.new("Frame") -- Create the slider bar
    bar.Size = UDim2.new(0, 120, 0, 6)
    bar.Position = UDim2.new(0, x, 0, y+20)
    bar.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    bar.BorderSizePixel = 0
    bar.Parent = parent
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((value-min)/(max-min), 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    fill.BorderSizePixel = 0
    fill.Parent = bar
    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((value-min)/(max-min), -7, 0.5, -4)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.Text = ""
    knob.Parent = bar
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Position = UDim2.new(0, x+124, 0, y+14)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = string.format("%.1f", value)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.TextColor3 = Color3.fromRGB(120,120,120)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.Parent = parent
    local dragging = false

    knob.MouseButton1Down:Connect(function()
        dragging = true
    end)
    knob.MouseButton1Up:Connect(function()
        dragging = false
    end)
    knob.MouseLeave:Connect(function()
        dragging = false
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = game:GetService("UserInputService"):GetMouseLocation().X
            local barAbs = bar.AbsolutePosition.X
            local rel = math.clamp((mouse - barAbs)/120, 0, 1)
            value = min + (max-min)*rel
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, -7, 0.5, -4)
            valueLabel.Text = string.format("%.1f", value)
            if callback then callback(value) end
        end
    end)
    -- hover for knob
    knob.MouseEnter:Connect(function()
        pcall(function() TweenService:Create(knob, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(230,230,230)}):Play() end)
    end)
    knob.MouseLeave:Connect(function()
        pcall(function() TweenService:Create(knob, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play() end)
    end)
    return knob, function() return value end
end

local function createColorBox(parent, x, y, labelText, color, callback)
    local box = Instance.new("TextButton")
    box.Size = UDim2.new(0, 24, 0, 24)
    box.Position = UDim2.new(0, x+120, 0, y)
    box.BackgroundColor3 = color
    box.BorderSizePixel = 0
    box.Text = ""
    box.Parent = parent
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 100, 0, 24)
    label.Position = UDim2.new(0, x, 0, y)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(230, 230, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    local colorListOpen = false
    local colorListFrame
    local colorOptions = {
        Color3.fromRGB(77, 230, 255), -- azul
        Color3.fromRGB(255, 0, 255),  -- rosa
        Color3.fromRGB(255, 255, 255),-- branco
        Color3.fromRGB(255, 0, 0),    -- vermelho
        Color3.fromRGB(0, 255, 0),    -- verde
        Color3.fromRGB(255, 255, 0),  -- amarelo
        Color3.fromRGB(0, 0, 0),      -- preto
        Color3.fromRGB(0, 255, 200),  -- ciano
    }
    box.MouseButton1Click:Connect(function()
        if colorListOpen then
            if colorListFrame then colorListFrame:Destroy() end
            colorListOpen = false
            return
        end
        colorListOpen = true
        colorListFrame = Instance.new("Frame")
        colorListFrame.Size = UDim2.new(0, 120, 0, #colorOptions*28)
        colorListFrame.Position = UDim2.new(0, x+150, 0, y)
        colorListFrame.BackgroundColor3 = Color3.fromRGB(32,32,36)
        colorListFrame.BorderSizePixel = 0
        colorListFrame.ZIndex = 20
        colorListFrame.Parent = parent
        for i, c in ipairs(colorOptions) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 24)
            optBtn.Position = UDim2.new(0, 0, 0, (i-1)*28)
            optBtn.BackgroundColor3 = c
            optBtn.Text = ""
            optBtn.BorderSizePixel = 0
            optBtn.ZIndex = 21
            optBtn.Parent = colorListFrame
            optBtn.MouseButton1Click:Connect(function()
                box.BackgroundColor3 = c
                if callback then callback(c) end
                colorListFrame:Destroy()
                colorListOpen = false
            end)
        end
    end)
    -- hover for color box
    box.MouseEnter:Connect(function()
        pcall(function() TweenService:Create(box, tweenInfoFast, {Size = UDim2.new(0, 26, 0, 26)}):Play() end)
    end)
    box.MouseLeave:Connect(function()
        pcall(function() TweenService:Create(box, tweenInfoFast, {Size = UDim2.new(0, 24, 0, 24)}):Play() end)
    end)
    return box, function() return box.BackgroundColor3 end
end

-- yA: posição vertical dos controles do painel Attack
local yA = 4
-- Dropdown Aimbot Type
createDropdown(attackScroll, 0, yA, "Aimbot Type", {"Camera", "Memory"}, 1)
yA = yA + 32
-- Checkbox Aimbot
-- Funções utilitárias do Aimbot
local aimbotActive = false
local aiming = false
local aimbotDisconnect = nil

function getClosestPlayerInFOV()
    local Players = game:GetService("Players")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer
    local minDist = math.huge
    local closest = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local isTarget = false
            if targetsOption == "All" then
                isTarget = true
            elseif targetsOption == "Players" then
                if not (player:IsA("Bot")) and not (player.Character and player.Character:FindFirstChild("Knocked")) then
                    isTarget = true
                end
            elseif targetsOption == "Knocked, Bots" then
                if (player:IsA("Bot")) then
                    isTarget = true
                end
            elseif targetsOption == "All Enemies" then
                if player.Team ~= LocalPlayer.Team then
                    isTarget = true
                end
            end
            if isTarget then
                local bone = getAimbotBone(player.Character)
                if bone then
                    local pos, onScreen = Camera:WorldToViewportPoint(bone.Position)
                    if onScreen then
                        local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                        local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                        if dist < minDist and dist <= (FOV_RADIUS or 120) then
                            minDist = dist
                            closest = player
                        end
                    end
                end
            end
        end
    end
    return closest
end

function getAimbotBone(character)
    local boneName = selectedBone or "Head"
    if character:FindFirstChild(boneName) then
        return character[boneName]
    end
    return character:FindFirstChild("HumanoidRootPart")
end

function enableAimbot()
    -- SANDBOX: aimbot functionality disabled to prevent cheating/unsafe behavior
    print("[SANDBOX] enableAimbot: Disabled in sandbox mode.")
    aimbotDisconnect = function() end
end

function onAimbotToggle(state)
    if state then
        if not aimbotActive then
            enableAimbot()
            aimbotActive = true
        end
    else
        if aimbotActive and aimbotDisconnect then
            aimbotDisconnect()
            aimbotActive = false
        end
    end
end
createCheckbox(attackScroll, 0, yA, "Aimbot", false, onAimbotToggle)
yA = yA + 28
-- Checkbox ESP real
local espActive = false
local espDisconnect = nil
local espConnections = {}
local allDrawings = {}
function enableESP()
    -- SANDBOX: ESP disabled to avoid using Drawing API for cheating purposes.
    print("[SANDBOX] enableESP: Disabled in sandbox mode.")
    espDisconnect = function() end
end
    -- ESP implementation removed in SANDBOX to avoid syntax issues
    
    end
    -- Função para decidir se deve criar ESP para o player
    local function shouldCreateESP(player)
        if player == LocalPlayer then return false end
        if targetsOption == "All" then return true end
        if targetsOption == "Players" then
            return not (player:IsA("Bot")) and not (player.Character and player.Character:FindFirstChild("Knocked"))
        end
        if targetsOption == "Knocked, Bots" then
            return (player:IsA("Bot")) or (player.Character and player.Character:FindFirstChild("Knocked"))
        end
        if targetsOption == "All Enemies" then
            -- Só considera inimigo se ambos têm Team definido e são diferentes
            if player.Team ~= nil and LocalPlayer.Team ~= nil then
                return player.Team ~= LocalPlayer.Team
            else
                return false
            end
        end
        return false
    end
    -- Cria ESP para todos os jogadores atuais
    for _, player in ipairs(Players:GetPlayers()) do
        if shouldCreateESP(player) then
            createESP(player)
        end
    end
    -- Atualiza ESP para novos jogadores
    table.insert(espConnections, Players.PlayerAdded:Connect(function(player)
        if shouldCreateESP(player) then
            createESP(player)
        end
    end))
    -- Atualiza ESP para personagens que renascem
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(espConnections, player.CharacterAdded:Connect(function()
            if shouldCreateESP(player) then
                createESP(player)
            end
        end))
    end
    espDisconnect = function()
        for _, con in ipairs(espConnections) do
            pcall(function()
                if con and con.Disconnect then con:Disconnect() end
            end)
        end
        espConnections = {}
        for _, d in ipairs(allDrawings) do
            pcall(function() if d and d.Remove then d:Remove() end end)
        end
        allDrawings = {}
    end

    -- Proteção: reanexar o menu ao PlayerGui se ele for recriado
    player.PlayerGui.ChildRemoved:Connect(function(child)
    if child.Name == "FortniteMenu" then
        wait(0.5)
        if not player.PlayerGui:FindFirstChild("FortniteMenu") then
            gui.Parent = player.PlayerGui
            print("[Proteção] Menu reanexado ao PlayerGui.")
        end
    end
end)

player.CharacterAdded:Connect(function()
    if not player.PlayerGui:FindFirstChild("FortniteMenu") then
        gui.Parent = player.PlayerGui
        print("[Proteção] Menu reanexado após respawn.")
    end
end)
end
function onESPToggle(state)
    if state then
        if not espActive then
            enableESP()
            espActive = true
        end
    else
        if espActive and espDisconnect then
            espDisconnect()
            espActive = false
        end
    end
end
createCheckbox(attackScroll, 0, yA, "ESP", false, onESPToggle)
yA = yA + 28
-- Checkbox NoRecoil real
local norecoilActive = false
local norecoilDisconnect = nil
local function enableNoRecoil()
    -- SANDBOX: NoRecoil disabled in sandbox mode.
    print("[SANDBOX] enableNoRecoil: Disabled in sandbox mode.")
    norecoilDisconnect = function() end
end
local function onNoRecoilToggle(state)
    if state then
        if not norecoilActive then
            enableNoRecoil()
            norecoilActive = true
        end
    else
        if norecoilActive and norecoilDisconnect then
            norecoilDisconnect()
            norecoilActive = false
        end
    end
end
createCheckbox(attackScroll, 0, yA, "NoRecoil", false, onNoRecoilToggle)
yA = yA + 28
createSlider(attackScroll, 0, yA, "Smoothness", 0, 0, 10)
yA = yA + 36
-- Campos desabilitados (apenas visual)
local function disabledFieldA(labelText, value)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 140, 0, 22)
    label.Position = UDim2.new(0, 18, 0, yA)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(120,120,120)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = attackScroll
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 160, 0, 26)
    box.Position = UDim2.new(0, 140, 0, yA-2)
    box.BackgroundColor3 = Color3.fromRGB(40,40,40)
    box.BorderSizePixel = 0
    box.Parent = attackScroll
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, 0, 1, 0)
    valueLabel.Position = UDim2.new(0, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = value
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.TextColor3 = Color3.fromRGB(120,120,120)
    valueLabel.Parent = box
    yA = yA + 32
end
disabledFieldA("Aimbot Keybind", "Mouse2")
disabledFieldA("Close Aim Keybind", "Caps Lock")
disabledFieldA("Bone Scan", "")
yA = yA + 32
local _, getSelectedBone = createDropdown(attackScroll, 0, yA, "Selected Aimbone", {"Head", "Body"}, 1, function(idx, val)
    selectedBone = val
end)
yA = yA + 32
yA = yA + 28
-- Triggerbot funcional
local triggerbotActive = false
local triggerbotDisconnect = nil
local function enableTriggerbot()
    -- SANDBOX: Triggerbot disabled in sandbox mode.
    print("[SANDBOX] enableTriggerbot: Disabled in sandbox mode.")
    triggerbotDisconnect = function() end
end
local function onTriggerbotToggle(state)
    if state then
        if not triggerbotActive then
            enableTriggerbot()
            triggerbotActive = true
        end
    else
        if triggerbotActive and triggerbotDisconnect then
            triggerbotDisconnect()
            triggerbotActive = false
        end
    end
end
createCheckbox(attackScroll, 0, yA, "Weapon Configs", false)
yA = yA + 28
createCheckbox(attackScroll, 0, yA, "Triggerbot", false, onTriggerbotToggle)
yA = yA + 28
local alwaysTriggerActive = false
local function onAlwaysTriggerToggle(state)
    alwaysTriggerActive = state
    -- Se ativar, ativa o triggerbot automaticamente
    if alwaysTriggerActive and not triggerbotActive then
        enableTriggerbot()
        triggerbotActive = true
    end
    -- Se desativar, desativa o triggerbot se ele não estiver ativado manualmente
    if not alwaysTriggerActive and triggerbotActive then
        if triggerbotDisconnect then
            triggerbotDisconnect()
            triggerbotActive = false
        end
    end
end
createCheckbox(attackScroll, 0, yA, "Always Trigger", false, onAlwaysTriggerToggle)
yA = yA + 28
disabledFieldA("Only Shotgun", "")

-- Funções e conteúdo do painel Weapon Mods
-- yW: posição vertical dos controles do painel Weapon Mods
local yW = 4
local nobloomActive = false
local nobloomDisconnect = nil
local function enableNoBloom()
    print("[SANDBOX] enableNoBloom: Disabled in sandbox mode.")
    nobloomDisconnect = function() end
end
local function onNoBloomToggle(state)
    if state then
        if not nobloomActive then
            enableNoBloom()
            nobloomActive = true
        end
    else
        if nobloomActive and nobloomDisconnect then
            nobloomDisconnect()
            nobloomActive = false
        end
    end
end
createCheckbox(weaponScroll, 0, yW, "NoBloom", false, onNoBloomToggle)

-- Instant Charge stub
local function enableInstantCharge()
    print("[SANDBOX] enableInstantCharge: Disabled in sandbox mode.")
    instantChargeDisconnect = function() end
end
local function onInstantChargeToggle(state)
    if state then
        if not instantChargeActive then
            enableInstantCharge()
            instantChargeActive = true
        end
    else
        if instantChargeActive and instantChargeDisconnect then
            instantChargeDisconnect()
            instantChargeActive = false
        end
    end
end
createCheckbox(weaponScroll, 0, yW, "Instant Charge", false, onInstantChargeToggle)

-- Freeze Target stub
local function enableFreezeTarget()
    print("[SANDBOX] enableFreezeTarget: Disabled in sandbox mode.")
    freezeTargetDisconnect = function() end
end
local function onFreezeTargetToggle(state)
    if state then
        if not freezeTargetActive then
            freezeTargetActive = true
            enableFreezeTarget()
        end
    else
        if freezeTargetActive and freezeTargetDisconnect then
            freezeTargetDisconnect()
            freezeTargetActive = false
        end
    end
end
createCheckbox(weaponScroll, 0, yW, "Freeze Target", false, onFreezeTargetToggle)

-- Noclip stubs
local function enableNoclip()
    print("[SANDBOX] enableNoclip: Disabled in sandbox mode.")
end
local function disableNoclip()
    print("[SANDBOX] disableNoclip: Disabled in sandbox mode.")
end
local function onNoclipToggle(state)
    noclipActive = state
    if state then
        enableNoclip()
    else
        disableNoclip()
    end
end
createCheckbox(weaponScroll, 0, yW, "Noclip", false, onNoclipToggle)
yW = yW + 28
local instantChargeActive = false
local instantChargeDisconnect = nil
local function enableInstantCharge()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local function instantCharge(tool)
        for _, v in pairs(tool:GetDescendants()) do
            if v:IsA("NumberValue") or v:IsA("IntValue") then
                if v.Name:lower():find("charge") or v.Name:lower():find("delay") then
                    v.Value = 0
                end
            end
            if v:IsA("ModuleScript") then
                local s, m = pcall(require, v)
                if s and type(m) == "table" then
                    for key, value in pairs(m) do
                        if tostring(key):lower():find("charge") or tostring(key):lower():find("delay") then
                            if type(value) == "number" then
                                m[key] = 0
                            end
                        end
                    end
                end
            end
        end
    end
    local charConn, bpConn
    charConn = LocalPlayer.CharacterAdded:Connect(function(char)
        bpConn = char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                instantCharge(child)
            end
        end)
    end)
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            instantCharge(tool)
        end
    end
    local bpConn2 = LocalPlayer.Backpack.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            instantCharge(child)
        end
    end)
    instantChargeDisconnect = function()
        if charConn then charConn:Disconnect() end
        if bpConn then bpConn:Disconnect() end
        if bpConn2 then bpConn2:Disconnect() end
    end
end
local function onInstantChargeToggle(state)
    if state then
        if not instantChargeActive then
            enableInstantCharge()
            instantChargeActive = true
        end
    else
        if instantChargeActive and instantChargeDisconnect then
            instantChargeDisconnect()
            instantChargeActive = false
        end
    end
end
createCheckbox(weaponScroll, 0, yW, "Instant Charge", false, onInstantChargeToggle)
yW = yW + 28
local noAimbotWhilstBuildingActive = false
local buildConn = nil
local function isBuilding()
    -- Exemplo: verifica se o player está segurando uma ferramenta de construção
    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find("build") then
        return true
    end
    return false
end
local function onNoAimbotWhilstBuildingToggle(state)
    noAimbotWhilstBuildingActive = state
    if state then
        if not buildConn then
            local RunService = game:GetService("RunService")
            buildConn = RunService.RenderStepped:Connect(function()
                buildConn._last = buildConn._last or 0
                local now = tick()
                if now - buildConn._last >= 0.15 then
                    buildConn._last = now
                    if noAimbotWhilstBuildingActive and isBuilding() then
                        if aimbotActive and aimbotDisconnect then
                            aimbotDisconnect()
                            aimbotActive = false
                        end
                    end
                end
            end)
        end
    else
        if buildConn then buildConn:Disconnect() buildConn = nil end
    end
end
createCheckbox(weaponScroll, 0, yW, "NoAimbotWhilstBuilding", false, onNoAimbotWhilstBuildingToggle)
yW = yW + 28
createCheckbox(weaponScroll, 0, yW, "Enable Target Locking", false)
yW = yW + 28
local freezeTargetActive = false
local freezeTargetDisconnect = nil
local function enableFreezeTarget()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")
    local frozenTarget = nil
    local function getClosestEnemy()
        local closest, minDist = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                    local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = player
                    end
                end
            end
        end
        return closest
    end
    local con = RunService.RenderStepped:Connect(function()
        if not freezeTargetActive then return end
        con._lastCheck = con._lastCheck or 0
        local now = tick()
        if now - con._lastCheck >= 0.15 then
            con._lastCheck = now
            if not frozenTarget or not frozenTarget.Parent or (frozenTarget.Parent:FindFirstChild("Humanoid") and frozenTarget.Parent.Humanoid.Health <= 0) then
                local target = getClosestEnemy()
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    -- unanchor previous
                    if frozenTarget and frozenTarget.Parent then
                        pcall(function() frozenTarget.Anchored = false end)
                    end
                    frozenTarget = target.Character.HumanoidRootPart
                    if frozenTarget then pcall(function() frozenTarget.Anchored = true end) end
                end
            end
        end
    end)
    freezeTargetDisconnect = function()
        if con then con:Disconnect() end
        if frozenTarget then
            frozenTarget.Anchored = false
            frozenTarget = nil
        end
    end
end
local function onFreezeTargetToggle(state)
    if state then
        if not freezeTargetActive then
            freezeTargetActive = true
            enableFreezeTarget()
        end
    else
        if freezeTargetActive and freezeTargetDisconnect then
            freezeTargetDisconnect()
            freezeTargetActive = false
        end
    end
end
createCheckbox(weaponScroll, 0, yW, "Freeze Target", false, onFreezeTargetToggle)
yW = yW + 28
-- Adiciona checkbox Noclip no painel Weapon Mods
local noclipActive = false
local noclipConn = nil
local noclipCharConn = nil
local noclipDescConn = nil
local function enableNoclip()
    if noclipConn then return end -- já está ativo
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local baseSpeed = 60
    local fastSpeed = 120
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
    -- Apply noclip to current character parts once and hook for new parts
    local function applyNoclipToCharacter(char)
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.CanCollide = false end)
            end
        end
        -- connect to new parts
        if noclipDescConn then noclipDescConn:Disconnect() noclipDescConn = nil end
        noclipDescConn = char.DescendantAdded:Connect(function(desc)
            if desc:IsA("BasePart") then pcall(function() desc.CanCollide = false end) end
        end)
    end
    if LocalPlayer.Character then
        applyNoclipToCharacter(LocalPlayer.Character)
        -- ensure we reconnect when character changes
        if noclipCharConn then noclipCharConn:Disconnect() noclipCharConn = nil end
        noclipCharConn = LocalPlayer.CharacterAdded:Connect(function(char)
            wait(0.1)
            applyNoclipToCharacter(char)
        end)
    end
    -- Movement handling (only set velocity, do not iterate parts each frame)
    noclipConn = RunService.RenderStepped:Connect(function(dt)
        if not noclipActive then return end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local move = Vector3.new()
            local cam = workspace.CurrentCamera
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
            local speed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and fastSpeed or baseSpeed
            local hrp = LocalPlayer.Character.HumanoidRootPart
            if move.Magnitude > 0 then
                hrp.Velocity = move.Unit * speed
            else
                hrp.Velocity = Vector3.new()
            end
        end
    end)
end
local function disableNoclip()
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    if noclipDescConn then noclipDescConn:Disconnect() noclipDescConn = nil end
    if noclipCharConn then noclipCharConn:Disconnect() noclipCharConn = nil end
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    if LocalPlayer.Character then
        for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                pcall(function() v.CanCollide = true end)
            end
        end
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end
local function onNoclipToggle(state)
    noclipActive = state
    if state then
        enableNoclip()
    else
        disableNoclip()
    end
end
createCheckbox(weaponScroll, 0, yW, "Noclip", false, onNoclipToggle)
yW = yW + 28
-- Funções e conteúdo do painel Settings
-- Funções auxiliares para FOV (área de configurações)
local drawFovActive = false
local function createFovCircle()
    if not fovCircle then
        local Camera = workspace.CurrentCamera
        fovCircle = safeDrawingNew("Circle")
        if fovCircle then
            fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            fovCircle.Radius = FOV_RADIUS
            fovCircle.Color = fovCircleColor
            fovCircle.Thickness = 2
            fovCircle.Filled = false
            fovCircle.Visible = true
        end
    end
end
local function destroyFovCircle()
    if fovCircle then
        fovCircle:Remove()
        fovCircle = nil
    end
end
local function onDrawFovToggle(state)
    drawFovActive = state
    if drawFovActive then
        createFovCircle()
    else
        destroyFovCircle()
    end
end
-- Atualizar círculo ao mudar o slider de FOV
local oldSetFOVValue = setFOVValue
setFOVValue = function(val)
    FOV_RADIUS = val
    if fovCircle then
        fovCircle.Radius = FOV_RADIUS
    end
    if oldSetFOVValue then oldSetFOVValue(val) end
    -- Se o DrawFOV estiver ativo e não existir círculo, cria
    if drawFovActive and not fovCircle then
        createFovCircle()
    end
end
-- No RunService.RenderStepped, manter posição do círculo se existir
local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
    if fovCircle then
        local Camera = workspace.CurrentCamera
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        fovCircle.Radius = FOV_RADIUS
        fovCircle.Visible = drawFovActive
        fovCircle.Color = fovCircleColor
    end
end)
-- yS: posição vertical dos controles do painel Settings

-- Dependências globais para funções utilitárias
-- math já é global, use diretamente
local yS = 4

-- Dropdown Targets
-- Adiciona opção 'All Enemies' ao dropdown
local targetsOptionsList = {"Knocked, Bots", "Players", "All", "All Enemies"}
targetsOption = "Knocked, Bots"
local targetsDropdown, getTargetsOption = createDropdown(settingsScroll, 0, yS, "Targets", targetsOptionsList, 1, function(idx, val)
    targetsOption = val
end)
yS = yS + 40 -- Espaço extra para garantir separação visual

-- Função para mini lista e botão de puxar arma no final do painel de Settings
local function getWeaponsList()
    local containers = {
        game:GetService("ReplicatedStorage"),
        game:GetService("Workspace"),
        game:GetService("StarterPack"),
    }
    local armas = {}
    local added = {}
    for _, container in ipairs(containers) do
        for _, obj in ipairs(container:GetDescendants()) do
            if obj:IsA("Tool") or obj:IsA("HopperBin") then
                if not added[obj.Name] then
                    table.insert(armas, obj.Name)
                    added[obj.Name] = true
                end
            end
        end
    end
    table.sort(armas)
    return armas
end

local function addWeaponSelectorWeaponMods()
    local weaponDropdown, getSelectedWeapon, selectedWeapon
    weaponDropdown, getSelectedWeapon = createDropdown(weaponScroll, 0, yW, "Selecionar Arma", getWeaponsList(), 1, function(idx, val)
        selectedWeapon = val
    end)
    yW = yW + 32

    local puxarArmaBtn = Instance.new("TextButton")
    puxarArmaBtn.Parent = weaponScroll
    puxarArmaBtn.Position = UDim2.new(0, 0, 0, yW)
    puxarArmaBtn.Size = UDim2.new(0, 120, 0, 24)
    puxarArmaBtn.BackgroundColor3 = Color3.fromRGB(20,20,20) -- preto
    puxarArmaBtn.TextColor3 = Color3.fromRGB(255,255,255)
    puxarArmaBtn.Text = "Puxar Arma"
    puxarArmaBtn.Font = Enum.Font.GothamBold
    puxarArmaBtn.TextSize = 15
    puxarArmaBtn.AutoButtonColor = true

    local function giveWeaponToLocalPlayer(weaponName)
        -- SANDBOX: Disabled - não clonamos armas nem enviamos remotes.
        pcall(function() print("[SANDBOX] giveWeaponToLocalPlayer blocked for:", weaponName) end)
        return false
    end

    puxarArmaBtn.MouseButton1Click:Connect(function()
        local arma = selectedWeapon or (getSelectedWeapon and getSelectedWeapon())
        if arma then
            giveWeaponToLocalPlayer(arma)
        end
    end)
    yW = yW + 32
end

-- Chamar função no Weapon Mods (após Noclip)
addWeaponSelectorWeaponMods()


-- Target ESP (color pickers removed)
yS = yS + 60

-- Espectar Player (telar)
local spectateConn = nil
local function spectatePlayer(state)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    if spectateConn then spectateConn:Disconnect() spectateConn = nil end
    if state and selectedPlayer then
        local function updateSpectate()
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                Camera.CameraSubject = target.Character.HumanoidRootPart
            end
        end
        updateSpectate()
        spectateConn = game:GetService("RunService").RenderStepped:Connect(updateSpectate)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
        end
    end
end
createCheckbox(settingsScroll, 0, yS, "Espectar Player", false, spectatePlayer)
yS = yS + 28

-- Teleportar até o player selecionado
local function teleportToPlayer(state)
    if state and selectedPlayer then
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local remoteNames = {"TeleportToPlayer", "TeleportEvent", "TPEvent", "Teleport", "TPToPlayer"}
        for _, remoteName in ipairs(remoteNames) do
            local remote = ReplicatedStorage:FindFirstChild(remoteName)
            if remote and remote:IsA("RemoteEvent") then
                fireServerBypass(remote, selectedPlayer)
                return
            end
        end
        -- Fallback local
        local target = Players:FindFirstChild(selectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
        end
    end
end
createCheckbox(settingsScroll, 0, yS, "Teleportar até Player", false, teleportToPlayer)
yS = yS + 28

-- Trazer o player selecionado até você
local function bringPlayerToMe(state)
    if state and selectedPlayer then
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local remoteNames = {"BringPlayer", "BringEvent", "BringToMe", "Bring", "TPHereEvent"}
        for _, remoteName in ipairs(remoteNames) do
            local remote = ReplicatedStorage:FindFirstChild(remoteName)
            if remote and remote:IsA("RemoteEvent") then
                fireServerBypass(remote, selectedPlayer)
                return
            end
        end
        -- Fallback local
        local target = Players:FindFirstChild(selectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            target.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
        end
    end
end
createCheckbox(settingsScroll, 0, yS, "Trazer Player até mim", false, bringPlayerToMe)
yS = yS + 28

-- God Mode (Imortalidade)
local godModeActive = false
local godModeConn = nil
local function setGodMode(state)
    godModeActive = state
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    if godModeConn then godModeConn:Disconnect() godModeConn = nil end
    if state then
        local function onHealthChanged(health)
            if godModeActive and health < 100 then
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.Health = humanoid.MaxHealth end
            end
        end
        local function connectHumanoid()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Health = humanoid.MaxHealth
                    godModeConn = humanoid.HealthChanged:Connect(onHealthChanged)
                end
            end
        end
        connectHumanoid()
        LocalPlayer.CharacterAdded:Connect(function()
            connectHumanoid()
        end)
    end
end
createCheckbox(settingsScroll, 0, yS, "God Mode (Imortal)", false, setGodMode)
yS = yS + 28

-- FOV
local fovSlider, getFovValue = createSlider(settingsScroll, 0, yS, "FOV", 120, 40, 300, setFOVValue)
yS = yS + 36

-- Color picker para FOV Circle
fovCircleColor = Color3.fromRGB(255, 40, 40) -- global
local colorBoxFovCircle = createColorBox(settingsScroll, 0, yS, "FOV Circle Color", fovCircleColor, function(newColor)
    fovCircleColor = newColor
    if fovCircle then
        fovCircle.Color = fovCircleColor
    end
end)
yS = yS + 28

-- Smooth
local smoothSlider, getSmoothValue = createSlider(settingsScroll, 0, yS, "Smooth", 1, 1, 10)
yS = yS + 36


local distSlider, getDistValue = createSlider(settingsScroll, 0, yS, "Distance", 1000, 100, 3000)
yS = yS + 36

-- Mini lista de jogadores
local function getPlayersList()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end
local selectedPlayer = nil
local function onPlayerSelect(idx, val)
    selectedPlayer = val
end
local playerDropdown, getSelectedPlayer = createDropdown(settingsScroll, 0, yS, "Selecionar Player", getPlayersList(), 1, onPlayerSelect)
yS = yS + 32

-- Função: Congelar Player

local frozenPlayers = {}
local function freezeSelectedPlayer(state)
    if not selectedPlayer then return end
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local remoteNames = {"FreezePlayer", "FreezeEvent", "Freeze", "AnchorPlayer", "AnchorEvent"}
    for _, remoteName in ipairs(remoteNames) do
        local remote = ReplicatedStorage:FindFirstChild(remoteName)
        if remote and remote:IsA("RemoteEvent") then
            fireServerBypass(remote, selectedPlayer, state)
            return
        end
    end
    -- Fallback local
    local target = Players:FindFirstChild(selectedPlayer)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        if state then
            target.Character.HumanoidRootPart.Anchored = true
            frozenPlayers[selectedPlayer] = true
        else
            target.Character.HumanoidRootPart.Anchored = false
            frozenPlayers[selectedPlayer] = nil
        end
    end
end
createCheckbox(settingsScroll, 0, yS, "Congelar Player", false, freezeSelectedPlayer)





yS = yS + 28

-- Função: Clonar Aparência
local function cloneAppearance()
    if not selectedPlayer then return end
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local target = Players:FindFirstChild(selectedPlayer)
    if target and target.Character and LocalPlayer.Character then
        for _, v in ipairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then
                v:Destroy()
            end
        end
        for _, v in ipairs(target.Character:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then
                v:Clone().Parent = LocalPlayer.Character
            end
        end
    end
end
createCheckbox(settingsScroll,    0, yS, "Clonar Aparência", false, function(state)
    if state then cloneAppearance() end
end)
yS = yS + 28

-- Função: Matar Player
local function killSelectedPlayer()
    if not selectedPlayer then return end
    pcall(function() print("[SANDBOX] killSelectedPlayer blocked for:", selectedPlayer) end)
end
createCheckbox(settingsScroll, 0, yS, "Matar Player", false, function(state)
    if state then killSelectedPlayer() end
end)
yS = yS + 28

-- Função: Prender Player (SANDBOX)

local jailedPlayers = {}
local function jailSelectedPlayer(state)
    if not selectedPlayer then return end
    pcall(function() print("[SANDBOX] jailSelectedPlayer blocked for:", selectedPlayer, state) end)
end
createCheckbox(settingsScroll, 0, yS, "Prender Player", false, jailSelectedPlayer)
yS = yS + 28

-- Draw FOV

local checkBoxDrawFov = createCheckbox(settingsScroll, 0, yS, "Draw FOV", false, onDrawFovToggle)
yS = yS + 28
local checkBoxVisibleOnly = createCheckbox(settingsScroll, 0, yS, "Visible Only", false)
yS = yS + 28

local checkBoxTeamCheck = createCheckbox(settingsScroll, 0, yS, "Team Check", false)
yS = yS + 28

-- Campo e botão para puxar dinheiro (final do painel de Settings)
local moneyInput = Instance.new("TextBox")
moneyInput.Parent = settingsScroll
moneyInput.Position = UDim2.new(0, 0, 0, yS)
moneyInput.Size = UDim2.new(0, 120, 0, 24)
moneyInput.BackgroundColor3 = Color3.fromRGB(32,32,32)
moneyInput.TextColor3 = Color3.fromRGB(255,255,255)
moneyInput.PlaceholderText = "Valor do dinheiro"
moneyInput.Font = Enum.Font.Gotham
moneyInput.TextSize = 16
moneyInput.Text = ""
moneyInput.ClearTextOnFocus = false

local puxarBtn = Instance.new("TextButton")
puxarBtn.Parent = settingsScroll
puxarBtn.Position = UDim2.new(0, 130, 0, yS)
puxarBtn.Size = UDim2.new(0, 90, 0, 24)
puxarBtn.BackgroundColor3 = Color3.fromRGB(20,20,20) -- preto
puxarBtn.TextColor3 = Color3.fromRGB(255,255,255)
puxarBtn.Text = "Puxar Dinheiro"
puxarBtn.Font = Enum.Font.GothamBold
puxarBtn.TextSize = 15
puxarBtn.AutoButtonColor = true



local function setLocalPlayerMoney(val)
    -- SANDBOX: Disabled - do not change money values or send remotes
    pcall(function() print("[SANDBOX] setLocalPlayerMoney blocked for:", val) end)
end

-- No final do painel de Settings, adicionar o checkbox do Bypass
yS = yS + 8
local function onBypassCheckbox(state)
    -- Enforce sandbox: always keep remote calls blocked
    BypassEnabled = true
    pcall(function() print("[SANDBOX] Remote calls are permanently blocked in sanitized script.") end)
end
createCheckbox(settingsScroll, 0, yS, "Bypass Anticheat (Bloquear servidor)", false, onBypassCheckbox)
yS = yS + 32

puxarBtn.MouseButton1Click:Connect(function()
    local val = tonumber(moneyInput.Text)
    if val then
        setLocalPlayerMoney(val)
    end
end)
yS = yS + 32

-- No final do painel de Settings, adicionar o checkbox do Bypass
yS = yS + 8
local function onBypassCheckbox(state)
    BypassEnabled = state
    if state then
        print("[Bypass] Ativado: Nenhum dado será enviado ao servidor.")
    else
        print("[Bypass] Desativado: Dados podem ser enviados ao servidor.")
    end
end
createCheckbox(settingsScroll, 0, yS, "Bypass Anticheat (Bloquear servidor)", false, onBypassCheckbox)
yS = yS + 32

-- Após criar o gui (ScreenGui principal):

gui:GetPropertyChangedSignal("Visible"):Connect(function()
    if not gui.Visible then
        gui.Visible = true
        print("[Proteção] Menu forçado a ficar visível.")
    end
end)

-- Função para desativar/limpar todas as funções do mod menu
local function cleanupModMenu()
    -- Exemplo de limpeza (adicione aqui todas as funções que precisam ser desativadas):
    -- Tentar desconectar/limpar todos os handlers conhecidos
    if espDisconnect and type(espDisconnect) == "function" then
        pcall(espDisconnect)
        espDisconnect = nil
    end
    if espConnections then
        for _, c in ipairs(espConnections) do pcall(function() if c.Disconnect then c:Disconnect() end end) end
        espConnections = {}
    end
    if allDrawings then
        for _, d in ipairs(allDrawings) do pcall(function() if d.Remove then d:Remove() end end) end
        allDrawings = {}
    end
    if noclipConn then pcall(function() noclipConn:Disconnect() end) noclipConn = nil end
    if disableNoclip and type(disableNoclip) == "function" then pcall(disableNoclip) end
    if aimbotDisconnect and type(aimbotDisconnect) == "function" then pcall(aimbotDisconnect) aimbotDisconnect = nil end
    if norecoilDisconnect and type(norecoilDisconnect) == "function" then pcall(norecoilDisconnect) norecoilDisconnect = nil end
    if triggerbotDisconnect and type(triggerbotDisconnect) == "function" then pcall(triggerbotDisconnect) triggerbotDisconnect = nil end
    if freezeTargetDisconnect and type(freezeTargetDisconnect) == "function" then pcall(freezeTargetDisconnect) freezeTargetDisconnect = nil end
    if instantChargeDisconnect and type(instantChargeDisconnect) == "function" then pcall(instantChargeDisconnect) instantChargeDisconnect = nil end
    if nobloomDisconnect and type(nobloomDisconnect) == "function" then pcall(nobloomDisconnect) nobloomDisconnect = nil end
    -- Remover círculo de FOV
    if fovCircle then pcall(function() fovCircle:Remove() end) fovCircle = nil end
    -- Resetar variáveis de estado
    noclipActive = false
    aimbotActive = false
    espActive = false
    triggerbotActive = false
    print("[ModMenu] Todas as funções foram desativadas e limpas.")
end

gui.AncestryChanged:Connect(function(_, parent)
    if not parent then
        cleanupModMenu()
    end
end)

aimbotBtn.MouseButton1Click:Connect(function()
    selectAimbotTab()
end)
attackPanel.Visible = true


