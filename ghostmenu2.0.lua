--[[
	═══════════════════════════════════════════════════════════════
	  GHOST MENU BY MAGNATA 3.0 (V9 PROFESSIONAL)
	  Splash screen, 5 categorias, 50+ cheats, config system,
	  ESP avancado, keybinds, UI profissional completa.
	  Roblox Studio - LocalScript em StarterPlayerScripts
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

local C = {
	accent      = Color3.fromRGB(255, 30, 30),
	accentGlow  = Color3.fromRGB(255, 80, 80),
	accentDim   = Color3.fromRGB(160, 15, 15),
	accentSoft  = Color3.fromRGB(60, 12, 12),
	textLight   = Color3.fromRGB(255, 100, 100),
	textWhite   = Color3.fromRGB(255, 255, 255),
	textSec     = Color3.fromRGB(200, 200, 210),
	textMuted   = Color3.fromRGB(140, 140, 155),
	sidebarBg   = Color3.fromRGB(22, 22, 28),
	sidebarHover= Color3.fromRGB(35, 35, 42),
	panelBg     = Color3.fromRGB(30, 30, 36),
	cardBg      = Color3.fromRGB(40, 40, 48),
	cardHover   = Color3.fromRGB(52, 52, 62),
	border      = Color3.fromRGB(65, 65, 78),
	borderLight = Color3.fromRGB(85, 85, 100),
	iconDim     = Color3.fromRGB(160, 160, 175),
	trackBg     = Color3.fromRGB(28, 28, 34),
	danger      = Color3.fromRGB(255, 50, 50),
	success     = Color3.fromRGB(50, 230, 90),
	blue        = Color3.fromRGB(60, 140, 255),
	yellow      = Color3.fromRGB(255, 230, 50),
	purple      = Color3.fromRGB(170, 70, 255),
	cyan        = Color3.fromRGB(60, 210, 230),
	white       = Color3.fromRGB(255, 255, 255),
	black       = Color3.fromRGB(0, 0, 0),
}

local BypassEnabled = true
local BypassMode = "block_all"
local bypassWhitelist = {}
local lastBlocked = {}

local function remoteId(remote)
	if not remote or not remote:IsA("Instance") then return "<unknown>" end
	local ok, name = pcall(function() return tostring(remote:GetFullName()) end)
	if ok and name then return name end
	return (remote.Name or "<unnamed>")
end

local S
local oldNamecall
oldNamecall = hookmetamethod and hookmetamethod(game, "__namecall", function(self, ...)
	local method = getnamecallmethod()
	local args = {...}
	if S and S.silentAim and BypassEnabled and not checkcaller() then
		if method == "FireServer" or method == "InvokeServer" then
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
		if method == "Hit" or method == "Target" then
			if S.aimbotTarget and S.aimbotTarget.Parent then
				if method == "Hit" then return CFrame.new(S.aimbotTarget.Position) end
				if method == "Target" then return S.aimbotTarget end
			end
		end
	end
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
local originalWarn = warn
local function setStealth(state)
	stealthEnabled = state
	if state then
		print = function() end
		warn = function() end
	else
		print = originalPrint
		warn = originalWarn
	end
end

S = {
	targetTeam = "Todos", aimbotPart = "Head",
	aimbot = false, aimbotFOV = 120, aimbotSmooth = 8, aimbotMethod = "Camera",
	triggerbot = false, triggerDelay = 0, silentAim = false,
	hitboxExpander = false, hitboxSize = 10,
	antiAim = false, killAura = false,

	espHighlight = false, espBox = false, espTracer = false, espSkeleton = false,
	espName = false, espDistance = false, espHealthBar = false, espHeadDot = false, espSnaplines = false,
	fovCircle = false, fovCircleColor = "Red", fullbright = false,
	espBoxColor = "Red", espTracerColor = "Red", espSkeletonColor = "White",
	espNameColor = "White", espDistanceColor = "Cyan", espHealthBarColor = "Green",
	espHeadDotColor = "Yellow", espSnaplinesColor = "Purple",
	chams = false, chamsColor = "Red", worldFOV = 70, timeOfDay = "Normal",
	thirdPerson = false, thirdPersonDist = 10,

	noRecoil = false, noSpread = false, infAmmo = false, rapidFire = false, dmgMult = 1, wallbang = false,

	speed = false, speedVal = 50, superJump = false, fly = false, noclip = false, godMode = false,
	spinbot = false, spinbotSpeed = 30, vehicleFly = false, autoBhop = false, spider = false,
	antiAfk = false, noFog = false, brightness = 2, gravityVal = 196.2, timescale = 1,

	mobileBtn = true,
	fovCircleObj = nil, flyBV = nil, flyBG = nil, vFlyBV = nil, vFlyBG = nil, espHighlighs = {},
	aimbotTarget = nil, espObjects = {},
}

local colorMap = {
	["Red"] = Color3.fromRGB(255, 40, 40), ["Green"] = Color3.fromRGB(40, 255, 40),
	["Blue"] = Color3.fromRGB(40, 120, 255), ["White"] = Color3.fromRGB(255, 255, 255),
	["Yellow"] = Color3.fromRGB(255, 220, 40), ["Purple"] = Color3.fromRGB(160, 50, 255),
	["Cyan"] = Color3.fromRGB(40, 200, 220), ["Orange"] = Color3.fromRGB(255, 150, 40),
}
local colorNames = {"Red", "Green", "Blue", "White", "Yellow", "Purple", "Cyan", "Orange"}

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

pcall(function()
	local pg = player:FindFirstChildOfClass("PlayerGui")
	if pg then
		local old = pg:FindFirstChild("MagnataMenuRemastered")
		if old then old:Destroy() end
	end
end)

local gui = make("ScreenGui", {
	Name = "MagnataMenuRemastered", ResetOnSpawn = false, DisplayOrder = 9999,
	ZIndexBehavior = Enum.ZIndexBehavior.Global, IgnoreGuiInset = true,
	Parent = player:WaitForChild("PlayerGui")
})
local espContainer = make("Folder", { Name = "ESP_Drawings", Parent = gui })

local splashFrame = make("Frame", {
	Size = UDim2.new(0, 400, 0, 200), Position = UDim2.new(0.5, -200, 0.5, -100),
	BackgroundColor3 = C.panelBg, BorderSizePixel = 0, Parent = gui
})
make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = splashFrame })
local splashStroke = make("UIStroke", { Thickness = 2, Color = C.accent, Transparency = 1, Parent = splashFrame })
make("UIGradient", {
	Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 15, 15)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 42))
	}, Parent = splashFrame
})
local splashTitle = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 30),
	BackgroundTransparency = 1, Text = "GHOST MENU", Font = Enum.Font.GothamBlack,
	TextColor3 = C.white, TextSize = 32, TextTransparency = 1, Parent = splashFrame
})
local splashVersion = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 72),
	BackgroundTransparency = 1, Text = "V9 PROFESSIONAL", Font = Enum.Font.GothamBold,
	TextColor3 = C.textWhite, TextSize = 14, TextTransparency = 1, Parent = splashFrame
})
local splashBarBg = make("Frame", {
	Size = UDim2.new(0, 300, 0, 4), Position = UDim2.new(0.5, -150, 0, 110),
	BackgroundColor3 = C.trackBg, BorderSizePixel = 0, Parent = splashFrame
})
make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = splashBarBg })
local splashBarFill = make("Frame", {
	Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = C.accent, BorderSizePixel = 0, Parent = splashBarBg
})
make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = splashBarFill })
local splashStatus = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 0, 125),
	BackgroundTransparency = 1, Text = "Carregando...", Font = Enum.Font.Gotham,
	TextColor3 = C.textSec, TextSize = 12, TextTransparency = 1, Parent = splashFrame
})
local splashBy = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 0, 170),
	BackgroundTransparency = 1, Text = "by Magnata", Font = Enum.Font.Gotham,
	TextColor3 = C.textSec, TextSize = 11, TextTransparency = 1, Parent = splashFrame
})

