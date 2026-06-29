--[[
	═══════════════════════════════════════════════════════════════
	  GHOST MENU BY MAGNATA 2.0 (Remastered - V7 THE MONSTER)
	  Layout Dashboard Original — NADA REMOVIDO, SÓ ADICIONADO!
	  + Hitbox Expander, Spinbot, Vehicle Fly, Wallbang e Cores!
	  Roblox Studio • LocalScript em StarterPlayerScripts
	═══════════════════════════════════════════════════════════════
--]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local WS = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local camera = WS.CurrentCamera
local mouse = player:GetMouse()
-- ╔══════════════════════════════════════════════════════════════╗
-- ║               SISTEMA DE BYPASS E STEALTH                    ║
-- ╚══════════════════════════════════════════════════════════════╝
-- Bypass simples: só bloqueia RemoteEvent e RemoteFunction
-- Ativar bypass por padrão: não enviar RemoteEvent ao servidor ao executar o script
local BypassEnabled = true
-- Bypass modes:
-- "block_all" = bloqueia todo FireServer/Invoke
-- "allow_whitelist" = bloqueia exceto remotes na whitelist
-- "passthrough" = não bloqueia (apenas loga quando desativado)
local BypassMode = "block_all" 
-- tabelas configuráveis
local bypassWhitelist = {} -- keys: Instance (RemoteEvent/RemoteFunction) -> true
local bypassBlacklist = {} -- keys: Instance -> true
local lastBlocked = {}
local function remoteId(remote)
    if not remote or not remote:IsA("Instance") then return "<unknown>" end
    local ok, name = pcall(function() return tostring(remote:GetFullName()) end)
    if ok and name then return name end
    return (remote.Name or "<unnamed>")
end
local oldNamecall
oldNamecall = hookmetamethod and hookmetamethod(game, "__namecall", function(self, ...)
	local method = getnamecallmethod()
	local args = {...}
	
	-- Sistema de Silent Aim (Intercepta Raycasts e Remotes de tiro)
	if S.silentAim and BypassEnabled and not checkcaller() then
		if method == "FireServer" or method == "InvokeServer" then
			-- Tentativa genérica de modificar Hit/Position/CFrame em argumentos de remotes de tiro
			if S.aimbotTarget and S.aimbotTarget.Parent then
				for i, arg in pairs(args) do
					if typeof(arg) == "Vector3" then
						args[i] = S.aimbotTarget.Position
					elseif typeof(arg) == "CFrame" then
						args[i] = CFrame.new(args[i].Position, S.aimbotTarget.Position)
					elseif typeof(arg) == "table" and arg.Hit then
						arg.Hit = S.aimbotTarget.Position
					end
				end
				return oldNamecall(self, unpack(args))
			end
		end
		
		-- Redirecionar Mouse.Hit e Mouse.Target (usado por jogos clássicos e ferramentas antigas)
		if method == "Hit" or method == "Target" then
			if S.aimbotTarget and S.aimbotTarget.Parent then
				if method == "Hit" then return CFrame.new(S.aimbotTarget.Position) end
				if method == "Target" then return S.aimbotTarget end
			end
		end
	end
	-- Bypass Padrão Original (Com suporte a Whitelist/Blacklist)
	if BypassEnabled and not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
		if BypassMode == "block_all" then
			lastBlocked[remoteId(self)] = true
			return nil
		elseif BypassMode == "allow_whitelist" then
			if not bypassWhitelist[self] then
				lastBlocked[remoteId(self)] = true
				return nil
			end
		end
	end
	return oldNamecall(self, unpack(args))
end) or function() end
local stealthEnabled = false
local originalPrint = print
local function setStealth(state)
	stealthEnabled = state
	if state then print = function() end else print = originalPrint end
end
-- ╔══════════════════════════════════════════════════════════════╗
-- ║                    ESTADO GLOBAL                             ║
-- ╚══════════════════════════════════════════════════════════════╝
local S = {
	-- Configurações Gerais de Alvo
	targetTeam = "Todos", aimbotPart = "Head",
	-- Combat / Attack
	aimbot = false, aimbotFOV = 120, aimbotSmooth = 8, aimbotMethod = "Camera",
	triggerbot = false, triggerDelay = 0, autoHeadshot = false, silentAim = false,
	hitboxExpander = false, hitboxSize = 10,
	antiAim = false, killAura = false,
	
	-- Weapon
	noRecoil = false, noSpread = false, infAmmo = false, rapidFire = false, dmgMult = 1, wallbang = false,
	
	-- Visuals
	espHighlight = false, espBox = false, espTracer = false, espSkeleton = false, espName = false,
	fovCircle = false, fovCircleColor = "Cyan", fullbright = false,
	espBoxColor = "Red", espTracerColor = "Red", espSkeletonColor = "White", espNameColor = "White",
	chams = false, chamsColor = "Red", worldFOV = 70, timeOfDay = "Normal", thirdPerson = false, thirdPersonDist = 10,
	
	-- Misc / Movement
	speed = false, speedVal = 50, superJump = false, fly = false, noclip = false, godMode = false,
	spinbot = false, spinbotSpeed = 30, vehicleFly = false, autoBhop = false, spider = false, antiAfk = false,
	
	-- Settings
	mobileBtn = true,
	
	-- Objects & Tracking
	fovCircleObj = nil, flyBV = nil, flyBG = nil, vFlyBV = nil, vFlyBG = nil, espHighlighs = {},
	aimbotTarget = nil
}
local colorMap = {
	["Red"] = Color3.fromRGB(255, 40, 40), ["Green"] = Color3.fromRGB(40, 255, 40),
	["Blue"] = Color3.fromRGB(40, 100, 255), ["White"] = Color3.fromRGB(255, 255, 255),
	["Yellow"] = Color3.fromRGB(255, 255, 40), ["Purple"] = Color3.fromRGB(150, 40, 255),
	["Cyan"] = Color3.fromRGB(0, 200, 255)
}
local colorNames = {"Red", "Green", "Blue", "White", "Yellow", "Purple", "Cyan"}
local function isValidTarget(p2)
	if not p2 or p2 == player then return false end
	if S.targetTeam == "Somente Inimigos" and p2.Team and player.Team and p2.Team == player.Team then return false end
	return true
end
local function make(class, props)
	local inst = Instance.new(class)
	if props then
		for k, v in pairs(props) do if k ~= "Parent" then inst[k] = v end end
		if props.Parent then inst.Parent = props.Parent end
	end
	return inst
end
-- ╔══════════════════════════════════════════════════════════════╗
-- ║                      GUI BASE (LAYOUT MAGNATA)               ║
-- ╚══════════════════════════════════════════════════════════════╝
local gui = make("ScreenGui", { Name = "MagnataMenuRemastered", ResetOnSpawn = false, DisplayOrder = 9999, ZIndexBehavior = Enum.ZIndexBehavior.Global, IgnoreGuiInset = true, Parent = player:WaitForChild("PlayerGui") })
local espContainer = make("Folder", { Name = "ESP_Drawings", Parent = gui })
local notifContainer = make("Frame", { Size = UDim2.new(0, 250, 1, -20), Position = UDim2.new(1, -270, 0, 10), BackgroundTransparency = 1, Parent = gui })
make("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), VerticalAlignment = Enum.VerticalAlignment.Bottom, Parent = notifContainer})
local main = make("Frame", { Size = UDim2.new(0, 820, 0, 520), Position = UDim2.new(0.5, -410, 0.5, -260), BackgroundColor3 = Color3.fromRGB(20, 20, 20), BorderSizePixel = 0, Visible = false, Parent = gui })
make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = main}); make("UIStroke", {Thickness = 1, Color = Color3.fromRGB(50, 50, 50), Parent = main})
make("UIGradient", { Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 28)), ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 24)) }, Parent = main })
-- Watermark Premium
local watermark = make("Frame", { Size = UDim2.new(0, 300, 0, 24), Position = UDim2.new(0, 15, 0, 15), BackgroundColor3 = Color3.fromRGB(20, 20, 24), BorderSizePixel = 0, Parent = gui })
make("UICorner", {CornerRadius = UDim.new(0, 4), Parent = watermark}); make("UIStroke", {Thickness = 1, Color = Color3.fromRGB(0, 200, 255), Parent = watermark})
local wmText = make("TextLabel", { Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, Text = "Ghost Menu V8 | FPS: 0 | Ping: 0ms", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.fromRGB(220, 220, 220), TextXAlignment = Enum.TextXAlignment.Left, Parent = watermark })
local rainbow = make("Frame", { Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Parent = watermark })
make("UIGradient", { Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)) }, Parent = rainbow })
local function notify(titleStr, textStr, duration)
	local dur = duration or 3
	local n = make("Frame", { Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = Color3.fromRGB(25, 25, 30), BackgroundTransparency = 1, Parent = notifContainer })
	make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = n})
	local stroke = make("UIStroke", {Thickness = 1, Color = Color3.fromRGB(0, 200, 255), Transparency = 1, Parent = n})
	local accent = make("Frame", { Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 200, 255), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = n })
	make("UICorner", {CornerRadius = UDim.new(0, 3), Parent = accent})
	local t = make("TextLabel", { Size = UDim2.new(1, -15, 0, 20), Position = UDim2.new(0, 10, 0, 5), BackgroundTransparency = 1, Text = titleStr, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255, 255, 255), TextTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = n })
	local d = make("TextLabel", { Size = UDim2.new(1, -15, 0, 20), Position = UDim2.new(0, 10, 0, 25), BackgroundTransparency = 1, Text = textStr, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Color3.fromRGB(180, 180, 180), TextTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = n })
	
	TweenService:Create(n, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
	TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0.5}):Play()
	TweenService:Create(accent, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
	TweenService:Create(t, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	TweenService:Create(d, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	
	task.delay(dur, function()
		TweenService:Create(n, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
		TweenService:Create(accent, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		TweenService:Create(t, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		TweenService:Create(d, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		task.wait(0.3); n:Destroy()
	end)
end
local title = make("TextLabel", { Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Color3.fromRGB(16, 16, 18), BorderSizePixel = 0, Text = " Ghost Menu by creator Magnata 2.0 (V8 ULTIMATE)", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(140, 220, 255), TextXAlignment = Enum.TextXAlignment.Center, Parent = main })
local closeBtn = make("TextButton", { Size = UDim2.new(0, 32, 0, 24), Position = UDim2.new(1, -38, 0, 6), BackgroundColor3 = Color3.fromRGB(32, 32, 32), Text = "✕", Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(140, 220, 255), BorderSizePixel = 0, Parent = main })
make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = closeBtn})
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)
local sidebar = make("Frame", { Size = UDim2.new(0, 110, 1, -36), Position = UDim2.new(0, 0, 0, 36), BackgroundColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Parent = main })
make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = sidebar}); make("UIStroke", {Thickness = 1, Color = Color3.fromRGB(0, 200, 255), Transparency = 0.8, Parent = sidebar})
-- ╔══════════════════════════════════════════════════════════════╗
-- ║                  PAINÉIS DE CONTEÚDO                         ║
-- ╚══════════════════════════════════════════════════════════════╝
local function createPanelBase(name, x, y, w, h)
	local p = make("Frame", { Size = UDim2.new(0, w, 0, h), Position = UDim2.new(0, x, 0, y), BackgroundColor3 = Color3.fromRGB(28, 28, 32), BorderSizePixel = 0, Parent = main })
	make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = p}); make("UIStroke", {Thickness = 1, Color = Color3.fromRGB(40, 40, 40), Parent = p})
	make("TextLabel", { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Text = name, Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(140, 220, 255), Parent = p })
	local scroll = make("ScrollingFrame", { Size = UDim2.new(1, 0, 1, -28), Position = UDim2.new(0, 0, 0, 28), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0, 0, 0, 0), Parent = p })
	make("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = scroll}); make("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), Parent = scroll})
	return p, scroll
