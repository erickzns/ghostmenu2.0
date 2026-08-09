--[[
	═══════════════════════════════════════════════════════════════════════
	  GHOST MENU V10 ULTRA — BY MAGNATA
	  Complete professional cheat menu for Roblox
	  Features: 4 Themes, 70+ cheats, Config save/load, Custom keybinds,
	  Premium animations, Advanced ESP, Enhanced bypass, 6 tabs
	  Roblox Studio — LocalScript em StarterPlayerScripts
	═══════════════════════════════════════════════════════════════════════
--]]

-- ╔══════════════════════════════════════════╗
-- ║           SERVICES & GLOBALS            ║
-- ╚══════════════════════════════════════════╝
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UIS           = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")
local WS            = game:GetService("Workspace")
local Lighting      = game:GetService("Lighting")
local HttpService   = game:GetService("HttpService")
local player        = Players.LocalPlayer
local camera        = WS.CurrentCamera
local mouse         = player:GetMouse()

-- ╔══════════════════════════════════════════╗
-- ║       CACHED TWEENINFO (Performance)    ║
-- ╚══════════════════════════════════════════╝
local TI_Fast    = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TI_Normal  = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TI_Smooth  = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TI_Slow    = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TI_Bounce  = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local TI_Elastic = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
local TI_Sine    = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

-- ╔══════════════════════════════════════════╗
-- ║           THEME SYSTEM (4 Temas)        ║
-- ╚══════════════════════════════════════════╝
local Themes = {
	Crimson = {
		name = "Crimson",
		accent      = Color3.fromRGB(255, 30, 30),
		accentGlow  = Color3.fromRGB(255, 80, 80),
		accentDim   = Color3.fromRGB(160, 15, 15),
		accentSoft  = Color3.fromRGB(60, 12, 12),
		textLight   = Color3.fromRGB(255, 100, 100),
		gradStart   = Color3.fromRGB(30, 15, 15),
		gradEnd     = Color3.fromRGB(35, 35, 42),
	},
	Phantom = {
		name = "Phantom",
		accent      = Color3.fromRGB(170, 70, 255),
		accentGlow  = Color3.fromRGB(200, 130, 255),
		accentDim   = Color3.fromRGB(100, 30, 160),
		accentSoft  = Color3.fromRGB(40, 15, 60),
		textLight   = Color3.fromRGB(200, 150, 255),
		gradStart   = Color3.fromRGB(20, 12, 30),
		gradEnd     = Color3.fromRGB(30, 28, 42),
	},
	Arctic = {
		name = "Arctic",
		accent      = Color3.fromRGB(60, 160, 255),
		accentGlow  = Color3.fromRGB(100, 190, 255),
		accentDim   = Color3.fromRGB(30, 90, 160),
		accentSoft  = Color3.fromRGB(12, 30, 60),
		textLight   = Color3.fromRGB(130, 200, 255),
		gradStart   = Color3.fromRGB(12, 18, 30),
		gradEnd     = Color3.fromRGB(28, 32, 42),
	},
	Emerald = {
		name = "Emerald",
		accent      = Color3.fromRGB(50, 220, 100),
		accentGlow  = Color3.fromRGB(100, 255, 140),
		accentDim   = Color3.fromRGB(25, 130, 55),
		accentSoft  = Color3.fromRGB(12, 50, 25),
		textLight   = Color3.fromRGB(120, 255, 160),
		gradStart   = Color3.fromRGB(12, 25, 15),
		gradEnd     = Color3.fromRGB(28, 38, 32),
	},
}
local themeOrder = {"Crimson", "Phantom", "Arctic", "Emerald"}
local currentThemeName = "Crimson"

-- Active color palette (mutable, updated on theme switch)
local C = {
	accent      = Color3.fromRGB(255, 30, 30),
	accentGlow  = Color3.fromRGB(255, 80, 80),
	accentDim   = Color3.fromRGB(160, 15, 15),
	accentSoft  = Color3.fromRGB(60, 12, 12),
	textLight   = Color3.fromRGB(255, 100, 100),
	textWhite   = Color3.fromRGB(255, 255, 255),
	textSec     = Color3.fromRGB(200, 200, 210),
	textMuted   = Color3.fromRGB(140, 140, 155),
	sidebarBg   = Color3.fromRGB(18, 18, 24),
	sidebarHover= Color3.fromRGB(32, 32, 40),
	panelBg     = Color3.fromRGB(26, 26, 32),
	cardBg      = Color3.fromRGB(36, 36, 44),
	cardHover   = Color3.fromRGB(48, 48, 58),
	cardActive  = Color3.fromRGB(42, 28, 28),
	border      = Color3.fromRGB(55, 55, 68),
	borderLight = Color3.fromRGB(75, 75, 90),
	iconDim     = Color3.fromRGB(140, 140, 160),
	trackBg     = Color3.fromRGB(24, 24, 30),
	danger      = Color3.fromRGB(255, 50, 50),
	success     = Color3.fromRGB(50, 230, 90),
	blue        = Color3.fromRGB(60, 140, 255),
	yellow      = Color3.fromRGB(255, 230, 50),
	purple      = Color3.fromRGB(170, 70, 255),
	cyan        = Color3.fromRGB(60, 210, 230),
	orange      = Color3.fromRGB(255, 150, 40),
	white       = Color3.fromRGB(255, 255, 255),
	black       = Color3.fromRGB(0, 0, 0),
	gradStart   = Color3.fromRGB(30, 15, 15),
	gradEnd     = Color3.fromRGB(35, 35, 42),
}

local themeUpdateCallbacks = {}

local function applyTheme(themeName)
	local t = Themes[themeName]
	if not t then return end
	currentThemeName = themeName
	C.accent     = t.accent
	C.accentGlow = t.accentGlow
	C.accentDim  = t.accentDim
	C.accentSoft = t.accentSoft
	C.textLight  = t.textLight
	C.gradStart  = t.gradStart
	C.gradEnd    = t.gradEnd
	C.cardActive = Color3.fromRGB(
		math.floor(t.accentSoft.R * 255 * 0.7),
		math.floor(t.accentSoft.G * 255 * 0.7),
		math.floor(t.accentSoft.B * 255 * 0.7)
	)
	for _, cb in ipairs(themeUpdateCallbacks) do
		pcall(cb)
	end
end

-- ╔══════════════════════════════════════════╗
-- ║           BYPASS SYSTEM (Enhanced)      ║
-- ╚══════════════════════════════════════════╝
local BypassEnabled = true
local BypassMode = "block_all"
local bypassWhitelist = {}
local lastBlocked = {}
local blockedLog = {}

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

	-- Silent aim intercept
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

	-- Anti-kick intercept
	if S and S.antiKick and not checkcaller() then
		if method == "Kick" then return nil end
	end

	-- Anti-teleport intercept
	if S and S.antiTeleport and not checkcaller() then
		if method == "Teleport" or method == "TeleportToPlaceInstance" then return nil end
	end

	-- Remote blocking
	if BypassEnabled and not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
		if BypassMode == "block_all" then
			local id = remoteId(self)
			lastBlocked[id] = true
			table.insert(blockedLog, {time = os.clock(), remote = id, method = method})
			if #blockedLog > 100 then table.remove(blockedLog, 1) end
			return nil
		elseif BypassMode == "allow_whitelist" then
			if not bypassWhitelist[self] then
				local id = remoteId(self)
				lastBlocked[id] = true
				table.insert(blockedLog, {time = os.clock(), remote = id, method = method})
				if #blockedLog > 100 then table.remove(blockedLog, 1) end
				return nil
			end
		end
	end
	return oldNamecall(self, unpack(args))
end) or function() end

-- Stealth mode
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

-- ╔══════════════════════════════════════════╗
-- ║         SETTINGS STATE (All cheats)     ║
-- ╚══════════════════════════════════════════╝
S = {
	-- Combat
	targetTeam = "Todos", aimbotPart = "Head",
	aimbot = false, aimbotFOV = 120, aimbotSmooth = 8, aimbotMethod = "Camera",
	triggerbot = false, triggerDelay = 0, silentAim = false,
	hitboxExpander = false, hitboxSize = 10,
	antiAim = false, killAura = false,
	autoParry = false,
	aimPrediction = false, predictionStrength = 5,
	fovCircleFilled = false,

	-- Visuals
	espHighlight = false, espBox = false, espTracer = false, espSkeleton = false,
	espName = false, espDistance = false, espHealthBar = false, espHeadDot = false, espSnaplines = false,
	fovCircle = false, fovCircleColor = "Red", fullbright = false,
	espBoxColor = "Red", espTracerColor = "Red", espSkeletonColor = "White",
	espNameColor = "White", espDistanceColor = "Cyan", espHealthBarColor = "Green",
	espHeadDotColor = "Yellow", espSnaplinesColor = "Purple",
	chams = false, chamsColor = "Red", worldFOV = 70, timeOfDay = "Normal",
	thirdPerson = false, thirdPersonDist = 10,
	crosshairEnabled = false, crosshairStyle = "Cross", crosshairColor = "White", crosshairSize = 12,
	killEffect = false,

	-- Weapon
	noRecoil = false, noSpread = false, infAmmo = false, rapidFire = false, dmgMult = 1, wallbang = false,

	-- Movement
	speed = false, speedVal = 50, superJump = false, fly = false, noclip = false, godMode = false,
	spinbot = false, spinbotSpeed = 30, vehicleFly = false, autoBhop = false, spider = false,
	infiniteJump = false, longJump = false, longJumpForce = 80,

	-- World
	antiAfk = false, noFog = false, brightness = 2, gravityVal = 196.2, timescale = 1,
	xray = false, xrayTransparency = 0.7, antiVoid = false,

	-- Settings / Security
	antiKick = false, antiTeleport = false, antiScreenshot = false,
	mobileBtn = true, showWatermark = true,
	uiScale = 1,

	-- Keybinds
	keybindMenu = Enum.KeyCode.Insert,
	keybindFly = Enum.KeyCode.F,
	keybindNoclip = Enum.KeyCode.V,
	keybindSpeed = Enum.KeyCode.X,

	-- Waypoint
	waypointSaved = nil,

	-- Internal
	fovCircleObj = nil, flyBV = nil, flyBG = nil, vFlyBV = nil, vFlyBG = nil,
	espHighlighs = {}, aimbotTarget = nil, espObjects = {},
	crosshairParts = {},
}

-- ╔══════════════════════════════════════════╗
-- ║          COLOR MAP & HELPERS            ║
-- ╚══════════════════════════════════════════╝
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

local function lerp3(a, b, t)
	return Color3.new(a.R + (b.R - a.R) * t, a.G + (b.G - a.G) * t, a.B + (b.B - a.B) * t)
end

-- ╔══════════════════════════════════════════╗
-- ║         CONFIG SAVE / LOAD SYSTEM       ║
-- ╚══════════════════════════════════════════╝
local configKeys = {
	"targetTeam", "aimbotPart", "aimbot", "aimbotFOV", "aimbotSmooth", "aimbotMethod",
	"triggerbot", "triggerDelay", "silentAim", "hitboxExpander", "hitboxSize",
	"antiAim", "killAura", "autoParry", "aimPrediction", "predictionStrength", "fovCircleFilled",
	"espHighlight", "espBox", "espTracer", "espSkeleton", "espName", "espDistance",
	"espHealthBar", "espHeadDot", "espSnaplines", "fovCircle", "fovCircleColor", "fullbright",
	"espBoxColor", "espTracerColor", "espSkeletonColor", "espNameColor", "espDistanceColor",
	"espHealthBarColor", "espHeadDotColor", "espSnaplinesColor",
	"chams", "chamsColor", "worldFOV", "timeOfDay", "thirdPerson", "thirdPersonDist",
	"crosshairEnabled", "crosshairStyle", "crosshairColor", "crosshairSize", "killEffect",
	"noRecoil", "noSpread", "infAmmo", "rapidFire", "dmgMult", "wallbang",
	"speed", "speedVal", "superJump", "fly", "noclip", "godMode",
	"spinbot", "spinbotSpeed", "vehicleFly", "autoBhop", "spider",
	"infiniteJump", "longJump", "longJumpForce",
	"antiAfk", "noFog", "brightness", "gravityVal", "timescale",
	"xray", "xrayTransparency", "antiVoid",
	"antiKick", "antiTeleport", "antiScreenshot", "mobileBtn", "showWatermark", "uiScale",
}