task.spawn(function()
	TweenService:Create(splashStroke, TweenInfo.new(0.5), { Transparency = 0 }):Play()
	TweenService:Create(splashTitle, TweenInfo.new(0.6), { TextTransparency = 0 }):Play()
	task.wait(0.3)
	TweenService:Create(splashVersion, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
	TweenService:Create(splashBy, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
	TweenService:Create(splashStatus, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
	task.wait(0.5)
	local stages = {"Inicializando modulos...", "Carregando bypass...", "Preparando ESP...", "Configurando UI...", "Ativando cheats...", "Pronto!"}
	for i, stage in ipairs(stages) do
		splashStatus.Text = stage
		local progress = i / #stages
		TweenService:Create(splashBarFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), { Size = UDim2.new(progress, 0, 1, 0) }):Play()
		task.wait(0.35)
	end
	task.wait(0.3)
	TweenService:Create(splashFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(splashStroke, TweenInfo.new(0.5), { Transparency = 1 }):Play()
	TweenService:Create(splashTitle, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
	TweenService:Create(splashVersion, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
	TweenService:Create(splashStatus, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
	TweenService:Create(splashBy, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
	task.wait(0.5)
	splashFrame:Destroy()
end)

local notifContainer = make("Frame", {
	Size = UDim2.new(0, 280, 1, -20), Position = UDim2.new(1, -300, 0, 10),
	BackgroundTransparency = 1, Parent = gui
})
make("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6),
	VerticalAlignment = Enum.VerticalAlignment.Bottom, Parent = notifContainer
})

local notifColors = {
	INFO = C.blue, SUCCESS = C.success, WARNING = C.yellow, ERROR = C.danger, FEATURE = C.purple,
}

local function notify(titleStr, textStr, duration, notifType)
	local dur = duration or 3
	local nType = notifType or "INFO"
	local accentCol = notifColors[nType] or C.accent
	local n = make("Frame", {
		Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = Color3.fromRGB(40, 40, 48),
		BackgroundTransparency = 1, Parent = notifContainer
	})
	make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = n })
	local stroke = make("UIStroke", { Thickness = 1, Color = accentCol, Transparency = 1, Parent = n })
	local accent = make("Frame", {
		Size = UDim2.new(0, 3, 1, -8), Position = UDim2.new(0, 6, 0, 4),
		BackgroundColor3 = accentCol, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = n
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = accent })
	local typeLabel = make("TextLabel", {
		Size = UDim2.new(0, 50, 0, 14), Position = UDim2.new(0, 16, 0, 6),
		BackgroundTransparency = 1, Text = nType, Font = Enum.Font.GothamBold,
		TextColor3 = accentCol, TextSize = 9, TextTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = n
	})
	local t = make("TextLabel", {
		Size = UDim2.new(1, -24, 0, 18), Position = UDim2.new(0, 16, 0, 18),
		BackgroundTransparency = 1, Text = titleStr, Font = Enum.Font.GothamBold,
		TextColor3 = C.white, TextTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = n
	})
	local d = make("TextLabel", {
		Size = UDim2.new(1, -24, 0, 14), Position = UDim2.new(0, 16, 0, 36),
		BackgroundTransparency = 1, Text = textStr, Font = Enum.Font.Gotham,
		TextColor3 = C.textSec, TextTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = n
	})

	TweenService:Create(n, TweenInfo.new(0.25), { BackgroundTransparency = 0 }):Play()
	TweenService:Create(stroke, TweenInfo.new(0.25), { Transparency = 0.6 }):Play()
	TweenService:Create(accent, TweenInfo.new(0.25), { BackgroundTransparency = 0 }):Play()
	TweenService:Create(typeLabel, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
	TweenService:Create(t, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
	TweenService:Create(d, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()

	task.delay(dur, function()
		TweenService:Create(n, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
		TweenService:Create(stroke, TweenInfo.new(0.3), { Transparency = 1 }):Play()
		TweenService:Create(accent, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
		TweenService:Create(typeLabel, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
		TweenService:Create(t, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
		TweenService:Create(d, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
		task.wait(0.3); n:Destroy()
	end)
end

local main = make("Frame", {
	Size = UDim2.new(0, 900, 0, 560), Position = UDim2.new(0.5, -450, 0.5, -280),
	BackgroundColor3 = C.panelBg, BorderSizePixel = 0, Visible = false, Parent = gui
})
make("UICorner", { CornerRadius = UDim.new(0, 10), Parent = main })
local mainStroke = make("UIStroke", { Thickness = 1, Color = C.border, Parent = main })
make("UIGradient", {
	Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 32, 38)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 28, 34))
	}, Parent = main
})

local title = make("Frame", {
	Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = C.sidebarBg,
	BorderSizePixel = 0, Parent = main
})
make("UICorner", { CornerRadius = UDim.new(0, 10), Parent = title })
local titleGradient = make("Frame", {
	Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -1),
	BackgroundColor3 = C.accent, BorderSizePixel = 0, Parent = title
})
local titleLabel = make("TextLabel", {
	Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0),
	BackgroundTransparency = 1, Text = "GHOST MENU V9", Font = Enum.Font.GothamBlack,
	TextSize = 16, TextColor3 = C.white, TextXAlignment = Enum.TextXAlignment.Left, Parent = title
})
local versionBadge = make("TextLabel", {
	Size = UDim2.new(0, 70, 0, 20), Position = UDim2.new(0, 140, 0.5, -10),
	BackgroundColor3 = C.accentSoft, BorderSizePixel = 0, Text = "PRO", Font = Enum.Font.GothamBold,
	TextSize = 10, TextColor3 = C.white, Parent = title
})
make("UICorner", { CornerRadius = UDim.new(0, 4), Parent = versionBadge })
local titleRight = make("TextLabel", {
	Size = UDim2.new(0.5, -12, 1, 0), Position = UDim2.new(0.5, 0, 0, 0),
	BackgroundTransparency = 1, Text = "by Magnata", Font = Enum.Font.Gotham,
	TextSize = 11, TextColor3 = C.textSec, TextXAlignment = Enum.TextXAlignment.Right, Parent = title
})
local closeBtn = make("TextButton", {
	Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -40, 0, 4),
	BackgroundColor3 = Color3.fromRGB(50, 30, 30), BorderSizePixel = 0,
	Text = "X", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.white, Parent = title
})
make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = closeBtn })
closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundColor3 = C.danger, TextColor3 = C.white }):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(50, 30, 30), TextColor3 = C.white }):Play()
end)
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

local minimizeBtn = make("TextButton", {
	Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -76, 0, 4),
	BackgroundColor3 = Color3.fromRGB(35, 35, 42), BorderSizePixel = 0,
	Text = "-", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = C.white, Parent = title
})
make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = minimizeBtn })

local sidebar = make("Frame", {
	Size = UDim2.new(0, 68, 1, -38), Position = UDim2.new(0, 0, 0, 38),
	BackgroundColor3 = C.sidebarBg, BorderSizePixel = 0, Parent = main
})
make("UICorner", { CornerRadius = UDim.new(0, 10), Parent = sidebar })
make("UIStroke", { Thickness = 1, Color = C.border, Transparency = 0.5, Parent = sidebar })

local contentArea = make("Frame", {
	Size = UDim2.new(1, -68, 1, -38), Position = UDim2.new(0, 68, 0, 38),
	BackgroundColor3 = C.panelBg, BorderSizePixel = 0, Parent = main
})
make("UICorner", { CornerRadius = UDim.new(0, 0), Parent = contentArea })

local panels = {}
local sidebarBtns = {}
local currentTab = "Combat"