end
local pAttack, sAttack = createPanelBase("Attack", 120, 46, 340, 464)
local pWeapon, sWeapon = createPanelBase("Weapon Mods", 470, 46, 340, 225)
local pVisual, sVisual = createPanelBase("Visuals", 470, 46, 340, 225)
local pMisc, sMisc = createPanelBase("Misc", 470, 285, 340, 225)
local pSettings, sSettings = createPanelBase("Settings", 470, 285, 340, 225)
pVisual.Visible = false; pSettings.Visible = false
local function createSidebarBtn(icon, y, callback)
	local btn = make("TextButton", { Size = UDim2.new(1, 0, 0, 48), Position = UDim2.new(0, 0, 0, y), BackgroundColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Text = "", Parent = sidebar })
	make("UICorner", {CornerRadius = UDim.new(0,8), Parent = btn})
	local lbl = make("TextLabel", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = icon, Font = Enum.Font.GothamBold, TextSize = 22, TextColor3 = Color3.fromRGB(100, 100, 100), Parent = btn })
	local accent = make("Frame", { Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 200, 255), BorderSizePixel = 0, BackgroundTransparency = 1, Parent = btn })
	make("UICorner", {CornerRadius = UDim.new(0,2), Parent = accent})
	btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play(); TweenService:Create(lbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play(); TweenService:Create(accent, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play() end)
	btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play(); TweenService:Create(lbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(100, 100, 100)}):Play(); TweenService:Create(accent, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end)
	btn.MouseButton1Click:Connect(callback)