local function serializeConfig()
	local data = {theme = currentThemeName}
	for _, key in ipairs(configKeys) do
		local v = S[key]
		if v ~= nil then
			if typeof(v) == "EnumItem" then
				data[key] = tostring(v)
			else
				data[key] = v
			end
		end
	end
	local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
	return ok and json or nil
end

local function deserializeConfig(json)
	local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
	if not ok or type(data) ~= "table" then return false end
	if data.theme and Themes[data.theme] then
		applyTheme(data.theme)
	end
	for _, key in ipairs(configKeys) do
		if data[key] ~= nil then
			S[key] = data[key]
		end
	end
	return true
end

-- ╔══════════════════════════════════════════╗
-- ║          CLEANUP OLD GUI                ║
-- ╚══════════════════════════════════════════╝
pcall(function()
	local pg = player:FindFirstChildOfClass("PlayerGui")
	if pg then
		for _, old in ipairs({"MagnataMenuRemastered", "GhostMenuV10"}) do
			local o = pg:FindFirstChild(old)
			if o then o:Destroy() end
		end
	end
end)

-- ╔══════════════════════════════════════════╗
-- ║         MAIN GUI CONTAINER              ║
-- ╚══════════════════════════════════════════╝
local gui = make("ScreenGui", {
	Name = "GhostMenuV10", ResetOnSpawn = false, DisplayOrder = 9999,
	ZIndexBehavior = Enum.ZIndexBehavior.Global, IgnoreGuiInset = true,
	Parent = player:WaitForChild("PlayerGui")
})
local espContainer = make("Folder", { Name = "ESP_Drawings", Parent = gui })

-- ╔══════════════════════════════════════════╗
-- ║       SPLASH SCREEN (Premium)           ║
-- ╚══════════════════════════════════════════╝
local splashOverlay = make("Frame", {
	Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(8, 8, 12),
	BackgroundTransparency = 1, ZIndex = 10000, Parent = gui
})

local splashFrame = make("Frame", {
	Size = UDim2.new(0, 440, 0, 240), Position = UDim2.new(0.5, -220, 0.5, -120),
	BackgroundColor3 = C.panelBg, BorderSizePixel = 0, ZIndex = 10001, Parent = splashOverlay
})
make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = splashFrame })
local splashStroke = make("UIStroke", { Thickness = 2, Color = C.accent, Transparency = 1, Parent = splashFrame })
make("UIGradient", {
	Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, C.gradStart),
		ColorSequenceKeypoint.new(1, C.gradEnd)
	}, Parent = splashFrame
})

-- Splash particles (decorative animated dots)
for i = 1, 12 do
	local particle = make("Frame", {
		Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4)),
		Position = UDim2.new(math.random() * 0.8 + 0.1, 0, math.random() * 0.6 + 0.2, 0),
		BackgroundColor3 = C.accent, BackgroundTransparency = 0.7,
		BorderSizePixel = 0, ZIndex = 10002, Parent = splashFrame
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = particle })
	task.spawn(function()
		while particle and particle.Parent do
			local targetPos = UDim2.new(math.random() * 0.8 + 0.1, 0, math.random() * 0.6 + 0.2, 0)
			TweenService:Create(particle, TweenInfo.new(math.random(20, 40) / 10, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = targetPos, BackgroundTransparency = math.random(5, 9) / 10
			}):Play()
			task.wait(math.random(20, 40) / 10)
		end
	end)
end

-- Ghost icon (ASCII art style)
local ghostIcon = make("TextLabel", {
	Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0.5, -30, 0, 15),
	BackgroundTransparency = 1, Text = "👻", TextSize = 40,
	TextTransparency = 1, ZIndex = 10003, Parent = splashFrame
})

local splashTitle = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 45), Position = UDim2.new(0, 0, 0, 70),
	BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBlack,
	TextColor3 = C.white, TextSize = 34, TextTransparency = 0,
	ZIndex = 10003, Parent = splashFrame
})
local splashVersion = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0, 112),
	BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBold,
	TextColor3 = C.accent, TextSize = 14, TextTransparency = 0,
	ZIndex = 10003, Parent = splashFrame
})
local splashBarBg = make("Frame", {
	Size = UDim2.new(0, 340, 0, 6), Position = UDim2.new(0.5, -170, 0, 150),
	BackgroundColor3 = C.trackBg, BorderSizePixel = 0, ZIndex = 10003, Parent = splashFrame
})
make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = splashBarBg })
local splashBarFill = make("Frame", {
	Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = C.accent,
	BorderSizePixel = 0, ZIndex = 10004, Parent = splashBarBg
})
make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = splashBarFill })
make("UIGradient", {
	Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, C.accentDim),
		ColorSequenceKeypoint.new(0.5, C.accent),
		ColorSequenceKeypoint.new(1, C.accentGlow),
	}, Parent = splashBarFill
})
local splashStatus = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 18), Position = UDim2.new(0, 0, 0, 168),
	BackgroundTransparency = 1, Text = "", Font = Enum.Font.Gotham,
	TextColor3 = C.textSec, TextSize = 11, TextTransparency = 0,
	ZIndex = 10003, Parent = splashFrame
})
local splashBy = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 18), Position = UDim2.new(0, 0, 0, 210),
	BackgroundTransparency = 1, Text = "by Magnata", Font = Enum.Font.Gotham,
	TextColor3 = C.textMuted, TextSize = 10, TextTransparency = 1,
	ZIndex = 10003, Parent = splashFrame
})

-- Typewriter effect for splash
local function typewrite(label, text, speed)
	for i = 1, #text do
		label.Text = string.sub(text, 1, i)
		task.wait(speed or 0.04)
	end
end

-- Splash animation sequence
task.spawn(function()
	task.wait(0.2)
	-- Fade in ghost icon
	TweenService:Create(ghostIcon, TI_Smooth, { TextTransparency = 0 }):Play()
	TweenService:Create(splashStroke, TI_Smooth, { Transparency = 0 }):Play()
	task.wait(0.3)

	-- Typewriter title
	typewrite(splashTitle, "GHOST MENU", 0.06)
	task.wait(0.15)
	typewrite(splashVersion, "V10 ULTRA", 0.05)
	TweenService:Create(splashBy, TI_Normal, { TextTransparency = 0 }):Play()
	task.wait(0.3)

	-- Glitch effect on title
	for _ = 1, 3 do
		splashTitle.Position = UDim2.new(0, math.random(-3, 3), 0, 70 + math.random(-2, 2))
		splashTitle.TextColor3 = Color3.fromRGB(255, math.random(200, 255), math.random(200, 255))
		task.wait(0.05)
	end
	splashTitle.Position = UDim2.new(0, 0, 0, 70)
	splashTitle.TextColor3 = C.white

	-- Loading stages
	local stages = {
		"Inicializando kernel...",
		"Carregando bypass engine...",
		"Preparando ESP pipeline...",
		"Configurando UI framework...",
		"Ativando modulos de combate...",
		"Sincronizando temas...",
		"Sistema pronto!"
	}
	for i, stage in ipairs(stages) do
		splashStatus.Text = "► " .. stage
		local progress = i / #stages
		TweenService:Create(splashBarFill, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Size = UDim2.new(progress, 0, 1, 0)
		}):Play()
		task.wait(0.3)
	end

	task.wait(0.4)

	-- Fade out
	TweenService:Create(splashOverlay, TweenInfo.new(0.6, Enum.EasingStyle.Quad), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(splashFrame, TI_Smooth, { BackgroundTransparency = 1 }):Play()
	TweenService:Create(splashStroke, TI_Smooth, { Transparency = 1 }):Play()
	for _, child in ipairs(splashFrame:GetDescendants()) do
		pcall(function()
			if child:IsA("TextLabel") then
				TweenService:Create(child, TI_Smooth, { TextTransparency = 1 }):Play()
			elseif child:IsA("Frame") then
				TweenService:Create(child, TI_Smooth, { BackgroundTransparency = 1 }):Play()
			end
		end)
	end
	task.wait(0.7)
	splashOverlay:Destroy()
end)

-- ╔══════════════════════════════════════════╗
-- ║      NOTIFICATION SYSTEM (Enhanced)     ║
-- ╚══════════════════════════════════════════╝
local notifContainer = make("Frame", {
	Size = UDim2.new(0, 300, 1, -20), Position = UDim2.new(1, -320, 0, 10),
	BackgroundTransparency = 1, ZIndex = 9000, Parent = gui
})
make("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6),
	VerticalAlignment = Enum.VerticalAlignment.Bottom, Parent = notifContainer
})

local notifIcons = {
	INFO = "ℹ️", SUCCESS = "✅", WARNING = "⚠️", ERROR = "❌", FEATURE = "⚡",
}
local notifColors = {
	INFO = C.blue, SUCCESS = C.success, WARNING = C.yellow, ERROR = C.danger, FEATURE = C.purple,
}
local activeNotifs = 0
local MAX_NOTIFS = 5