local function createSidebarBtn(icon, label, tabName, yPos, callback)
	local btn = make("TextButton", {
		Size = UDim2.new(1, -6, 0, 48), Position = UDim2.new(0, 3, 0, yPos),
		BackgroundColor3 = C.sidebarBg, BorderSizePixel = 0, Text = "", Parent = sidebar
	})
	make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btn })
	local iconLbl = make("TextLabel", {
		Size = UDim2.new(1, 0, 0, 18), Position = UDim2.new(0, 0, 0, 4),
		BackgroundTransparency = 1, Text = icon, Font = Enum.Font.GothamBold,
		TextSize = 13, TextColor3 = C.iconDim, TextTruncate = Enum.TextTruncate.AtEnd, Parent = btn
	})
	local textLbl = make("TextLabel", {
		Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, 24),
		BackgroundTransparency = 1, Text = label, Font = Enum.Font.GothamBold,
		TextSize = 9, TextColor3 = C.textMuted, TextTruncate = Enum.TextTruncate.AtEnd, Parent = btn
	})
	local indicator = make("Frame", {
		Size = UDim2.new(0, 2, 0, 0), Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = C.accent,
		BorderSizePixel = 0, BackgroundTransparency = 1, Parent = btn
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = indicator })

	sidebarBtns[tabName] = { btn = btn, icon = iconLbl, text = textLbl, indicator = indicator }

	btn.MouseEnter:Connect(function()
		if currentTab ~= tabName then
			TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = C.sidebarHover }):Play()
			TweenService:Create(iconLbl, TweenInfo.new(0.2), { TextColor3 = C.textWhite }):Play()
		end
	end)
	btn.MouseLeave:Connect(function()
		if currentTab ~= tabName then
			TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = C.sidebarBg }):Play()
			TweenService:Create(iconLbl, TweenInfo.new(0.2), { TextColor3 = C.iconDim }):Play()
		end
	end)
	btn.MouseButton1Click:Connect(function()
		callback()
	end)
end

local function switchTab(tabName)
	currentTab = tabName
	for name, data in pairs(sidebarBtns) do
		if name == tabName then
			TweenService:Create(data.btn, TweenInfo.new(0.2), { BackgroundColor3 = C.cardActive }):Play()
			TweenService:Create(data.icon, TweenInfo.new(0.2), { TextColor3 = C.accent }):Play()
			TweenService:Create(data.text, TweenInfo.new(0.2), { TextColor3 = C.textLight }):Play()
			TweenService:Create(data.indicator, TweenInfo.new(0.2), { BackgroundTransparency = 0, Size = UDim2.new(0, 2, 0, 20) }):Play()
		else
			TweenService:Create(data.btn, TweenInfo.new(0.2), { BackgroundColor3 = C.sidebarBg }):Play()
			TweenService:Create(data.icon, TweenInfo.new(0.2), { TextColor3 = C.iconDim }):Play()
			TweenService:Create(data.text, TweenInfo.new(0.2), { TextColor3 = C.textMuted }):Play()
			TweenService:Create(data.indicator, TweenInfo.new(0.2), { BackgroundTransparency = 1, Size = UDim2.new(0, 2, 0, 0) }):Play()
		end
	end
	for name, panel in pairs(panels) do
		if name == tabName then
			panel.Visible = true
			panel.BackgroundTransparency = 1
			TweenService:Create(panel, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
		else
			panel.Visible = false
		end
	end
end

local tabY = 8
createSidebarBtn("COMBAT", "", "Combat", tabY, function() switchTab("Combat") end); tabY = tabY + 52
createSidebarBtn("VISUALS", "", "Visuals", tabY, function() switchTab("Visuals") end); tabY = tabY + 52
createSidebarBtn("MOVEMENT", "", "Movement", tabY, function() switchTab("Movement") end); tabY = tabY + 52
createSidebarBtn("WORLD", "", "World", tabY, function() switchTab("World") end); tabY = tabY + 52
createSidebarBtn("SETTINGS", "", "Settings", tabY, function() switchTab("Settings") end)

local function createTabPanel(name)
	local panel = make("ScrollingFrame", {
		Size = UDim2.new(1, -8, 1, -8), Position = UDim2.new(0, 4, 0, 4),
		BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
		ScrollBarImageColor3 = C.accent, AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0), Visible = false, Parent = contentArea
	})
	make("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3), Parent = panel })
	make("UIPadding", {
		PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 12),
		PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = panel
	})
	panels[name] = panel
	return panel
end

local function createSectionHeader(parent, text, order)
	local f = make("Frame", {
		Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1,
		LayoutOrder = order or 0, Parent = parent
	})
	make("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
		Text = "  " .. text, Font = Enum.Font.GothamBold, TextSize = 12,
		TextColor3 = C.white, TextXAlignment = Enum.TextXAlignment.Left, Parent = f
	})
	local line = make("Frame", {
		Size = UDim2.new(1, -10, 0, 1), Position = UDim2.new(0, 5, 1, -2),
		BackgroundColor3 = C.accent, BorderSizePixel = 0, Transparency = 0.5, Parent = f
	})
	return f
end

local orderCounter = 0
local function nextOrder()
	orderCounter = orderCounter + 1
	return orderCounter
end

local function createCheckbox(parent, labelText, default, callback)
	local checked = default
	local f = make("Frame", {
		Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = C.cardBg,
		BorderSizePixel = 0, LayoutOrder = nextOrder(), Parent = parent
	})
	make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = f })
	make("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = f })
	make("TextLabel", {
		Size = UDim2.new(1, -40, 1, 0), BackgroundTransparency = 1,
		Text = labelText, Font = Enum.Font.Gotham, TextSize = 14,
		TextColor3 = C.textWhite, TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd, Parent = f
	})
	local box = make("TextButton", {
		Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -32, 0.5, -12),
		BackgroundColor3 = checked and C.accent or C.trackBg, BorderSizePixel = 0,
		Text = "", Parent = f
	})
	make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = box })
	make("UIStroke", { Thickness = 1.5, Color = checked and C.accent or C.borderLight, Parent = box })
	local checkMark = make("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
		Text = checked and "✓" or "", Font = Enum.Font.GothamBold, TextSize = 16,
		TextColor3 = C.white, Parent = box
	})

	f.MouseEnter:Connect(function()
		TweenService:Create(f, TweenInfo.new(0.15), { BackgroundColor3 = C.cardHover }):Play()
	end)
	f.MouseLeave:Connect(function()
		TweenService:Create(f, TweenInfo.new(0.15), { BackgroundColor3 = C.cardBg }):Play()
	end)

	box.MouseButton1Click:Connect(function()
		checked = not checked
		local col = checked and C.accent or C.trackBg
		local strk = checked and C.accent or C.border
		TweenService:Create(box, TweenInfo.new(0.15), { BackgroundColor3 = col }):Play()
		TweenService:Create(box:FindFirstChildOfClass("UIStroke") or box, TweenInfo.new(0.15), { Color = strk }):Play()
		checkMark.Text = checked and "✓" or ""
		if checked then
			notify("ATIVADO", labelText, 2, "SUCCESS")
		else
			notify("DESATIVADO", labelText, 2, "WARNING")
		end
		if callback then callback(checked) end
	end)

	if default then
		if callback then callback(true) end
	end
end

local function createCycleButton(parent, labelText, options, default, callback)
	local idx = 1
	for i, v in ipairs(options) do if v == default then idx = i break end end
	local f = make("Frame", {
		Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = C.cardBg,
		BorderSizePixel = 0, LayoutOrder = nextOrder(), Parent = parent
	})
	make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = f })
	make("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = f })
	make("TextLabel", {
		Size = UDim2.new(1, -145, 1, 0), BackgroundTransparency = 1,
		Text = labelText, Font = Enum.Font.Gotham, TextSize = 14,
		TextColor3 = C.textWhite, TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd, Parent = f
	})
	local btn = make("TextButton", {
		Size = UDim2.new(0, 135, 0, 26), Position = UDim2.new(1, -135, 0.5, -13),
		BackgroundColor3 = C.trackBg, Text = "  " .. options[idx] .. "  ",
		Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.accent, Parent = f
	})
	make("UICorner", { CornerRadius = UDim.new(0, 5), Parent = btn })
	make("UIStroke", { Thickness = 1.5, Color = C.borderLight, Parent = btn })

	f.MouseEnter:Connect(function()
		TweenService:Create(f, TweenInfo.new(0.15), { BackgroundColor3 = C.cardHover }):Play()
	end)
	f.MouseLeave:Connect(function()
		TweenService:Create(f, TweenInfo.new(0.15), { BackgroundColor3 = C.cardBg }):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		idx = (idx % #options) + 1
		btn.Text = "  " .. options[idx] .. "  "
		TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = C.accentSoft }):Play()
		task.wait(0.1)
		TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = C.trackBg }):Play()
		if callback then callback(options[idx]) end
	end)
end