end
createSidebarBtn("🎯", 10, function() pAttack.Visible = true; pWeapon.Visible = true; pMisc.Visible = true; pVisual.Visible = false; pSettings.Visible = false end)
createSidebarBtn("👁️", 65, function() pWeapon.Visible = false; pVisual.Visible = true end)
createSidebarBtn("⚙️", 120, function() pMisc.Visible = false; pSettings.Visible = true end)
-- ╔══════════════════════════════════════════════════════════════╗
-- ║                COMPONENTES DE UI MAGNATA                     ║
-- ╚══════════════════════════════════════════════════════════════╝
local function createCheckbox(parent, labelText, default, callback)
	local checked = default
	local f = make("Frame", { Size = UDim2.new(1, -20, 0, 32), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Parent = parent })
	make("TextLabel", { Size = UDim2.new(1, -40, 1, 0), BackgroundTransparency = 1, Text = "  " .. labelText, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Color3.fromRGB(220, 220, 230), TextXAlignment = Enum.TextXAlignment.Left, Parent = f })
	local box = make("TextButton", { Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -24, 0.5, -11), BackgroundColor3 = Color3.fromRGB(24, 24, 28), BorderSizePixel = 0, Text = "", Parent = f })
	make("UICorner", {CornerRadius = UDim.new(0,6), Parent = box}); make("UIStroke", {Thickness = 1, Color = Color3.fromRGB(50,50,55), Parent = box})
	local check = make("Frame", { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 4, 0, 4), BackgroundColor3 = checked and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(24,24,28), BorderSizePixel = 0, Parent = box })
	make("UICorner", {CornerRadius = UDim.new(0,4), Parent = check})
	box.MouseButton1Click:Connect(function() 
		checked = not checked; 
		TweenService:Create(check, TweenInfo.new(0.15), {BackgroundColor3 = checked and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(24,24,28)}):Play(); 
		if checked then notify("Module Toggled", labelText .. " foi Ativado", 2) else notify("Module Toggled", labelText .. " foi Desativado", 2) end
		if callback then callback(checked) end 
	end)