local function notify(titleStr, textStr, duration, notifType)
	if activeNotifs >= MAX_NOTIFS then return end
	activeNotifs = activeNotifs + 1
	local dur = duration or 3
	local nType = notifType or "INFO"
	local accentCol = notifColors[nType] or C.accent
	local icon = notifIcons[nType] or "ℹ️"

	local n = make("Frame", {
		Size = UDim2.new(1, 0, 0, 60), BackgroundColor3 = Color3.fromRGB(32, 32, 40),
		BackgroundTransparency = 1, ZIndex = 9001, Parent = notifContainer
	})
	make("UICorner", { CornerRadius = UDim.new(0, 10), Parent = n })
	local stroke = make("UIStroke", { Thickness = 1, Color = accentCol, Transparency = 1, Parent = n })

	-- Left accent bar
	local accentBar = make("Frame", {
		Size = UDim2.new(0, 3, 1, -10), Position = UDim2.new(0, 6, 0, 5),
		BackgroundColor3 = accentCol, BackgroundTransparency = 1,
		BorderSizePixel = 0, ZIndex = 9002, Parent = n
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = accentBar })

	-- Icon
	local iconLbl = make("TextLabel", {
		Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 16, 0, 6),
		BackgroundTransparency = 1, Text = icon, TextSize = 14,
		TextTransparency = 1, ZIndex = 9002, Parent = n
	})

	-- Type badge
	local typeLbl = make("TextLabel", {
		Size = UDim2.new(0, 60, 0, 14), Position = UDim2.new(0, 38, 0, 8),
		BackgroundTransparency = 1, Text = nType, Font = Enum.Font.GothamBold,
		TextColor3 = accentCol, TextSize = 9, TextTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 9002, Parent = n
	})

	-- Title
	local t = make("TextLabel", {
		Size = UDim2.new(1, -24, 0, 18), Position = UDim2.new(0, 16, 0, 22),
		BackgroundTransparency = 1, Text = titleStr, Font = Enum.Font.GothamBold,
		TextColor3 = C.white, TextSize = 13, TextTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 9002, Parent = n
	})

	-- Description
	local d = make("TextLabel", {
		Size = UDim2.new(1, -24, 0, 14), Position = UDim2.new(0, 16, 0, 40),
		BackgroundTransparency = 1, Text = textStr, Font = Enum.Font.Gotham,
		TextColor3 = C.textSec, TextSize = 11, TextTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 9002, Parent = n
	})

	-- Duration progress bar
	local durBar = make("Frame", {
		Size = UDim2.new(1, -16, 0, 2), Position = UDim2.new(0, 8, 1, -5),
		BackgroundColor3 = accentCol, BackgroundTransparency = 1,
		BorderSizePixel = 0, ZIndex = 9002, Parent = n
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = durBar })

	-- Animate in (slide from right)
	n.Position = UDim2.new(0.3, 0, 0, 0)
	TweenService:Create(n, TI_Normal, { BackgroundTransparency = 0.05, Position = UDim2.new(0, 0, 0, 0) }):Play()
	TweenService:Create(stroke, TI_Normal, { Transparency = 0.5 }):Play()
	TweenService:Create(accentBar, TI_Normal, { BackgroundTransparency = 0 }):Play()
	TweenService:Create(iconLbl, TI_Normal, { TextTransparency = 0 }):Play()
	TweenService:Create(typeLbl, TI_Normal, { TextTransparency = 0 }):Play()
	TweenService:Create(t, TI_Normal, { TextTransparency = 0 }):Play()
	TweenService:Create(d, TI_Normal, { TextTransparency = 0 }):Play()
	TweenService:Create(durBar, TI_Normal, { BackgroundTransparency = 0.3 }):Play()

	-- Duration bar countdown
	task.delay(0.3, function()
		TweenService:Create(durBar, TweenInfo.new(dur - 0.6, Enum.EasingStyle.Linear), {
			Size = UDim2.new(0, 0, 0, 2)
		}):Play()
	end)

	-- Animate out
	task.delay(dur, function()
		TweenService:Create(n, TI_Normal, { BackgroundTransparency = 1, Position = UDim2.new(0.3, 0, 0, 0) }):Play()
		TweenService:Create(stroke, TI_Normal, { Transparency = 1 }):Play()
		TweenService:Create(accentBar, TI_Normal, { BackgroundTransparency = 1 }):Play()
		TweenService:Create(iconLbl, TI_Normal, { TextTransparency = 1 }):Play()
		TweenService:Create(typeLbl, TI_Normal, { TextTransparency = 1 }):Play()
		TweenService:Create(t, TI_Normal, { TextTransparency = 1 }):Play()
		TweenService:Create(d, TI_Normal, { TextTransparency = 1 }):Play()
		TweenService:Create(durBar, TI_Normal, { BackgroundTransparency = 1 }):Play()
		task.wait(0.3)
		n:Destroy()
		activeNotifs = activeNotifs - 1
	end)
end

-- ╔══════════════════════════════════════════╗
-- ║          MAIN WINDOW                    ║
-- ╚══════════════════════════════════════════╝
local main = make("Frame", {
	Size = UDim2.new(0, 940, 0, 580), Position = UDim2.new(0.5, -470, 0.5, -290),
	BackgroundColor3 = C.panelBg, BorderSizePixel = 0, Visible = false, Parent = gui
})
make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = main })
local mainStroke = make("UIStroke", { Thickness = 1.5, Color = C.border, Parent = main })
local mainGrad = make("UIGradient", {
	Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 38)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 24, 30))
	}, Parent = main
})

-- Drop shadow
local shadow = make("ImageLabel", {
	Size = UDim2.new(1, 30, 1, 30), Position = UDim2.new(0.5, 0, 0.5, 0),
	AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1,
	Image = "rbxassetid://5554236805", ImageColor3 = Color3.new(0, 0, 0),
	ImageTransparency = 0.6, ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(23, 23, 277, 277), ZIndex = -1, Parent = main
})

-- ╔══════════════════════════════════════════╗
-- ║           TITLE BAR                     ║
-- ╚══════════════════════════════════════════╝
local title = make("Frame", {
	Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = C.sidebarBg,
	BorderSizePixel = 0, Parent = main
})
make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = title })

-- Animated gradient line at bottom of title
local titleLine = make("Frame", {
	Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -1),
	BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = title
})
local titleLineGrad = make("UIGradient", {
	Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, C.accent),
		ColorSequenceKeypoint.new(0.5, C.accentGlow),
		ColorSequenceKeypoint.new(1, C.accent)
	}, Parent = titleLine
})

-- Animate rainbow shift on title line
task.spawn(function()
	local offset = 0
	while titleLineGrad and titleLineGrad.Parent do
		offset = (offset + 0.005) % 1
		titleLineGrad.Offset = Vector2.new(math.sin(offset * math.pi * 2) * 0.3, 0)
		task.wait(0.03)
	end
end)

-- Ghost icon in title
local titleIcon = make("TextLabel", {
	Size = UDim2.new(0, 30, 1, 0), Position = UDim2.new(0, 10, 0, 0),
	BackgroundTransparency = 1, Text = "👻", TextSize = 18,
	Parent = title
})

local titleLabel = make("TextLabel", {
	Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 38, 0, 0),
	BackgroundTransparency = 1, Text = "GHOST MENU", Font = Enum.Font.GothamBlack,
	TextSize = 16, TextColor3 = C.white, TextXAlignment = Enum.TextXAlignment.Left, Parent = title
})

-- ULTRA badge with glow pulse
local ultraBadge = make("TextLabel", {
	Size = UDim2.new(0, 56, 0, 22), Position = UDim2.new(0, 170, 0.5, -11),
	BackgroundColor3 = C.accentSoft, BorderSizePixel = 0, Text = "ULTRA", Font = Enum.Font.GothamBlack,
	TextSize = 10, TextColor3 = C.accent, Parent = title
})
make("UICorner", { CornerRadius = UDim.new(0, 5), Parent = ultraBadge })
make("UIStroke", { Thickness = 1, Color = C.accent, Transparency = 0.5, Parent = ultraBadge })

-- Pulse animation for ULTRA badge
task.spawn(function()
	while ultraBadge and ultraBadge.Parent do
		TweenService:Create(ultraBadge, TI_Sine, { TextColor3 = C.accentGlow }):Play()
		task.wait(1.5)
		TweenService:Create(ultraBadge, TI_Sine, { TextColor3 = C.accent }):Play()
		task.wait(1.5)
	end
end)

-- Version + clock on right
local titleRight = make("TextLabel", {
	Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(1, -300, 0, 0),
	BackgroundTransparency = 1, Text = "V10 | by Magnata", Font = Enum.Font.Gotham,
	TextSize = 11, TextColor3 = C.textMuted, TextXAlignment = Enum.TextXAlignment.Right, Parent = title
})

-- Real-time clock
local clockLabel = make("TextLabel", {
	Size = UDim2.new(0, 55, 0, 22), Position = UDim2.new(1, -145, 0.5, -11),
	BackgroundColor3 = C.trackBg, BorderSizePixel = 0, Text = "00:00",
	Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = C.textSec, Parent = title
})
make("UICorner", { CornerRadius = UDim.new(0, 4), Parent = clockLabel })
task.spawn(function()
	while clockLabel and clockLabel.Parent do
		clockLabel.Text = os.date("%H:%M:%S")
		task.wait(1)
	end
end)

-- Close button
local closeBtn = make("TextButton", {
	Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(1, -42, 0, 5),
	BackgroundColor3 = Color3.fromRGB(50, 28, 28), BorderSizePixel = 0,
	Text = "✕", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = C.textMuted, Parent = title
})
make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = closeBtn })
closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TI_Fast, { BackgroundColor3 = C.danger, TextColor3 = C.white }):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TI_Fast, { BackgroundColor3 = Color3.fromRGB(50, 28, 28), TextColor3 = C.textMuted }):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
	TweenService:Create(main, TI_Normal, { Size = UDim2.new(0, 920, 0, 560) }):Play()
	task.wait(0.05)
	main.Visible = false
	main.Size = UDim2.new(0, 940, 0, 580)
end)

-- Minimize button
local minimizeBtn = make("TextButton", {
	Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(1, -80, 0, 5),
	BackgroundColor3 = Color3.fromRGB(35, 35, 42), BorderSizePixel = 0,
	Text = "─", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = C.textMuted, Parent = title
})
make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = minimizeBtn })
minimizeBtn.MouseEnter:Connect(function()
	TweenService:Create(minimizeBtn, TI_Fast, { BackgroundColor3 = C.cardHover, TextColor3 = C.white }):Play()
end)
minimizeBtn.MouseLeave:Connect(function()
	TweenService:Create(minimizeBtn, TI_Fast, { BackgroundColor3 = Color3.fromRGB(35, 35, 42), TextColor3 = C.textMuted }):Play()
end)

-- ╔══════════════════════════════════════════╗
-- ║           SIDEBAR (6 Tabs + Icons)      ║
-- ╚══════════════════════════════════════════╝
local sidebar = make("Frame", {
	Size = UDim2.new(0, 72, 1, -42), Position = UDim2.new(0, 0, 0, 42),
	BackgroundColor3 = C.sidebarBg, BorderSizePixel = 0, Parent = main
})
make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = sidebar })

-- Separator line
local sidebarSep = make("Frame", {
	Size = UDim2.new(0, 1, 1, -20), Position = UDim2.new(1, 0, 0, 10),
	BackgroundColor3 = C.border, BorderSizePixel = 0, BackgroundTransparency = 0.5, Parent = sidebar
})

-- Content area
local contentArea = make("Frame", {
	Size = UDim2.new(1, -73, 1, -42), Position = UDim2.new(0, 73, 0, 42),
	BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Parent = main
})

local panels = {}
local sidebarBtns = {}
local currentTab = "Combat"