local function createSlider(parent, labelText, min, max, default, callback)
	local val = default
	local f = make("Frame", {
		Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = C.cardBg,
		BorderSizePixel = 0, LayoutOrder = nextOrder(), Parent = parent
	})
	make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = f })
	make("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = f })
	make("TextLabel", {
		Size = UDim2.new(1, -55, 0, 22), BackgroundTransparency = 1,
		Text = labelText, Font = Enum.Font.Gotham, TextSize = 14,
		TextColor3 = C.textWhite, TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd, Parent = f
	})
	local valLbl = make("TextLabel", {
		Size = UDim2.new(0, 40, 0, 22), Position = UDim2.new(1, -48, 0, 0),
		BackgroundTransparency = 1, Text = tostring(val), Font = Enum.Font.GothamBold,
		TextSize = 13, TextColor3 = C.accent, TextXAlignment = Enum.TextXAlignment.Right, Parent = f
	})
	local track = make("Frame", {
		Size = UDim2.new(1, -16, 0, 8), Position = UDim2.new(0, 8, 0, 32),
		BackgroundColor3 = C.trackBg, BorderSizePixel = 0, Parent = f
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })
	local pct = (val - min) / (max - min)
	local fill = make("Frame", {
		Size = UDim2.new(pct, 0, 1, 0), BackgroundColor3 = C.accent, BorderSizePixel = 0, Parent = track
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })
	local thumb = make("Frame", {
		Size = UDim2.new(0, 14, 0, 14), AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(pct, 0, 0.5, 0), BackgroundColor3 = C.white,
		BorderSizePixel = 0, Parent = track
	})
	make("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = thumb })
	make("UIStroke", { Thickness = 1, Color = C.accent, Parent = thumb })
	local btn = make("TextButton", {
		Size = UDim2.new(1, 0, 1, 14), Position = UDim2.new(0, 0, 0, -7),
		BackgroundTransparency = 1, Text = "", Parent = track
	})
	local dragging = false
	btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
	btn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local p2 = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			val = math.floor(min + p2 * (max - min))
			fill.Size = UDim2.new(p2, 0, 1, 0)
			thumb.Position = UDim2.new(p2, 0, 0.5, 0)
			valLbl.Text = tostring(val)
			if callback then callback(val) end
		end
	end)

	f.MouseEnter:Connect(function()
		TweenService:Create(f, TweenInfo.new(0.15), { BackgroundColor3 = C.cardHover }):Play()
	end)
	f.MouseLeave:Connect(function()
		TweenService:Create(f, TweenInfo.new(0.15), { BackgroundColor3 = C.cardBg }):Play()
	end)
end

local function createButton(parent, labelText, callback)
	local f = make("Frame", {
		Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1,
		LayoutOrder = nextOrder(), Parent = parent
	})
	local btn = make("TextButton", {
		Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 3),
		BackgroundColor3 = C.cardBg, Text = "  " .. labelText,
		Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.accent,
		TextXAlignment = Enum.TextXAlignment.Left, Parent = f
	})
	make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
	make("UIStroke", { Thickness = 1, Color = C.border, Parent = btn })
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = C.cardHover }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = C.cardBg }):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = C.accent, TextColor3 = C.white }):Play()
		task.wait(0.1)
		TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = C.cardBg, TextColor3 = C.accent }):Play()
		if callback then callback() end
	end)
end

local espCache = {}
local r15conns = { {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"}, {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"}, {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"}, {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"} }
local r6conns = { {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"} }

local function getLine()
	return make("Frame", {
		BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = 1, Visible = false, Parent = espContainer
	})
end

local function drawLine(line, p1, p2, thickness)
	local dist = (p2 - p1).Magnitude
	line.Size = UDim2.new(0, dist, 0, thickness)
	line.Position = UDim2.new(0, (p1.X + p2.X) / 2, 0, (p1.Y + p2.Y) / 2)
	line.Rotation = math.deg(math.atan2(p2.Y - p1.Y, p2.X - p1.X))
end

local function getEspCache(p)
	if not espCache[p] then
		local c = {
			box = {getLine(), getLine(), getLine(), getLine()},
			tracer = getLine(),
			snapline = getLine(),
			name = make("TextLabel", {
				BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 13,
				TextColor3 = Color3.new(1,1,1), TextStrokeTransparency = 0,
				AnchorPoint = Vector2.new(0.5, 1), ZIndex = 2, Visible = false, Parent = espContainer
			}),
			distance = make("TextLabel", {
				BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 11,
				TextColor3 = Color3.new(1,1,1), TextStrokeTransparency = 0,
				AnchorPoint = Vector2.new(0.5, 0), ZIndex = 2, Visible = false, Parent = espContainer
			}),
			headCircle = make("Frame", {
				BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5),
				ZIndex = 1, Visible = false, Parent = espContainer
			}),
			healthBarBg = make("Frame", {
				BackgroundColor3 = C.trackBg, BorderSizePixel = 0, ZIndex = 1, Visible = false, Parent = espContainer
			}),
			healthBarFill = make("Frame", {
				BackgroundColor3 = C.success, BorderSizePixel = 0, ZIndex = 2, Visible = false, Parent = espContainer
			}),
			skeleton = {},
		}
		make("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = c.headCircle })
		make("UIStroke", { Name = "Stroke", Thickness = 1.5, Parent = c.headCircle })
		for i = 1, 15 do table.insert(c.skeleton, getLine()) end
		espCache[p] = c
	end
	return espCache[p]
end

local function hideEsp(cache)
	for _, l in ipairs(cache.box) do l.Visible = false end
	cache.tracer.Visible = false
	cache.snapline.Visible = false
	cache.name.Visible = false
	cache.distance.Visible = false
	for _, l in ipairs(cache.skeleton) do l.Visible = false end
	if cache.headCircle then cache.headCircle.Visible = false end
	cache.healthBarBg.Visible = false
	cache.healthBarFill.Visible = false
end

local function updateEsp(p)
	local cache = getEspCache(p)
	local char = p.Character
	if not char or not char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("Humanoid").Health <= 0 then
		hideEsp(cache); return
	end
	local head = char:FindFirstChild("Head")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not head or not root then hideEsp(cache); return end

	local topPos, topVis = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
	local botPos, botVis = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
	local rootPos, rootVis = camera:WorldToViewportPoint(root.Position)

	if not topVis or not botVis then hideEsp(cache); return end

	local h = botPos.Y - topPos.Y
	local w = h / 2
	local x = topPos.X - w / 2
	local y = topPos.Y

	if S.espBox then
		local cBox = colorMap[S.espBoxColor]
		local b = cache.box
		b[1].Size = UDim2.new(0, 1, 0, h); b[1].Position = UDim2.new(0, x, 0, y + h/2)
		b[1].Rotation = 0; b[1].Visible = true; b[1].BackgroundColor3 = cBox
		b[2].Size = UDim2.new(0, 1, 0, h); b[2].Position = UDim2.new(0, x + w, 0, y + h/2)
		b[2].Rotation = 0; b[2].Visible = true; b[2].BackgroundColor3 = cBox
		b[3].Size = UDim2.new(0, w, 0, 1); b[3].Position = UDim2.new(0, x + w/2, 0, y)
		b[3].Rotation = 0; b[3].Visible = true; b[3].BackgroundColor3 = cBox
		b[4].Size = UDim2.new(0, w, 0, 1); b[4].Position = UDim2.new(0, x + w/2, 0, y + h)
		b[4].Rotation = 0; b[4].Visible = true; b[4].BackgroundColor3 = cBox
	else
		for _, l in ipairs(cache.box) do l.Visible = false end
	end

	if S.espTracer then
		drawLine(cache.tracer, Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y), Vector2.new(rootPos.X, rootPos.Y), 1.5)
		cache.tracer.BackgroundColor3 = colorMap[S.espTracerColor]; cache.tracer.Visible = true
	else
		cache.tracer.Visible = false
	end

	if S.espSnaplines then
		drawLine(cache.snapline, Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2), Vector2.new(rootPos.X, rootPos.Y), 1)
		cache.snapline.BackgroundColor3 = colorMap[S.espSnaplinesColor]
		cache.snapline.Transparency = 0.5
		cache.snapline.Visible = true
	else
		cache.snapline.Visible = false
	end

	if S.espName then
		local hp = math.floor(char:FindFirstChildOfClass("Humanoid").Health)
		cache.name.Text = string.format("%s [%d HP]", p.Name, hp)
		cache.name.Position = UDim2.new(0, x + w/2, 0, y - 20)
		cache.name.TextColor3 = colorMap[S.espNameColor]
		cache.name.Visible = true
	else
		cache.name.Visible = false
	end

	if S.espDistance and rootVis then
		local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if myRoot then
			local dist = math.floor((myRoot.Position - root.Position).Magnitude)
			cache.distance.Text = string.format("[%dm]", dist)
			cache.distance.Position = UDim2.new(0, x + w/2, 0, y + h + 4)
			cache.distance.TextColor3 = colorMap[S.espDistanceColor]
			cache.distance.Visible = true
		end
	else
		cache.distance.Visible = false
	end

	if S.espHealthBar then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
			local barH = h
			local barW = 3
			local barX = x - 8
			local barY = y
			cache.healthBarBg.Size = UDim2.new(0, barW, 0, barH)
			cache.healthBarBg.Position = UDim2.new(0, barX, 0, barY)
			cache.healthBarBg.Visible = true
			cache.healthBarFill.Size = UDim2.new(0, barW, 0, barH * hpPct)
			cache.healthBarFill.Position = UDim2.new(0, barX, 0, barY + barH * (1 - hpPct))
			if hpPct > 0.5 then
				cache.healthBarFill.BackgroundColor3 = C.success
			elseif hpPct > 0.25 then
				cache.healthBarFill.BackgroundColor3 = C.yellow
			else
				cache.healthBarFill.BackgroundColor3 = C.danger
			end
			cache.healthBarFill.Visible = true
		end
	else
		cache.healthBarBg.Visible = false
		cache.healthBarFill.Visible = false
	end

	local lineIdx = 1
	if S.espSkeleton then
		local cSkel = colorMap[S.espSkeletonColor]
		local conns = (char:FindFirstChild("UpperTorso")) and r15conns or r6conns
		for _, c in ipairs(conns) do
			local p1 = char:FindFirstChild(c[1])
			local p2 = char:FindFirstChild(c[2])
			if p1 and p2 then
				local p1Pos, v1 = camera:WorldToViewportPoint(p1.Position)
				local p2Pos, v2 = camera:WorldToViewportPoint(p2.Position)
				if v1 and v2 then
					local line = cache.skeleton[lineIdx]
					if line then
						drawLine(line, Vector2.new(p1Pos.X, p1Pos.Y), Vector2.new(p2Pos.X, p2Pos.Y), 1.5)
						line.BackgroundColor3 = cSkel; line.Visible = true; lineIdx = lineIdx + 1
					end
				end
			end
		end
		local headPos, headVis = camera:WorldToViewportPoint(head.Position)
		if headVis then
			local headTopPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.6, 0))
			local radius = math.abs(headPos.Y - headTopPos.Y) * 2
			cache.headCircle.Position = UDim2.new(0, headPos.X, 0, headPos.Y)
			cache.headCircle.Size = UDim2.new(0, radius, 0, radius)
			cache.headCircle.Stroke.Color = cSkel
			cache.headCircle.Visible = true
		else
			cache.headCircle.Visible = false
		end
	else
		if cache.headCircle then cache.headCircle.Visible = false end
	end
	for i = lineIdx, #cache.skeleton do cache.skeleton[i].Visible = false end