end
local function createCycleButton(parent, labelText, options, default, callback)
	local idx = 1
	for i, v in ipairs(options) do if v == default then idx = i break end end
	local f = make("Frame", { Size = UDim2.new(1, -20, 0, 32), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Parent = parent })
	make("TextLabel", { Size = UDim2.new(0, 150, 0, 32), BackgroundTransparency = 1, Text = "  " .. labelText, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Color3.fromRGB(220, 220, 230), TextXAlignment = Enum.TextXAlignment.Left, Parent = f })
	local btn = make("TextButton", { Size = UDim2.new(0, 120, 0, 24), Position = UDim2.new(1, -120, 0, 4), BackgroundColor3 = Color3.fromRGB(24, 24, 28), Text = options[idx], Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.fromRGB(0, 200, 255), Parent = f })
	make("UICorner", {CornerRadius = UDim.new(0,4), Parent = btn}); make("UIStroke", {Thickness = 1, Color = Color3.fromRGB(50,50,55), Parent = btn})
	btn.MouseButton1Click:Connect(function() idx = (idx % #options) + 1; btn.Text = options[idx]; callback(options[idx]) end)
end
local function createSlider(parent, labelText, min, max, default, callback)
	local val = default
	local f = make("Frame", { Size = UDim2.new(1, -20, 0, 48), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Parent = parent })
	make("TextLabel", { Size = UDim2.new(1, -50, 0, 20), BackgroundTransparency = 1, Text = "  " .. labelText, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Color3.fromRGB(220, 220, 230), TextXAlignment = Enum.TextXAlignment.Left, Parent = f })
	local valLbl = make("TextLabel", { Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -40, 0, 0), BackgroundTransparency = 1, Text = tostring(val), Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.fromRGB(0, 200, 255), TextXAlignment = Enum.TextXAlignment.Right, Parent = f })
	local track = make("Frame", { Size = UDim2.new(1, -10, 0, 6), Position = UDim2.new(0, 5, 0, 28), BackgroundColor3 = Color3.fromRGB(20, 20, 24), BorderSizePixel = 0, Parent = f })
	make("UICorner", {CornerRadius = UDim.new(1,0), Parent = track})
	local pct = (val - min) / (max - min)
	local fill = make("Frame", { Size = UDim2.new(pct, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 200, 255), BorderSizePixel = 0, Parent = track })
	make("UICorner", {CornerRadius = UDim.new(1,0), Parent = fill})
	local btn = make("TextButton", { Size = UDim2.new(1, 0, 1, 10), Position = UDim2.new(0, 0, 0, -5), BackgroundTransparency = 1, Text = "", Parent = track })
	local dragging = false
	btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
	btn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local p2 = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			val = math.floor(min + p2 * (max - min)); fill.Size = UDim2.new(p2, 0, 1, 0); valLbl.Text = tostring(val); callback(val)
		end
	end)
end
local function createButton(parent, labelText, callback)
	local f = make("Frame", { Size = UDim2.new(1, -20, 0, 32), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Parent = parent })
	local btn = make("TextButton", { Size = UDim2.new(1, 0, 0, 24), Position = UDim2.new(0, 0, 0, 4), BackgroundColor3 = Color3.fromRGB(24, 24, 28), Text = labelText, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.fromRGB(0, 200, 255), Parent = f })
	make("UICorner", {CornerRadius = UDim.new(0,4), Parent = btn}); make("UIStroke", {Thickness = 1, Color = Color3.fromRGB(50,50,55), Parent = btn})
	btn.MouseButton1Click:Connect(function() 
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 200, 255), TextColor3 = Color3.fromRGB(0,0,0)}):Play()
		task.wait(0.1)
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(24, 24, 28), TextColor3 = Color3.fromRGB(0, 200, 255)}):Play()
		if callback then callback() end 
	end)