local function createSidebarBtn(icon, label, tabName, yPos, callback)
	local btn = make("TextButton", {
		Size = UDim2.new(1, -8, 0, 52), Position = UDim2.new(0, 4, 0, yPos),
		BackgroundColor3 = C.sidebarBg, BorderSizePixel = 0, Text = "", Parent = sidebar
	})
	make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btn })

	local iconLbl = make("TextLabel", {
		Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0, 5),
		BackgroundTransparency = 1, Text = icon, TextSize = 18,
		TextColor3 = C.iconDim, Parent = btn
	})
	local textLbl = make("TextLabel", {
		Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, 28),
		BackgroundTransparency = 1, Text = label, Font = Enum.Font.GothamBold,
		TextSize = 8, TextColor3 = C.textMuted, TextTruncate = Enum.TextTruncate.AtEnd, Parent = btn
	})

	-- Active indicator (left bar)
	local indicator = make("Frame", {
		Size = UDim2.new(0, 3, 0, 0), Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = C.accent,
		BorderSizePixel = 0, BackgroundTransparency = 1, Parent = btn
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = indicator })

	sidebarBtns[tabName] = { btn = btn, icon = iconLbl, text = textLbl, indicator = indicator }

	btn.MouseEnter:Connect(function()
		if currentTab ~= tabName then
			TweenService:Create(btn, TI_Fast, { BackgroundColor3 = C.sidebarHover }):Play()
			TweenService:Create(iconLbl, TI_Fast, { TextColor3 = C.textWhite }):Play()
		end
	end)
	btn.MouseLeave:Connect(function()
		if currentTab ~= tabName then
			TweenService:Create(btn, TI_Fast, { BackgroundColor3 = C.sidebarBg }):Play()
			TweenService:Create(iconLbl, TI_Fast, { TextColor3 = C.iconDim }):Play()
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
			TweenService:Create(data.btn, TI_Normal, { BackgroundColor3 = C.cardActive }):Play()
			TweenService:Create(data.icon, TI_Normal, { TextColor3 = C.accent }):Play()
			TweenService:Create(data.text, TI_Normal, { TextColor3 = C.textLight }):Play()
			TweenService:Create(data.indicator, TI_Normal, { BackgroundTransparency = 0, Size = UDim2.new(0, 3, 0, 24) }):Play()
		else
			TweenService:Create(data.btn, TI_Normal, { BackgroundColor3 = C.sidebarBg }):Play()
			TweenService:Create(data.icon, TI_Normal, { TextColor3 = C.iconDim }):Play()
			TweenService:Create(data.text, TI_Normal, { TextColor3 = C.textMuted }):Play()
			TweenService:Create(data.indicator, TI_Normal, { BackgroundTransparency = 1, Size = UDim2.new(0, 3, 0, 0) }):Play()
		end
	end
	for name, panel in pairs(panels) do
		if name == tabName then
			panel.Visible = true
			panel.Position = UDim2.new(0.03, 0, 0, 0)
			panel.BackgroundTransparency = 1
			TweenService:Create(panel, TI_Smooth, { Position = UDim2.new(0, 4, 0, 4), BackgroundTransparency = 1 }):Play()
		else
			panel.Visible = false
		end
	end
end

-- Create 6 sidebar tabs
local tabY = 8
createSidebarBtn("⚔️", "COMBAT", "Combat", tabY, function() switchTab("Combat") end); tabY = tabY + 56
createSidebarBtn("👁️", "VISUALS", "Visuals", tabY, function() switchTab("Visuals") end); tabY = tabY + 56
createSidebarBtn("🏃", "MOVE", "Movement", tabY, function() switchTab("Movement") end); tabY = tabY + 56
createSidebarBtn("🌍", "WORLD", "World", tabY, function() switchTab("World") end); tabY = tabY + 56
createSidebarBtn("⚙️", "CONFIG", "Settings", tabY, function() switchTab("Settings") end); tabY = tabY + 56
createSidebarBtn("🎨", "THEMES", "Themes", tabY, function() switchTab("Themes") end)

-- ╔══════════════════════════════════════════╗
-- ║        UI COMPONENT BUILDERS            ║
-- ╚══════════════════════════════════════════╝
local function createTabPanel(name)
	local panel = make("ScrollingFrame", {
		Size = UDim2.new(1, -8, 1, -8), Position = UDim2.new(0, 4, 0, 4),
		BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
		ScrollBarImageColor3 = C.accent, AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0), Visible = false, Parent = contentArea
	})
	make("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = panel })
	make("UIPadding", {
		PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 14),
		PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = panel
	})
	panels[name] = panel
	return panel
end

local orderCounter = 0
local function nextOrder()
	orderCounter = orderCounter + 1
	return orderCounter
end

local function createSectionHeader(parent, text, order)
	local f = make("Frame", {
		Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1,
		LayoutOrder = order or 0, Parent = parent
	})
	local headerText = make("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
		Text = "  ▸ " .. text, Font = Enum.Font.GothamBlack, TextSize = 11,
		TextColor3 = C.accent, TextXAlignment = Enum.TextXAlignment.Left, Parent = f
	})
	local line = make("Frame", {
		Size = UDim2.new(1, -10, 0, 1), Position = UDim2.new(0, 5, 1, -2),
		BackgroundColor3 = C.accent, BorderSizePixel = 0, BackgroundTransparency = 0.7, Parent = f
	})
	make("UIGradient", {
		Transparency = NumberSequence.new{
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1)
		}, Parent = line
	})

	-- Track for theme updates
	table.insert(themeUpdateCallbacks, function()
		headerText.TextColor3 = C.accent
		line.BackgroundColor3 = C.accent
	end)

	return f
end

-- Toggle switch (iOS style)
local function createToggle(parent, labelText, default, callback)
	local checked = default
	local f = make("Frame", {
		Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = C.cardBg,
		BorderSizePixel = 0, LayoutOrder = nextOrder(), Parent = parent
	})
	make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = f })
	make("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = f })

	local lbl = make("TextLabel", {
		Size = UDim2.new(1, -55, 1, 0), BackgroundTransparency = 1,
		Text = labelText, Font = Enum.Font.Gotham, TextSize = 13,
		TextColor3 = C.textWhite, TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd, Parent = f
	})

	-- Pill toggle
	local toggleBg = make("Frame", {
		Size = UDim2.new(0, 42, 0, 22), Position = UDim2.new(1, -48, 0.5, -11),
		BackgroundColor3 = checked and C.accent or C.trackBg,
		BorderSizePixel = 0, Parent = f
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = toggleBg })
	make("UIStroke", { Thickness = 1, Color = checked and C.accent or C.borderLight, Parent = toggleBg })

	local knob = make("Frame", {
		Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, checked and 22 or 3, 0.5, -8),
		BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = toggleBg
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

	-- Clickable area
	local clickArea = make("TextButton", {
		Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = f
	})

	f.MouseEnter:Connect(function()
		TweenService:Create(f, TI_Fast, { BackgroundColor3 = C.cardHover }):Play()
	end)
	f.MouseLeave:Connect(function()
		TweenService:Create(f, TI_Fast, { BackgroundColor3 = C.cardBg }):Play()
	end)

	clickArea.MouseButton1Click:Connect(function()
		checked = not checked
		local bgCol = checked and C.accent or C.trackBg
		local strkCol = checked and C.accent or C.borderLight
		local knobPos = checked and UDim2.new(0, 22, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)

		TweenService:Create(toggleBg, TI_Bounce, { BackgroundColor3 = bgCol }):Play()
		TweenService:Create(toggleBg:FindFirstChildOfClass("UIStroke"), TI_Fast, { Color = strkCol }):Play()
		TweenService:Create(knob, TI_Bounce, { Position = knobPos }):Play()

		-- Bounce animation on knob
		TweenService:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 18, 0, 16) }):Play()
		task.delay(0.15, function()
			TweenService:Create(knob, TI_Bounce, { Size = UDim2.new(0, 16, 0, 16) }):Play()
		end)

		if checked then
			notify("ATIVADO", labelText, 2, "SUCCESS")
		else
			notify("DESATIVADO", labelText, 2, "WARNING")
		end
		if callback then callback(checked) end
	end)

	-- Theme update
	table.insert(themeUpdateCallbacks, function()
		if checked then
			toggleBg.BackgroundColor3 = C.accent
			toggleBg:FindFirstChildOfClass("UIStroke").Color = C.accent
		end
	end)

	if default and callback then callback(true) end
end

-- Cycle button
local function createCycleButton(parent, labelText, options, default, callback)
	local idx = 1
	for i, v in ipairs(options) do if v == default then idx = i; break end end
	local f = make("Frame", {
		Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = C.cardBg,
		BorderSizePixel = 0, LayoutOrder = nextOrder(), Parent = parent
	})
	make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = f })
	make("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = f })

	make("TextLabel", {
		Size = UDim2.new(1, -155, 1, 0), BackgroundTransparency = 1,
		Text = labelText, Font = Enum.Font.Gotham, TextSize = 13,
		TextColor3 = C.textWhite, TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd, Parent = f
	})

	local btn = make("TextButton", {
		Size = UDim2.new(0, 140, 0, 26), Position = UDim2.new(1, -144, 0.5, -13),
		BackgroundColor3 = C.trackBg, Text = "  " .. options[idx] .. "  ",
		Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.accent, Parent = f
	})
	make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
	make("UIStroke", { Thickness = 1, Color = C.borderLight, Parent = btn })

	-- Arrows
	local arrowLeft = make("TextLabel", {
		Size = UDim2.new(0, 14, 1, 0), Position = UDim2.new(0, 2, 0, 0),
		BackgroundTransparency = 1, Text = "◀", Font = Enum.Font.GothamBold,
		TextSize = 8, TextColor3 = C.textMuted, Parent = btn
	})
	local arrowRight = make("TextLabel", {
		Size = UDim2.new(0, 14, 1, 0), Position = UDim2.new(1, -16, 0, 0),
		BackgroundTransparency = 1, Text = "▶", Font = Enum.Font.GothamBold,
		TextSize = 8, TextColor3 = C.textMuted, Parent = btn
	})

	f.MouseEnter:Connect(function()
		TweenService:Create(f, TI_Fast, { BackgroundColor3 = C.cardHover }):Play()
	end)
	f.MouseLeave:Connect(function()
		TweenService:Create(f, TI_Fast, { BackgroundColor3 = C.cardBg }):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		idx = (idx % #options) + 1
		btn.Text = "  " .. options[idx] .. "  "
		TweenService:Create(btn, TI_Fast, { BackgroundColor3 = C.accentSoft }):Play()
		task.wait(0.12)
		TweenService:Create(btn, TI_Fast, { BackgroundColor3 = C.trackBg }):Play()
		if callback then callback(options[idx]) end
	end)

	table.insert(themeUpdateCallbacks, function()
		btn.TextColor3 = C.accent
	end)
end

-- Slider with floating tooltip
local function createSlider(parent, labelText, min, max, default, callback)
	local val = default
	local f = make("Frame", {
		Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = C.cardBg,
		BorderSizePixel = 0, LayoutOrder = nextOrder(), Parent = parent
	})
	make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = f })
	make("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = f })

	make("TextLabel", {
		Size = UDim2.new(1, -55, 0, 22), BackgroundTransparency = 1,
		Text = labelText, Font = Enum.Font.Gotham, TextSize = 13,
		TextColor3 = C.textWhite, TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd, Parent = f
	})
	local valLbl = make("TextLabel", {
		Size = UDim2.new(0, 44, 0, 20), Position = UDim2.new(1, -48, 0, 1),
		BackgroundColor3 = C.trackBg, BorderSizePixel = 0,
		Text = tostring(val), Font = Enum.Font.GothamBold,
		TextSize = 11, TextColor3 = C.accent, Parent = f
	})
	make("UICorner", { CornerRadius = UDim.new(0, 4), Parent = valLbl })

	local track = make("Frame", {
		Size = UDim2.new(1, -16, 0, 8), Position = UDim2.new(0, 8, 0, 34),
		BackgroundColor3 = C.trackBg, BorderSizePixel = 0, Parent = f
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })

	local pct = (val - min) / (max - min)
	local fill = make("Frame", {
		Size = UDim2.new(pct, 0, 1, 0), BackgroundColor3 = C.accent, BorderSizePixel = 0, Parent = track
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })
	make("UIGradient", {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, C.accentDim),
			ColorSequenceKeypoint.new(1, C.accent),
		}, Parent = fill
	})

	local thumb = make("Frame", {
		Size = UDim2.new(0, 16, 0, 16), AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(pct, 0, 0.5, 0), BackgroundColor3 = C.white,
		BorderSizePixel = 0, Parent = track
	})
	make("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = thumb })
	make("UIStroke", { Thickness = 2, Color = C.accent, Parent = thumb })

	-- Glow ring around thumb
	local thumbGlow = make("Frame", {
		Size = UDim2.new(0, 24, 0, 24), AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = C.accent,
		BackgroundTransparency = 0.85, BorderSizePixel = 0, Visible = false, Parent = thumb
	})
	make("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = thumbGlow })

	local hitArea = make("TextButton", {
		Size = UDim2.new(1, 0, 1, 16), Position = UDim2.new(0, 0, 0, -8),
		BackgroundTransparency = 1, Text = "", Parent = track
	})

	local dragging = false
	hitArea.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true; thumbGlow.Visible = true
		end
	end)
	hitArea.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false; thumbGlow.Visible = false
		end
	end)
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
		TweenService:Create(f, TI_Fast, { BackgroundColor3 = C.cardHover }):Play()
	end)
	f.MouseLeave:Connect(function()
		TweenService:Create(f, TI_Fast, { BackgroundColor3 = C.cardBg }):Play()
	end)

	table.insert(themeUpdateCallbacks, function()
		fill.BackgroundColor3 = C.accent
		thumb:FindFirstChildOfClass("UIStroke").Color = C.accent
		valLbl.TextColor3 = C.accent
		thumbGlow.BackgroundColor3 = C.accent
	end)