end

local function refreshHighlightESP()
	for _, o in pairs(S.espHighlighs) do if o and o.Parent then o:Destroy() end end
	S.espHighlighs = {}
	if not S.espHighlight then return end
	for _, p in ipairs(Players:GetPlayers()) do
		if isValidTarget(p) and p.Character then
			table.insert(S.espHighlighs, make("Highlight", {
				FillColor = C.danger, FillTransparency = 0.5,
				OutlineColor = C.white, OutlineTransparency = 0.3,
				Parent = p.Character
			}))
		end
	end
end

local function applyChams(char, enabled)
	if not char then return end
	for _, p in ipairs(char:GetDescendants()) do
		if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
			if enabled then
				if not p:FindFirstChild("OriginalMat") then
					make("StringValue", { Name = "OriginalMat", Value = tostring(p.Material), Parent = p })
					make("Color3Value", { Name = "OriginalCol", Value = p.Color, Parent = p })
				end
				p.Material = Enum.Material.ForceField
				p.Color = colorMap[S.chamsColor] or Color3.new(1,0,0)
			else
				if p:FindFirstChild("OriginalMat") then
					p.Material = Enum.Material[string.split(p.OriginalMat.Value, ".")[3]] or Enum.Material.Plastic
					p.Color = p.OriginalCol.Value
					p.OriginalMat:Destroy()
					p.OriginalCol:Destroy()
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
		frames = 0; lastTick = tick()
		local mw = math.clamp(watermark.TextBounds.X + 20, 200, 400)
		TweenService:Create(watermark, TweenInfo.new(0.5), { Size = UDim2.new(0, mw, 0, 24) }):Play()
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if isValidTarget(p) then
			if (S.espBox or S.espTracer or S.espSkeleton or S.espName or S.espDistance or S.espHealthBar or S.espHeadDot or S.espSnaplines) then
				updateEsp(p)
			elseif espCache[p] then
				hideEsp(espCache[p])
			end
		else
			if espCache[p] then hideEsp(espCache[p]) end
		end
	end
end)

local function getChar() return player.Character or player.CharacterAdded:Wait() end
local function getRoot()
	local c = getChar()
	return c and c:FindFirstChild("HumanoidRootPart")
end

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
			if S.rapidFire and (n:find("fire") or n:find("rate") or n:find("delay")) then
				if v:IsA("NumberValue") or v:IsA("IntValue") then v.Value = 0 end
			end
			if S.dmgMult > 1 and (n:find("damage") or n:find("dmg")) then
				if v:IsA("NumberValue") or v:IsA("IntValue") then v.Value = v.Value * S.dmgMult end
			end
		end
	end
end

player.CharacterAdded:Connect(function(char)
	char.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then task.wait(0.1); hookWeapon(child) end
	end)
end)