end
-- ╔══════════════════════════════════════════════════════════════╗
-- ║               SISTEMA DE ESP 2D AVANÇADO                     ║
-- ╚══════════════════════════════════════════════════════════════╝
local espCache = {}
local r15conns = { {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"}, {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"}, {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"}, {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"} }
local r6conns = { {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"} }
local function getLine() return make("Frame", { BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = 1, Visible = false, Parent = espContainer }) end
local function drawLine(line, p1, p2, thickness)
	local dist = (p2 - p1).Magnitude; line.Size = UDim2.new(0, dist, 0, thickness); line.Position = UDim2.new(0, (p1.X + p2.X) / 2, 0, (p1.Y + p2.Y) / 2); line.Rotation = math.deg(math.atan2(p2.Y - p1.Y, p2.X - p1.X))
end
local function getEspCache(p)
	if not espCache[p] then
		local c = { box = {getLine(), getLine(), getLine(), getLine()}, tracer = getLine(), name = make("TextLabel", { BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.new(1,1,1), TextStrokeTransparency = 0, AnchorPoint = Vector2.new(0.5, 1), ZIndex = 2, Visible = false, Parent = espContainer }), skeleton = {}, headCircle = make("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = 1, Visible = false, Parent = espContainer }) }
		make("UICorner", {CornerRadius = UDim.new(0.5, 0), Parent = c.headCircle})
		make("UIStroke", {Name = "Stroke", Thickness = 1.5, Parent = c.headCircle})
		for i = 1, 15 do table.insert(c.skeleton, getLine()) end
		espCache[p] = c
	end
	return espCache[p]
end
local function hideEsp(cache)
	for _, l in ipairs(cache.box) do l.Visible = false end
	cache.tracer.Visible = false; cache.name.Visible = false
	for _, l in ipairs(cache.skeleton) do l.Visible = false end
	if cache.headCircle then cache.headCircle.Visible = false end
end
local function updateEsp(p)
	local cache = getEspCache(p)
	local char = p.Character
	if not char or not char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("Humanoid").Health <= 0 then hideEsp(cache); return end
	
	local head = char:FindFirstChild("Head")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not head or not root then hideEsp(cache); return end
	
	local topPos, topVis = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
	local botPos, botVis = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
	local rootPos, rootVis = camera:WorldToViewportPoint(root.Position)
	
	if not topVis or not botVis then hideEsp(cache); return end
	
	local h = botPos.Y - topPos.Y; local w = h / 2; local x = topPos.X - w/2; local y = topPos.Y
	
	if S.espBox then
		local cBox = colorMap[S.espBoxColor]
		local b = cache.box
		b[1].Size = UDim2.new(0, 1, 0, h); b[1].Position = UDim2.new(0, x, 0, y + h/2); b[1].Rotation = 0; b[1].Visible = true; b[1].BackgroundColor3 = cBox
		b[2].Size = UDim2.new(0, 1, 0, h); b[2].Position = UDim2.new(0, x + w, 0, y + h/2); b[2].Rotation = 0; b[2].Visible = true; b[2].BackgroundColor3 = cBox
		b[3].Size = UDim2.new(0, w, 0, 1); b[3].Position = UDim2.new(0, x + w/2, 0, y); b[3].Rotation = 0; b[3].Visible = true; b[3].BackgroundColor3 = cBox
		b[4].Size = UDim2.new(0, w, 0, 1); b[4].Position = UDim2.new(0, x + w/2, 0, y + h); b[4].Rotation = 0; b[4].Visible = true; b[4].BackgroundColor3 = cBox
	else
		for _, l in ipairs(cache.box) do l.Visible = false end
	end
	
	if S.espTracer then drawLine(cache.tracer, Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y), Vector2.new(rootPos.X, rootPos.Y), 1.5); cache.tracer.BackgroundColor3 = colorMap[S.espTracerColor]; cache.tracer.Visible = true else cache.tracer.Visible = false end
	
	if S.espName then
		local hp = math.floor(char:FindFirstChildOfClass("Humanoid").Health)
		cache.name.Text = string.format("%s [%d HP]", p.Name, hp); cache.name.Position = UDim2.new(0, x + w/2, 0, y - 5); cache.name.TextColor3 = colorMap[S.espNameColor]; cache.name.Visible = true
	else cache.name.Visible = false end
	
	local lineIdx = 1
	if S.espSkeleton then
		local cSkel = colorMap[S.espSkeletonColor]
		local conns = (char:FindFirstChild("UpperTorso")) and r15conns or r6conns
		for _, c in ipairs(conns) do
			local p1 = char:FindFirstChild(c[1]); local p2 = char:FindFirstChild(c[2])
			if p1 and p2 then
				local p1Pos, v1 = camera:WorldToViewportPoint(p1.Position)
				local p2Pos, v2 = camera:WorldToViewportPoint(p2.Position)
				if v1 and v2 then
					local line = cache.skeleton[lineIdx]
					if line then drawLine(line, Vector2.new(p1Pos.X, p1Pos.Y), Vector2.new(p2Pos.X, p2Pos.Y), 1.5); line.BackgroundColor3 = cSkel; line.Visible = true; lineIdx = lineIdx + 1 end
				end
			end
		end
		local headPos, headVis = camera:WorldToViewportPoint(head.Position)
		if headVis then
			local headTopPos, _ = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.6, 0))
			local radius = math.abs(headPos.Y - headTopPos.Y) * 2
			cache.headCircle.Position = UDim2.new(0, headPos.X, 0, headPos.Y)
			cache.headCircle.Size = UDim2.new(0, radius, 0, radius)
			cache.headCircle.Stroke.Color = cSkel
			cache.headCircle.Visible = true
		else cache.headCircle.Visible = false end
	else
		if cache.headCircle then cache.headCircle.Visible = false end
	end
	for i = lineIdx, #cache.skeleton do cache.skeleton[i].Visible = false end
end
local function refreshHighlightESP()
	for _, o in pairs(S.espHighlighs) do if o and o.Parent then o:Destroy() end end; S.espHighlighs = {}
	if not S.espHighlight then return end
	for _, p in ipairs(Players:GetPlayers()) do
		if isValidTarget(p) and p.Character then table.insert(S.espHighlighs, make("Highlight", {FillColor = Color3.fromRGB(255, 40, 40), Parent = p.Character})) end
	end
end
local function applyChams(char, enabled)
	if not char then return end
	for _, p in ipairs(char:GetDescendants()) do
		if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
			if enabled then
				if not p:FindFirstChild("OriginalMat") then
					make("StringValue", {Name = "OriginalMat", Value = tostring(p.Material), Parent = p})
					make("Color3Value", {Name = "OriginalCol", Value = p.Color, Parent = p})
				end
				p.Material = Enum.Material.ForceField
				p.Color = colorMap[S.chamsColor] or Color3.new(1,0,0)
			else
				if p:FindFirstChild("OriginalMat") then
					p.Material = Enum.Material[string.split(p.OriginalMat.Value, ".")[3]] or Enum.Material.Plastic
					p.Color = p.OriginalCol.Value
					p.OriginalMat:Destroy(); p.OriginalCol:Destroy()
				end
			end
		end
	end
end
local frames, lastTick = 0, tick()
RunService.RenderStepped:Connect(function()
	frames = frames + 1
	if tick() - lastTick >= 1 then
		local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
		wmText.Text = string.format("Ghost Menu V8 | FPS: %d | Ping: %dms", frames, ping)
		frames = 0; lastTick = tick()
		local mw = math.clamp(wmText.TextBounds.X + 20, 200, 400)
		TweenService:Create(watermark, TweenInfo.new(0.5), {Size = UDim2.new(0, mw, 0, 24)}):Play()
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if isValidTarget(p) then
			if (S.espBox or S.espTracer or S.espSkeleton or S.espName) then updateEsp(p) elseif espCache[p] then hideEsp(espCache[p]) end
		else
			if espCache[p] then hideEsp(espCache[p]) end
		end
	end
end)
-- ╔══════════════════════════════════════════════════════════════╗
-- ║                  LÓGICA DOS CHEATS FPS                       ║
-- ╚══════════════════════════════════════════════════════════════╝
local function getChar() return player.Character or player.CharacterAdded:Wait() end
local function getRoot() local c = getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
-- Lógica para injeção em armas (Wallbang e Weapon Mods)
local function hookWeapon(tool)
	for _, v in ipairs(tool:GetDescendants()) do
		if v:IsA("NumberValue") or v:IsA("IntValue") or v:IsA("BoolValue") then
			local n = v.Name:lower()
			if S.noRecoil and (n:find("recoil") or n:find("kick")) then v.Value = 0 end
			if S.noSpread and (n:find("spread") or n:find("accuracy")) then v.Value = 0 end
			if S.infAmmo and (n:find("ammo") or n:find("mag")) then v.Value = 999 end
			if S.wallbang and (n:find("penetration") or n:find("wallbang") or n:find("pierce")) then
				if v:IsA("BoolValue") then v.Value = true else v.Value = 999 end
			end
		end
	end
end
player.CharacterAdded:Connect(function(char)
	char.ChildAdded:Connect(function(child) if child:IsA("Tool") then task.wait(0.1); hookWeapon(child) end end)
end)
RunService.Heartbeat:Connect(function()
	local char = player.Character; if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local rp = char:FindFirstChild("HumanoidRootPart")
	-- Hitbox Expander
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local targetHRP = p.Character:FindFirstChild("HumanoidRootPart")
			if targetHRP then
				if S.hitboxExpander and isValidTarget(p) then
					targetHRP.Size = Vector3.new(S.hitboxSize, S.hitboxSize, S.hitboxSize)
					targetHRP.Transparency = 0.7; targetHRP.CanCollide = false
				else
					targetHRP.Size = Vector3.new(2, 2, 1)
					targetHRP.Transparency = 1; targetHRP.CanCollide = true
				end
			end
		end
	end
	if hum then
		if S.speed then hum.WalkSpeed = S.speedVal end
		if S.superJump then hum.JumpPower = 120; hum.UseJumpPower = true end
		if S.godMode then hum.Health = hum.MaxHealth end
		
		-- Auto Bhop
		if S.autoBhop and UIS:IsKeyDown(Enum.KeyCode.Space) then
			if hum.FloorMaterial ~= Enum.Material.Air then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
		end
	end
	
	if S.noclip then for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
	
	if S.spider and rp then
		local hrpLook = rp.CFrame.LookVector
		local ray = Ray.new(rp.Position, hrpLook * 3)
		local hit, pos = WS:FindPartOnRayWithIgnoreList(ray, {char})
		if hit then
			if not S.flyBV then S.flyBV = make("BodyVelocity", {MaxForce = Vector3.new(1e6,1e6,1e6), Velocity = Vector3.new(0, 50, 0), Parent = rp}) end
		else
			if S.flyBV and not S.fly then S.flyBV:Destroy(); S.flyBV = nil end
		end
	end
	
	if S.spinbot and rp then rp.CFrame = rp.CFrame * CFrame.Angles(0, math.rad(S.spinbotSpeed), 0) end
	if S.antiAim and rp then rp.CFrame = rp.CFrame * CFrame.Angles(math.rad(math.random(-45, 45)), math.rad(math.random(-180, 180)), math.rad(math.random(-45, 45))) end
	
	-- Kill Aura
	if S.killAura and rp then
		for _, p in ipairs(Players:GetPlayers()) do
			if isValidTarget(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local d = (p.Character.HumanoidRootPart.Position - rp.Position).Magnitude
				if d < 15 then
					-- Força colisão violenta / tentativa genérica de dano
					firetouchinterest(rp, p.Character.HumanoidRootPart, 0)
					firetouchinterest(rp, p.Character.HumanoidRootPart, 1)
				end
			end
		end
	end
	
	-- World FOV & 3rd Person
	if S.worldFOV ~= 70 then camera.FieldOfView = S.worldFOV end
	if S.thirdPerson then 
		player.CameraMaxZoomDistance = S.thirdPersonDist
		player.CameraMinZoomDistance = S.thirdPersonDist
	else
		player.CameraMaxZoomDistance = 400
		player.CameraMinZoomDistance = 0.5
	end
	
	-- Time of Day
	if S.timeOfDay == "Dia" then Lighting.ClockTime = 14 elseif S.timeOfDay == "Noite" then Lighting.ClockTime = 0 end
	
	if S.fly and S.flyBV and S.flyBG and rp then
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector end
		if dir.Magnitude > 0 then dir = dir.Unit end
		S.flyBV.Velocity = dir * S.speedVal; S.flyBG.CFrame = camera.CFrame
	end
	
	-- Vehicle Fly
	if S.vehicleFly and hum and hum.SeatPart then
		local seat = hum.SeatPart
		if not S.vFlyBV then S.vFlyBV = make("BodyVelocity", {MaxForce = Vector3.new(1e6,1e6,1e6), Velocity = Vector3.zero, Parent = seat}); S.vFlyBG = make("BodyGyro", {MaxTorque = Vector3.new(1e6,1e6,1e6), D = 200, P = 10000, Parent = seat}) end
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector end
		if dir.Magnitude > 0 then dir = dir.Unit end
		S.vFlyBV.Velocity = dir * S.speedVal; S.vFlyBG.CFrame = camera.CFrame
	else
		if S.vFlyBV then S.vFlyBV:Destroy(); S.vFlyBV = nil end
		if S.vFlyBG then S.vFlyBG:Destroy(); S.vFlyBG = nil end
	end
	if S.aimbot or S.silentAim then
		local best, bd = nil, S.aimbotFOV
		local bestSP = nil
		local mLoc = UIS:GetMouseLocation()
		for _, p in ipairs(Players:GetPlayers()) do
			if isValidTarget(p) and p.Character then
				local part = p.Character:FindFirstChild(S.aimbotPart)
				if part and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
					local sp, onScreen = camera:WorldToViewportPoint(part.Position)
					if onScreen then
						local d = (Vector2.new(sp.X, sp.Y) - mLoc).Magnitude
						if d < bd then bd = d; best = part; bestSP = sp end
					end
				end
			end
		end
		
		S.aimbotTarget = best -- Atualiza o alvo global para o Silent Aim
		if S.aimbot and best and bestSP and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then 
			if S.aimbotMethod == "Mouse" and mousemoverel then
				local smoothFactor = math.max(1, S.aimbotSmooth / 2)
				local moveX = (bestSP.X - mLoc.X) / smoothFactor
				local moveY = (bestSP.Y - mLoc.Y) / smoothFactor
				mousemoverel(moveX, moveY)
			else
				camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, best.Position), S.aimbotSmooth / 100) 
			end
		end
		
		-- Triggerbot
		if S.triggerbot and best and bestSP then
			local dMouse = (Vector2.new(bestSP.X, bestSP.Y) - mLoc).Magnitude
			if dMouse < 25 then
				task.wait(S.triggerDelay / 1000)
				mouse1click()
			end
		end
	else
		S.aimbotTarget = nil
	end
	if S.fovCircle and S.fovCircleObj then 
		local mLoc = UIS:GetMouseLocation()
		S.fovCircleObj.Position = UDim2.new(0, mLoc.X, 0, mLoc.Y)
		S.fovCircleObj.Size = UDim2.new(0, S.aimbotFOV*2, 0, S.aimbotFOV*2)
	end
end)
player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if S.speed then local h = char:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = S.speedVal end end
	if S.godMode then local h = char:FindFirstChildOfClass("Humanoid"); if h then h.Health = 1e9; h.MaxHealth = 1e9 end end
	if S.espHighlight then refreshHighlightESP() end