end

-- Action button with ripple effect
local function createButton(parent, labelText, callback)
	local f = make("Frame", {
		Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1,
		LayoutOrder = nextOrder(), ClipsDescendants = true, Parent = parent
	})
	local btn = make("TextButton", {
		Size = UDim2.new(1, 0, 0, 32), Position = UDim2.new(0, 0, 0, 3),
		BackgroundColor3 = C.cardBg, Text = "", Font = Enum.Font.GothamBold,
		TextSize = 13, TextColor3 = C.accent, TextXAlignment = Enum.TextXAlignment.Left,
		ClipsDescendants = true, Parent = f
	})
	make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btn })
	make("UIStroke", { Thickness = 1, Color = C.border, Parent = btn })

	-- Button icon + text
	local btnIcon = make("TextLabel", {
		Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1, Text = "▸", Font = Enum.Font.GothamBold,
		TextSize = 12, TextColor3 = C.accent, Parent = btn
	})
	local btnText = make("TextLabel", {
		Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 30, 0, 0),
		BackgroundTransparency = 1, Text = labelText, Font = Enum.Font.GothamBold,
		TextSize = 12, TextColor3 = C.accent, TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd, Parent = btn
	})

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TI_Fast, { BackgroundColor3 = C.cardHover }):Play()
		TweenService:Create(btnIcon, TI_Fast, { TextColor3 = C.accentGlow }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TI_Fast, { BackgroundColor3 = C.cardBg }):Play()
		TweenService:Create(btnIcon, TI_Fast, { TextColor3 = C.accent }):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		-- Ripple effect
		local ripple = make("Frame", {
			Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = C.accent,
			BackgroundTransparency = 0.7, BorderSizePixel = 0, Parent = btn
		})
		make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ripple })
		TweenService:Create(ripple, TI_Smooth, { Size = UDim2.new(2, 0, 3, 0), BackgroundTransparency = 1 }):Play()
		task.delay(0.4, function() ripple:Destroy() end)

		TweenService:Create(btn, TI_Fast, { BackgroundColor3 = C.accent }):Play()
		TweenService:Create(btnText, TI_Fast, { TextColor3 = C.white }):Play()
		task.wait(0.12)
		TweenService:Create(btn, TI_Fast, { BackgroundColor3 = C.cardBg }):Play()
		TweenService:Create(btnText, TI_Fast, { TextColor3 = C.accent }):Play()
		if callback then callback() end
	end)

	table.insert(themeUpdateCallbacks, function()
		btnText.TextColor3 = C.accent
		btnIcon.TextColor3 = C.accent
	end)
end

-- ╔══════════════════════════════════════════╗
-- ║           ESP SYSTEM (Advanced)         ║
-- ╚══════════════════════════════════════════╝
local espCache = {}
local espFrameCounter = 0
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
		for _ = 1, 15 do table.insert(c.skeleton, getLine()) end
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
		for _, conn in ipairs(conns) do
			local p1 = char:FindFirstChild(conn[1])
			local p2 = char:FindFirstChild(conn[2])
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

-- Cleanup ESP when player leaves
Players.PlayerRemoving:Connect(function(p)
	if espCache[p] then
		pcall(function()
			for _, l in ipairs(espCache[p].box) do if l and l.Parent then l:Destroy() end end
			if espCache[p].tracer and espCache[p].tracer.Parent then espCache[p].tracer:Destroy() end
			if espCache[p].snapline and espCache[p].snapline.Parent then espCache[p].snapline:Destroy() end
			if espCache[p].name and espCache[p].name.Parent then espCache[p].name:Destroy() end
			if espCache[p].distance and espCache[p].distance.Parent then espCache[p].distance:Destroy() end
			if espCache[p].headCircle and espCache[p].headCircle.Parent then espCache[p].headCircle:Destroy() end
			if espCache[p].healthBarBg and espCache[p].healthBarBg.Parent then espCache[p].healthBarBg:Destroy() end
			if espCache[p].healthBarFill and espCache[p].healthBarFill.Parent then espCache[p].healthBarFill:Destroy() end
			for _, l in ipairs(espCache[p].skeleton) do if l and l.Parent then l:Destroy() end end
		end)
		espCache[p] = nil
	end
end)