RunService.Heartbeat:Connect(function()
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local rp = char:FindFirstChild("HumanoidRootPart")

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local targetHRP = p.Character:FindFirstChild("HumanoidRootPart")
			if targetHRP then
				if S.hitboxExpander and isValidTarget(p) then
					targetHRP.Size = Vector3.new(S.hitboxSize, S.hitboxSize, S.hitboxSize)
					targetHRP.Transparency = 0.7
					targetHRP.CanCollide = false
				else
					targetHRP.Size = Vector3.new(2, 2, 1)
					targetHRP.Transparency = 1
					targetHRP.CanCollide = true
				end
			end
		end
	end

	if hum then
		if S.speed then hum.WalkSpeed = S.speedVal end
		if S.superJump then hum.JumpPower = 120; hum.UseJumpPower = true end
		if S.godMode then hum.Health = hum.MaxHealth end
		if S.autoBhop and UIS:IsKeyDown(Enum.KeyCode.Space) then
			if hum.FloorMaterial ~= Enum.Material.Air then
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end

	if S.noclip then
		for _, p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide = false end
		end
	end

	if S.spider and rp then
		local hrpLook = rp.CFrame.LookVector
		local ray = Ray.new(rp.Position, hrpLook * 3)
		local hit, pos = WS:FindPartOnRayWithIgnoreList(ray, {char})
		if hit then
			if not S.flyBV then
				S.flyBV = make("BodyVelocity", { MaxForce = Vector3.new(1e6,1e6,1e6), Velocity = Vector3.new(0, 50, 0), Parent = rp })
			end
		else
			if S.flyBV and not S.fly then S.flyBV:Destroy(); S.flyBV = nil end
		end
	end

	if S.spinbot and rp then
		rp.CFrame = rp.CFrame * CFrame.Angles(0, math.rad(S.spinbotSpeed), 0)
	end
	if S.antiAim and rp then
		rp.CFrame = rp.CFrame * CFrame.Angles(
			math.rad(math.random(-45, 45)),
			math.rad(math.random(-180, 180)),
			math.rad(math.random(-45, 45))
		)
	end

	if S.killAura and rp then
		for _, p in ipairs(Players:GetPlayers()) do
			if isValidTarget(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local d = (p.Character.HumanoidRootPart.Position - rp.Position).Magnitude
				if d < 15 then
					firetouchinterest(rp, p.Character.HumanoidRootPart, 0)
					firetouchinterest(rp, p.Character.HumanoidRootPart, 1)
				end
			end
		end
	end

	if S.worldFOV ~= 70 then camera.FieldOfView = S.worldFOV end
	if S.thirdPerson then
		player.CameraMaxZoomDistance = S.thirdPersonDist
		player.CameraMinZoomDistance = S.thirdPersonDist
	else
		player.CameraMaxZoomDistance = 400
		player.CameraMinZoomDistance = 0.5
	end

	if S.timeOfDay == "Dia" then Lighting.ClockTime = 14
	elseif S.timeOfDay == "Noite" then Lighting.ClockTime = 0
	end

	Lighting.Gravity = S.gravityVal

	if S.fly and S.flyBV and S.flyBG and rp then
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector end
		if dir.Magnitude > 0 then dir = dir.Unit end
		S.flyBV.Velocity = dir * S.speedVal
		S.flyBG.CFrame = camera.CFrame
	end

	if S.vehicleFly and hum and hum.SeatPart then
		local seat = hum.SeatPart
		if not S.vFlyBV then
			S.vFlyBV = make("BodyVelocity", { MaxForce = Vector3.new(1e6,1e6,1e6), Velocity = Vector3.zero, Parent = seat })
			S.vFlyBG = make("BodyGyro", { MaxTorque = Vector3.new(1e6,1e6,1e6), D = 200, P = 10000, Parent = seat })
		end
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector end
		if dir.Magnitude > 0 then dir = dir.Unit end
		S.vFlyBV.Velocity = dir * S.speedVal
		S.vFlyBG.CFrame = camera.CFrame
	else
		if S.vFlyBV then S.vFlyBV:Destroy(); S.vFlyBV = nil end
		if S.vFlyBG then S.vFlyBG:Destroy(); S.vFlyBG = nil end
	end

	if S.aimbot or S.silentAim then
		camera = WS.CurrentCamera
		local best, bd = nil, S.aimbotFOV
		local bestSP = nil
		local mLoc = UIS:GetMouseLocation()
		local camCF = camera.CFrame
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and isValidTarget(p) and p.Character then
				local part = p.Character:FindFirstChild(S.aimbotPart or "Head")
				local hum = p.Character:FindFirstChildOfClass("Humanoid")
				if part and hum and hum.Health > 0 then
					local sp, onScreen = camCF:WorldToViewportPoint(part.Position)
					if onScreen and sp.Z > 0 then
						local d = (Vector2.new(sp.X, sp.Y) - mLoc).Magnitude
						if d < bd then bd = d; best = part; bestSP = sp end
					end
				end
			end
		end
		S.aimbotTarget = best
		if S.aimbot and best and bestSP then
			if S.aimbotMethod == "Mouse" and mousemoverel then
				local smoothFactor = math.max(1, S.aimbotSmooth / 2)
				local moveX = (bestSP.X - mLoc.X) / smoothFactor
				local moveY = (bestSP.Y - mLoc.Y) / smoothFactor
				mousemoverel(moveX, moveY)
			else
				local alpha = math.clamp(S.aimbotSmooth / 20, 0.05, 1)
				pcall(function()
					camera.CFrame = CFrame.new(camera.CFrame.Position, best.Position):Lerp(camera.CFrame, 1 - alpha)
				end)
			end
		end

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
end)

RunService.RenderStepped:Connect(function()
	if S.fovCircle and S.fovCircleObj then
		local mLoc = UIS:GetMouseLocation()
		S.fovCircleObj.Position = UDim2.new(0, mLoc.X, 0, mLoc.Y)
		S.fovCircleObj.Size = UDim2.new(0, S.aimbotFOV * 2, 0, S.aimbotFOV * 2)
	end
end)

player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if S.speed then
		local h = char:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = S.speedVal end
	end
	if S.godMode then
		local h = char:FindFirstChildOfClass("Humanoid")
		if h then h.Health = 1e9; h.MaxHealth = 1e9 end
	end
	if S.espHighlight then refreshHighlightESP() end
end)

local sCombat = createTabPanel("Combat")
createSectionHeader(sCombat, "TARGET", 1)
createCycleButton(sCombat, "Target Selection", {"Todos", "Somente Inimigos"}, "Todos", function(v) S.targetTeam = v; refreshHighlightESP() end)
createCycleButton(sCombat, "Aimbot Part", {"Head", "HumanoidRootPart"}, "Head", function(v) S.aimbotPart = v end)
createCycleButton(sCombat, "Aimbot Method", {"Camera", "Mouse"}, "Camera", function(v) S.aimbotMethod = v end)

createSectionHeader(sCombat, "AIMBOT", 10)
createCheckbox(sCombat, "Aimbot", false, function(v) S.aimbot = v end)
createSlider(sCombat, "Aimbot FOV Range", 50, 500, 120, function(v)
	S.aimbotFOV = v
	if S.fovCircleObj then S.fovCircleObj.Size = UDim2.new(0, v*2, 0, v*2) end
end)
createSlider(sCombat, "Aimbot Smoothness", 1, 20, 8, function(v) S.aimbotSmooth = v end)
createCheckbox(sCombat, "Silent Aim (Magic Bullet)", false, function(v) S.silentAim = v end)

createSectionHeader(sCombat, "AUTO-FIRE", 30)
createCheckbox(sCombat, "Triggerbot", false, function(v) S.triggerbot = v end)
createSlider(sCombat, "Triggerbot Delay (ms)", 0, 1000, 0, function(v) S.triggerDelay = v end)

createSectionHeader(sCombat, "EXPLOITS", 40)
createCheckbox(sCombat, "Hitbox Expander", false, function(v) S.hitboxExpander = v end)
createSlider(sCombat, "Hitbox Size", 2, 30, 10, function(v) S.hitboxSize = v end)
createCheckbox(sCombat, "Anti-Aim (Jitter)", false, function(v) S.antiAim = v end)
createCheckbox(sCombat, "Kill Aura (Melee Fling)", false, function(v) S.killAura = v end)

createSectionHeader(sCombat, "WEAPON MODS", 50)
createCheckbox(sCombat, "Wallbang (Ignore Walls)", false, function(v) S.wallbang = v end)
createCheckbox(sCombat, "No Recoil", false, function(v) S.noRecoil = v end)
createCheckbox(sCombat, "No Spread", false, function(v) S.noSpread = v end)
createCheckbox(sCombat, "Infinite Ammo", false, function(v) S.infAmmo = v end)
createCheckbox(sCombat, "Rapid Fire", false, function(v) S.rapidFire = v end)
createSlider(sCombat, "Damage Multiplier", 1, 10, 1, function(v) S.dmgMult = v end)

local sVisuals = createTabPanel("Visuals")
createSectionHeader(sVisuals, "PLAYER ESP", 1)
createCheckbox(sVisuals, "ESP Box (Caixa)", false, function(v) S.espBox = v end)
createCycleButton(sVisuals, "Box Color", colorNames, "Red", function(v) S.espBoxColor = v end)
createCheckbox(sVisuals, "ESP Tracers (Linhas)", false, function(v) S.espTracer = v end)
createCycleButton(sVisuals, "Tracers Color", colorNames, "Red", function(v) S.espTracerColor = v end)
createCheckbox(sVisuals, "ESP Skeleton", false, function(v) S.espSkeleton = v end)
createCycleButton(sVisuals, "Skeleton Color", colorNames, "White", function(v) S.espSkeletonColor = v end)
createCheckbox(sVisuals, "ESP Name & HP", false, function(v) S.espName = v end)
createCycleButton(sVisuals, "Name & HP Color", colorNames, "White", function(v) S.espNameColor = v end)
createCheckbox(sVisuals, "ESP Distance", false, function(v) S.espDistance = v end)
createCycleButton(sVisuals, "Distance Color", colorNames, "Cyan", function(v) S.espDistanceColor = v end)
createCheckbox(sVisuals, "ESP Health Bar", false, function(v) S.espHealthBar = v end)
createCycleButton(sVisuals, "Health Bar Color", colorNames, "Green", function(v) S.espHealthBarColor = v end)
createCheckbox(sVisuals, "ESP Snaplines (Crosshair)", false, function(v) S.espSnaplines = v end)
createCycleButton(sVisuals, "Snaplines Color", colorNames, "Purple", function(v) S.espSnaplinesColor = v end)