end)
-- ╔══════════════════════════════════════════════════════════════╗
-- ║                 POPULANDO OS PAINÉIS                         ║
-- ╚══════════════════════════════════════════════════════════════╝
createCycleButton(sAttack, "Target Selection", {"Todos", "Somente Inimigos"}, "Todos", function(v) S.targetTeam = v; refreshHighlightESP() end)
createCycleButton(sAttack, "Aimbot Part", {"Head", "HumanoidRootPart"}, "Head", function(v) S.aimbotPart = v end)
createCycleButton(sAttack, "Aimbot Method", {"Camera", "Mouse"}, "Camera", function(v) S.aimbotMethod = v end)
createCheckbox(sAttack, "Aimbot", false, function(v) S.aimbot = v end)
createCheckbox(sAttack, "Silent Aim (Magic Bullet)", false, function(v) S.silentAim = v end)
createSlider(sAttack, "Aimbot FOV Range", 50, 500, 120, function(v) S.aimbotFOV = v; if S.fovCircleObj then S.fovCircleObj.Size = UDim2.new(0, v*2, 0, v*2) end end)
createSlider(sAttack, "Aimbot Smoothness", 1, 20, 8, function(v) S.aimbotSmooth = v end)
createCheckbox(sAttack, "Triggerbot", false, function(v) S.triggerbot = v end)
createSlider(sAttack, "Triggerbot Delay (ms)", 0, 1000, 0, function(v) S.triggerDelay = v end)
createCheckbox(sAttack, "Hitbox Expander", false, function(v) S.hitboxExpander = v end)
createSlider(sAttack, "Hitbox Size", 2, 30, 10, function(v) S.hitboxSize = v end)
createCheckbox(sAttack, "Anti-Aim (Jitter)", false, function(v) S.antiAim = v end)
createCheckbox(sAttack, "Kill Aura (Melee Fling)", false, function(v) S.killAura = v end)
createCheckbox(sWeapon, "Wallbang (Ignore Walls)", false, function(v) S.wallbang = v end)
createCheckbox(sWeapon, "No Recoil", false, function(v) S.noRecoil = v end)
createCheckbox(sWeapon, "No Spread", false, function(v) S.noSpread = v end)
createCheckbox(sWeapon, "Infinite Ammo", false, function(v) S.infAmmo = v end)
createCheckbox(sWeapon, "Rapid Fire", false, function(v) S.rapidFire = v end)
createSlider(sWeapon, "Damage Multiplier", 1, 10, 1, function(v) S.dmgMult = v end)
createCheckbox(sVisual, "ESP Box (Caixa)", false, function(v) S.espBox = v end)
createCycleButton(sVisual, "↳ Box Color", colorNames, "Red", function(v) S.espBoxColor = v end)
createCheckbox(sVisual, "ESP Tracers (Linhas)", false, function(v) S.espTracer = v end)
createCycleButton(sVisual, "↳ Tracers Color", colorNames, "Red", function(v) S.espTracerColor = v end)
createCheckbox(sVisual, "ESP Skeleton (Esqueleto)", false, function(v) S.espSkeleton = v end)
createCycleButton(sVisual, "↳ Skeleton Color", colorNames, "White", function(v) S.espSkeletonColor = v end)
createCheckbox(sVisual, "ESP Name & HP", false, function(v) S.espName = v end)
createCycleButton(sVisual, "↳ Name & HP Color", colorNames, "White", function(v) S.espNameColor = v end)
createCheckbox(sVisual, "Player ESP Highlight", false, function(v) S.espHighlight = v; refreshHighlightESP() end)
createCheckbox(sVisual, "Chams (Material Hack)", false, function(v) S.chams = v; for _, p in ipairs(Players:GetPlayers()) do if isValidTarget(p) then applyChams(p.Character, v) end end end)
createCycleButton(sVisual, "↳ Chams Color", colorNames, "Red", function(v) S.chamsColor = v; if S.chams then for _, p in ipairs(Players:GetPlayers()) do if isValidTarget(p) then applyChams(p.Character, true) end end end end)
createCheckbox(sVisual, "Draw FOV (Círculo)", false, function(v) 
	S.fovCircle = v
	if v and not S.fovCircleObj then
		S.fovCircleObj = make("Frame", { Size = UDim2.new(0, S.aimbotFOV*2, 0, S.aimbotFOV*2), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Parent = gui })
		make("UICorner", {CornerRadius = UDim.new(0.5, 0), Parent = S.fovCircleObj})
		make("UIStroke", {Name = "Stroke", Color = colorMap[S.fovCircleColor], Thickness = 1.5, Parent = S.fovCircleObj})
	end
	if S.fovCircleObj then S.fovCircleObj.Visible = v end
end)
createCycleButton(sVisual, "↳ FOV Color", colorNames, "Cyan", function(v) 
	S.fovCircleColor = v
	if S.fovCircleObj and S.fovCircleObj:FindFirstChild("Stroke") then S.fovCircleObj.Stroke.Color = colorMap[v] end
end)
createSlider(sVisual, "World FOV", 70, 120, 70, function(v) S.worldFOV = v end)
createCycleButton(sVisual, "Time of Day", {"Normal", "Dia", "Noite"}, "Normal", function(v) S.timeOfDay = v end)
createCheckbox(sVisual, "Third Person Mode", false, function(v) S.thirdPerson = v end)
createSlider(sVisual, "↳ 3rd Person Distance", 5, 50, 10, function(v) S.thirdPersonDist = v end)
createCheckbox(sMisc, "Speed Hack", false, function(v) S.speed = v end)
createSlider(sMisc, "Movement Speed", 16, 200, 50, function(v) S.speedVal = v end)
createCheckbox(sMisc, "Super Jump", false, function(v) S.superJump = v end)
createCheckbox(sMisc, "Auto Bunny Hop", false, function(v) S.autoBhop = v end)
createCheckbox(sMisc, "Spider (Wallclimb)", false, function(v) S.spider = v end)
createCheckbox(sMisc, "Noclip", false, function(v) S.noclip = v end)
createCheckbox(sMisc, "Fly Mode", false, function(v) 
	S.fly = v; local rp = getRoot()
	if v and rp then
		S.flyBV = make("BodyVelocity", {MaxForce = Vector3.new(1e6,1e6,1e6), Velocity = Vector3.zero, Parent = rp})
		S.flyBG = make("BodyGyro", {MaxTorque = Vector3.new(1e6,1e6,1e6), D = 200, P = 10000, Parent = rp})
	else
		if S.flyBV then S.flyBV:Destroy(); S.flyBV = nil end
		if S.flyBG then S.flyBG:Destroy(); S.flyBG = nil end
	end
end)
createCheckbox(sMisc, "Vehicle Fly", false, function(v) S.vehicleFly = v end)
createCheckbox(sMisc, "Spinbot", false, function(v) S.spinbot = v end)
createSlider(sMisc, "Spinbot Speed", 10, 100, 30, function(v) S.spinbotSpeed = v end)
createCheckbox(sMisc, "God Mode", false, function(v) S.godMode = v end)
createCheckbox(sMisc, "Anti-AFK", false, function(v) S.antiAfk = v end)
createButton(sMisc, "Teleport to Aim Target", function()
	local rp = getRoot()
	if rp and S.aimbotTarget and S.aimbotTarget.Parent then
		local targetHrp = S.aimbotTarget.Parent:FindFirstChild("HumanoidRootPart")
		if targetHrp then
			rp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 4)
			notify("Teleport", "Teleportado para as costas de " .. S.aimbotTarget.Parent.Name, 2)
		end
	else
		notify("Erro", "Nenhum alvo na mira do Aimbot/Silent Aim", 2)
	end