local function refreshHighlightESP()
	for _, o in pairs(S.espHighlighs) do if o and o.Parent then o:Destroy() end end
	S.espHighlighs = {}
	if not S.espHighlight then return end
	for _, p in ipairs(Players:GetPlayers()) do
		if isValidTarget(p) and p.Character then
			table.insert(S.espHighlighs, make("Highlight", {
				FillColor = C.accent, FillTransparency = 0.5,
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
					pcall(function()
						p.Material = Enum.Material[string.split(p.OriginalMat.Value, ".")[3]] or Enum.Material.Plastic
					end)
					p.Color = p.OriginalCol.Value
					p.OriginalMat:Destroy()
					p.OriginalCol:Destroy()
				end
			end
		end
	end
end

-- ╔══════════════════════════════════════════╗
-- ║         CROSSHAIR SYSTEM (New)          ║
-- ╚══════════════════════════════════════════╝
local crosshairContainer = make("Frame", {
	Size = UDim2.new(0, 50, 0, 50), AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1,
	Visible = false, ZIndex = 5000, Parent = gui
})

local function updateCrosshair()
	-- Clear existing
	for _, child in ipairs(crosshairContainer:GetChildren()) do child:Destroy() end

	if not S.crosshairEnabled then
		crosshairContainer.Visible = false
		return
	end

	crosshairContainer.Visible = true
	local col = colorMap[S.crosshairColor] or Color3.new(1,1,1)
	local sz = S.crosshairSize

	if S.crosshairStyle == "Cross" or S.crosshairStyle == "Cross+Dot" then
		-- Horizontal
		make("Frame", {
			Size = UDim2.new(0, sz, 0, 2), Position = UDim2.new(0.5, -sz/2, 0.5, -1),
			BackgroundColor3 = col, BorderSizePixel = 0, ZIndex = 5001, Parent = crosshairContainer
		})
		-- Vertical
		make("Frame", {
			Size = UDim2.new(0, 2, 0, sz), Position = UDim2.new(0.5, -1, 0.5, -sz/2),
			BackgroundColor3 = col, BorderSizePixel = 0, ZIndex = 5001, Parent = crosshairContainer
		})
	end

	if S.crosshairStyle == "Dot" or S.crosshairStyle == "Cross+Dot" then
		local dot = make("Frame", {
			Size = UDim2.new(0, 4, 0, 4), Position = UDim2.new(0.5, -2, 0.5, -2),
			BackgroundColor3 = col, BorderSizePixel = 0, ZIndex = 5002, Parent = crosshairContainer
		})
		make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = dot })
	end

	if S.crosshairStyle == "Circle" then
		local circle = make("Frame", {
			Size = UDim2.new(0, sz, 0, sz), Position = UDim2.new(0.5, -sz/2, 0.5, -sz/2),
			BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 5001, Parent = crosshairContainer
		})
		make("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = circle })
		make("UIStroke", { Thickness = 1.5, Color = col, Parent = circle })
	end
end

-- ╔══════════════════════════════════════════╗
-- ║        ESP RENDER LOOP (Throttled)      ║
-- ╚══════════════════════════════════════════╝
RunService.RenderStepped:Connect(function()
	espFrameCounter = espFrameCounter + 1
	-- Throttle: update ESP every 2 frames for performance
	if espFrameCounter % 2 ~= 0 then return end

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

-- ╔══════════════════════════════════════════╗
-- ║         AIMBOT LOGIC (RenderStepped)    ║
-- ╚══════════════════════════════════════════╝
RunService:BindToRenderStep("GhostAimbot", 201, function()
	if S.aimbot or S.silentAim then
		local best, bd = nil, S.aimbotFOV
		local bestSP = nil
		local mLoc = UIS:GetMouseLocation()
		
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and isValidTarget(p) and p.Character then
				local part = p.Character:FindFirstChild(S.aimbotPart or "Head")
				local targetHum = p.Character:FindFirstChildOfClass("Humanoid")
				if part and targetHum and targetHum.Health > 0 then
					local targetPos = part.Position
					
					if S.aimPrediction then
						local targetRp = p.Character:FindFirstChild("HumanoidRootPart")
						if targetRp then
							local vel = targetRp.AssemblyLinearVelocity or targetRp.Velocity
							targetPos = targetPos + vel * (S.predictionStrength / 60)
						end
					end
					
					local sp, onScreen = WS.CurrentCamera:WorldToViewportPoint(targetPos)
					if onScreen and sp.Z > 0 then
						local d = (Vector2.new(sp.X, sp.Y) - mLoc).Magnitude
						if d < bd then 
							bd = d
							best = part
							bestSP = sp 
						end
					end
				end
			end
		end
		
		S.aimbotTarget = best
		
		if S.aimbot and best and bestSP and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			local targetPos = best.Position
			if S.aimPrediction then
				local targetRp = best.Parent:FindFirstChild("HumanoidRootPart")
				if targetRp then
					local vel = targetRp.AssemblyLinearVelocity or targetRp.Velocity
					targetPos = targetPos + vel * (S.predictionStrength / 60)
				end
			end
			
			if S.aimbotMethod == "Mouse" and mousemoverel then
				local smoothFactor = math.max(1, S.aimbotSmooth / 2)
				local moveX = (bestSP.X - mLoc.X) / smoothFactor
				local moveY = (bestSP.Y - mLoc.Y) / smoothFactor
				mousemoverel(moveX, moveY)
			else
				local alpha = 1 / S.aimbotSmooth
				local currentCFrame = WS.CurrentCamera.CFrame
				local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
				WS.CurrentCamera.CFrame = currentCFrame:Lerp(targetCFrame, alpha)
			end
		end
	else
		S.aimbotTarget = nil
	end
end)

-- ╔══════════════════════════════════════════╗
-- ║         GAMEPLAY LOGIC                  ║
-- ╚══════════════════════════════════════════╝
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

-- Infinite Jump
UIS.JumpRequest:Connect(function()
	if S.infiniteJump then
		local char = player.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end)

-- Anti-Void
RunService.Heartbeat:Connect(function()
	if S.antiVoid then
		local char = player.Character
		if char then
			local rp = char:FindFirstChild("HumanoidRootPart")
			if rp and rp.Position.Y < -150 then
				rp.CFrame = CFrame.new(rp.Position.X, 50, rp.Position.Z)
				notify("ANTI-VOID", "Salvo de cair no void!", 2, "SUCCESS")
			end
		end
	end
end)

-- Main heartbeat loop
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
					pcall(function()
						targetHRP.Size = Vector3.new(2, 2, 1)
						targetHRP.Transparency = 1
						targetHRP.CanCollide = true
					end)
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
		if S.longJump and UIS:IsKeyDown(Enum.KeyCode.Space) and rp then
			local moveDir = hum.MoveDirection
			if moveDir.Magnitude > 0 then
				rp.Velocity = rp.Velocity + moveDir * S.longJumpForce * 0.1
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
		local hit, _ = WS:FindPartOnRayWithIgnoreList(ray, {char})
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
					pcall(function()
						firetouchinterest(rp, p.Character.HumanoidRootPart, 0)
						firetouchinterest(rp, p.Character.HumanoidRootPart, 1)
					end)
				end
			end
		end
	end

	-- Auto-Parry (detect incoming attacks)
	if S.autoParry and rp then
		for _, p in ipairs(Players:GetPlayers()) do
			if isValidTarget(p) and p.Character then
				local targetHum = p.Character:FindFirstChildOfClass("Humanoid")
				local targetRp = p.Character:FindFirstChild("HumanoidRootPart")
				if targetHum and targetRp then
					local dist = (targetRp.Position - rp.Position).Magnitude
					if dist < 20 then
						-- Check if target is attacking (animation state)
						pcall(function()
							local anim = targetHum:GetPlayingAnimationTracks()
							for _, track in ipairs(anim) do
								local name = track.Animation and track.Animation.Name or ""
								if name:lower():find("attack") or name:lower():find("swing") or name:lower():find("slash") then
									-- Trigger block
									if mouse1click then mouse1click() end
								end
							end
						end)
					end
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

	pcall(function() WS.Gravity = S.gravityVal end)

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

	-- Triggerbot logic (kept in Heartbeat or moved to RenderStepped)
	if S.triggerbot and S.aimbotTarget then
		local mLoc = UIS:GetMouseLocation()
		local sp, onScreen = WS.CurrentCamera:WorldToViewportPoint(S.aimbotTarget.Position)
		if onScreen then
			local dMouse = (Vector2.new(sp.X, sp.Y) - mLoc).Magnitude
			if dMouse < 25 then
				task.wait(S.triggerDelay / 1000)
				pcall(function() mouse1click() end)
			end
		end
	end
end)

-- FOV circle render
RunService.RenderStepped:Connect(function()
	if S.fovCircle and S.fovCircleObj then
		local mLoc = UIS:GetMouseLocation()
		S.fovCircleObj.Position = UDim2.new(0, mLoc.X, 0, mLoc.Y)
		S.fovCircleObj.Size = UDim2.new(0, S.aimbotFOV * 2, 0, S.aimbotFOV * 2)
	end
end)

-- Character respawn handler
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

-- ╔══════════════════════════════════════════╗
-- ║         TAB PANELS — COMBAT             ║
-- ╚══════════════════════════════════════════╝
local sCombat = createTabPanel("Combat")
createSectionHeader(sCombat, "TARGET", 1)
createCycleButton(sCombat, "Target Selection", {"Todos", "Somente Inimigos"}, "Todos", function(v) S.targetTeam = v; refreshHighlightESP() end)
createCycleButton(sCombat, "Aimbot Part", {"Head", "HumanoidRootPart"}, "Head", function(v) S.aimbotPart = v end)
createCycleButton(sCombat, "Aimbot Method", {"Camera", "Mouse"}, "Camera", function(v) S.aimbotMethod = v end)

createSectionHeader(sCombat, "AIMBOT", 10)
createToggle(sCombat, "Aimbot", false, function(v) S.aimbot = v end)
createSlider(sCombat, "Aimbot FOV Range", 50, 500, 120, function(v)
	S.aimbotFOV = v
	if S.fovCircleObj then S.fovCircleObj.Size = UDim2.new(0, v*2, 0, v*2) end
end)
createSlider(sCombat, "Aimbot Smoothness", 1, 20, 8, function(v) S.aimbotSmooth = v end)
createToggle(sCombat, "Silent Aim (Magic Bullet)", false, function(v) S.silentAim = v end)
createToggle(sCombat, "Aim Prediction", false, function(v) S.aimPrediction = v end)
createSlider(sCombat, "Prediction Strength", 1, 20, 5, function(v) S.predictionStrength = v end)

createSectionHeader(sCombat, "AUTO-FIRE", 30)
createToggle(sCombat, "Triggerbot", false, function(v) S.triggerbot = v end)
createSlider(sCombat, "Triggerbot Delay (ms)", 0, 1000, 0, function(v) S.triggerDelay = v end)
createToggle(sCombat, "Auto-Parry (Melee Block)", false, function(v) S.autoParry = v end)

createSectionHeader(sCombat, "EXPLOITS", 40)
createToggle(sCombat, "Hitbox Expander", false, function(v) S.hitboxExpander = v end)
createSlider(sCombat, "Hitbox Size", 2, 30, 10, function(v) S.hitboxSize = v end)
createToggle(sCombat, "Anti-Aim (Jitter)", false, function(v) S.antiAim = v end)
createToggle(sCombat, "Kill Aura (Melee Fling)", false, function(v) S.killAura = v end)

createSectionHeader(sCombat, "WEAPON MODS", 50)
createToggle(sCombat, "Wallbang (Ignore Walls)", false, function(v) S.wallbang = v end)
createToggle(sCombat, "No Recoil", false, function(v) S.noRecoil = v end)
createToggle(sCombat, "No Spread", false, function(v) S.noSpread = v end)
createToggle(sCombat, "Infinite Ammo", false, function(v) S.infAmmo = v end)
createToggle(sCombat, "Rapid Fire", false, function(v) S.rapidFire = v end)
createSlider(sCombat, "Damage Multiplier", 1, 10, 1, function(v) S.dmgMult = v end)

-- ╔══════════════════════════════════════════╗
-- ║         TAB PANELS — VISUALS            ║
-- ╚══════════════════════════════════════════╝
local sVisuals = createTabPanel("Visuals")
createSectionHeader(sVisuals, "PLAYER ESP", 1)
createToggle(sVisuals, "ESP Box (Caixa)", false, function(v) S.espBox = v end)
createCycleButton(sVisuals, "Box Color", colorNames, "Red", function(v) S.espBoxColor = v end)
createToggle(sVisuals, "ESP Tracers (Linhas)", false, function(v) S.espTracer = v end)
createCycleButton(sVisuals, "Tracers Color", colorNames, "Red", function(v) S.espTracerColor = v end)
createToggle(sVisuals, "ESP Skeleton", false, function(v) S.espSkeleton = v end)
createCycleButton(sVisuals, "Skeleton Color", colorNames, "White", function(v) S.espSkeletonColor = v end)
createToggle(sVisuals, "ESP Name & HP", false, function(v) S.espName = v end)
createCycleButton(sVisuals, "Name & HP Color", colorNames, "White", function(v) S.espNameColor = v end)
createToggle(sVisuals, "ESP Distance", false, function(v) S.espDistance = v end)
createCycleButton(sVisuals, "Distance Color", colorNames, "Cyan", function(v) S.espDistanceColor = v end)
createToggle(sVisuals, "ESP Health Bar", false, function(v) S.espHealthBar = v end)
createCycleButton(sVisuals, "Health Bar Color", colorNames, "Green", function(v) S.espHealthBarColor = v end)
createToggle(sVisuals, "ESP Snaplines (Crosshair)", false, function(v) S.espSnaplines = v end)
createCycleButton(sVisuals, "Snaplines Color", colorNames, "Purple", function(v) S.espSnaplinesColor = v end)

createSectionHeader(sVisuals, "OVERLAYS", 20)
createToggle(sVisuals, "Player Highlight", false, function(v) S.espHighlight = v; refreshHighlightESP() end)
createToggle(sVisuals, "Chams (Material Hack)", false, function(v)
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

createSectionHeader(sVisuals, "CROSSHAIR", 25)
createToggle(sVisuals, "Custom Crosshair", false, function(v) S.crosshairEnabled = v; updateCrosshair() end)
createCycleButton(sVisuals, "Crosshair Style", {"Cross", "Dot", "Circle", "Cross+Dot"}, "Cross", function(v) S.crosshairStyle = v; updateCrosshair() end)
createCycleButton(sVisuals, "Crosshair Color", colorNames, "White", function(v) S.crosshairColor = v; updateCrosshair() end)
createSlider(sVisuals, "Crosshair Size", 6, 40, 12, function(v) S.crosshairSize = v; updateCrosshair() end)

createSectionHeader(sVisuals, "AIMBOT VISUALS", 30)
createToggle(sVisuals, "Draw FOV Circle", false, function(v)
	S.fovCircle = v
	if v and not S.fovCircleObj then
		S.fovCircleObj = make("Frame", {
			Size = UDim2.new(0, S.aimbotFOV*2, 0, S.aimbotFOV*2),
			AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Parent = gui
		})
		make("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = S.fovCircleObj })
		make("UIStroke", { Name = "Stroke", Color = colorMap[S.fovCircleColor], Thickness = 1.5, Parent = S.fovCircleObj })
		if S.fovCircleFilled then
			S.fovCircleObj.BackgroundTransparency = 0.9
			S.fovCircleObj.BackgroundColor3 = colorMap[S.fovCircleColor]
		end
	end
	if S.fovCircleObj then S.fovCircleObj.Visible = v end
end)
createToggle(sVisuals, "FOV Circle Filled", false, function(v)
	S.fovCircleFilled = v
	if S.fovCircleObj then
		S.fovCircleObj.BackgroundTransparency = v and 0.9 or 1
		if v then S.fovCircleObj.BackgroundColor3 = colorMap[S.fovCircleColor] end
	end
end)
createCycleButton(sVisuals, "FOV Circle Color", colorNames, "Red", function(v)
	S.fovCircleColor = v
	if S.fovCircleObj and S.fovCircleObj:FindFirstChild("Stroke") then
		S.fovCircleObj.Stroke.Color = colorMap[v]
	end
	if S.fovCircleFilled and S.fovCircleObj then
		S.fovCircleObj.BackgroundColor3 = colorMap[v]
	end
end)
createToggle(sVisuals, "Kill Effect (Screen Flash)", false, function(v) S.killEffect = v end)

createSectionHeader(sVisuals, "CAMERA", 40)
createSlider(sVisuals, "World FOV", 70, 120, 70, function(v) S.worldFOV = v end)
createCycleButton(sVisuals, "Time of Day", {"Normal", "Dia", "Noite"}, "Normal", function(v) S.timeOfDay = v end)
createToggle(sVisuals, "Third Person Mode", false, function(v) S.thirdPerson = v end)
createSlider(sVisuals, "3rd Person Distance", 5, 50, 10, function(v) S.thirdPersonDist = v end)

-- ╔══════════════════════════════════════════╗
-- ║         TAB PANELS — MOVEMENT           ║
-- ╚══════════════════════════════════════════╝
local sMovement = createTabPanel("Movement")
createSectionHeader(sMovement, "MOVEMENT", 1)
createToggle(sMovement, "Speed Hack", false, function(v) S.speed = v end)
createSlider(sMovement, "Movement Speed", 16, 200, 50, function(v) S.speedVal = v end)
createToggle(sMovement, "Super Jump", false, function(v) S.superJump = v end)
createToggle(sMovement, "Infinite Jump", false, function(v) S.infiniteJump = v end)
createToggle(sMovement, "Long Jump", false, function(v) S.longJump = v end)
createSlider(sMovement, "Long Jump Force", 20, 200, 80, function(v) S.longJumpForce = v end)
createToggle(sMovement, "Auto Bunny Hop", false, function(v) S.autoBhop = v end)
createToggle(sMovement, "Spider (Wallclimb)", false, function(v) S.spider = v end)
createToggle(sMovement, "Noclip (Walk Through Walls)", false, function(v) S.noclip = v end)

createSectionHeader(sMovement, "FLIGHT", 20)
createToggle(sMovement, "Fly Mode (WASD)", false, function(v)
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
createToggle(sMovement, "Vehicle Fly", false, function(v) S.vehicleFly = v end)

createSectionHeader(sMovement, "ROTATION", 30)
createToggle(sMovement, "Spinbot", false, function(v) S.spinbot = v end)
createSlider(sMovement, "Spinbot Speed", 10, 100, 30, function(v) S.spinbotSpeed = v end)

createSectionHeader(sMovement, "DEFENSE", 40)
createToggle(sMovement, "God Mode", false, function(v) S.godMode = v end)

createSectionHeader(sMovement, "TELEPORT", 50)
createButton(sMovement, "Teleport to Aim Target", function()
	local rp = getRoot()
	if rp and S.aimbotTarget and S.aimbotTarget.Parent then
		local targetHrp = S.aimbotTarget.Parent:FindFirstChild("HumanoidRootPart")
		if targetHrp then
			rp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 4)
			notify("TELEPORT", "Teleportado para " .. S.aimbotTarget.Parent.Name, 2, "FEATURE")
		end
	else
		notify("ERRO", "Nenhum alvo na mira", 2, "ERROR")
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
			notify("ERRO", "Nenhum jogador valido", 2, "ERROR")
		end
	end
end)
createButton(sMovement, "Save Waypoint", function()
	local rp = getRoot()
	if rp then
		S.waypointSaved = rp.CFrame
		notify("WAYPOINT", "Posicao salva com sucesso!", 2, "SUCCESS")
	end
end)
createButton(sMovement, "Load Waypoint", function()
	local rp = getRoot()
	if rp and S.waypointSaved then
		rp.CFrame = S.waypointSaved
		notify("WAYPOINT", "Teleportado para waypoint salvo!", 2, "FEATURE")
	else
		notify("ERRO", "Nenhum waypoint salvo", 2, "ERROR")
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

-- ╔══════════════════════════════════════════╗
-- ║         TAB PANELS — WORLD              ║
-- ╚══════════════════════════════════════════╝
local sWorld = createTabPanel("World")
createSectionHeader(sWorld, "LIGHTING", 1)
createToggle(sWorld, "Fullbright", false, function(v)
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
createToggle(sWorld, "No Fog", false, function(v)
	S.noFog = v
	if v then
		S._origFogEnd = Lighting.FogEnd
		S._origFogStart = Lighting.FogStart
		pcall(function() S._origDensity = Lighting.Atmosphere and Lighting.Atmosphere.Density end)
		Lighting.FogEnd = 100000
		Lighting.FogStart = 0
		pcall(function() if Lighting.Atmosphere then Lighting.Atmosphere.Density = 0 end end)
	else
		if S._origFogEnd then Lighting.FogEnd = S._origFogEnd end
		if S._origFogStart then Lighting.FogStart = S._origFogStart end
		pcall(function()
			if S._origDensity and Lighting.Atmosphere then Lighting.Atmosphere.Density = S._origDensity end
		end)
	end
end)
createSlider(sWorld, "Brightness", 0, 10, 2, function(v) S.brightness = v; Lighting.Brightness = v end)

createSectionHeader(sWorld, "PHYSICS", 10)
createSlider(sWorld, "Gravity", 0, 500, 196, function(v) S.gravityVal = v; pcall(function() WS.Gravity = v end) end)
createSlider(sWorld, "Timescale", 1, 10, 1, function(v) S.timescale = v end)

createSectionHeader(sWorld, "VISION", 20)
createToggle(sWorld, "X-Ray (See Through Walls)", false, function(v)
	S.xray = v
	for _, obj in ipairs(WS:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name ~= "Baseplate" and obj.Name ~= "Terrain" then
			if not obj:FindFirstChild("_origTransparency") then
				if v then
					local sv = make("NumberValue", { Name = "_origTransparency", Value = obj.Transparency, Parent = obj })
					obj.Transparency = math.max(obj.Transparency, S.xrayTransparency)
				end
			elseif not v then
				obj.Transparency = obj._origTransparency.Value
				obj._origTransparency:Destroy()
			end
		end
	end
	if v then
		notify("X-RAY", "Paredes semi-transparentes ativadas", 2, "FEATURE")
	end
end)
createSlider(sWorld, "X-Ray Transparency", 5, 9, 7, function(v) S.xrayTransparency = v / 10 end)
createToggle(sWorld, "Anti-Void (Prevent Falling)", false, function(v) S.antiVoid = v end)

createSectionHeader(sWorld, "ENVIRONMENT", 30)
createToggle(sWorld, "Remove Terrain Decorations", false, function(v)
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
createButton(sWorld, "Remove All Meshes (Lobby)", function()
	for _, obj in ipairs(WS:GetDescendants()) do
		if obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
			obj:Destroy()
		end
	end
	notify("WORLD", "Meshes destruidos", 2, "WARNING")
end)

-- ╔══════════════════════════════════════════╗
-- ║         TAB PANELS — SETTINGS           ║
-- ╚══════════════════════════════════════════╝
local sSettings = createTabPanel("Settings")
createSectionHeader(sSettings, "SECURITY", 1)
createToggle(sSettings, "Stealth Mode (Hide Logs)", false, setStealth)
createToggle(sSettings, "Anti-Kick (Block Kick)", false, function(v) S.antiKick = v end)
createToggle(sSettings, "Anti-Teleport", false, function(v) S.antiTeleport = v end)
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

createSectionHeader(sSettings, "CONFIG", 10)
createButton(sSettings, "Copy Config to Clipboard", function()
	local json = serializeConfig()
	if json then
		pcall(function() setclipboard(json) end)
		notify("CONFIG", "Configuracao copiada para clipboard!", 3, "SUCCESS")
	else
		notify("ERRO", "Falha ao serializar config", 2, "ERROR")
	end
end)
createButton(sSettings, "Load Config from Clipboard", function()
	local ok, clipText = pcall(function()
		if getclipboard then return getclipboard() end
		return nil
	end)
	if ok and clipText then
		local success = deserializeConfig(clipText)
		if success then
			notify("CONFIG", "Configuracao carregada com sucesso!", 3, "SUCCESS")
		else
			notify("ERRO", "JSON invalido no clipboard", 2, "ERROR")
		end
	else
		notify("ERRO", "Nao foi possivel ler o clipboard", 2, "ERROR")
	end
end)
createButton(sSettings, "Reset Config (Default)", function()
	-- Reset all settings to defaults
	S.aimbot = false; S.aimbotFOV = 120; S.aimbotSmooth = 8
	S.triggerbot = false; S.silentAim = false; S.hitboxExpander = false
	S.antiAim = false; S.killAura = false; S.autoParry = false
	S.espBox = false; S.espTracer = false; S.espSkeleton = false
	S.espName = false; S.espDistance = false; S.espHealthBar = false
	S.espSnaplines = false; S.chams = false; S.fovCircle = false
	S.speed = false; S.fly = false; S.noclip = false; S.godMode = false
	S.spinbot = false; S.superJump = false; S.infiniteJump = false
	S.fullbright = false; S.noFog = false; S.xray = false; S.antiVoid = false
	applyTheme("Crimson")
	notify("CONFIG", "Todas as configuracoes restauradas para padrao!", 3, "WARNING")
end)

createSectionHeader(sSettings, "UI", 20)
createToggle(sSettings, "Mobile Button Visible", true, function(v) S.mobileBtn = v end)
createToggle(sSettings, "Show Watermark", true, function(v) S.showWatermark = v end)
createToggle(sSettings, "Anti-AFK (Prevent Idle Kick)", false, function(v) S.antiAfk = v end)

createSectionHeader(sSettings, "INFORMATION", 30)
createButton(sSettings, "Show Player List", function()
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		table.insert(list, p.Name)
	end
	notify("PLAYERS (" .. #list .. ")", table.concat(list, ", "), 5, "INFO")
end)
createButton(sSettings, "Show Blocked Remotes", function()
	local count = 0
	for _ in pairs(lastBlocked) do count = count + 1 end
	notify("BYPASS LOG", count .. " remotes bloqueados no total", 3, "INFO")
end)
createButton(sSettings, "Show Active Cheats", function()
	local active = {}
	if S.aimbot then table.insert(active, "Aimbot") end
	if S.silentAim then table.insert(active, "SilentAim") end
	if S.triggerbot then table.insert(active, "Triggerbot") end
	if S.autoParry then table.insert(active, "AutoParry") end
	if S.speed then table.insert(active, "Speed") end
	if S.fly then table.insert(active, "Fly") end
	if S.noclip then table.insert(active, "Noclip") end
	if S.godMode then table.insert(active, "GodMode") end
	if S.infiniteJump then table.insert(active, "InfJump") end
	if S.espBox then table.insert(active, "BoxESP") end
	if S.espTracer then table.insert(active, "TracerESP") end
	if S.chams then table.insert(active, "Chams") end
	if S.xray then table.insert(active, "X-Ray") end
	if #active > 0 then
		notify("ACTIVE (" .. #active .. ")", table.concat(active, " | "), 5, "INFO")
	else
		notify("ACTIVE", "Nenhum cheat ativo", 3, "WARNING")
	end
end)
createButton(sSettings, "Destroy Menu (Full Reset)", function()
	for _, p in ipairs(Players:GetPlayers()) do
		if espCache[p] then
			pcall(function()
				for _, l in ipairs(espCache[p].box) do if l and l.Parent then l:Destroy() end end
				if espCache[p].tracer and espCache[p].tracer.Parent then espCache[p].tracer:Destroy() end
				if espCache[p].name and espCache[p].name.Parent then espCache[p].name:Destroy() end
			end)
		end
	end
	if gui and gui.Parent then gui:Destroy() end
	notify("DESTROY", "Menu destruido completamente", 2, "ERROR")
end)
createButton(sSettings, "Credits", function()
	notify("GHOST MENU V10 ULTRA", "by Magnata — Todos os direitos reservados 2025", 5, "FEATURE")
end)

-- ╔══════════════════════════════════════════╗
-- ║         TAB PANELS — THEMES             ║
-- ╚══════════════════════════════════════════╝
local sThemes = createTabPanel("Themes")
createSectionHeader(sThemes, "SELECT THEME", 1)

for i, themeName in ipairs(themeOrder) do
	local theme = Themes[themeName]
	local f = make("Frame", {
		Size = UDim2.new(1, 0, 0, 60), BackgroundColor3 = C.cardBg,
		BorderSizePixel = 0, LayoutOrder = nextOrder(), Parent = sThemes
	})
	make("UICorner", { CornerRadius = UDim.new(0, 10), Parent = f })
	make("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = f })

	-- Color preview dots
	local previewContainer = make("Frame", {
		Size = UDim2.new(0, 90, 0, 20), Position = UDim2.new(0, 0, 0, 8),
		BackgroundTransparency = 1, Parent = f
	})
	local colors = {theme.accent, theme.accentGlow, theme.accentDim, theme.gradStart}
	for j, col in ipairs(colors) do
		local dot = make("Frame", {
			Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, (j-1) * 22, 0, 2),
			BackgroundColor3 = col, BorderSizePixel = 0, Parent = previewContainer
		})
		make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = dot })
	end

	-- Theme name
	make("TextLabel", {
		Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 32),
		BackgroundTransparency = 1, Text = themeName:upper(), Font = Enum.Font.GothamBlack,
		TextSize = 14, TextColor3 = theme.accent, TextXAlignment = Enum.TextXAlignment.Left, Parent = f
	})

	-- Apply button
	local applyBtn = make("TextButton", {
		Size = UDim2.new(0, 70, 0, 28), Position = UDim2.new(1, -78, 0.5, -14),
		BackgroundColor3 = theme.accentSoft, Text = "APPLY", Font = Enum.Font.GothamBold,
		TextSize = 10, TextColor3 = theme.accent, Parent = f
	})
	make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = applyBtn })
	make("UIStroke", { Thickness = 1, Color = theme.accent, Transparency = 0.5, Parent = applyBtn })

	applyBtn.MouseEnter:Connect(function()
		TweenService:Create(applyBtn, TI_Fast, { BackgroundColor3 = theme.accent, TextColor3 = C.white }):Play()
	end)
	applyBtn.MouseLeave:Connect(function()
		TweenService:Create(applyBtn, TI_Fast, { BackgroundColor3 = theme.accentSoft, TextColor3 = theme.accent }):Play()
	end)
	applyBtn.MouseButton1Click:Connect(function()
		applyTheme(themeName)
		notify("TEMA", "Tema " .. themeName .. " aplicado!", 2, "FEATURE")

		-- Update core UI elements
		pcall(function()
			titleLine.BackgroundColor3 = C.accent
			titleLineGrad.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, C.accent),
				ColorSequenceKeypoint.new(0.5, C.accentGlow),
				ColorSequenceKeypoint.new(1, C.accent)
			}
			ultraBadge.TextColor3 = C.accent
			ultraBadge.BackgroundColor3 = C.accentSoft
			ultraBadge:FindFirstChildOfClass("UIStroke").Color = C.accent
		end)

		-- Update sidebar active tab
		if sidebarBtns[currentTab] then
			sidebarBtns[currentTab].btn.BackgroundColor3 = C.cardActive
			sidebarBtns[currentTab].icon.TextColor3 = C.accent
			sidebarBtns[currentTab].text.TextColor3 = C.textLight
			sidebarBtns[currentTab].indicator.BackgroundColor3 = C.accent
		end
	end)

	f.MouseEnter:Connect(function()
		TweenService:Create(f, TI_Fast, { BackgroundColor3 = C.cardHover }):Play()
	end)
	f.MouseLeave:Connect(function()
		TweenService:Create(f, TI_Fast, { BackgroundColor3 = C.cardBg }):Play()
	end)
end

createSectionHeader(sThemes, "THEME INFO", 20)
createButton(sThemes, "Current Theme Info", function()
	notify("TEMA ATIVO", currentThemeName:upper() .. " — Todas as cores da UI foram sincronizadas", 3, "INFO")
end)

-- ╔══════════════════════════════════════════╗
-- ║        WATERMARK (Enhanced)             ║
-- ╚══════════════════════════════════════════╝
local watermark = make("Frame", {
	Size = UDim2.new(0, 360, 0, 28), Position = UDim2.new(0, 15, 0, 15),
	BackgroundColor3 = Color3.fromRGB(28, 28, 36), BorderSizePixel = 0, Parent = gui
})
make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = watermark })
make("UIStroke", { Thickness = 1, Color = C.accent, Transparency = 0.4, Parent = watermark })

local wmText = make("TextLabel", {
	Size = UDim2.new(1, -14, 1, 0), Position = UDim2.new(0, 7, 0, 0),
	BackgroundTransparency = 1, Text = "👻 Ghost Menu V10 ULTRA | FPS: 0 | Ping: 0ms | Cheats: 0",
	Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.white,
	TextXAlignment = Enum.TextXAlignment.Left, Parent = watermark
})

-- Animated gradient bar under watermark
local wmBar = make("Frame", {
	Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -1),
	BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = watermark
})
local wmBarGrad = make("UIGradient", {
	Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 165, 0)),
		ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 100, 255)),
		ColorSequenceKeypoint.new(0.83, Color3.fromRGB(150, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
	}, Parent = wmBar
})