createSectionHeader(sVisuals, "OVERLAYS", 20)
createCheckbox(sVisuals, "Player Highlight", false, function(v) S.espHighlight = v; refreshHighlightESP() end)
createCheckbox(sVisuals, "Chams (Material Hack)", false, function(v)
	S.chams = v
	for _, p in ipairs(Players:GetPlayers()) do
		if isValidTarget(p) then applyChams(p.Character, v) end
	end
end)
createCycleButton(sVisuals, "Chams Color", colorNames, "Red", function(v)
	S.chamsColor = v
	if S.chams then
		for _, p in ipairs(Players:GetPlayers()) do
			if isValidTarget(p) then applyChams(p.Character, true) end
		end
	end
end)

createSectionHeader(sVisuals, "AIMBOT VISUALS", 30)
createCheckbox(sVisuals, "Draw FOV Circle", false, function(v)
	S.fovCircle = v
	if v and not S.fovCircleObj then
		S.fovCircleObj = make("Frame", {
			Size = UDim2.new(0, S.aimbotFOV*2, 0, S.aimbotFOV*2),
			AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Parent = gui
		})
		make("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = S.fovCircleObj })
		make("UIStroke", { Name = "Stroke", Color = colorMap[S.fovCircleColor], Thickness = 1.5, Parent = S.fovCircleObj })
	end
	if S.fovCircleObj then S.fovCircleObj.Visible = v end
end)
createCycleButton(sVisuals, "FOV Circle Color", colorNames, "Red", function(v)
	S.fovCircleColor = v
	if S.fovCircleObj and S.fovCircleObj:FindFirstChild("Stroke") then
		S.fovCircleObj.Stroke.Color = colorMap[v]
	end
end)

createSectionHeader(sVisuals, "CAMERA", 40)
createSlider(sVisuals, "World FOV", 70, 120, 70, function(v) S.worldFOV = v end)
createCycleButton(sVisuals, "Time of Day", {"Normal", "Dia", "Noite"}, "Normal", function(v) S.timeOfDay = v end)
createCheckbox(sVisuals, "Third Person Mode", false, function(v) S.thirdPerson = v end)
createSlider(sVisuals, "3rd Person Distance", 5, 50, 10, function(v) S.thirdPersonDist = v end)

local sMovement = createTabPanel("Movement")
createSectionHeader(sMovement, "MOVEMENT", 1)
createCheckbox(sMovement, "Speed Hack", false, function(v) S.speed = v end)
createSlider(sMovement, "Movement Speed", 16, 200, 50, function(v) S.speedVal = v end)
createCheckbox(sMovement, "Super Jump", false, function(v) S.superJump = v end)
createCheckbox(sMovement, "Auto Bunny Hop", false, function(v) S.autoBhop = v end)
createCheckbox(sMovement, "Spider (Wallclimb)", false, function(v) S.spider = v end)
createCheckbox(sMovement, "Noclip (Walk Through Walls)", false, function(v) S.noclip = v end)

createSectionHeader(sMovement, "FLIGHT", 20)
createCheckbox(sMovement, "Fly Mode (WASD)", false, function(v)
	S.fly = v
	local rp = getRoot()
	if v and rp then
		S.flyBV = make("BodyVelocity", { MaxForce = Vector3.new(1e6,1e6,1e6), Velocity = Vector3.zero, Parent = rp })
		S.flyBG = make("BodyGyro", { MaxTorque = Vector3.new(1e6,1e6,1e6), D = 200, P = 10000, Parent = rp })
	else
		if S.flyBV then S.flyBV:Destroy(); S.flyBV = nil end
		if S.flyBG then S.flyBG:Destroy(); S.flyBG = nil end
	end
end)
createCheckbox(sMovement, "Vehicle Fly", false, function(v) S.vehicleFly = v end)

createSectionHeader(sMovement, "ROTATION", 30)
createCheckbox(sMovement, "Spinbot", false, function(v) S.spinbot = v end)
createSlider(sMovement, "Spinbot Speed", 10, 100, 30, function(v) S.spinbotSpeed = v end)

createSectionHeader(sMovement, "DEFENSE", 40)
createCheckbox(sMovement, "God Mode", false, function(v) S.godMode = v end)
createButton(sMovement, "Teleport to Aim Target", function()
	local rp = getRoot()
	if rp and S.aimbotTarget and S.aimbotTarget.Parent then
		local targetHrp = S.aimbotTarget.Parent:FindFirstChild("HumanoidRootPart")
		if targetHrp then
			rp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 4)
			notify("TELEPORT", "Teleportado para as costas de " .. S.aimbotTarget.Parent.Name, 2, "FEATURE")
		end
	else
		notify("ERRO", "Nenhum alvo na mira do Aimbot/Silent Aim", 2, "ERROR")
	end
end)
createButton(sMovement, "Teleport to Random Player", function()
	local rp = getRoot()
	if rp then
		local targets = {}
		for _, p in ipairs(Players:GetPlayers()) do
			if isValidTarget(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				table.insert(targets, p)
			end
		end
		if #targets > 0 then
			local target = targets[math.random(1, #targets)]
			rp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
			notify("TELEPORT", "Teleportado para " .. target.Name, 2, "FEATURE")
		else
			notify("ERRO", "Nenhum jogador valido encontrado", 2, "ERROR")
		end
	end
end)
createButton(sMovement, "Respawn Character", function()
	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.Health = 0
			notify("RESPAWN", "Personagem eliminado para respawn", 2, "WARNING")
		end
	end
end)

local sWorld = createTabPanel("World")
createSectionHeader(sWorld, "LIGHTING", 1)
createCheckbox(sWorld, "Fullbright", false, function(v)
	S.fullbright = v
	if v then
		S._origBrightness = Lighting.Brightness
		S._origAmbient = Lighting.Ambient
		S._origOutdoor = Lighting.OutdoorAmbient
		Lighting.Brightness = 2
		Lighting.Ambient = Color3.fromRGB(255, 255, 255)
		Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
	else
		if S._origBrightness then Lighting.Brightness = S._origBrightness end
		if S._origAmbient then Lighting.Ambient = S._origAmbient end
		if S._origOutdoor then Lighting.OutdoorAmbient = S._origOutdoor end
	end
end)
createCheckbox(sWorld, "No Fog", false, function(v)
	S.noFog = v
	if v then
		S._origFogEnd = Lighting.FogEnd
		S._origFogStart = Lighting.FogStart
		S._origDensity = Lighting.Atmosphere and Lighting.Atmosphere.Density
		Lighting.FogEnd = 100000
		Lighting.FogStart = 0
		if Lighting.Atmosphere then Lighting.Atmosphere.Density = 0 end
	else
		if S._origFogEnd then Lighting.FogEnd = S._origFogEnd end
		if S._origFogStart then Lighting.FogStart = S._origFogStart end
		if S._origDensity and Lighting.Atmosphere then Lighting.Atmosphere.Density = S._origDensity end
	end
end)
createSlider(sWorld, "Brightness", 0, 10, 2, function(v) S.brightness = v; Lighting.Brightness = v end)

createSectionHeader(sWorld, "PHYSICS", 10)
createSlider(sWorld, "Gravity", 0, 500, 196, function(v) S.gravityVal = v; WS.Gravity = v end)
createSlider(sWorld, "Timescale", 1, 10, 1, function(v) S.timescale = v end)

createSectionHeader(sWorld, "ENVIRONMENT", 20)
createCheckbox(sWorld, "Remove Terrain Decorations", false, function(v)
	if v then
		for _, obj in ipairs(WS:GetDescendants()) do
			if obj:IsA("Decal") or obj:IsA("Texture") then
				obj.Transparency = 1
			end
		end
	else
		for _, obj in ipairs(WS:GetDescendants()) do
			if obj:IsA("Decal") or obj:IsA("Texture") then
				obj.Transparency = 0
			end
		end
	end
end)
createButton(sWorld, "Remove All Parts (Lobby)", function()
	for _, obj in ipairs(WS:GetDescendants()) do
		if obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
			obj:Destroy()
		end
	end
	notify("WORLD", "Meshes destruidos", 2, "WARNING")
end)

local sSettings = createTabPanel("Settings")
createSectionHeader(sSettings, "SECURITY", 1)
createCheckbox(sSettings, "Stealth Mode (Ocultar Logs)", false, setStealth)
createButton(sSettings, "Block All Remotes", function()
	BypassEnabled = true
	BypassMode = "block_all"
	notify("BYPASS", "Todos os remotes bloqueados", 2, "SUCCESS")
end)
createButton(sSettings, "Allow Whitelist Only", function()
	BypassEnabled = true
	BypassMode = "allow_whitelist"
	notify("BYPASS", "Apenas whitelist permitida", 2, "SUCCESS")
end)
createButton(sSettings, "Disable Bypass", function()
	BypassEnabled = false
	notify("BYPASS", "Bypass desativado", 2, "WARNING")
end)

createSectionHeader(sSettings, "UI", 10)
createCheckbox(sSettings, "Mobile Button Visible", true, function(v) S.mobileBtn = v end)
createButton(sSettings, "Destroy Menu (Full Reset)", function()
	for _, p in ipairs(Players:GetPlayers()) do
		if espCache[p] then
			for _, l in ipairs(espCache[p].box) do if l and l.Parent then l:Destroy() end end
			if espCache[p].tracer and espCache[p].tracer.Parent then espCache[p].tracer:Destroy() end
			if espCache[p].name and espCache[p].name.Parent then espCache[p].name:Destroy() end
		end
	end
	if gui and gui.Parent then gui:Destroy() end
	notify("DESTROY", "Menu destruido completamente", 2, "ERROR")
end)

createSectionHeader(sSettings, "INFORMATION", 20)
createButton(sSettings, "Show Player List", function()
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		table.insert(list, p.Name)
	end
	notify("PLAYERS", table.concat(list, ", "), 5, "INFO")
end)
createButton(sSettings, "Show Blocked Remotes", function()
	local count = 0
	for _ in pairs(lastBlocked) do count = count + 1 end
	notify("BYPASS", count .. " remotes bloqueados no total", 3, "INFO")
end)
createButton(sSettings, "Show Current Settings", function()
	local active = {}
	if S.aimbot then table.insert(active, "Aimbot") end
	if S.silentAim then table.insert(active, "SilentAim") end
	if S.triggerbot then table.insert(active, "Triggerbot") end
	if S.speed then table.insert(active, "Speed") end
	if S.fly then table.insert(active, "Fly") end
	if S.noclip then table.insert(active, "Noclip") end
	if S.godMode then table.insert(active, "GodMode") end
	if S.espBox then table.insert(active, "BoxESP") end
	if S.espTracer then table.insert(active, "TracerESP") end
	if S.chams then table.insert(active, "Chams") end
	if #active > 0 then
		notify("ACTIVE", table.concat(active, " | "), 5, "INFO")
	else
		notify("ACTIVE", "Nenhum cheat ativo", 3, "WARNING")
	end
end)
createButton(sSettings, "Credits", function()
	notify("CREDITS", "Ghost Menu V9 by Magnata - Todos os direitos reservados", 5, "INFO")
end)

local watermark = make("Frame", {
	Size = UDim2.new(0, 300, 0, 24), Position = UDim2.new(0, 15, 0, 15),
	BackgroundColor3 = Color3.fromRGB(35, 35, 42), BorderSizePixel = 0, Parent = gui
})
make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = watermark })
make("UIStroke", { Thickness = 1, Color = C.accent, Transparency = 0.3, Parent = watermark })
local wmText = make("TextLabel", {
	Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0),
	BackgroundTransparency = 1, Text = "Ghost Menu V9 | FPS: 0 | Ping: 0ms",
	Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.white,
	TextXAlignment = Enum.TextXAlignment.Left, Parent = watermark
})
local rainbow = make("Frame", {
	Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -1),
	BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = watermark
})
make("UIGradient", {
	Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 100, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
	}, Parent = rainbow
})

