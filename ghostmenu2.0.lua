-- Ghost Menu V1 - HARDCORE OFUSCADO
local P=game:GetService("Players")
local L=P.LocalPlayer
local function rS(l)local s="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"local t=""for i=1,l do t=t..string.sub(s,math.random(1,#s),math.random(1,#s))end return t end
local A=Color3.fromRGB(20,20,20)local B=Color3.fromRGB(200,0,0)local C=Color3.fromRGB(30,30,30)local D=Color3.fromRGB(35,39,42)local E=Color3.fromRGB(255,255,255)local F=Color3.fromRGB(180,180,180)
local T={"R0hPU1QxMjM=","VklQS0VZNDU2","VEVTVEU3ODk="}local R={"UEVSTUExMjM=","VklQRk9SRVZFUg=="}
local K="Z2hvc3RtZW51X2tleS50eHQ="
local function wF(c)if writefile then pcall(function()writefile(K,tostring(c))end)end end
local function rF()if isfile and readfile then local ok,c=pcall(function()return readfile(K)end)if ok then return c end end return nil end
local function sT()wF(os.time()+14*24*60*60)end
local function sP()wF("UEVSTUVOVE=")end
local function hA()local c=rF()if not c then return false,nil end;if c=="UEVSTUVOVE=" then return true,"PERMANENT" end;local t=tonumber(c) if t and os.time()<t then return true,t end;return false,t end
local function vK(i)for _,k in ipairs(T)do if i==k then return"TEMP"end end;for _,k in ipairs(R)do if i==k then return"PERMA"end end;return nil end

local templates={fly="cHJpbnQoJ0ZseSB0ZW1wbGF0ZScp",esp="cHJpbnQoJ0VQUyB0ZW1wbGF0ZScp",aimlock="cHJpbnQoJ0FpbWxvY2sgdGVtcGxhdGUnKQ==",petsimx_autoclaim="cHJpbnQoJ1BldFNpbVggQXV0b0NsYWltJyk=",petsimx_autofarm="cHJpbnQoJ1BldFNpbVggQXV0b0Zhcm0nKQ==",shindo_rboss="cHJpbnQoJ1NoaW5kbyBCb3NzZmFybScp",kinglegacy_ops="cHJpbnQoJ0tpbmcgTGVnYWN5IE9QJyk=",vbaop_tool="cHJpbnQoJ1ZCQSBPUCcp"}

local tabs={{Name="Q3JlZGl0cw==",Content="credits"},{Name="U0VSQ0ggU2NyaXB0cw==",Content="search"},{Name="R2VuZXJhbCBVc2UgU2NyaXB0cw==",Content="general"},{Name="QnVnIFJlcG9ydHM=",Content="bugs"},{Name="UGV0IFNpbSBY",Content="petsimx"},{Name="VkJBIE9Q",Content="vbaop"},{Name="U2hpbmRvIExpZmU=",Content="shindo"},{Name="S0lORyBMRUdBQ1k=",Content="kinglegacy"}}
local tC={}
local function mB(p,tX,yX,sX)local b=Instance.new("TextButton",p)b.Text=tX;b.Size=UDim2.new(sX or 0.7,0,0,36);b.Position=UDim2.new(0.15,0,0,yX);b.BackgroundColor3=B;b.TextColor3=E;b.Font=Enum.Font.SourceSansBold;b.TextSize=16;b.BorderSizePixel=0;return b end

-- Decodifica Base64
local function dB64(s)local b="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"local t=""for i=1,#s,4 do local a,b1,c,d=string.byte(s,i,i+3)or 65,string.byte(s,i+1,i+1+3)or 65,string.byte(s,i+2,i+2+3)or 65,string.byte(s,i+3,i+3+3)or 65 local n=(a*262144)+(b1*4096)+(c*64)+d t=t..string.char(math.floor(n/65536)%256,math.floor(n/256)%256,n%256)end return t end

-- Abas
tC.credits=function(m)for _,v in pairs(m:GetChildren())do v:Destroy()end;local y=40;local b1=mB(m,dB64("RGlzY29yZCBTZXJ2ZXIgKGNsaWNrKQ=="),y);y=y+50;b1.MouseButton1Click:Connect(function()if setclipboard then pcall(function()setclipboard(dB64("aHR0cHM6Ly9kaXNjb3JkLmdnL2dob3N0bWVudQ=="))end)end;b1.Text="Copied!";wait(1);b1.Text=dB64("RGlzY29yZCBTZXJ2ZXIgKGNsaWNrKQ==")end)end

tC.search=function(m)for _,v in pairs(m:GetChildren())do v:Destroy()end;local tL=Instance.new("TextLabel",m);tL.Text=dB64("UGVzaXNhcnNoIFNjcmlwdHM=");tL.Size=UDim2.new(1,-40,0,24);tL.Position=UDim2.new(0,20,0,20);tL.BackgroundTransparency=1;tL.TextColor3=E;tL.Font=Enum.Font.SourceSans;tL.TextSize=16;tL.TextXAlignment=Enum.TextXAlignment.Left
local sB=Instance.new("TextBox",m);sB.PlaceholderText=dB64("QnVza2FyLi4u");sB.Size=UDim2.new(0.6,0,0,28);sB.Position=UDim2.new(0,20,0,50);sB.BackgroundColor3=D;sB.TextColor3=E;sB.Font=Enum.Font.SourceSans;sB.TextSize=14;sB.ClearTextOnFocus=false
local rF=Instance.new("Frame",m);rF.Size=UDim2.new(1,-40,1,-120);rF.Position=UDim2.new(0,20,0,90);rF.BackgroundTransparency=1
local function pR(fil)for _,c in pairs(rF:GetChildren())do c:Destroy()end;local y=0;fil=(fil or ""):lower();local function aR(n,cod)if fil==""or string.find(n:lower(),fil)or string.find(cod:lower(),fil)then local b=mB(rF,n,y,0.9);y=y+40;b.MouseButton1Click:Connect(function()if setclipboard then pcall(function()setclipboard(cod)end)end;b.Text="Copied!";wait(1);b.Text=n end)end end
aR(dB64("Rmx5ICh0ZW1wbGF0ZSki"),templates.fly)
aR(dB64("RVBTICh0ZW1wbGF0ZSki"),templates.esp)
aR(dB64("QWltbG9jayB0ZW1wbGF0ZQ=="),templates.aimlock)
aR(dB64("UGV0U2ltWCAtIEF1dG9DbGFpbQ=="),templates.petsimx_autoclaim)
aR(dB64("UGV0U2ltWCAtIEF1dG9GYXJt"),templates.petsimx_autofarm)
aR(dB64("U2hpbmRvIEJvc3NmYXJt"),templates.shindo_rboss)
aR(dB64("S2luZ0xlZ2FjeSBPUA=="),templates.kinglegacy_ops)
aR(dB64("VkJBIE9QIFRvb2w="),templates.vbaop_tool)
end;sB.FocusLost:Connect(function(enter)if enter then pR(sB.Text or "")end end)

-- Abrir Hub Hardcore
local function oH()
local sG=Instance.new("ScreenGui",L.PlayerGui);sG.ResetOnSpawn=false
local f=Instance.new("Frame",sG);f.Size=UDim2.new(0,540,0,370);f.Position=UDim2.new(0.5,-270,0.5,-185);f.BackgroundColor3=A;f.BorderSizePixel=0
local top=Instance.new("Frame",f);top.Size=UDim2.new(1,0,0,32);top.BackgroundColor3=B;top.BorderSizePixel=0
local title=Instance.new("TextLabel",top);title.Text=dB64("R2hvc3QgTWVudSBWMTAuMA==");title.Size=UDim2.new(1,-80,1,0);title.Position=UDim2.new(0,12,0,0);title.BackgroundTransparency=1;title.TextColor3=E;title.Font=Enum.Font.SourceSansBold;title.TextSize=16;title.TextXAlignment=Enum.TextXAlignment.Left
local minBtn=Instance.new("TextButton",top);minBtn.Text="_";minBtn.Size=UDim2.new(0,32,0,32);minBtn.Position=UDim2.new(1,-64,0,0);minBtn.BackgroundColor3=B;minBtn.TextColor3=E;minBtn.Font=Enum.Font.SourceSansBold;minBtn.TextSize=24;minBtn.BorderSizePixel=0
local closeBtn=Instance.new("TextButton",top);closeBtn.Text="X";closeBtn.Size=UDim2.new(0,32,0,32);closeBtn.Position=UDim2.new(1,-32,0,0);closeBtn.BackgroundColor3=B;closeBtn.TextColor3=E;closeBtn.Font=Enum.Font.SourceSansBold;closeBtn.TextSize=20;closeBtn.BorderSizePixel=0
local navCol=Instance.new("Frame",f);navCol.Size=UDim2.new(0,160,1,-32);navCol.Position=UDim2.new(0,60,0,32);navCol.BackgroundColor3=D;navCol.BorderSizePixel=0
local navBar=Instance.new("ScrollingFrame",navCol);navBar.Size=UDim2.new(1,0,1,-60);navBar.Position=UDim2.new(0,0,0,38);navBar.BackgroundTransparency=1;navBar.BorderSizePixel=0;navBar.CanvasSize=UDim2.new(0,0,0,400);navBar.ScrollBarThickness=6;navBar.ScrollBarImageColor3=B
local navLayout=Instance.new("UIListLayout",navBar);navLayout.SortOrder=Enum.SortOrder.LayoutOrder;navLayout.Padding=UDim.new(0,2)
local mainArea=Instance.new("Frame",f);mainArea.Size=UDim2.new(1,-220,1,-32);mainArea.Position=UDim2.new(0,220,0,32);mainArea.BackgroundTransparency=1;mainArea.Name="MainArea"
for _,tab in ipairs(tabs)do local btn=mB(navBar,"# "..dB64(tab.Name),0,1);btn.Name=dB64(tab.Name);btn.TextXAlignment=Enum.TextXAlignment.Left;btn.MouseButton1Click:Connect(function()for _,b in pairs(navBar:GetChildren())do if b:IsA("TextButton")then if b.Name==dB64(tab.Name) then b.BackgroundColor3=B;b.TextColor3=E else b.BackgroundColor3=D;b.TextColor3=F end end end;local fn=tC[tab.Content];if fn then fn(mainArea)end end)end
end

-- Inicialização hardcore
local acc,exp=hA()
if acc then oH()else print(dB64("VGVsYSBkZSBsb2dpbiBzZXJpYSBleGliaWRh"))end