-- Animated gradient offset
task.spawn(function()
	local offset = 0
	while wmBarGrad and wmBarGrad.Parent do
		offset = (offset + 0.01) % 1
		wmBarGrad.Offset = Vector2.new(offset, 0)
		task.wait(0.03)
	end
end)

-- FPS + Ping counter
local fpsCount = 0
local fpsLast = tick()
RunService.RenderStepped:Connect(function()
	fpsCount = fpsCount + 1
	if tick() - fpsLast >= 1 then
		local ping = 0
		pcall(function()
			ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
		end)

		-- Count active cheats
		local activeCount = 0
		local bools = {"aimbot", "silentAim", "triggerbot", "autoParry", "hitboxExpander", "killAura", "antiAim",
			"espBox", "espTracer", "espSkeleton", "espName", "espDistance", "espHealthBar", "espSnaplines",
			"espHighlight", "chams", "crosshairEnabled", "fovCircle",
			"speed", "superJump", "fly", "noclip", "godMode", "spinbot", "spider", "infiniteJump", "longJump",
			"autoBhop", "vehicleFly",
			"fullbright", "noFog", "xray", "antiVoid",
			"noRecoil", "noSpread", "infAmmo", "rapidFire", "wallbang"}
		for _, key in ipairs(bools) do
			if S[key] then activeCount = activeCount + 1 end
		end

		wmText.Text = string.format(
			"👻 Ghost Menu V10 ULTRA | FPS: %d | Ping: %dms | Cheats: %d",
			fpsCount, math.floor(ping), activeCount
		)
		fpsCount = 0
		fpsLast = tick()

		local mw = math.clamp(wmText.TextBounds.X + 20, 260, 500)
		TweenService:Create(watermark, TI_Smooth, { Size = UDim2.new(0, mw, 0, 28) }):Play()
	end

	watermark.Visible = S.showWatermark
end)