local fpsCount = 0
local fpsLast = tick()
RunService.RenderStepped:Connect(function()
	fpsCount = fpsCount + 1
	if tick() - fpsLast >= 1 then
		local ping = 0
		pcall(function()
			ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
		end)
		wmText.Text = string.format("Ghost Menu V9 PRO | FPS: %d | Ping: %dms", fpsCount, math.floor(ping))
		fpsCount = 0
		fpsLast = tick()
		local mw = math.clamp(wmText.TextBounds.X + 20, 200, 450)
		TweenService:Create(watermark, TweenInfo.new(0.5), { Size = UDim2.new(0, mw, 0, 24) }):Play()
	end
end)

local mobileButton = make("TextButton", {
	Size = UDim2.new(0, 56, 0, 56), Position = UDim2.new(1, -75, 1, -75),
	BackgroundColor3 = C.accent, Text = "GM", Font = Enum.Font.GothamBlack,
	TextSize = 18, TextColor3 = C.white, BorderSizePixel = 0, ZIndex = 1000, Parent = gui
})
make("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = mobileButton })
make("UIStroke", { Thickness = 2, Color = C.white, Transparency = 0.5, Parent = mobileButton })

local mobileGlow = make("Frame", {
	Size = UDim2.new(1, 8, 1, 8), AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = C.accent,
	BackgroundTransparency = 0.8, BorderSizePixel = 0, ZIndex = 999, Parent = mobileButton
})
make("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = mobileGlow })

mobileButton.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
	if main.Visible then
		notify("MENU", "Menu aberto - Pressione Insert para fechar", 2, "INFO")
	end
end)

mobileButton.MouseEnter:Connect(function()
	TweenService:Create(mobileButton, TweenInfo.new(0.2), { Size = UDim2.new(0, 60, 0, 60) }):Play()
end)
mobileButton.MouseLeave:Connect(function()
	TweenService:Create(mobileButton, TweenInfo.new(0.2), { Size = UDim2.new(0, 56, 0, 56) }):Play()
end)

RunService.Heartbeat:Connect(function()
	mobileButton.Visible = S.mobileBtn
end)

task.spawn(function()
	while mobileGlow and mobileGlow.Parent do
		TweenService:Create(mobileGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { BackgroundTransparency = 0.5 }):Play()
		task.wait(1.5)
		TweenService:Create(mobileGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { BackgroundTransparency = 0.9 }):Play()
		task.wait(1.5)
	end
end)

local draggingMain, dragStartMain, startPosMain
title.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMain = true
		dragStartMain = i.Position
		startPosMain = main.Position
	end
end)
title.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingMain = false end
end)
UIS.InputChanged:Connect(function(i)
	if draggingMain and i.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = i.Position - dragStartMain
		main.Position = UDim2.new(
			startPosMain.X.Scale, startPosMain.X.Offset + delta.X,
			startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y
		)
	end
end)

UIS.InputBegan:Connect(function(i, p)
	if not p and i.KeyCode == Enum.KeyCode.Insert then
		main.Visible = not main.Visible
	end
end)

local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
	if S.antiAfk then
		vu:Button2Down(Vector2.new(0,0), camera.CFrame)
		task.wait(1)
		vu:Button2Up(Vector2.new(0,0), camera.CFrame)
		notify("ANTI-AFK", "Conexao mantida - Evitou kick por inatividade", 3, "SUCCESS")
	end
end)

task.wait(1)
switchTab("Combat")

print("========================================")
print("  GHOST MENU V9 PROFESSIONAL")
print("  by Magnata")
print("  Carregado com sucesso!")
print("  Pressione Insert para abrir/fechar")
print("========================================")
notify("GHOST MENU V9", "Carregado com sucesso! Pressione Insert para abrir.", 5, "SUCCESS")