end)
createCheckbox(sSettings, "Stealth Mode (Ocultar Logs)", false, setStealth)
createCheckbox(sSettings, "Ativar Botão Mobile", true, function(v) S.mobileBtn = v end)
-- ╔══════════════════════════════════════════════════════════════╗
-- ║                 BOTÃO MOBILE E DRAG MENU                     ║
-- ╚══════════════════════════════════════════════════════════════╝
local mobileButton = make("TextButton", { Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(1, -80, 1, -80), BackgroundColor3 = Color3.fromRGB(0, 200, 255), Text = "👻", TextSize = 26, Font = Enum.Font.GothamBold, BorderSizePixel = 0, ZIndex = 1000, Parent = gui })
make("UICorner", {CornerRadius = UDim.new(0.5, 0), Parent = mobileButton})
mobileButton.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
RunService.Heartbeat:Connect(function() mobileButton.Visible = S.mobileBtn end)
local draggingMain, dragStartMain, startPosMain
title.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingMain = true; dragStartMain = i.Position; startPosMain = main.Position end end)
title.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingMain = false end end)
UIS.InputChanged:Connect(function(i)
	if draggingMain and i.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = i.Position - dragStartMain; main.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
	end
end)
UIS.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
	if S.antiAfk then
		vu:Button2Down(Vector2.new(0,0), camera.CFrame)
		task.wait(1)
		vu:Button2Up(Vector2.new(0,0), camera.CFrame)
		notify("Anti-AFK", "Conexão mantida (Evitou kick por inatividade).", 3)
	end
end)
print("[Magnata Menu Remastered V8 ULTIMATE] ✅ Carregado com Sucesso!")
notify("Ghost Menu Injetado", "V8 ULTIMATE carregada com sucesso. Pressione Insert para abrir/fechar.", 5)