-- ╔══════════════════════════════════════════╗
-- ║        MOBILE TOGGLE BUTTON             ║
-- ╚══════════════════════════════════════════╝
local mobileButton = make("TextButton", {
	Size = UDim2.new(0, 58, 0, 58), Position = UDim2.new(1, -78, 1, -78),
	BackgroundColor3 = C.accent, Text = "👻", TextSize = 24,
	TextColor3 = C.white, BorderSizePixel = 0, ZIndex = 1000, Parent = gui
})
make("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = mobileButton })
make("UIStroke", { Thickness = 2, Color = C.white, Transparency = 0.4, Parent = mobileButton })

-- Glow ring
local mobileGlow = make("Frame", {
	Size = UDim2.new(1, 10, 1, 10), AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = C.accent,
	BackgroundTransparency = 0.8, BorderSizePixel = 0, ZIndex = 999, Parent = mobileButton
})
make("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = mobileGlow })

mobileButton.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
	if main.Visible then
		-- Scale-in animation
		main.Size = UDim2.new(0, 900, 0, 550)
		TweenService:Create(main, TI_Bounce, { Size = UDim2.new(0, 940, 0, 580) }):Play()
		notify("MENU", "Menu aberto — Pressione Insert para fechar", 2, "INFO")
	end
end)

mobileButton.MouseEnter:Connect(function()
	TweenService:Create(mobileButton, TI_Normal, { Size = UDim2.new(0, 62, 0, 62) }):Play()
end)
mobileButton.MouseLeave:Connect(function()
	TweenService:Create(mobileButton, TI_Normal, { Size = UDim2.new(0, 58, 0, 58) }):Play()
end)

RunService.Heartbeat:Connect(function()
	mobileButton.Visible = S.mobileBtn
end)

-- Pulse animation
task.spawn(function()
	while mobileGlow and mobileGlow.Parent do
		TweenService:Create(mobileGlow, TI_Sine, { BackgroundTransparency = 0.5 }):Play()
		task.wait(1.5)
		TweenService:Create(mobileGlow, TI_Sine, { BackgroundTransparency = 0.9 }):Play()
		task.wait(1.5)
	end
end)

-- Update mobile button color on theme change
table.insert(themeUpdateCallbacks, function()
	mobileButton.BackgroundColor3 = C.accent
	mobileGlow.BackgroundColor3 = C.accent
	watermark:FindFirstChildOfClass("UIStroke").Color = C.accent
end)

-- ╔══════════════════════════════════════════╗
-- ║         DRAG SYSTEM                     ║
-- ╚══════════════════════════════════════════╝
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

-- ╔══════════════════════════════════════════╗
-- ║         KEYBINDS                        ║
-- ╚══════════════════════════════════════════╝
UIS.InputBegan:Connect(function(i, p)
	if p then return end

	-- Menu toggle
	if i.KeyCode == S.keybindMenu then
		main.Visible = not main.Visible
		if main.Visible then
			main.Size = UDim2.new(0, 900, 0, 550)
			TweenService:Create(main, TI_Bounce, { Size = UDim2.new(0, 940, 0, 580) }):Play()
		end
	end

	-- Quick keybinds (only when menu is closed to avoid conflicts)
	if not main.Visible then
		if i.KeyCode == S.keybindFly then
			S.fly = not S.fly
			local rp = getRoot()
			if S.fly and rp then
				S.flyBV = make("BodyVelocity", { MaxForce = Vector3.new(1e6,1e6,1e6), Velocity = Vector3.zero, Parent = rp })
				S.flyBG = make("BodyGyro", { MaxTorque = Vector3.new(1e6,1e6,1e6), D = 200, P = 10000, Parent = rp })
			else
				if S.flyBV then S.flyBV:Destroy(); S.flyBV = nil end
				if S.flyBG then S.flyBG:Destroy(); S.flyBG = nil end
			end
			notify(S.fly and "FLY ON" or "FLY OFF", "Keybind: " .. tostring(S.keybindFly), 1.5, S.fly and "SUCCESS" or "WARNING")
		elseif i.KeyCode == S.keybindNoclip then
			S.noclip = not S.noclip
			notify(S.noclip and "NOCLIP ON" or "NOCLIP OFF", "Keybind: " .. tostring(S.keybindNoclip), 1.5, S.noclip and "SUCCESS" or "WARNING")
		elseif i.KeyCode == S.keybindSpeed then
			S.speed = not S.speed
			notify(S.speed and "SPEED ON" or "SPEED OFF", "Keybind: " .. tostring(S.keybindSpeed), 1.5, S.speed and "SUCCESS" or "WARNING")
		end
	end
end)

-- ╔══════════════════════════════════════════╗
-- ║         ANTI-AFK                        ║
-- ╚══════════════════════════════════════════╝
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
	if S.antiAfk then
		pcall(function()
			vu:Button2Down(Vector2.new(0,0), camera.CFrame)
			task.wait(1)
			vu:Button2Up(Vector2.new(0,0), camera.CFrame)
		end)
		notify("ANTI-AFK", "Conexao mantida — evitou kick por inatividade", 3, "SUCCESS")
	end
end)

-- ╔══════════════════════════════════════════╗
-- ║          INITIALIZATION                 ║
-- ╚══════════════════════════════════════════╝
task.wait(1)
switchTab("Combat")

print("══════════════════════════════════════════")
print("  👻 GHOST MENU V10 ULTRA")
print("  by Magnata")
print("  Carregado com sucesso!")
print("  Pressione Insert para abrir/fechar")
print("  Keybinds: F=Fly | V=Noclip | X=Speed")
print("══════════════════════════════════════════")
notify("GHOST MENU V10 ULTRA", "Carregado! Pressione Insert para abrir. | F=Fly V=Noclip X=Speed", 5, "SUCCESS")
