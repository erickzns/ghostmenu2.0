-- Ofuscamento mediano do Ghost Menu

local a=game:GetService("Players").LocalPlayer
local b=Color3.fromRGB
local c=b(20,20,20)
local d=b(200,0,0)
local e=b(30,30,30)
local f=b(35,39,42)
local g=b(255,255,255)
local h=b(180,180,180)

local i,j,k,l,m

local n={"GHOST123","VIPKEY456","TESTE789"}
local o={"PERMA123","VIPFOREVER"}
local p="ghostmenu_key.txt"

local function q(r) if writefile then pcall(function() writefile(p,tostring(r)) end) end end
local function s() if isfile and readfile then local ok,content=pcall(function() return readfile(p) end) if ok then return content end end return nil end
local function t() local u=os.time()+(14*24*60*60) q(u) end
local function v() q("PERMANENT") end
local function w() local x=s() if not x then return false,nil end if x=="PERMANENT" then return true,"PERMANENT" end local y=tonumber(x) if y and os.time()<y then return true,y end return false,y end
local function z(input) for _,k in ipairs(n) do if input==k then return"TEMP" end end for _,k in ipairs(o) do if input==k then return"PERMA" end end return nil end

-- Templates ofuscados
local A={fly="print('Fly template')",esp="print('ESP template')",aimlock="print('Aimlock template')",petsimx_autoclaim="print('PetSimX AutoClaim')",petsimx_autofarm="print('PetSimX AutoFarm')",shindo_rboss="print('Shindo Bossfarm')",kinglegacy_ops="print('King Legacy')",vbaop_tool="print('VBA OP')"}

-- Função de criar botão
local function B(parent,text,posY,sizeX) local btn=Instance.new("TextButton") btn.Text=text btn.Size=UDim2.new(sizeX or 0.7,0,0,36) btn.Position=UDim2.new(0.15,0,0,posY) btn.BackgroundColor3=d btn.TextColor3=g btn.Font=Enum.Font.SourceSansBold btn.TextSize=16 btn.BorderSizePixel=0 btn.Parent=parent return btn end

-- Função de abrir Hub (simplificada)
local function C()
    local sg=Instance.new("ScreenGui")
    sg.Name="GhostMenuHub"
    sg.Parent=a.PlayerGui
    sg.ResetOnSpawn=false
    local mf=Instance.new("Frame",sg)
    mf.Size=UDim2.new(0,540,0,370)
    mf.Position=UDim2.new(0.5,-270,0.5,-185)
    mf.BackgroundColor3=c
    mf.BorderSizePixel=0
    mf.Active=true
    -- top bar
    local tb=Instance.new("Frame",mf)
    tb.Size=UDim2.new(1,0,0,32)
    tb.BackgroundColor3=d
    tb.BorderSizePixel=0
    -- etc...
end

-- Inicialização
local access,expire=w()
if access then
    C()
else
    criarLoginDiscordStyle()
end
