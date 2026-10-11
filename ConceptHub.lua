-- =====================================================================
-- WHITELIST GATE (Concept Hub)
-- Проверяет аккаунт Roblox + HWID + IP через твой бэкенд.
-- Незавайтлистенных кикает и логирует в Discord-вебхук.
-- Плейсхолдеры ниже ОБЯЗАТЕЛЬНО заполнить.
-- Гейт отключается сам, пока API_BASE = плейсхолдер (чтобы не залочить себя).
-- =====================================================================
do
	local Players = game:GetService("Players")
	local HttpService = game:GetService("HttpService")
	local LocalPlayer = Players.LocalPlayer

	local API_BASE    = "https://ships-tale-discussions-relate.trycloudflare.com"  -- quick tunnel (cloudflared); МЕНЯЕТСЯ при каждом перезапуске туннеля!
	local LOG_WEBHOOK = "https://discord.com/api/webhooks/XXXX/YYYY"  -- вебхук для логов отказов
	local KICK_REASON = "Нет вайтлиста. Напишите владельцу скрипта."
	local OWNER_IDS   = { 0 }                                -- Roblox UserId(ы), которые обходят проверку
	local ENABLED     = (API_BASE ~= "https://YOUR_BACKEND_URL")

	local function httpGet(url)
		local ok, res = pcall(function()
			if type(request) == "function" then
				local r = request({ Url = url, Method = "GET" })
				if type(r) == "table" then return r.Body end
				return r
			end
			return game:HttpGet(url)
		end)
		if ok and type(res) == "string" then return res end
		return nil
	end

	local function getHWID()
		local candidates = {
			function() return gethwid() end,
			function() return syn and syn.get_hwid and syn.get_hwid() end,
			function() return game:GetService("RbxAnalyticsService"):GetClientId() end,
		}
		for _, f in ipairs(candidates) do
			local ok, v = pcall(f)
			if ok and type(v) == "string" and #v > 0 then return v end
		end
		return "unknown"
	end

	local function sendLog(payload)
		pcall(function()
			local req = (type(request) == "function" and request) or (syn and syn.request) or http_request
			if req then
				req({
					Url = LOG_WEBHOOK,
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = HttpService:JSONEncode(payload),
				})
			end
		end)
	end

	if ENABLED then
		local userId      = LocalPlayer.UserId
		local username    = LocalPlayer.Name
		local displayName = LocalPlayer.DisplayName
		local hwid        = getHWID()
		local ip          = httpGet("https://api.ipify.org") or "unknown"

		local allowed = false
		for _, id in ipairs(OWNER_IDS) do
			if id == userId then allowed = true break end
		end

		if not allowed then
			local url = API_BASE .. "/verify?userid=" .. tostring(userId)
				.. "&username=" .. HttpService:UrlEncode(username)
				.. "&hwid=" .. HttpService:UrlEncode(hwid)
				.. "&ip=" .. HttpService:UrlEncode(ip)
			local body = httpGet(url)
			if body then
				local ok, data = pcall(HttpService.JSONDecode, HttpService, body)
				if ok and type(data) == "table" and data.whitelisted == true then
					allowed = true
				end
			end
		end

		if not allowed then
			sendLog({
				username = "Concept Hub | Whitelist",
				embeds = {{
					title = "Unwhitelisted injection attempt",
					color = 15158332,
					fields = {
						{ name = "Roblox Account", value = tostring(username) .. " (" .. tostring(displayName) .. ")", inline = true },
						{ name = "UserId", value = tostring(userId), inline = true },
						{ name = "HWID", value = tostring(hwid), inline = false },
						{ name = "IP", value = tostring(ip), inline = true },
						{ name = "PlaceId", value = tostring(game.PlaceId), inline = true },
						{ name = "JobId", value = tostring(game.JobId), inline = false },
					},
					timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
				}},
			})
			LocalPlayer:Kick(KICK_REASON)
			while true do
				task.wait(1)
			end
		end
	end
end

local NeverLose_Module = (function()
--[[
                          Neverlose.cc UI Library
    Author: 4lpaca
	License: MIT
    Discord: https://arceney.win/discord
    Other-Projects: https://4lpaca.win
]]

do
	local Constant = 'L'..'P'..'H'..'_NO_VIRTUALIZE';
	getfenv()[Constant] = getfenv()[Constant] or function(f) return f end;
end;

cloneref = cloneref or function(i) return i end;
gethui = gethui or get_hidden_gui;
getcustomasset = getcustomasset or getsynasset;
getgenv = getgenv or getfenv;

local LOAD_ENV = LPH_NO_VIRTUALIZE(function()
	if game:GetService('RunService'):IsStudio() then
		local BaseWorkspace = game:GetService("ReplicatedFirst"):FindFirstChild('PRI_WORKSPACE') or Instance.new('Folder',game:GetService("ReplicatedFirst"));

		BaseWorkspace.Name = 'PRI\0.'..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)));

		local __get_path_c = function(path)
			return (string.find(path,'/',1,true) and string.split(path,'/')) or (string.find(path,'\\',1,true) and string.split(path,'\\')) or {path};
		end;

		local __get_path = function(path)
			local main = __get_path_c(path);

			local block = BaseWorkspace;

			for i,v in next , main do
				block = block[v];
			end;

			return block;
		end;

		getgenv().readfile = function(path)
			local path : StringValue = __get_path(path);

			return path.Value;
		end;

		getgenv().isfile = function(path)
			local success , message = pcall(function()
				return __get_path(path);
			end);

			if success and not message:IsA("Folder") then
				return true;
			end;

			return false;
		end;

		getgenv().isfolder = function(path)
			local success , message = pcall(function()
				return __get_path(path);
			end);

			if success and message:IsA("Folder") then
				return true;
			end;

			return false;
		end;

		getgenv().writefile = function(path,content)
			local main = __get_path_c(path);

			local block = BaseWorkspace;

			for i,v in next , main do
				local item = block:FindFirstChild(v);
				if not item then
					local c = Instance.new('StringValue',block);

					c.Name = tostring(v);
					c.Value = content;
				else
					if item:IsA('StringValue') and tostring(item) == v then
						item.Name = tostring(v);
						item.Value = content;
					end;

					block = item;
				end;
			end;
		end;

		getgenv().listfiles = function(path)
			local fold = __get_path(path);
			local pa = {};

			for i,v in next , fold:GetChildren() do
				if v:IsA('StringValue') then
					table.insert(pa,path..'/'..tostring(v));
				end;
			end;

			return pa;
		end;

		getgenv().makefolder = function(path)
			local main = __get_path_c(path);

			local block = BaseWorkspace;

			for i,v in next , main do
				local item = block:FindFirstChild(v);
				if not item then
					local c = Instance.new('Folder',block);

					c.Name = tostring(v);
				else
					block = item;
				end;
			end;
		end;

		getgenv().delfile = function(path)
			local main = __get_path_c(path);

			local block = BaseWorkspace;

			for i,v in next , main do
				local item = block:FindFirstChild(v);
				if item and item:IsA('StringValue') then
					item:Destroy();
				else
					block = item;
				end;
			end;
		end;
	end;
end)

LOAD_ENV();

writefile = writefile or getgenv().writefile;
makefolder = makefolder or getgenv().makefolder;
readfile = readfile or getgenv().readfile;
delfolder = delfolder or getgenv().delfolder;
delfile = delfile or getgenv().delfile;
listfiles = listfiles or getgenv().listfiles;
isfolder = isfolder or getgenv().isfolder;
isfile = isfile or getgenv().isfile;

local NeverLose = {};

NeverLose.BuiltInRegular = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json',Enum.FontWeight.Regular,Enum.FontStyle.Normal);
NeverLose.BuiltInBold = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json',Enum.FontWeight.Bold,Enum.FontStyle.Normal);
NeverLose.GlobalSignals = {};
NeverLose.UnloadEnabled = false;

local cloneref: cloneref = cloneref or function(f) return f end;
local TweenService: TweenService = cloneref(game:GetService('TweenService'));
local UserInputService: UserInputService = cloneref(game:GetService('UserInputService'));
local TextService: TextService = cloneref(game:GetService('TextService'));
local RunService: RunService = cloneref(game:GetService('RunService'));
local Players: Players = cloneref(game:GetService('Players'));
local HttpService: HttpService = cloneref(game:GetService('HttpService'));
local LocalPlayer: Player = Players.LocalPlayer;
local CoreGui: PlayerGui = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or cloneref(game:FindFirstChild('CoreGui')) or cloneref(LocalPlayer.PlayerGui);
local Mouse: Mouse = LocalPlayer:GetMouse();
local CurrentCamera: Camera = cloneref(workspace.CurrentCamera);
local ProtectGui = protect_gui or protectgui or (syn and syn.protect_gui) or function(s) return s; end;
local GlobalWindow = Instance.new('ScreenGui');
local ManualTween = TweenInfo.new(0.1);
local SlowyTween = TweenInfo.new(0.175);
local FastTween = TweenInfo.new(0.05);
local VSlowTween = TweenInfo.new(0.5,Enum.EasingStyle.Quint);
local Encryption = {};

NeverLose.UserProfile = Players:GetUserThumbnailAsync(LocalPlayer.UserId , Enum.ThumbnailType.HeadShot , Enum.ThumbnailSize.Size150x150)
NeverLose.RandomString = LPH_NO_VIRTUALIZE(function()
	return string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4));
end);

ProtectGui(GlobalWindow);

GlobalWindow.Name = NeverLose.RandomString();
GlobalWindow.IgnoreGuiInset = true;
GlobalWindow.ZIndexBehavior = Enum.ZIndexBehavior.Global;
GlobalWindow.ResetOnSpawn = false;
GlobalWindow.Parent = CoreGui;

NeverLose.Scales = {
	Small = UDim2.fromOffset(540,380),
	Mobile = UDim2.fromOffset(640,385),
	Default = UDim2.fromOffset(640 , 480),
	Large = UDim2.fromOffset(800 , 600)
};

NeverLose.IconColor = Color3.fromRGB(255, 255, 255);
NeverLose.ScreenGui = GlobalWindow;
NeverLose.Flags = {};
NeverLose.AccentColor = Color3.fromRGB(78, 127, 252);
NeverLose.MainColor = Color3.fromRGB(8, 8, 13);
NeverLose.RegisiteryColor = {};
NeverLose.NameRegisitry = {};
NeverLose.IsMosueOverOtherFrame = false;
NeverLose.GlobalLogo = "rbxassetid://120358385035996";
NeverLose.ImageColorMapping = "rbxassetid://4155801252";

if getcustomasset then
	local link = "https://github.com/4lpaca-pin/NeverLose/blob/main/assets/%s?raw=true";
	local dir = 'NLAssets';

	if not isfolder(dir) then
		makefolder(dir);
	end;

	pcall(function()
		if not isfile(dir..'/'..'logo.png') then
			local byte = game:HttpGet(string.format(link,'logo.png'));

			writefile(dir..'/'..'logo.png' , byte);
			task.wait();
		end;

		if isfile(dir..'/'..'logo.png') then
			NeverLose.GlobalLogo = getcustomasset(dir..'/'..'logo.png')
		end;
	end);

	pcall(function()
		if not isfile(dir..'/'..'saturation_value_gradient.png') then
			local byte = game:HttpGet(string.format(link,'saturation_value_gradient.png'));

			writefile(dir..'/'..'saturation_value_gradient.png' , byte);
			task.wait();
		end;

		if isfile(dir..'/'..'saturation_value_gradient.png') then
			NeverLose.ImageColorMapping = getcustomasset(dir..'/'..'saturation_value_gradient.png')
		end;
	end);
end;

function NeverLose:AddSignal(RBXSignal)
	if NeverLose.UnloadEnabled then
		table.insert(NeverLose.GlobalSignals,RBXSignal);
	end;

	return RBXSignal;
end;

function NeverLose:AddQuery(ItemRoot: Frame , Name : string)
	table.insert(NeverLose.NameRegisitry , {
		Root = ItemRoot,
		Idx = Name,
	});
end;

function Encryption.new(data: string)
	local bytes = {};
	local encrypt_seed = ((#data + 3782) % 111) + 1;

	string.gsub(data , '.', LPH_NO_VIRTUALIZE(function(dt)
		table.insert(bytes , tostring(dt:byte() + encrypt_seed));
	end));

	local concatbyte = table.concat(bytes,'?');

	table.clear(bytes);

	return "{"..tostring(encrypt_seed + 72667).."}?"..concatbyte;
end;

function Encryption.reverse(data: string)
	local main_data = string.split(data,'?');
	local seed_str = main_data[1]:gsub('{',''):gsub('}','');
	local seed = tonumber(seed_str);

	local ks = {};
	local real_seed = seed - 72667;

	for i,v in next , main_data do
		if i > 1 then
			local fake_byte = tonumber(v);
			table.insert(ks , string.char(fake_byte - real_seed))	
		end;
	end;

	local data = table.concat(ks);

	table.clear(ks);

	return data;
end;

do
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

	NeverLose.Base64Encode = LPH_NO_VIRTUALIZE(function(data)
		return ((data:gsub('.', function(x) 
			local r,b='',x:byte()
			for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
			return r;
		end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
			if (#x < 6) then return '' end
			local c=0
			for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
			return b:sub(c+1,c+1)
		end)..({ '', '==', '=' })[#data%3+1])
	end);

	NeverLose.Base64Decode = LPH_NO_VIRTUALIZE(function(data)
		data = string.gsub(data, '[^'..b..'=]', '')
		return (data:gsub('.', function(x)
			if (x == '=') then return '' end
			local r,f='',(b:find(x)-1)
			for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
			return r;
		end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
			if (#x ~= 8) then return '' end
			local c=0
			for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
			return string.char(c)
		end))
	end);
end;

NeverLose.LoadIcon = LPH_NO_VIRTUALIZE(function()
	NeverLose.RobloxIcon = {
		["3d-cube-arrow-left"] = "3d-cube-arrow-left",
		["amazon"] = "amazon",
		["arm-left"] = "arm-left",
		["arm-right"] = "arm-right",
		["arrow-curl-to-left"] = "arrow-curl-to-left",
		["arrow-curl-to-right"] = "arrow-curl-to-right",
		["arrow-down-to-line"] = "arrow-down-to-line",
		["arrow-large-down"] = "arrow-large-down",
		["arrow-large-left"] = "arrow-large-left",
		["arrow-large-right"] = "arrow-large-right",
		["arrow-large-up"] = "arrow-large-up",
		["arrow-right-from-portrait-rectangle"] = "arrow-right-from-portrait-rectangle",
		["arrow-right-to-portrait-rectangle"] = "arrow-right-to-portrait-rectangle",
		["arrow-rotate-down-dashed"] = "arrow-rotate-down-dashed",
		["arrow-rotate-right"] = "arrow-rotate-right",
		["arrow-rotate-right-dashed"] = "arrow-rotate-right-dashed",
		["arrow-small-down"] = "arrow-small-down",
		["arrow-small-left"] = "arrow-small-left",
		["arrow-small-right"] = "arrow-small-right",
		["arrow-small-up"] = "arrow-small-up",
		["arrow-spin-clockwise"] = "arrow-spin-clockwise",
		["arrow-spin-clockwise-10"] = "arrow-spin-clockwise-10",
		["arrow-spin-clockwise-15"] = "arrow-spin-clockwise-15",
		["arrow-spin-clockwise-30"] = "arrow-spin-clockwise-30",
		["arrow-spin-counter-clockwise-10"] = "arrow-spin-counter-clockwise-10",
		["arrow-spin-counter-clockwise-15"] = "arrow-spin-counter-clockwise-15",
		["arrow-spin-counter-clockwise-30"] = "arrow-spin-counter-clockwise-30",
		["arrow-thick-to-left"] = "arrow-thick-to-left",
		["arrow-thick-to-right"] = "arrow-thick-to-right",
		["arrow-up-from-landscape-rectangle"] = "arrow-up-from-landscape-rectangle",
		["arrow-up-right-from-square"] = "arrow-up-right-from-square",
		["arrow-wide-short-down"] = "arrow-wide-short-down",
		["arrow-wide-short-left"] = "arrow-wide-short-left",
		["arrow-wide-short-right"] = "arrow-wide-short-right",
		["arrow-wide-short-up"] = "arrow-wide-short-up",
		["arrows-small-directional"] = "arrows-small-directional",
		["audio-wave-dotted-line"] = "audio-wave-dotted-line",
		["backpack"] = "backpack",
		["beard"] = "beard",
		["bell"] = "bell",
		["bell-clock"] = "bell-clock",
		["bell-plus"] = "bell-plus",
		["bell-slash"] = "bell-slash",
		["belt"] = "belt",
		["binoculars"] = "binoculars",
		["book-closed"] = "book-closed",
		["bookmark"] = "bookmark",
		["bow-tie"] = "bow-tie",
		["building-store"] = "building-store",
		["bullet-flying"] = "bullet-flying",
		["butterfly-wings"] = "butterfly-wings",
		["calendar"] = "calendar",
		["calendar-plus"] = "calendar-plus",
		["calendar-star"] = "calendar-star",
		["camera-small"] = "camera-small",
		["caret-small-down"] = "caret-small-down",
		["caret-small-left"] = "caret-small-left",
		["caret-small-right"] = "caret-small-right",
		["caret-small-up"] = "caret-small-up",
		["chain-link"] = "chain-link",
		["chart-four-vertical-bars"] = "chart-four-vertical-bars",
		["chart-line"] = "chart-line",
		["chart-pie"] = "chart-pie",
		["chart-scatter-plot"] = "chart-scatter-plot",
		["chart-three-vertical-bars"] = "chart-three-vertical-bars",
		["check"] = "check",
		["check-large"] = "check-large",
		["check-small"] = "check-small",
		["chevron-large-down"] = "chevron-large-down",
		["chevron-large-down-to-line"] = "chevron-large-down-to-line",
		["chevron-large-left"] = "chevron-large-left",
		["chevron-large-left-to-line"] = "chevron-large-left-to-line",
		["chevron-large-right"] = "chevron-large-right",
		["chevron-large-right-to-line"] = "chevron-large-right-to-line",
		["chevron-large-up"] = "chevron-large-up",
		["chevron-large-up-to-line"] = "chevron-large-up-to-line",
		["chevron-small-down"] = "chevron-small-down",
		["chevron-small-down-to-line"] = "chevron-small-down-to-line",
		["chevron-small-left"] = "chevron-small-left",
		["chevron-small-left-to-line"] = "chevron-small-left-to-line",
		["chevron-small-right"] = "chevron-small-right",
		["chevron-small-right-to-line"] = "chevron-small-right-to-line",
		["chevron-small-up"] = "chevron-small-up",
		["chevron-small-up-to-line"] = "chevron-small-up-to-line",
		["circle-check"] = "circle-check",
		["circle-i"] = "circle-i",
		["circle-minus"] = "circle-minus",
		["circle-person"] = "circle-person",
		["circle-person-three-horizontal-bars-wrapping-right"] = "circle-person-three-horizontal-bars-wrapping-right",
		["circle-play"] = "circle-play",
		["circle-plus"] = "circle-plus",
		["circle-question"] = "circle-question",
		["circle-slash"] = "circle-slash",
		["circle-star"] = "circle-star",
		["circle-three-dots-horizontal"] = "circle-three-dots-horizontal",
		["circle-three-dots-vertical"] = "circle-three-dots-vertical",
		["circle-x"] = "circle-x",
		["clock"] = "clock",
		["clock-dashed"] = "clock-dashed",
		["clock-spin-reverse"] = "clock-spin-reverse",
		["clock-spin-reverse-dashed"] = "clock-spin-reverse-dashed",
		["clothes-hanger"] = "clothes-hanger",
		["cloud"] = "cloud",
		["cloud-arrow-down"] = "cloud-arrow-down",
		["code"] = "code",
		["compact-makeup-brush"] = "compact-makeup-brush",
		["compass"] = "compass",
		["controller-with-cog"] = "controller-with-cog",
		["crop"] = "crop",
		["crosshairs"] = "crosshairs",
		["crosshairs-slash"] = "crosshairs-slash",
		["cube-vertexes"] = "cube-vertexes",
		["curved-rectangle-megaphone"] = "curved-rectangle-megaphone",
		["diagonal-line-pattern"] = "diagonal-line-pattern",
		["diagonal-line-pattern-sticker"] = "diagonal-line-pattern-sticker",
		["diamond-simplified"] = "diamond-simplified",
		["discord"] = "discord",
		["disguise-nose-glasses"] = "disguise-nose-glasses",
		["document-circle-slash"] = "document-circle-slash",
		["document-list-heart"] = "document-list-heart",
		["door-open-arrow-to-bottom-right"] = "door-open-arrow-to-bottom-right",
		["dress"] = "dress",
		["dual-arrows-horizontal"] = "dual-arrows-horizontal",
		["dual-arrows-to-corners"] = "dual-arrows-to-corners",
		["dual-arrows-vertical"] = "dual-arrows-vertical",
		["envelope"] = "envelope",
		["eraser"] = "eraser",
		["eye"] = "eye",
		["eye-slash"] = "eye-slash",
		["eye-with-eyeliner"] = "eye-with-eyeliner",
		["eyebrows"] = "eyebrows",
		["eyelashes"] = "eyelashes",
		["face-winking"] = "face-winking",
		["facebook"] = "facebook",
		["file-box"] = "file-box",
		["fingerprint"] = "fingerprint",
		["flag"] = "flag",
		["flame"] = "flame",
		["folder"] = "folder",
		["fountain-pen-nib"] = "fountain-pen-nib",
		["four-bars-horizontal-center-aligned"] = "four-bars-horizontal-center-aligned",
		["four-bars-horizontal-chevron-left"] = "four-bars-horizontal-chevron-left",
		["four-bars-horizontal-chevron-right"] = "four-bars-horizontal-chevron-right",
		["four-bars-horizontal-justified-aligned"] = "four-bars-horizontal-justified-aligned",
		["four-bars-horizontal-left-aligned"] = "four-bars-horizontal-left-aligned",
		["four-bars-horizontal-right-aligned"] = "four-bars-horizontal-right-aligned",
		["frame-bubble-slash"] = "frame-bubble-slash",
		["frame-bubble-soundwave"] = "frame-bubble-soundwave",
		["frame-camera"] = "frame-camera",
		["frame-camera-center"] = "frame-camera-center",
		["frame-collapsed"] = "frame-collapsed",
		["frame-corners"] = "frame-corners",
		["frame-expanded"] = "frame-expanded",
		["frame-face"] = "frame-face",
		["frame-person-torso"] = "frame-person-torso",
		["frame-record"] = "frame-record",
		["frame-single-bar-horizontal"] = "frame-single-bar-horizontal",
		["frame-soundwave"] = "frame-soundwave",
		["frame-video-camera"] = "frame-video-camera",
		["gear"] = "gear",
		["generic-dpad"] = "generic-dpad",
		["gift-box"] = "gift-box",
		["gift-card"] = "gift-card",
		["glasses"] = "glasses",
		["globe-detailed"] = "globe-detailed",
		["globe-simplified"] = "globe-simplified",
		["globe-simplipfied-speech-bubble"] = "globe-simplipfied-speech-bubble",
		["grid"] = "grid",
		["guilded"] = "guilded",
		["hack-week"] = "hack-week",
		["hammer-code"] = "hammer-code",
		["hand-curved-arrow-left"] = "hand-curved-arrow-left",
		["hand-dual-arrows"] = "hand-dual-arrows",
		["hand-ellipse"] = "hand-ellipse",
		["hand-half-ellipse"] = "hand-half-ellipse",
		["hand-two-arrows-horizontal"] = "hand-two-arrows-horizontal",
		["hashtag"] = "hashtag",
		["hat-fedora"] = "hat-fedora",
		["hat-toque"] = "hat-toque",
		["head-blank"] = "head-blank",
		["head-blush"] = "head-blush",
		["head-female"] = "head-female",
		["head-freckles"] = "head-freckles",
		["head-lips"] = "head-lips",
		["head-male"] = "head-male",
		["headphones"] = "headphones",
		["headphones-arrow-up"] = "headphones-arrow-up",
		["headphones-arrow-up-lock"] = "headphones-arrow-up-lock",
		["headphones-slash"] = "headphones-slash",
		["headphones-x"] = "headphones-x",
		["headphones-x-lock"] = "headphones-x-lock",
		["heart"] = "heart",
		["house"] = "house",
		["image"] = "image",
		["image-stacked"] = "image-stacked",
		["instagram"] = "instagram",
		["jacket"] = "jacket",
		["key"] = "key",
		["key-alt"] = "key-alt",
		["key-apostrophe"] = "key-apostrophe",
		["key-arrow-down"] = "key-arrow-down",
		["key-arrow-right"] = "key-arrow-right",
		["key-arrow-up"] = "key-arrow-up",
		["key-asterisk"] = "key-asterisk",
		["key-backspace"] = "key-backspace",
		["key-caps-lock"] = "key-caps-lock",
		["key-caret"] = "key-caret",
		["key-comma"] = "key-comma",
		["key-command"] = "key-command",
		["key-control"] = "key-control",
		["key-grave-accent"] = "key-grave-accent",
		["key-period"] = "key-period",
		["key-return"] = "key-return",
		["key-shift"] = "key-shift",
		["key-space"] = "key-space",
		["key-tab"] = "key-tab",
		["language-characters"] = "language-characters",
		["leg-left"] = "leg-left",
		["leg-right"] = "leg-right",
		["lightning-bolt"] = "lightning-bolt",
		["linkedin"] = "linkedin",
		["lips"] = "lips",
		["lipstick"] = "lipstick",
		["list-bulleted"] = "list-bulleted",
		["location-pin"] = "location-pin",
		["location-pin-map"] = "location-pin-map",
		["lock-closed"] = "lock-closed",
		["lollipop"] = "lollipop",
		["magnifying-glass"] = "magnifying-glass",
		["magnifying-glass-minus"] = "magnifying-glass-minus",
		["magnifying-glass-plus"] = "magnifying-glass-plus",
		["mascara"] = "mascara",
		["megaphone"] = "megaphone",
		["memory-card"] = "memory-card",
		["messenger"] = "messenger",
		["microphone"] = "microphone",
		["microphone-slash"] = "microphone-slash",
		["microphone-text-box"] = "microphone-text-box",
		["microphone-triangle-exclamation"] = "microphone-triangle-exclamation",
		["minus"] = "minus",
		["minus-small"] = "minus-small",
		["mirror-standing"] = "mirror-standing",
		["moments"] = "moments",
		["moon"] = "moon",
		["mouse-button-left"] = "mouse-button-left",
		["mouse-button-right"] = "mouse-button-right",
		["mouse-scrollwheel"] = "mouse-scrollwheel",
		["music-note"] = "music-note",
		["nebula"] = "nebula",
		["necklace"] = "necklace",
		["nine-dots-grid"] = "nine-dots-grid",
		["ninja"] = "ninja",
		["nose"] = "nose",
		["page"] = "page",
		["paint-brush"] = "paint-brush",
		["paint-bucket"] = "paint-bucket",
		["pants"] = "pants",
		["pants-2d-text"] = "pants-2d-text",
		["paper-airplane"] = "paper-airplane",
		["parrot"] = "parrot",
		["pause-large"] = "pause-large",
		["pause-small"] = "pause-small",
		["pencil"] = "pencil",
		["pencil-square"] = "pencil-square",
		["person"] = "person",
		["person-arrow-from-bottom-right"] = "person-arrow-from-bottom-right",
		["person-check"] = "person-check",
		["person-circle-slash"] = "person-circle-slash",
		["person-climbing"] = "person-climbing",
		["person-clock"] = "person-clock",
		["person-falling"] = "person-falling",
		["person-graduate"] = "person-graduate",
		["person-jumping"] = "person-jumping",
		["person-magnifying-glass"] = "person-magnifying-glass",
		["person-photo-camera"] = "person-photo-camera",
		["person-play"] = "person-play",
		["person-play-clock"] = "person-play-clock",
		["person-plus"] = "person-plus",
		["person-racing"] = "person-racing",
		["person-running"] = "person-running",
		["person-standing"] = "person-standing",
		["person-standing-arrow-reverse"] = "person-standing-arrow-reverse",
		["person-standing-dual-arrows-vertical"] = "person-standing-dual-arrows-vertical",
		["person-standing-gear"] = "person-standing-gear",
		["person-swimming"] = "person-swimming",
		["person-teleport"] = "person-teleport",
		["person-trash-can"] = "person-trash-can",
		["person-walking"] = "person-walking",
		["person-with-smaller-person"] = "person-with-smaller-person",
		["phone"] = "phone",
		["phone-down"] = "phone-down",
		["phone-plus"] = "phone-plus",
		["phone-volume"] = "phone-volume",
		["phone-x"] = "phone-x",
		["photo-camera"] = "photo-camera",
		["photo-camera-face"] = "photo-camera-face",
		["photo-camera-slash"] = "photo-camera-slash",
		["picture-in-picture"] = "picture-in-picture",
		["pig"] = "pig",
		["pin"] = "pin",
		["pin-slash"] = "pin-slash",
		["play-large"] = "play-large",
		["play-small"] = "play-small",
		["plus-large"] = "plus-large",
		["plus-small"] = "plus-small",
		["premium"] = "premium",
		["ps-circle"] = "ps-circle",
		["ps-dpad-down"] = "ps-dpad-down",
		["ps-dpad-left"] = "ps-dpad-left",
		["ps-dpad-right"] = "ps-dpad-right",
		["ps-dpad-up"] = "ps-dpad-up",
		["ps-l1"] = "ps-l1",
		["ps-l2"] = "ps-l2",
		["ps-l3"] = "ps-l3",
		["ps-r1"] = "ps-r1",
		["ps-r2"] = "ps-r2",
		["ps-r3"] = "ps-r3",
		["ps-square"] = "ps-square",
		["ps-stick-left"] = "ps-stick-left",
		["ps-stick-right"] = "ps-stick-right",
		["ps-triagle"] = "ps-triagle",
		["ps-x"] = "ps-x",
		["ps4-options"] = "ps4-options",
		["ps4-share"] = "ps4-share",
		["ps4-touchpad"] = "ps4-touchpad",
		["ps5-options"] = "ps5-options",
		["ps5-share"] = "ps5-share",
		["ps5-touchpad"] = "ps5-touchpad",
		["pumpkin"] = "pumpkin",
		["purse"] = "purse",
		["rectangle-list"] = "rectangle-list",
		["rectangle-numbers-counting"] = "rectangle-numbers-counting",
		["rectangle-person-with-three-horizontal-lines"] = "rectangle-person-with-three-horizontal-lines",
		["robux"] = "robux",
		["rosette-seven-point"] = "rosette-seven-point",
		["rosette-ten-point"] = "rosette-ten-point",
		["seven-point-rosette"] = "seven-point-rosette",
		["shield-check"] = "shield-check",
		["shield-lock"] = "shield-lock",
		["shirt"] = "shirt",
		["shirt-2d-text"] = "shirt-2d-text",
		["shirt-pants"] = "shirt-pants",
		["shoe-left"] = "shoe-left",
		["shoe-right"] = "shoe-right",
		["shopping-basket"] = "shopping-basket",
		["shopping-basket-check"] = "shopping-basket-check",
		["shopping-cart"] = "shopping-cart",
		["shorts"] = "shorts",
		["sidebar"] = "sidebar",
		["signal-exclamation"] = "signal-exclamation",
		["six-dots-two-column-grid"] = "six-dots-two-column-grid",
		["skip-end-large"] = "skip-end-large",
		["skip-end-small"] = "skip-end-small",
		["skip-next-large"] = "skip-next-large",
		["skip-next-small"] = "skip-next-small",
		["skip-previous-large"] = "skip-previous-large",
		["skip-previous-small"] = "skip-previous-small",
		["skip-start-large"] = "skip-start-large",
		["skip-start-small"] = "skip-start-small",
		["smartphone-portrait"] = "smartphone-portrait",
		["speaker"] = "speaker",
		["speaker-slash"] = "speaker-slash",
		["speaker-triangle-exclamation"] = "speaker-triangle-exclamation",
		["speaker-x"] = "speaker-x",
		["speech-bubble-align-center"] = "speech-bubble-align-center",
		["speech-bubble-align-left"] = "speech-bubble-align-left",
		["speech-bubble-exclamation"] = "speech-bubble-exclamation",
		["speech-bubble-round"] = "speech-bubble-round",
		["square-bone"] = "square-bone",
		["square-books"] = "square-books",
		["square-check"] = "square-check",
		["square-code"] = "square-code",
		["square-dashed-person-standing"] = "square-dashed-person-standing",
		["square-dual-arrows-horizontal"] = "square-dual-arrows-horizontal",
		["square-dual-arrows-to-corner"] = "square-dual-arrows-to-corner",
		["square-face-sound"] = "square-face-sound",
		["square-face-waving-hand"] = "square-face-waving-hand",
		["square-face-winking"] = "square-face-winking",
		["square-minus"] = "square-minus",
		["square-person"] = "square-person",
		["squares-grid-plus"] = "squares-grid-plus",
		["squares-grid-qr"] = "squares-grid-qr",
		["stacked-squares-arrow-down-left"] = "stacked-squares-arrow-down-left",
		["stacked-squares-arrow-up-right"] = "stacked-squares-arrow-up-right",
		["stacked-squares-plus"] = "stacked-squares-plus",
		["star"] = "star",
		["stop-large"] = "stop-large",
		["stop-small"] = "stop-small",
		["studio"] = "studio",
		["sun"] = "sun",
		["sweater"] = "sweater",
		["sword"] = "sword",
		["tag-sparkle"] = "tag-sparkle",
		["teletype"] = "teletype",
		["tencent-qq"] = "tencent-qq",
		["text-b-bold"] = "text-b-bold",
		["text-box-microphone"] = "text-box-microphone",
		["text-h-subscript-1"] = "text-h-subscript-1",
		["text-h-subscript-2"] = "text-h-subscript-2",
		["text-h-subscript-3"] = "text-h-subscript-3",
		["text-i-italic"] = "text-i-italic",
		["text-s-strikethrough"] = "text-s-strikethrough",
		["text-u-underline"] = "text-u-underline",
		["text-uppercase-a-lowercase-a"] = "text-uppercase-a-lowercase-a",
		["text-x-subscript-2"] = "text-x-subscript-2",
		["text-x-superscript-2"] = "text-x-superscript-2",
		["three-bars-horizontal"] = "three-bars-horizontal",
		["three-bars-horizontal-chevron-left"] = "three-bars-horizontal-chevron-left",
		["three-bars-horizontal-narrowing"] = "three-bars-horizontal-narrowing",
		["three-bars-horizontal-triangles-vertical"] = "three-bars-horizontal-triangles-vertical",
		["three-bars-vertical-triangles-horizontal"] = "three-bars-vertical-triangles-horizontal",
		["three-chevrons-enlarging-down"] = "three-chevrons-enlarging-down",
		["three-chevrons-enlarging-up"] = "three-chevrons-enlarging-up",
		["three-dots-horizontal"] = "three-dots-horizontal",
		["three-dots-vertical"] = "three-dots-vertical",
		["three-horizontal-bars-wrapping-right"] = "three-horizontal-bars-wrapping-right",
		["three-people"] = "three-people",
		["three-ring-note"] = "three-ring-note",
		["three-sliders-horizontal"] = "three-sliders-horizontal",
		["three-stacked-squares-tilted"] = "three-stacked-squares-tilted",
		["thumb-down"] = "thumb-down",
		["thumb-up"] = "thumb-up",
		["tik-tok"] = "tik-tok",
		["tilt"] = "tilt",
		["torso"] = "torso",
		["trash-can"] = "trash-can",
		["triangle-exclamation"] = "triangle-exclamation",
		["trophy"] = "trophy",
		["tshirt"] = "tshirt",
		["tshirt-2d-text"] = "tshirt-2d-text",
		["tshirt-dual-arrows"] = "tshirt-dual-arrows",
		["twitch"] = "twitch",
		["twitter"] = "twitter",
		["two-arrows-down-and-up"] = "two-arrows-down-and-up",
		["two-arrows-from-center"] = "two-arrows-from-center",
		["two-arrows-left-right"] = "two-arrows-left-right",
		["two-arrows-loop-clockwise"] = "two-arrows-loop-clockwise",
		["two-arrows-loop-clockwise-1"] = "two-arrows-loop-clockwise-1",
		["two-arrows-loop-clockwise-infinity"] = "two-arrows-loop-clockwise-infinity",
		["two-arrows-spin-clockwise"] = "two-arrows-spin-clockwise",
		["two-arrows-spin-clockwise-plus"] = "two-arrows-spin-clockwise-plus",
		["two-arrows-switch-right"] = "two-arrows-switch-right",
		["two-arrows-to-center"] = "two-arrows-to-center",
		["two-folders"] = "two-folders",
		["two-location-pins-connecting-arrow"] = "two-location-pins-connecting-arrow",
		["two-makeup-brushes"] = "two-makeup-brushes",
		["two-people"] = "two-people",
		["two-people-speech-bubble"] = "two-people-speech-bubble",
		["two-stacked-squares"] = "two-stacked-squares",
		["two-switches-horizontal"] = "two-switches-horizontal",
		["verified-backplate"] = "verified-backplate",
		["verified-check"] = "verified-check",
		["verified-mono"] = "verified-mono",
		["video-camera"] = "video-camera",
		["video-camera-arrow-to-bottom-left"] = "video-camera-arrow-to-bottom-left",
		["video-camera-arrow-to-top-right"] = "video-camera-arrow-to-top-right",
		["video-camera-slash"] = "video-camera-slash",
		["video-camera-triangle-exclamation"] = "video-camera-triangle-exclamation",
		["video-camera-x"] = "video-camera-x",
		["wallet"] = "wallet",
		["we-chat"] = "we-chat",
		["whatsapp"] = "whatsapp",
		["x"] = "x",
		["x-small"] = "x-small",
		["xbox-a"] = "xbox-a",
		["xbox-a-pressed"] = "xbox-a-pressed",
		["xbox-a-unpressed"] = "xbox-a-unpressed",
		["xbox-b"] = "xbox-b",
		["xbox-dpad"] = "xbox-dpad",
		["xbox-dpad-down"] = "xbox-dpad-down",
		["xbox-dpad-left"] = "xbox-dpad-left",
		["xbox-dpad-right"] = "xbox-dpad-right",
		["xbox-dpad-up"] = "xbox-dpad-up",
		["xbox-lb"] = "xbox-lb",
		["xbox-lt"] = "xbox-lt",
		["xbox-menu"] = "xbox-menu",
		["xbox-rb"] = "xbox-rb",
		["xbox-rt"] = "xbox-rt",
		["xbox-stick-left"] = "xbox-stick-left",
		["xbox-stick-left-directional"] = "xbox-stick-left-directional",
		["xbox-stick-left-horizontal"] = "xbox-stick-left-horizontal",
		["xbox-stick-left-vertical"] = "xbox-stick-left-vertical",
		["xbox-stick-right"] = "xbox-stick-right",
		["xbox-stick-right-directional"] = "xbox-stick-right-directional",
		["xbox-stick-right-horizontal"] = "xbox-stick-right-horizontal",
		["xbox-stick-right-vertical"] = "xbox-stick-right-vertical",
		["xbox-view"] = "xbox-view",
		["xbox-x"] = "xbox-x",
		["xbox-y"] = "xbox-y",
		["xr-headset"] = "xr-headset",
		["youtube"] = "youtube"
	};
end);

NeverLose.IsMouseOverFrame = LPH_NO_VIRTUALIZE(function(self , Frame)
	if not Frame then
		return;
	end;

	if NeverLose.Global3DRenderMode then
		if Frame.GuiState == Enum.GuiState.Hover or Frame.GuiState == Enum.GuiState.Press then
			return true;
		end;

		return false;
	end;

	local AbsPos: Vector2, AbsSize: Vector2 = Frame.AbsolutePosition, Frame.AbsoluteSize;

	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
		return true;
	end;
end);

NeverLose.CreateSignal = LPH_NO_VIRTUALIZE(function(self , DefaultValue)
	local __cache = Instance.new('BindableEvent');
	local bind = {
		Value = DefaultValue,
		__event = __cache
	};

	function bind:GetValue()
		return bind.Value;
	end;

	function bind:SetValue(f)
		bind.Value = f;

		return __cache:Fire(f);
	end;

	function bind:Connect(f)
		local signal = __cache.Event:Connect(f);

		NeverLose:AddSignal(signal);

		return signal;
	end;

	return bind;
end);

NeverLose.SetIconMode = LPH_NO_VIRTUALIZE(function(self , Label: TextLabel , Icon: string)
	local useBold = string.lower(string.sub(Icon , -5)) == '-bold';

	if useBold then
		Label.Text = Icon:sub(1,-6);
		Label.FontFace = NeverLose.BuiltInBold;
	else
		Label.Text = Icon;
		Label.FontFace = NeverLose.BuiltInRegular;
	end;
end);

function NeverLose:GetIconFont(icon: string)
	local useBold = string.lower(string.sub(icon , -5)) == '-bold';

	if useBold then
		return NeverLose.BuiltInBold;
	end;

	return NeverLose.BuiltInRegular;
end;

function NeverLose:MoreThanHalfY(Value: number)
	return (NeverLose.ScreenGui.AbsoluteSize.Y / 2) < Value
end;

NeverLose.IsStudio = RunService:IsStudio();
NeverLose.IsMobile = UserInputService.TouchEnabled;

NeverLose.CreateInput = LPH_NO_VIRTUALIZE(function(self , Frame , Callback)
	local Button = Instance.new('ImageButton',Frame);

	Button.ZIndex = Frame.ZIndex + 10;
	Button.Size = UDim2.fromScale(1,1);
	Button.BackgroundTransparency = 1;
	Button.ImageTransparency = 1;
	Button.Image = "rbxasset://textuers/translateIcon.png";

	if Callback then
		local bth_signal = Button.MouseButton1Click:Connect(Callback);

		return Button , bth_signal;
	end;

	return Button;
end);

NeverLose.PlayAnimate = LPH_NO_VIRTUALIZE(function(Self , Info , Property)
	local Tween = TweenService:Create(Self , Info or TweenInfo.new(0.25) , Property);

	Tween:Play();

	return Tween;
end);

NeverLose.Drag = LPH_NO_VIRTUALIZE(function(InputFrame: Frame, MoveFrame: Frame, Speed : number)
	local dragToggle: boolean = false;
	local dragStart: Vector3 = nil;
	local startPos: UDim2 = nil;
	local Tween = TweenInfo.new(Speed);

	local updateInput = function(input)
		local delta = input.Position - dragStart;
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y);

		if NeverLose.Global3DRenderMode then
			NeverLose.PlayAnimate(MoveFrame,Tween,{
				Position = UDim2.fromScale(0.5,0.5)
			});
		else
			NeverLose.PlayAnimate(MoveFrame,Tween,{
				Position = position
			});
		end;
	end;

	NeverLose:AddSignal(InputFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true;
			dragStart = input.Position;
			startPos = MoveFrame.Position;

			local input_end;
			input_end = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false;

					input_end:Disconnect();
				end
			end)
		end
	end));

	NeverLose:AddSignal(UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end));
end);

NeverLose.Rounding = LPH_NO_VIRTUALIZE(function(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end);

NeverLose.ProcessParams = LPH_NO_VIRTUALIZE(function(self , Params , Fixed)
	Params = Params or {};

	local k = Params or {};

	for i,v in next , Fixed do
		k[i] = Params[i] or v;
	end;

	table.clear(Fixed);

	return k;
end);

NeverLose.AutoAssignFlag = LPH_NO_VIRTUALIZE(function(Config, Fallback)
	Fallback = Fallback or "option";

	if Config.Flag then
		return Config.Flag;
	end;

	local base = tostring(Config.Text or Fallback):gsub("[^%w_%-]","_"):gsub("_+","_"):gsub("^_",""):gsub("_$","");
	if base == "" then base = Fallback end;

	local flag = base;
	local n = 1;
	while NeverLose.Flags[flag] do
		n += 1;
		flag = base .. "_" .. n;
	end;

	Config.Flag = flag;
	return flag;
end);

NeverLose.EnabledBlur = true;
NeverLose.BlurModuleParent = workspace.CurrentCamera;

NeverLose.GetCalculatePosition = LPH_NO_VIRTUALIZE(function(planePos, planeNormal, rayOrigin, rayDirection)
	local n = planeNormal;
	local d = rayDirection;
	local v = rayOrigin - planePos;

	local num = (n.x * v.x) + (n.y * v.y) + (n.z * v.z);
	local den = (n.x * d.x) + (n.y * d.y) + (n.z * d.z);
	local a = -num / den;

	return rayOrigin + (a * rayDirection);
end);

NeverLose.CreateBlurModule = LPH_NO_VIRTUALIZE(function(self , Frame , Signal)
	if not NeverLose.EnabledBlur then
		return NeverLose:AddSignal(Instance.new('BindableEvent').Event:Connect(function() return "nl"; end));	
	end;

	local Part = Instance.new('Part',NeverLose.BlurModuleParent);
	local DepthOfField = Instance.new('DepthOfFieldEffect',cloneref(game:GetService('Lighting')));
	local BlockMesh = Instance.new("BlockMesh");

	BlockMesh.Parent = Part;

	Part.Material = Enum.Material.Glass;
	Part.Transparency = 1;
	Part.Reflectance = 1;
	Part.CastShadow = false;
	Part.Anchored = true;
	Part.CanCollide = false;
	Part.CanQuery = false;
	Part.CollisionGroup = NeverLose.RandomString();
	Part.Size = Vector3.new(1, 1, 1) * 0.01;
	Part.Color = Color3.fromRGB(0,0,0);

	DepthOfField.Enabled = true;
	DepthOfField.FarIntensity = 0;
	DepthOfField.FocusDistance = 0;
	DepthOfField.InFocusRadius = 1000;
	DepthOfField.NearIntensity = 1;
	DepthOfField.Name = NeverLose.RandomString();

	Part.Name = NeverLose.RandomString();

	local disconnect;

	local UpdateFunction = function()
		local IsWindowActive = Signal:GetValue();

		if IsWindowActive and not NeverLose.Global3DRenderMode then

			NeverLose.PlayAnimate(DepthOfField,TweenInfo.new(0.1),{
				NearIntensity = 1
			})

			NeverLose.PlayAnimate(Part,TweenInfo.new(0.1),{
				Transparency = 0.97,
				Size = Vector3.new(1, 1, 1) * 0.01;
			})

			Part.Parent = NeverLose.BlurModuleParent;
		else
			NeverLose.PlayAnimate(DepthOfField,TweenInfo.new(0.1),{
				NearIntensity = 0
			})

			NeverLose.PlayAnimate(Part,TweenInfo.new(0.1),{
				Size = Vector3.zero,
				Transparency = 1.5,
			})

			Part.Parent = nil;

			return false;
		end;

		if IsWindowActive then
			local corner0 = Frame.AbsolutePosition;
			local corner1 = corner0 + Frame.AbsoluteSize;

			local ray0 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner0.X, corner0.Y, 1);
			local ray1 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner1.X, corner1.Y, 1);

			local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ);

			local planeNormal = CurrentCamera.CFrame.LookVector;

			local pos0 = NeverLose.GetCalculatePosition(planeOrigin, planeNormal, ray0.Origin, ray0.Direction);
			local pos1 = NeverLose.GetCalculatePosition(planeOrigin, planeNormal, ray1.Origin, ray1.Direction);

			pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0);
			pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1);

			local size   = pos1 - pos0;
			local center = (pos0 + pos1) / 2;

			BlockMesh.Offset = center
			BlockMesh.Scale  = size / 0.0101;
			Part.CFrame = CurrentCamera.CFrame;
		end;
	end;

	local rbxsignal = NeverLose:AddSignal(CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(UpdateFunction))
	local loopThread = NeverLose:AddSignal(UserInputService.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			pcall(UpdateFunction);
		end;
	end));

	local THREAD = task.spawn(function()
		while true do task.wait(0.1)
			pcall(UpdateFunction);
		end;
	end);

	disconnect = function()
		rbxsignal:Disconnect();
		loopThread:Disconnect();
		task.cancel(THREAD);
		Part:Destroy();
		DepthOfField:Destroy();
	end;

	Frame.Destroying:Connect(disconnect);

	return rbxsignal;
end);

local EmptyFunction = function() end;

function NeverLose:RollingEffect(parent)
	local UIGradient = Instance.new("UIGradient")

	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.4), NumberSequenceKeypoint.new(1.00, 0.00)}
	UIGradient.Parent = parent

	return UIGradient;
end;

function NeverLose:CreateShadow(parent , RollingEffect)
	local Shadow = {};

	local UIShadowSafe85 = Instance.new("UIStroke")
	local UIShadowSafe65 = Instance.new("UIStroke")
	local UIShadowSafe50 = Instance.new("UIStroke")
	local UIShadowSafe45 = Instance.new("UIStroke")

	UIShadowSafe85.Thickness = 6.000
	UIShadowSafe85.Transparency = 1
	UIShadowSafe85.Parent = parent

	UIShadowSafe65.Thickness = 5.000
	UIShadowSafe65.Transparency = 1
	UIShadowSafe65.Parent = parent

	UIShadowSafe50.Thickness = 4.000
	UIShadowSafe50.Transparency = 1
	UIShadowSafe50.Parent = parent

	UIShadowSafe45.Thickness = 3.000
	UIShadowSafe45.Transparency = 1
	UIShadowSafe45.Parent = parent

	local RollingEffectThread;
	local r1,r2,r3,r4;

	if RollingEffect then
		r1 = NeverLose:RollingEffect(UIShadowSafe85);
		r2 = NeverLose:RollingEffect(UIShadowSafe65);
		r3 = NeverLose:RollingEffect(UIShadowSafe50);
		r4 = NeverLose:RollingEffect(UIShadowSafe45);
	end;

	Shadow.Render = LPH_NO_VIRTUALIZE(function(self , value)
		if RollingEffectThread then
			task.cancel(RollingEffectThread);
			RollingEffectThread = nil;
		end;

		if value then
			NeverLose.PlayAnimate(UIShadowSafe85 , SlowyTween , {
				Transparency = 0.900
			})

			NeverLose.PlayAnimate(UIShadowSafe65 , SlowyTween , {
				Transparency = 0.900
			})

			NeverLose.PlayAnimate(UIShadowSafe50 , SlowyTween , {
				Transparency = 0.900
			})

			NeverLose.PlayAnimate(UIShadowSafe45 , SlowyTween , {
				Transparency = 0.900
			})

			if RollingEffect then
				RollingEffectThread = task.spawn(function()
					local level = 20;
					while true do task.wait(0.025)
						NeverLose.PlayAnimate(r1 , SlowyTween , {
							Rotation = r1.Rotation + level
						});

						NeverLose.PlayAnimate(r2 , SlowyTween , {
							Rotation = r2.Rotation + level
						});

						NeverLose.PlayAnimate(r3 , SlowyTween , {
							Rotation = r3.Rotation + level
						});

						NeverLose.PlayAnimate(r4 , SlowyTween , {
							Rotation = r4.Rotation + level
						});
					end;
				end);
			end;
		else
			NeverLose.PlayAnimate(UIShadowSafe85 , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(UIShadowSafe65 , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(UIShadowSafe50 , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(UIShadowSafe45 , SlowyTween , {
				Transparency = 1
			})
		end;
	end);

	return Shadow;
end;

function NeverLose:CreateOptionWindow(Frame: Frame , Zindex)
	Zindex = Zindex or 9;

	local Window = {
		Signal = NeverLose:CreateSignal(false),
	};

	local OptionHandler = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIListLayout = Instance.new("UIListLayout")
	local UIStroke = Instance.new("UIStroke")
	local shadow = NeverLose:CreateShadow(OptionHandler);

	OptionHandler.Name = NeverLose.RandomString();
	OptionHandler.Parent = NeverLose.ScreenGui
	OptionHandler.AnchorPoint = Vector2.new(0, 0)
	OptionHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
	OptionHandler.BackgroundTransparency = 0.035
	OptionHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OptionHandler.BorderSizePixel = 0
	OptionHandler.ClipsDescendants = true
	OptionHandler.Position = UDim2.new(255,255,255,255)
	OptionHandler.Size = UDim2.new(0, 220, 0, 75)
	OptionHandler.ZIndex = Zindex + 9

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = OptionHandler

	UIListLayout.Parent = OptionHandler
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	UIStroke.Transparency = 0.650
	UIStroke.Color = Color3.fromRGB(45, 48, 58)
	UIStroke.Parent = OptionHandler

	NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
		NeverLose.PlayAnimate(OptionHandler , SlowyTween , {
			Size = UDim2.new(0, 220, 0, UIListLayout.AbsoluteContentSize.Y - 1)
		})
	end)));

	NeverLose:AddSignal(OptionHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
		if OptionHandler.BackgroundTransparency > 0.9 then
			OptionHandler.Visible = false;
			UIListLayout.Parent = nil;
			OptionHandler.Parent = nil;
		else
			OptionHandler.Visible = true;
			UIListLayout.Parent = OptionHandler

			if NeverLose.Global3DRenderMode then
				OptionHandler.Parent = NeverLose.GlobalSurfaceGui;
			else
				OptionHandler.Parent = NeverLose.ScreenGui;
			end;
		end
	end)));

	local FollowingThread;
	local SetPosition = LPH_NO_VIRTUALIZE(function()
		if NeverLose:MoreThanHalfY(Frame.AbsolutePosition.Y + 65) then
			OptionHandler.AnchorPoint = Vector2.new(0,1)
		else
			OptionHandler.AnchorPoint = Vector2.new(0,0)
		end;

		OptionHandler.Position = UDim2.fromOffset(Frame.AbsolutePosition.X + 18 , Frame.AbsolutePosition.Y + 65);
	end);

	Window.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if FollowingThread then
			task.cancel(FollowingThread);
			FollowingThread = nil;
		end;

		if value then
			SetPosition();

			NeverLose.PlayAnimate(OptionHandler , SlowyTween , {
				BackgroundTransparency = 0.035
			})

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 0.650
			})

			shadow:Render(true);

			if NeverLose.Global3DRenderMode then
				OptionHandler.Parent = NeverLose.GlobalSurfaceGui;
			else
				OptionHandler.Parent = NeverLose.ScreenGui;
			end;

			FollowingThread = task.spawn(function()
				while true do task.wait()
					SetPosition();
				end
			end)
		else
			NeverLose.PlayAnimate(OptionHandler , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			})

			shadow:Render(false);
		end;
	end);

	Window.SetRender(false);
	Window.Signal:Connect(Window.SetRender)

	local Payback = NeverLose:RegisiterItem(OptionHandler , Window.Signal);

	Payback.Winbdow = Window;
	Payback.Root = OptionHandler;
	Payback.Signal = Window.Signal;

	return Payback;
end;

function NeverLose:CreateColorPicker(HandleFrame: Frame)
	local ZIndex = HandleFrame.ZIndex;

	local ColorPickerLib = {};

	local ColorPickerHandler = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local SaViMap = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local ColorZoneSelection = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local ColorMap = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_4 = Instance.new("UICorner")
	local ColorMapSelection = Instance.new("Frame")
	local UIStroke_3 = Instance.new("UIStroke")
	local UICorner_5 = Instance.new("UICorner")
	local RGBLabel = Instance.new("TextLabel")
	local UICorner_6 = Instance.new("UICorner")
	local Shadow = NeverLose:CreateShadow(ColorPickerHandler);

	ColorPickerHandler.Name = NeverLose.RandomString();
	ColorPickerHandler.Parent = NeverLose.ScreenGui
	ColorPickerHandler.AnchorPoint = Vector2.new(0, 0)
	ColorPickerHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
	ColorPickerHandler.BackgroundTransparency = 0.035
	ColorPickerHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPickerHandler.BorderSizePixel = 0
	ColorPickerHandler.ClipsDescendants = true
	ColorPickerHandler.Position = UDim2.new(255, 0, 255, 20)
	ColorPickerHandler.Size = UDim2.new(0, 200, 0, 240)
	ColorPickerHandler.ZIndex = ZIndex + 125

	NeverLose:AddSignal(ColorPickerHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
		if ColorPickerHandler.BackgroundTransparency > 0.9 then
			ColorPickerHandler.Visible = false;
			ColorPickerHandler.Parent = nil
		else
			ColorPickerHandler.Visible = true;

			if NeverLose.Global3DRenderMode then
				ColorPickerHandler.Parent = NeverLose.GlobalSurfaceGui;
			else
				ColorPickerHandler.Parent = NeverLose.ScreenGui;
			end;
		end;
	end)));

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = ColorPickerHandler

	UIStroke.Transparency = 0.650
	UIStroke.Color = Color3.fromRGB(45, 48, 58)
	UIStroke.Parent = ColorPickerHandler

	SaViMap.Name = NeverLose.RandomString();
	SaViMap.Parent = ColorPickerHandler
	SaViMap.AnchorPoint = Vector2.new(0.5, 0)
	SaViMap.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
	SaViMap.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SaViMap.BorderSizePixel = 0
	SaViMap.Position = UDim2.new(0.5, 0, 0, 5)
	SaViMap.Size = UDim2.new(0, 185, 0, 185)
	SaViMap.ZIndex = ZIndex + 126
	SaViMap.Image = NeverLose.ImageColorMapping -- UNSAFE IMAGE

	UICorner_2.CornerRadius = UDim.new(0, 5)
	UICorner_2.Parent = SaViMap

	ColorZoneSelection.Name = NeverLose.RandomString();
	ColorZoneSelection.Parent = SaViMap
	ColorZoneSelection.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorZoneSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorZoneSelection.BackgroundTransparency = 1.000
	ColorZoneSelection.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorZoneSelection.BorderSizePixel = 0
	ColorZoneSelection.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorZoneSelection.Size = UDim2.new(0, 10, 0, 10)
	ColorZoneSelection.ZIndex = ZIndex + 127

	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = ColorZoneSelection

	UIStroke_2.Color = Color3.fromRGB(255, 255, 255)
	UIStroke_2.Parent = ColorZoneSelection

	ColorMap.Name = NeverLose.RandomString();
	ColorMap.Parent = ColorPickerHandler
	ColorMap.AnchorPoint = Vector2.new(0.5, 0)
	ColorMap.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorMap.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorMap.BorderSizePixel = 0
	ColorMap.Position = UDim2.new(0.5, 0, 0, 200)
	ColorMap.Size = UDim2.new(1, -15, 0, 10)
	ColorMap.ZIndex = ZIndex + 126

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(203, 255, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(50, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 101, 255)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(50, 0, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))}
	UIGradient.Parent = ColorMap

	UICorner_4.CornerRadius = UDim.new(0, 3)
	UICorner_4.Parent = ColorMap

	ColorMapSelection.Name = NeverLose.RandomString();
	ColorMapSelection.Parent = ColorMap
	ColorMapSelection.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorMapSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorMapSelection.BackgroundTransparency = 1.000
	ColorMapSelection.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorMapSelection.BorderSizePixel = 0
	ColorMapSelection.Position = UDim2.new(0, 0, 0.5, 0)
	ColorMapSelection.Size = UDim2.new(0, 5, 1, 0)
	ColorMapSelection.ZIndex = ZIndex + 126

	UIStroke_3.Thickness = 2.000
	UIStroke_3.Color = Color3.fromRGB(255, 255, 255)
	UIStroke_3.Parent = ColorMapSelection

	UICorner_5.CornerRadius = UDim.new(0, 3)
	UICorner_5.Parent = ColorMapSelection

	RGBLabel.Name = NeverLose.RandomString();
	RGBLabel.Parent = ColorPickerHandler
	RGBLabel.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
	RGBLabel.BackgroundTransparency = 0.750
	RGBLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	RGBLabel.BorderSizePixel = 0
	RGBLabel.Position = UDim2.new(0, 10, 0, 217)
	RGBLabel.Size = UDim2.new(1, -20, 0, 15)
	RGBLabel.ZIndex = ZIndex + 127
	RGBLabel.Font = Enum.Font.GothamBold
	RGBLabel.Text = "#FFFFFF"
	RGBLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	RGBLabel.TextSize = 12.000
	RGBLabel.TextTransparency = 0.400
	RGBLabel.TextXAlignment = Enum.TextXAlignment.Left

	UICorner_6.CornerRadius = UDim.new(0, 4)
	UICorner_6.Parent = RGBLabel

	ColorPickerLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if value then
			ColorPickerHandler.Position = UDim2.new(0,HandleFrame.AbsolutePosition.X + 20 , 0 ,HandleFrame.AbsolutePosition.Y + 75);

			NeverLose.PlayAnimate(ColorPickerHandler,SlowyTween , {
				BackgroundTransparency = 0.035
			})

			NeverLose.PlayAnimate(UIStroke,SlowyTween , {
				Transparency = 0.650
			})

			NeverLose.PlayAnimate(SaViMap,SlowyTween , {
				BackgroundTransparency = 0,
				ImageTransparency = 0
			})

			NeverLose.PlayAnimate(UIStroke_2,SlowyTween , {
				Transparency = 0
			})

			NeverLose.PlayAnimate(ColorMap,SlowyTween , {
				BackgroundTransparency = 0
			})

			NeverLose.PlayAnimate(UIStroke_3,SlowyTween , {
				Transparency = 0
			})

			NeverLose.PlayAnimate(RGBLabel,SlowyTween , {
				BackgroundTransparency = 0.750,
				TextTransparency = 0.400
			})

			Shadow:Render(true)
		else
			NeverLose.PlayAnimate(ColorPickerHandler,SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke,SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(SaViMap,SlowyTween , {
				BackgroundTransparency = 1,
				ImageTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke_2,SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(ColorMap,SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke_3,SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(RGBLabel,SlowyTween , {
				BackgroundTransparency = 1,
				TextTransparency = 1
			})

			Shadow:Render(false)
		end;
	end);

	ColorPickerLib.SetRender(false);
	ColorPickerLib.Root = ColorPickerHandler;
	ColorPickerLib.H = 1;
	ColorPickerLib.S = 1;
	ColorPickerLib.V = 1;
	ColorPickerLib.Callback = EmptyFunction;

	function ColorPickerLib:Update()
		local RealColor = Color3.fromHSV(ColorPickerLib.H , ColorPickerLib.S , ColorPickerLib.V);

		NeverLose.PlayAnimate(ColorZoneSelection,ManualTween,{
			Position = UDim2.fromScale(ColorPickerLib.S , 1 - ColorPickerLib.V)
		});

		NeverLose.PlayAnimate(SaViMap,ManualTween,{
			BackgroundColor3 = Color3.fromHSV(ColorPickerLib.H , 1 , 1)
		});

		NeverLose.PlayAnimate(ColorMapSelection,ManualTween,{
			Position = UDim2.fromScale(ColorPickerLib.H,0.5)
		});

		RGBLabel.Text = "#"..RealColor:ToHex();

		ColorPickerLib.Callback(RealColor);
	end;

	function ColorPickerLib:SetValue(Color)
		if typeof(Color) == 'string' then
			Color = Color3.fromHex(Color);
		end;

		local H , S , V = Color:ToHSV();

		ColorPickerLib.H = H;
		ColorPickerLib.S = S;
		ColorPickerLib.V = V;

		ColorPickerLib:Update();
	end;

	ColorPickerLib.IsHold = false;

	NeverLose:AddSignal(ColorPickerHandler.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = true;
		end;
	end));

	NeverLose:AddSignal(ColorPickerHandler.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = false;
		end;
	end));

	NeverLose:AddSignal(ColorMap.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = true;

			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or ColorPickerLib.IsHold) do task.wait()
				local ColorY = ColorMap.AbsolutePosition.X
				local ColorYM = ColorY + ColorMap.AbsoluteSize.X;
				local Value = math.clamp(Mouse.X, ColorY, ColorYM)
				local Code = ((Value - ColorY) / (ColorYM - ColorY));

				ColorPickerLib.H = Code;
				ColorPickerLib:Update();
			end;
		end;
	end)));

	NeverLose:AddSignal(SaViMap.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = true;

			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or ColorPickerLib.IsHold) do task.wait();
				local PosX = SaViMap.AbsolutePosition.X;
				local ScaleX = PosX + SaViMap.AbsoluteSize.X;
				local Value, PosY = math.clamp(Mouse.X, PosX, ScaleX), SaViMap.AbsolutePosition.Y;
				local ScaleY = PosY + SaViMap.AbsoluteSize.Y;
				local Vals = math.clamp(Mouse.Y, PosY, ScaleY);

				ColorPickerLib.S = (Value - PosX) / (ScaleX - PosX);
				ColorPickerLib.V = (1 - ((Vals - PosY) / (ScaleY - PosY)));
				ColorPickerLib:Update();
			end
		end
	end)));

	return ColorPickerLib;
end;

NeverLose.KeyEnum = {
	One = '1',
	Two = '2',
	Three = '3',
	Four = '4',
	Five = '5',
	Six = '6',
	Seven = '7',
	Eight = '8',
	Nine = '9',
	Zero = '0',
	['Minus'] = "-",
	['Plus'] = "+",
	BackSlash = "\\",
	Slash = "/",
	Period = '.',
	Semicolon = ';',
	Colon = ":",
	LeftControl = "LCtrl",
	RightControl = "RCtrl",
	LeftShift = "LShift",
	RightShift = "RShift",
	Return = "Enter",
	LeftBracket = "[",
	RightBracket = "]",
	Quote = "'",
	Comma = ",",
	Equals = "=",
	LeftSuper = "Super",
	RightSuper = "Super",
	LeftAlt = "LAlt",
	RightAlt = "RAlt",
	Escape = "Esc",
};

NeverLose.EnumReverse = {};

for i,v in next , NeverLose.KeyEnum do
	NeverLose.EnumReverse[v] = i;
end;

function NeverLose:KeyCodeToStr(K: Enum.KeyCode)
	if typeof(K) == 'string' then
		if NeverLose.KeyEnum[K] then
			return NeverLose.KeyEnum[K];
		end;

		return K;
	end;

	return (NeverLose.KeyEnum[K.Name] or K.Name);
end;

function NeverLose:StrToKeyCode(str: string)
	if NeverLose.EnumReverse[str] then
		return Enum.KeyCode[NeverLose.EnumReverse[str]];
	end;

	return Enum.KeyCode[str];
end;

function NeverLose:RegisiterHandler(Handler: Frame , Signal)
	local handle = {};
	local ZINdex = Handler.ZIndex;

	function handle:AddToggle(Config)
		Config = NeverLose:ProcessParams(Config , {
			Default = false,
			Flag = nil,
			Callback = EmptyFunction,
		});

		local Toggle = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Circle = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")

		Toggle.Name = NeverLose.RandomString();
		Toggle.Parent = Handler
		Toggle.BackgroundColor3 = Color3.fromRGB(10, 13, 21)
		Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Toggle.BorderSizePixel = 0
		Toggle.ClipsDescendants = true
		Toggle.Size = UDim2.new(0, 30, 0, 18)
		Toggle.ZIndex = ZINdex + 13
		Toggle.LayoutOrder = -(#Handler:GetChildren() + 5);

		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = Toggle

		Circle.Name = NeverLose.RandomString();
		Circle.Parent = Toggle
		Circle.AnchorPoint = Vector2.new(0.5, 0.5)
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 0.500
		Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Circle.BorderSizePixel = 0
		Circle.Position = UDim2.new(0.300000012, 0, 0.5, 0)
		Circle.Size = UDim2.new(0, 16, 0, 16)
		Circle.ZIndex = ZINdex + 14

		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = Circle

		local ToggleLib = {
			Root = Toggle	
		};

		ToggleLib.SetUI = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(Toggle,SlowyTween,{
					BackgroundTransparency = 0,
					BackgroundColor3 = NeverLose.AccentColor
				})

				NeverLose.PlayAnimate(Circle,SlowyTween,{
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0,
					Position = UDim2.new(0.7, 0, 0.5, 0)
				})
			else
				NeverLose.PlayAnimate(Toggle,SlowyTween,{
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(10, 13, 21)
				})

				NeverLose.PlayAnimate(Circle,SlowyTween,{
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.500,
					Position = UDim2.new(0.300000012, 0, 0.5, 0)
				})
			end;
		end);

		ToggleLib.SetVisible = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ToggleLib.SetUI(Config.Default);
			else
				NeverLose.PlayAnimate(Toggle,SlowyTween,{
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(10, 13, 21)
				})

				NeverLose.PlayAnimate(Circle,SlowyTween,{
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					Position = UDim2.new(0.300000012, 0, 0.5, 0)
				})
			end;
		end);

		ToggleLib.SetUI(Config.Default);
		ToggleLib.SetVisible(Signal:GetValue());

		NeverLose:CreateInput(Toggle , LPH_NO_VIRTUALIZE(function()
			Config.Default = not Config.Default;

			ToggleLib.SetUI(Config.Default);

			Config.Callback(Config.Default)
		end))

		ToggleLib.Signal = Signal:Connect(ToggleLib.SetVisible);

		function ToggleLib:GetValue()
			return Config.Default;
		end;

		function ToggleLib:SetValue(v)
			Config.Default = v;

			if Signal:GetValue() then
				ToggleLib.SetUI(Config.Default);
			end;

			Config.Callback(Config.Default)
		end;

		NeverLose.AutoAssignFlag(Config, "Toggle");
		NeverLose.Flags[Config.Flag] = ToggleLib;

		return ToggleLib;
	end;

	function handle:AddSlider(Config)
		Config = NeverLose:ProcessParams(Config , {
			Default = 50,
			Min = 0,
			Max = 10,
			Type = "",
			Rounding = 0,
			Nums = {},
			Flag = nil,
			Size = 125,
			Callback = EmptyFunction,
		});

		local SliderLib = {};

		SliderLib.GetSize = LPH_NO_VIRTUALIZE(function()
			return (Config.Default - Config.Min) / (Config.Max - Config.Min);
		end);

		local FullNumSize = TextService:GetTextSize(string.rep("0",(Config.Rounding + #tostring(Config.Max))+1)..tostring(Config.Type),10,Enum.Font.GothamMedium,Vector2.new(math.huge,math.huge));

		SliderLib.MaximumSize = FullNumSize.X;

		if Config.Nums then
			local nszie = 0;

			for i,ns in next , Config.Nums do
				local size = TextService:GetTextSize(string.rep("m",string.len(tostring(ns))),10,Enum.Font.GothamMedium,Vector2.new(math.huge,math.huge));

				if nszie < size.X then
					nszie = size.X;
				end
			end;

			if SliderLib.MaximumSize < nszie then
				SliderLib.MaximumSize = nszie;
			end;
		end;

		local Slider = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local ValueFrame = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ValueLabel = Instance.new("TextBox")
		local SlideMain = Instance.new("Frame")
		local SlideFrame = Instance.new("Frame")
		local UICorner_3 = Instance.new("UICorner")
		local SlideMoving = Instance.new("Frame")
		local UICorner_4 = Instance.new("UICorner")
		local Frame = Instance.new("Frame")
		local UICorner_5 = Instance.new("UICorner")
		local boxSize = 2;

		Slider.Name = NeverLose.RandomString();
		Slider.Parent = Handler
		Slider.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		Slider.BackgroundTransparency = 1.000
		Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Slider.BorderSizePixel = 0
		Slider.ClipsDescendants = false
		Slider.Size = UDim2.new(0, Config.Size, 0, 18)
		Slider.ZIndex = ZINdex + 13
		Slider.LayoutOrder = -(#Handler:GetChildren() + 5);

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Slider

		ValueFrame.Name = NeverLose.RandomString();
		ValueFrame.Parent = Slider
		ValueFrame.AnchorPoint = Vector2.new(1, 0)
		ValueFrame.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.ClipsDescendants = true
		ValueFrame.Position = UDim2.new(1, 0, 0, 0)
		ValueFrame.Size = UDim2.new(0, SliderLib.MaximumSize + boxSize, 0, 18)
		ValueFrame.ZIndex = ZINdex + 13

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = ValueFrame

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = ValueFrame

		ValueLabel.Name = NeverLose.RandomString();
		ValueLabel.Parent = ValueFrame
		ValueLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.BackgroundTransparency = 1.000
		ValueLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueLabel.BorderSizePixel = 0
		ValueLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ValueLabel.Size = UDim2.new(1, 0, 1, 0)
		ValueLabel.ZIndex = ZINdex + 14
		ValueLabel.Font = Enum.Font.GothamMedium
		ValueLabel.Text = tostring(Config.Default)..tostring(Config.Type);
		ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.TextSize = 10.000
		ValueLabel.ClearTextOnFocus = false;
		ValueLabel.TextTransparency = 0.350

		SlideMain.Name = NeverLose.RandomString();
		SlideMain.Parent = Slider
		SlideMain.AnchorPoint = Vector2.new(0, 0.5)
		SlideMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SlideMain.BackgroundTransparency = 1.000
		SlideMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SlideMain.BorderSizePixel = 0
		SlideMain.Position = UDim2.new(0, 0, 0.5, 0)
		SlideMain.Size = UDim2.new(1, -((SliderLib.MaximumSize + 11)), 0, 18)
		SlideMain.ZIndex = ZINdex + 13

		SlideFrame.Name = NeverLose.RandomString();
		SlideFrame.Parent = SlideMain
		SlideFrame.AnchorPoint = Vector2.new(0, 0.5)
		SlideFrame.BackgroundColor3 = Color3.fromRGB(30, 29, 36)
		SlideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SlideFrame.BorderSizePixel = 0
		SlideFrame.Position = UDim2.new(0, 0, 0.5, 0)
		SlideFrame.Size = UDim2.new(1, 0, 0, 5)
		SlideFrame.ZIndex = ZINdex + 13

		UICorner_3.CornerRadius = UDim.new(1, 0)
		UICorner_3.Parent = SlideFrame

		SlideMoving.Name = NeverLose.RandomString();
		SlideMoving.Parent = SlideFrame
		SlideMoving.BackgroundColor3 = NeverLose.AccentColor
		SlideMoving.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SlideMoving.BorderSizePixel = 0
		SlideMoving.Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
		SlideMoving.ZIndex = ZINdex + 14

		UICorner_4.CornerRadius = UDim.new(1, 0)
		UICorner_4.Parent = SlideMoving

		Frame.Parent = SlideMoving
		Frame.AnchorPoint = Vector2.new(1, 0.5)
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Position = UDim2.new(1, 5, 0.5, 0)
		Frame.Size = UDim2.new(0, 10, 0, 10)
		Frame.ZIndex = ZINdex + 15

		UICorner_5.CornerRadius = UDim.new(1, 0)
		UICorner_5.Parent = Frame

		local LoadText = LPH_NO_VIRTUALIZE(function()
			if Config.Nums[Config.Default] then
				ValueLabel.Text = Config.Nums[Config.Default]

			else
				ValueLabel.Text = tostring(Config.Default)..tostring(Config.Type);

			end;
		end);

		ValueLabel.FocusLost:Connect(LPH_NO_VIRTUALIZE(function()
			local OutVal = NeverLose:ParseInput(ValueLabel.Text , true);
			if OutVal then
				local rx = math.clamp(OutVal , Config.Min , Config.Max);
				local Value = NeverLose.Rounding(rx,Config.Rounding);

				if Value then
					Config.Default = Value;

					TweenService:Create(SlideMoving , ManualTween ,{
						Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
					}):Play();

					LoadText();

					Config.Callback(Config.Default)
				else
					LoadText();
				end;

			else
				LoadText()
			end;
		end));

		SliderLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(ValueFrame,SlowyTween,{
					BackgroundTransparency = 0,
					Size = UDim2.new(0, SliderLib.MaximumSize + boxSize, 0, 18)
				});

				NeverLose.PlayAnimate(UIStroke,SlowyTween,{
					Transparency = 0.650
				});

				NeverLose.PlayAnimate(ValueLabel,SlowyTween,{
					TextTransparency = 0.350
				});

				NeverLose.PlayAnimate(SlideFrame,SlowyTween,{
					BackgroundTransparency = 0
				});

				NeverLose.PlayAnimate(SlideMoving,SlowyTween,{
					BackgroundTransparency = 0,
					Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
				});

				NeverLose.PlayAnimate(Frame,SlowyTween,{
					BackgroundTransparency = 0
				});
			else
				NeverLose.PlayAnimate(ValueFrame,SlowyTween,{
					BackgroundTransparency = 1,
				});

				NeverLose.PlayAnimate(UIStroke,SlowyTween,{
					Transparency = 1
				});

				NeverLose.PlayAnimate(ValueLabel,SlowyTween,{
					TextTransparency = 1
				});

				NeverLose.PlayAnimate(SlideFrame,SlowyTween,{
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(SlideMoving,SlowyTween,{
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 1, 0)
				});

				NeverLose.PlayAnimate(Frame,SlowyTween,{
					BackgroundTransparency = 1
				});
			end;
		end);

		SliderLib.SetRender(Signal:GetValue());
		SliderLib.Signal = Signal:Connect(SliderLib.SetRender);

		local Update = function(Input)
			local SizeScale = math.clamp((((Input.Position.X) - SlideMain.AbsolutePosition.X) / SlideMain.AbsoluteSize.X), 0, 1);
			local Main = ((Config.Max - Config.Min) * SizeScale) + Config.Min;
			local Value = NeverLose.Rounding(Main,Config.Rounding);
			local PositionX = UDim2.fromScale(SizeScale, 1);
			local Size = ((Value - Config.Min) / (Config.Max - Config.Min)) + 0.02;

			Config.Default = Value;

			TweenService:Create(SlideMoving , ManualTween ,{
				Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
			}):Play();

			LoadText()


			Config.Callback(Value)
		end;

		local IsHold = false;

		do
			SlideMain.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					IsHold = true
					Update(Input)
				end
			end))

			SlideMain.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if UserInputService.TouchEnabled then
						if not NeverLose:IsMouseOverFrame(SlideMain) then
							IsHold = false
						end;
					else
						IsHold = false
					end;
				end
			end))

			UserInputService.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(Input)
				if IsHold then
					if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)  then
						if UserInputService.TouchEnabled then
							if not NeverLose:IsMouseOverFrame(SlideMain) then
								IsHold = false
							else
								Update(Input)
							end;
						else
							Update(Input)
						end;
					end;
				end;
			end));
		end;

		function SliderLib:GetValue()
			return Config.Default;
		end;

		function SliderLib:SetValue(v)
			Config.Default = v;

			if Signal:GetValue() then
				NeverLose.PlayAnimate(SlideMoving,SlowyTween,{
					BackgroundTransparency = 0,
					Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
				});
			end;

			LoadText()

			Config.Callback(Config.Default);
		end;

		NeverLose.AutoAssignFlag(Config, "Slider");
		NeverLose.Flags[Config.Flag] = SliderLib;

		return SliderLib;
	end;

	function handle:AddOption(GearIcon)
		local Option = Instance.new("Frame")
		local Icon = Instance.new("TextLabel")
		local UICorner = Instance.new("UICorner")

		Option.Name = NeverLose.RandomString();
		Option.Parent = Handler
		Option.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
		Option.BackgroundTransparency = 1.000
		Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Option.BorderSizePixel = 0
		Option.ClipsDescendants = true
		Option.Size = UDim2.new(0, 20, 0, 18)
		Option.ZIndex = ZINdex + 13
		Option.LayoutOrder = -(#Handler:GetChildren() + 5);

		Icon.Name = NeverLose.RandomString();
		Icon.Parent = Option
		Icon.AnchorPoint = Vector2.new(0.5, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		Icon.Size = UDim2.new(1, 0, 1, 0)
		Icon.ZIndex = ZINdex + 14
		Icon.FontFace = NeverLose.BuiltInBold
		Icon.Text = (GearIcon == 1 and 'gear') or (GearIcon == 2 and 'chevron-large-right') or "three-dots-horizontal";
		Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
		Icon.TextSize = 16.000
		Icon.TextTransparency = 0.400
		Icon.TextWrapped = true

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Option

		local Window = NeverLose:CreateOptionWindow(Option , ZINdex + 13);
		local reciveSignal;

		Window.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 0.400
				})
			else
				NeverLose.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 1
				})
			end;
		end);

		Window.SetRender(Signal:GetValue());
		Signal:Connect(Window.SetRender);

		local bthg = NeverLose:CreateInput(Option , LPH_NO_VIRTUALIZE(function()
			if reciveSignal then
				reciveSignal:Disconnect();
				reciveSignal = nil;	
			end;

			Window.Signal:SetValue(true);

			reciveSignal = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not NeverLose:IsMouseOverFrame(Window.Root) and not NeverLose:IsMouseOverFrame(Option) then
						if reciveSignal then
							reciveSignal:Disconnect();
							reciveSignal = nil;	
						end;

						Window.Signal:SetValue(false);
					end
				end
			end)
		end));

		NeverLose:AddSignal(bthg.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(Option , SlowyTween , {
				BackgroundTransparency = 0.5
			})

			NeverLose.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.25
			})
		end)));

		NeverLose:AddSignal(bthg.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(Option , SlowyTween , {
				BackgroundTransparency = 1.000
			})

			NeverLose.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.400
			})
		end)));

		return Window;
	end;

	function handle:AddColorPicker(Config)
		Config = NeverLose:ProcessParams(Config , {
			Default = Color3.fromRGB(255, 255, 255),
			Callback  = EmptyFunction,
		});

		if typeof(Config.Default) == 'string' then
			Config.Default = Color3.fromHex(Config.Default:gsub('#',''));
		end;

		local ColorPickerLib = {};
		local ColorPicker = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ImageLabel = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")

		ColorPicker.Name = NeverLose.RandomString();
		ColorPicker.Parent = Handler
		ColorPicker.BackgroundColor3 = Config.Default;
		ColorPicker.BackgroundTransparency = 0
		ColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorPicker.BorderSizePixel = 0
		ColorPicker.ClipsDescendants = true
		ColorPicker.Size = UDim2.new(0, 18, 0, 18)
		ColorPicker.ZIndex = ZINdex + 13
		ColorPicker.LayoutOrder = -(#Handler:GetChildren() + 5);

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = ColorPicker

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = ColorPicker

		ImageLabel.Parent = ColorPicker
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Size = UDim2.new(1, 0, 1, 0)
		ImageLabel.ZIndex = ZINdex + 11
		ImageLabel.Image = "rbxasset://textures/meshPartFallback.png"
		ImageLabel.ImageTransparency = 0.9
		ImageLabel.BackgroundTransparency = 1;
		ImageLabel.ScaleType = Enum.ScaleType.Crop

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = ImageLabel

		local BackendM = NeverLose:CreateColorPicker(ColorPicker);

		BackendM:SetValue(Config.Default)
		BackendM.Callback = function(color)
			ColorPicker.BackgroundColor3 = color;
			Config.Default = color;
			Config.Callback(Config.Default);
		end;

		local signal;
		NeverLose:CreateInput(ColorPicker , LPH_NO_VIRTUALIZE(function()
			if signal then
				signal:Disconnect();
				signal = nil;
			end;

			BackendM.SetRender(true);

			signal = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not NeverLose:IsMouseOverFrame(ColorPicker) and not NeverLose:IsMouseOverFrame(BackendM.Root) then
						if signal then
							signal:Disconnect();
							signal = nil;
						end;

						BackendM.SetRender(false);
					end;
				end;
			end)
		end));

		ColorPickerLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(ColorPicker , SlowyTween , {
					BackgroundTransparency = 0
				})

				NeverLose.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 0.650
				})

				NeverLose.PlayAnimate(ImageLabel , SlowyTween , {
					ImageTransparency = 0.9
				})
			else
				NeverLose.PlayAnimate(ColorPicker , SlowyTween , {
					BackgroundTransparency = 1
				})

				NeverLose.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 1
				})

				NeverLose.PlayAnimate(ImageLabel , SlowyTween , {
					ImageTransparency = 1
				})
			end;
		end);

		ColorPickerLib.SetRender(Signal:GetValue());
		Signal:Connect(ColorPickerLib.SetRender);

		function ColorPickerLib:GetValue()
			return Config.Default;
		end;

		function ColorPickerLib:SetValue(v)
			Config.Default = v;
			BackendM:SetValue(Config.Default)
		end;

		NeverLose.AutoAssignFlag(Config, "ColorPicker");
		NeverLose.Flags[Config.Flag] = ColorPickerLib;

		return ColorPickerLib;
	end;

	function handle:AddKeybind(Config)
		Config = NeverLose:ProcessParams(Config,{
			Default = nil,
			Blacklist = {},
			Callback = EmptyFunction,
			Flag = nil
		});

		local KeybindLib = {};

		local Keybind = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ValueLabel = Instance.new("TextLabel")

		Keybind.Name = NeverLose.RandomString();
		Keybind.Parent = Handler
		Keybind.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Keybind.BorderSizePixel = 0
		Keybind.ClipsDescendants = true
		Keybind.Size = UDim2.new(0, 45, 0, 18)
		Keybind.ZIndex = ZINdex + 13
		Keybind.LayoutOrder = -(#Handler:GetChildren() + 5);

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Keybind

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = Keybind

		ValueLabel.Name = NeverLose.RandomString();
		ValueLabel.Parent = Keybind
		ValueLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.BackgroundTransparency = 1.000
		ValueLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueLabel.BorderSizePixel = 0
		ValueLabel.ClipsDescendants = true
		ValueLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ValueLabel.Size = UDim2.new(1, 0, 1, 0)
		ValueLabel.ZIndex = ZINdex + 14
		ValueLabel.Font = Enum.Font.GothamMedium
		ValueLabel.Text = NeverLose:KeyCodeToStr(Config.Default or "None")
		ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.TextSize = 10.000
		ValueLabel.TextTransparency = 0.500

		KeybindLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(Keybind,SlowyTween, {
					BackgroundTransparency = 0
				})

				NeverLose.PlayAnimate(UIStroke,SlowyTween, {
					Transparency = 0.650
				})

				NeverLose.PlayAnimate(ValueLabel,SlowyTween, {
					TextTransparency = 0.500
				})
			else
				NeverLose.PlayAnimate(Keybind,SlowyTween, {
					BackgroundTransparency = 1
				})

				NeverLose.PlayAnimate(UIStroke,SlowyTween, {
					Transparency = 1
				})

				NeverLose.PlayAnimate(ValueLabel,SlowyTween, {
					TextTransparency = 1
				})
			end;
		end);

		function KeybindLib:Update()
			local size = TextService:GetTextSize(ValueLabel.Text,ValueLabel.TextSize,ValueLabel.Font,Vector2.new(math.huge,math.huge));

			NeverLose.PlayAnimate(Keybind , SlowyTween , {
				Size = UDim2.new(0, size.X + 7, 0, 18)
			})
		end;

		local IsBlacklist = LPH_NO_VIRTUALIZE(function(v)
			return Config.Blacklist and (Config.Blacklist[v] or table.find(Config.Blacklist,v))
		end);

		KeybindLib:Update()

		KeybindLib.SetRender(Signal:GetValue());
		Signal:Connect(KeybindLib.SetRender);

		local IsBinding = false;
		NeverLose:CreateInput(Keybind , function()
			if IsBinding then
				return;
			end;

			IsBinding = true;

			ValueLabel.Text = "...";

			KeybindLib:Update();

			local Selected = nil;

			while not Selected do
				local Key = UserInputService.InputBegan:Wait();

				if Key.KeyCode ~= Enum.KeyCode.Unknown and not IsBlacklist(Key.KeyCode) and not IsBlacklist(Key.KeyCode.Name) then
					Selected = Key.KeyCode;
				else
					if Key.UserInputType == Enum.UserInputType.MouseButton1 and not IsBlacklist(Enum.UserInputType.MouseButton1) and not IsBlacklist("M1B") then
						Selected = "M1B";
					elseif Key.UserInputType == Enum.UserInputType.MouseButton2 and not IsBlacklist(Enum.UserInputType.MouseButton2) and not IsBlacklist("M2B") then
						Selected = "M2B";
					end;
				end;
			end;

			IsBinding = false;

			local KeyName = typeof(Selected) == "string" and Selected or Selected.Name;

			Config.Default = KeyName;

			ValueLabel.Text = NeverLose:KeyCodeToStr(KeyName);

			KeybindLib:Update();

			Config.Callback(KeyName)
		end)

		function KeybindLib:GetValue()
			return Config.Default;
		end;

		function KeybindLib:SetValue(v)
			Config.Default = v;
			ValueLabel.Text = NeverLose:KeyCodeToStr(v);
			KeybindLib:Update();
			Config.Callback(Config.Default);
		end;

		NeverLose.AutoAssignFlag(Config, "Keybind");
		NeverLose.Flags[Config.Flag] = KeybindLib;

		return KeybindLib;
	end;

	function handle:AddTextInput(Config)
		Config = NeverLose:ProcessParams(Config , {
			Default = "",
			Placeholder = "Placeholder",
			Callback = print,
			Flag = nil,
			Size = 100,
			Numeric = false,
		});

		local TextBoxLib = {};

		local TextInput = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local TextBox = Instance.new("TextBox")

		TextInput.Name = NeverLose.RandomString();
		TextInput.Parent = Handler
		TextInput.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		TextInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextInput.BorderSizePixel = 0
		TextInput.ClipsDescendants = true
		TextInput.Size = UDim2.new(0, Config.Size, 0, 18)
		TextInput.ZIndex = ZINdex + 13
		TextInput.LayoutOrder = -(#Handler:GetChildren() + 5);

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = TextInput

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = TextInput

		TextBox.Parent = TextInput
		TextBox.AnchorPoint = Vector2.new(0, 0.5)
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0, 5, 0.5, 0)
		TextBox.Size = UDim2.new(1, -5, 0, 17)
		TextBox.ZIndex = ZINdex + 14
		TextBox.ClearTextOnFocus = false
		TextBox.Font = Enum.Font.GothamMedium
		TextBox.PlaceholderText = Config.Placeholder
		TextBox.Text = tostring(Config.Default)
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.TextSize = 11.000
		TextBox.TextTransparency = 0.350
		TextBox.TextXAlignment = Enum.TextXAlignment.Left

		TextBoxLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(TextInput , SlowyTween ,{
					BackgroundTransparency = 0
				})	

				NeverLose.PlayAnimate(UIStroke , SlowyTween ,{
					Transparency = 0.650
				})	

				NeverLose.PlayAnimate(TextBox , SlowyTween ,{
					TextTransparency = 0.350
				})	
			else
				NeverLose.PlayAnimate(TextInput , SlowyTween ,{
					BackgroundTransparency = 1
				})	

				NeverLose.PlayAnimate(UIStroke , SlowyTween ,{
					Transparency = 1
				})	

				NeverLose.PlayAnimate(TextBox , SlowyTween ,{
					TextTransparency = 1
				})
			end;
		end);

		NeverLose:AddSignal(TextBox:GetPropertyChangedSignal('Text'):Connect(LPH_NO_VIRTUALIZE(function()
			local valout = NeverLose:ParseInput(TextBox.Text , Config.Numeric);

			if Config.Numeric then
				TextBox.Text = string.gsub(TextBox.Text , '[^0-9.]','')
			end;

			if valout then
				Config.Default = valout;
				Config.Callback(valout);
			end
		end)));

		TextBoxLib.SetRender(Signal:GetValue());
		Signal:Connect(TextBoxLib.SetRender);

		function TextBoxLib:GetValue()
			return Config.Default;
		end;

		function TextBoxLib:SetValue(v)
			Config.Default = v;
			TextBox.Text = tostring(v);
			Config.Callback(Config.Default);
		end;

		NeverLose.AutoAssignFlag(Config, "TextBox");
		NeverLose.Flags[Config.Flag] = TextBoxLib;

		return TextBoxLib;
	end;

	function handle:AddDropdown(Config)
		Config = NeverLose:ProcessParams(Config , {
			Default = nil,
			Values = {},
			Multi = false,
			Callback = EmptyFunction,
			AutoUpdate = false,
			Flag = nil,
			Size = 100
		})

		Config.Default = NeverLose.ProcessDropdown(Config.Default);

		local Dropdown = Instance.new("Frame")
		local DropdownIcon = Instance.new("TextLabel")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local BasedLabel = Instance.new("TextLabel")

		Dropdown.Name = NeverLose.RandomString();
		Dropdown.Parent = Handler
		Dropdown.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown.BorderSizePixel = 0
		Dropdown.ClipsDescendants = true
		Dropdown.Size = UDim2.new(0, Config.Size, 0, 18)
		Dropdown.ZIndex = ZINdex + 13
		Dropdown.LayoutOrder = -(#Handler:GetChildren() + 5);

		DropdownIcon.Name = NeverLose.RandomString();
		DropdownIcon.Parent = Dropdown
		DropdownIcon.AnchorPoint = Vector2.new(1, 0.5)
		DropdownIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		DropdownIcon.BackgroundTransparency = 1.000
		DropdownIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DropdownIcon.BorderSizePixel = 0
		DropdownIcon.Position = UDim2.new(1, -2, 0.5, 0)
		DropdownIcon.Size = UDim2.new(0, 18, 0, 18)
		DropdownIcon.ZIndex = ZINdex + 14
		DropdownIcon.FontFace = NeverLose.BuiltInBold
		DropdownIcon.Text = "chevron-small-down"
		DropdownIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
		DropdownIcon.TextSize = 16.000
		DropdownIcon.TextTransparency = 0.250
		DropdownIcon.TextWrapped = true

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Dropdown

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = Dropdown

		BasedLabel.Name = NeverLose.RandomString();
		BasedLabel.Parent = Dropdown
		BasedLabel.AnchorPoint = Vector2.new(0, 0.5)
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.ClipsDescendants = true
		BasedLabel.Position = UDim2.new(0, 5, 0.5, 0)
		BasedLabel.Size = UDim2.new(1, -25, 0, 15)
		BasedLabel.ZIndex = ZINdex + 14
		BasedLabel.Font = Enum.Font.GothamMedium
		BasedLabel.Text = NeverLose.ParseDropdown(Config.Default);
		BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 12.000
		BasedLabel.TextTransparency = 0.5
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

		do
			local UIGradient = Instance.new("UIGradient")

			UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.85, 0.23), NumberSequenceKeypoint.new(1.00, 1.00)}
			UIGradient.Parent = BasedLabel;
		end;

		NeverLose:AddSignal(Dropdown.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
				TextTransparency = 0.200
			})
		end)));

		NeverLose:AddSignal(Dropdown.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
				TextTransparency = 0.5
			})
		end)));

		local DropdownLib = {
			OpenSignal = NeverLose:CreateSignal(false),
			Signals = {},
			Refuse = {},
		};

		DropdownLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(Dropdown , SlowyTween , {
					BackgroundTransparency = 0
				});

				NeverLose.PlayAnimate(DropdownIcon , SlowyTween , {
					TextTransparency = 0.250
				});

				NeverLose.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 0.650
				});

				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0.5
				});
			else
				NeverLose.PlayAnimate(Dropdown , SlowyTween , {
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(DropdownIcon , SlowyTween , {
					TextTransparency = 1
				});

				NeverLose.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 1
				});

				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				});
			end
		end);

		DropdownLib.SetRender(Signal:GetValue())
		Signal:Connect(DropdownLib.SetRender);
		DropdownLib.ExtentSize = 0;

		do
			local DropdownHandler = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local DropdownScrollFrame = Instance.new("ScrollingFrame")
			local UIListLayout = Instance.new("UIListLayout")
			local Shadow = NeverLose:CreateShadow(DropdownHandler);

			DropdownHandler.Name = NeverLose.RandomString();
			DropdownHandler.Parent = NeverLose.ScreenGui;
			DropdownHandler.AnchorPoint = Vector2.new(0.5, 0)
			DropdownHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
			DropdownHandler.BackgroundTransparency = 0.5
			DropdownHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownHandler.BorderSizePixel = 0
			DropdownHandler.ClipsDescendants = true
			DropdownHandler.Position = UDim2.new(255,255,255,255)
			DropdownHandler.Size = UDim2.new(0, 125, 0, 50)
			DropdownHandler.ZIndex = ZINdex + 125
			DropdownLib.BlockRoot = DropdownHandler;

			NeverLose:AddSignal(DropdownHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
				if DropdownHandler.BackgroundTransparency > 0.9 then
					DropdownHandler.Visible = false;
					DropdownHandler.Parent = nil;
				else
					DropdownHandler.Visible = true;

					if NeverLose.Global3DRenderMode then
						DropdownHandler.Parent = NeverLose.GlobalSurfaceGui;
					else
						DropdownHandler.Parent = NeverLose.ScreenGui;
					end;
				end;
			end));

			UICorner.CornerRadius = UDim.new(0, 10)
			UICorner.Parent = DropdownHandler

			UIStroke.Transparency = 0.650
			UIStroke.Color = Color3.fromRGB(45, 48, 58)
			UIStroke.Parent = DropdownHandler

			DropdownScrollFrame.Name = NeverLose.RandomString();
			DropdownScrollFrame.Parent = DropdownHandler
			DropdownScrollFrame.Active = true
			DropdownScrollFrame.AnchorPoint = Vector2.new(0.5, 0.5)
			DropdownScrollFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownScrollFrame.BackgroundTransparency = 1.000
			DropdownScrollFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownScrollFrame.BorderSizePixel = 0
			DropdownScrollFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
			DropdownScrollFrame.Size = UDim2.new(1, -5, 1, -5)
			DropdownScrollFrame.ZIndex = ZINdex + 127
			DropdownScrollFrame.ScrollBarThickness = 0

			DropdownLib.RootItem = DropdownScrollFrame;

			UIListLayout.Parent = DropdownScrollFrame
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

			NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
				DropdownScrollFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y)
				NeverLose.PlayAnimate(DropdownHandler , SlowyTween , {
					Size = UDim2.new(0, (Dropdown.AbsoluteSize.X + 5) + DropdownLib.ExtentSize, 0, math.min(UIListLayout.AbsoluteContentSize.Y + 5, 250));
				})
			end)));

			local SetPosition = LPH_NO_VIRTUALIZE(function()
				if NeverLose:MoreThanHalfY(Dropdown.AbsolutePosition.Y + 85) then
					DropdownHandler.AnchorPoint = Vector2.new(0.5,1)
				else
					DropdownHandler.AnchorPoint = Vector2.new(0.5,0)
				end;

				DropdownHandler.Position = UDim2.fromOffset(Dropdown.AbsolutePosition.X + (DropdownHandler.AbsoluteSize.X / 2), Dropdown.AbsolutePosition.Y + 85);

			end);

			DropdownLib.SetFrameRender = LPH_NO_VIRTUALIZE(function(value)
				DropdownLib.OpenSignal:SetValue(value);

				if value then
					Shadow:Render(true);

					DropdownHandler.Size = UDim2.new(0, (Dropdown.AbsoluteSize.X + 5) + DropdownLib.ExtentSize, 0, math.min(UIListLayout.AbsoluteContentSize.Y + 5, 250));

					SetPosition();

					NeverLose.PlayAnimate(DropdownHandler , SlowyTween , {
						BackgroundTransparency = 0.035
					})

					if Config.AutoUpdate then
						DropdownLib:Generate();
					end;
				else

					NeverLose.PlayAnimate(DropdownHandler , SlowyTween , {
						BackgroundTransparency = 1
					})

					Shadow:Render(false);
				end;
			end);

			DropdownLib.SetFrameRender(false);
		end;

		local SecureSignal;
		NeverLose:CreateInput(Dropdown , LPH_NO_VIRTUALIZE(function()
			if SecureSignal then
				SecureSignal:Disconnect();
				SecureSignal = nil;
			end;

			DropdownLib.SetFrameRender(true);
			NeverLose.IsMosueOverOtherFrame = true;

			SecureSignal = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not NeverLose:IsMouseOverFrame(DropdownLib.BlockRoot) and not NeverLose:IsMouseOverFrame(Dropdown) then
						if SecureSignal then
							SecureSignal:Disconnect();
							SecureSignal = nil;
						end;

						NeverLose.IsMosueOverOtherFrame = false;
						DropdownLib.SetFrameRender(false);
					end;
				end
			end)
		end))

		DropdownLib.IsMatch = LPH_NO_VIRTUALIZE(function(v1)
			if typeof(Config.Default) =='table' then
				if Config.Default[v1] or table.find(Config.Default , v1) then
					return true;
				end
			end

			if Config.Default == v1 then
				return true;
			end;
		end);

		function DropdownLib:Generate()
			for i,v in next , DropdownLib.RootItem:GetChildren() do
				if v:IsA('Frame') then
					v:Destroy();
				end;
			end;

			for i,v in next , DropdownLib.Signals do
				v:Disconnect();
			end;

			table.clear(DropdownLib.Signals);
			table.clear(DropdownLib.Refuse);

			local Lastone;
			for i,Value in next , Config.Values do
				local ItemFrame = Instance.new("Frame")
				local ItemLabel = Instance.new("TextLabel")
				local UICorner = Instance.new("UICorner")

				ItemFrame.Name = NeverLose.RandomString();
				ItemFrame.Parent = DropdownLib.RootItem
				ItemFrame.BackgroundColor3 = Color3.fromRGB(29, 31, 38)
				ItemFrame.BackgroundTransparency = 1.000
				ItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ItemFrame.BorderSizePixel = 0
				ItemFrame.Size = UDim2.new(1, 0, 0, 25)
				ItemFrame.ZIndex = ZINdex + 1258

				ItemLabel.Name = NeverLose.RandomString();
				ItemLabel.Parent = ItemFrame
				ItemLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ItemLabel.BackgroundTransparency = 1.000
				ItemLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ItemLabel.BorderSizePixel = 0
				ItemLabel.Position = UDim2.new(0, 15, 0, 4)
				ItemLabel.Size = UDim2.new(0,1, 0, 15)
				ItemLabel.ZIndex = ZINdex + 1258
				ItemLabel.Font = Enum.Font.GothamMedium
				ItemLabel.Text = tostring(Value);
				ItemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				ItemLabel.TextSize = 13.000
				ItemLabel.TextTransparency = 0.200
				ItemLabel.TextXAlignment = Enum.TextXAlignment.Left

				UICorner.CornerRadius = UDim.new(0, 10)
				UICorner.Parent = ItemFrame
				local sizetext = TextService:GetTextSize(ItemLabel.Text , ItemLabel.TextSize,ItemLabel.Font,Vector2.new(math.huge,math.huge));

				DropdownLib.ExtentSize = math.max(DropdownLib.ExtentSize , sizetext.X);

				local MIcon , MarkItem = nil , nil;

				if Config.Multi then
					local Icon = Instance.new("TextLabel")

					Icon.Parent = ItemFrame;
					Icon.AnchorPoint = Vector2.new(0, 0.5)
					Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Icon.BackgroundTransparency = 1.000
					Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Icon.BorderSizePixel = 0
					Icon.Position = UDim2.new(0, 5, 0.5, 0)
					Icon.Size = UDim2.new(0, 20, 0, 20)
					Icon.ZIndex = ZINdex + 1259
					Icon.FontFace = NeverLose.BuiltInBold;
					Icon.Text = "check"
					Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
					Icon.TextSize = 18.000
					Icon.TextTransparency = 1
					Icon.TextWrapped = true;

					local VisiblewOfMult = LPH_NO_VIRTUALIZE(function()
						if DropdownLib.IsMatch(Value) then
							NeverLose.PlayAnimate(ItemLabel , VSlowTween , {
								TextTransparency = 0.200,
								Position = UDim2.new(0, 30, 0, 4)
							})

							NeverLose.PlayAnimate(Icon , vs , {
								TextTransparency = 0.250
							})

							Lastone = ItemLabel;
						else

							NeverLose.PlayAnimate(Icon , SlowyTween , {
								TextTransparency = 1
							})

							NeverLose.PlayAnimate(ItemLabel , VSlowTween , {
								TextTransparency = 0.5,
								Position = UDim2.new(0, 15, 0, 4)
							})
						end;
					end);

					MIcon = Icon;
					MarkItem = VisiblewOfMult;
				else
					local DefaultVisible = LPH_NO_VIRTUALIZE(function()
						if DropdownLib.IsMatch(Value) then
							NeverLose.PlayAnimate(ItemLabel , SlowyTween , {
								TextTransparency = 0.200
							})

							Lastone = ItemLabel;
						else
							NeverLose.PlayAnimate(ItemLabel , SlowyTween , {
								TextTransparency = 0.5
							})
						end;
					end);

					MarkItem = DefaultVisible;
				end;

				MarkItem();

				table.insert(DropdownLib.Refuse , MarkItem)

				table.insert(DropdownLib.Signals,ItemFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(ItemFrame , SlowyTween , {
						BackgroundTransparency = 0.1
					})
				end)));

				table.insert(DropdownLib.Signals,ItemFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(ItemFrame , SlowyTween , {
						BackgroundTransparency = 1
					})
				end)));

				table.insert(DropdownLib.Signals , DropdownLib.OpenSignal:Connect(LPH_NO_VIRTUALIZE(function(val)
					if val then
						MarkItem();
					else
						NeverLose.PlayAnimate(ItemLabel , SlowyTween , {
							TextTransparency = 1
						})

						if MIcon then
							NeverLose.PlayAnimate(MIcon , SlowyTween , {
								TextTransparency = 1
							})
						end;
					end;
				end)));

				if Config.Multi then
					local _,bth_signal = NeverLose:CreateInput(ItemFrame , LPH_NO_VIRTUALIZE(function()
						Config.Default[Value] = not Config.Default[Value];

						MarkItem();

						BasedLabel.Text = NeverLose.ParseDropdown(Config.Default);

						Config.Callback(Config.Default);
					end));

					table.insert(DropdownLib.Signals , bth_signal);
				else
					local _,bth_signal = NeverLose:CreateInput(ItemFrame , LPH_NO_VIRTUALIZE(function()
						Config.Default = Value;

						for i,v in next , DropdownLib.Refuse do
							task.spawn(v);
						end;

						BasedLabel.Text = NeverLose.ParseDropdown(Config.Default);

						Config.Callback(Config.Default);
					end));

					table.insert(DropdownLib.Signals , bth_signal);
				end;
			end;
		end;

		DropdownLib:Generate();

		function DropdownLib:GetValue()
			return Config.Default;
		end;

		function DropdownLib:SetValue(v)
			Config.Default = v;

			BasedLabel.Text = NeverLose.ParseDropdown(Config.Default);

			for i,v in next , DropdownLib.Refuse do
				task.spawn(v);
			end;

			Config.Callback(Config.Default);
		end;

		function DropdownLib:SetValues(a)
			Config.Values = a;

			if not Config.AutoUpdate then
				DropdownLib:Generate();
			end;
		end;

		NeverLose.AutoAssignFlag(Config, "Dropdown");
		NeverLose.Flags[Config.Flag] = DropdownLib;

		return DropdownLib;
	end;

	return handle;
end;

NeverLose.ProcessDropdown = LPH_NO_VIRTUALIZE(function(value)
	if typeof(value) == 'table' then
		local data = {};

		for i,v in next , value do
			if typeof(v) == 'boolean' and typeof(i) ~= 'number' then
				data[i] = v;
			else
				data[v] = true;
			end;
		end;

		return data;
	else
		return value;
	end;
end);

NeverLose.ParseDropdown = LPH_NO_VIRTUALIZE(function(value)
	if not value then return 'Select'; end;

	local Out;

	if typeof(value) == 'table' then
		if #value > 0 then
			local x = {};

			for i,v in next , value do
				table.insert(x , tostring(v))
			end;

			Out = table.concat(x,' , ');

			table.clear(x);
		else
			local x = {};

			for i,v in next , value do
				if v == true then
					table.insert(x , tostring(i));
				end			
			end;

			Out = table.concat(x,' , ');

			table.clear(x)

			if not Out:byte() then
				Out = 'Select';
			end
		end;
	else
		Out = tostring(value or 'Select');
	end;

	return Out;
end);

function NeverLose:ParseInput(Value , Numeric)
	if not Value then
		return (Numeric and nil) or "";	
	end;

	if Numeric then
		local out = string.gsub(tostring(Value), '[^0-9.%-]', '')

		if tonumber(out) then
			return tonumber(out);
		end;

		return nil;
	end;

	return Value;
end;

function NeverLose:CreateToolTips(Container: Frame , Name: string , Content: string)
	local Tooltips = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local TooltipName = Instance.new("TextLabel")
	local TooltipContent = Instance.new("TextLabel")
	local Shadow = NeverLose:CreateShadow(Tooltips);

	Tooltips.Name = NeverLose.RandomString();
	Tooltips.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
	Tooltips.BackgroundTransparency = 0.075
	Tooltips.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Tooltips.BorderSizePixel = 0
	Tooltips.ClipsDescendants = true
	Tooltips.Position = UDim2.new(255,255,255,255)
	Tooltips.Size = UDim2.new(0,0,0,0)
	Tooltips.ZIndex = 130

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = Tooltips

	UIStroke.Transparency = 0.650
	UIStroke.Color = Color3.fromRGB(45, 48, 58)
	UIStroke.Parent = Tooltips

	TooltipName.Name = NeverLose.RandomString();
	TooltipName.Parent = Tooltips
	TooltipName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TooltipName.BackgroundTransparency = 1.000
	TooltipName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TooltipName.BorderSizePixel = 0
	TooltipName.Position = UDim2.new(0, 15, 0, 5)
	TooltipName.Size = UDim2.new(0, 1, 0, 20)
	TooltipName.ZIndex = 132
	TooltipName.Font = Enum.Font.GothamBold
	TooltipName.Text = Name
	TooltipName.TextColor3 = Color3.fromRGB(255, 255, 255)
	TooltipName.TextSize = 15.000
	TooltipName.TextXAlignment = Enum.TextXAlignment.Left

	TooltipContent.Name = NeverLose.RandomString();
	TooltipContent.Parent = Tooltips
	TooltipContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TooltipContent.BackgroundTransparency = 1.000
	TooltipContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TooltipContent.BorderSizePixel = 0
	TooltipContent.Position = UDim2.new(0, 15, 0, 30)
	TooltipContent.Size = UDim2.new(0, 1, 0, 15)
	TooltipContent.ZIndex = 132
	TooltipContent.Font = Enum.Font.GothamBold
	TooltipContent.Text = Content
	TooltipContent.TextColor3 = Color3.fromRGB(255, 255, 255)
	TooltipContent.TextSize = 12.000
	TooltipContent.TextTransparency = 0.650
	TooltipContent.TextXAlignment = Enum.TextXAlignment.Left
	TooltipContent.TextYAlignment = Enum.TextYAlignment.Top

	local ToolTip = {};

	ToolTip.Update = LPH_NO_VIRTUALIZE(function()
		local SizeName = TextService:GetTextSize(TooltipName.Text , TooltipName.TextSize , TooltipName.Font , Vector2.new(math.huge,math.huge));
		local SizeContent = TextService:GetTextSize(TooltipContent.Text , TooltipContent.TextSize , TooltipContent.Font , Vector2.new(math.huge,math.huge));

		local MaxX = math.max(SizeName.X , SizeContent.X) + 65;
		local MaxY = SizeName.Y + SizeContent.Y + 30;

		NeverLose.PlayAnimate(Tooltips,SlowyTween , {
			Size = UDim2.new(0,MaxX,0,MaxY)
		})
	end)

	NeverLose:AddSignal(Tooltips:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
		if Tooltips.BackgroundTransparency > 0.9 then
			Tooltips.Visible = false;
			Tooltips.Parent = nil;
		else
			Tooltips.Visible = true;

			if NeverLose.Global3DRenderMode then
				Tooltips.Parent = NeverLose.GlobalSurfaceGui;
			else
				Tooltips.Parent = NeverLose.ScreenGui;
			end;
		end
	end)));

	ToolTip.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if value then
			Tooltips.Position = UDim2.fromOffset(Container.AbsolutePosition.X + Container.AbsoluteSize.X , Container.AbsolutePosition.Y + (Container.AbsoluteSize.Y + 25));

			NeverLose.PlayAnimate(Tooltips , SlowyTween , {
				BackgroundTransparency = 0.075
			})

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 0.650
			})

			NeverLose.PlayAnimate(TooltipName , SlowyTween , {
				TextTransparency = 0
			})

			NeverLose.PlayAnimate(TooltipContent , SlowyTween , {
				TextTransparency = 0.650
			})

			ToolTip.Update();
			Shadow:Render(true);
		else
			NeverLose.PlayAnimate(Tooltips , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(TooltipName , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(TooltipContent , SlowyTween , {
				TextTransparency = 1
			})

			Shadow:Render(false);
		end;
	end);

	ToolTip.SetRender(false);
	ToolTip.Update();

	local DelayThread;
	NeverLose:AddSignal(Container.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
		if DelayThread then
			task.cancel(DelayThread);
			DelayThread = nil;
		end;

		DelayThread = task.delay(1,ToolTip.SetRender,true);
	end)));

	NeverLose:AddSignal(Container.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
		if DelayThread then
			task.cancel(DelayThread);
			DelayThread = nil;
		end;

		ToolTip.SetRender(false);
		ToolTip.Update();
	end)))

	return ToolTip;
end;

function NeverLose:RegisiterItem(Frame: Frame , Signel)
	local idx = {};
	local LayerIndex = Frame.ZIndex;

	function idx:AddLabel(Name: string,Warp: boolean)
		local BasedFrame = Instance.new("Frame")
		local BasedLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local BasedHandler = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local UICorner = Instance.new("UICorner")

		BasedFrame.Name = NeverLose.RandomString();
		BasedFrame.Parent = Frame
		BasedFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		BasedFrame.BackgroundTransparency = 1.000
		BasedFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedFrame.BorderSizePixel = 0
		BasedFrame.Size = UDim2.new(1, 0, 0, 30)
		BasedFrame.ZIndex = LayerIndex + 8

		NeverLose:AddQuery(BasedFrame , Name);

		BasedLabel.Name = NeverLose.RandomString();
		BasedLabel.Parent = BasedFrame
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.Position = UDim2.new(0, 11, 0, 6)
		BasedLabel.Size = UDim2.new(0,1, 0, 15)
		BasedLabel.ZIndex = LayerIndex + 9
		BasedLabel.Font = Enum.Font.GothamMedium
		BasedLabel.Text = Name
		BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 13.000
		BasedLabel.TextTransparency = 0.35
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

		LineFrame.Name = NeverLose.RandomString();
		LineFrame.Parent = BasedFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = LayerIndex + 11

		BasedHandler.Name = NeverLose.RandomString();
		BasedHandler.Parent = BasedFrame
		BasedHandler.AnchorPoint = Vector2.new(1, 0)
		BasedHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedHandler.BackgroundTransparency = 1.000
		BasedHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedHandler.BorderSizePixel = 0
		BasedHandler.Position = UDim2.new(1, -11, 0, 2)
		BasedHandler.Size = UDim2.new(1, -20, 0, 25)
		BasedHandler.ZIndex = LayerIndex + 12

		UIListLayout.Parent = BasedHandler
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0, 5)

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = BasedFrame

		local UpdateWarp = LPH_NO_VIRTUALIZE(function()
			local size = TextService:GetTextSize(BasedLabel.Text , BasedLabel.TextSize , BasedLabel.Font , Vector2.new(math.huge,math.huge));
			NeverLose.PlayAnimate(BasedFrame , SlowyTween , {
				Size = UDim2.new(1, 0, 0, size.Y + 13);
			})

			BasedLabel.Size = UDim2.new(1, -35, 1, 0)
			BasedLabel.TextYAlignment = Enum.TextYAlignment.Top;
		end);

		if Warp then
			UpdateWarp();
		end;

		local handle = NeverLose:RegisiterHandler(BasedHandler , Signel);

		handle.Root = BasedFrame;

		handle.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(BasedFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0.35
				})

				NeverLose.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 0.650
				})
			else
				NeverLose.PlayAnimate(BasedFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				})

				NeverLose.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 1
				})
			end;
		end);

		function handle:SetVisible(val)
			BasedFrame.Visible = val;
		end;

		NeverLose:AddSignal(BasedFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(BasedFrame , SlowyTween , {
				BackgroundTransparency = 0.35
			});

			NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
				TextTransparency = 0.25
			})

		end)))

		NeverLose:AddSignal(BasedFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(BasedFrame , SlowyTween , {
				BackgroundTransparency = 1
			});

			NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
				TextTransparency = 0.35
			})
		end)))

		function handle:SetText(t)
			local oldtxt = BasedLabel.Text;

			BasedLabel.Text = t;

			if Warp and oldtxt ~= t then
				UpdateWarp();
			end;
		end;

		function handle:ToolTip(Content: string)
			handle.ToolTip = NeverLose:CreateToolTips(BasedFrame , Name , Content);

			return handle;
		end;

		handle.SetRender(Signel:GetValue());
		Signel:Connect(handle.SetRender);

		return handle;
	end;

	function idx:AddButton(Config)
		Config = NeverLose:ProcessParams(Config , {
			Icon = 'chevron-large-left',
			Name = "Button",
			Callback = EmptyFunction,
			ToolTip = nil,
		});

		local Button = {};
		local ButtonFrame = Instance.new("Frame")
		local BasedLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Icon = Instance.new("TextLabel")

		NeverLose:AddQuery(ButtonFrame , Config.Name);

		ButtonFrame.Name = NeverLose.RandomString();
		ButtonFrame.Parent = Frame
		ButtonFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		ButtonFrame.BackgroundTransparency = 1.000
		ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonFrame.BorderSizePixel = 0
		ButtonFrame.Size = UDim2.new(1, 0, 0, 30)
		ButtonFrame.ZIndex = LayerIndex + 8

		BasedLabel.Name = NeverLose.RandomString();
		BasedLabel.Parent = ButtonFrame
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.Position = UDim2.new(0, 35, 0, 6)
		BasedLabel.Size = UDim2.new(0,1, 0, 15)
		BasedLabel.ZIndex = LayerIndex + 9
		BasedLabel.Font = Enum.Font.GothamMedium
		BasedLabel.Text = Config.Name;
		BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 13.000
		BasedLabel.TextTransparency = 0.200
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

		LineFrame.Name = NeverLose.RandomString();
		LineFrame.Parent = ButtonFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = LayerIndex + 11

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = ButtonFrame

		Icon.Name = NeverLose.RandomString();
		Icon.Parent = ButtonFrame
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 11, 0, 5)
		Icon.Size = UDim2.new(0, 18, 0, 18)
		Icon.ZIndex = LayerIndex + 9
		Icon.FontFace = NeverLose.BuiltInBold
		Icon.Text = Config.Icon
		Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
		Icon.TextSize = 16.000
		Icon.TextTransparency = 0.250
		Icon.TextWrapped = true

		function Button:SetText(t)
			BasedLabel.Text = t;
		end;

		function Button:SetIcon(t)
			Icon.Text = t
		end;

		local bth = NeverLose:CreateInput(ButtonFrame , LPH_NO_VIRTUALIZE(function()
			Config.Callback();
		end));

		NeverLose:AddSignal(bth.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(ButtonFrame , SlowyTween , {
				BackgroundTransparency = 0.35
			});
		end)))

		NeverLose:AddSignal(bth.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(ButtonFrame , SlowyTween , {
				BackgroundTransparency = 1
			});
		end)))

		Button.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(ButtonFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0.200
				});

				NeverLose.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 0.650
				});

				NeverLose.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 0.250
				});
			else
				NeverLose.PlayAnimate(ButtonFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				});

				NeverLose.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 1
				});
			end;
		end);

		if Config.ToolTip then
			Button.ToolTip = NeverLose:CreateToolTips(ButtonFrame , Config.Name , Config.ToolTip);
		end;

		Button.SetRender(Signel:GetValue())
		Signel:Connect(Button.SetRender);

		return Button;
	end;

	function idx:AddUserFrame(Name : string , Profile: string , Expires : string)
		local UserFrame = Instance.new("Frame")
		local UserLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local LogoImage = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")
		local UserStatusLabel = Instance.new("TextLabel")

		UserFrame.Name = NeverLose.RandomString();
		UserFrame.Parent = Frame
		UserFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		UserFrame.BackgroundTransparency = 1.000
		UserFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		UserFrame.BorderSizePixel = 0
		UserFrame.Size = UDim2.new(1, 0, 0, 60)
		UserFrame.ZIndex = LayerIndex + 8

		UserLabel.Name = NeverLose.RandomString();
		UserLabel.Parent = UserFrame
		UserLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		UserLabel.BackgroundTransparency = 1.000
		UserLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		UserLabel.BorderSizePixel = 0
		UserLabel.Position = UDim2.new(0, 65, 0, 10)
		UserLabel.Size = UDim2.new(1, -35, 0, 15)
		UserLabel.ZIndex = LayerIndex + 9
		UserLabel.Font = Enum.Font.GothamMedium
		UserLabel.Text = Name or 'User'
		UserLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		UserLabel.TextSize = 13.000
		UserLabel.TextTransparency = 0.200
		UserLabel.TextXAlignment = Enum.TextXAlignment.Left

		LineFrame.Name = NeverLose.RandomString();
		LineFrame.Parent = UserFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = LayerIndex + 11

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = UserFrame

		LogoImage.Name = NeverLose.RandomString();
		LogoImage.Parent = UserFrame
		LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LogoImage.BackgroundTransparency = 1.000
		LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogoImage.BorderSizePixel = 0
		LogoImage.Position = UDim2.new(0, 10, 0, 5)
		LogoImage.Size = UDim2.new(0, 45, 0, 45)
		LogoImage.ZIndex = LayerIndex + 9
		LogoImage.Image = Profile or "rbxasset://textures/ui/clb_robux_20@3x.png";

		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = LogoImage

		UserStatusLabel.Name = NeverLose.RandomString();
		UserStatusLabel.Parent = UserFrame
		UserStatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		UserStatusLabel.BackgroundTransparency = 1.000
		UserStatusLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		UserStatusLabel.BorderSizePixel = 0
		UserStatusLabel.Position = UDim2.new(0, 65, 0, 25)
		UserStatusLabel.Size = UDim2.new(1, -35, 0, 15)
		UserStatusLabel.ZIndex = LayerIndex + 9
		UserStatusLabel.Font = Enum.Font.GothamMedium
		UserStatusLabel.Text = Expires or '( Release )'
		UserStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		UserStatusLabel.TextSize = 13.000
		UserStatusLabel.TextTransparency = 0.200
		UserStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
		UserFrame:SetAttribute("ThemeLock", true)
		UserLabel:SetAttribute("ThemeLock", true)
		LineFrame:SetAttribute("ThemeLock", true)
		LogoImage:SetAttribute("ThemeLock", true)
		UserStatusLabel:SetAttribute("ThemeLock", true)

		local UserFrameItem = {};

		UserFrameItem.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(UserLabel,SlowyTween,{
					TextTransparency = 0.200
				})

				NeverLose.PlayAnimate(LineFrame,SlowyTween,{
					BackgroundTransparency = 0.650
				})

				NeverLose.PlayAnimate(LogoImage,SlowyTween,{
					ImageTransparency = 0
				})

				NeverLose.PlayAnimate(UserStatusLabel,SlowyTween,{
					TextTransparency = 0.200
				})
			else
				NeverLose.PlayAnimate(UserLabel,SlowyTween,{
					TextTransparency = 1
				})

				NeverLose.PlayAnimate(LineFrame,SlowyTween,{
					BackgroundTransparency = 1
				})

				NeverLose.PlayAnimate(LogoImage,SlowyTween,{
					ImageTransparency = 1
				})

				NeverLose.PlayAnimate(UserStatusLabel,SlowyTween,{
					TextTransparency = 1
				})
			end;
		end);

		UserFrameItem.SetRender(Signel:GetValue())
		Signel:Connect(UserFrameItem.SetRender);

		function UserFrameItem:SetUsername(name)
			UserLabel.Text = name or 'User'
		end;

		function UserFrameItem:SetProfile(Profile)
			LogoImage.Image = Profile or "rbxasset://textures/ui/clb_robux_20@3x.png";
		end;

		function UserFrameItem:SetExpires(Exp)
			UserStatusLabel.Text = Exp or '( Release )';
		end;

		return UserFrameItem;
	end;

	return idx;
end;

function NeverLose:CreateWindow(Config)
	Config = NeverLose:ProcessParams(Config , {
		Logo = NeverLose.GlobalLogo,
		Name = "Neverlose",
		Content = "Counter-Strike 2",
		Size = UDim2.new(0, 640, 0, 480),
		ConfigFolder = "NeverLoseConfigs",
		Enable3DRenderer = false,
		Keybind = "Insert"
	});

	local Window = {
		Logo = Config.Logo,
		Name = Config.Name,
		Content = Config.Content,
		Size = Config.Size,
		ConfigFolder = Config.ConfigFolder,
		Signal = NeverLose:CreateSignal(true),
		Tabs = {},
		CurrentTab = 1,
		Keybind = Config.Keybind,
		Enable3DRenderer = Config.Enable3DRenderer
	};

	NeverLose.GlobalLogo = Window.Logo;

	local Logging = NeverLose:CreateLogger();
	if not isfolder(Window.ConfigFolder) then
		makefolder(Window.ConfigFolder);
	end;

	local WindowFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local LeftMenuFrame = Instance.new("Frame")
	local HeadFrame = Instance.new("Frame")
	local LogoImage = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local WindowName = Instance.new("TextLabel")
	local WindowContent = Instance.new("TextLabel")
	local LineFrame = Instance.new("Frame")
	local LeftScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local BottomFrame = Instance.new("Frame")
	local AccountProfile = Instance.new("ImageLabel")
	local UICorner_3 = Instance.new("UICorner")
	local AccountName = Instance.new("TextLabel")
	local ExpireLabel = Instance.new("TextLabel")
	local LineFrame_2 = Instance.new("Frame")
	local UserSettingButton = Instance.new("TextLabel")
	local RightMenuFrame = Instance.new("Frame")
	local UIStroke = Instance.new("UIStroke")
	local UICorner_4 = Instance.new("UICorner")
	local RightHeader = Instance.new("Frame")
	local LineFrame_3 = Instance.new("Frame")
	local ConfigFrame = Instance.new("Frame")
	local UIStroke_2 = Instance.new("UIStroke")
	local UICorner_5 = Instance.new("UICorner")
	local ConfigIcon = Instance.new("TextLabel")
	local LineFrame_4 = Instance.new("Frame")
	local ConfigName = Instance.new("TextLabel")
	local ConfigBthIcon = Instance.new("TextLabel")
	local SearchFrame = Instance.new("Frame")
	local SearchIcon = Instance.new("TextLabel")
	local SearchBox = Instance.new("TextBox")
	local TabContainer = Instance.new("Frame")

	WindowFrame.Name = NeverLose.RandomString();
	WindowFrame.Parent = NeverLose.ScreenGui;
	NeverLose.WindowFrame = WindowFrame;
	WindowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	WindowFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
	WindowFrame.BackgroundTransparency = 0.055
	WindowFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowFrame.BorderSizePixel = 0
	WindowFrame.ClipsDescendants = true
	WindowFrame.Position = UDim2.new(255, 0, 255, 0)
	WindowFrame.Size = Window.Size
	WindowFrame.Active = true;

	if not NeverLose.EnabledBlur then
		WindowFrame.BackgroundTransparency = 0.0255
	end;

	local renderParentWindow = LPH_NO_VIRTUALIZE(function()
		if Window.__3DRender then
			if WindowFrame.BackgroundTransparency > 0.9 then
				WindowFrame.Visible = false;
				WindowFrame.Parent = nil
			else
				WindowFrame.Visible = true;

				NeverLose.PlayAnimate(WindowFrame,VSlowTween , {
					Position = UDim2.fromScale(0.5,0.5);
				});

				WindowFrame.Parent = Window.SurfaceGui;
			end;
		else
			if WindowFrame.BackgroundTransparency > 0.9 then
				WindowFrame.Visible = false;
				WindowFrame.Parent = nil
			else
				WindowFrame.Visible = true;
				WindowFrame.Parent = NeverLose.ScreenGui


			end;
		end;
	end);

	NeverLose:AddSignal(WindowFrame:GetPropertyChangedSignal('BackgroundTransparency'):Connect(renderParentWindow))

	Window.SetRender = LPH_NO_VIRTUALIZE(function(self , value)
		if value then
			NeverLose.PlayAnimate(WindowFrame , SlowyTween , {
				BackgroundTransparency = (NeverLose.EnabledBlur and 0.055) or 0.0255,
				Size = Window.Size
			})

			NeverLose.PlayAnimate(LogoImage , SlowyTween , {
				ImageTransparency = 0
			})

			NeverLose.PlayAnimate(WindowName , SlowyTween , {
				TextTransparency = 0
			})

			NeverLose.PlayAnimate(WindowContent , SlowyTween , {
				TextTransparency = 0.650
			})

			NeverLose.PlayAnimate(LineFrame , SlowyTween , {
				BackgroundTransparency = 0.650
			})

			NeverLose.PlayAnimate(AccountProfile , SlowyTween , {
				ImageTransparency = 0
			})

			NeverLose.PlayAnimate(AccountName , SlowyTween , {
				TextTransparency = 0
			})

			NeverLose.PlayAnimate(ExpireLabel , SlowyTween , {
				TextTransparency = 0.650
			})

			NeverLose.PlayAnimate(LineFrame_2 , SlowyTween , {
				BackgroundTransparency = 0.650
			})

			NeverLose.PlayAnimate(UserSettingButton , SlowyTween , {
				TextTransparency = 0.5
			})

			NeverLose.PlayAnimate(RightMenuFrame , SlowyTween , {
				BackgroundTransparency = 0.600
			})

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 0.650
			})

			NeverLose.PlayAnimate(LineFrame_3 , SlowyTween , {
				BackgroundTransparency = 0.650
			})

			NeverLose.PlayAnimate(ConfigFrame , SlowyTween , {
				BackgroundTransparency = 0.750
			})

			NeverLose.PlayAnimate(UIStroke_2 , SlowyTween , {
				Transparency = 0.650
			})

			NeverLose.PlayAnimate(ConfigIcon , SlowyTween , {
				TextTransparency = 0.250
			})

			NeverLose.PlayAnimate(LineFrame_4 , SlowyTween , {
				BackgroundTransparency = 0.650
			})

			NeverLose.PlayAnimate(ConfigName , SlowyTween , {
				TextTransparency = 0.350
			})

			NeverLose.PlayAnimate(ConfigBthIcon , SlowyTween , {
				TextTransparency = 0.250
			})

			NeverLose.PlayAnimate(SearchIcon , SlowyTween , {
				TextTransparency = 0.250
			})

			NeverLose.PlayAnimate(SearchBox , SlowyTween , {
				TextTransparency = 0.350
			})

			Window.Shadow:Render(true);
		else

			NeverLose.PlayAnimate(WindowFrame , SlowyTween , {
				BackgroundTransparency = 1,
				Size = Window.Size + UDim2.fromOffset(-15,-15)
			})

			NeverLose.PlayAnimate(LogoImage , SlowyTween , {
				ImageTransparency = 1
			})

			NeverLose.PlayAnimate(WindowName , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(WindowContent , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(LineFrame , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(AccountProfile , SlowyTween , {
				ImageTransparency = 1
			})

			NeverLose.PlayAnimate(AccountName , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(ExpireLabel , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(LineFrame_2 , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UserSettingButton , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(RightMenuFrame , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(LineFrame_3 , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(ConfigFrame , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke_2 , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(ConfigIcon , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(LineFrame_4 , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(ConfigName , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(ConfigBthIcon , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(SearchIcon , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(SearchBox , SlowyTween , {
				TextTransparency = 1
			})

			Window.Shadow:Render(false);
		end;
	end);

	Window.Shadow = NeverLose:CreateShadow(WindowFrame);
	Window.Shadow:Render(false);

	task.delay(0.25,function()
		WindowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		Window:SetRender(true);
		NeverLose:AddSignal(Window.Signal:Connect(LPH_NO_VIRTUALIZE(function(...)
			Window:SetRender(...);
		end)))
	end)

	if NeverLose.EnabledBlur then
		NeverLose:CreateBlurModule(WindowFrame,Window.Signal);
	end;

	do
		local Frame = Instance.new("Frame")

		Frame.Parent = WindowFrame
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new(1, 0, 0, 50)
		Frame.ZIndex = 7
		Frame.BackgroundTransparency = 1;

		NeverLose.Drag(Frame , WindowFrame , 0.15)
	end

	UICorner.Parent = WindowFrame

	LeftMenuFrame.Name = NeverLose.RandomString();
	LeftMenuFrame.Parent = WindowFrame
	LeftMenuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LeftMenuFrame.BackgroundTransparency = 1.000
	LeftMenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LeftMenuFrame.BorderSizePixel = 0
	LeftMenuFrame.Size = UDim2.new(0, 175, 1, 0)

	HeadFrame.Name = NeverLose.RandomString();
	HeadFrame.Parent = LeftMenuFrame
	HeadFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HeadFrame.BackgroundTransparency = 1.000
	HeadFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeadFrame.BorderSizePixel = 0
	HeadFrame.Size = UDim2.new(1, 0, 0, 50)
	HeadFrame.ZIndex = 7

	LogoImage.Name = NeverLose.RandomString();
	LogoImage.Parent = HeadFrame
	LogoImage.AnchorPoint = Vector2.new(0, 0.5)
	LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoImage.BackgroundTransparency = 1.000
	LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoImage.BorderSizePixel = 0
	LogoImage.Position = UDim2.new(0, 10, 0.5, 0)
	LogoImage.Size = UDim2.new(0, 35, 0, 35)
	LogoImage.ZIndex = 7
	LogoImage.Image = Window.Logo
	LogoImage.ImageColor3 = NeverLose.IconColor

	UICorner_2.CornerRadius = UDim.new(0, 7)
	UICorner_2.Parent = LogoImage

	WindowName.Name = NeverLose.RandomString();
	WindowName.Parent = HeadFrame
	WindowName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WindowName.BackgroundTransparency = 1.000
	WindowName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowName.BorderSizePixel = 0
	WindowName.Position = UDim2.new(0, 55, 0, 4)
	WindowName.Size = UDim2.new(0, 200, 0, 25)
	WindowName.ZIndex = 7
	WindowName.Font = Enum.Font.GothamBold
	WindowName.Text = Window.Name
	WindowName.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowName.TextSize = 18.000
	WindowName.TextXAlignment = Enum.TextXAlignment.Left
	WindowName:SetAttribute("ThemeLock", true)
	WindowName:SetAttribute("ThemeKeepText", true)

	WindowContent.Name = NeverLose.RandomString();
	WindowContent.Parent = HeadFrame
	WindowContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WindowContent.BackgroundTransparency = 1.000
	WindowContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowContent.BorderSizePixel = 0
	WindowContent.Position = UDim2.new(0, 55, 0, 25)
	WindowContent.Size = UDim2.new(0, 200, 0, 15)
	WindowContent.ZIndex = 7
	WindowContent.Font = Enum.Font.GothamBold
	WindowContent.Text = Window.Content
	WindowContent.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowContent.TextSize = 9.000
	WindowContent.TextTransparency = 0.650
	WindowContent.TextXAlignment = Enum.TextXAlignment.Left

	LineFrame.Name = NeverLose.RandomString();
	LineFrame.Parent = HeadFrame
	LineFrame.AnchorPoint = Vector2.new(0.5, 1)
	LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
	LineFrame.BackgroundTransparency = 0.650
	LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame.BorderSizePixel = 0
	LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
	LineFrame.Size = UDim2.new(1, -10, 0, 1)
	LineFrame.ZIndex = 5

	LeftScrollingFrame.Name = NeverLose.RandomString();
	LeftScrollingFrame.Parent = LeftMenuFrame
	LeftScrollingFrame.Active = true
	LeftScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
	LeftScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LeftScrollingFrame.BackgroundTransparency = 1.000
	LeftScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LeftScrollingFrame.BorderSizePixel = 0
	LeftScrollingFrame.Position = UDim2.new(0.5, 0, 0, 60)
	LeftScrollingFrame.Size = UDim2.new(1, -10, 1, -115)
	LeftScrollingFrame.ZIndex = 7
	LeftScrollingFrame.ScrollBarThickness = 0

	UIListLayout.Parent = LeftScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
		LeftScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 1)
	end)))

	BottomFrame.Name = NeverLose.RandomString();
	BottomFrame.Parent = LeftMenuFrame
	BottomFrame.AnchorPoint = Vector2.new(0, 1)
	BottomFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	BottomFrame.BackgroundTransparency = 1.000
	BottomFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BottomFrame.BorderSizePixel = 0
	BottomFrame.Position = UDim2.new(0, 0, 1, 0)
	BottomFrame.Size = UDim2.new(1, 0, 0, 50)
	BottomFrame.ZIndex = 7

	AccountProfile.Name = NeverLose.RandomString();
	AccountProfile.Parent = BottomFrame
	AccountProfile.AnchorPoint = Vector2.new(0, 0.5)
	AccountProfile.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AccountProfile.BackgroundTransparency = 1.000
	AccountProfile.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AccountProfile.BorderSizePixel = 0
	AccountProfile.Position = UDim2.new(0, 10, 0.5, 0)
	AccountProfile.Size = UDim2.new(0, 35, 0, 35)
	AccountProfile.ZIndex = 7
	AccountProfile.Image = NeverLose.UserProfile or ""

	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = AccountProfile

	AccountName.Name = NeverLose.RandomString();
	AccountName.Parent = BottomFrame
	AccountName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AccountName.BackgroundTransparency = 1.000
	AccountName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AccountName.BorderSizePixel = 0
	AccountName.Position = UDim2.new(0, 55, 0, 5)
	AccountName.Size = UDim2.new(0, 100, 0, 25)
	AccountName.ZIndex = 7
	AccountName.Font = Enum.Font.GothamBold
	AccountName.Text = ""
	AccountName.TextColor3 = Color3.fromRGB(255, 255, 255)
	AccountName.TextSize = 14.000
	AccountName.TextXAlignment = Enum.TextXAlignment.Left
	AccountName.TextTruncate = Enum.TextTruncate.SplitWord;

	ExpireLabel.Name = NeverLose.RandomString();
	ExpireLabel.Parent = BottomFrame
	ExpireLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ExpireLabel.BackgroundTransparency = 1.000
	ExpireLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ExpireLabel.BorderSizePixel = 0
	ExpireLabel.Position = UDim2.new(0, 55, 0, 25)
	ExpireLabel.Size = UDim2.new(0, 200, 0, 15)
	ExpireLabel.ZIndex = 7
	ExpireLabel.Font = Enum.Font.GothamBold
	ExpireLabel.Text = "( Release )"
	ExpireLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	ExpireLabel.TextSize = 10.000
	ExpireLabel.TextTransparency = 0.650
	ExpireLabel.TextXAlignment = Enum.TextXAlignment.Left

	LineFrame_2.Name = NeverLose.RandomString();
	LineFrame_2.Parent = BottomFrame
	LineFrame_2.AnchorPoint = Vector2.new(0.5, 0)
	LineFrame_2.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
	LineFrame_2.BackgroundTransparency = 0.650
	LineFrame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame_2.BorderSizePixel = 0
	LineFrame_2.Position = UDim2.new(0.5, 0, 0, 0)
	LineFrame_2.Size = UDim2.new(1, -10, 0, 1)
	LineFrame_2.ZIndex = 5

	UserSettingButton.Name = NeverLose.RandomString();
	UserSettingButton.Parent = BottomFrame
	UserSettingButton.AnchorPoint = Vector2.new(1, 0.5)
	UserSettingButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserSettingButton.BackgroundTransparency = 1.000
	UserSettingButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	UserSettingButton.BorderSizePixel = 0
	UserSettingButton.Position = UDim2.new(1, -7, 0.5, 0)
	UserSettingButton.Size = UDim2.new(0, 25, 0, 25)
	UserSettingButton.ZIndex = 7
	UserSettingButton.FontFace = NeverLose.BuiltInBold
	UserSettingButton.Text = "chevron-large-right"
	UserSettingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	UserSettingButton.TextSize = 13.000
	UserSettingButton.TextTransparency = 0.5
	AccountProfile:SetAttribute("ThemeLock", true)
	AccountName:SetAttribute("ThemeLock", true)
	ExpireLabel:SetAttribute("ThemeLock", true)
	UserSettingButton:SetAttribute("ThemeLock", true)

	NeverLose:AddSignal(BottomFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
		NeverLose.PlayAnimate(UserSettingButton,SlowyTween , {
			TextTransparency = 0.25
		})		
	end)))

	NeverLose:AddSignal(BottomFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
		NeverLose.PlayAnimate(UserSettingButton,SlowyTween , {
			TextTransparency = 0.5
		})		
	end)))

RightMenuFrame.Name = NeverLose.RandomString();
RightMenuFrame.Parent = WindowFrame
NeverLose.RightMenuFrame = RightMenuFrame;
	RightMenuFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
	RightMenuFrame.BackgroundTransparency = 0.600
	RightMenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	RightMenuFrame.BorderSizePixel = 0
	RightMenuFrame.ClipsDescendants = true
	RightMenuFrame.Position = UDim2.new(0, 176, 0, 0)
	RightMenuFrame.Size = UDim2.new(1, -176, 1, 0)
	RightMenuFrame.ZIndex = 8

	UIStroke.Transparency = 0.650
	UIStroke.Color = Color3.fromRGB(45, 48, 58)
	UIStroke.Parent = RightMenuFrame

	UICorner_4.CornerRadius = UDim.new(0, 13)
	UICorner_4.Parent = RightMenuFrame

	RightHeader.Name = NeverLose.RandomString();
	RightHeader.Parent = RightMenuFrame
	RightHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	RightHeader.BackgroundTransparency = 1.000
	RightHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
	RightHeader.BorderSizePixel = 0
	RightHeader.Size = UDim2.new(1, 0, 0, 50)
	RightHeader.ZIndex = 9

	LineFrame_3.Name = NeverLose.RandomString();
	LineFrame_3.Parent = RightHeader
	LineFrame_3.AnchorPoint = Vector2.new(0.5, 1)
	LineFrame_3.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
	LineFrame_3.BackgroundTransparency = 0.650
	LineFrame_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame_3.BorderSizePixel = 0
	LineFrame_3.Position = UDim2.new(0.5, 0, 1, 0)
	LineFrame_3.Size = UDim2.new(1, -10, 0, 1)
	LineFrame_3.ZIndex = 9

	ConfigFrame.Name = NeverLose.RandomString();
	ConfigFrame.Parent = RightHeader
	ConfigFrame.AnchorPoint = Vector2.new(0, 0.5)
	ConfigFrame.BackgroundColor3 = Color3.fromRGB(13, 17, 22)
	ConfigFrame.BackgroundTransparency = 0.750
	ConfigFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigFrame.BorderSizePixel = 0
	ConfigFrame.Position = UDim2.new(0, 10, 0.5, 0)
	ConfigFrame.Size = UDim2.new(0, 115, 0, 30)
	ConfigFrame.ZIndex = 9

	UIStroke_2.Transparency = 0.650
	UIStroke_2.Color = Color3.fromRGB(45, 48, 58)
	UIStroke_2.Parent = ConfigFrame

	UICorner_5.CornerRadius = UDim.new(0, 4)
	UICorner_5.Parent = ConfigFrame

	ConfigIcon.Name = NeverLose.RandomString();
	ConfigIcon.Parent = ConfigFrame
	ConfigIcon.AnchorPoint = Vector2.new(0, 0.5)
	ConfigIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConfigIcon.BackgroundTransparency = 1.000
	ConfigIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigIcon.BorderSizePixel = 0
	ConfigIcon.Position = UDim2.new(0, 2, 0.5, 0)
	ConfigIcon.Size = UDim2.new(0, 25, 0, 25)
	ConfigIcon.ZIndex = 9
	ConfigIcon.FontFace = NeverLose.BuiltInBold
	ConfigIcon.Text = "floppy-disk"
	ConfigIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
	ConfigIcon.TextSize = 16.000
	ConfigIcon.TextTransparency = 0.250
	ConfigIcon.TextWrapped = true

	LineFrame_4.Name = NeverLose.RandomString();
	LineFrame_4.Parent = ConfigFrame
	LineFrame_4.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
	LineFrame_4.BackgroundTransparency = 0.650
	LineFrame_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame_4.BorderSizePixel = 0
	LineFrame_4.Position = UDim2.new(0, 30, 0, 0)
	LineFrame_4.Size = UDim2.new(0, 1, 1, 0)

	ConfigName.Name = NeverLose.RandomString();
	ConfigName.Parent = ConfigFrame
	ConfigName.AnchorPoint = Vector2.new(0, 0.5)
	ConfigName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConfigName.BackgroundTransparency = 1.000
	ConfigName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigName.BorderSizePixel = 0
	ConfigName.Position = UDim2.new(0, 40, 0.5, 0)
	ConfigName.Size = UDim2.new(1, -7, 0, 15)
	ConfigName.ZIndex = 9
	ConfigName.Font = Enum.Font.GothamMedium
	ConfigName.Text = "Default"
	ConfigName.TextColor3 = Color3.fromRGB(255, 255, 255)
	ConfigName.TextSize = 12.000
	ConfigName.TextTransparency = 0.350
	ConfigName.TextXAlignment = Enum.TextXAlignment.Left

	ConfigBthIcon.Name = NeverLose.RandomString();
	ConfigBthIcon.Parent = ConfigFrame
	ConfigBthIcon.AnchorPoint = Vector2.new(1, 0.5)
	ConfigBthIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConfigBthIcon.BackgroundTransparency = 1.000
	ConfigBthIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigBthIcon.BorderSizePixel = 0
	ConfigBthIcon.Position = UDim2.new(1, -2, 0.5, 0)
	ConfigBthIcon.Size = UDim2.new(0, 25, 0, 25)
	ConfigBthIcon.ZIndex = 9
	ConfigBthIcon.FontFace = NeverLose.BuiltInBold
	ConfigBthIcon.Text = "chevron-small-down"
	ConfigBthIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
	ConfigBthIcon.TextSize = 16.000
	ConfigBthIcon.TextTransparency = 0.250
	ConfigBthIcon.TextWrapped = true

	SearchFrame.Name = NeverLose.RandomString();
	SearchFrame.Parent = RightHeader
	SearchFrame.AnchorPoint = Vector2.new(1, 0.5)
	SearchFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchFrame.BackgroundTransparency = 1.000
	SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchFrame.BorderSizePixel = 0
	SearchFrame.ClipsDescendants = true
	SearchFrame.Position = UDim2.new(1, -10, 0.5, 0)
	SearchFrame.Size = UDim2.new(0, 30, 0, 30)
	SearchFrame.ZIndex = 12

	SearchIcon.Name = NeverLose.RandomString();
	SearchIcon.Parent = SearchFrame
	SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
	SearchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchIcon.BackgroundTransparency = 1.000
	SearchIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchIcon.BorderSizePixel = 0
	SearchIcon.Position = UDim2.new(0, 2, 0.5, 0)
	SearchIcon.Size = UDim2.new(0, 25, 0, 25)
	SearchIcon.ZIndex = 12
	SearchIcon.FontFace = NeverLose.BuiltInBold
	SearchIcon.Text = "magnifying-glass"
	SearchIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
	SearchIcon.TextSize = 14.000
	SearchIcon.TextTransparency = 0.45
	SearchIcon.TextWrapped = true

	SearchBox.Name = NeverLose.RandomString();
	SearchBox.Parent = SearchFrame
	SearchBox.AnchorPoint = Vector2.new(0, 0.5)
	SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchBox.BackgroundTransparency = 1.000
	SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchBox.BorderSizePixel = 0
	SearchBox.Position = UDim2.new(0, 35, 0.5, 0)
	SearchBox.Size = UDim2.new(1, -35, 0, 25)
	SearchBox.ZIndex = 12
	SearchBox.ClearTextOnFocus = false
	SearchBox.Font = Enum.Font.GothamMedium
	SearchBox.PlaceholderText = "Search"
	SearchBox.Text = ""
	SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	SearchBox.TextSize = 13.000
	SearchBox.TextTransparency = 1
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left

	TabContainer.Name = NeverLose.RandomString();
	TabContainer.Parent = RightMenuFrame
	TabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabContainer.BackgroundTransparency = 1.000
	TabContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabContainer.BorderSizePixel = 0
	TabContainer.ClipsDescendants = true
	TabContainer.Position = UDim2.new(0, 0, 0, 50)
	TabContainer.Size = UDim2.new(1, 0, 1, -50)
	TabContainer.ZIndex = 5

	do
		Window.Searching = false;
		local Input = NeverLose:CreateInput(SearchIcon , LPH_NO_VIRTUALIZE(function()
			Window.Searching = not Window.Searching;

			if Window.Searching then
				NeverLose.PlayAnimate(SearchFrame , VSlowTween , {
					Size = UDim2.new(0, 220, 0, 30)
				})

				NeverLose.PlayAnimate(SearchIcon , SlowyTween , {
					TextTransparency = 0.25
				})

				NeverLose.PlayAnimate(SearchBox , VSlowTween , {
					TextTransparency = 0.350
				})
			else
				NeverLose.PlayAnimate(SearchFrame , VSlowTween , {
					Size = UDim2.new(0, 30, 0, 30)
				})

				NeverLose.PlayAnimate(SearchIcon , SlowyTween , {
					TextTransparency = 0.45
				})

				NeverLose.PlayAnimate(SearchBox , SlowyTween , {
					TextTransparency = 1
				})

				SearchBox.Text = "";
			end;
		end));	

		local wati_for_finish = tick();
		local last_thread;
		local max_time = 0.2;

		NeverLose:AddSignal(SearchBox:GetPropertyChangedSignal('Text'):Connect(LPH_NO_VIRTUALIZE(function()
			if not SearchBox.Text:byte() then
				for i,v in next , NeverLose.NameRegisitry do
					v.Root.Visible = true;
				end;

				return;	
			end;

			wati_for_finish = tick();

			if last_thread then
				task.cancel(last_thread);
				last_thread = nil;
			end;

			last_thread = task.delay(max_time,function()
				if SearchBox.Text:byte() and (tick() - wati_for_finish) > max_time then
					for i,v in next , NeverLose.NameRegisitry do
						if string.find(string.lower(v.Idx) , string.lower(SearchBox.Text), 1, true) then
							v.Root.Visible = true;
						else
							v.Root.Visible = false;
						end;
					end;
				end;
			end);
		end)));

		NeverLose:AddSignal(Input.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(SearchIcon , SlowyTween , {
				TextTransparency = 0.25
			})
		end)))

		NeverLose:AddSignal(Input.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			if Window.Searching then
				NeverLose.PlayAnimate(SearchIcon , SlowyTween , {
					TextTransparency = 0.25
				})
			else
				NeverLose.PlayAnimate(SearchIcon , SlowyTween , {
					TextTransparency = 0.45
				})
			end;
		end)));
	end;

	if Window.Enable3DRenderer then
		local Part = Instance.new('Part');

		Part.Name = NeverLose.RandomString();
		Part.Anchored = true;
		Part.Transparency = 1;
		Part.CanCollide = false;
		Part.CanTouch = false;
		Part.AudioCanCollide = false;
		Part.CollisionGroup = NeverLose.RandomString();
		Part.CFrame = CFrame.new(0,0,0);
		Part.Size = Vector3.zero;

		local SurfaceGui = Instance.new("SurfaceGui")

		SurfaceGui.Parent = NeverLose.ScreenGui;
		SurfaceGui.Adornee = Part;
		SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		SurfaceGui.AlwaysOnTop = true
		SurfaceGui.LightInfluence = 1.000
		SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
		SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize;
		SurfaceGui.PixelsPerStud = 40;

		Window.SurfaceGui = SurfaceGui;
		NeverLose.GlobalSurfaceGui = SurfaceGui;

		local PerfectScale = Vector2.new(1920 , 1080 + 300)

		Window.Load3DBlock = LPH_NO_VIRTUALIZE(function()
			if not Window.Signal:GetValue() then
				local _,OnScreen = CurrentCamera:WorldToViewportPoint(Part.Position);

				if OnScreen then
					NeverLose.PlayAnimate(Part,VSlowTween , {
						CFrame = CurrentCamera.CFrame * CFrame.new(0,0,-15) * CFrame.Angles(0,math.rad(180),0);
					});
				end;

				return
			end;

			local Dimensions = 50;

			local XY_Incom = Vector2.new(PerfectScale.X + 5, PerfectScale.Y * 1.35) / (Dimensions / 2);
			local PerfectDistance = XY_Incom.Magnitude;
			local SizeIndicator = PerfectDistance / 1.35;

			Part.Parent = NeverLose.BlurModuleParent or workspace;

			NeverLose.PlayAnimate(Part,VSlowTween , {
				CFrame = (CurrentCamera.CFrame * CFrame.new(0,0,-25)) * CFrame.Angles(0,math.rad(180),0);
			});

			Part.Size = Vector3.new(PerfectScale.X / SizeIndicator,PerfectScale.Y / SizeIndicator,0);
		end);

		function Window:Set3DRender(val)
			Window.__3DRender = val;
			NeverLose.Global3DRenderMode = val;

			if val then
				Window.Load3DBlock();
			else


				Part.Parent = nil;
			end;

			renderParentWindow();
		end;
	end;

	function Window:AddTabLabel(Name: string)
		local TabLabel = Instance.new("TextLabel")

		TabLabel.Name = NeverLose.RandomString()
		TabLabel.Parent = LeftScrollingFrame
		TabLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabLabel.BackgroundTransparency = 1.000
		TabLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabLabel.BorderSizePixel = 0
		TabLabel.Size = UDim2.new(1, -7, 0, 15)
		TabLabel.ZIndex = 8
		TabLabel.Font = Enum.Font.GothamMedium
		TabLabel.Text = Name
		TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabLabel.TextSize = 11.000
		TabLabel.TextTransparency = 0.500
		TabLabel.TextXAlignment = Enum.TextXAlignment.Left

		local SetRender = LPH_NO_VIRTUALIZE(function(val)
			if val then
				NeverLose.PlayAnimate(TabLabel , SlowyTween,{
					TextTransparency = 0.500
				})
			else
				NeverLose.PlayAnimate(TabLabel , SlowyTween,{
					TextTransparency = 1
				})
			end
		end)

		SetRender(Window.Signal:GetValue());

		return Window.Signal:Connect(SetRender);
	end;

	function Window:AddTab(Config)
		Config = NeverLose:ProcessParams(Config , {
			Icon = "crosshairs",
			Name = "Tab",
			Type = "Double"
		});

		local Tab = {
			Signal = NeverLose:CreateSignal(false);
		};

		local TabButton = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local TabIcon = Instance.new("TextLabel")
		local TabContentLabel = Instance.new("TextLabel")

		Tab.Idx = TabButton;

		TabButton.Name = NeverLose.RandomString();
		TabButton.Parent = LeftScrollingFrame
		TabButton.BackgroundColor3 = Color3.fromRGB(41, 45, 49)
		TabButton.BackgroundTransparency = 0.500
		TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, -1, 0, 30)
		TabButton.ZIndex = 8

		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = TabButton

		TabIcon.Name = NeverLose.RandomString();
		TabIcon.Parent = TabButton
		TabIcon.AnchorPoint = Vector2.new(0, 0.5)
		TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabIcon.BackgroundTransparency = 1.000
		TabIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabIcon.BorderSizePixel = 0
		TabIcon.Position = UDim2.new(0, 2, 0.5, 0)
		TabIcon.Size = UDim2.new(0, 25, 0, 25)
		TabIcon.ZIndex = 9
		TabIcon.FontFace = NeverLose.BuiltInBold
		TabIcon.Text = Config.Icon;
		TabIcon.TextColor3 = Color3.fromRGB(139, 92, 246)
		TabIcon.TextSize = 16.000
		TabIcon.TextWrapped = true

		TabContentLabel.Name = NeverLose.RandomString();
		TabContentLabel.Parent = TabButton
		TabContentLabel.AnchorPoint = Vector2.new(0, 0.5)
		TabContentLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabContentLabel.BackgroundTransparency = 1.000
		TabContentLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabContentLabel.BorderSizePixel = 0
		TabContentLabel.Position = UDim2.new(0, 30, 0.5, 0)
		TabContentLabel.Size = UDim2.new(1, -7, 0, 15)
		TabContentLabel.ZIndex = 9
		TabContentLabel.Font = Enum.Font.GothamMedium
		TabContentLabel.Text = Config.Name
		TabContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabContentLabel.TextSize = 12.000
		TabContentLabel.TextXAlignment = Enum.TextXAlignment.Left
		TabButton:SetAttribute("ThemeLock", true)
		TabIcon:SetAttribute("ThemeLock", true)
		TabContentLabel:SetAttribute("ThemeLock", true)

		local TabFrame = Instance.new("Frame")
		local LeftScroll = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local RightScroll = Instance.new("ScrollingFrame")
		local UIListLayout_2 = Instance.new("UIListLayout")

		TabFrame.Name = NeverLose.RandomString();
		TabFrame.Parent = TabContainer
		TabFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		TabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabFrame.BackgroundTransparency = 1.000
		TabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabFrame.BorderSizePixel = 0
		TabFrame.ClipsDescendants = true
		TabFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		TabFrame.Size = UDim2.new(1, 0, 1, 0)
		TabFrame.Visible = true;

		LeftScroll.Name = NeverLose.RandomString();
		LeftScroll.Parent = TabFrame
		LeftScroll.Active = true
		LeftScroll.AnchorPoint = Vector2.new(0.5, 0.5)
		LeftScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LeftScroll.BackgroundTransparency = 1.000
		LeftScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LeftScroll.BorderSizePixel = 0
		LeftScroll.ClipsDescendants = false
		LeftScroll.Position = UDim2.new(0.25, 0, 0.5, 0)
		LeftScroll.Size = UDim2.new(0.5, 0, 1, -5)
		LeftScroll.ScrollBarThickness = 0

		UIListLayout.Parent = LeftScroll
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)

		NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
			LeftScroll.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 1)
		end)))

		RightScroll.Name = NeverLose.RandomString();
		RightScroll.Parent = TabFrame
		RightScroll.Active = true
		RightScroll.AnchorPoint = Vector2.new(0.5, 0.5)
		RightScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		RightScroll.BackgroundTransparency = 1.000
		RightScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
		RightScroll.BorderSizePixel = 0
		RightScroll.ClipsDescendants = false
		RightScroll.Position = UDim2.new(0.75, 0, 0.5, 0)
		RightScroll.Size = UDim2.new(0.5, 0, 1, -5)
		RightScroll.ScrollBarThickness = 0

		UIListLayout_2.Parent = RightScroll
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.Padding = UDim.new(0, 5)

		if Config.Type == "Single" then
			UIListLayout_2:Destroy();
			RightScroll:Destroy();
			RightScroll = LeftScroll;
			UIListLayout_2 = UIListLayout;
			LeftScroll.Size = UDim2.new(1, 0, 1, -5);
			LeftScroll.Position = UDim2.new(0.5, 0, 0.5, 0)
		else
			NeverLose:AddSignal(UIListLayout_2:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
				RightScroll.CanvasSize = UDim2.fromOffset(0,UIListLayout_2.AbsoluteContentSize.Y + 1)
			end)))
		end;

		NeverLose:AddSignal(TabIcon:GetPropertyChangedSignal('TextTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if TabIcon.TextTransparency > 0.4 then
				UIListLayout.Parent = nil;
				UIListLayout_2.Parent = nil;
				TabFrame.Visible = false;
				TabFrame.Parent = nil
			else
				UIListLayout.Parent = LeftScroll;
				UIListLayout_2.Parent = RightScroll;
				TabFrame.Visible = true;
				TabFrame.Parent = TabContainer;
			end;
		end)));

		Tab.SetValue = LPH_NO_VIRTUALIZE(function(value)
			Tab.Signal:SetValue(value);

			if value then
				NeverLose.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 0.500
				})

				NeverLose.PlayAnimate(TabIcon , SlowyTween , {
					TextTransparency = 0,
					TextColor3 = Color3.fromRGB(139, 92, 246)
				})

				NeverLose.PlayAnimate(TabContentLabel , SlowyTween , {
					TextTransparency = 0
				})
			else
				NeverLose.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 1
				})

				NeverLose.PlayAnimate(TabIcon , SlowyTween , {
					TextTransparency = 0.5,
					TextColor3 = Color3.fromRGB(252, 252, 252)
				})

				NeverLose.PlayAnimate(TabContentLabel , SlowyTween , {
					TextTransparency = 0.5
				})
			end;
		end);

		table.insert(Window.Tabs,Tab);

		if Window.Tabs[Window.CurrentTab] == Tab then
			Tab.SetValue(true)
		else
			Tab.SetValue(false);
		end;

		local over = NeverLose:CreateInput(TabButton,LPH_NO_VIRTUALIZE(function()
			for i,v in next , Window.Tabs do
				if v.Idx == TabButton then
					v.SetValue(true);
					Window.CurrentTab = i;
				else
					v.SetValue(false);
				end;
			end;
		end));

		NeverLose:AddSignal(over.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			if Window.Tabs[Window.CurrentTab] == Tab then
				NeverLose.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 0.500
				})
			else
				NeverLose.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 0.8
				})
			end;
		end)))

		NeverLose:AddSignal(over.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			if Window.Tabs[Window.CurrentTab] == Tab then
				NeverLose.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 0.500
				})
			else
				NeverLose.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 1
				})
			end;
		end)))

		Window.Signal:Connect(LPH_NO_VIRTUALIZE(function(value)
			if value then
				if Window.Tabs[Window.CurrentTab] == Tab then
					Tab.SetValue(true)
				else
					Tab.SetValue(false);
				end;
			else
				Tab.SetValue(false);

				NeverLose.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 1
				})

				NeverLose.PlayAnimate(TabIcon , SlowyTween , {
					TextTransparency = 1,
				})

				NeverLose.PlayAnimate(TabContentLabel , SlowyTween , {
					TextTransparency = 1
				})
			end;
		end));

		function Tab:AddSection(Config)
			Config = NeverLose:ProcessParams(Config , {
				Name = "SECTION",
				Position = 'left',
				Collapsible = false
			});

			local Collapsed = false

			local SectionFrame = Instance.new("Frame")
			local SectionLabel = Instance.new("TextLabel")
			local SectionHandler = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local UIListLayout = Instance.new("UIListLayout")

			SectionFrame.Name = NeverLose.RandomString();
			SectionFrame.Parent = (string.lower(Config.Position) == 'left' and LeftScroll) or RightScroll
			SectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionFrame.BackgroundTransparency = 1.000
			SectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionFrame.BorderSizePixel = 0
			SectionFrame.ClipsDescendants = true
			SectionFrame.Size = UDim2.new(1, -5, 0, 0)
			SectionFrame.ZIndex = 9

			SectionLabel.Name = NeverLose.RandomString();
			SectionLabel.Parent = SectionFrame
			SectionLabel.AnchorPoint = Vector2.new(0.5, 0)
			SectionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionLabel.BackgroundTransparency = 1.000
			SectionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionLabel.BorderSizePixel = 0
			SectionLabel.Position = UDim2.new(0.5, 0, 0, 0)
			SectionLabel.Size = UDim2.new(1, -35, 0, 15)
			SectionLabel.ZIndex = 9
			SectionLabel.Font = Enum.Font.GothamMedium
			SectionLabel.Text = Config.Name
			SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionLabel.TextSize = 11.000
			SectionLabel.TextTransparency = 0.500
			SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

			SectionHandler.Name = NeverLose.RandomString();
			SectionHandler.Parent = SectionFrame
			SectionHandler.AnchorPoint = Vector2.new(0.5, 0)
			SectionHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
			SectionHandler.BackgroundTransparency = 0.500
			SectionHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionHandler.BorderSizePixel = 0
			SectionHandler.ClipsDescendants = true
			SectionHandler.Position = UDim2.new(0.5, 0, 0, 20)
			SectionHandler.Size = UDim2.new(1, -10, 1, -21)
			SectionHandler.ZIndex = 9

			UIStroke.Transparency = 0.650
			UIStroke.Color = Color3.fromRGB(45, 48, 58)
			UIStroke.Parent = SectionHandler

			UICorner.CornerRadius = UDim.new(0, 10)
			UICorner.Parent = SectionHandler

			UIListLayout.Parent = SectionHandler
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
				if Collapsed then return end

				if UIListLayout.AbsoluteContentSize.Y <= 1 then
					NeverLose.PlayAnimate(SectionFrame , VSlowTween , {
						Size = UDim2.new(1, -5, 0, 0)
					})
				else
					NeverLose.PlayAnimate(SectionFrame , VSlowTween , {
						Size = UDim2.new(1, -5, 0, UIListLayout.AbsoluteContentSize.Y + 19.5)
					})
				end;
			end));

			local Section = NeverLose:RegisiterItem(SectionHandler , Tab.Signal);

			Section.SetRender = LPH_NO_VIRTUALIZE(function(value)
				if value then
					NeverLose.PlayAnimate(SectionLabel,SlowyTween,{
						TextTransparency = 0.500
					})

					NeverLose.PlayAnimate(SectionHandler,SlowyTween,{
						BackgroundTransparency = 0.500
					})

					NeverLose.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 0.650
					})
				else
					NeverLose.PlayAnimate(SectionLabel,SlowyTween,{
						TextTransparency = 1
					})

					NeverLose.PlayAnimate(SectionHandler,SlowyTween,{
						BackgroundTransparency = 1
					})

					NeverLose.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 1
					})
				end;
			end);

			Section.SetRender(Tab.Signal:GetValue());
			Tab.Signal:Connect(Section.SetRender);

			if Config.Collapsible then
				local SectionArrow = Instance.new("TextLabel")
				SectionArrow.Parent = SectionFrame
				SectionArrow.AnchorPoint = Vector2.new(1, 0)
				SectionArrow.BackgroundTransparency = 1
				SectionArrow.BorderSizePixel = 0
				SectionArrow.Position = UDim2.new(1, -6, 0, 2)
				SectionArrow.Size = UDim2.new(0, 16, 0, 16)
				SectionArrow.ZIndex = 10
				SectionArrow.FontFace = NeverLose.BuiltInBold
				SectionArrow.Text = "caret-small-down"
				SectionArrow.TextColor3 = Color3.fromRGB(200, 205, 215)
				SectionArrow.TextSize = 14
				SectionArrow:SetAttribute("ThemeLock", true)

				local SectionClick = Instance.new("TextButton")
				SectionClick.Parent = SectionFrame
				SectionClick.AutoButtonColor = false
				SectionClick.BackgroundTransparency = 1
				SectionClick.BorderSizePixel = 0
				SectionClick.Position = UDim2.new(0, 0, 0, 0)
				SectionClick.Size = UDim2.new(1, 0, 0, 18)
				SectionClick.Text = ""
				SectionClick.ZIndex = 10

				function Section:SetCollapsed(state)
					Collapsed = state and true or false
					SectionArrow.Text = Collapsed and "caret-small-right" or "caret-small-down"
					SectionHandler.Visible = not Collapsed
					if Collapsed then
						NeverLose.PlayAnimate(SectionFrame, SlowyTween, {
							Size = UDim2.new(1, -5, 0, 18)
						})
					else
						NeverLose.PlayAnimate(SectionFrame, SlowyTween, {
							Size = UDim2.new(1, -5, 0, UIListLayout.AbsoluteContentSize.Y + 19.5)
						})
					end
					return self
				end

				SectionClick.MouseButton1Click:Connect(function()
					Section:SetCollapsed(not Collapsed)
				end)
			end

			function Section:AddToggle(Config)
				Config = Config or {};

				local Row = self:AddLabel((Config.Text or "Toggle") , false);

				local Toggle = Row:AddToggle(Config);

				function Toggle:ToolTip(Content)
					Row:ToolTip(Content);
					return self;
				end;

				function Toggle:AddKeybind(KeybindConfig)
					return Row:AddKeybind(KeybindConfig or {});
				end;

				return Toggle;
			end;

			function Section:AddSlider(Config)
				Config = Config or {};

				local Row = self:AddLabel((Config.Text or "Slider") , false);

				local Slider = Row:AddSlider(Config);

				function Slider:ToolTip(Content)
					Row:ToolTip(Content);
					return self;
				end;

				return Slider;
			end;

			function Section:AddDropdown(Config)
				Config = Config or {};

				local Row = self:AddLabel((Config.Text or "Dropdown") , false);

				local Dropdown = Row:AddDropdown(Config);

				function Dropdown:ToolTip(Content)
					Row:ToolTip(Content);
					return self;
				end;

				return Dropdown;
			end;

			function Section:AddKeybind(Config)
				Config = Config or {};

				local Row = self:AddLabel((Config.Text or "Keybind") , false);

				return Row:AddKeybind(Config);
			end;

			function Section:AddColorPicker(Config)
				Config = Config or {};

				local Row = self:AddLabel((Config.Text or "Color") , false);

				return Row:AddColorPicker(Config);
			end;

			function Section:AddTextInput(Config)
				Config = Config or {};

				local Row = self:AddLabel((Config.Text or "Input") , false);

				return Row:AddTextInput(Config);
			end;

			return Section;
		end;

		return Tab;
	end;

	function Window:_InitConfig()
		local ConfigSignal = NeverLose:CreateSignal(false);
		local ConfigLib = {
			Signals = {},
		};

		local ConfigMenu = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIListLayout = Instance.new("UIListLayout")
		local UIStroke = Instance.new("UIStroke")
		local InputFrame = Instance.new("Frame")
		local BasedLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local BasedHandler = Instance.new("Frame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local TextInput = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke_2 = Instance.new("UIStroke")
		local TextBox = Instance.new("TextBox")
		local LoadConfig = Instance.new("Frame")
		local Icon = Instance.new("TextLabel")
		local UICorner_3 = Instance.new("UICorner")
		local UICorner_4 = Instance.new("UICorner")

		local shadow = NeverLose:CreateShadow(ConfigMenu);

		ConfigLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ConfigMenu.Position = UDim2.fromOffset(ConfigFrame.AbsolutePosition.X + 110 , ConfigFrame.AbsolutePosition.Y + 96)

				NeverLose.PlayAnimate(ConfigMenu , SlowyTween , {
					BackgroundTransparency = 0.035,
					Position = UDim2.fromOffset(ConfigFrame.AbsolutePosition.X + 110 , ConfigFrame.AbsolutePosition.Y + 95)
				})	

				NeverLose.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 0.650
				})
				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0.200
				})	

				NeverLose.PlayAnimate(UIStroke_2 , SlowyTween , {
					Transparency = 0.65
				})	

				NeverLose.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 0.650
				})	
				NeverLose.PlayAnimate(TextInput , SlowyTween , {
					BackgroundTransparency = 0
				})	
				NeverLose.PlayAnimate(TextBox , SlowyTween , {
					TextTransparency = 0.350
				})	
				NeverLose.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 0.350
				})	

				NeverLose.PlayAnimate(ConfigBthIcon , SlowyTween , {
					Rotation = 180
				})	

				shadow:Render(true)
			else
				NeverLose.PlayAnimate(ConfigBthIcon , SlowyTween , {
					Rotation = 0
				})

				NeverLose.PlayAnimate(ConfigMenu , SlowyTween , {
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(ConfigFrame.AbsolutePosition.X + 110 , ConfigFrame.AbsolutePosition.Y + 96)
				})	

				NeverLose.PlayAnimate(UIStroke_2 , SlowyTween , {
					Transparency = 1
				})	

				NeverLose.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 1
				})
				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				})	
				NeverLose.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 1
				})	
				NeverLose.PlayAnimate(TextInput , SlowyTween , {
					BackgroundTransparency = 1
				})	
				NeverLose.PlayAnimate(TextBox , SlowyTween , {
					TextTransparency = 1
				})	
				NeverLose.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 1
				})	

				shadow:Render(false)
			end;
		end);

		NeverLose:AddSignal(ConfigMenu:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if ConfigMenu.BackgroundTransparency > 0.9 then
				ConfigMenu.Visible = false;
				UIListLayout.Parent = nil;
				ConfigMenu.Parent = nil;
			else

				ConfigMenu.Visible = true;
				UIListLayout.Parent = ConfigMenu

				if NeverLose.Global3DRenderMode then
					ConfigMenu.Parent = NeverLose.GlobalSurfaceGui;
				else
					ConfigMenu.Parent = NeverLose.ScreenGui;
				end;
			end
		end)))

		ConfigMenu.Name = NeverLose.RandomString();
		ConfigMenu.Parent = NeverLose.ScreenGui;
		ConfigMenu.AnchorPoint = Vector2.new(0.5, 0)
		ConfigMenu.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		ConfigMenu.BackgroundTransparency = 0.035
		ConfigMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ConfigMenu.BorderSizePixel = 0
		ConfigMenu.ClipsDescendants = true
		ConfigMenu.Position = UDim2.new(255,255,255,255)
		ConfigMenu.Size = UDim2.new(0, 220,0, 110)
		ConfigMenu.ZIndex = 151

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = ConfigMenu

		UIListLayout.Parent = ConfigMenu
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 4)

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = ConfigMenu

		InputFrame.Name = NeverLose.RandomString();
		InputFrame.Parent = ConfigMenu
		InputFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		InputFrame.BackgroundTransparency = 1.000
		InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		InputFrame.BorderSizePixel = 0
		InputFrame.Size = UDim2.new(1, 0, 0, 30)
		InputFrame.ZIndex = 154

		BasedLabel.Name = NeverLose.RandomString();
		BasedLabel.Parent = InputFrame
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.Position = UDim2.new(0, 11, 0, 6)
		BasedLabel.Size = UDim2.new(0,1, 0, 15)
		BasedLabel.ZIndex = 154
		BasedLabel.Font = Enum.Font.GothamMedium
		BasedLabel.Text = "Config"
		BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 13.000
		BasedLabel.TextTransparency = 0.200
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

		LineFrame.Name = NeverLose.RandomString();
		LineFrame.Parent = InputFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = 154

		BasedHandler.Name = NeverLose.RandomString();
		BasedHandler.Parent = InputFrame
		BasedHandler.AnchorPoint = Vector2.new(1, 0)
		BasedHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedHandler.BackgroundTransparency = 1.000
		BasedHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedHandler.BorderSizePixel = 0
		BasedHandler.Position = UDim2.new(1, -11, 0, 2)
		BasedHandler.Size = UDim2.new(1, -20, 0, 25)
		BasedHandler.ZIndex = 154

		UIListLayout_2.Parent = BasedHandler
		UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout_2.Padding = UDim.new(0, 5)

		NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
			if #ConfigLib.Signals <= 0 then
				NeverLose.PlayAnimate(ConfigMenu , SlowyTween , {
					Size = UDim2.new(0, 220,0, UIListLayout.AbsoluteContentSize.Y + 0);
				})
			else
				NeverLose.PlayAnimate(ConfigMenu , SlowyTween , {
					Size = UDim2.new(0, 220,0, UIListLayout.AbsoluteContentSize.Y + 5);
				})
			end;

		end)));

		TextInput.Name = NeverLose.RandomString();
		TextInput.Parent = BasedHandler
		TextInput.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		TextInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextInput.BorderSizePixel = 0
		TextInput.ClipsDescendants = true
		TextInput.Size = UDim2.new(0, 100, 0, 18)
		TextInput.ZIndex = 154

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = TextInput

		UIStroke_2.Transparency = 0.650
		UIStroke_2.Color = Color3.fromRGB(45, 48, 58)
		UIStroke_2.Parent = TextInput

		TextBox.Parent = TextInput
		TextBox.AnchorPoint = Vector2.new(0, 0.5)
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0, 5, 0.5, 0)
		TextBox.Size = UDim2.new(1, -5, 0, 17)
		TextBox.ZIndex = 154
		TextBox.ClearTextOnFocus = false
		TextBox.Font = Enum.Font.GothamMedium
		TextBox.PlaceholderText = "Config Name ..."
		TextBox.Text = ""
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.TextSize = 11.000
		TextBox.TextTransparency = 0.350
		TextBox.TextXAlignment = Enum.TextXAlignment.Left

		LoadConfig.Name = NeverLose.RandomString();
		LoadConfig.Parent = BasedHandler
		LoadConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
		LoadConfig.BackgroundTransparency = 1.000
		LoadConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LoadConfig.BorderSizePixel = 0
		LoadConfig.ClipsDescendants = true
		LoadConfig.Size = UDim2.new(0, 20, 0, 18)
		LoadConfig.ZIndex = 153

		Icon.Name = NeverLose.RandomString();
		Icon.Parent = LoadConfig
		Icon.AnchorPoint = Vector2.new(0.5, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		Icon.Size = UDim2.new(1, 0, 1, 0)
		Icon.ZIndex = 153
		Icon.FontFace = NeverLose.BuiltInBold
		Icon.Text = "plus-large"
		Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
		Icon.TextSize = 16.000
		Icon.TextTransparency = 0.350
		Icon.TextWrapped = true

		UICorner_3.CornerRadius = UDim.new(0, 4)
		UICorner_3.Parent = LoadConfig

		UICorner_4.CornerRadius = UDim.new(0, 10)
		UICorner_4.Parent = InputFrame

		local OpenButton = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")

		OpenButton.Name = NeverLose.RandomString();
		OpenButton.Parent = ConfigFrame
		OpenButton.AnchorPoint = Vector2.new(0, 0.5)
		OpenButton.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		OpenButton.BackgroundTransparency = 1.000
		OpenButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OpenButton.BorderSizePixel = 0
		OpenButton.Position = UDim2.new(0, 31, 0.5, 0)
		OpenButton.Size = UDim2.new(1, -31, 1, 0)
		OpenButton.ZIndex = 10
		OpenButton.Font = Enum.Font.SourceSans
		OpenButton.Text = ""
		OpenButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		OpenButton.TextSize = 14.000

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = OpenButton

		ConfigLib.SetRender(false);
		ConfigSignal:Connect(ConfigLib.SetRender);
		ConfigLib.UnsafeThread = nil;
		ConfigLib.SelectedConfig = "Default";

		local UpdateSize = LPH_NO_VIRTUALIZE(function()
			local size = TextService:GetTextSize(ConfigName.Text , ConfigName.TextSize,ConfigName.Font,Vector2.new(math.huge,math.huge));

			NeverLose.PlayAnimate(ConfigFrame,SlowyTween , {
				Size = UDim2.fromOffset(size.X + 75, 30)
			});
		end);

		UpdateSize();

		function ConfigLib:GetData(performance)
			local ikc = {};
			
			local cd = 0;
			for Flag,v in next , NeverLose.Flags do
				if v and v.GetValue then
					local data = v:GetValue();

					if data == nil then
						continue;
					end;

					if typeof(data) == 'Color3' then
						table.insert(ikc,{
							Idx = Flag,
							Value = data:ToHex(),
						});
					else
						table.insert(ikc,{
							Idx = Flag,
							Value = data
						});
					end;
				end;
				
				if performance then
					if cd % 35 == 1 then
						task.wait()
					end
				end;
				
				cd += 1;
			end;

			return NeverLose.Base64Encode(Encryption.new(HttpService:JSONEncode(ikc)));
		end;

		local UnsafeFlags = {
			Noclip = true,
			Fly = true,
			Spin = true,
			Click_TP = true,
			Server_Bullying = true,
			Character_Size = true,
		}

		-- Pass toggles are session-only. Applying a saved value would fire
		-- their callbacks and rewrite the Passes folder (wiping gamepasses
		-- the player already owns), so config loads ignore these two flags.
		local SessionOnlyFlags = {
			Open_Access_all_passes = true,
			Visual_VIP = true,
		}

		function ConfigLib:LoadData(data)
			local coded = HttpService:JSONDecode(Encryption.reverse(NeverLose.Base64Decode(data)));

for i,v in next , coded do
			if v.Idx then
				if NeverLose.Flags[v.Idx] and v.Value ~= nil and not SessionOnlyFlags[v.Idx] then
					if UnsafeFlags[v.Idx] then
						NeverLose.Flags[v.Idx]:SetValue(false)
					else
						task.spawn(function()
							NeverLose.Flags[v.Idx]:SetValue(v.Value)
						end)
					end
				end;
			end;
		end;

		task.defer(function()
			if NL_RestorePhysics then NL_RestorePhysics() end
		end);
		end;

		function ConfigLib:RefreshConfig()
			if not isfolder(Window.ConfigFolder) then
				makefolder(Window.ConfigFolder);
			end;
			
			if not isfile(Window.ConfigFolder..'/Default') then
				writefile(Window.ConfigFolder..'/Default',ConfigLib:GetData());
			end;
			
			for i,v in next,ConfigMenu:GetChildren() do
				if v:GetAttribute('ConfigItem') then
					v:Destroy();
				end;
			end;

			for i,v in next , ConfigLib.Signals do
				v:Disconnect();
			end

			table.clear(ConfigLib.Signals);

			local ConfigList = {};
			for i,v in next , listfiles(Window.ConfigFolder) do

				local name = string.sub(v , #Window.ConfigFolder + 2);

				table.insert(ConfigList , name)
			end;

			for i,ConfigNameStr in next , ConfigList do
				local ConfigItemFrame = Instance.new("Frame")
				local BasedHandler = Instance.new("Frame")
				local UIListLayout = Instance.new("UIListLayout")
				local DeleteConfig = Instance.new("Frame")
				local Icon = Instance.new("TextLabel")
				local UICorner = Instance.new("UICorner")
				local LoadConfig = Instance.new("Frame")
				local Icon_2 = Instance.new("TextLabel")
				local UICorner_2 = Instance.new("UICorner")
				local UICorner_3 = Instance.new("UICorner")
				local BasedLabel = Instance.new("TextLabel")
				local UIStroke = Instance.new("UIStroke")

				ConfigItemFrame.Name = NeverLose.RandomString();
				ConfigItemFrame.Parent = ConfigMenu
				ConfigItemFrame.BackgroundColor3 = Color3.fromRGB(21, 20, 27)
				ConfigItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ConfigItemFrame.BorderSizePixel = 0
				ConfigItemFrame.Size = UDim2.new(1, -10, 0, 30)
				ConfigItemFrame.ZIndex = 153
				ConfigItemFrame:SetAttribute('ConfigItem',true);

				BasedHandler.Name = NeverLose.RandomString();
				BasedHandler.Parent = ConfigItemFrame
				BasedHandler.AnchorPoint = Vector2.new(1, 0)
				BasedHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				BasedHandler.BackgroundTransparency = 1.000
				BasedHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
				BasedHandler.BorderSizePixel = 0
				BasedHandler.Position = UDim2.new(1, -11, 0, 2)
				BasedHandler.Size = UDim2.new(1, -20, 0, 25)
				BasedHandler.ZIndex = 153

				UIListLayout.Parent = BasedHandler
				UIListLayout.FillDirection = Enum.FillDirection.Horizontal
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				UIListLayout.Padding = UDim.new(0, 5)

				DeleteConfig.Name = NeverLose.RandomString();
				DeleteConfig.Parent = BasedHandler
				DeleteConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
				DeleteConfig.BackgroundTransparency = 1.000
				DeleteConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DeleteConfig.BorderSizePixel = 0
				DeleteConfig.ClipsDescendants = true
				DeleteConfig.Size = UDim2.new(0, 20, 0, 18)
				DeleteConfig.ZIndex = 153

				Icon.Name = NeverLose.RandomString();
				Icon.Parent = DeleteConfig
				Icon.AnchorPoint = Vector2.new(0.5, 0.5)
				Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Icon.BackgroundTransparency = 1.000
				Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Icon.BorderSizePixel = 0
				Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
				Icon.Size = UDim2.new(1, 0, 1, 0)
				Icon.ZIndex = 153
				Icon.FontFace = NeverLose.BuiltInBold
				Icon.Text = "trash-can"
				Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
				Icon.TextSize = 16.000
				Icon.TextTransparency = 0.400
				Icon.TextWrapped = true

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = DeleteConfig

				LoadConfig.Name = NeverLose.RandomString();
				LoadConfig.Parent = BasedHandler
				LoadConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
				LoadConfig.BackgroundTransparency = 1.000
				LoadConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
				LoadConfig.BorderSizePixel = 0
				LoadConfig.ClipsDescendants = true
				LoadConfig.Size = UDim2.new(0, 20, 0, 18)
				LoadConfig.ZIndex = 153

				Icon_2.Name = NeverLose.RandomString();
				Icon_2.Parent = LoadConfig
				Icon_2.AnchorPoint = Vector2.new(0.5, 0.5)
				Icon_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Icon_2.BackgroundTransparency = 1.000
				Icon_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Icon_2.BorderSizePixel = 0
				Icon_2.Position = UDim2.new(0.5, 0, 0.5, 0)
				Icon_2.Size = UDim2.new(1, 0, 1, 0)
				Icon_2.ZIndex = 153
				Icon_2.FontFace = NeverLose.BuiltInBold
				Icon_2.Text = "arrow-right-from-portrait-rectangle"
				Icon_2.TextColor3 = Color3.fromRGB(223, 223, 223)
				Icon_2.TextSize = 16.000
				Icon_2.TextTransparency = 0.400
				Icon_2.TextWrapped = true

				UICorner_2.CornerRadius = UDim.new(0, 4)
				UICorner_2.Parent = LoadConfig

				UICorner_3.CornerRadius = UDim.new(0, 5)
				UICorner_3.Parent = ConfigItemFrame

				BasedLabel.Name = NeverLose.RandomString();
				BasedLabel.Parent = ConfigItemFrame
				BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				BasedLabel.BackgroundTransparency = 1.000
				BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				BasedLabel.BorderSizePixel = 0
				BasedLabel.Position = UDim2.new(0, 11, 0, 7)
				BasedLabel.Size = UDim2.new(0, 1, 0, 15)
				BasedLabel.ZIndex = 153
				BasedLabel.Font = Enum.Font.GothamMedium
				BasedLabel.Text = ConfigNameStr
				BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				BasedLabel.TextSize = 13.000
				BasedLabel.TextTransparency = 0.200
				BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

				UIStroke.Transparency = 0.500
				UIStroke.Color = Color3.fromRGB(45, 48, 58)
				UIStroke.Parent = ConfigItemFrame

				local Render = LPH_NO_VIRTUALIZE(function(rst)
					if rst then
						NeverLose.PlayAnimate(ConfigItemFrame,SlowyTween,{
							BackgroundTransparency = 0
						})

						NeverLose.PlayAnimate(Icon,SlowyTween,{
							TextTransparency = 0.400
						})

						NeverLose.PlayAnimate(Icon_2,SlowyTween,{
							TextTransparency = 0.400
						})

						NeverLose.PlayAnimate(BasedLabel,SlowyTween,{
							TextTransparency = 0.200
						})

						NeverLose.PlayAnimate(UIStroke,SlowyTween,{
							Transparency = 0.500
						})
					else
						NeverLose.PlayAnimate(ConfigItemFrame,SlowyTween,{
							BackgroundTransparency = 1
						})

						NeverLose.PlayAnimate(Icon,SlowyTween,{
							TextTransparency = 1
						})

						NeverLose.PlayAnimate(Icon_2,SlowyTween,{
							TextTransparency = 1
						})

						NeverLose.PlayAnimate(BasedLabel,SlowyTween,{
							TextTransparency = 1
						})

						NeverLose.PlayAnimate(UIStroke,SlowyTween,{
							Transparency = 1
						})
					end;
				end)

				Render(ConfigSignal:GetValue());
				table.insert(ConfigLib.Signals , ConfigSignal:Connect(Render));

				table.insert(ConfigLib.Signals , ConfigItemFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 0.25
					})
				end)));

				table.insert(ConfigLib.Signals , ConfigItemFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 0.500
					})
				end)));

				local deleter,signal = NeverLose:CreateInput(DeleteConfig,function()
					if ConfigNameStr == "Default" then
						Logging.new("trash-can","You can't delete default config!",3.5)
						return;
					end;
					
					delfile(Window.ConfigFolder..'/'..ConfigNameStr);

					UpdateSize();

					ConfigLib:RefreshConfig();

					Logging.new("trash-can",'Deleted '..tostring(ConfigNameStr),3.5)
				end);


				local _,load_signal = NeverLose:CreateInput(LoadConfig,function()
					local path = Window.ConfigFolder..'/'..ConfigNameStr;

					if isfile(path) then
						local data = readfile(path);

						ConfigLib:LoadData(data);

						ConfigLib.SelectedConfig = ConfigNameStr;
						ConfigName.Text = ConfigNameStr;

						UpdateSize();

						ConfigLib:RefreshConfig();

						Logging.new("folder",'Loaded '..tostring(ConfigNameStr),3.5)
					end
				end);

				table.insert(ConfigLib.Signals , signal);
				table.insert(ConfigLib.Signals , load_signal);

				table.insert(ConfigLib.Signals , deleter.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(Icon,SlowyTween,{
						TextTransparency = 0.2,
						TextColor3 = Color3.fromRGB(223, 125, 125)
					})
				end)))

				table.insert(ConfigLib.Signals , deleter.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(Icon,SlowyTween,{
						TextTransparency = 0.400,
						TextColor3 = Color3.fromRGB(223, 223, 223)
					})
				end)))

				table.insert(ConfigLib.Signals , LoadConfig.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(Icon_2,SlowyTween,{
						TextTransparency = 0.2,
						TextColor3 = NeverLose.AccentColor
					})
				end)))

				table.insert(ConfigLib.Signals , LoadConfig.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(Icon_2,SlowyTween,{
						TextTransparency = 0.400,
						TextColor3 = Color3.fromRGB(223, 223, 223)
					})
				end)))
			end;

			table.clear(ConfigList);
		end;
		
		task.delay(1,function()
			if ConfigLib.SelectedConfig == "Default" then
				local path = Window.ConfigFolder..'/Default';
				local ConfigNameStr = "Default";
				
				if isfile(path) then
					local data = readfile(path);

					ConfigLib:LoadData(data);

					ConfigLib.SelectedConfig = ConfigNameStr;
					ConfigName.Text = ConfigNameStr;

					UpdateSize();

					ConfigLib:RefreshConfig();

					Logging.new("folder","Loaded Default Config",3.5);
					
					task.spawn(function()
						while true do task.wait(5.75);
							if isfile(path) and ConfigLib.SelectedConfig == "Default" then
								writefile(Window.ConfigFolder..'/Default',ConfigLib:GetData(true));
							end;
						end;
					end);
				end;
			end;
		end);

		local hover_write = NeverLose:CreateInput(ConfigIcon,function()
			local path = Window.ConfigFolder..'/'..(ConfigLib.SelectedConfig or "Default");

			if isfile(path) then
				writefile(Window.ConfigFolder..'/'..(ConfigLib.SelectedConfig or "Default"),ConfigLib:GetData());

				Logging.new("folder",'Saved '..tostring(ConfigLib.SelectedConfig),3.5)
			end;
		end);

		NeverLose:AddSignal(hover_write.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(ConfigIcon,SlowyTween,{
				TextTransparency = 0.1
			})
		end)));

		NeverLose:AddSignal(hover_write.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(ConfigIcon,SlowyTween,{
				TextTransparency = 0.25
			})
		end)));


		local mv = NeverLose:CreateInput(LoadConfig , function()
			local cfg_name = TextBox.Text;

			if cfg_name and cfg_name:byte() and not cfg_name:find('/',1,true) and not cfg_name:find('\\',1,true) then
				cfg_name = string.sub(cfg_name , 1 , 24);

				writefile(Window.ConfigFolder..'/'..cfg_name,ConfigLib:GetData());
				ConfigLib.SelectedConfig = cfg_name;
				ConfigName.Text = cfg_name;

				Logging.new("folder",'Created '..tostring(cfg_name),3.5)

				TextBox.Text = "";

				UpdateSize();

				ConfigLib:RefreshConfig();
			end;
		end);

		NeverLose:AddSignal(mv.MouseEnter:Connect(function()
			NeverLose.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.1
			})
		end))

		NeverLose:AddSignal(mv.MouseLeave:Connect(function()
			NeverLose.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.35
			})
		end))

		ConfigLib:RefreshConfig();

		OpenButton.MouseButton1Click:Connect(LPH_NO_VIRTUALIZE(function()
			if ConfigLib.UnsafeThread then
				ConfigLib.UnsafeThread:Disconnect();
				ConfigLib.UnsafeThread = nil;
			end;

			ConfigSignal:SetValue(true);

			ConfigLib.UnsafeThread = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not NeverLose:IsMouseOverFrame(ConfigMenu) then
						if ConfigLib.UnsafeThread then
							ConfigLib.UnsafeThread:Disconnect();
							ConfigLib.UnsafeThread = nil;
						end;

						ConfigSignal:SetValue(false);
					end;
				end;
			end)
		end));

		return ConfigLib;
	end;

	Window.ConfigLib = Window:_InitConfig();

	local UserSettings = NeverLose:CreateOptionWindow(BottomFrame , BottomFrame.ZIndex + 13);
	local reciveSignal;
	NeverLose:CreateInput(BottomFrame , LPH_NO_VIRTUALIZE(function()
		if reciveSignal then
			reciveSignal:Disconnect();
			reciveSignal = nil;	
		end;

		UserSettings.Signal:SetValue(true);

		reciveSignal = UserInputService.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if not NeverLose:IsMouseOverFrame(UserSettings.Root) and not NeverLose:IsMouseOverFrame(BottomFrame) and not NeverLose.IsMosueOverOtherFrame then
					if reciveSignal then
						reciveSignal:Disconnect();
						reciveSignal = nil;	
					end;

					UserSettings.Signal:SetValue(false);
				end
			end
		end);
	end))

	Window.UserSettings = UserSettings;

	function Window:SetAccount(Config)
		Config = NeverLose:ProcessParams(Config , {
			Profile = NeverLose.UserProfile,
			Username = LocalPlayer.DisplayName,
			Expires = "( Release )",
		});

		AccountName.Text = Config.Username;
		AccountProfile.Image = Config.Profile;
		ExpireLabel.Text = Config.Expires;

		Window.Username = Config.Username or Window.Username;
		Window.Profile = Config.Profile or Window.Profile;
		Window.Expires = Config.Expires or Window.Expires;

		if Window.UserSettings.UserFrame then
			Window.UserSettings.UserFrame:SetUsername(Window.Username);
			Window.UserSettings.UserFrame:SetProfile(Window.Profile);
			Window.UserSettings.UserFrame:SetExpires(Window.Expires);
		else
			Window.UserSettings.UserFrame = UserSettings:AddUserFrame(Window.Username , Window.Profile , Window.Expires);
		end;
	end;

	function Window:SetSize(newsize)
		Window.Size = newsize;

		if Window.Signal:GetValue() then
			NeverLose.PlayAnimate(WindowFrame , VSlowTween , {
				Size = Window.Size
			})
		end
	end;

	Window:SetAccount();

	NeverLose:AddSignal(UserInputService.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(value,ISTYPING)
		if value.KeyCode == Window.Keybind or value.KeyCode.Name == Window.Keybind then
			if not ISTYPING then
				Window:ToggleInterface()
			end
		end;
	end)));

	function Window:ToggleInterface()
		Window.Signal:SetValue(not Window.Signal:GetValue());

		if Window.__3DRender then
			Window.Load3DBlock();
		end;
	end;

	function Window:Watermark()
		if NeverLose.__WatermarkCache then
			return NeverLose.__WatermarkCache;
		end;

		local Watermark_lb = {};
		local Watermark = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIListLayout = Instance.new("UIListLayout")
		local Shadow = NeverLose:CreateShadow(Watermark);

		Watermark.Name = NeverLose.RandomString();
		Watermark.Parent = NeverLose.ScreenGui
		Watermark.AnchorPoint = Vector2.new(1, 0)
		Watermark.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
		Watermark.BackgroundTransparency = 0.200
		Watermark.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Watermark.BorderSizePixel = 0
		Watermark.ClipsDescendants = true
		Watermark.Position = UDim2.new(1, -10, 0, 10)
		Watermark.Size = UDim2.new(0, 120, 0, 30)
		Watermark.ZIndex = 16

		UICorner.CornerRadius = UDim.new(0, 25)
		UICorner.Parent = Watermark

		UIListLayout.Parent = Watermark
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

		local empty_space = Instance.new('Frame');

		empty_space.Size = UDim2.fromOffset(15,0);
		empty_space.BackgroundTransparency = 1;
		empty_space.Parent = Watermark;
		empty_space.LayoutOrder = 5;

		Watermark:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if Watermark.BackgroundTransparency > 0.9 then
				Watermark.Visible = false;
				Watermark.Parent = nil;
			else
				Watermark.Parent = NeverLose.ScreenGui
				Watermark.Visible = true;
			end;
		end));

		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(Watermark , SlowyTween , {
				Size = UDim2.new(0, UIListLayout.AbsoluteContentSize.X + 5, 0, 30)
			})
		end));

		NeverLose.__WatermarkCache = Watermark_lb;

		Shadow:Render(true);

		Watermark_lb.Renders = {};
		Watermark_lb.Status = true;

		function Watermark_lb:SetRender(value)
			Watermark_lb.Status = value;

			if value then
				NeverLose.PlayAnimate(Watermark,SlowyTween , {
					BackgroundTransparency = 0.200
				})

				Shadow:Render(true);

				for i,v in next , Watermark_lb.Renders do
					pcall(v,true);
				end;
			else
				NeverLose.PlayAnimate(Watermark,SlowyTween , {
					BackgroundTransparency = 1
				})

				Shadow:Render(false);

				for i,v in next , Watermark_lb.Renders do
					pcall(v,false);
				end;
			end
		end;

		function Watermark_lb:AddBlock(IconStr , Name)
			local InnerBlock = {};

			local Frame = Instance.new("Frame")
			local Content = Instance.new("TextLabel")
			local Icon = Instance.new("TextLabel")

			Frame.Parent = Watermark
			Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame.BackgroundTransparency = 1.000
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Size = UDim2.new(0, 50, 0, 30)

			Content.Name = NeverLose.RandomString();
			Content.Parent = Frame
			Content.AnchorPoint = Vector2.new(0, 0.5)
			Content.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
			Content.BackgroundTransparency = 1.000
			Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Content.BorderSizePixel = 0
			Content.Position = UDim2.new(0, 35, 0.5, 0)
			Content.Size = UDim2.new(0, 1, 0, 25)
			Content.ZIndex = 17
			Content.Font = Enum.Font.GothamBold
			Content.Text = Name
			Content.TextColor3 = Color3.fromRGB(186, 186, 186)
			Content.TextSize = 15.000
			Content.TextTransparency = 0.200
			Content.TextXAlignment = Enum.TextXAlignment.Left

			Icon.Name = NeverLose.RandomString();
			Icon.Parent = Frame
			Icon.AnchorPoint = Vector2.new(0, 0.5)
			Icon.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
			Icon.BackgroundTransparency = 1.000
			Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Icon.BorderSizePixel = 0
			Icon.Position = UDim2.new(0, 10, 0.5, 0)
			Icon.Size = UDim2.new(0, 20, 0, 20)
			Icon.ZIndex = 17
			Icon.FontFace = NeverLose.BuiltInBold;
			Icon.Text = IconStr
			Icon.TextColor3 = NeverLose.AccentColor
			Icon.TextSize = 18.000
			Icon.TextTransparency = 0.250
			Icon.TextWrapped = true

			InnerBlock.Update = LPH_NO_VIRTUALIZE(function(value)
				local size = TextService:GetTextSize(Content.Text , Content.TextSize,Content.Font,Vector2.new(math.huge,math.huge))

				if InnerBlock.Visible then
					NeverLose.PlayAnimate(Frame,VSlowTween,{
						Size = UDim2.new(0, size.X + 35, 0, 30)
					})
				else
					NeverLose.PlayAnimate(Frame,VSlowTween,{
						Size = UDim2.new(0, 0, 0, 30)
					})
				end;
			end);

			InnerBlock.Visible = true;

			InnerBlock.Update();

			function InnerBlock:SetVisible(v)
				InnerBlock.Visible = v;

				if Watermark_lb.Status then
					InnerBlock.SetRender(v);
				end;

				InnerBlock.Update();
			end;

			InnerBlock.SetRender = LPH_NO_VIRTUALIZE(function(value)
				if value and InnerBlock.Visible then
					NeverLose.PlayAnimate(Content,SlowyTween , {
						TextTransparency = 0.200
					})

					NeverLose.PlayAnimate(Icon,SlowyTween , {
						TextTransparency = 0.250
					})
				else

					NeverLose.PlayAnimate(Content,SlowyTween , {
						TextTransparency = 1
					})

					NeverLose.PlayAnimate(Icon,SlowyTween , {
						TextTransparency = 1
					})
				end;
			end);

			table.insert(Watermark_lb.Renders,InnerBlock.SetRender);

			function InnerBlock:SetText(t)
				Content.Text = t;

				InnerBlock.Update();
			end;

			function InnerBlock:Input(func)
				local c,s = NeverLose:CreateInput(Frame,func);

				return s;
			end;

			return InnerBlock;
		end;

		return Watermark_lb;
	end;

	Window:SetRender(false);

	return Window;
end;

function NeverLose:CreateNotification()
	if NeverLose.__Notification_Cache then
		return NeverLose.__Notification_Cache;
	end;

	local Notifier = {};
	local Notification = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Notification.Name = NeverLose.RandomString();
	Notification.Parent = NeverLose.ScreenGui;
	Notification.AnchorPoint = Vector2.new(1, 0)
	Notification.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Notification.BackgroundTransparency = 1.000
	Notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Notification.BorderSizePixel = 0
	Notification.Position = UDim2.new(1, -25, 0, 25)
	Notification.Size = UDim2.new(0, 25, 0, 25)

	UIListLayout.Parent = Notification
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 0)

	NeverLose.__Notification_Cache = Notifier;

	function Notifier.new(Config)
		Config = NeverLose:ProcessParams(Config , {
			Title = "Notification",
			Content = "Hello World!",
			Logo = NeverLose.GlobalLogo or "rbxasset://textures/ui/VerifiedBadgeNameIcon.png",
			Duration = 5,
		});

		if NeverLose.__WatermarkCache then
			NeverLose.PlayAnimate(Notification,SlowyTween , {
				Position = UDim2.new(1, -25, 0, 55)
			});
		end;

		local ContainerFrame = Instance.new("Frame")
		local NotifyFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local LogoImage = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")
		local NotifyName = Instance.new("TextLabel")
		local NotifyContent = Instance.new("TextLabel");
		local shadow = NeverLose:CreateShadow(NotifyFrame , true);

		ContainerFrame.Name = NeverLose.RandomString();
		ContainerFrame.Parent = Notification
		ContainerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ContainerFrame.BackgroundTransparency = 1.000
		ContainerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ContainerFrame.BorderSizePixel = 0
		ContainerFrame.Size = UDim2.new(0, 0, 0, 100)

		NotifyFrame.Name = NeverLose.RandomString();
		NotifyFrame.Parent = ContainerFrame
		NotifyFrame.AnchorPoint = Vector2.new(1, 0)
		NotifyFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		NotifyFrame.BackgroundTransparency = 0.075
		NotifyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrame.BorderSizePixel = 0
		NotifyFrame.ClipsDescendants = true
		NotifyFrame.Position = UDim2.new(0, 750, 0, 0)
		NotifyFrame.Size = UDim2.new(0, 220, 0, 55)
		NotifyFrame.ZIndex = 130

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = NotifyFrame

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = NotifyFrame

		LogoImage.Name = NeverLose.RandomString();
		LogoImage.Parent = NotifyFrame
		LogoImage.AnchorPoint = Vector2.new(0, 0.5)
		LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LogoImage.BackgroundTransparency = 1.000
		LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogoImage.BorderSizePixel = 0
		LogoImage.Position = UDim2.new(0, 10, 0.5, 0)
		LogoImage.Size = UDim2.new(0, 35, 0, 35)
		LogoImage.ZIndex = 131
		LogoImage.Image = Config.Logo
		LogoImage.ImageColor3 = NeverLose.IconColor;

		UICorner_2.CornerRadius = UDim.new(0, 7)
		UICorner_2.Parent = LogoImage

		NotifyName.Name = NeverLose.RandomString();
		NotifyName.Parent = NotifyFrame
		NotifyName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyName.BackgroundTransparency = 1.000
		NotifyName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyName.BorderSizePixel = 0
		NotifyName.Position = UDim2.new(0, 50, 0, 7)
		NotifyName.Size = UDim2.new(0, 200, 0, 20)
		NotifyName.ZIndex = 132
		NotifyName.Font = Enum.Font.GothamBold
		NotifyName.Text = Config.Title
		NotifyName.TextColor3 = Color3.fromRGB(255, 255, 255)
		NotifyName.TextSize = 17.000
		NotifyName.TextXAlignment = Enum.TextXAlignment.Left

		NotifyContent.Name = NeverLose.RandomString();
		NotifyContent.Parent = NotifyFrame
		NotifyContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyContent.BackgroundTransparency = 1.000
		NotifyContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyContent.BorderSizePixel = 0
		NotifyContent.Position = UDim2.new(0, 50, 0, 28)
		NotifyContent.Size = UDim2.new(0, 200, 0, 15)
		NotifyContent.ZIndex = 132
		NotifyContent.Font = Enum.Font.GothamBold
		NotifyContent.Text = Config.Content
		NotifyContent.TextColor3 = Color3.fromRGB(255, 255, 255)
		NotifyContent.TextSize = 12.000
		NotifyContent.TextTransparency = 0.650
		NotifyContent.TextXAlignment = Enum.TextXAlignment.Left

		local Size1 = TextService:GetTextSize(NotifyName.Text,NotifyName.TextSize,NotifyName.Font,Vector2.new(math.huge,math.huge));
		local Size2 = TextService:GetTextSize(NotifyContent.Text,NotifyContent.TextSize,NotifyContent.Font,Vector2.new(math.huge,math.huge));

		local MainSize = math.max(Size1.X , Size2.X);

		NotifyFrame.Size = UDim2.new(0, MainSize + 65, 0, 55);

		shadow:Render(true)
		NeverLose.PlayAnimate(NotifyFrame , VSlowTween , {
			Position = UDim2.new(1, 0, 0, 0)
		})

		ContainerFrame.Size = UDim2.new(0, 0, 0, 65)

		task.delay(Config.Duration or 5 , LPH_NO_VIRTUALIZE(function()

			if NeverLose.__WatermarkCache then
				NeverLose.PlayAnimate(Notification,SlowyTween , {
					Position = UDim2.new(1, -25, 0, 55)
				});
			end;

			shadow:Render(false)

			NeverLose.PlayAnimate(NotifyFrame , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(LogoImage , SlowyTween , {
				ImageTransparency = 1
			})

			NeverLose.PlayAnimate(NotifyName , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(NotifyContent , SlowyTween , {
				TextTransparency = 1
			})

			task.wait(0.125);

			NeverLose.PlayAnimate(ContainerFrame , SlowyTween , {
				Size = UDim2.new(0, 0, 0, 0)
			})

			task.wait(0.125);

			ContainerFrame:Destroy();
		end))
	end;

	return Notifier;
end;

function NeverLose:CreateLogger()
	if NeverLose.__LogSystem then
		return 	NeverLose.__LogSystem;
	end;

	local Logging = {};
	local Log = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Log.Name = NeverLose.RandomString();
	Log.Parent = NeverLose.ScreenGui
	Log.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Log.BackgroundTransparency = 1.000
	Log.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Log.BorderSizePixel = 0
	Log.Position = UDim2.new(0, 25, 0, 5 + math.abs(NeverLose.ScreenGui.AbsolutePosition.Y))
	Log.Size = UDim2.new(0, 25, 0, 25)

	UIListLayout.Parent = Log
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 12)

	NeverLose.__LogSystem = Logging;

	function Logging.new(IconStr: string , Message: string , Duration: number)
		Duration = Duration or 3;
		Message = Message or "Log";
		IconStr = IconStr or "crosshairs";

		local LogFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local LogContent = Instance.new("TextLabel")
		local Line = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local Icon = Instance.new("TextLabel")
		local Shadow = NeverLose:CreateShadow(LogFrame , true);

		LogFrame.Name = NeverLose.RandomString();
		LogFrame.Parent = Log
		LogFrame.AnchorPoint = Vector2.new(0.5, 0)
		LogFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		LogFrame.BackgroundTransparency =  1--0.075
		LogFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogFrame.BorderSizePixel = 0
		LogFrame.ClipsDescendants = true
		LogFrame.Position = UDim2.new(0,0,0,0)
		LogFrame.Size = UDim2.new(0, 0, 0, 20)
		LogFrame.ZIndex = 130

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = LogFrame

		UIStroke.Transparency = 1--0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = LogFrame

		LogContent.Name = NeverLose.RandomString();
		LogContent.Parent = LogFrame
		LogContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LogContent.BackgroundTransparency = 1.000
		LogContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogContent.BorderSizePixel = 0
		LogContent.Position = UDim2.new(0, 25, 0, 2)
		LogContent.Size = UDim2.new(0, 200, 0, 15)
		LogContent.ZIndex = 132
		LogContent.Font = Enum.Font.GothamBold
		LogContent.Text = Message
		LogContent.TextColor3 = Color3.fromRGB(255, 255, 255)
		LogContent.TextSize = 12.000
		LogContent.TextTransparency = 1--0.250
		LogContent.TextXAlignment = Enum.TextXAlignment.Left

		Line.Name = NeverLose.RandomString();
		Line.Parent = LogFrame
		Line.AnchorPoint = Vector2.new(0, 0.5)
		Line.BackgroundColor3 = NeverLose.AccentColor
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.BackgroundTransparency = 1 --0
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0, -2, 0.5, 0)
		Line.Size = UDim2.new(0, 5, 1, 0)
		Line.ZIndex = 131

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = Line

		Icon.Name = NeverLose.RandomString();
		Icon.Parent = LogFrame
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 7, 0, 3)
		Icon.Size = UDim2.new(0, 15, 0, 15)
		Icon.ZIndex = 133
		Icon.FontFace = NeverLose.BuiltInBold
		Icon.Text = IconStr
		Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
		Icon.TextSize = 13.000
		Icon.TextTransparency = 1--0.250
		Icon.TextWrapped = true

		local size = TextService:GetTextSize(LogContent.Text,LogContent.TextSize,LogContent.Font,Vector2.new(math.huge,math.huge));

		NeverLose.PlayAnimate(LogFrame , SlowyTween , {
			Size = UDim2.new(0, size.X + 35, 0, 20),
			BackgroundTransparency =  0.075
		});

		task.delay(0.15,LPH_NO_VIRTUALIZE(function()
			Shadow:Render(true);

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 0.650
			});

			NeverLose.PlayAnimate(LogContent , SlowyTween , {
				TextTransparency = 0.25
			});

			NeverLose.PlayAnimate(Line , SlowyTween , {
				BackgroundTransparency = 0
			});

			NeverLose.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.25
			});

			task.wait(Duration + 0.1);

			Shadow:Render(false);

			NeverLose.PlayAnimate(LogFrame , SlowyTween , {
				BackgroundTransparency =  1
			});

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			});

			NeverLose.PlayAnimate(LogContent , SlowyTween , {
				TextTransparency = 1
			});

			NeverLose.PlayAnimate(Line , SlowyTween , {
				BackgroundTransparency = 1
			});

			NeverLose.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 1
			});

			task.wait(0.25);

			LogFrame:Destroy();
		end))
	end;

	return Logging
end;

function NeverLose:CreateIndicator()
	local IndicatorFrame = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	IndicatorFrame.Name = NeverLose.RandomString();
	IndicatorFrame.Parent = NeverLose.ScreenGui;
	IndicatorFrame.AnchorPoint = Vector2.new(0, 0.5)
	IndicatorFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	IndicatorFrame.BackgroundTransparency = 1.000
	IndicatorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	IndicatorFrame.BorderSizePixel = 0
	IndicatorFrame.Position = UDim2.new(0, 15, 0.5, 0)
	IndicatorFrame.Size = UDim2.new(0, 100, 0, 100)
	IndicatorFrame.ZIndex = 15

	UIListLayout.Parent = IndicatorFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 10)

	local Indicators = {};

	Indicators.Color = {
		Red = Color3.fromRGB(255, 102, 105),
		Green = Color3.fromRGB(135, 255, 143),
		White = Color3.fromRGB(186, 186, 186),
	};

	Indicators.Root = IndicatorFrame;

	function Indicators.new(Config)
		Config = NeverLose:ProcessParams(Config , {
			Name = "Indicator",
			Icon = 'crosshairs',
			Color = 'Red',
		});

		local Indicator = {
			CurrentColor = Config.Color,	
			Visible = false,
		};

		local IndicatorItem = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Line = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIGradient = Instance.new("UIGradient")
		local Icon = Instance.new("TextLabel")
		local Content = Instance.new("TextLabel")
		local Shadow = NeverLose:CreateShadow(IndicatorItem);

		IndicatorItem.Name = NeverLose.RandomString();
		IndicatorItem.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
		IndicatorItem.BackgroundTransparency = 1
		IndicatorItem.BorderColor3 = Color3.fromRGB(0, 0, 0)
		IndicatorItem.BorderSizePixel = 0
		IndicatorItem.ClipsDescendants = true
		IndicatorItem.Size = UDim2.new(0, 85, 0, 40)
		IndicatorItem.ZIndex = 16
		IndicatorItem.Visible = false;

		IndicatorItem:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if IndicatorItem.BackgroundTransparency > 0.9 then
				IndicatorItem.Parent = nil;
				IndicatorItem.Visible = false;
			else
				IndicatorItem.Parent = IndicatorFrame;
				IndicatorItem.Visible = true;
			end;
		end))

		UICorner.CornerRadius = UDim.new(0, 25)
		UICorner.Parent = IndicatorItem

		Line.Name = NeverLose.RandomString();
		Line.Parent = IndicatorItem
		Line.AnchorPoint = Vector2.new(0, 0.5)
		Line.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0, 2, 0.5, 0)
		Line.BackgroundTransparency = 1;
		Line.Size = UDim2.new(0, 3, 0.649999976, 0)
		Line.ZIndex = 17

		UICorner_2.CornerRadius = UDim.new(0, 25)
		UICorner_2.Parent = Line

		UIGradient.Rotation = 90
		UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.50, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
		UIGradient.Parent = Line

		Icon.Name = NeverLose.RandomString();
		Icon.Parent = IndicatorItem
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 10, 0.5, 0)
		Icon.Size = UDim2.new(0, 25, 0, 25)
		Icon.ZIndex = 17
		Icon.FontFace = NeverLose.BuiltInBold;
		Icon.Text = Config.Icon
		Icon.TextColor3 = Color3.fromRGB(186, 186, 186)
		Icon.TextSize = 21.000
		Icon.TextTransparency = 1
		Icon.TextWrapped = true

		Content.Name = NeverLose.RandomString();
		Content.Parent = IndicatorItem
		Content.AnchorPoint = Vector2.new(0, 0.5)
		Content.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
		Content.BackgroundTransparency = 1.000
		Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Content.BorderSizePixel = 0
		Content.Position = UDim2.new(0, 40, 0.5, 0)
		Content.Size = UDim2.new(1, -40, 0, 25)
		Content.ZIndex = 17
		Content.Font = Enum.Font.GothamBold
		Content.Text = Config.Name
		Content.TextColor3 = Color3.fromRGB(186, 186, 186)
		Content.TextSize = 20.000
		Content.TextTransparency = 1
		Content.TextXAlignment = Enum.TextXAlignment.Left

		Indicator.Update = LPH_NO_VIRTUALIZE(function()
			local text = TextService:GetTextSize(Content.Text,Content.TextSize , Content.Font , Vector2.new(math.huge,math.huge));

			NeverLose.PlayAnimate(IndicatorItem , SlowyTween , {
				Size = UDim2.new(0, text.X + 60, 0, 40);
			})
		end);

		Indicator.SetRender = LPH_NO_VIRTUALIZE(function(self , value)
			Indicator.Visible = value;

			if value then
				NeverLose.PlayAnimate(IndicatorItem , SlowyTween , {
					BackgroundTransparency = 0.200
				});

				NeverLose.PlayAnimate(Line , SlowyTween , {
					BackgroundTransparency = 0,
					BackgroundColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				NeverLose.PlayAnimate(Icon , VSlowTween , {
					TextTransparency = 0.250,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				NeverLose.PlayAnimate(Content , VSlowTween , {
					TextTransparency = 0.2,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				Shadow:Render(true);
			else
				NeverLose.PlayAnimate(IndicatorItem , SlowyTween , {
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(Line , SlowyTween , {
					BackgroundTransparency = 1,
					BackgroundColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				NeverLose.PlayAnimate(Icon , VSlowTween , {
					TextTransparency = 1,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				NeverLose.PlayAnimate(Content , VSlowTween , {
					TextTransparency = 1,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				Shadow:Render(false);
			end;

			Indicator.Update();
		end);

		Indicator.Update();
		Indicator:SetRender(false);

		function Indicator:SetColor(new_color)
			Indicator.CurrentColor = new_color;

			if Indicator.Visible then
				Indicator:SetRender(true);
			end;
		end;

		function Indicator:SetText(name)
			Config.Name = name;

			Content.Text = Config.Name;

			Indicator.Update();
		end;

		return Indicator;
	end;

	return Indicators;
end;

function NeverLose:Unload()
	if not NeverLose.UnloadEnabled then
		return;	
	end;

	NeverLose.ScreenGui:Destroy();

	for i,v in next , NeverLose.GlobalSignals do
		pcall(v.Disconnect,v)
	end;
end;

return NeverLose;
end)();
(function(NeverLose)--        ##############################
--      ################################
--    #####                          #####
--   #####                              #####
--  ######                                ######
--  ###                                      ###
--  ###                                      ###
--  ###        C O N C E P T   H U B        ###
--  ###                                      ###
--  ###                                      ###
--  ######                                ######
--   #####                              #####
--    #####                          #####
--      ###############################
--        #############################
--
-- РСЃРїСЂР°РІР»РµРЅРёРµ: СѓРґР°Р»СЏРµРј РґСѓР±Р»РёСЂСѓСЋС‰РёРµСЃСЏ РѕР±СЉСЏРІР»РµРЅРёСЏ Рё РёСЃРїСЂР°РІР»СЏРµРј РѕС€РёР±РєРё
WallComboName = "WallCombo"

Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
EncodingService = game:GetService("EncodingService")
UserInputService = game:GetService("UserInputService")
RunService = game:GetService("RunService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
Workspace = game:GetService("Workspace")
TeleportService = game:GetService("TeleportService")
Lighting = game:GetService("Lighting")
TweenService = game:GetService("TweenService")

-- Neutro Library is bundled earlier in this file (Vortex 2.0 ships NeverLose).
Library = NeverLose
ThemeManager = nil
SaveManager = nil

FreezePingState = { active = false, value = 50 }

-- РСЃРїСЂР°РІР»РµРЅРёРµ: СѓР±РёСЂР°РµРј РґСѓР±Р»РёСЂСѓСЋС‰РёРµСЃСЏ РѕР±СЉСЏРІР»РµРЅРёСЏ Players Рё LocalPlayer
-- РћРЅРё СѓР¶Рµ РѕР±СЉСЏРІР»РµРЅС‹ РІС‹С€Рµ

function renameObject(parent, oldName, newName)
    local object = parent:FindFirstChild(oldName)
    if object then
        object.Name = newName
    end
end

function removeFriends(targets)
    if not targets or type(targets) ~= "table" then return end
    for i = #targets, 1, -1 do
        local targetPlayer = Players:FindFirstChild(targets[i])
        if targetPlayer and LocalPlayer:IsFriendsWith(targetPlayer.UserId) then
            table.remove(targets, i)
        end
    end
end

-- Partner VX: hand-picked players that the automatic Main features must never
-- touch. Same idea as Ignore Friends, except the list is chosen by the user.
PartnerVXNames = PartnerVXNames or {}

function IsPartnerVX(name)
    return type(name) == "string" and PartnerVXNames[name] == true
end

-- Mutates in place, exactly like removeFriends, so the hot loops can call it
-- without allocating a new table every frame.
function removePartners(targets)
    if not targets or type(targets) ~= "table" then return end
    for i = #targets, 1, -1 do
        if PartnerVXNames[targets[i]] == true then
            table.remove(targets, i)
        end
    end
end

function rejoinCurrentServer()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end

function resetCharacterForced()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    -- РСЃРїСЂР°РІР»РµРЅРёРµ: РїСЂРѕРІРµСЂСЏРµРј СЃСѓС‰РµСЃС‚РІРѕРІР°РЅРёРµ replicatesignal
    if type(replicatesignal) == "function" and LocalPlayer.Kill then
        replicatesignal(LocalPlayer.Kill)
    elseif humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Dead)
    else
        character:BreakJoints()
    end
end

-- Friend Detection System
FriendExcludeList = {}
FriendStatusCache = {}
TARGET_USER_ID = game.Players.LocalPlayer.UserId

function checkPlayerFriendship(player)
	if player == LocalPlayer then return end
	if FriendStatusCache[player] ~= nil then return end
	local success, isFriend = pcall(function()
		return player:IsFriendsWith(TARGET_USER_ID)
	end)
	if not success then return end
	FriendStatusCache[player] = isFriend and true or false
	if isFriend then
		if not table.find(FriendExcludeList, player) then
			table.insert(FriendExcludeList, player)
		end
	else
		local index = table.find(FriendExcludeList, player)
		if index then
			table.remove(FriendExcludeList, index)
		end
	end
end

function checkAllPlayers()
	for _, player in ipairs(Players:GetPlayers()) do
		checkPlayerFriendship(player)
	end
end

task.spawn(checkAllPlayers)

task.spawn(function()
	while true do
		task.wait(30)
		checkAllPlayers()
	end
end)

Players.PlayerAdded:Connect(function(player)
	task.wait(2)
	checkPlayerFriendship(player)
end)

Players.PlayerRemoving:Connect(function(player)
	FriendStatusCache[player] = nil
	local index = table.find(FriendExcludeList, player)
	if index then
		table.remove(FriendExcludeList, index)
	end
end)

function isExcludedCharacter(character)
	if not character then return false end
	if FriendStatusCache[character] ~= nil then
		return FriendStatusCache[character]
	end
	local player = Players:GetPlayerFromCharacter(character)
	if not player then return false end
	if FriendStatusCache[player] ~= nil then
		return FriendStatusCache[player]
	end
	return table.find(FriendExcludeList, player) ~= nil
end

-- Shared "never touch" check for the automatic WallCombo features. Returns
-- true when the target is a friend (auto-detected, same list as Ignore Friends)
-- or was picked in the PartnerVX list. Accepts a Player, a character model or
-- an NPC model, so Wall Spam, Wallcombo V1, Godmode V1 and Godmode all use one
-- single source of truth.
function IsProtectedWallComboTarget(target)
	if target == nil then return false end
	local player
	if typeof(target) == "Instance" then
		if target:IsA("Player") then
			player = target
		elseif target:IsA("Model") then
			player = Players:GetPlayerFromCharacter(target)
		end
	end
	if player then
		if IsPartnerVX(player.Name) then return true end
		local cached = FriendStatusCache[player]
		if cached == nil then
			local ok, isFriend = pcall(function() return player:IsFriendsWith(LocalPlayer.UserId) end)
			if ok then
				cached = isFriend and true or false
				FriendStatusCache[player] = cached
			end
		end
		return cached == true
	end
	local name = typeof(target) == "Instance" and target.Name or nil
	return name ~= nil and IsPartnerVX(name) == true
end

TrackedConnections = {}
BlockedIncomingRemotes = {}

function SetIncomingTrafficState(remoteInstance, shouldBlock)
    if not remoteInstance:IsA("RemoteEvent") and not remoteInstance:IsA("UnreliableRemoteEvent") then 
        return 
    end
    if shouldBlock then
        -- РСЃРїСЂР°РІР»РµРЅРёРµ: РїСЂРѕРІРµСЂСЏРµРј РЅР°Р»РёС‡РёРµ getconnections
        if getconnections then
            local connections = getconnections(remoteInstance.OnClientEvent)
            if #connections > 0 then
                TrackedConnections[remoteInstance] = TrackedConnections[remoteInstance] or {}
                for _, connection in ipairs(connections) do
                    if connection.Enabled then
                        connection:Disable()
                        table.insert(TrackedConnections[remoteInstance], connection)
                    end
                end
            end
        end
    else
        local savedConnections = TrackedConnections[remoteInstance]
        if savedConnections then
            for _, connection in ipairs(savedConnections) do
                connection:Enable()
            end
            TrackedConnections[remoteInstance] = nil
        end
    end
end

game.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("RemoteEvent") or descendant:IsA("UnreliableRemoteEvent") then
        if BlockedIncomingRemotes[descendant.Name] then
            task.wait(0.1)
            SetIncomingTrafficState(descendant, true)
        end
    end
end)

function BlockIncomingRemote(remoteName)
    BlockedIncomingRemotes[remoteName] = true
    for _, descendant in ipairs(game:GetDescendants()) do
        if descendant.Name == remoteName then
            SetIncomingTrafficState(descendant, true)
        end
    end
end

function UnblockIncomingRemote(remoteName)
    BlockedIncomingRemotes[remoteName] = nil
    for _, descendant in ipairs(game:GetDescendants()) do
        if descendant.Name == remoteName then
            SetIncomingTrafficState(descendant, false)
        end
    end
end

MAX_DISTANCE = 20000
antiSLEnabled = false
PlayerCache = {}

function InitializePlayerCache(player)
    if not PlayerCache[player] then
        PlayerCache[player] = {
            IsPhantom = false,
            OriginalTransparencies = {},
            OriginalDisplayType = Enum.HumanoidDisplayDistanceType.Viewer
        }
    end
end

function MakePlayerPhantom(player, character)
    local data = PlayerCache[player]
    if not data or data.IsPhantom then return end
    data.IsPhantom = true
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        data.OriginalDisplayType = humanoid.DisplayDistanceType
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.Anchored = true
    end
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            if not data.OriginalTransparencies[descendant] then
                data.OriginalTransparencies[descendant] = descendant.Transparency
            end
            descendant.Transparency = 1
        end
    end
end

function RemovePlayerPhantom(player, character)
    local data = PlayerCache[player]
    if not data or not data.IsPhantom then return end
    data.IsPhantom = false
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = data.OriginalDisplayType or Enum.HumanoidDisplayDistanceType.Viewer
    end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.Anchored = false
    end
    for descendant, originalValue in pairs(data.OriginalTransparencies) do
        if descendant and descendant.Parent then
            descendant.Transparency = originalValue
        end
    end
    data.OriginalTransparencies = {}
end

function SetAntiSLEnabled(state)
   antiSLEnabled = state
    if not antiSLEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                RemovePlayerPhantom(player, player.Character)
            end
        end
        PlayerCache = {}
    end
end

RunService.RenderStepped:Connect(function()
    if not antiSLEnabled then return end
    local localCharacter = LocalPlayer.Character
    if not localCharacter or not localCharacter:FindFirstChild("HumanoidRootPart") then return end
    local localRoot = localCharacter.HumanoidRootPart
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer then
            local otherCharacter = otherPlayer.Character
            if otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart") then
                local otherRoot = otherCharacter.HumanoidRootPart
                InitializePlayerCache(otherPlayer)
                local distance = (localRoot.Position - otherRoot.Position).Magnitude
                local data = PlayerCache[otherPlayer]
                if distance > MAX_DISTANCE then
                    if not data.IsPhantom then
                        MakePlayerPhantom(otherPlayer, otherCharacter)
                    end
                else
                    if data.IsPhantom then
                        RemovePlayerPhantom(otherPlayer, otherCharacter)
                    end
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    PlayerCache[player] = nil
end)

function TargetSystem_GetPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then 
            table.insert(names, p.Name) 
        end
    end
    table.sort(names, function(a, b) 
        return a < b
    end)
    return names
end

function excludeDeadPlayers(nameTable)
    local aliveOnly = {}
    for _, playerName in ipairs(nameTable) do
        local playerObj = Players:FindFirstChild(playerName)
        if playerObj then
            local character = playerObj.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    table.insert(aliveOnly, playerName)
                end
            end
        end
    end
    return aliveOnly
end

function filterAndSortPlayers(playerNamesTable, maxRange)
    if not playerNamesTable or type(playerNamesTable) ~= "table" then return {} end
    maxRange = maxRange or 100
    local validTargets = {}
    local localCharacter = LocalPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
    for _, name in ipairs(playerNamesTable) do
        local targetPlayer = Players:FindFirstChild(name)
        if targetPlayer and targetPlayer ~= LocalPlayer and targetPlayer.Character
            and not IsProtectedWallComboTarget(targetPlayer) then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if localRoot and targetRoot then
                local distance = (localRoot.Position - targetRoot.Position).Magnitude
                if distance <= maxRange then
                    table.insert(validTargets, {
                        Name = name,
                        Distance = distance
                    })
                end
            end
        end
    end
    table.sort(validTargets, function(a, b)
        return a.Distance < b.Distance
    end)
    local sortedNames = {}
    for _, data in ipairs(validTargets) do
        table.insert(sortedNames, data.Name)
    end
    return sortedNames
end

function GetCharacterAbility(charName,folderName,Number)
    local characterFolder = ReplicatedStorage.Characters[charName]
    local targetFolder = characterFolder:FindFirstChild(folderName)
    if targetFolder then
        return targetFolder:FindFirstChild(Number)
    end
    return nil
end

function GetCurrentCharacter()
    local ok, res = pcall(function()
        return LocalPlayer.Data.Character.Value
    end)
    if ok and res then return res end
    return "Gon" -- РСЃРїСЂР°РІР»РµРЅРёРµ: РІРѕР·РІСЂР°С‰Р°РµРј Р·РЅР°С‡РµРЅРёРµ РїРѕ СѓРјРѕР»С‡Р°РЅРёСЋ
end

function generateActionNumber()
    return "Action" .. math.random(1000, 9999)
end

function getServerTime()
    return workspace:GetServerTimeNow()
end

-- ==============================================
-- GODMODE FUNCTION
-- ==============================================

do
GodmodeData = {
    active = false,
    running = false,
    delay = 0.05,
    comboCount = 8,
    targetRefreshRate = 2.0
}

GodmodeTargetCache = {
    players = {},
    npcs = {},
    lastUpdate = 0
}

function IsTargetAliveGodmode(char)
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local health = hum:GetAttribute("Health") or hum.Health
    return health and health >= 1
end

function UpdateGodmodeTargetCache()
    local now = tick()
    if now - GodmodeTargetCache.lastUpdate < GodmodeData.targetRefreshRate then
        return GodmodeTargetCache
    end
    GodmodeTargetCache.lastUpdate = now
    GodmodeTargetCache.players = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and not IsProtectedWallComboTarget(p) then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and IsTargetAliveGodmode(p.Character) then
                table.insert(GodmodeTargetCache.players, p)
            end
        end
    end
    GodmodeTargetCache.npcs = {}
    local npcContainer = Workspace:FindFirstChild("Characters")
    if npcContainer then
        local npcFolder = npcContainer:FindFirstChild("NPCs")
        if npcFolder then
            for _, npc in pairs(npcFolder:GetChildren()) do
                if npc:IsA("Model") then
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if hrp and IsTargetAliveGodmode(npc) and not IsProtectedWallComboTarget(npc) then
                        table.insert(GodmodeTargetCache.npcs, npc)
                    end
                end
            end
        end
    end
    return GodmodeTargetCache
end

function SendGodmodeWallCombo(target, targetType)
    if not target then return end
    if IsProtectedWallComboTarget(target) then return end
    local targetChar = (targetType == "player") and target.Character or target
    if not targetChar or not IsTargetAliveGodmode(targetChar) then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    local charName = GetCurrentCharacter()
    if not charName then return end
    local wc = ReplicatedStorage.Characters[charName]:FindFirstChild(WallComboName)
    if not wc then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local id = math.random(100000, 999999)
    local targetName = target.Name
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return end
    local abilityRemote = remotes:FindFirstChild("Abilities") and remotes.Abilities:FindFirstChild("Ability")
    local actionRemote = remotes:FindFirstChild("Combat") and remotes.Combat:FindFirstChild("Action")
    if not abilityRemote or not actionRemote then return end
    pcall(function()
        abilityRemote:FireServer(wc, id + 1)
        actionRemote:FireServer(wc, "Characters:"..charName..":"..WallComboName, 1, id + 1,
            {
                HitboxCFrames = {targetRoot.CFrame},
                BestHitCharacter = targetChar,
                HitCharacters = {targetChar},
                Ignore = {},
                DeathInfo = {},
                BlockedCharacters = {},
                HitInfo = {
                    IsFacing = true,
                    IsInFront = true,
                    Blocked = false,
                    GetUp = true
                },
                Actions = {
                    ["A1_"..tostring(id)] = {
                        [targetName] = {
                            Animation = "Punch1Hit",
                            Preset = "Punch",
                            Velocity = Vector3.new(0, 80, 0),
                            ImpulseVelocity = Vector3.new(0, 150, 0),
                            Duration = 0.2,
                            FromPosition = targetRoot.Position,
                            Seed = math.random(1, 999999),
                        }
                    }
                },
                ServerTime = tick(),
                FromCFrame = root.CFrame
            },
            "Action"..math.random(1000,9999),
            0
        )
    end)
end

function GodmodeCycle()
    if GodmodeData.running then return end
    GodmodeData.running = true
    local cycleCounter = 0
    while GodmodeData.active do
        if cycleCounter % 5 == 0 then
            UpdateGodmodeTargetCache()
        end
        cycleCounter = cycleCounter + 1
        local allTargets = {}
        for _, player in pairs(GodmodeTargetCache.players) do
            table.insert(allTargets, {target = player, type = "player"})
        end
        for _, npc in pairs(GodmodeTargetCache.npcs) do
            table.insert(allTargets, {target = npc, type = "npc"})
        end
        if #allTargets == 0 then
            task.wait(0.5)
        else
            for combo = 1, GodmodeData.comboCount do
                if not GodmodeData.active then break end
                for _, targetInfo in pairs(allTargets) do
                    if not GodmodeData.active then break end
                    SendGodmodeWallCombo(targetInfo.target, targetInfo.type)
                    task.wait(0.01)
                end
                task.wait(GodmodeData.delay)
            end
        end
        task.wait(0.1)
    end
    GodmodeData.running = false
end

function StartGodmode()
    if GodmodeData.active then return end
    GodmodeData.active = true
    UpdateGodmodeTargetCache()
    task.spawn(GodmodeCycle)
    print("Godmode: ON")
end

function StopGodmode()
    GodmodeData.active = false
    GodmodeData.running = false
    print("Godmode: OFF")
end

function ToggleGodmode()
    if GodmodeData.active then
        StopGodmode()
    else
        StartGodmode()
    end
end
end

-- ==============================================
-- DUEL GODMODE (INFINITE LIVES / ANTI-DEATH)
-- ==============================================

do
DuelGodmodeData = {
    active = false,
    tickConnection = nil,
    charAddedConnection = nil,
    diedConnection = nil,
    healthChangedConnection = nil,
    livesConnection = nil,
    bigHealth = 1e9,
    maxLives = 3,
    originalMaxHealth = nil
}

function DuelGodmodeForceAlive(character)
    character = character or LocalPlayer.Character
    if not character then return end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        if hum.MaxHealth < DuelGodmodeData.bigHealth then
            hum.MaxHealth = DuelGodmodeData.bigHealth
        end
        if hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
        hum:SetAttribute("Health", hum.MaxHealth)
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end)
    pcall(function()
        if character:GetAttribute("Ragdoll") then character:SetAttribute("Ragdoll", false) end
        if character:GetAttribute("Knockback") then character:SetAttribute("Knockback", false) end
    end)
    local root = character:FindFirstChild("HumanoidRootPart")
    if root then
        pcall(function()
            if root:GetAttribute("Ragdoll") then root:SetAttribute("Ragdoll", false) end
            if root:GetAttribute("Knockback") then root:SetAttribute("Knockback", false) end
        end)
    end
end

function DuelGodmodeHookCharacter(character)
    character = character or LocalPlayer.Character
    if not character then return end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if DuelGodmodeData.diedConnection then
        pcall(function() DuelGodmodeData.diedConnection:Disconnect() end)
        DuelGodmodeData.diedConnection = nil
    end
    if DuelGodmodeData.healthChangedConnection then
        pcall(function() DuelGodmodeData.healthChangedConnection:Disconnect() end)
        DuelGodmodeData.healthChangedConnection = nil
    end

    DuelGodmodeData.diedConnection = hum.Died:Connect(function()
        if DuelGodmodeData.active then
            pcall(DuelGodmodeForceAlive, character)
        end
    end)

    DuelGodmodeData.healthChangedConnection = hum.HealthChanged:Connect(function(newHealth)
        if DuelGodmodeData.active and newHealth <= 0 then
            pcall(DuelGodmodeForceAlive, character)
        end
    end)
end

function DuelGodmodeLockLives()
    local info = LocalPlayer:FindFirstChild("Info")
    local lives = info and info:FindFirstChild("Lives")
    if not lives or not lives:IsA("IntValue") then return end
    if lives.Value < DuelGodmodeData.maxLives then
        pcall(function() lives.Value = DuelGodmodeData.maxLives end)
    end
end

function DuelGodmodeLockLivesBind()
    local info = LocalPlayer:FindFirstChild("Info")
    local lives = info and info:FindFirstChild("Lives")
    if not lives or not lives:IsA("IntValue") then return end
    if DuelGodmodeData.livesConnection then
        pcall(function() DuelGodmodeData.livesConnection:Disconnect() end)
        DuelGodmodeData.livesConnection = nil
    end
    if lives.Value < DuelGodmodeData.maxLives then
        pcall(function() lives.Value = DuelGodmodeData.maxLives end)
    end
    DuelGodmodeData.livesConnection = lives.Changed:Connect(function()
        if DuelGodmodeData.active and lives.Value < DuelGodmodeData.maxLives then
            pcall(function() lives.Value = DuelGodmodeData.maxLives end)
        end
    end)
end

function StartDuelGodmode()
    if DuelGodmodeData.active then return end
    DuelGodmodeData.active = true

    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then DuelGodmodeData.originalMaxHealth = hum.MaxHealth end
    end

    DuelGodmodeHookCharacter(char)
    DuelGodmodeForceAlive(char)
    DuelGodmodeLockLivesBind()

    DuelGodmodeData.tickConnection = RunService.RenderStepped:Connect(function()
        if not DuelGodmodeData.active then return end
        DuelGodmodeForceAlive(LocalPlayer.Character)
        DuelGodmodeLockLives()
    end)

    DuelGodmodeData.charAddedConnection = LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(0.1)
        if DuelGodmodeData.active then
            DuelGodmodeHookCharacter(newChar)
            DuelGodmodeForceAlive(newChar)
            DuelGodmodeLockLivesBind()
        end
    end)

    print("Duel Godmode: ON")
end

function StopDuelGodmode()
    if not DuelGodmodeData.active then return end
    DuelGodmodeData.active = false

    if DuelGodmodeData.tickConnection then pcall(function() DuelGodmodeData.tickConnection:Disconnect() end); DuelGodmodeData.tickConnection = nil end
    if DuelGodmodeData.charAddedConnection then pcall(function() DuelGodmodeData.charAddedConnection:Disconnect() end); DuelGodmodeData.charAddedConnection = nil end
    if DuelGodmodeData.diedConnection then pcall(function() DuelGodmodeData.diedConnection:Disconnect() end); DuelGodmodeData.diedConnection = nil end
    if DuelGodmodeData.healthChangedConnection then pcall(function() DuelGodmodeData.healthChangedConnection:Disconnect() end); DuelGodmodeData.healthChangedConnection = nil end
    if DuelGodmodeData.livesConnection then pcall(function() DuelGodmodeData.livesConnection:Disconnect() end); DuelGodmodeData.livesConnection = nil end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 then
        pcall(function()
            if DuelGodmodeData.originalMaxHealth and DuelGodmodeData.originalMaxHealth > 0 then
                hum.MaxHealth = DuelGodmodeData.originalMaxHealth
                if hum.Health > hum.MaxHealth then hum.Health = hum.MaxHealth end
            end
        end)
    end

    print("Duel Godmode: OFF")
end
end

-- ==============================================
-- WALL SPAM FUNCTION
-- ==============================================

do
WallSpamData = {
    active = false,
    running = false,
    delay = 0.01,
    comboCount = 20
}

RemoteData = {
    ability = nil,
    action = nil
}

function GetRemotes()
    if not RemoteData.ability then
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                local abilities = remotes:FindFirstChild("Abilities")
                local combat = remotes:FindFirstChild("Combat")
                if abilities then
                    RemoteData.ability = abilities:FindFirstChild("Ability")
                end
                if combat then
                    RemoteData.action = combat:FindFirstChild("Action")
                end
            end
        end)
    end
    return RemoteData
end

CharName = ""
WallComboCache = nil
LastCharCheck = 0

function GetCharName()
    local now = tick()
    if now - LastCharCheck < 0.5 then return CharName end
    LastCharCheck = now
    local ok, v = pcall(function() return LocalPlayer.Data.Character.Value end)
    CharName = (ok and v) or "Gon"
    return CharName
end

function GetWallCombo()
    local cn = GetCharName()
    if WallComboCache and WallComboCache.Parent and WallComboCache.Parent.Parent then return WallComboCache end
    local chars = ReplicatedStorage:FindFirstChild("Characters")
    local cf = chars and chars:FindFirstChild(cn)
    WallComboCache = cf and cf:FindFirstChild("WallCombo")
    return WallComboCache
end

function IsTargetAlive(char)
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local health = hum:GetAttribute("Health") or hum.Health
    return health and health >= 1
end

PlayerCacheWallSpam = {}
NPCCacheWallSpam = {}
LastUpdateWallSpam = 0

function GetPlayersWallSpam()
    local now = tick()
    if now - LastUpdateWallSpam < 0.5 then return PlayerCacheWallSpam end
    local t = {}
    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and count < 15 and not IsProtectedWallComboTarget(p) then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and IsTargetAlive(p.Character) then
                table.insert(t, p)
                count = count + 1
            end
        end
    end
    PlayerCacheWallSpam = t
    return t
end

function GetNPCsWallSpam()
    local now = tick()
    if now - LastUpdateWallSpam < 0.5 then return NPCCacheWallSpam end
    local npcs = {}
    local npcContainer = Workspace:FindFirstChild("Characters")
    if npcContainer then
        local npcFolder = npcContainer:FindFirstChild("NPCs")
        if npcFolder then
            for _, npc in pairs(npcFolder:GetChildren()) do
                if npc:IsA("Model") then
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if hrp and IsTargetAlive(npc) and not IsProtectedWallComboTarget(npc) then
                        table.insert(npcs, npc)
                    end
                end
            end
        end
    end
    NPCCacheWallSpam = npcs
    return npcs
end

-- Outbound packet budget shared by Wall Spam and Wallcombo V1. It is a leaky
-- bucket per feature: each refills at its own packets/sec rate (burst up to
-- that amount), so no matter how high the speed settings are the hub can not
-- flood the network, and the ping stays stable at any Wallcombo speed.
-- v1 = Wallcombo V1 activations (ability + action = 2 packets each),
-- spam = Wall Spam combo hits (ability + action = 2 packets each).
WallComboNetLimits = { v1 = 500, spam = 400, paper = 200, antigod = 300, antigodv2 = 400, godv3 = 400, killaurav2 = 400 }
WallComboNetState = {
    v1 = { tokens = 500, last = tick() },
    spam = { tokens = 400, last = tick() },
    paper = { tokens = 200, last = tick() },
    antigod = { tokens = 300, last = tick() },
    antigodv2 = { tokens = 400, last = tick() },
    godv3 = { tokens = 400, last = tick() },
    killaurav2 = { tokens = 400, last = tick() },
}

function WallComboNetTake(bucket, cost)
    local limit = WallComboNetLimits[bucket]
    if not limit then return false end
    cost = cost or 1
    local state = WallComboNetState[bucket]
    local now = tick()
    local elapsed = now - state.last
    if elapsed > 0 then
        state.tokens = math.min(limit, state.tokens + elapsed * limit)
        state.last = now
    end
    if state.tokens < cost then return false end
    state.tokens = state.tokens - cost
    return true
end

function SendWallCombo(target, targetType)
    if not target then return end
    -- Friends and PartnerVX picks are skipped before anything is sent.
    if IsProtectedWallComboTarget(target) then return end
    -- 4 combo hits x (ability + action) = 8 packets per call. The whole call is
    -- skipped while the spam budget is empty, which also skips the CPU work.
    if not WallComboNetTake("spam", 8) then return end
    local targetChar = (targetType == "player") and target.Character or target
    if not targetChar or not IsTargetAlive(targetChar) then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    local wc = GetWallCombo()
    if not wc then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local charName = GetCharName()
    local id = math.random(100000, 999999)
    local targetName = target.Name
    local remotes = GetRemotes()
    if not remotes.ability or not remotes.action then return end
    for i = 1, 4 do
        if not IsTargetAlive(targetChar) then break end
        pcall(function()
            remotes.ability:FireServer(wc, id + i)
            remotes.action:FireServer(wc, "Characters:"..charName..":WallCombo", i, id + i,
                {
                    HitboxCFrames = {targetRoot.CFrame, targetRoot.CFrame, targetRoot.CFrame},
                    BestHitCharacter = targetChar,
                    HitCharacters = {targetChar, targetChar, targetChar},
                    Ignore = {},
                    DeathInfo = {},
                    BlockedCharacters = {},
                    HitInfo = {
                        IsFacing = true,
                        IsInFront = true,
                        Blocked = false,
                        GetUp = true
                    },
                    Actions = {
                        ["A"..i.."_"..tostring(id)] = {
                            [targetName] = {
                                Animation = i <= 2 and "Punch1Hit" or "Punch2Hit",
                                Preset = "Punch",
                                Velocity = Vector3.new(0, 80 * i, 0),
                                ImpulseVelocity = Vector3.new(0, 150 * i, 0),
                                Duration = 0.2,
                                FromPosition = targetRoot.Position,
                                Seed = math.random(1, 999999),
                            }
                        }
                    },
                    ServerTime = tick(),
                    FromCFrame = root.CFrame
                },
                "Action"..math.random(1000,9999),
                0
            )
        end)
    end
end

function WallSpamCycle()
    if WallSpamData.running then return end
    WallSpamData.running = true
    while WallSpamData.active do
        local players = GetPlayersWallSpam()
        local npcs = GetNPCsWallSpam()
        for combo = 1, WallSpamData.comboCount do
            if not WallSpamData.active then break end
            for _, player in pairs(players) do
                if not WallSpamData.active then break end
                SendWallCombo(player, "player")
            end
            for _, npc in pairs(npcs) do
                if not WallSpamData.active then break end
                SendWallCombo(npc, "npc")
            end
            task.wait(WallSpamData.delay)
        end
        task.wait(WallSpamData.delay * 2)
    end
    WallSpamData.running = false
end

function StartWallSpam()
    if WallSpamData.active then return end
    WallSpamData.active = true
    task.spawn(WallSpamCycle)
    print("Wall Spam: ON")
end

function StopWallSpam()
    WallSpamData.active = false
    WallSpamData.running = false
    print("Wall Spam: OFF")
end

function ToggleWallSpam()
    if WallSpamData.active then
        StopWallSpam()
    else
        StartWallSpam()
    end
end
end

-- ==============================================
-- РљРћРќР•Р¦ WALL SPAM Р¤РЈРќРљР¦РР
-- ==============================================

-- ==============================================
-- VISUAL FEATURES
-- ==============================================

-- ==============================================
-- AURA вЂ” РЅРѕРІР°СЏ СЃРёСЃС‚РµРјР° (РєР»РѕРЅРёСЂСѓРµС‚ СЌС„С„РµРєС‚С‹ РїРµСЂСЃРѕРЅР°Р¶РµР№)
-- Gon / Mob / Nanami / Sukuna + СЃРІРѕР№ С†РІРµС‚ Рё СЂР°РґСѓРіР°
-- ==============================================
Cfg = {}
Cfg.AuraType = "None"
Cfg.AuraColor = Color3.fromRGB(255, 200, 60)
Cfg.RainbowAura = false

AuraSystem = {}

do
    local auraPaths = {}
    local activeAuras = {}
    local originalAuraColors = {}
    local auraObjects = setmetatable({}, { __mode = "k" })
    local rainbowAuraConnection

    local function getAuraPaths()
        local paths = {}
        local success, combat = pcall(function() return LocalPlayer.PlayerScripts.Combat.Transform end)
        if success and combat then
            for _, charName in ipairs({"Gon", "Mob", "Nanami", "Sukuna"}) do
                local charFolder = combat:FindFirstChild(charName)
                if charFolder and charFolder:FindFirstChild("Insert") then
                    paths[charName] = charFolder.Insert
                end
            end
        end
        return paths
    end

    auraPaths = getAuraPaths()

    local function ClearAuras()
        for _, aura in pairs(activeAuras) do
            if aura and aura.Parent then aura:Destroy() end
        end
        activeAuras, originalAuraColors = {}, {}
    end

    local function ProcessAuraObject(obj, mode, color)
        auraObjects[obj] = true
        local function SaveOriginalAuraColor(o)
            if o:IsA("ParticleEmitter") or o:IsA("Beam") or o:IsA("Trail") or o:IsA("PointLight") or o:IsA("SpotLight") or o:IsA("SurfaceLight") or o:IsA("MeshPart") or o:IsA("Part") then
                originalAuraColors[o] = o.Color
            elseif o:IsA("Highlight") then
                originalAuraColors[o] = { FillColor = o.FillColor, OutlineColor = o.OutlineColor }
            end
        end

        local function ApplyAuraColor(o, c)
            if o:IsA("ParticleEmitter") or o:IsA("Beam") or o:IsA("Trail") then
                o.Color = ColorSequence.new(c)
            elseif o:IsA("PointLight") or o:IsA("SpotLight") or o:IsA("SurfaceLight") or o:IsA("MeshPart") or o:IsA("Part") then
                o.Color = c
            elseif o:IsA("Highlight") then
                o.FillColor, o.OutlineColor = c, c
            end
        end

        local function ResetAuraColor(o)
            local saved = originalAuraColors[o]
            if not saved then return end
            if o:IsA("Highlight") then
                o.FillColor, o.OutlineColor = saved.FillColor, saved.OutlineColor
            else
                o.Color = saved
            end
        end

        if mode == "save" then
            SaveOriginalAuraColor(obj)
        elseif mode == "apply" and color then
            ApplyAuraColor(obj, color)
        elseif mode == "reset" then
            ResetAuraColor(obj)
        end

        for _, child in pairs(obj:GetChildren()) do
            ProcessAuraObject(child, mode, color)
        end
    end

    local function ApplyAura(auraName)
        Cfg.AuraType = auraName
        ClearAuras()
        local folder = auraPaths[auraName]
        if not folder then return end
        for _, effectPart in pairs(folder:GetChildren()) do
            local bodyPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(effectPart.Name)
            if bodyPart then
                for _, effect in pairs(effectPart:GetChildren()) do
                    local success, clone = pcall(function() return effect:Clone() end)
                    if success and clone then
                        clone.Parent = bodyPart
                        table.insert(activeAuras, clone)
                        ProcessAuraObject(clone, "save")
                        if Cfg.AuraColor and not Cfg.RainbowAura then
                            ProcessAuraObject(clone, "apply", Cfg.AuraColor)
                        end
                    end
                end
            end
        end
    end

    local function RecolorAuras(color)
        for _, aura in pairs(activeAuras) do
            ProcessAuraObject(aura, "apply", color)
        end
    end

    local function ResetAurasToDefault()
        Cfg.AuraColor = nil
        for _, aura in pairs(activeAuras) do
            ProcessAuraObject(aura, "reset")
        end
    end

    local function rainbowCycle()
        if Cfg.RainbowAura and #activeAuras > 0 then
            local t = tick() * 2
            RecolorAuras(Color3.new((math.sin(t) + 1) / 2, (math.sin(t + 2) + 1) / 2, (math.sin(t + 4) + 1) / 2))
        end
    end

    local function SetRainbow(Value)
        Cfg.RainbowAura = Value
        if Value then
            if not rainbowAuraConnection or not rainbowAuraConnection.Connected then
                rainbowAuraConnection = RunService.RenderStepped:Connect(rainbowCycle)
            end
        else
            if rainbowAuraConnection and rainbowAuraConnection.Connected then
                rainbowAuraConnection:Disconnect()
                rainbowAuraConnection = nil
            end
            if Cfg.AuraColor then
                RecolorAuras(Cfg.AuraColor)
            else
                ResetAurasToDefault()
            end
        end
    end

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(2)
        ClearAuras()
    end)

    AuraSystem.ApplyAura = ApplyAura
    AuraSystem.RecolorAuras = RecolorAuras
    AuraSystem.ResetAurasToDefault = ResetAurasToDefault
    AuraSystem.SetRainbow = SetRainbow
    AuraSystem.ClearAuras = ClearAuras
    AuraSystem.IsAura = function(o)
        return auraObjects[o] == true
    end
    AuraSystem.GetPaths = function()
        return auraPaths
    end
end

-- ATMOSPHERE
AtmosphereData = { active = false, color = Color3.fromRGB(180, 140, 220) }
OriginalLighting = {}

-- РЎР»РѕРІР°СЂСЊ С†РІРµС‚РѕРІ Р°С‚РјРѕСЃС„РµСЂС‹ (РјРѕР¶РЅРѕ СЂР°СЃС€РёСЂСЏС‚СЊ)
AtmosphereColorMap = {
    Purple = Color3.fromRGB(180, 140, 220), -- РґРµС„РѕР»С‚РЅС‹Р№ С„РёРѕР»РµС‚РѕРІС‹Р№
    Blue   = Color3.fromRGB(80, 160, 255),
    Cyan   = Color3.fromRGB(90, 208, 255),
    Red    = Color3.fromRGB(255, 80, 80),
    Green  = Color3.fromRGB(80, 255, 140),
    Orange = Color3.fromRGB(255, 180, 60),
    Pink   = Color3.fromRGB(255, 100, 200),
    White  = Color3.fromRGB(255, 255, 255),
    Night  = Color3.fromRGB(20, 20, 30),
    Sunset = Color3.fromRGB(255, 240, 200),
}

function SaveLighting()
    OriginalLighting = {
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Brightness = Lighting.Brightness,
        ColorShift_Top = Lighting.ColorShift_Top,
        ColorShift_Bottom = Lighting.ColorShift_Bottom,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        GlobalShadows = Lighting.GlobalShadows,
        ClockTime = Lighting.ClockTime,
    }
end

function applyAtmosphereColor(color)
    AtmosphereData.color = color
    -- РџСЂРёРІРѕРґРёРј С†РІРµС‚ Рє РµРґРёРЅРѕРјСѓ "РµСЃС‚РµСЃС‚РІРµРЅРЅРѕРјСѓ" С‚РѕРЅСѓ С‡РµСЂРµР· HSV:
    -- Р±РµСЂС‘Рј С‚РѕРЅ РёР· РІС‹Р±СЂР°РЅРЅРѕРіРѕ С†РІРµС‚Р°, РЅРѕ РѕРіСЂР°РЅРёС‡РёРІР°РµРј РЅР°СЃС‹С‰РµРЅРЅРѕСЃС‚СЊ Рё СЏСЂРєРѕСЃС‚СЊ,
    -- С‡С‚РѕР±С‹ СЃ Р»СЋР±С‹Рј С†РІРµС‚РѕРј (Р±РµР»С‹Р№/С‡С‘СЂРЅС‹Р№/СЏСЂРєРёР№/С‚С‘РјРЅС‹Р№) РЅРµ Р±С‹Р»Рѕ РїРµСЂРµСЃРІРµС‚Р° РёР»Рё С‡РµСЂРЅРѕС‚С‹
    local h, s, v = color:ToHSV()
    local toneHue = h
    local toneSat = math.clamp(s * 0.35, 0.12, 0.35)
    local toneVal = math.clamp(v * 0.85 + 0.25, 0.38, 1)

    local atmo = Lighting:FindFirstChild("VortexAtmosphere")
    if atmo then
        atmo.Color = Color3.fromHSV(toneHue, toneSat, toneVal)
        atmo.Decay = Color3.fromHSV(toneHue, math.min(s, 0.15), math.clamp(v * 0.7 + 0.1, 0.3, 0.9))
    end
    local cc = Lighting:FindFirstChild("VortexCC")
    if cc then
        cc.TintColor = Color3.fromHSV(toneHue, math.min(s, 0.25), 1)
    end
    if AtmosphereData.active then
        Lighting.ColorShift_Top = Color3.fromHSV(toneHue, math.min(s, 0.18), 1)
        Lighting.ColorShift_Bottom = Color3.fromHSV(toneHue, math.min(s, 0.12), 0.8)
        Lighting.Ambient = Color3.fromHSV(toneHue, math.min(s, 0.1), 0.45)
        Lighting.OutdoorAmbient = Color3.fromHSV(toneHue, math.min(s, 0.15), 0.55)
    end
end

function StartAtmosphere()
    if not OriginalLighting.Ambient then SaveLighting() end
    AtmosphereData.active = true
    Lighting.Brightness = 1.3
    Lighting.GlobalShadows = true
    Lighting.ClockTime = 14
    if not Lighting:FindFirstChild("VortexAtmosphere") then
        local atmo = Instance.new("Atmosphere")
        atmo.Name = "VortexAtmosphere"
        atmo.Density = 0.3
        atmo.Offset = 0.25
        atmo.Haze = 1.2
        atmo.Glare = 0.35
        atmo.Parent = Lighting
    end
    if not Lighting:FindFirstChild("VortexBloom") then
        local bloom = Instance.new("BloomEffect")
        bloom.Name = "VortexBloom"
        bloom.Intensity = 0.12
        bloom.Size = 12
        bloom.Threshold = 1.05
        bloom.Parent = Lighting
    end
    if not Lighting:FindFirstChild("VortexCC") then
        local cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "VortexCC"
        cc.Brightness = 0.02
        cc.Contrast = 0.08
        cc.Saturation = 0.15
        cc.Parent = Lighting
    end
    applyAtmosphereColor(AtmosphereData.color)
end

function StopAtmosphere()
    AtmosphereData.active = false
    if OriginalLighting.Ambient then
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.ColorShift_Top = OriginalLighting.ColorShift_Top
        Lighting.ColorShift_Bottom = OriginalLighting.ColorShift_Bottom
        Lighting.EnvironmentDiffuseScale = OriginalLighting.EnvironmentDiffuseScale
        Lighting.EnvironmentSpecularScale = OriginalLighting.EnvironmentSpecularScale
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
        Lighting.ClockTime = OriginalLighting.ClockTime
    end
    for _, name in ipairs({"VortexAtmosphere", "VortexBloom", "VortexCC"}) do
        local obj = Lighting:FindFirstChild(name)
        if obj then obj:Destroy() end
    end
end

-- NEON TRAILS
TrailData = { active = false, color = Color3.fromRGB(90, 208, 255) }
TrailConnection = nil
ActiveTrails = {}

function CreateTrailOnPart(part, color)
    local att0 = Instance.new("Attachment")
    att0.Position = Vector3.new(0, 0.3, 0)
    att0.Parent = part
    local att1 = Instance.new("Attachment")
    att1.Position = Vector3.new(0, -0.3, 0)
    att1.Parent = part
    local trail = Instance.new("Trail")
    trail.Attachment0 = att0
    trail.Attachment1 = att1
    trail.Color = ColorSequence.new(color)
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
    trail.Lifetime = 0.6
    trail.MinLength = 0.1
    trail.LightEmission = 1
    trail.LightInfluence = 0
    trail.Parent = part
    return { att0 = att0, att1 = att1, trail = trail }
end

function StartTrails()
    TrailData.active = true
    TrailConnection = RunService.RenderStepped:Connect(function()
        if not TrailData.active then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, name in ipairs({"RightArm", "LeftArm", "RightLeg", "LeftLeg", "Torso", "HumanoidRootPart"}) do
            local part = char:FindFirstChild(name)
            if part and not ActiveTrails[name] then
                ActiveTrails[name] = CreateTrailOnPart(part, TrailData.color)
            end
            if part and ActiveTrails[name] then
                ActiveTrails[name].trail.Color = ColorSequence.new(TrailData.color)
            end
        end
    end)
end

function StopTrails()
    TrailData.active = false
    if TrailConnection then TrailConnection:Disconnect(); TrailConnection = nil end
    for name, data in pairs(ActiveTrails) do
        if data.trail then data.trail:Destroy() end
        if data.att0 then data.att0:Destroy() end
        if data.att1 then data.att1:Destroy() end
    end
    ActiveTrails = {}
end

-- Р¤СѓРЅРєС†РёСЏ РґР»СЏ СЃРјРµРЅС‹ С†РІРµС‚Р° С‚СЂРµР№Р»РѕРІ РЅР° Р»РµС‚Сѓ
function applyTrailColor(color)
    TrailData.color = color
    for _, data in pairs(ActiveTrails) do
        if data.trail and data.trail.Parent then
            data.trail.Color = ColorSequence.new(color)
        end
    end
end

-- HP INDICATORS
HPData = { active = false }
HPConnection = nil
HPBillboards = {}

function CreateHPIndicator(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if HPBillboards[player] then return end
    local bb = Instance.new("BillboardGui")
    bb.Name = "VortexHP"
    bb.Size = UDim2.new(0, 100, 0, 20)
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = head
    bb.Parent = head
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    bg.BackgroundTransparency = 0.3
    bg.BorderSizePixel = 0
    bg.Parent = bb
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 4)
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    fill.BorderSizePixel = 0
    fill.Parent = bg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "100%"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.Parent = bg
    HPBillboards[player] = bb
end

function RemoveHPIndicator(player)
    if HPBillboards[player] then
        HPBillboards[player]:Destroy()
        HPBillboards[player] = nil
    end
end

function StartHPIndicators()
    HPData.active = true
    HPConnection = RunService.RenderStepped:Connect(function()
        if not HPData.active then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if not HPBillboards[player] then
                    CreateHPIndicator(player)
                end
                local bb = HPBillboards[player]
                if bb and bb.Parent then
                    local char = player.Character
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local maxHP = humanoid.MaxHealth
                        local curHP = humanoid:GetAttribute("Health") or humanoid.Health
                        local pct = math.clamp(curHP / maxHP, 0, 1)
                        local fill = bb:FindFirstChild("Fill", true)
                        local label = bb:FindFirstChild("Label", true)
                        if fill then
                            fill.Size = UDim2.new(pct, 0, 1, 0)
                            fill.BackgroundColor3 = Color3.fromRGB(
                                math.floor(255 * (1 - pct)),
                                math.floor(255 * pct),
                                0
                            )
                        end
                        if label then
                            label.Text = math.floor(pct * 100) .. "%"
                        end
                    end
                end
            else
                RemoveHPIndicator(player)
            end
        end
    end)
    Players.PlayerRemoving:Connect(function(player)
        RemoveHPIndicator(player)
    end)
end

function StopHPIndicators()
    HPData.active = false
    if HPConnection then HPConnection:Disconnect(); HPConnection = nil end
    for player, _ in pairs(HPBillboards) do
        RemoveHPIndicator(player)
    end
    HPBillboards = {}
end

-- PARTICLES (РЎРІРµС‚Р»СЏС‡РєРё РїРѕ РјРёСЂСѓ)
ParticleData = { active = false, color = Color3.fromRGB(190, 230, 255) }
ParticleColorMap = {
    Warm   = Color3.fromRGB(255, 214, 120), -- С‚С‘РїР»С‹Р№ СЏРЅС‚Р°СЂРЅС‹Р№
    Cyan   = Color3.fromRGB(90, 208, 255),
    Purple = Color3.fromRGB(170, 80, 255),
    Green  = Color3.fromRGB(120, 255, 150),
    Pink   = Color3.fromRGB(255, 130, 200),
    Red    = Color3.fromRGB(255, 80, 80),
    White  = Color3.fromRGB(230, 240, 255),
    Blue   = Color3.fromRGB(110, 160, 255),
}
ParticleConnection = nil
ActiveParticles = {}

function applyParticleColor(Value)
    local c = ParticleColorMap[Value]
    if not c then return end
    ParticleData.color = c
    for _, pe in pairs(ActiveParticles) do
        if pe and pe.Parent then
            pe.Color = ColorSequence.new(c)
        end
    end
end

function StartParticles()
    ParticleData.active = true
    ParticleConnection = RunService.RenderStepped:Connect(function()
        if not ParticleData.active then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if not ActiveParticles[1] or not ActiveParticles[1].Parent then
            local pe = Instance.new("ParticleEmitter")
            pe.Name = "Fireflies"
            pe.Color = ColorSequence.new(ParticleData.color)
            pe.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.7),
                NumberSequenceKeypoint.new(0.6, 0.4),
                NumberSequenceKeypoint.new(1, 0)
            })
            pe.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.5),
                NumberSequenceKeypoint.new(0.5, 0.2),
                NumberSequenceKeypoint.new(1, 1)
            })
            pe.Lifetime = NumberRange.new(2.5, 5.5)
            pe.Rate = 16
            pe.Speed = NumberRange.new(1.5, 5)
            pe.VelocityInheritance = 0.1
            pe.Drag = 0.3
            pe.SpreadAngle = Vector2.new(360, 360)
            pe.Rotation = NumberRange.new(0, 360)
            pe.RotSpeed = NumberRange.new(-30, 30)
            pe.LightEmission = 1
            pe.LightInfluence = 0
            pe.EmissionDirection = Enum.NormalId.Top
            pe.Parent = hrp
            ActiveParticles[1] = pe
        end
        local pe = ActiveParticles[1]
        local pulse = 0.8 + (math.sin(tick() * 2.2) + 1) * 0.13
        local baseColor = ParticleData.color
    pe.Color = ColorSequence.new(Color3.new(baseColor.R * pulse, baseColor.G * pulse, baseColor.B * pulse))
        pe.Rate = 12 + math.floor((math.sin(tick() * 1.7) + 1) * 8)
    end)
end

function StopParticles()
    ParticleData.active = false
    if ParticleConnection then ParticleConnection:Disconnect(); ParticleConnection = nil end
    for _, pe in pairs(ActiveParticles) do
        if pe and pe.Parent then pe:Destroy() end
    end
    ActiveParticles = {}
end

-- ==============================================
-- KEYBIND SYSTEM
-- ==============================================

-- Keybinds are now handled by the built-in KeyPicker addon on each toggle

-- ==============================================
-- РЎРќР•Р–РРќРљР Р’ РҐРђР‘Р•
-- ==============================================

function CreateSnowflakes()
    pcall(function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local snowGui = Instance.new("ScreenGui")
        snowGui.Name = "VortexSnowflakes"
        snowGui.IgnoreGuiInset = true
        snowGui.ResetOnSpawn = false
        snowGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        snowGui.Parent = playerGui

        local snowChars = {"*", "+", ".", "o", "~"}
        local snowColors = {
            Color3.fromRGB(200, 220, 255),
            Color3.fromRGB(180, 200, 255),
            Color3.fromRGB(220, 230, 255),
            Color3.fromRGB(160, 190, 255),
        }

        for i = 1, 25 do
            local sLabel = Instance.new("TextLabel")
            sLabel.Size = UDim2.new(0, math.random(10, 20), 0, math.random(10, 20))
            sLabel.BackgroundTransparency = 1
            sLabel.Text = snowChars[math.random(1, #snowChars)]
            sLabel.TextColor3 = snowColors[math.random(1, #snowColors)]
            sLabel.TextScaled = true
            sLabel.Font = Enum.Font.GothamBold
            sLabel.TextTransparency = math.random(30, 70) / 100
            sLabel.ZIndex = 5
            sLabel.Parent = snowGui

            task.spawn(function()
                local startX = math.random(0, 1000)
                local startY = math.random(-200, -50)
                local speed = math.random(30, 80) / 10
                local swayAmp = math.random(20, 60)
                local swaySpeed = math.random(10, 30) / 10
                local elapsed = 0
                while sLabel and sLabel.Parent do
                    elapsed = task.wait(0.03)
                    local yPos = startY + (elapsed * speed * 20)
                    local xPos = startX + math.sin(elapsed * swaySpeed) * swayAmp
                    if yPos > 1100 then
                        yPos = math.random(-200, -50)
                        startX = math.random(0, 1000)
                        elapsed = 0
                    end
                    sLabel.Position = UDim2.new(0, xPos, 0, yPos)
                    sLabel.Rotation = math.sin(elapsed * 2) * 30
                end
            end)
        end
    end)
end

-- ==============================================
-- РљРћРќР•Р¦ VISUAL FEATURES
-- ==============================================

-- NeverLose ships its own theming / config module; the Obsidian ThemeManager block is gone.
-- SaveManager duties are covered by NeverLose's built-in _InitConfig + config buttons.

Window = NeverLose:CreateWindow({
    Name = "Concept Hub",
    Content = "Release",
    Size = UDim2.new(0, 800, 0, 600),
    ConfigFolder = "ConceptHub",
    Keybind = "RightShift",
    Enable3DRenderer = false,
})

-- ========================================================
-- Р©РРўРћРљ РџРћР›Р¬Р—РћР’РђРўР•Р›РЇ (СЃС‚СЂРµР»РѕС‡РєР°):
-- РґР°С‚Р°, РІСЂРµРјСЏ Рё РєРѕР»РёС‡РµСЃС‚РІРѕ Р·Р°РїСѓСЃРєРѕРІ С…Р°Р±Р° Р·Р° СЃРµРіРѕРґРЅСЏ.
-- РЎС‡С‘С‚С‡РёРє Р»РµР¶РёС‚ РІ С„Р°Р№Р»Рµ launchlog.txt РІ РїР°РїРєРµ РєРѕРЅС„РёРіРѕРІ.
-- ========================================================
task.spawn(function()
    pcall(function()
        -- launchlog lives OUTSIDE Window.ConfigFolder on purpose: the
        -- built-in config browser lists every file in that folder, so a
        -- log file in there shows up as a "config" and fails to decode.
        local launchFolder = "ConceptHubData"
        local launchFile = launchFolder .. "/launchlog.txt"
        local today = os.date("%Y-%m-%d")
        local count = 1

        if not isfolder(launchFolder) then
            makefolder(launchFolder)
        end

        if isfile(launchFile) then
            local saved = readfile(launchFile)
            local savedDate = saved:match("^(%S+)")
            if savedDate == today then
                local savedCount = tonumber(saved:match("(%d+)$")) or 0
                count = savedCount + 1
            end
        end

        writefile(launchFile, today .. " " .. tostring(count))

        local infoHandle = Window.UserSettings:AddLabel(" ", true)
        if infoHandle and infoHandle.SetText then
            task.spawn(function()
                while infoHandle.SetText do
                    local dateStr = os.date("%d.%m.%Y")
                    local timeStr = os.date("%H:%M:%S")
                    local launchWord = count == 1 and "СЂР°Р·" or (count <= 4 and "СЂР°Р·Р°" or "СЂР°Р·")
                    infoHandle:SetText(string.format(
                        "Date: %s  Time: %s\nLaunches today: %d %s",
                        dateStr, timeStr, count, launchWord
                    ))
                    task.wait(1)
                end
            end)
        end
    end)
end)

-- ========================================================
-- РќРђРЎРўР РћР™РљР Р’РљР›РђР”РљР SETTINGS (Р±Р»РёРє + С‚РµРјР° РёРЅС‚РµСЂС„РµР№СЃР°).
-- Р’РёРґР¶РµС‚С‹ Р¶РёРІСѓС‚ РІ Tabs.Settings, РЅРѕ Р·РЅР°С‡РµРЅРёСЏ С‡РёС‚Р°СЋС‚СЃСЏ
-- РґРµРєРѕСЂР°С‚РёРІРЅС‹Рј С†РёРєР»РѕРј РЅР°РїСЂСЏРјСѓСЋ РёР· СЌС‚РёС… С‚Р°Р±Р»РёС†.
-- ========================================================
Theme = {
    Accent = Color3.fromRGB(78, 127, 252),
    Prev = Color3.fromRGB(78, 127, 252),
    P = Color3.fromRGB(139, 92, 246),
    C = Color3.fromRGB(56, 189, 248),
}
ThemeRefs = {}
GlareSettings = {
    Enabled = true,
    Cycle = 6,
    SweepDuration = 1.3,
    Side = 1,
    Angle = 18,
    Color = Color3.fromRGB(255, 255, 255),
}
local LastGlareColor = GlareSettings.Color

local function ColorLum(c)
    return 0.2126 * c.R + 0.7152 * c.G + 0.0722 * c.B
end

local function ColorSat(c)
    local mx, mn = math.max(c.R, c.G, c.B), math.min(c.R, c.G, c.B)
    return (mx - mn) / (mx + 0.0001)
end

Theme.Base = {
    bg = Color3.fromRGB(18, 15, 30),
    surface = Color3.fromRGB(26, 28, 36),
    widget = Color3.fromRGB(20, 22, 27),
    accent = Color3.fromRGB(78, 127, 252),
}
Theme.Bg = Theme.Base.bg
Theme.Surface = Theme.Base.surface
Theme.Active = false

Theme.DefaultP = Color3.fromRGB(139, 92, 246)
Theme.DefaultC = Color3.fromRGB(56, 189, 248)
Theme.P = Theme.DefaultP
Theme.C = Theme.DefaultC
ThemeRefs.bgImage = nil

function ApplyThemeInstance(el)
    pcall(function()
        if el:GetAttribute("ThemeLock") then
            return
        end
        if el:IsA("GuiObject") and el.BackgroundTransparency < 0.98 then
            local base = el:GetAttribute("ThemeBaseBG") or el.BackgroundColor3
            el:SetAttribute("ThemeBaseBG", base)
            local lum = ColorLum(base)
            local sat = ColorSat(base)
            if sat > 0.3 and lum < 0.85 then
                el.BackgroundColor3 = Theme.Accent
            elseif lum < 0.22 and sat < 0.3 then
                if lum < 0.09 then
                    el.BackgroundColor3 = Theme.Bg
                else
                    el.BackgroundColor3 = Theme.Surface
                end
            end
        end
        if el:IsA("TextLabel") or el:IsA("TextButton") or el:IsA("TextBox") then
            local baseT = el:GetAttribute("ThemeBaseText") or el.TextColor3
            el:SetAttribute("ThemeBaseText", baseT)
            local lumT = ColorLum(baseT)
            local satT = ColorSat(baseT)
            if satT > 0.3 and lumT < 0.85 then
                el.TextColor3 = Theme.Accent
            end
        end
        if el:IsA("UIStroke") then
            local baseS = el:GetAttribute("ThemeBaseStroke") or el.Color
            el:SetAttribute("ThemeBaseStroke", baseS)
            local lumS = ColorLum(baseS)
            local satS = ColorSat(baseS)
            if satS > 0.5 then
                el.Color = Theme.Accent
            elseif lumS < 0.25 then
                el.Color = Theme.Surface
            end
        end
    end)
end

function ThemeAll()
    local sg = NeverLose.ScreenGui
    if sg then
        for _, el in ipairs(sg:GetDescendants()) do
            ApplyThemeInstance(el)
        end
    end
    if NeverLose.SyncGlareVisuals then
        NeverLose.SyncGlareVisuals()
    end
end

local function BannerCircle(p, posX, posY, size, color, transp, rot)
    local f = Instance.new("Frame", p)
    f.BackgroundColor3 = color
    f.BackgroundTransparency = transp
    f.BorderSizePixel = 0
    f.Size = UDim2.new(0, size, 0, size)
    f.Position = UDim2.new(posX / 100, 0, posY / 100, 0)
    f.Rotation = rot or 0
    f.ZIndex = 2
    Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
    return f
end

local function BannerEllipse(p, posX, posY, w, h, color, transp, rot)
    local f = Instance.new("Frame", p)
    f.BackgroundColor3 = color
    f.BackgroundTransparency = transp
    f.BorderSizePixel = 0
    f.Size = UDim2.new(0, w, 0, h)
    f.Position = UDim2.new(posX / 100, -w / 2, posY / 100, -h / 2)
    f.Rotation = rot or 0
    f.ZIndex = 2
    Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
    return f
end

local function BannerDiamond(p, posX, posY, size, color, transp, rot)
    return BannerEllipse(p, posX, posY, size, size, color, transp, (rot or 0) + 45)
end

local function BannerBar(p, posX, posY, w, h, color, transp, rot)
    local f = Instance.new("Frame", p)
    f.BackgroundColor3 = color
    f.BackgroundTransparency = transp
    f.BorderSizePixel = 0
    f.Size = UDim2.new(0, w, 0, h)
    f.Position = UDim2.new(posX / 100, 0, posY / 100, 0)
    f.Rotation = rot or 0
    f.ZIndex = 2
    return f
end

local function BannerGradient(p, top, bottom, rot)
    local g = Instance.new("UIGradient", p)
    g.Rotation = rot or 90
    g.Color = ColorSequence.new(top, bottom)
end

function SettleThemeBackground(banner)
    pcall(function()
        local old = ThemeRefs.banner
        if old then old:Destroy(); ThemeRefs.banner = nil end
        if banner == false or banner == nil then return end
        if type(banner) == "boolean" then return end
        local main = ThemeRefs.main
        if not main then
            for _, d in ipairs(NeverLose.ScreenGui:GetChildren()) do
                local a = (d:IsA("Frame") and d.AbsoluteSize.X or 0)
                if a > 300 then
                    main = d
                    break
                end
            end
            ThemeRefs.main = main
        end
        if not main then return end
        local bg = Instance.new("Frame")
        bg.Name = "ConceptBanner"
        bg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        bg.BackgroundTransparency = 1
        bg.BorderSizePixel = 0
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.Position = UDim2.new(0, 0, 0, 0)
        bg.ZIndex = 1
        bg.Active = false
        bg.Parent = main
        if NeverLose.BannerLog then
            NeverLose.BannerLog("theme banner frame parented to " .. tostring(main.Name) .. " zindex=" .. tostring(main.ZIndex) .. " absSize=" .. tostring(main.AbsoluteSize) .. " transp=" .. tostring(main.BackgroundTransparency))
        end
        local white = Color3.fromRGB(255, 255, 255)
        local bright = 0.55
        local mid = 0.38
        local deep = 0.24
        local themeAsset = nil
        if type(ThemeBannerAssets) == "table" then
            themeAsset = ThemeBannerAssets[banner] or ThemeBannerAssets["Default"]
        end
        if themeAsset then
            local img = Instance.new("ImageLabel")
            img.Name = "ConceptThemeBanner"
            img.BackgroundTransparency = 1
            img.BorderSizePixel = 0
            img.Size = UDim2.new(1, 0, 1, 0)
            img.Position = UDim2.new(0, 0, 0, 0)
            img.ZIndex = 2
            img.ScaleType = Enum.ScaleType.Crop
            img.ImageTransparency = 0.15
            img.ImageColor3 = Color3.fromRGB(255, 255, 255)
            img.Image = "rbxthumb://type=Asset&id=" .. tostring(themeAsset) .. "&w=768&h=432"
            img.Parent = bg
            if NeverLose.BannerLog then
                NeverLose.BannerLog("theme '" .. tostring(banner) .. "' banner asset=" .. tostring(themeAsset) .. " url=" .. tostring(img.Image))
            end
            local tint = Instance.new("Frame")
            tint.Name = "ConceptThemeBannerTint"
            tint.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
            tint.BackgroundTransparency = 0.35
            tint.BorderSizePixel = 0
            tint.Size = UDim2.new(1, 0, 1, 0)
            tint.Position = UDim2.new(0, 0, 0, 0)
            tint.ZIndex = 3
            tint.Active = false
            tint.Parent = bg
        elseif banner == "Sakura" then
            BannerGradient(bg, Color3.fromRGB(255, 196, 214), Color3.fromRGB(255, 232, 238), 90)
            BannerCircle(bg, 8, 6, 190, Color3.fromRGB(255, 214, 224), 0)
            local petals = {
                Color3.fromRGB(240, 116, 160), Color3.fromRGB(255, 158, 190),
                Color3.fromRGB(255, 196, 214), Color3.fromRGB(233, 96, 144),
            }
            for i = 1, 28 do
                local x = (i * 37) % 100
                local y = ((i * 53) + 12) % 100
                local w = 26 + (i % 6) * 7
                BannerEllipse(bg, x, y, w, w * 0.48, petals[i % #petals + 1], 0.25 + (i % 4) * 0.1, (i * 47) % 360)
            end
        elseif banner == "Light" then
            BannerGradient(bg, Color3.fromRGB(244, 244, 248), Color3.fromRGB(214, 214, 226), 90)
            for i = 0, 5 do
                local y = 16 + i * 16
                BannerBar(bg, 0, y, 100, 90, Color3.fromRGB(255, 255, 255), 0.55 + (i % 2) * 0.12, (i % 2 == 0) and -14 or 14)
            end
            BannerCircle(bg, 84, 12, 130, Color3.fromRGB(255, 255, 255), 0.3)
        elseif banner == "Dark" then
            BannerGradient(bg, Color3.fromRGB(30, 32, 40), Color3.fromRGB(14, 15, 20), 90)
            for i = 0, 7 do
                local y = 8 + i * 13
                BannerBar(bg, 0, y, 100, 54, Color3.fromRGB(255, 255, 255), 0.72 + (i % 3) * 0.06, (i % 2 == 0) and 8 or -8)
            end
            BannerCircle(bg, 12, 12, 90, Color3.fromRGB(255, 255, 255), 0.82)
            BannerCircle(bg, 88, 82, 70, Color3.fromRGB(255, 255, 255), 0.85)
        elseif banner == "Blue" then
            BannerGradient(bg, Color3.fromRGB(88, 146, 240), Color3.fromRGB(52, 100, 190), 90)
            for i = 1, 6 do
                local x = (i * 23) % 90
                local y = 8 + (i * 29) % 60
                local s = 70 + (i % 3) * 40
                BannerCircle(bg, x, y, s, Color3.fromRGB(255, 255, 255), 0.45 + (i % 2) * 0.2)
            end
            BannerDiamond(bg, 50, 78, 90, Color3.fromRGB(190, 214, 255), 0.6)
        elseif banner == "Indigo" then
            BannerGradient(bg, Color3.fromRGB(104, 110, 224), Color3.fromRGB(58, 64, 168), 90)
            for i = 1, 10 do
                local x = (i * 47) % 100
                local y = (i * 31) % 100
                BannerDiamond(bg, x, y, 24 + (i % 4) * 14, Color3.fromRGB(188, 191, 255), 0.35 + (i % 3) * 0.18, (i * 22) % 360)
            end
        elseif banner == "Purple" then
            BannerGradient(bg, Color3.fromRGB(158, 132, 244), Color3.fromRGB(106, 80, 200), 90)
            for i = 1, 6 do
                local s = 46 + (i % 4) * 26
                BannerCircle(bg, (i * 31) % 100, (i * 47) % 100, s, Color3.fromRGB(255, 255, 255), 0.55, 0)
                BannerCircle(bg, (i * 31) % 100, (i * 47) % 100, s * 0.55, Color3.fromRGB(196, 178, 255), 0, 0)
            end
            BannerCircle(bg, 50, 14, 170, Color3.fromRGB(186, 160, 250), 0.25)
        elseif banner == "Pink" then
            BannerGradient(bg, Color3.fromRGB(240, 100, 156), Color3.fromRGB(198, 60, 120), 90)
            for i = 1, 26 do
                local x = (i * 41) % 100
                local y = (i * 23) % 100
                local w = 22 + (i % 5) * 8
                BannerEllipse(bg, x, y, w, w * 0.5, Color3.fromRGB(255, 190, 214), 0.1, (i * 53) % 360)
                BannerEllipse(bg, x - w * 0.22, y - w * 0.16, w * 0.5, w * 0.5, Color3.fromRGB(255, 190, 214), 0.1, 0)
                BannerEllipse(bg, x + w * 0.22, y - w * 0.16, w * 0.5, w * 0.5, Color3.fromRGB(255, 190, 214), 0.1, 0)
            end
        elseif banner == "Red" then
            BannerGradient(bg, Color3.fromRGB(240, 90, 100), Color3.fromRGB(170, 40, 52), 90)
            for i = 0, 6 do
                local y = 6 + i * 15
                BannerBar(bg, 0, y, 100, 60, Color3.fromRGB(255, 184, 188), 0.15 + (i % 2) * 0.22, -18)
            end
            BannerCircle(bg, 66, 18, 140, Color3.fromRGB(255, 214, 216), 0.2)
        elseif banner == "Orange" then
            BannerGradient(bg, Color3.fromRGB(244, 160, 90), Color3.fromRGB(214, 104, 44), 90)
            for i = 1, 9 do
                local ang = 160 + i * 17
                BannerBar(bg, 14, 26, 210, 26, Color3.fromRGB(255, 220, 170), 0.3, ang)
            end
            BannerCircle(bg, 14, 26, 84, Color3.fromRGB(255, 210, 150), 0.1)
        elseif banner == "Yellow" then
            BannerGradient(bg, Color3.fromRGB(250, 214, 96), Color3.fromRGB(226, 168, 48), 90)
            for i = 1, 14 do
                local x = (i * 29) % 100
                local y = (i * 61) % 100
                local s = 12 + (i % 4) * 8
                BannerBar(bg, x - s, y, s * 2, 11, Color3.fromRGB(255, 244, 190), 0.15, 0)
                BannerBar(bg, x, y - s, 11, s * 2, Color3.fromRGB(255, 244, 190), 0.15, 0)
            end
            BannerGradient(bg, Color3.fromRGB(255, 230, 130), Color3.fromRGB(255, 214, 96), 90)
        elseif banner == "Green" then
            BannerGradient(bg, Color3.fromRGB(96, 196, 116), Color3.fromRGB(50, 150, 74), 90)
            for i = 1, 22 do
                local x = (i * 43) % 100
                local y = (i * 19) % 100
                local w = 34 + (i % 5) * 10
                BannerEllipse(bg, x, y, w, w * 0.42, Color3.fromRGB(178, 240, 192), 0.1 + (i % 3) * 0.15, (i * 29) % 180)
            end
        elseif banner == "Teal" then
            BannerGradient(bg, Color3.fromRGB(58, 188, 174), Color3.fromRGB(30, 148, 136), 90)
            for i = 0, 4 do
                local y = 14 + i * 17
                local h = 24 + (i * 7) % 18
                local f = Instance.new("Frame", bg)
                f.BackgroundColor3 = Color3.fromRGB(180, 240, 230)
                f.BackgroundTransparency = 0.42 + (i % 2) * 0.25
                f.BorderSizePixel = 0
                f.Size = UDim2.new(0, 20 + (i * 9) % 46, 0, h)
                f.Position = UDim2.new(6 + (i * 8) % 30, 0, y / 100, 0)
                f.ZIndex = 2
                Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
            end
        elseif banner == "Cyan" then
            BannerGradient(bg, Color3.fromRGB(84, 196, 220), Color3.fromRGB(48, 150, 190), 90)
            for i = 1, 9 do
                local x = (i * 31) % 100
                local y = (i * 47) % 100
                local s = 44 + (i % 4) * 26
                BannerCircle(bg, x, y, s, Color3.fromRGB(255, 255, 255), 0.3 + (i % 2) * 0.2)
            end
        elseif banner == "Olemad" then
            BannerGradient(bg, Color3.fromRGB(212, 178, 120), Color3.fromRGB(176, 138, 84), 90)
            for i = 1, 8 do
                local x = (i * 23) % 100
                local y = (i * 51) % 100
                BannerCircle(bg, x, y, 34 + (i % 3) * 18, Color3.fromRGB(240, 210, 150), 0.25, 0)
                BannerCircle(bg, x, y, 20 + (i % 3) * 10, Color3.fromRGB(255, 238, 190), 0.18, 0)
            end
        elseif banner == "Sir Meme" then
            BannerGradient(bg, Color3.fromRGB(200, 90, 210), Color3.fromRGB(142, 46, 158), 90)
            for i = 1, 12 do
                local x = (i * 37) % 100
                local y = (i * 29) % 100
                BannerDiamond(bg, x, y, 30 + (i % 3) * 16, Color3.fromRGB(255, 170, 235), 0.3 + (i % 2) * 0.2, (i * 33) % 360)
            end
            BannerCircle(bg, 20, 18, 120, Color3.fromRGB(255, 190, 240), 0.25)
        elseif banner == "darkModz" then
            BannerGradient(bg, Color3.fromRGB(120, 40, 48), Color3.fromRGB(60, 14, 20), 90)
            for i = 1, 7 do
                local x = (i * 19) % 100
                local y = 4 + (i * 31) % 40
                BannerBar(bg, x, y, 240, 16, Color3.fromRGB(255, 120, 130), 0.35, 62)
            end
            BannerCircle(bg, 78, 20, 140, Color3.fromRGB(170, 60, 70), 0.3)
        elseif banner == "MIRKO KING" then
            BannerGradient(bg, Color3.fromRGB(226, 168, 60), Color3.fromRGB(170, 112, 36), 90)
            for i = 1, 10 do
                local x = (i * 41) % 100
                local y = (i * 23) % 100
                local s = 22 + (i % 3) * 14
                BannerDiamond(bg, x, y, s, Color3.fromRGB(255, 226, 140), 0.2, 0)
            end
            BannerBar(bg, 0, 78, 100, 26, Color3.fromRGB(255, 236, 170), 0.55, 0)
        else
            BannerGradient(bg, Color3.fromRGB(224, 224, 236), Color3.fromRGB(190, 190, 206), 90)
            BannerCircle(bg, 14, 14, 110, Color3.fromRGB(255, 255, 255), 0.35)
            BannerCircle(bg, 82, 70, 80, Color3.fromRGB(255, 255, 255), 0.45)
        end
        ThemeRefs.banner = bg
    end)
end

function RestoreThemeBase()
    local sg = NeverLose.ScreenGui
    if sg then
        for _, el in ipairs(sg:GetDescendants()) do
            pcall(function()
                if el:GetAttribute("ThemeLock") then
                    return
                end
                local b = el:GetAttribute("ThemeBaseBG")
                if b then el.BackgroundColor3 = b end
                local t = el:GetAttribute("ThemeBaseText")
                if t then el.TextColor3 = t end
                local s = el:GetAttribute("ThemeBaseStroke")
                if s then el.Color = s end
            end)
        end
    end
    Theme.Accent = Theme.Base.accent
    Theme.Prev = Theme.Base.accent
    NeverLose.AccentColor = Theme.Base.accent
    Theme.Active = false
    SettleThemeBackground(false)
    if NeverLose.SyncGlareVisuals then
        NeverLose.SyncGlareVisuals()
    end
end

function SetTheme(color)
    color = color or Theme.P
    local L = ColorLum(color)
    Theme.Accent = color
    Theme.Prev = color
    Theme.P = Theme.DefaultP
    Theme.C = Theme.DefaultC
    if L > 0.82 then
        Theme.Bg = color:Lerp(Color3.fromRGB(10, 10, 14), 0.9)
        Theme.Surface = color:Lerp(Color3.fromRGB(10, 10, 14), 0.78)
    else
        Theme.Bg = color:Lerp(Color3.fromRGB(10, 10, 14), 0.88)
        Theme.Surface = color:Lerp(Color3.fromRGB(10, 10, 14), 0.72)
    end
    NeverLose.AccentColor = color
    Theme.Active = true
    SettleThemeBackground(false)
    ThemeAll()
end

if not Theme._hooked then
    Theme._hooked = true
    task.spawn(function()
        pcall(function()
            local sg = NeverLose.ScreenGui
            if sg then
                sg.DescendantAdded:Connect(function(el)
                    if Theme.Active then
                        ApplyThemeInstance(el)
                    end
                end)
            end
        end)
    end)
end

-- ========================================================
-- Р”Р•РљРћР РђРўРР’РќР«Р• Р­Р¤Р¤Р•РљРўР« РҐРђР‘Рђ (Р±РµР·РѕРїР°СЃРЅР°СЏ РІРµСЂСЃРёСЏ):
-- РњСЏРіРєРёР№ РіСЂР°РґРёРµРЅС‚ С„РѕРЅР° + В«РґС‹С€Р°С‰Р°СЏВ» РЅРµРѕРЅРѕРІР°СЏ РѕР±РІРѕРґРєР° РѕРєРЅР°
-- + РјРµРґР»РµРЅРЅРѕРµ РїРµСЂРµР»РёРІР°РЅРёРµ Р·Р°РіРѕР»РѕРІРєР°.
-- Р‘Р•Р— РѕРІРµСЂР»РµРµРІ РїРѕРІРµСЂС… РІРєР»Р°РґРѕРє, Р‘Р•Р— С…РѕРІРµСЂ-РїРµСЂРµСЂРёСЃРѕРІРѕРє
-- Рё Р‘Р•Р— UpdateColorsUsingRegistry вЂ” РЅРёС‡РµРіРѕ РЅРµ Р»РѕРјР°РµС‚.
-- ========================================================
task.spawn(function()
    pcall(function()
        local sg = NeverLose.ScreenGui
        if not sg then return end
        local main = nil
        local best = 0
        for _, d in ipairs(sg:GetChildren()) do
            if d:IsA("Frame") and d.AbsoluteSize.X > best then
                best = d.AbsoluteSize.X
                main = d
            end
        end
        if not main or best < 300 then return end

        local P = Theme.P
        local C = Theme.C

        -- РџСѓР»СЊСЃРёСЂСѓСЋС‰Р°СЏ РЅРµРѕРЅРѕРІР°СЏ РѕР±РІРѕРґРєР° РѕРєРЅР° (РІРєР»Р°РґРєРё РЅРµ С‚СЂРѕРіР°РµРј)
        local glow = Instance.new("UIStroke")
        glow.Thickness = 5
        glow.Transparency = 0.8
        glow.Color = P
        glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        glow.ZIndex = 99
        glow.Parent = main

        local line = Instance.new("UIStroke")
        line.Thickness = 2
        line.Transparency = 0.3
        line.Color = C
        line.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        line.ZIndex = 100
        line.Parent = main
        ThemeRefs.glow = glow
        ThemeRefs.line = line

        -- РџРµСЂРµР»РёРІР°СЋС‰РёР№СЃСЏ Р·Р°РіРѕР»РѕРІРѕРє "Concept Hub"
        local title = nil
        for _, d in ipairs(main:GetDescendants()) do
            if d:IsA("TextLabel") and d.Text == "Concept Hub" then
                title = d
                break
            end
        end
        local titleGrad = nil
        if title then
            titleGrad = Instance.new("UIGradient")
            titleGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, P),
                ColorSequenceKeypoint.new(0.5, C),
                ColorSequenceKeypoint.new(1, P),
            })
            titleGrad.Parent = title
            ThemeRefs.titleGrad = titleGrad
        end

        -- РњСЏРіРєР°СЏ СЃРІРµС‚СЏС‰Р°СЏСЃСЏ РєСЂРѕРјРєР° РїРѕ РІРµСЂС…Сѓ РѕРєРЅР°
        local topGlow = Instance.new("Frame")
        topGlow.Name = "VortexTopGlow"
        topGlow.Size = UDim2.new(1, 0, 0, 2)
        topGlow.BackgroundColor3 = P
        topGlow.BackgroundTransparency = 0.35
        topGlow.BorderSizePixel = 0
        topGlow.Active = false
        topGlow.ZIndex = 0
        local topGlowGrad = Instance.new("UIGradient")
        topGlowGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, P),
            ColorSequenceKeypoint.new(0.35, P),
            ColorSequenceKeypoint.new(0.5, C),
            ColorSequenceKeypoint.new(0.65, P),
            ColorSequenceKeypoint.new(1, P),
        })
        topGlowGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(0.4, 0.25),
            NumberSequenceKeypoint.new(0.5, 0.1),
            NumberSequenceKeypoint.new(0.6, 0.25),
            NumberSequenceKeypoint.new(1, 0.9),
        })
        topGlowGrad.Parent = topGlow
        topGlow.Parent = main
        ThemeRefs.topGlow = topGlow
        ThemeRefs.topGlowGrad = topGlowGrad

        -- Р”РёР°РіРѕРЅР°Р»СЊРЅС‹Р№ В«СЃС‚РµРєР»СЏРЅРЅС‹Р№В» Р±Р»РёРє (РїСЂРѕР±РµРіР°РµС‚ РїРѕ РјРµРЅСЋ РєР°Р¶РґС‹Рµ ~6 СЃРµРє)
        -- РљР»РёРїР°РµС‚СЃСЏ РІ РіСЂР°РЅРёС†С‹ РѕРєРЅР°, Active=false вЂ” РЅРµ РїРµСЂРµС…РІР°С‚С‹РІР°РµС‚ РєР»РёРєРё.
        -- РџР°СЂР°РјРµС‚СЂС‹ (РёРЅС‚РµСЂРІР°Р»/РґР»РёС‚РµР»СЊРЅРѕСЃС‚СЊ/СЃС‚РѕСЂРѕРЅР°/С†РІРµС‚) Р±РµСЂСѓС‚СЃСЏ РёР· GlareSettings
        -- Рё РєР°СЃС‚РѕРјРёР·РёСЂСѓСЋС‚СЃСЏ РІРѕ РІРєР»Р°РґРєРµ Settings.
        local glareClip = Instance.new("Frame")
        glareClip.Name = "VortexGlareClip"
        glareClip.Size = UDim2.new(1, 0, 1, 0)
        glareClip.Position = UDim2.new(0, 0, 0, 0)
        glareClip.BackgroundTransparency = 1
        glareClip.BorderSizePixel = 0
        glareClip.Active = false
        glareClip.ClipsDescendants = true
        glareClip.ZIndex = 90
        glareClip.Parent = main
        ThemeRefs.glareClip = glareClip

        local GLARE_W = 130
        local glare = Instance.new("Frame")
        glare.Name = "VortexGlare"
        glare.Size = UDim2.new(0, GLARE_W, 1.4, 0)
        glare.Position = UDim2.new(0, -GLARE_W * 2, 0, -0.2)
        glare.Rotation = 18
        glare.BackgroundColor3 = GlareSettings.Color
        glare.BackgroundTransparency = 0.62
        glare.BorderSizePixel = 0
        glare.Active = false
        glare.ZIndex = 90
        glare.Visible = false
        local glareGrad = Instance.new("UIGradient")
        glareGrad.Rotation = 90
        glareGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, GlareSettings.Color),
            ColorSequenceKeypoint.new(0.5, GlareSettings.Color),
            ColorSequenceKeypoint.new(1, GlareSettings.Color),
        })
        glareGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.95),
            NumberSequenceKeypoint.new(0.5, -0.6),
            NumberSequenceKeypoint.new(1, 0.95),
        })
        glareGrad.Parent = glare
        glare.Parent = glareClip
        ThemeRefs.glare = glare
        ThemeRefs.glareGrad = glareGrad

        local function SyncGlareVisuals()
            LastGlareColor = GlareSettings.Color
            glare.BackgroundColor3 = GlareSettings.Color
            glareGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, GlareSettings.Color),
                ColorSequenceKeypoint.new(0.5, GlareSettings.Color),
                ColorSequenceKeypoint.new(1, GlareSettings.Color),
            })
        end
        NeverLose.SyncGlareVisuals = SyncGlareVisuals
        SyncGlareVisuals()

        -- РњРµРґР»РµРЅРЅР°СЏ Р°РЅРёРјР°С†РёСЏ В«РґС‹С…Р°РЅРёСЏВ» (РѕР±С…РѕРґРёС‚СЃСЏ С‚РѕР»СЊРєРѕ СЃРІРѕРёРјРё РѕР±СЉРµРєС‚Р°РјРё)
        local elapsed = 0
        local conn = RunService.RenderStepped:Connect(function(dt)
            pcall(function()
            if not main.Parent then
                if conn then conn:Disconnect() end
                return
            end
            if not main.Visible then return end
            elapsed = elapsed + (dt or 0.03)
            local mix = (math.sin(elapsed * 1.1) + 1) / 2
            local col = Theme.P:Lerp(Theme.C, mix)
            glow.Color = col
            line.Color = col
            glow.Transparency = 0.76 + math.sin(elapsed * 1.5) * 0.08
            line.Transparency = 0.3 + math.sin(elapsed * 1.5 + 0.6) * 0.1
            if titleGrad then
                titleGrad.Offset = Vector2.new(math.sin(elapsed * 0.9) * 0.5, 0)
            end
            topGlow.BackgroundTransparency = 0.4 + math.sin(elapsed * 0.8) * 0.12
            topGlowGrad.Offset = Vector2.new(math.sin(elapsed * 0.5) * 0.4, 0)

            -- РЎС‚РµРєР»СЏРЅРЅС‹Р№ Р±Р»РёРє: РёРЅС‚РµСЂРІР°Р», СЃРєРѕСЂРѕСЃС‚СЊ Рё СЃС‚РѕСЂРѕРЅР° РёР· GlareSettings
            if GlareSettings.Enabled then
                local cycle = math.max(1, GlareSettings.Cycle)
                local sweepDur = math.clamp(GlareSettings.SweepDuration, 0.2, cycle - 0.2)
                local ph = elapsed % cycle
                if ph < sweepDur then
                    local t = ph / sweepDur
                    local e = t * t * (3 - 2 * t)  -- smoothstep РґР»СЏ РїР»Р°РІРЅРѕРіРѕ С…РѕРґР°
                    local winW = main.AbsoluteSize.X
                    glare.Visible = true
                    if GlareSettings.Side >= 1 then
                        -- СЃР»РµРІР° РЅР°РїСЂР°РІРѕ
                        glare.Position = UDim2.new(0, -GLARE_W * 2 + (winW + GLARE_W * 3) * e, 0, -0.2)
                        glare.Rotation = GlareSettings.Angle
                    else
                        -- СЃРїСЂР°РІР° РЅР°Р»РµРІРѕ
                        glare.Position = UDim2.new(0, (winW + GLARE_W * 2) - (winW + GLARE_W * 3) * e, 0, -0.2)
                        glare.Rotation = -GlareSettings.Angle
                    end
                    -- РјСЏРіРєРѕРµ Р·Р°С‚СѓС…Р°РЅРёРµ РІ РЅР°С‡Р°Р»Рµ Рё РєРѕРЅС†Рµ РїСЂРѕС…РѕРґР°
                    local fade = math.min(1, math.min(t / 0.12, (1 - t) / 0.12))
                    glare.BackgroundTransparency = 0.95 - 0.33 * fade
                else
                    glare.Visible = false
                end
            else
                glare.Visible = false
            end
            end)
        end)
    end)
end)

-- ========================================================
-- РРќР¤РћР РњРђР¦РРћРќРќРђРЇ РџРђРќР•Р›Р¬ Р’ РџР РђР’РћРњ Р’Р•Р РҐРќР•Рњ РЈР“Р›РЈ
-- ========================================================

function createInfoPanel()
    -- РџРѕР»СѓС‡Р°РµРј РЅРёРє РёРіСЂРѕРєР°
    local playerName = game:GetService("Players").LocalPlayer.Name
    
    -- РЎРѕР·РґР°С‘Рј ScreenGui
    local infoGui = Instance.new("ScreenGui")
    infoGui.Name = "VortexInfo"
    infoGui.IgnoreGuiInset = true
    infoGui.ResetOnSpawn = false
    infoGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    infoGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- РћРЎРќРћР’РќРђРЇ РџРђРќР•Р›Р¬ (Frame)
    local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 484, 0, 44)  -- СЂРѕРІРЅРѕ: 3 РїСЂРѕР±РµР»Р° РїРѕСЃР»Рµ РІСЂРµРјРµРЅРё + С‚РµРєСЃС‚ + 2 РїСЂРѕР±РµР»Р°
    mainFrame.Position = UDim2.new(1, -492, 0, 15)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 15, 30)
    mainFrame.BackgroundTransparency = 0
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = infoGui
    
    -- Р—Р°РєСЂСѓРіР»РµРЅРёРµ СѓРіР»РѕРІ
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- РќРµРѕРЅРѕРІР°СЏ РѕР±РІРѕРґРєР° РїР°РЅРµР»Рё
    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(139, 92, 246)
    panelStroke.Thickness = 1.2
    panelStroke.Transparency = 0.45
    panelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    panelStroke.Parent = mainFrame
    
    -- РњРёРЅРё-РіСЂР°РґРёРµРЅС‚ РЅР° РїР°РЅРµР»Рё
    local panelGrad = Instance.new("UIGradient")
    panelGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 22, 52)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(14, 13, 26)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 22, 48)),
    })
    panelGrad.Rotation = 90
    panelGrad.Parent = mainFrame
    
    -- Р›РћР“РћРўРРџ "C"
    local logoFrame = Instance.new("Frame")
    logoFrame.Size = UDim2.new(0, 28, 0, 28)
    logoFrame.Position = UDim2.new(0, 6, 0.5, -14)
    logoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    logoFrame.BackgroundTransparency = 0
    logoFrame.BorderSizePixel = 0
    logoFrame.Parent = mainFrame
    
    -- РљРѕР»СЊС†Рѕ РІРѕРєСЂСѓРі Р±СѓРєРІС‹ (РїРµСЂРµР»РёРІР°РµС‚СЃСЏ С„РёРѕР»РµС‚РѕРІС‹Рј)
    local logoRing = Instance.new("UIStroke")
    logoRing.Color = Color3.fromRGB(168, 85, 247)
    logoRing.Thickness = 1.6
    logoRing.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    logoRing.Parent = logoFrame
    
    -- Р—Р°РєСЂСѓРіР»РµРЅРёРµ РґР»СЏ Р»РѕРіРѕС‚РёРїР° (РєСЂСѓРі)
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(1, 0)
    logoCorner.Parent = logoFrame
    
    -- Р‘СѓРєРІР° "C" СЃ Р±С‹СЃС‚СЂС‹Рј С„РёРѕР»РµС‚РѕРІС‹Рј РїРµСЂРµР»РёРІРѕРј
    local letterV = Instance.new("TextLabel")
    letterV.Size = UDim2.new(1, 0, 1, 0)
    letterV.Position = UDim2.new(0, 0, 0, 0)
    letterV.BackgroundTransparency = 1
    letterV.Text = "C"
    letterV.TextSize = 18
    letterV.TextColor3 = Color3.fromRGB(255, 255, 255)
    letterV.Font = Enum.Font.GothamBold
    letterV.TextScaled = true
    letterV.Parent = logoFrame
    local letterGrad = Instance.new("UIGradient")
    letterGrad.Rotation = 0
    letterGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 58, 237)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(168, 85, 247)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(236, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(124, 58, 237)),
    })
    letterGrad.Parent = letterV
    local logoGlow = Instance.new("UIStroke")
    logoGlow.Color = Color3.fromRGB(168, 85, 247)
    logoGlow.Thickness = 3
    logoGlow.Transparency = 0.6
    logoGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    logoGlow.Parent = logoFrame

    -- РќРРљ РР“Р РћРљРђ + Р”РђРўРђ + Р’Р Р•РњРЇ (РІСЃРµ СЌРјРѕРґР·Рё Р‘Р•Р›Р«Р•)
infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(0, 330, 0, 32)
    infoLabel.Position = UDim2.new(0, 42, 0.5, -16)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "\u{1F464}  " .. playerName .. "    \u{1F4C5}  " .. os.date("%d.%m.%Y") .. "    \u{1F552}  " .. os.date("%H:%M:%S")
    infoLabel.TextSize = 16
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.Font = Enum.Font.GothamMedium
    infoLabel.TextScaled = false
    infoLabel.Parent = mainFrame

    -- HubName (РїРµСЂРµР»РёРІР°СЋС‰РµРµСЃСЏ, РІ СЃР°РјРѕРј РєРѕРЅС†Рµ РїР°РЅРµР»Рё вЂ” РЅРёС‡РµРіРѕ РЅРµ РїРµСЂРµРєСЂС‹РІР°РµС‚)
vortexLabel = Instance.new("TextLabel")
    vortexLabel.Size = UDim2.new(0, 112, 0, 32)
    vortexLabel.Position = UDim2.new(0, 372, 0.5, -16)  -- СЃСЂР°Р·Сѓ Р·Р° РІСЂРµРјРµРЅРµРј
    vortexLabel.BackgroundTransparency = 1
    vortexLabel.Text = "   ConceptHub  "
    vortexLabel.TextSize = 15
    vortexLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    vortexLabel.TextXAlignment = Enum.TextXAlignment.Left
    vortexLabel.Font = Enum.Font.GothamBold
    vortexLabel.TextScaled = false
    vortexLabel.Parent = mainFrame
    local vortexGrad = Instance.new("UIGradient")
    vortexGrad.Rotation = 0
    vortexGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(139, 92, 246)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(56, 189, 248)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 92, 246)),
    })
    vortexGrad.Parent = vortexLabel

    
    -- РћР‘РќРћР’Р›Р•РќРР• Р’Р Р•РњР•РќР
    local timeConnection = game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
        if not mainFrame.Parent then
            if timeConnection then
                timeConnection:Disconnect()
            end
            return
        end
    infoLabel.Text = "\u{1F464}  " .. playerName .. "     \u{1F4C5}  " .. os.date("%d.%m.%Y") .. "     \u{1F552}  " .. os.date("%H:%M:%S")
        end)
    end)
    
    -- РњРµРґР»РµРЅРЅС‹Р№ С„РёРѕР»РµС‚РѕРІС‹Р№ РїРµСЂРµР»РёРІ Р±СѓРєРІС‹ "C" Рё РєРѕР»СЊС†Р°
    local shimmerStart = tick()
    local shimmerConnection = RunService.RenderStepped:Connect(function(dt)
        pcall(function()
        if not mainFrame.Parent then
            if shimmerConnection then shimmerConnection:Disconnect() end
            return
        end
        local t = (tick() - shimmerStart) * 1.6
        local purpleMix = (math.sin(t) + 1) / 2
        local ringColor = Color3.fromRGB(124, 58, 237):Lerp(Color3.fromRGB(196, 130, 255), purpleMix)
        logoRing.Color = ringColor
        logoGlow.Color = ringColor
        panelStroke.Color = ringColor
        letterGrad.Offset = Vector2.new(math.sin(t + 1.3) * 0.65, 0)
        end)
    end)

    return {
        Gui = infoGui,
        Frame = mainFrame,
        InfoLabel = infoLabel,
        VortexLabel = vortexLabel,
        Destroy = function()
            if timeConnection then
                timeConnection:Disconnect()
            end
            if shimmerConnection then
                shimmerConnection:Disconnect()
            end
            if infoGui then
                infoGui:Destroy()
            end
        end
    }
end

-- РЎРѕР·РґР°С‘Рј РїР°РЅРµР»СЊ
infoPanel = createInfoPanel()
print("вњ… РРЅС„РѕСЂРјР°С†РёРѕРЅРЅР°СЏ РїР°РЅРµР»СЊ СЃРѕР·РґР°РЅР°! РќРёРє: " .. game:GetService("Players").LocalPlayer.Name)

-- ========================================================
-- РљРћРќР•Р¦ РРќР¤РћР РњРђР¦РРћРќРќРћР™ РџРђРќР•Р›Р
-- ========================================================

-- ============================================================
-- Sidebar "Visual chapter": a header with an arrow that expands
-- and collapses the visual sub-tabs placed underneath it.
-- ============================================================
local function CreateVisualChapter(parentFrame)
    local header = Instance.new("TextButton")
    header.Name = "VisualChapterHeader"
    header.Parent = parentFrame
    header.AutoButtonColor = false
    header.BackgroundColor3 = Color3.fromRGB(41, 45, 49)
    header.BackgroundTransparency = 0.85
    header.BorderSizePixel = 0
    header.Size = UDim2.new(1, -1, 0, 30)
    header.Text = ""
    header.ZIndex = 8
    header:SetAttribute("ThemeLock", true)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = header

    local icon = Instance.new("TextLabel")
    icon.Parent = header
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(0, 2, 0.5, 0)
    icon.Size = UDim2.new(0, 25, 0, 25)
    icon.ZIndex = 9
    icon.FontFace = NeverLose.BuiltInBold
    icon.Text = "palette"
    icon.TextColor3 = Color3.fromRGB(150, 155, 165)
    icon.TextSize = 16
    icon:SetAttribute("ThemeLock", true)

    local title = Instance.new("TextLabel")
    title.Parent = header
    title.AnchorPoint = Vector2.new(0, 0.5)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 30, 0.5, 0)
    title.Size = UDim2.new(1, -58, 0, 15)
    title.ZIndex = 9
    title.Font = Enum.Font.GothamMedium
    title.Text = "Visual chapter"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title:SetAttribute("ThemeLock", true)

    local arrow = Instance.new("TextLabel")
    arrow.Parent = header
    arrow.AnchorPoint = Vector2.new(1, 0.5)
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -8, 0.5, 0)
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.ZIndex = 9
    arrow.FontFace = NeverLose.BuiltInBold
    arrow.Text = "caret-small-right"
    arrow.TextColor3 = Color3.fromRGB(200, 205, 215)
    arrow.TextSize = 16
    arrow:SetAttribute("ThemeLock", true)

    local rows = {}
    local childTabs = {}
    local expanded = false

    local function setExpanded(state)
        expanded = state
        arrow.Text = state and "caret-small-down" or "caret-small-right"

        for _, row in ipairs(rows) do
            row.Visible = state
        end

        -- If a sub-tab was open while collapsing, fall back to the first tab.
        if not state then
            local current = Window.Tabs[Window.CurrentTab]
            for _, child in ipairs(childTabs) do
                if child == current then
                    for i, tab in ipairs(Window.Tabs) do
                        tab.SetValue(i == 1)
                    end
                    Window.CurrentTab = 1
                    break
                end
            end
        end
    end

    header.MouseButton1Click:Connect(function()
        setExpanded(not expanded)
    end)

    setExpanded(false)

    local chapter = {}

    function chapter:AddChild(config)
        local tab = Window:AddTab(config)
        local button = tab.Idx
        local container = button.Parent

        local row = Instance.new("Frame")
        row.Name = "VisualChapterRow"
        row.BackgroundTransparency = 1
        row.BorderSizePixel = 0
        row.Size = UDim2.new(1, -1, 0, 30)
        row.Parent = container
        row:SetAttribute("ThemeLock", true)

        button.Parent = row
        button.Size = UDim2.new(1, -18, 1, 0)
        button.Position = UDim2.new(0, 18, 0, 0)

        table.insert(rows, row)
        table.insert(childTabs, tab)
        row.Visible = expanded
        return tab
    end

    function chapter:Finish()
        setExpanded(false)
    end

    return chapter
end

Tabs = {}

-- 1) Combat (renamed from Main)
Tabs.Main = Window:AddTab({ Icon = "sparkles", Name = "Combat", Type = "Double" })

-- 1.5) Duel Combat
Tabs.DuelCombat = Window:AddTab({ Icon = "sword", Name = "Duel Combat", Type = "Double" })

-- 2) Legit
Tabs.Legit = Window:AddTab({ Icon = "shield", Name = "Legit", Type = "Double" })

-- 3) Movement (Extra merged into it)
Tabs.Movement = Window:AddTab({ Icon = "car", Name = "Movement", Type = "Double" })
Tabs.Extra = Tabs.Movement

-- 4) Visual chapter -> 5) Visual World + 6) VSX Visual
local VisualChapter = CreateVisualChapter(Tabs.Movement.Idx.Parent)
Tabs.Visual = VisualChapter:AddChild({ Icon = "palette", Name = "Visual World", Type = "Double" })
Tabs.VSX = VisualChapter:AddChild({ Icon = "brush", Name = "VSX Visual", Type = "Double" })
VisualChapter:Finish()

-- 7) Configurations
Tabs["Configurations"] = Window:AddTab({ Icon = "settings", Name = "Configurations", Type = "Single" })

-- 7.5) Open access
Tabs.OpenAccess = Window:AddTab({ Icon = "key", Name = "Open access", Type = "Double" })

-- 8) Setting Playr (Fun + Player merged)
Tabs.Player = Window:AddTab({ Icon = "user", Name = "Setting Playr", Type = "Single" })
Tabs.Fun = Tabs.Player

-- 9) Texture
Tabs.Textur = Window:AddTab({ Icon = "wand", Name = "Texture", Type = "Single" })

-- 10) Setting UI (renamed from Settings)
Tabs.Settings = Window:AddTab({ Icon = "three-sliders-horizontal", Name = "Setting UI", Type = "Single" })

-- ========================================================
-- РќРћР’Р«Р• Р’РљР›РђР”РљР: Movement / Player / Fun
-- ========================================================
-- (Movement / Player / Fun / Textur are defined in the block above)

-- ========================================================
-- РќРћР’РђРЇ Р’РљР›РђР”РљРђ SETTINGS (Р±Р»РёРє + С†РІРµС‚ РёРЅС‚РµСЂС„РµР№СЃР°).
-- Р’РќРРњРђРќРР•: РІРёРґР¶РµС‚С‹ СЌС‚РѕР№ РІРєР»Р°РґРєРё РЅР°РјРµСЂРµРЅРЅРѕ РќР• РґРѕР±Р°РІР»СЏСЋС‚СЃСЏ
-- РІ BindableToggles вЂ” Р·РЅР°С‡РёС‚ РѕРЅРё РќР• Р±РёРЅРґСЏС‚СЃСЏ РЅР° РєР»Р°РІРёС€Рё.
-- ========================================================
-- (Settings tab is defined in the block above)

BlikSection = Tabs.Settings:AddSection({ Name = "Blik", Position = "left" })
ThemeSection = Tabs.Settings:AddSection({ Name = "InterfaceColor", Position = "left" })
BannerSection = Tabs.Settings:AddSection({ Name = "Banner", Position = "right" })

NeverLose.Banner = NeverLose.Banner or { image = nil, overlay = nil, transparency = 0.35, panelTransparency = nil }

NeverLose.Banner.default = "126117415439604"

NeverLose.Banner.cache = {
    ["126117415439604"] = "rbxthumb://type=Asset&id=126117415439604&w=768&h=432",
    ["105023753013943"] = "rbxthumb://type=Asset&id=105023753013943&w=768&h=432",
}

do
    local logPath = "banner_log.txt"
    local absPath = "C:\\Users\\arsen\\AppData\\Local\\Temp\\opencode\\banner_log.txt"
    local function stamp()
        local ok, t = pcall(function() return os.date and os.date("%H:%M:%S") or "?" end)
        return ok and tostring(t) or "?"
    end
    NeverLose.BannerLog = function(...)
        local parts = {}
        for i = 1, select("#", ...) do
            parts[#parts + 1] = tostring(select(i, ...))
        end
        local line = "[" .. stamp() .. "] " .. table.concat(parts, " ")
        print(line)
        if type(writefile) == "function" then
            pcall(function()
                local old = ""
                if type(readfile) == "function" then
                    local ok, data = pcall(function() return readfile(logPath) end)
                    if ok and type(data) == "string" then old = data end
                end
                writefile(logPath, old .. line .. "\n")
            end)
            pcall(function() writefile(absPath, line .. "\n", true) end)
        end
    end
    NeverLose.BannerLog("banner module loaded")
end

do
    local wf = NeverLose.WindowFrame
    if not wf then
        NeverLose.BannerLog("WindowFrame is NIL")
    else
        NeverLose.BannerLog(string.format(
            "WindowFrame: parent=%s visible=%s zindex=%d absSize=%s absPos=%s transp=%.3f guiZBehavior=%s screenGui=%s",
            tostring(wf.Parent and wf.Parent.Name),
            tostring(wf.Visible),
            wf.ZIndex,
            tostring(wf.AbsoluteSize),
            tostring(wf.AbsolutePosition),
            wf.BackgroundTransparency,
            tostring(wf.Parent and wf.Parent.ZIndexBehavior),
            tostring(NeverLose.ScreenGui and NeverLose.ScreenGui.Name)
        ))
    end
end

local function BannerClear()
    if NeverLose.Banner.image then
        pcall(function() NeverLose.Banner.image:Destroy() end)
        NeverLose.Banner.image = nil
    end
    if NeverLose.Banner.overlay then
        pcall(function() NeverLose.Banner.overlay:Destroy() end)
        NeverLose.Banner.overlay = nil
    end
    if NeverLose.Banner.panelTransparency ~= nil and NeverLose.RightMenuFrame then
        pcall(function()
            if NeverLose.RightMenuFrame.Parent then
                NeverLose.RightMenuFrame.BackgroundTransparency = NeverLose.Banner.panelTransparency
            end
        end)
        NeverLose.Banner.panelTransparency = nil
    end
end

local function BannerTrim(input)
    if type(input) == "number" then input = tostring(input) end
    if type(input) ~= "string" then return "" end
    local code = input:match("^%s*(.-)%s*$")
    code = code:gsub('"', ""):gsub("'", "")
    if code == "" then return "" end
    if not code:match("://") then
        local scheme, rest = code:match("^(%a[%w+.-]*):(.*)$")
        if scheme then
            return scheme .. "://" .. rest
        end
    end
    return code
end

local function BannerMode()
    local mode = "Auto"
    if bannerModeDropdown then
        pcall(function() mode = bannerModeDropdown:GetValue() or "Auto" end)
    end
    return mode
end

local function BannerHttpGet(url)
    local body = nil
    if type(request) == "function" then
        local ok, res = pcall(function()
            return request({ Url = url, Method = "GET" })
        end)
        if ok and type(res) == "table" and res.Success and type(res.Body) == "string" then
            body = res.Body
        end
    end
    if not body then
        pcall(function()
            local HttpService = game:GetService("HttpService")
            local ok, res = pcall(function()
                return HttpService:RequestAsync({ Url = url, Method = "GET" })
            end)
            if ok and type(res) == "table" and res.Success and type(res.Body) == "string" then
                body = res.Body
            end
        end)
    end
    return body
end

local function BannerApiUrl(path, query)
    local body = BannerHttpGet("https://thumbnails.roblox.com" .. path .. "?" .. query)
    if type(body) ~= "string" then return nil end
    local url = nil
    pcall(function()
        local HttpService = game:GetService("HttpService")
        local data = HttpService:JSONDecode(body)
        if type(data) == "table" and type(data.data) == "table" and type(data.data[1]) == "table" then
            url = data.data[1].imageUrl
        end
    end)
    return url
end

local function BannerCanLoad(url)
    if type(url) ~= "string" or url == "" then return false end
    local ContentProvider = nil
    pcall(function() ContentProvider = game:GetService("ContentProvider") end)
    if not ContentProvider then return true end
    local ok = pcall(function()
        ContentProvider:PreloadAsync({ url }, 8)
    end)
    return ok and true or false
end

local function BannerShow(url)
    BannerClear()
    if type(url) ~= "string" or url == "" then return false end
    local code = url
    local parent = NeverLose.WindowFrame
    if not parent or not parent.Parent then
        print("[NeverLose] banner failed: no window frame parent")
        return false
    end
    if NeverLose.RightMenuFrame and NeverLose.RightMenuFrame.Parent then
        NeverLose.Banner.panelTransparency = NeverLose.RightMenuFrame.BackgroundTransparency
        pcall(function() NeverLose.RightMenuFrame.BackgroundTransparency = 1 end)
    end
    local overlay = Instance.new("Frame")
    overlay.Name = "NeverLoseBannerOverlay"
    overlay.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
    overlay.BackgroundTransparency = 0.15
    overlay.BorderSizePixel = 0
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.Position = UDim2.fromScale(0, 0)
    overlay.ZIndex = 2
    overlay.Active = false
    overlay.Selectable = false
    overlay.Parent = parent
    local image = Instance.new("ImageLabel")
    image.Name = "NeverLoseBannerImage"
    image.BackgroundTransparency = 1
    image.BorderSizePixel = 0
    image.Size = UDim2.fromScale(1, 1)
    image.Position = UDim2.fromScale(0, 0)
    image.Image = code
    image.ImageColor3 = Color3.fromRGB(255, 255, 255)
    image.ImageTransparency = NeverLose.Banner.transparency
    image.ScaleType = Enum.ScaleType.Crop
    image.ZIndex = 3
    image.Active = false
    image.Selectable = false
    image.Parent = parent
    NeverLose.Banner.image = image
    NeverLose.Banner.overlay = overlay
    NeverLose.Banner.code = code
    NeverLose.BannerLog("banner applied: " .. code)
    local loadState = "unknown"
    pcall(function()
        if not BannerCanLoad(code) then
            loadState = "FAILED"
            NeverLose.BannerLog("banner image did NOT load: " .. code)
        else
            loadState = "ok"
        end
    end)
    NeverLose.BannerLog(string.format(
        "image placed: parent=%s zindex=%d visible=%s absSize=%s guiParent=%s load=%s",
        tostring(image.Parent and image.Parent.Name),
        image.ZIndex,
        tostring(image.Visible),
        tostring(image.AbsoluteSize),
        tostring(image.Parent and image.Parent.Parent and image.Parent.Parent.Name),
        loadState
    ))
    return true
end

local function BannerApply(input)
    local code = BannerTrim(input)
    if code == "" then return false end
    if code:match("://") then
        return BannerShow(code)
    end
    local id = code:match("^%d+$")
    if not id then
        return BannerShow("rbxassetid://" .. code)
    end
    local mode = BannerMode()
    if mode == "Auto" then
        mode = "Asset Api"
    end
    local cached = nil
    if NeverLose.Banner.cache and NeverLose.Banner.cache[id] then
        cached = NeverLose.Banner.cache[id]
    end
    local candidates = {
        "rbxthumb://type=Asset&id=" .. id .. "&w=768&h=432",
        "rbxassetid://" .. id,
    }
    if cached then
        table.insert(candidates, 3, cached)
    end
    table.insert(candidates, "rbxthumb://type=AssetThumb&id=" .. id .. "&w=768&h=432")
    if mode == "Asset Api" or mode == "Auto" then
        for _, candidate in ipairs(candidates) do
            local state = "fail"
            pcall(function()
                if BannerCanLoad(candidate) then
                    state = "OK"
                end
            end)
            NeverLose.BannerLog("candidate " .. candidate .. " -> " .. state)
            if state == "OK" then
                return BannerShow(candidate)
            end
        end
        return false
    end
    if mode == "Asset" then
        return BannerShow("rbxassetid://" .. id)
    elseif mode == "Asset Thumb" then
        return BannerShow("rbxthumb://type=Asset&w=768&h=432&id=" .. id)
    elseif mode == "User Thumb" then
        return BannerShow("rbxthumb://type=AvatarHeadShot&w=420&h=420&id=" .. id)
    elseif mode == "Game Thumb" then
        return BannerShow("rbxthumb://type=Game&w=420&h=420&id=" .. id)
    elseif mode == "User Api" then
        local url = BannerApiUrl("/v1/users/avatar-headshot", "userIds=" .. id .. "&size=420x420&format=Png&isCircular=false")
        if url then
            return BannerShow(url)
        end
        print("[NeverLose] banner user api failed: " .. id)
        return false
    elseif mode == "Game Api" then
        local url = BannerApiUrl("/v1/games/icons", "universeIds=" .. id .. "&returnPolicy=PlaceHolder&size=420x420&format=Png")
        if url then
            return BannerShow(url)
        end
        print("[NeverLose] banner game api failed: " .. id)
        return false
    end
    local url = BannerApiUrl("/v1/assets", "assetIds=" .. id .. "&returnPolicy=PlaceHolder&size=768x432&format=Png&isCircular=false")
    if url then
        return BannerShow(url)
    end
    url = BannerApiUrl("/v1/games/icons", "universeIds=" .. id .. "&returnPolicy=PlaceHolder&size=420x420&format=Png")
    if url then
        return BannerShow(url)
    end
    print("[NeverLose] banner api failed, fallback to rbxassetid: " .. id)
    return BannerShow("rbxassetid://" .. id)
end

BannerCodeTextBox = BannerSection:AddTextInput({
    Text = "Banner Code",
    Placeholder = "126117415439604 or rbxassetid://1234567890",
    Default = NeverLose.Banner.default,
    Size = 150,
    Callback = function(value)
        if type(value) == "string" and value ~= "" then
            BannerApply(value)
        end
    end,
})

local function BannerReapply()
    local value = ""
    pcall(function() value = BannerCodeTextBox:GetValue() end)
    if value ~= "" then
        BannerApply(value)
    end
end

bannerModeDropdown = BannerSection:AddDropdown({
    Text = "Banner Mode",
    Default = "Auto",
    Options = { "Auto", "Asset Api", "Game Api", "User Api", "Asset", "Asset Thumb", "Game Thumb", "User Thumb" },
    Callback = function()
        task.defer(BannerReapply)
    end,
})
bannerModeDropdown:ToolTip("Auto renders any id through the Roblox thumbnails API, this is the only mode that works for decals")

BannerSection:AddButton({
    Name = "Apply Banner",
    Callback = BannerReapply,
})

BannerSection:AddButton({
    Name = "Remove Banner",
    Callback = function()
        pcall(function() BannerCodeTextBox:SetValue("") end)
        BannerClear()
    end,
})

BannerSection:AddButton({
    Name = "Test Banner",
    Callback = function()
        BannerApply("rbxasset://textures/ui/VerifiedBadgeNameIcon.png")
    end,
})

BannerSection:AddButton({
    Name = "Solid Test",
    Callback = function()
        BannerClear()
        local parent = NeverLose.WindowFrame
        if not parent or not parent.Parent then
            print("[NeverLose] solid test failed: no parent")
            return
        end
        if NeverLose.RightMenuFrame and NeverLose.RightMenuFrame.Parent then
            NeverLose.Banner.panelTransparency = NeverLose.RightMenuFrame.BackgroundTransparency
            pcall(function() NeverLose.RightMenuFrame.BackgroundTransparency = 1 end)
        end
        local box = Instance.new("Frame")
        box.Name = "NeverLoseSolidTest"
        box.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        box.BackgroundTransparency = 0
        box.BorderSizePixel = 0
        box.Size = UDim2.fromScale(1, 1)
        box.Position = UDim2.fromScale(0, 0)
        box.ZIndex = 2
        box.Active = false
        box.Selectable = false
        box.Parent = parent
        NeverLose.Banner.overlay = box
        NeverLose.BannerLog(string.format(
            "solid test: parent=%s zindex=%d visible=%s absSize=%s screenGuiParent=%s screenGuiDisplayOrder=%s resetOnSpawn=%s",
            tostring(box.Parent and box.Parent.Name),
            box.ZIndex,
            tostring(box.Visible),
            tostring(box.AbsoluteSize),
            tostring(box.Parent and box.Parent.Parent and box.Parent.Parent.Name),
            tostring(box.Parent and box.Parent.Parent and box.Parent.Parent.DisplayOrder),
            tostring(box.Parent and box.Parent.Parent and box.Parent.Parent.ResetOnSpawn)
        ))
        local wf = NeverLose.WindowFrame
        NeverLose.BannerLog(string.format(
            "WINDOW: zindex=%d visible=%s transp=%.3f absSize=%s absPos=%s clips=%s parentClass=%s",
            wf.ZIndex,
            tostring(wf.Visible),
            wf.BackgroundTransparency,
            tostring(wf.AbsoluteSize),
            tostring(wf.AbsolutePosition),
            tostring(wf.ClipsDescendants),
            tostring(wf.Parent and wf.Parent.ClassName)
        ))
        NeverLose.BannerLog("CHILDREN of window (name/class/z/vis/abs/transp):")
        local childCount = 0
        for _, child in ipairs(wf:GetChildren()) do
            childCount = childCount + 1
            NeverLose.BannerLog(string.format(
                "  %s / %s / z=%d / vis=%s / %s / t=%.3f",
                tostring(child.Name), child.ClassName, child.ZIndex, tostring(child.Visible),
                tostring(child.AbsoluteSize), child.BackgroundTransparency
            ))
        end
        NeverLose.BannerLog("child count = " .. tostring(childCount))
        NeverLose.BannerLog("LAYERS above banner (z>=4, sorted desc):")
        local layers = {}
        for _, d in ipairs(NeverLose.ScreenGui:GetDescendants()) do
            if d:IsA("GuiObject") and d.ZIndex >= 4 and d ~= box then
                layers[#layers + 1] = d
            end
        end
        table.sort(layers, function(a, b) return a.ZIndex > b.ZIndex end)
        local shown = 0
        for _, d in ipairs(layers) do
            if shown >= 25 then break end
            local size = d.AbsoluteSize
            if size.X > 200 and size.Y > 150 and d.BackgroundTransparency < 1 then
                shown = shown + 1
                NeverLose.BannerLog(string.format(
                    "  %s / %s / z=%d / transp=%.3f / color=%s / size=%s",
                    tostring(d.Name), d.ClassName, d.ZIndex, d.BackgroundTransparency,
                    tostring(d.BackgroundColor3), tostring(size)
                ))
            end
        end
        NeverLose.BannerLog("wide layers above banner = " .. tostring(shown))
    end,
})

BannerTransparencySlider = BannerSection:AddSlider({
    Text = "Banner Opacity",
    Default = 35,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        NeverLose.Banner.transparency = (value or 35) / 100
        if NeverLose.Banner.image then
            pcall(function() NeverLose.Banner.image.ImageTransparency = NeverLose.Banner.transparency end)
        end
    end,
})

task.defer(function()
    task.wait(4)
    if NeverLose.BannerLog and NeverLose.Banner.image then
        NeverLose.BannerLog("auto banner: color=" .. tostring(NeverLose.Banner.image.ImageColor3) .. " transp=" .. tostring(NeverLose.Banner.image.ImageTransparency) .. " z=" .. tostring(NeverLose.Banner.image.ZIndex))
    end
end)

-- ========================================================
-- HUB SIZE (настройка длины и высоты хаба)
-- ========================================================
SizeSection = Tabs.Settings:AddSection({ Name = "HubSize", Position = "left" })

local hubWidth = 800
local hubHeight = 600

local function ApplyHubSize()
    if Window and Window.SetSize then
        pcall(function()
            Window:SetSize(UDim2.new(0, hubWidth, 0, hubHeight))
        end)
    end
end

HubWidthSlider = SizeSection:AddSlider({
    Text = "Hub Width",
    Min = 500,
    Max = 1600,
    Default = 800,
    Rounding = 10,
    Callback = function(value)
        hubWidth = value or 800
        ApplyHubSize()
    end,
})

HubHeightSlider = SizeSection:AddSlider({
    Text = "Hub Height",
    Min = 350,
    Max = 1000,
    Default = 600,
    Rounding = 10,
    Callback = function(value)
        hubHeight = value or 600
        ApplyHubSize()
    end,
})

SizeSection:AddButton({
    Name = "Reset Size",
    Callback = function()
        hubWidth = 800
        hubHeight = 600
        pcall(function() HubWidthSlider:SetValue(800) end)
        pcall(function() HubHeightSlider:SetValue(600) end)
        ApplyHubSize()
    end,
})

GlareEnabledToggle = BlikSection:AddToggle({
    Text = "Glare",
    Default = true,
    Callback = function(v)
        GlareSettings.Enabled = v
    end,
})

GlareSpeedSlider = BlikSection:AddSlider({
    Text = "Glare Speed",
    Default = 6,
    Min = 1,
    Max = 15,
    Rounding = 1,
    Type = " sec",
    Callback = function(v)
        GlareSettings.Cycle = v
    end,
})

GlareSideToggle = BlikSection:AddToggle({
    Text = "Reverse Side",
    Default = false,
    Callback = function(v)
        GlareSettings.Side = v and -1 or 1
    end,
})

GlareColorPicker = BlikSection:AddColorPicker({
    Text = "Glare Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        GlareSettings.Color = color
        if NeverLose.SyncGlareVisuals then
            NeverLose.SyncGlareVisuals()
        end
    end,
})

GlareAngleSlider = BlikSection:AddSlider({
    Text = "Glare Angle",
    Default = 18,
    Min = 0,
    Max = 75,
    Rounding = 0,
    Type = " deg",
    Callback = function(v)
        GlareSettings.Angle = v
    end,
})

ThemeColorPicker = ThemeSection:AddColorPicker({
    Text = "Interface Color",
    Default = Theme.P,
    Callback = function(color)
        if SetTheme then
            SetTheme(color)
        end
    end,
})

ThemeResetButton = ThemeSection:AddButton({
    Name = "Reset Interface Color",
    Callback = function()
        if SetTheme then
            SetTheme(Color3.fromRGB(139, 92, 246))
        end
    end,
})

ThemeBannerAssets = {
    ["Akva"] = "126117415439604",
    ["Femboy"] = "100951792813319",
    ["Minecraft sunset"] = "123479764150343",
    ["Real-life view"] = "130766604531467",
    ["Default"] = "126117415439604",
}

ThemePresets = {
    { Name = "Akva", Reset = true },
    { Name = "Femboy", Reset = true },
    { Name = "Minecraft sunset", Reset = true },
    { Name = "Real-life view", Reset = true },
}

ThemeButtons = {}
for _, preset in ipairs(ThemePresets) do
    ThemeButtons[preset.Name] = ThemeSection:AddButton({
        Name = preset.Name,
        Callback = function()
            if preset.Reset then
                if RestoreThemeBase then RestoreThemeBase() end
                SettleThemeBackground(preset.Name)
            else
                if SetTheme then SetTheme(preset.Color) end
                SettleThemeBackground(preset.Name)
            end
        end,
    })
end

task.defer(function()
    task.wait(1.5)
    SettleThemeBackground("Akva")
end)

-- ==============================================
-- MOVEMENT
-- ==============================================
MovementSection = Tabs.Movement:AddSection({ Name = "Movement", Position = "left" })
FlySection = Tabs.Movement:AddSection({ Name = "FlySettings", Position = "left" })

FlySpeedSlider = FlySection:AddSlider({
    Text = "Fly Speed",
    Default = 24,
    Min = 5,
    Max = 100,
    Rounding = 0,
    Type = " studs/s",
})

local flyConnection, flyBodyGyro, flyBodyVelocity = nil, nil, nil

function StopFly()
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

function StartFly()
    StopFly()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    hum.PlatformStand = true
    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end)
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyGyro.D = 150
    flyBodyGyro.P = 12000
    flyBodyGyro.Parent = hrp
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyVelocity.Velocity = Vector3.new()
    flyBodyVelocity.Parent = hrp
    flyConnection = RunService.RenderStepped:Connect(function()
        local char2 = LocalPlayer.Character
        local hrp2 = char2 and char2:FindFirstChild("HumanoidRootPart")
        local hum2 = char2 and char2:FindFirstChildOfClass("Humanoid")
        if not hrp2 or not hum2 then return end
        local cam = workspace.CurrentCamera
        local forward = cam.CFrame.LookVector
        local right = cam.CFrame.RightVector
        local vertical = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vertical = vertical + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vertical = vertical - 1 end
        local dir = forward * ((UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0))
            + right * ((UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0))
            + Vector3.new(0, vertical, 0)
        if dir.Magnitude > 0 then dir = dir.Unit * FlySpeedSlider:GetValue() else dir = Vector3.new() end
        flyBodyVelocity.Velocity = dir
        flyBodyGyro.CFrame = cam.CFrame
    end)
end

flyToggle = MovementSection:AddToggle({
    Text = "Fly",
    Default = false,

    Callback = function(Value)
        if Value then StartFly() else StopFly() end
    end,
})
flyToggle:ToolTip("WASD вЂ” РїРѕР»С‘С‚, Space вЂ” РІРІРµСЂС…, Shift/Control вЂ” РІРЅРёР·")

noclipConnection = nil

noclipToggle = MovementSection:AddToggle({
    Text = "Noclip",
    Default = false,

    Callback = function(Value)
        if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
        if not Value then
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
            return
        end
        noclipConnection = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    end,
})
noclipToggle:ToolTip("РџСЂРѕС…РѕРґРёС€СЊ СЃРєРІРѕР·СЊ СЃС‚РµРЅС‹ Рё РѕР±СЉРµРєС‚С‹")

MovementSection:AddButton({
    Name = "Teleport Up",
    Callback = function()
        pcall(teleportupwards)
    end,
})

function applyJumpPower(v)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = v
    end
end

JumpPowerSlider = FlySection:AddSlider({
    Text = "Jump Power",
    Default = 50,
    Min = 25,
    Max = 250,
    Rounding = 0,

    Callback = applyJumpPower,
})

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    applyJumpPower(JumpPowerSlider:GetValue())
end)

-- ==============================================
-- PLAYER
-- ==============================================
PlayerUtilsSection = Tabs.Player:AddSection({ Name = "PlayerUtils", Position = "left" })

PlayerUtilsSection:AddButton({
    Name = "Reset Character",
    Callback = function()
        resetCharacterForced()
    end,
})

PlayerUtilsSection:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        rejoinCurrentServer()
    end,
})

clickTPConnection = nil

clickTPToggle = PlayerUtilsSection:AddToggle({
    Text = "Click TP",
    Default = false,

    Callback = function(Value)
        if clickTPConnection then clickTPConnection:Disconnect(); clickTPConnection = nil end
        if not Value then return end
        clickTPConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            if not UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then return end
            local mouse = LocalPlayer:GetMouse()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp or not mouse.Target then return end
            pcall(function()
                hrp.CFrame = mouse.Hit + Vector3.new(0, 2, 0)
            end)
        end)
    end,
})
clickTPToggle:ToolTip("Ctrl + Р›РљРњ вЂ” С‚РµР»РµРїРѕСЂС‚ РІ С‚РѕС‡РєСѓ РїСЂРёС†РµР»Р°")

PlayerInfoSection = Tabs.Player:AddSection({ Name = "PlayerInfo", Position = "left" })
statsLabel = PlayerInfoSection:AddLabel("FPS: --  |  Ping: -- ms")

fpsLast = tick()
fpsValue = 60
fpsTick = 0
fpsConnection = RunService.RenderStepped:Connect(function()
    local now = tick()
    local dt = now - fpsLast
    fpsLast = now
    if dt > 0 then
        fpsValue = fpsValue * 0.9 + (1 / dt) * 0.1
    end
    if now - fpsTick >= 1 then
        fpsTick = now
        local ping = 0
        pcall(function()
            if FreezePingState.active then
                ping = FreezePingState.value
            else
                local pingStat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
                if pingStat then ping = pingStat:GetValue() or 0 end
            end
        end)
        pcall(function()
            statsLabel:SetText(string.format("FPS: %d  |  Ping: %d ms", math.floor(fpsValue + 0.5), math.floor(ping + 0.5)))
        end)
    end
end)

-- ==============================================
-- FUN
-- ==============================================
FunSlidersSection = Tabs.Fun:AddSection({ Name = "FunSliders", Position = "left" })
FunTogglesSection = Tabs.Fun:AddSection({ Name = "FunToggles", Position = "left" })

CharScaleStore = {}
DefaultHipHeight = nil
function applyCharSize(v)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        if next(CharScaleStore) == nil then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    CharScaleStore[part] = part.Size
                end
            end
            DefaultHipHeight = hum.HipHeight
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for part, orig in pairs(CharScaleStore) do
            pcall(function()
                local rel = part.CFrame.Position - hrp.Position
                part.CFrame = hrp.CFrame * CFrame.new(rel * v)
                part.Size = orig * v
            end)
        end
        if DefaultHipHeight and DefaultHipHeight > 0 then
            hum.HipHeight = DefaultHipHeight
        end
    end)
end

SizeSlider = FunSlidersSection:AddSlider({
    Text = "Character Size",
    Default = 1,
    Min = 0.5,
    Max = 2.5,
    Rounding = 2,

    Callback = applyCharSize,
})

spinConnection = nil

spinToggle = FunTogglesSection:AddToggle({
    Text = "Spin",
    Default = false,

    Callback = function(Value)
        if spinConnection then spinConnection:Disconnect(); spinConnection = nil end
        if not Value then return end
        spinConnection = RunService.RenderStepped:Connect(function(dt)
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, (dt or 0.03) * 8, 0)
        end)
    end,
})
spinToggle:ToolTip("РљСЂСѓС‚РёС‚ РїРµСЂСЃРѕРЅР°Р¶Р° РЅР° РјРµСЃС‚Рµ, РєР°Рє РІРѕР»С‡РѕРє")

HeadlessState = { enabled = false, connection = nil }

local function ApplyHeadless()
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("BasePart") then
        if HeadlessState.enabled then
            if head.Transparency ~= 1 then head.Transparency = 1 end
        else
            if head.Transparency == 1 then head.Transparency = 0 end
        end
    end
end

HeadlessState.Set = function(Value)
    HeadlessState.enabled = Value and true or false
    if HeadlessState.connection then
        HeadlessState.connection:Disconnect()
        HeadlessState.connection = nil
    end
    if HeadlessState.enabled then
        ApplyHeadless()
        HeadlessState.connection = RunService.Heartbeat:Connect(function()
            ApplyHeadless()
        end)
    else
        ApplyHeadless()
    end
end

FunTogglesSection:AddToggle({
    Text = "Headless",
    Default = false,

    Callback = function(Value)
        HeadlessState.Set(Value)
    end,
})

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if HeadlessState.enabled then ApplyHeadless() end
end)

headlessConnection = nil

RadarState = { gui = nil, frame = nil, players = {}, connection = nil }

radarToggle = FunTogglesSection:AddToggle({
    Text = "Radar",
    Default = false,

    Callback = function(Value)
        if not Value then
            if radarConnection then radarConnection:Disconnect(); radarConnection = nil end
            if radarDragBegin then radarDragBegin:Disconnect(); radarDragBegin = nil end
            if radarDragMove then radarDragMove:Disconnect(); radarDragMove = nil end
            if radarDragEnd then radarDragEnd:Disconnect(); radarDragEnd = nil end
            if radarGui then pcall(function() radarGui:Destroy() end); radarGui = nil end
            radarPlayers = nil
            return
        end
        if radarGui then
            pcall(function() radarGui:Destroy() end)
        end
        radarGui = Instance.new("ScreenGui")
        radarGui.Name = "ConceptRadar"
        radarGui.ResetOnSpawn = false
        radarGui.IgnoreGuiInset = true
        radarGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        radarGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

        local radarFrame = Instance.new("Frame")
        radarFrame.Size = UDim2.new(0, 250, 0, 250)
        radarFrame.Position = UDim2.new(0.5, -125, 0.5, -125)
        radarFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
        radarFrame.BackgroundTransparency = 0.2
        radarFrame.BorderSizePixel = 2
        radarFrame.BorderColor3 = Color3.fromRGB(124, 58, 237)
        radarFrame.Parent = radarGui
        local radarCorner = Instance.new("UICorner")
        radarCorner.CornerRadius = UDim.new(0, 125)
        radarCorner.Parent = radarFrame
        local radarStroke = Instance.new("UIStroke")
        radarStroke.Thickness = 0
        radarStroke.Parent = radarFrame

        -- РџРµСЂРµС‚Р°СЃРєРёРІР°РЅРёРµ СЂР°РґР°СЂР° Р·Р°Р¶Р°С‚РёРµРј РџР РђР’РћР™ РєРЅРѕРїРєРё РјС‹С€Рё (РєСѓРґР° СѓРіРѕРґРЅРѕ)
        local dragging = false
        local startOffset = Vector2.zero
        local totalDelta = Vector2.zero
        radarDragBegin = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
            if not radarFrame then return end
            dragging = true
            totalDelta = Vector2.zero
            startOffset = UDim2.new(0, radarFrame.Position.X.Offset, 0, radarFrame.Position.Y.Offset)
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
        end)
        radarDragMove = UserInputService.InputChanged:Connect(function(input, gameProcessed)
            if not dragging then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            if not radarFrame then return end
            totalDelta = totalDelta + input.Delta
            radarFrame.Position = UDim2.new(0, startOffset.X + totalDelta.X, 0, startOffset.Y + totalDelta.Y)
        end)
        radarDragEnd = UserInputService.InputEnded:Connect(function(input, gameProcessed)
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                dragging = false
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end
        end)

        local radarTitle = Instance.new("TextLabel")
        radarTitle.Size = UDim2.new(0, 250, 0, 26)
        radarTitle.Position = UDim2.new(0, 0, 0, 4)
        radarTitle.BackgroundTransparency = 1
        radarTitle.Text = "RADAR"
        radarTitle.TextSize = 18
        radarTitle.Font = Enum.Font.GothamBold
        radarTitle.TextColor3 = Color3.fromRGB(236, 180, 255)
        radarTitle.Parent = radarFrame

        radarPlayers = {}
        radarConnection = RunService.RenderStepped:Connect(function()
            if not radarGui or not radarGui.Parent then
                if radarConnection then radarConnection:Disconnect(); radarConnection = nil end
                return
            end
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local collected = {}
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local pchar = plr.Character
                    local phrp = pchar and pchar:FindFirstChild("HumanoidRootPart")
                    if phrp then
                        local rel = phrp.Position - hrp.Position
                        if rel.Magnitude <= 600 then
                            collected[plr.Name] = true
                            local item = radarPlayers[plr.Name]
                            if not item then
                                local dotFrame = Instance.new("Frame")
                                dotFrame.Size = UDim2.new(0, 12, 0, 12)
                                dotFrame.Position = UDim2.new(0.5, -6, 0.5, -6)
                                dotFrame.BackgroundColor3 = Color3.fromRGB(236, 180, 255)
                                dotFrame.BackgroundTransparency = 0.3
                                dotFrame.Parent = radarFrame
                                local dotCorner = Instance.new("UICorner")
                                dotCorner.CornerRadius = UDim.new(0, 6)
                                dotCorner.Parent = dotFrame
                                local dotStroke = Instance.new("UIStroke")
                                dotStroke.Thickness = 0
                                dotStroke.Parent = dotFrame
                                local nickLabel = Instance.new("TextLabel")
                                nickLabel.Size = UDim2.new(0, 80, 0, 16)
                                nickLabel.BackgroundTransparency = 1
                                nickLabel.Text = plr.Name
                                nickLabel.TextSize = 11
                                nickLabel.Font = Enum.Font.GothamMedium
                                nickLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                nickLabel.TextStrokeTransparency = 0.4
                                nickLabel.Parent = radarFrame
                                item = { dot = dotFrame, label = nickLabel }
                                radarPlayers[plr.Name] = item
                            end
                            local px = math.clamp(rel.X / 600, -1, 1) * 105
                            local py = math.clamp(rel.Z / 600, -1, 1) * 105
                            item.dot.Position = UDim2.new(0.5, px - 6 + 125 * 0.0, 0.5, -py - 6)
                            item.label.Position = UDim2.new(0.5, px - 40 + 125 * 0.0, 0.5, -py - 26)
                        end
                    end
                end
            end
            for name, item in pairs(radarPlayers) do
                if not collected[name] then
                    if item.dot then pcall(function() item.dot:Destroy() end) end
                    if item.label then pcall(function() item.label:Destroy() end) end
                    radarPlayers[name] = nil
                end
            end
        end)
    end,
})

-- ==============================================
-- РљРћРќР•Р¦ РќРћР’Р«РҐ Р’РљР›РђР”РћРљ
-- ==============================================

-- Config persistence is built into NeverLose (config buttons live at the bottom of the window).
-- Old Obsidian SaveManager block removed.

AntiGodmodesSection = Tabs.Main:AddSection({ Name = "AntiGodmodes", Position = "left", Collapsible = true })
TogglesSection = Tabs.Main:AddSection({ Name = "toggles", Position = "left" })
invulnerabilityModesActive = false

-- ==============================================
-- Р”РћР‘РђР’Р›РЇР•Рњ GODMODE Р WALL SPAM Р’ UI
-- ==============================================

godmodeToggleLib = TogglesSection:AddToggle({
    Text = "Godmode",
    Default = false,

    Callback = function(Value)
        if Value then
            StartGodmode()
        else
            StopGodmode()
        end
    end,
})
godmodeToggleLib:ToolTip("Р”РµР»Р°РµС‚ РІР°СЃ РЅРµСѓСЏР·РІРёРјС‹Рј, СЃРїР°РјСЏ WallCombo РїРѕ РІСЃРµРј С†РµР»СЏРј")

NeverLose.Invisible = NeverLose.Invisible or { active = false, hooked = false, remote = nil, token = 0 }

local function InvisibleGetRemote()
    local ok, remotes = pcall(function() return ReplicatedStorage.Remotes.Replication end)
    if ok and remotes then
        return remotes:FindFirstChild("FullCustomReplicationUnreliable")
    end
    return nil
end

local function InvisibleInstallHook()
    if NeverLose.Invisible.hooked then return end
    local mt = getrawmetatable(game)
    if not mt or not mt.__namecall then return end
    NeverLose.Invisible.oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        if NeverLose.Invisible.active then
            if getnamecallmethod() == "FireServer" and self == NeverLose.Invisible.remote then
                return nil
            end
        end
        return NeverLose.Invisible.oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
    NeverLose.Invisible.hooked = true
end

local function InvisibleApply()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp or not hrp.Parent then return false end
    local remote = InvisibleGetRemote()
    if not remote then return false end
    NeverLose.Invisible.remote = remote
    InvisibleInstallHook()
    NeverLose.Invisible.active = false
    NeverLose.Invisible.token = NeverLose.Invisible.token + 1
    local token = NeverLose.Invisible.token
    local originalCF = hrp.CFrame
    local flyingCF = originalCF + Vector3.new(0, 50000, 0)
    for i = 1, 10 do
        if NeverLose.Invisible.token ~= token then return false end
        if not hrp.Parent then return false end
        hrp.CFrame = flyingCF
        pcall(function() remote:FireServer() end)
        task.wait(0.1)
    end
    if NeverLose.Invisible.token ~= token then return false end
    NeverLose.Invisible.active = true
    if hrp.Parent then
        hrp.CFrame = originalCF
    end
    return true
end

local function InvisibleRemove()
    NeverLose.Invisible.token = NeverLose.Invisible.token + 1
    NeverLose.Invisible.active = false
    local remote = NeverLose.Invisible.remote or InvisibleGetRemote()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if remote and hrp and hrp.Parent then
        pcall(function() remote:FireServer() end)
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if NeverLose.Invisible.active then
        task.spawn(InvisibleApply)
    end
end)

invisibleToggleLib = TogglesSection:AddToggle({
    Text = "Invisible",
    Default = false,

    Callback = function(Value)
        if Value then
            task.spawn(function()
                if not InvisibleApply() then
                    invisibleToggleLib:SetValue(false)
                end
            end)
        else
            InvisibleRemove()
        end
    end,
})
invisibleToggleLib:ToolTip("Ghost mode: sends your character 50000 studs above your real position, then blocks further position replication. You stay at your real spot locally, so your hits and abilities still work. Re-applies automatically after respawn.")

OpFunctionalSection = Tabs.Main:AddSection({ Name = "Op Functional", Position = "right" })

NeverLose.WallComboV1 = NeverLose.WallComboV1 or { active = false, bound = false, core = nil }

local function WallComboV1GetCore()
    if NeverLose.WallComboV1.core then return NeverLose.WallComboV1.core end
    local ok, mod = pcall(function() return require(ReplicatedStorage:WaitForChild("Core", 9e9)) end)
    if ok and type(mod) == "table" and type(mod.Get) == "function" then
        NeverLose.WallComboV1.core = mod
    end
    return NeverLose.WallComboV1.core
end

local function WallComboV1GetAbility()
    local charName = GetCurrentCharacter and GetCurrentCharacter() or nil
    if not charName then return nil end
    local folder = ReplicatedStorage:FindFirstChild("Characters")
    local charModel = folder and folder:FindFirstChild(charName)
    if not charModel then return nil end
    local names = { WallComboName, "WallCombo", "wall" }
    for i = 1, #names do
        if names[i] then
            local ability = charModel:FindFirstChild(names[i])
            if ability then return ability end
        end
    end
    return nil
end

local function WallComboV1IsPartnerEntry(entry)
    if type(entry) ~= "Instance" then return false end
    local model = entry
    if not model:IsA("Model") then
        model = entry:FindFirstAncestorOfClass("Model") or entry
    end
    return IsProtectedWallComboTarget(model)
end

local function WallComboV1StripPartners(list)
    if type(list) ~= "table" then return end
    for i = #list, 1, -1 do
        if WallComboV1IsPartnerEntry(list[i]) then
            table.remove(list, i)
        end
    end
end

local function WallComboV1Validate(character, part)
    if character ~= nil and WallComboV1IsPartnerEntry(character) then return false end
    if part ~= nil and WallComboV1IsPartnerEntry(part) then return false end
    return true
end

-- The old version monkeypatched the game module Combat.Hit.Process to drop
-- partner hits. That global override could leave the client-side hit/animation
-- processing stuck, which made other players look frozen while emoting and
-- sliding around. Partner / friend filtering is done without touching any game
-- module now: Wallcombo V1 and Godmode V1 use the Box CustomValidation plus
-- WallComboV1StripPartners, and the target lists are filtered up front.
NeverLose.PartnerFilter = NeverLose.PartnerFilter or { installed = false }

-- Reach of Wallcombo V1 in studs. The Box is centred on your character, so
-- the box edge is this many studs away in every direction; the box itself is
-- 2x this value. The RangeV1 slider (created with the toggle below) overrides
-- it and is stored in the config like every other slider.
WallComboV1Reach = 45

-- How often Wallcombo V1 runs Box + Activate, in activations per second.
-- The SpeedWallcombo slider (created with the RangeV1 slider below) overrides
-- it, so the speed is fps independent and can be tuned by hand. The shared
-- packet budget (WallComboNetTake) then caps the real send rate so the ping
-- stays stable at any speed.
WallComboV1Speed = 250
WallComboV1LastFire = 0
WallComboV1PrevStep = 0

local function WallComboV1SpeedNow()
    local slider = speedWallcomboSlider
    if slider and slider.GetValue then
        local ok, value = pcall(slider.GetValue, slider)
        if ok and type(value) == "number" and value > 0 then
            return value
        end
    end
    return WallComboV1Speed
end

local function WallComboV1ReachNow()
    local slider = wallComboV1RangeSlider
    if slider and slider.GetValue then
        local ok, value = pcall(slider.GetValue, slider)
        if ok and type(value) == "number" and value > 0 then
            return value
        end
    end
    return WallComboV1Reach
end

local function WallComboV1Step()
    local core = WallComboV1GetCore()
    if not core then return end
    local character = LocalPlayer.Character
    local head = character and character:FindFirstChild("Head")
    if not head then return end
    local ability = WallComboV1GetAbility()
    if not ability then return end
    local now = tick()
    local dt = now - WallComboV1PrevStep
    WallComboV1PrevStep = now
    local elapsed = now - WallComboV1LastFire
    local burst = math.floor(elapsed * WallComboV1SpeedNow())
    if burst < 1 then return end
    if burst > 8 then burst = 8 end
    if dt > 0.033 then
        burst = 1
    elseif dt > 0.02 and burst > 2 then
        burst = 2
    end
    local reach = WallComboV1ReachNow()
    local boxSize = Vector3.new(reach * 2, reach * 2, reach * 2)
    local origin = head.Position + Vector3.new(0, 0, 2.5)
    local okHit, res, resList = pcall(function()
        local combat = core.Get("Combat", "Hit")
        if not combat or type(combat.Box) ~= "function" then return nil end
        return combat.Box(nil, character, { Size = boxSize, CustomValidation = WallComboV1Validate })
    end)
    if not okHit or not res then return end
    WallComboV1StripPartners(res)
    WallComboV1StripPartners(resList)
    local okAct, activate = pcall(function()
        local abilityCore = core.Get("Combat", "Ability")
        return abilityCore and abilityCore.Activate
    end)
    if not okAct or type(activate) ~= "function" then return end
    local fired = false
    for _ = 1, burst do
        if not WallComboNetTake("v1", 2) then break end
        pcall(activate, ability, res, origin)
        fired = true
    end
    if fired then WallComboV1LastFire = now end
end

local function WallComboV1Bind()
    if NeverLose.WallComboV1.bound then return end
    RunService:BindToRenderStep("NeverLoseWallComboV1", Enum.RenderPriority.Input.Value, WallComboV1Step)
    NeverLose.WallComboV1.bound = true
end

local function WallComboV1Unbind()
    if not NeverLose.WallComboV1.bound then return end
    RunService:UnbindFromRenderStep("NeverLoseWallComboV1")
    NeverLose.WallComboV1.bound = false
end

wallComboV1Toggle = OpFunctionalSection:AddToggle({
    Text = "Wallcombo V1",
    Default = false,

    Callback = function(Value)
        NeverLose.WallComboV1.active = Value
        if Value then
            WallComboV1Bind()
        else
            WallComboV1Unbind()
        end
    end,
})
wallComboV1Toggle:ToolTip("Activates the WallCombo ability at the SpeedWallcombo rate with a hitbox sized by the RangeV1 slider below. Combine it with Wall Spam for the full combo.")

wallComboV1RangeSlider = OpFunctionalSection:AddSlider({
    Text = "RangeV1",
    Default = 45,
    Min = 10,
    Max = 150,
    Rounding = 0,
})
wallComboV1RangeSlider:ToolTip("Wallcombo V1 catch distance in studs from your character (box size = 2x this value). Saved with the config.")

speedWallcomboSlider = OpFunctionalSection:AddSlider({
    Text = "SpeedWallcombo",
    Default = 250,
    Min = 30,
    Max = 600,
    Rounding = 0,
})
speedWallcomboSlider:ToolTip("Wallcombo V1 activations per second (fps independent, up to 8 per frame, backs off automatically when the framerate drops). The V1 packet budget (500 packets/s) caps the real send rate, so the ping stays stable at any value. Saved with the config.")

NeverLose.AntiGodmode = NeverLose.AntiGodmode or { active = false, connection = nil, lastSend = 0, cacheTime = 0, targets = {} }

AntiGodmodeTargetCount = 15
AntiGodmodeSendCooldown = 0.01
AntiGodmodeCacheLifetime = 0.05

local function AntiGodmodeTargets()
    local state = NeverLose.AntiGodmode
    local now = tick()
    if now - state.cacheTime < AntiGodmodeCacheLifetime then return state.targets end
    state.cacheTime = now
    local targets = {}
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return targets end
    local localPos = root.Position
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not IsPartnerVX(player.Name) then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and IsTargetAlive(char) then
                table.insert(targets, { Target = player, Type = "player", Char = char, Distance = (localPos - hrp.Position).Magnitude })
            end
        end
    end
    local ok, npcs = pcall(GetNPCsWallSpam)
    if ok and type(npcs) == "table" then
        for _, npc in ipairs(npcs) do
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            if hrp and IsTargetAlive(npc) then
                table.insert(targets, { Target = npc, Type = "npc", Char = npc, Distance = (localPos - hrp.Position).Magnitude })
            end
        end
    end
    table.sort(targets, function(a, b) return a.Distance < b.Distance end)
    local result = {}
    for i = 1, math.min(#targets, AntiGodmodeTargetCount) do
        result[i] = targets[i]
    end
    state.targets = result
    return result
end

local function AntiGodmodeSend(target, targetType)
    if not target or IsPartnerVX(target.Name) then return end
    -- 4 combo hits x (ability + action) = 8 packets per target.
    if not WallComboNetTake("antigod", 8) then return end
    local targetChar = (targetType == "player") and target.Character or target
    if not targetChar or not IsTargetAlive(targetChar) then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    local wc = GetWallCombo()
    if not wc then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local charName = GetCharName()
    local remotes = GetRemotes()
    if not remotes.ability or not remotes.action then return end
    local baseId = math.random(100000, 999999)
    local targetName = target.Name
    local serverTime = tick()
    local rootCFrame = root.CFrame
    for i = 1, 4 do
        if not IsTargetAlive(targetChar) then break end
        pcall(function()
            local actionId = baseId + i
            remotes.ability:FireServer(wc, actionId)
            remotes.action:FireServer(wc, "Characters:"..charName..":WallCombo", i, actionId,
                {
                    HitboxCFrames = {targetRoot.CFrame, targetRoot.CFrame, targetRoot.CFrame},
                    BestHitCharacter = targetChar,
                    HitCharacters = {targetChar, targetChar, targetChar},
                    Ignore = {},
                    DeathInfo = {},
                    BlockedCharacters = {},
                    HitInfo = { IsFacing = true, IsInFront = true, Blocked = false, GetUp = true },
                    Actions = {
                        ["A"..i.."_"..tostring(actionId)] = {
                            [targetName] = {
                                Animation = i <= 2 and "Punch1Hit" or "Punch2Hit",
                                Preset = "Punch",
                                Velocity = Vector3.new(0, 80 * i, 0),
                                ImpulseVelocity = Vector3.new(0, 150 * i, 0),
                                Duration = 0.2,
                                FromPosition = targetRoot.Position,
                                Seed = math.random(1, 999999),
                            }
                        }
                    },
                    ServerTime = serverTime,
                    FromCFrame = rootCFrame
                },
                "Action"..math.random(1000, 9999),
                0
            )
        end)
    end
end

local function AntiGodmodeStep()
    local state = NeverLose.AntiGodmode
    if not state.active then return end
    local now = tick()
    if now - state.lastSend < AntiGodmodeSendCooldown then return end
    state.lastSend = now
    local targets = AntiGodmodeTargets()
    for _, entry in ipairs(targets) do
        if not state.active then break end
        AntiGodmodeSend(entry.Target, entry.Type)
    end
end

local function AntiGodmodeBind()
    if NeverLose.AntiGodmode.connection then return end
    NeverLose.AntiGodmode.connection = RunService.Heartbeat:Connect(AntiGodmodeStep)
end

local function AntiGodmodeUnbind()
    local state = NeverLose.AntiGodmode
    if state.connection then
        state.connection:Disconnect()
        state.connection = nil
    end
end

antiGodmodeToggle = AntiGodmodesSection:AddToggle({
    Text = "Anti-Godmode",
    Default = false,

    Callback = function(Value)
        local state = NeverLose.AntiGodmode
        state.active = Value
        if Value then
            state.lastSend = 0
            state.cacheTime = 0
            AntiGodmodeBind()
        else
            AntiGodmodeUnbind()
        end
    end,
})
NeverLose.AntiGodmodeV2 = NeverLose.AntiGodmodeV2 or { active = false, connections = {}, lastDash = 0 }

AntiGodmodeV2DashInterval = 1
AntiGodmodeV2Threads = 12
AntiGodmodeV2Wait = 0.02

local function AntiGodmodeV2Target()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest = nil
    local best = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and not IsPartnerVX(player.Name) then
            local char = player.Character
            local hum = char:FindFirstChild("Humanoid")
            local tRoot = char:FindFirstChild("HumanoidRootPart")
            if hum and tRoot and IsTargetAlive(char) then
                local d = (tRoot.Position - root.Position).Magnitude
                if d < best then best = d; closest = player end
            end
        end
    end
    return closest
end

local function AntiGodmodeV2Attack()
    local state = NeverLose.AntiGodmodeV2
    if not state.active then return end
    -- Dash + ability + action = up to 3 packets per hit; the whole attack is
    -- skipped while the budget is empty, which also skips the CPU work.
    if not WallComboNetTake("antigodv2", 2) then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local target = AntiGodmodeV2Target()
    if not target or not target.Character then return end
    local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not tRoot then return end
    local charName = GetCharName()
    local wc = GetWallCombo()
    local remotes = GetRemotes()
    if not charName or not wc or not remotes.ability or not remotes.action then return end
    local now = tick()
    if now - state.lastDash > AntiGodmodeV2DashInterval then
        state.lastDash = now
        pcall(function()
            local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
            local characterFolder = remotesFolder and remotesFolder:FindFirstChild("Character")
            local dash = characterFolder and characterFolder:FindFirstChild("Dash")
            if dash then
                dash:FireServer(root.CFrame, "L", root.CFrame.LookVector, nil, tick())
            end
        end)
    end
    pcall(function()
        remotes.ability:FireServer(wc, 1, {}, tRoot.Position)
        remotes.action:FireServer(wc, charName .. ":WallCombo", 2, 1,
            {
                HitboxCFrames = { tRoot.CFrame, tRoot.CFrame },
                BestHitCharacter = target.Character,
                HitCharacters = { target.Character },
                Ignore = {},
                DeathInfo = {},
                BlockedCharacters = {},
                HitInfo = { IsFacing = false, IsInFront = true },
                ServerTime = os.time(),
                Actions = {
                    ActionNumber1 = {
                        [target.Name] = {
                            StartCFrameStr = tostring(root.CFrame),
                            Local = true,
                            Collision = false,
                            Animation = "Punch1Hit",
                            Preset = "Punch",
                            Velocity = Vector3.zero,
                            FromPosition = tRoot.Position,
                            Seed = math.random(1, 999999),
                        }
                    }
                },
                FromCFrame = tRoot.CFrame
            },
            "Action152",
            0
        )
    end)
end

local function AntiGodmodeV2Bind()
    local state = NeverLose.AntiGodmodeV2
    if #state.connections > 0 then return end
    for _ = 1, AntiGodmodeV2Threads do
        table.insert(state.connections, RunService.Heartbeat:Connect(function()
            task.wait(AntiGodmodeV2Wait)
            pcall(AntiGodmodeV2Attack)
        end))
    end
end

local function AntiGodmodeV2Unbind()
    local state = NeverLose.AntiGodmodeV2
    for _, connection in ipairs(state.connections) do
        pcall(function() connection:Disconnect() end)
    end
    state.connections = {}
end

antiGodmodeV2Toggle = AntiGodmodesSection:AddToggle({
    Text = "AntigodmodeV2",
    Default = false,

    Callback = function(Value)
        local state = NeverLose.AntiGodmodeV2
        state.active = Value
        if Value then
            state.lastDash = 0
            AntiGodmodeV2Bind()
        else
            AntiGodmodeV2Unbind()
        end
    end,
})
NeverLose.GodmodeV3 = NeverLose.GodmodeV3 or { active = false, closestThread = nil, selfThread = nil }

GodmodeV3ClosestDelay = 0.03
GodmodeV3SelfDelay = 0.01

local function GodmodeV3ClosestLoop()
    while NeverLose.GodmodeV3.active do
        task.wait(GodmodeV3ClosestDelay)
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local target = nil
        local best = math.huge
        for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and not IsPartnerVX(player.Name) then
                local char = player.Character
                local hum = char:FindFirstChild("Humanoid")
                local charRoot = char:FindFirstChild("HumanoidRootPart")
                if hum and charRoot and IsTargetAlive(char) then
                    local d = (charRoot.Position - root.Position).Magnitude
                    if d < best then best = d; target = player end
                end
            end
        end
        if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then continue end
        if not WallComboNetTake("godv3", 2) then continue end
        local charName = GetCharName()
        local wc = GetWallCombo()
        local remotes = GetRemotes()
        if not charName or not wc or not remotes.ability or not remotes.action then continue end
        local targetChar = target.Character
        local targetRoot = targetChar.HumanoidRootPart
        pcall(function()
            remotes.ability:FireServer(wc, 33036, nil, targetChar, targetRoot.Position)
            remotes.action:FireServer(wc, "Characters:"..charName..":WallCombo", 1, 33036, {
                HitboxCFrames = {},
                BestHitCharacter = targetChar,
                HitCharacters = { targetChar },
                Ignore = {},
                DeathInfo = {},
                Actions = {},
                HitInfo = { IsFacing = true, IsInFront = true },
                BlockedCharacters = {},
                ServerTime = os.clock(),
                FromCFrame = root.CFrame
            }, "Action651", 0)
        end)
    end
end

local function GodmodeV3SelfLoop()
    while NeverLose.GodmodeV3.active do
        task.wait(GodmodeV3SelfDelay)
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local charName = GetCharName()
            local wc = GetWallCombo()
            if not charName or not wc then return end
            local remotes = GetRemotes()
            if not remotes.ability or not remotes.action then return end
            if not WallComboNetTake("godv3", 2) then return end
            local actionId = "Action" .. math.random(1000, 9999)
            local randomId = math.random(100000, 999999)
            remotes.ability:FireServer(wc, randomId)
            remotes.action:FireServer(wc, "Characters:" .. charName .. ":WallCombo", 1, randomId, {
                HitboxCFrames = { nil },
                BestHitCharacter = char,
                HitCharacters = { char },
                Ignore = { [actionId] = { char } },
                DeathInfo = {},
                Actions = { [actionId] = {} },
                HitInfo = { Blocked = false, IsFacing = true, IsInFront = true },
                BlockedCharacters = {},
                ServerTime = tick(),
                FromCFrame = nil
            }, actionId)
        end)
    end
end

local function GodmodeV3Start()
    if NeverLose.GodmodeV3.closestThread then return end
    NeverLose.GodmodeV3.active = true
    NeverLose.GodmodeV3.closestThread = task.spawn(GodmodeV3ClosestLoop)
    NeverLose.GodmodeV3.selfThread = task.spawn(GodmodeV3SelfLoop)
end

local function GodmodeV3Stop()
    NeverLose.GodmodeV3.active = false
    if NeverLose.GodmodeV3.closestThread then task.cancel(NeverLose.GodmodeV3.closestThread); NeverLose.GodmodeV3.closestThread = nil end
    if NeverLose.GodmodeV3.selfThread then task.cancel(NeverLose.GodmodeV3.selfThread); NeverLose.GodmodeV3.selfThread = nil end
end

godmodeV3Toggle = AntiGodmodesSection:AddToggle({
    Text = "GodmodeV3",
    Default = false,

    Callback = function(Value)
        if Value then
            GodmodeV3Start()
        else
            GodmodeV3Stop()
        end
    end,
})

godmodeV3ClosestSlider = AntiGodmodesSection:AddSlider({
    Text = "GodmodeV3 Closest Delay",
    Default = 0.03,
    Min = 0.005,
    Max = 0.2,
    Rounding = 3,
    Callback = function(Value)
        GodmodeV3ClosestDelay = Value
    end,
})

godmodeV3SelfSlider = AntiGodmodesSection:AddSlider({
    Text = "GodmodeV3 Self Delay",
    Default = 0.01,
    Min = 0.005,
    Max = 0.2,
    Rounding = 3,
    Callback = function(Value)
        GodmodeV3SelfDelay = Value
    end,
})

NeverLose.KillAuraV2 = NeverLose.KillAuraV2 or { active = false, connections = {}, lastDash = 0 }

KillAuraV2DashInterval = 0.7
KillAuraV2Threads = 9
KillAuraV2Wait = 0.02

local function KillAuraV2Target()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest = nil
    local best = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not IsPartnerVX(player.Name) then
            local char = player.Character
            local hum = char:FindFirstChild("Humanoid")
            local tRoot = char:FindFirstChild("HumanoidRootPart")
            if hum and tRoot and IsTargetAlive(char) then
                local d = (tRoot.Position - root.Position).Magnitude
                if d < best then best = d; closest = player end
            end
        end
    end
    return closest
end

local function KillAuraV2Attack()
    local state = NeverLose.KillAuraV2
    if not state.active then return end
    if not WallComboNetTake("killaurav2", 3) then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local target = KillAuraV2Target()
    if not target or not target.Character then return end
    local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not tRoot then return end
    local charName = GetCharName()
    local wc = GetWallCombo()
    local remotes = GetRemotes()
    if not charName or not wc or not remotes.ability or not remotes.action then return end
    local now = tick()
    if now - state.lastDash > KillAuraV2DashInterval then
        state.lastDash = now
        pcall(function()
            local charRemotes = ReplicatedStorage:FindFirstChild("Remotes")
            local characterRemotes = charRemotes and charRemotes:FindFirstChild("Character")
            local dash = characterRemotes and characterRemotes:FindFirstChild("Dash")
            if dash then dash:FireServer(root.CFrame, "L", root.CFrame.LookVector, nil, tick()) end
        end)
    end
    pcall(function() remotes.ability:FireServer(wc, 1, {}, tRoot.Position) end)
    pcall(function()
        remotes.action:FireServer(wc, charName .. ":WallCombo", 2, 1, {
            HitboxCFrames = { tRoot.CFrame, tRoot.CFrame },
            BestHitCharacter = target.Character,
            HitCharacters = { target.Character },
            Ignore = {}, DeathInfo = {}, BlockedCharacters = {},
            HitInfo = { IsFacing = false, IsInFront = true },
            ServerTime = os.time(),
            Actions = {
                ActionNumber1 = {
                    [target.Name] = {
                        StartCFrameStr = tostring(root.CFrame),
                        Local = true,
                        Collision = false,
                        Animation = "Punch1Hit",
                        Preset = "Punch",
                        Velocity = Vector3.zero,
                        FromPosition = tRoot.Position,
                        Seed = math.random(1, 999999),
                    }
                }
            },
            FromCFrame = tRoot.CFrame
        }, "Action151", 0)
    end)
end

local function KillAuraV2Bind()
    local state = NeverLose.KillAuraV2
    if #state.connections > 0 then return end
    for _ = 1, KillAuraV2Threads do
        table.insert(state.connections, RunService.Heartbeat:Connect(function()
            task.wait(KillAuraV2Wait)
            pcall(KillAuraV2Attack)
        end))
    end
end

local function KillAuraV2Unbind()
    local state = NeverLose.KillAuraV2
    for _, c in ipairs(state.connections) do
        pcall(function() c:Disconnect() end)
    end
    state.connections = {}
end

killAuraV2Toggle = AntiGodmodesSection:AddToggle({
    Text = "Kill Aura V2",
    Default = false,

    Callback = function(Value)
        local state = NeverLose.KillAuraV2
        state.active = Value
        if Value then
            KillAuraV2Bind()
        else
            KillAuraV2Unbind()
        end
    end,
})

NeverLose.GodmodeV1 = NeverLose.GodmodeV1 or { active = false, bound = false }

GodmodeV1BoxSize = Vector3.new(5000, 5000, 5000)

local function GodmodeV1Step()
    local core = WallComboV1GetCore()
    if not core then return end
    local character = LocalPlayer.Character
    local head = character and character:FindFirstChild("Head")
    if not head then return end
    local ability = WallComboV1GetAbility()
    if not ability then return end
    local okHit, res, resList = pcall(function()
        local combat = core.Get("Combat", "Hit")
        if not combat or type(combat.Box) ~= "function" then return nil end
        return combat.Box(nil, character, { Size = GodmodeV1BoxSize, CustomValidation = WallComboV1Validate })
    end)
    if not okHit or not res then return end
    WallComboV1StripPartners(res)
    WallComboV1StripPartners(resList)
    local okAct, activate = pcall(function()
        local abilityCore = core.Get("Combat", "Ability")
        return abilityCore and abilityCore.Activate
    end)
    if not okAct or type(activate) ~= "function" then return end
    pcall(activate, ability, res, head.Position + Vector3.new(0, 0, 2.5))
end

local function GodmodeV1Bind()
    if NeverLose.GodmodeV1.bound then return end
    RunService:BindToRenderStep("NeverLoseGodmodeV1", Enum.RenderPriority.Input.Value, GodmodeV1Step)
    NeverLose.GodmodeV1.bound = true
end

local function GodmodeV1Unbind()
    if not NeverLose.GodmodeV1.bound then return end
    RunService:UnbindFromRenderStep("NeverLoseGodmodeV1")
    NeverLose.GodmodeV1.bound = false
end

godmodeV1Toggle = OpFunctionalSection:AddToggle({
    Text = "Godmode V1",
    Default = false,

    Callback = function(Value)
        NeverLose.GodmodeV1.active = Value
        if Value then
            GodmodeV1Bind()
        else
            GodmodeV1Unbind()
        end
    end,
})
godmodeV1Toggle:ToolTip("Same godmode as the Combat tab, but it uses the real WallCombo ability every frame with a 5000x5000x5000 hitbox, so your own WallCombo stays visible instead of being hidden like the old payload version.")

NeverLose.InstantReset = NeverLose.InstantReset or { active = false, respawnCF = nil, pending = false }
local InstantResetRespawnConn = nil

local function InstantResetCapture()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        NeverLose.InstantReset.respawnCF = hrp.CFrame
    else
        pcall(function()
            NeverLose.InstantReset.respawnCF = char:GetPivot()
        end)
    end
end

local function InstantResetDoRespawn()
    local state = NeverLose.InstantReset
    InstantResetCapture()
    if state.pending or not state.active then return end
    state.pending = true
    local dyingChar = LocalPlayer.Character
    task.wait(0.25)
    if not state.active then
        state.pending = false
        return
    end
    pcall(function()
        LocalPlayer:LoadCharacter()
    end)
    task.delay(5, function()
        state.pending = false
    end)
    task.spawn(function()
        for _ = 1, 10 do
            task.wait(0.3)
            if not state.active or LocalPlayer.Character ~= dyingChar then break end
            pcall(function()
                LocalPlayer:LoadCharacter()
            end)
        end
        state.pending = false
    end)
end

local function InstantResetOnCharacter(character)
    local state = NeverLose.InstantReset
    if not state.active or not character then return end
    state.pending = false
    local cf = state.respawnCF
    if cf then
        task.spawn(function()
            local hrp = character:WaitForChild("HumanoidRootPart", 5)
            if not hrp then return end
            task.wait(0.15)
            if not character.Parent or not state.active then return end
            pcall(function()
                local fcr = require(LocalPlayer.PlayerScripts.Character.FullCustomReplication)
                if fcr and fcr.Override then
                    fcr.Override(character, cf)
                end
            end)
            task.wait()
            if character.Parent and state.active then
                pcall(function()
                    local fcr = require(LocalPlayer.PlayerScripts.Character.FullCustomReplication)
                    if fcr and fcr.Override then
                        fcr.Override(character, cf)
                    end
                end)
            end
        end)
    end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then
        pcall(function() hum = character:WaitForChild("Humanoid", 5) end)
    end
    if not hum or hum:GetAttribute("IRHooked") then return end
    hum:SetAttribute("IRHooked", true)
    hum.Died:Once(function()
        InstantResetDoRespawn()
    end)
    pcall(function()
        hum.StateChanged:Connect(function(_, newState)
            if not state.active then return end
            if newState == Enum.HumanoidStateType.Dead then
                InstantResetDoRespawn()
            end
        end)
    end)
    pcall(function()
        hum:GetAttributeChangedSignal("Health"):Connect(function()
            if not state.active then return end
            local hp = hum:GetAttribute("Health")
            if hp and hp <= 0 then
                InstantResetDoRespawn()
            end
        end)
    end)
    pcall(function()
        hum:GetPropertyChangedSignal("Health"):Connect(function()
            if not state.active then return end
            if hum.Health <= 0 then
                InstantResetDoRespawn()
            end
        end)
    end)
end

local function InstantResetStart()
    local state = NeverLose.InstantReset
    if state.active then return end
    state.active = true
    state.pending = false
    state.respawnCF = nil
    InstantResetRespawnConn = LocalPlayer.CharacterAdded:Connect(function(ch)
        InstantResetOnCharacter(ch)
    end)
    if LocalPlayer.Character then
        task.spawn(function()
            InstantResetOnCharacter(LocalPlayer.Character)
        end)
    end
end

local function InstantResetStop()
    local state = NeverLose.InstantReset
    state.active = false
    state.pending = false
    if InstantResetRespawnConn then
        InstantResetRespawnConn:Disconnect()
        InstantResetRespawnConn = nil
    end
end

instantResetToggleLib = OpFunctionalSection:AddToggle({
    Text = "Instant Reset",
    Default = false,
    Callback = function(Value)
        if Value then
            InstantResetStart()
        else
            InstantResetStop()
        end
    end,
})
instantResetToggleLib:ToolTip("Respawns you the moment you die and puts you back on the exact spot where you died")

wallSpamToggleLib = TogglesSection:AddToggle({
    Text = "Wall Spam",
    Default = false,

    Callback = function(Value)
        if Value then
            StartWallSpam()
        else
            StopWallSpam()
        end
    end,
})
wallSpamToggleLib:ToolTip("РЎРїР°РјРёС‚ WallCombo РїРѕ РІСЃРµРј РёРіСЂРѕРєР°Рј Рё NPC СЃ РјР°РєСЃРёРјР°Р»СЊРЅРѕР№ СЃРєРѕСЂРѕСЃС‚СЊСЋ")

auraV2ToggleLib = TogglesSection:AddToggle({
    Text = "AuraV2",
    Default = false,

    Callback = function(Value)
        if Value then
            StartAuraV2()
        else
            StopAuraV2()
        end
    end,
})
auraV2ToggleLib:ToolTip("РљРёР»Р»Р°СѓСЂР° СЂР°РґРёСѓСЃ 500: Р±РѕРєРѕРІС‹Рµ РґРµС€Рё + СѓРґР°СЂС‹ + РЈР›Р¬РўРђ РїРѕ С†РµР»СЏРј (СѓР»СЊС‚Р° РїСЂРѕР±РёРІР°РµС‚ GodMode)")

hideWallcomboToggleLib = TogglesSection:AddToggle({
    Text = "Hide Wallcombo",
    Default = false,

    Callback = function(Value)
        if Value then
            -- РСЃРїСЂР°РІР»РµРЅРёРµ: РїСЂРѕРІРµСЂСЏРµРј СЃСѓС‰РµСЃС‚РІРѕРІР°РЅРёРµ РїРµСЂСЃРѕРЅР°Р¶РµР№
            local chars = ReplicatedStorage:FindFirstChild("Characters")
            if chars then
                for _, char in pairs(chars:GetChildren()) do
                    renameObject(char, "WallCombo", "wall")
                end
            end
            WallComboName = "wall"
        else
            local chars = ReplicatedStorage:FindFirstChild("Characters")
            if chars then
                for _, char in pairs(chars:GetChildren()) do
                    renameObject(char, "wall", "WallCombo")
                end
            end
            WallComboName = "WallCombo"
        end
    end,
})
hideWallcomboToggleLib:ToolTip("Hides your WallCombo from everyone")

invuln1ToggleLib = TogglesSection:AddToggle({
    Text = "invulnerability method 1",
    Default = false,

    Callback = function(Value)
        if Value then
            startsinvulnerabilityMode()
        else
            stopsinvulnerabilityMode()
        end
    end,
})
invuln1ToggleLib:ToolTip("grabs all dummys")

function startsinvulnerabilityMode()
    if invulnerabilityModesActive then return end
    invulnerabilityModesActive = true
    task.spawn(function()
        while invulnerabilityModesActive do
            wallcombodummy("The Ultimate Bum")
            wallcombodummy("Blocking Bum")
            wallcombodummy("Attacking Bum")
            task.wait(0.01)
        end
    end)
end

function stopsinvulnerabilityMode()
    invulnerabilityModesActive = false
end

function wallcombodummy(Target)
    local function findUltimateBum()
        local characters = Workspace:FindFirstChild("Characters")
        if not characters then return nil end
        local npcs = characters:FindFirstChild("NPCs")
        if not npcs then return nil end
        local ultimateBum = npcs:FindFirstChild(Target)
        if ultimateBum and ultimateBum:IsA("Model") then
            return ultimateBum
        end
        return nil
    end

    local charName = GetCurrentCharacter()
    if not charName then return false end
    -- РСЃРїСЂР°РІР»РµРЅРёРµ: РїСЂРѕРІРµСЂСЏРµРј СЃСѓС‰РµСЃС‚РІРѕРІР°РЅРёРµ РїР°РїРєРё РїРµСЂСЃРѕРЅР°Р¶Р°
    local charFolder = ReplicatedStorage:FindFirstChild("Characters") and ReplicatedStorage.Characters:FindFirstChild(charName)
    if not charFolder then return false end
    local wallComboAbility = charFolder:FindFirstChild(WallComboName)
    if not wallComboAbility then 
        return false
    end
    local ultimateBum = findUltimateBum()
    if ultimateBum == nil then 
        return false
    end
    local actionNumber = generateActionNumber()
    local serverTime = getServerTime()
    local randomId = math.random(100000, 999999)
    local remoteArgs = {
        wallComboAbility,
        "Characters:" .. charName .. ":" .. WallComboName,
        1,
        randomId,
        {
            HitboxCFrames = {nil},
            BestHitCharacter = ultimateBum,
            HitCharacters = {ultimateBum},
            Ignore = {[actionNumber] = {ultimateBum}},
            DeathInfo = {},
            Actions = {[actionNumber] = {}},
            HitInfo = {
                Blocked = false,
                IsFacing = true,
                IsInFront = true
            },
            BlockedCharacters = {},
            ServerTime = serverTime,
            FromCFrame = nil
        },
        "Action" .. math.random(1000, 9999)
    }
    pcall(function()
        ReplicatedStorage.Remotes.Abilities.Ability:FireServer(wallComboAbility, randomId)
    end)
    pcall(function()
        ReplicatedStorage.Remotes.Combat.Action:FireServer(unpack(remoteArgs))
    end)
    return true
end

invulnerabilityMode2loop = false
invulnerabilityMode2connection = nil

function invulnerabilityMode2start()
    if invulnerabilityMode2connection then return end
    invulnerabilityMode2loop = true
    invulnerabilityMode2connection = RunService.Heartbeat:Connect(function()
        if not invulnerabilityMode2loop then
            if invulnerabilityMode2connection then
                invulnerabilityMode2connection:Disconnect()
                invulnerabilityMode2connection = nil
            end
            return
        end
        task.spawn(function()
            for i = 1,10 * 4 do
               fullcustom3(-9e9,90000,9e9)
            end
        end)
    end)
end

function invulnerabilityMode2stop()
    invulnerabilityMode2loop = false
    if invulnerabilityMode2connection then
        invulnerabilityMode2connection:Disconnect()
        invulnerabilityMode2connection = nil
    end
end

function fullcustom3(X,Y,Z)
    local hrp = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
    if not hrp then return end
    local targetCF = hrp.CFrame
    local servertime = workspace:GetServerTimeNow()
    local args = {
        servertime,
        targetCF + Vector3.new(X,Y,Z),
        false,
        nil,
        [5] = game:GetService("Players").LocalPlayer.Character
    }
    ReplicatedStorage.Remotes.Replication.FullCustomReplicationUnreliable:FireServer(unpack(args, 1, 5))
end

invuln2ToggleLib = TogglesSection:AddToggle({
    Text = "invulnerability method 2",
    Default = false,

    Callback = function(Value)
        if Value then
            invulnerabilityMode2start()
            if serverbullyingtoggle then
                serverbullyingtoggle:SetVisible(false)
            end
        else
            invulnerabilityMode2stop()
            if serverbullyingtoggle then
                serverbullyingtoggle:SetVisible(true)
            end
        end
    end,
})
invuln2ToggleLib:ToolTip("Makes you mostly unable to be hit")

DuelCombatSection = Tabs.DuelCombat:AddSection({ Name = "DuelCombat", Position = "left" })

duelGodmodeToggleLib = DuelCombatSection:AddToggle({
    Text = "Infinite Lives (Duel)",
    Default = false,

    Callback = function(Value)
        if Value then
            StartDuelGodmode()
        else
            StopDuelGodmode()
        end
    end,
})
duelGodmodeToggleLib:ToolTip("Anti-death: keeps HP / Health attribute and rank lives maxed so you stop losing lives in duels")

Killfarmloop = false
Killfarmconnection = nil

function killFarmstart()
    if Killfarmconnection then return end
    Killfarmloop = true
    local Targetnumber = 1
    local processingAttack = false
    local deadBlacklist = {} 
    Killfarmconnection = RunService.Heartbeat:Connect(function()
        if not Killfarmloop or processingAttack then return end
        local targets = TargetSystem_GetPlayerNames()
        removePartners(targets)
        local alivetargets = excludeDeadPlayers(targets)
        local strictlyAliveTargets = {}
        for _, name in ipairs(alivetargets) do
            if not deadBlacklist[name] then
                table.insert(strictlyAliveTargets, name)
            end
        end
        local targetsnumber = #strictlyAliveTargets
        if targetsnumber == 0 then 
            Targetnumber = 1
            return 
        end 
        if Targetnumber > targetsnumber then
            Targetnumber = 1
        end
        local targetName = strictlyAliveTargets[Targetnumber]
        local target = Players:FindFirstChild(targetName)
        local isTargetAlive = false
        if target and target.Character then
            local th = target.Character:FindFirstChild("Humanoid")
            if th then
                local hp = th:GetAttribute("Health") or th.Health
                if hp > 0 then
                    isTargetAlive = true
                end
            end
        end
        if isTargetAlive then
            processingAttack = true
            fullcustom(target, 0)
            task.wait()
            adminAbuseWallcombo(target, 2)
            Targetnumber = Targetnumber + 1
            processingAttack = false
        else
            deadBlacklist[targetName] = true
            task.delay(3, function()
                deadBlacklist[targetName] = nil
            end)
            Targetnumber = Targetnumber + 1
            if Targetnumber > targetsnumber then
                Targetnumber = 1
            end
        end
    end)
end
		
function killFarmstop()
    if Killfarmconnection then
        Killfarmconnection:Disconnect()
        Killfarmconnection = nil
    end
    Killfarmloop = false
end

killFarmToggleLib = TogglesSection:AddToggle({
    Text = "Kill Farm[Beta]",
    Default = false,

    Callback = function(Value)
        if Value then
            killFarmstart()
        else
            killFarmstop()
        end
    end,
})
killFarmToggleLib:ToolTip("farms kills")

TargetSystemSection = Tabs.Main:AddSection({ Name = "TargetSystem", Position = "right" })
TargetSystemDropdown = TargetSystemSection:AddDropdown({
    Text = "Target",
    Values = TargetSystem_GetPlayerNames(),
    Default = nil,
    Multi = false,
})

task.spawn(function()
    while true do
        local updatedNames = TargetSystem_GetPlayerNames()
        TargetSystemDropdown:SetValues(updatedNames)
        task.wait(1)
    end
end)

localPlayerCFrame = CFrame.new()

function SetlocalPlayerCFrame()
    local p = LocalPlayer
    local q = p and p.Character and p.Character.HumanoidRootPart and p.Character.HumanoidRootPart.CFrame or CFrame.new()
    localPlayerCFrame = q + Vector3.new(0,20,0)
end

function GetTargetCFrame(Target)
    local p = Target
    local q = p and p.Character and p.Character.HumanoidRootPart and p.Character.HumanoidRootPart.CFrame or CFrame.new()
    return q
end

function fullcustom(Target,Y)
    local targetCF = GetTargetCFrame(Target)
    local servertime = workspace:GetServerTimeNow()
    local args = {
        servertime,
        targetCF + Vector3.new(0,Y,0),
        false,
        nil,
        [5] = LocalPlayer.Character
    }
    ReplicatedStorage.Remotes.Replication.FullCustomReplicationUnreliable:FireServer(unpack(args, 1, 5))
end

function fullcustom2()
    local targetCF = localPlayerCFrame
    local servertime = workspace:GetServerTimeNow()
    local args = {
        servertime,
        targetCF,
        false,
        nil,
        [5] = LocalPlayer.Character
    }
    ReplicatedStorage.Remotes.Replication.FullCustomReplicationUnreliable:FireServer(unpack(args, 1, 5))
end

function TargetsystemKillAura(Target)
    local charName = GetCurrentCharacter()
    local target = Target
    if not target then return end
    if IsProtectedWallComboTarget(target) then return end
    local actionNumber = generateActionNumber()
    local randomId = math.random(100000, 999999)
    local targetChar = target.Character
    local th = target.Character:FindFirstChild("Humanoid")
    if th then
        local hp = th:GetAttribute("Health")
        if hp > 0 then
            pcall(function() SetlocalPlayerCFrame() end)
            task.wait()
            pcall(function() fullcustom(Target,0) end)
            task.wait()
            pcall(function()
                local targetCF = GetTargetCFrame(Target)
                local servertime = getServerTime()
                -- РСЃРїСЂР°РІР»РµРЅРёРµ: РїСЂРѕРІРµСЂСЏРµРј СЃСѓС‰РµСЃС‚РІРѕРІР°РЅРёРµ РїР°РїРєРё РїРµСЂСЃРѕРЅР°Р¶Р°
                local charFolder = ReplicatedStorage:FindFirstChild("Characters") and ReplicatedStorage.Characters:FindFirstChild(charName)
                if not charFolder then return end
                local ability = charFolder:FindFirstChild(WallComboName)
                if not ability then return end
                local remoteArgs = {
                    ability,
                    "Characters:" .. charName .. ":" .. WallComboName,
                    2,
                    randomId,
                    {
                        HitboxCFrames = {targetCF,targetCF,targetCF,targetCF,targetCF,targetCF},
                        BestHitCharacter = targetChar,
                        HitCharacters = {targetChar,targetChar,targetChar},
                        Ignore = {},
                        DeathInfo = {},
                        BlockedCharacters = {},
                        HitInfo = {
                            IsFacing = true,
                            IsInFront = true
                        },
                        ServerTime = servertime,
                        Actions = {},
                        FromCFrame = targetCF
                    },
                    actionNumber,
                    0
                }
                pcall(function()
                    ReplicatedStorage.Remotes.Abilities.Ability:FireServer(ability, randomId)
                end)
                pcall(function()
                    ReplicatedStorage.Remotes.Combat.Action:FireServer(unpack(remoteArgs))
                end)
            end)
            task.wait()
            pcall(function() fullcustom2() end)
        end
    end
end

function TargetSystemwallcombo(Target)
    local charName = GetCurrentCharacter()
    local target = Target
    if not target then return end
    if IsProtectedWallComboTarget(target) then return end
    local actionNumber = generateActionNumber()
    local randomId = math.random(100000, 999999)
    local th = target.Character:FindFirstChild("Humanoid")
    if th then
        local hp = th:GetAttribute("Health")
        if hp <= 0 then
            pcall(function() SetlocalPlayerCFrame() end)
            task.wait()
            pcall(function() fullcustom(Target,20) end)
            task.wait()
            local servertime = getServerTime()
            -- РСЃРїСЂР°РІР»РµРЅРёРµ: РїСЂРѕРІРµСЂСЏРµРј СЃСѓС‰РµСЃС‚РІРѕРІР°РЅРёРµ РїР°РїРєРё РїРµСЂСЃРѕРЅР°Р¶Р°
            local charFolder = ReplicatedStorage:FindFirstChild("Characters") and ReplicatedStorage.Characters:FindFirstChild(charName)
            if not charFolder then return end
            local ability = charFolder:FindFirstChild(WallComboName)
            if not ability then return end
            local remoteArgs = {
                ability,
                "Characters:" .. charName .. ":" .. WallComboName,
                1,
                randomId,
                {
                    HitboxCFrames = {nil},
                    BestHitCharacter = target.Character,
                    HitCharacters = {target.Character},
                    Ignore = {[actionNumber] = {target.Character}},
                    DeathInfo = {},
                    Actions = {[actionNumber] = {}},
                    HitInfo = {
                        Blocked = false,
                        IsFacing = true,
                        IsInFront = true
                    },
                    BlockedCharacters = {},
                    ServerTime = servertime,
                    FromCFrame = nil
                },
                actionNumber
            }
            pcall(function()
                ReplicatedStorage.Remotes.Abilities.Ability:FireServer(ability, randomId)
            end)
            pcall(function()
                ReplicatedStorage.Remotes.Combat.Action:FireServer(unpack(remoteArgs))
            end)
            task.wait()
            pcall(function() fullcustom2() end)
        end
    end
end

function UseAbilitiesTargetSystem(Target,Ability,Number)
    local charName = GetCurrentCharacter()
    local target = Target
    if not target then return end
    if IsProtectedWallComboTarget(target) then return end
    local targetChar = target.Character
    local targetCF = GetTargetCFrame(Target)
    local th = target.Character:FindFirstChild("Humanoid")
    if th then
        local hp = th:GetAttribute("Health")
        if hp > 0 then
            pcall(function() SetlocalPlayerCFrame() end)
            task.wait()
            pcall(function() fullcustom(Target,0) end)
            task.wait()
            pcall(function()
                local ability = GetCharacterAbility(charName,Ability,Number)
                if not ability then return end
                ReplicatedStorage.Remotes.Abilities.Ability:FireServer(ability,9000000)
                local servertime = workspace:GetServerTimeNow()
                local actions = {377,380,383,384,385,387,389}
                for i=1,7 do
                    local args = {
                        ability,
                        charName..":"..Ability..":"..Number,
                        i,
                        9000000,
                        {
                            HitboxCFrames = {targetCF,targetCF},
                            BestHitCharacter = targetChar,
                            HitCharacters = {targetChar},
                            Ignore = i>2 and {ActionNumber1={targetChar}} or {},
                            DeathInfo = {},
                            BlockedCharacters = {},
                            HitInfo = {
                                IsFacing = not (i==1 or i==2),
                                IsInFront = i<=2,
                                Blocked = i>2 and false or nil
                            },
                            ServerTime = servertime,
                            Actions = i>2 and {ActionNumber1={}} or {},
                            FromCFrame = targetCF
                        },
                        "Action"..actions[i],
                        i==2 and 0.1 or nil
                    }
                    if i==7 then
                        args[5].RockCFrame = targetCF
                        args[5].Actions = {
                            ActionNumber1 = {
                                [target.Name] = {
                                    StartCFrameStr = tostring(targetCF.X)..","..tostring(targetCF.Y)..","..tostring(targetCF.Z)..",0,0,0,0,0,0,0,0,0",
                                    ImpulseVelocity = Vector3.new(1901,-25000,291),
                                    AbilityName = "4",
                                    RotVelocityStr = "0,0,0",
                                    VelocityStr = "1.900635,0.010867,0.291061",
                                    Duration = 2,
                                    RotImpulseVelocity = Vector3.new(5868,-6649,-7414),
                                    Seed = math.random(1,1e6),
                                    LookVectorStr = "0.988493,0,0.151268"
                                }
                            }
                        }
                    end
                    ReplicatedStorage.Remotes.Combat.Action:FireServer(unpack(args))
                end
                pcall(function()
                    ReplicatedStorage.Remotes.Abilities.AbilityCanceled:FireServer(
                        GetCharacterAbility(charName,Ability,Number)
                    )
                end)
            end)
            task.wait()
            pcall(function() fullcustom2() end)
        end
    end
end

TargetsystemKillloop = false
TargetsystemKillconnection = nil

function killaurastart()
    if TargetsystemKillconnection then return end
    TargetsystemKillloop = true
    TargetsystemKillconnection = RunService.Heartbeat:Connect(function()
        if not TargetsystemKillloop then return end
        TargetsystemKillAura(Players:FindFirstChild(TargetSystemDropdown:GetValue()))
    end)
end
		
function killaurastop()
    if TargetsystemKillconnection then
        TargetsystemKillconnection:Disconnect()
        TargetsystemKillconnection = nil
    end
    TargetsystemKillloop = false
end

targetSystemGrabloop = false

function targetSystemGrabloopstart()
    if targetSystemGrabloop then return end
    targetSystemGrabloop = true
    while targetSystemGrabloop do
        pcall(function() TargetSystemwallcombo(Players:FindFirstChild(TargetSystemDropdown:GetValue())) end)
        task.wait(0.01)
    end
end
		
function targetSystemGrabloopstop()
    targetSystemGrabloop = false
end

killThenGrabToggle = TargetSystemSection:AddToggle({
    Text = "kill then grab",
    Default = false,

    Callback = function(Value)
        if Value then
            killaurastart()
            targetSystemGrabloopstart()
        else
            killaurastop()
            targetSystemGrabloopstop()
        end
    end,
})
killThenGrabToggle:ToolTip("kills then keeps the target in an inf loop of wallcombos")

function followTick()
    local targetPlayer = Players:FindFirstChild(TargetSystemDropdown:GetValue())
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local targetCF = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0.1, 4)
    pcall(function()
        require(LocalPlayer.PlayerScripts.Character.FullCustomReplication).Override(myChar, targetCF)
    end)
end

Targetsystemtelportloop = false
Targetsystemtelportconnection = nil

function telportstart()
    if Targetsystemtelportconnection then return end
    Targetsystemtelportloop = true
    Targetsystemtelportconnection = RunService.Heartbeat:Connect(function()
        if not Targetsystemtelportloop then return end
        followTick()
    end)
end
		
function telportstop()
    if Targetsystemtelportconnection then
        Targetsystemtelportconnection:Disconnect()
        Targetsystemtelportconnection = nil
    end
    Targetsystemtelportloop = false
end

telportToggle = TargetSystemSection:AddToggle({
    Text = "telport to target",
    Default = false,

    Callback = function(Value)
        if Value then
            telportstart()
        else
            telportstop()
        end
    end,
})
telportToggle:ToolTip("telports behind the person")

abilitiesSpamToggle = TargetSystemSection:AddToggle({
    Text = "Abilities Spam",
    Default = false,

    Callback = function(Value)
        if Value then
            AbilitiesSpamloopTargetSystemstart()
        else
            AbilitiesSpamloopTargetSystemstop()
        end
    end,
})
abilitiesSpamToggle:ToolTip("uses any move/moves you have chosen on him")

AbilitiesTargetSystemDropdown = TargetSystemSection:AddDropdown({
    Text = "Abilities",
    Values = { "Ability 1", "Ability 2", "Ability 3", "Ability 4" },
    Default = {},
    Multi = true,
})

DelayAbilitesspamTargetSystemSlider = TargetSystemSection:AddSlider({
    Text = "Delay",
    Default = 0.01,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
})

AbilitiesSpamloopTargetSystems = false

function AbilitiesSpamloopTargetSystemstart()
    if AbilitiesSpamloopTargetSystems then return end
    AbilitiesSpamloopTargetSystems = true
    while AbilitiesSpamloopTargetSystems do
        local targetPlayer = Players:FindFirstChild(TargetSystemDropdown:GetValue())
        if not targetPlayer then
            task.wait(0.01)
        else
            local selected = AbilitiesTargetSystemDropdown:GetValue()
            if selected["Ability 1"] then
                UseAbilitiesTargetSystem(targetPlayer,"Abilities",1)
                UseAbilitiesTargetSystem(targetPlayer,"Ultimates",1)
                task.wait(DelayAbilitesspamTargetSystemSlider:GetValue())
            end
            if selected["Ability 2"] then
                UseAbilitiesTargetSystem(targetPlayer,"Abilities",2)
                UseAbilitiesTargetSystem(targetPlayer,"Ultimates",2)
                task.wait(DelayAbilitesspamTargetSystemSlider:GetValue())
            end
            if selected["Ability 3"] then
                UseAbilitiesTargetSystem(targetPlayer,"Abilities",3)
                UseAbilitiesTargetSystem(targetPlayer,"Ultimates",3)
                task.wait(DelayAbilitesspamTargetSystemSlider:GetValue())
            end
            if selected["Ability 4"] then
                UseAbilitiesTargetSystem(targetPlayer,"Abilities",4)
                UseAbilitiesTargetSystem(targetPlayer,"Ultimates",4)
                task.wait(DelayAbilitesspamTargetSystemSlider:GetValue())
            end
        end
        task.wait()
    end
end
		
function AbilitiesSpamloopTargetSystemstop()
    AbilitiesSpamloopTargetSystems = false
end

AdminAbuseSection = Tabs.Main:AddSection({ Name = "AdminAbuse", Position = "left" })

function setGravity(enabled)
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = not enabled
            if not enabled then
                part.Velocity = Vector3.new(0, 0, 0)
                part.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end

function NL_RestorePhysics()
    pcall(function()
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = nil
        if spinConnection then spinConnection:Disconnect() end
        spinConnection = nil
        if flyConnection then flyConnection:Disconnect() end
        flyConnection = nil
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
        flyBodyVelocity = nil
        flyBodyGyro = nil

        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
                part.Anchored = false
            end
        end
        if hum then
            hum.PlatformStand = false
            if DefaultHipHeight and DefaultHipHeight > 0 then
                hum.HipHeight = DefaultHipHeight
            else
                hum.HipHeight = 2
            end
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
        end
    end)
end

function teleportupwards()
    local PlayerRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not PlayerRoot then return false end
    local upPos = PlayerRoot.Position + Vector3.new(0, 80, 0)
    pcall(function()
        require(LocalPlayer.PlayerScripts.Character.FullCustomReplication).Override(LocalPlayer.Character, CFrame.new(upPos))
    end)
    return true
end

Serverbullyingloop = false
IgrnoreFriendsAdminAbuse = false

function Serverbullyingloopstart()
    if Serverbullyingloop then return end
    Serverbullyingloop = true
    while Serverbullyingloop do
        local Targets = TargetSystem_GetPlayerNames()
        removePartners(Targets)
        if IgrnoreFriendsAdminAbuse then
            removeFriends(Targets)
        end
        local maxLimit = math.min(14, #Targets)
        for i=1,maxLimit do
            for j=1,20 do
                TargetsystemKillAura(Players:FindFirstChild(Targets[i]))
            end
            TargetSystemwallcombo(Players:FindFirstChild(Targets[i]))
            task.wait(0.01)
        end
        task.wait()
    end
end
		
function Serverbullyingloopstop()
    Serverbullyingloop = false
end

serverbullyingtoggle = AdminAbuseSection:AddToggle({
    Text = "Server Bullying",
    Default = false,

    Callback = function(Value)
        if Value then
            teleportupwards()
            setGravity(false)
            Serverbullyingloopstart()
        else
            setGravity(true)
            Serverbullyingloopstop()
        end
    end,
})
serverbullyingtoggle:ToolTip("kills the entire server and keeps them in an inf loop of wallcombos")

AdminAbuseSection:AddLabel("======================================", false)

function UseAbilities(Target,Ability,Number)
    local charName = GetCurrentCharacter()
    local target = Target
    if not target then return end
    if IsProtectedWallComboTarget(target) then return end
    local targetChar = target.Character
    local targetCF = GetTargetCFrame(Target)
    local th = target.Character:FindFirstChild("Humanoid")
    pcall(function()
        local ability = GetCharacterAbility(charName,Ability,Number)
        if not ability then return end
        ReplicatedStorage.Remotes.Abilities.Ability:FireServer(ability,9000000)
        local servertime = workspace:GetServerTimeNow()
        local actions = {377,380,383,384,385,387,389}
        for i=1,7 do
            local args = {
                ability,
                charName..":"..Ability..":"..Number,
                i,
                9000000,
                {
                    HitboxCFrames = {targetCF,targetCF},
                    BestHitCharacter = targetChar,
                    HitCharacters = {targetChar},
                    Ignore = i>2 and {ActionNumber1={targetChar}} or {},
                    DeathInfo = {},
                    BlockedCharacters = {},
                    HitInfo = {
                        IsFacing = not (i==1 or i==2),
                        IsInFront = i<=2,
                        Blocked = i>2 and false or nil
                    },
                    ServerTime = servertime,
                    Actions = i>2 and {ActionNumber1={}} or {},
                    FromCFrame = targetCF
                },
                "Action"..actions[i],
                i==2 and 0.1 or nil
            }
            if i==7 then
                args[5].RockCFrame = targetCF
                args[5].Actions = {
                    ActionNumber1 = {
                        [target.Name] = {
                            StartCFrameStr = tostring(targetCF.X)..","..tostring(targetCF.Y)..","..tostring(targetCF.Z)..",0,0,0,0,0,0,0,0,0",
                            ImpulseVelocity = Vector3.new(1901,-25000,291),
                            AbilityName = "4",
                            RotVelocityStr = "0,0,0",
                            VelocityStr = "1.900635,0.010867,0.291061",
                            Duration = 2,
                            RotImpulseVelocity = Vector3.new(5868,-6649,-7414),
                            Seed = math.random(1,1e6),
                            LookVectorStr = "0.988493,0,0.151268"
                        }
                    }
                }
            end
            ReplicatedStorage.Remotes.Combat.Action:FireServer(unpack(args))
        end
        pcall(function()
            ReplicatedStorage.Remotes.Abilities.AbilityCanceled:FireServer(
                GetCharacterAbility(charName,Ability,Number)
            )
        end)
    end)
end

function adminAbuseWallcombo(Target,number)
    local charName = GetCurrentCharacter()
    local target = Target
    if not target then return end
    local actionNumber = generateActionNumber()
    local randomId = math.random(100000, 999999)
    local targetChar = target.Character
    pcall(function()
        local targetCF = GetTargetCFrame(Target)
        local servertime = getServerTime()
        -- РСЃРїСЂР°РІР»РµРЅРёРµ: РїСЂРѕРІРµСЂСЏРµРј СЃСѓС‰РµСЃС‚РІРѕРІР°РЅРёРµ РїР°РїРєРё РїРµСЂСЃРѕРЅР°Р¶Р°
        local charFolder = ReplicatedStorage:FindFirstChild("Characters") and ReplicatedStorage.Characters:FindFirstChild(charName)
        if not charFolder then return end
        local ability = charFolder:FindFirstChild(WallComboName)
        if not ability then return end
        local remoteArgs = {
            ability,
            "Characters:" .. charName .. ":" .. WallComboName,
            number,
            randomId,
            {
                HitboxCFrames = {targetCF,targetCF,targetCF,targetCF,targetCF,targetCF},
                BestHitCharacter = targetChar,
                HitCharacters = {targetChar,targetChar,targetChar},
                Ignore = {},
                DeathInfo = {},
                BlockedCharacters = {},
                HitInfo = {
                    IsFacing = true,
                    IsInFront = true
                },
                ServerTime = servertime,
                Actions = {},
                FromCFrame = targetCF
            },
            actionNumber,
            0
        }
        pcall(function()
            ReplicatedStorage.Remotes.Abilities.Ability:FireServer(ability, randomId)
        end)
        pcall(function()
            ReplicatedStorage.Remotes.Combat.Action:FireServer(unpack(remoteArgs))
        end)
    end)
    task.wait()
end
		
PartnerVXSection = Tabs.Main:AddSection({ Name = "PartnerVX", Position = "left" })

local PartnerVXGreen = Color3.fromRGB(74, 222, 128)

-- DropdownLib rebuilds every row from scratch on SetValues, so the green
-- highlight has to be re-applied after each refresh, not just once.
local function PartnerVXRepaint()
    local root = PartnerVXDropdown and PartnerVXDropdown.RootItem
    if not root then return end
    for _, row in ipairs(root:GetChildren()) do
        if row:IsA("Frame") then
            for _, label in ipairs(row:GetChildren()) do
                if label:IsA("TextLabel") and label.Text ~= "check" then
                    if PartnerVXNames[label.Text] then
                        label.TextColor3 = PartnerVXGreen
                        label.TextTransparency = 0
                    else
                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        label.TextTransparency = 0.200
                    end
                end
            end
        end
    end
    if PartnerVXCountLabel then
        local count = 0
        for _ in pairs(PartnerVXNames) do
            count = count + 1
        end
        PartnerVXCountLabel:SetText("Partners: " .. (count > 0 and tostring(count) or "none"))
    end
end

PartnerVXDropdown = PartnerVXSection:AddDropdown({
    Text = "Partners",
    Values = TargetSystem_GetPlayerNames(),
    Default = {},
    Multi = true,
    Callback = function(sel)
        PartnerVXNames = {}
        -- Handle both shapes the library can hand back: a set {name=true} and
        -- a plain array {"name", true}.
        if type(sel) == "table" then
            for key, flag in next, sel do
                local candidate = (flag == true) and key or flag
                if type(candidate) == "string" and candidate ~= "" and candidate ~= "check" then
                    PartnerVXNames[candidate] = true
                end
            end
        end
        PartnerVXRepaint()
    end,
})

PartnerVXDropdown:ToolTip("Players picked here are skipped by KillAura, WallCombo, Server Bullying, Kill Farm and AuraV2.")

PartnerVXSection:AddButton({
    Name = "Pick Friends",
    Icon = "person-plus",
    ToolTip = "Mark every friend in the server as a partner",
    Callback = function()
        local sel = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and LocalPlayer:IsFriendsWith(p.UserId) then
                sel[p.Name] = true
            end
        end
        PartnerVXDropdown:SetValue(sel)
        PartnerVXRepaint()
    end,
})

PartnerVXSection:AddButton({
    Name = "Clear All",
    Icon = "person-circle-slash",
    ToolTip = "Remove every player from the partner list",
    Callback = function()
        PartnerVXDropdown:SetValue({})
        PartnerVXRepaint()
    end,
})

PartnerVXCountLabel = PartnerVXSection:AddLabel("Partners: none", true)

-- Runs once so the counter matches any partners restored from a saved config.
PartnerVXRepaint()

-- Only rebuilds the rows when the roster actually changed, so the list does not
-- churn (and does not steal the scroll position) every frame.
task.spawn(function()
    while true do
        local names = TargetSystem_GetPlayerNames()
        local joined = table.concat(names, ",")
        if joined ~= PartnerVXCachedNames then
            PartnerVXCachedNames = joined
            PartnerVXDropdown:SetValues(names)
            PartnerVXRepaint()
        end
        task.wait(2)
    end
end)

function KillRangeloopstop()
    AbilitiesSpamloop = false
end

killAuraAdmToggle = AdminAbuseSection:AddToggle({
    Text = "KillAura",
    Default = false,

    Callback = function(Value)
        if Value then
            KillRangeloopstart()
        else
            KillRangeloopstop()
        end
    end,
})
killAuraAdmToggle:ToolTip("Kills Everyone in Range with the Methods You Choice")

ignoreFriendsAdmToggle = AdminAbuseSection:AddToggle({
    Text = "IgnoreFriends",
    Default = false,

    Callback = function(Value)
        IgrnoreFriendsAdminAbuse = Value
    end,
})
ignoreFriendsAdmToggle:ToolTip("makes all of the function in admin abuse not target your friends")

showRangeToggle = AdminAbuseSection:AddToggle({
    Text = "ShowRangeCircle",
    Default = false,

    Callback = function(Value)
        if Value then
            startCircleTracker()
        else
            destroyCircle()
        end
    end,
})
showRangeToggle:ToolTip("shows the range you chosen")

AdminAbuseDropdown = AdminAbuseSection:AddDropdown({
    Text = "Methods",
    Values = { "Abilities", "KillAura", "WallCombo"},
    Default = "Abilities",
    Multi = false,
})

KillAuraRangeSlider = AdminAbuseSection:AddSlider({
    Text = "Range",
    Default = 100,
    Min = 1,
    Max = 100,
    Rounding = 0,
})

CircleColor = Color3.fromRGB(90, 208, 255)
RingThickness = 0.8
RingTransparency = 0.2

rangeCircle = nil
rangeAdornment = nil
updateCircleConnection = nil

function destroyCircle()
    if updateCircleConnection then
        updateCircleConnection:Disconnect()
        updateCircleConnection = nil
    end
    if rangeCircle then
        rangeCircle:Destroy()
        rangeCircle = nil
    end
end

function startCircleTracker()
    destroyCircle()
    rangeCircle = Instance.new("Part")
    rangeCircle.Size = Vector3.new(1, 1, 1)
    rangeCircle.Transparency = 1
    rangeCircle.Anchored = true
    rangeCircle.CanCollide = false
    rangeCircle.CanQuery = false
    rangeCircle.CanTouch = false
    rangeCircle.CastShadow = false
    rangeCircle.Parent = workspace
    rangeAdornment = Instance.new("CylinderHandleAdornment")
    rangeAdornment.Adornee = rangeCircle
    rangeAdornment.AlwaysOnTop = true
    rangeAdornment.Height = 0.05
    rangeAdornment.Color3 = CircleColor
    rangeAdornment.Transparency = RingTransparency
    rangeAdornment.Parent = rangeCircle
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    updateCircleConnection = RunService.RenderStepped:Connect(function()
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        raycastParams.FilterDescendantsInstances = {character, rangeCircle}
        local rayOrigin = hrp.Position
        local rayDirection = Vector3.new(0, -50, 0)
        local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        local targetPosition
        if raycastResult then
            targetPosition = raycastResult.Position
        else
            targetPosition = hrp.Position - Vector3.new(0, 2.9, 0)
        end
        local currentRadius = KillAuraRangeSlider:GetValue()
        rangeAdornment.Radius = currentRadius
        rangeAdornment.InnerRadius = currentRadius - RingThickness
        rangeAdornment.Color3 = CircleColor
        rangeAdornment.Transparency = RingTransparency
        rangeCircle.CFrame = CFrame.new(targetPosition + Vector3.new(0, 0.05, 0)) * CFrame.Angles(math.rad(90), 0, 0)
    end)
end

AbilitiesSpamloop = false

function KillRangeloopstart()
    if AbilitiesSpamloop then return end
    AbilitiesSpamloop = true
    while AbilitiesSpamloop do
        local Targets = TargetSystem_GetPlayerNames()
        Targets = filterAndSortPlayers(Targets,KillAuraRangeSlider:GetValue())
        removePartners(Targets)
        if IgrnoreFriendsAdminAbuse then
            removeFriends(Targets)
        end
        local maxLimit = math.min(14, #Targets)
        for i=1,maxLimit do
            local targetPlayer = Targets[i] and Players:FindFirstChild(Targets[i])
            if not targetPlayer then
                task.wait(0.01)
            else
                local selected = AdminAbuseDropdown:GetValue()
                if selected == "Abilities" then
                    UseAbilities(targetPlayer,"Abilities",1)
                    UseAbilities(targetPlayer,"Ultimates",1)
                    UseAbilities(targetPlayer,"Abilities",2)
                    UseAbilities(targetPlayer,"Ultimates",2)
                    UseAbilities(targetPlayer,"Abilities",3)
                    UseAbilities(targetPlayer,"Ultimates",3)
                    UseAbilities(targetPlayer,"Abilities",4)
                    UseAbilities(targetPlayer,"Ultimates",4)
                    task.wait(0.05)
                end
                if selected == "KillAura" then
                    adminAbuseWallcombo(targetPlayer,2)
                    task.wait()
                end
                if selected == "WallCombo" then
                    adminAbuseWallcombo(targetPlayer,1)
                    adminAbuseWallcombo(targetPlayer,2)
                    task.wait(0.05)
                end
            end
        end
        task.wait()
    end
end

AntiSection = Tabs.Main:AddSection({ Name = "AntiandLagger", Position = "right" })
AbilityFolder = workspace:WaitForChild("Map"):WaitForChild("Props"):WaitForChild("Ability")

isDeletionEnabled = true 

function cleanFolder(child)
    if isDeletionEnabled then
        child:Destroy()
    end
end

AbilityFolder.ChildAdded:Connect(cleanFolder)

for _, child in ipairs(AbilityFolder:GetChildren()) do
    if isDeletionEnabled then
        child:Destroy()
    end
end

antiLaggerToggle = AntiSection:AddToggle({
    Text = "Anti-Serverlagger",
    Default = false,

    Callback = function(Value)
        if Value then
            BlockIncomingRemote("Ability")
            SetAntiSLEnabled(true)
            isDeletionEnabled = true
        else
            UnblockIncomingRemote("Ability")
            SetAntiSLEnabled(false)
            isDeletionEnabled = false
        end
    end,
})
antiLaggerToggle:ToolTip("Counters all laggers")

AntiSection:AddLabel("======================================", false)

serverLaggerToggle = AntiSection:AddToggle({
    Text = "Serverlagger",
    Default = false,

    Callback = function(Value)
        if Value then
            ServerLaggerstart()
            dashlaggerLoopstart()
        else
            ServerLaggerstop()
            dashlaggerLoopstop()
        end
    end,
})
serverLaggerToggle:ToolTip("Lags using the methods you choice")

ServerLaggerDropdown = AntiSection:AddDropdown({
    Text = "Methods",
    Values = { "Abilities", "Dash", "WallCombo" },
    Default = { ["WallCombo"] = true },
    Multi = true,
})

function UseAbilitiesServerLagger(Ability,Number)
    local charName = GetCurrentCharacter()
    local target = LocalPlayer
    if not target then return end
    local targetChar = target.Character
    local targetCF = GetTargetCFrame(target)
    local th = target.Character:FindFirstChild("Humanoid")
    pcall(function()
        local ability = GetCharacterAbility(charName,Ability,Number)
        if not ability then return end
        ReplicatedStorage.Remotes.Abilities.Ability:FireServer(ability,9000000)
        local servertime = workspace:GetServerTimeNow()
        local actions = {377,380,383,384,385,387,389}
        for i=1,7 do
            local args = {
                ability,
                charName..":"..Ability..":"..Number,
                i,
                9000000,
                {
                    HitboxCFrames = {targetCF,targetCF},
                    CustomInfo = {
                        Name = string.format("%.11f",  math.random(1000, 9999) + math.random()),
                        ProjectileCFrame =targetCF,
                        Material = Enum.Material.Ground,
                        Color = Color3.new(0.50196081399918, 0.32941177487373, 0.22745098173618),
                        CFrame = targetCF
                    },
                    HitCharacters = {},
                    Ignore = i>2 and {ActionNumber1={}} or {},
                    DeathInfo = {},
                    BlockedCharacters = {},
                    HitInfo = {},
                    ServerTime = servertime,
                    Actions = i>2 and {ActionNumber1={}} or {},
                    FromCFrame = targetCF
                },
                "Action"..actions[i],
                i==2 and 0.1 or nil
            }
            if i==7 then
                args[5].RockCFrame = targetCF
                args[5].Actions = {
                    ActionNumber1 = {
                        [target.Name] = {
                            StartCFrameStr = tostring(targetCF.X)..","..tostring(targetCF.Y)..","..tostring(targetCF.Z)..",0,0,0,0,0,0,0,0,0",
                            ImpulseVelocity = Vector3.new(1901,-25000,291),
                            AbilityName = "4",
                            RotVelocityStr = "0,0,0",
                            VelocityStr = "1.900635,0.010867,0.291061",
                            Duration = 2,
                            RotImpulseVelocity = Vector3.new(5868,-6649,-7414),
                            Seed = math.random(1,1e6),
                            LookVectorStr = "0.988493,0,0.151268"
                        }
                    }
                }
            end
            ReplicatedStorage.Remotes.Combat.Action:FireServer(unpack(args))
        end
        pcall(function()
            ReplicatedStorage.Remotes.Abilities.AbilityCanceled:FireServer(
                GetCharacterAbility(charName,Ability,Number)
            )
        end)
    end)
end

ServerLaggerSlider = AntiSection:AddSlider({
    Text = "Times Per FPS",
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 0,
})

ServerLaggerloop = false
ServerLaggerDashloop = false
ServerLaggerconnection = nil

function ServerLaggerstart()
    if ServerLaggerconnection then return end
    ServerLaggerloop = true
    ServerLaggerconnection = RunService.Heartbeat:Connect(function()
        if not ServerLaggerloop then
            if ServerLaggerconnection then
                ServerLaggerconnection:Disconnect()
                ServerLaggerconnection = nil
            end
            return
        end
        local selected = ServerLaggerDropdown:GetValue()
        local number = ServerLaggerSlider:GetValue()
        task.spawn(function()
            for i = 1, number do
                if selected["Abilities"] then
                    pcall(UseAbilitiesServerLagger, "Abilities", 1)
                    pcall(UseAbilitiesServerLagger, "Abilities", 2)
                    pcall(UseAbilitiesServerLagger, "Abilities", 3)
                    pcall(UseAbilitiesServerLagger, "Abilities", 4)
                end
                if selected["WallCombo"] then
                    pcall(wallcombodummy, "The Ultimate Bum")
                    pcall(wallcombodummy, "Blocking Bum")
                    pcall(wallcombodummy, "Attacking Bum")
                end
            end
        end)
    end)
end

function ServerLaggerstop()
    ServerLaggerloop = false
    if ServerLaggerconnection then
        ServerLaggerconnection:Disconnect()
        ServerLaggerconnection = nil
    end
end

function dashlaggerLoopstart()
    if ServerLaggerDashloop then return end
    ServerLaggerDashloop = true
    local selected = ServerLaggerDropdown:GetValue()
    task.spawn(function()
        while ServerLaggerDashloop do
            if selected["Dash"] then
                fullcustom3(-9e9, -5, 9e9)
                task.wait()
                fullcustom3(9e9, 5, -9e9)
            end
            task.wait()
        end
    end)
end

function dashlaggerLoopstop()
    ServerLaggerDashloop = false
end

HitBoxSection = Tabs.Legit:AddSection({ Name = "HitBox", Position = "left" })

hitBoxToggleLib = HitBoxSection:AddToggle({
    Text = "HitBoxtoggle",
    Default = false,

    Callback = function(Value)
        toggleHitbox(Value)
    end,
})
hitBoxToggleLib:ToolTip("enables hitbox")

enhancerToggleLib = HitBoxSection:AddToggle({
    Text = "Enhancertoggle",
    Default = false,

    Callback = function(Value)
        toggleEnhancer(Value)
    end,
})
enhancerToggleLib:ToolTip("Makes hitbox work better and if you change the multipler you get higher damage")

HitboxLegitfy = false
HitboxIgnoreFriends = false
HitboxVisualizer = false

HitboxLegitifytoggle = HitBoxSection:AddToggle({
    Text = "HitboxLegitify",
    Default = false,

    Callback = function(Value)
        HitboxLegitfy = Value
    end,
})
HitboxLegitifytoggle:ToolTip("makes stuff legit")

HitboxIgnoreFriendstoggle = HitBoxSection:AddToggle({
    Text = "HitboxIgnoreFriends",
    Default = false,

    Callback = function(Value)
        HitboxIgnoreFriends = Value
    end,
})
HitboxIgnoreFriendstoggle:ToolTip("Makes you unable to hit your friends")

HitboxVisualizertoggle = HitBoxSection:AddToggle({
    Text = "HitboxVisualizer",
    Default = false,

    Callback = function(Value)
        HitboxVisualizer = Value
    end,
})
HitboxVisualizertoggle:ToolTip("shows the hitboxes with a square")

EnhancerHitboxSlider = HitBoxSection:AddSlider({
    Text = "EnhancerMultiplier",
    Default = 0,
    Min = 0,
    Max = 50,
    Rounding = 0,
})

HitBoxXSlider = HitBoxSection:AddSlider({
    Text = "X",
    Default = 40,
    Min = 0,
    Max = 250,
    Rounding = 0,
})

HitBoxYSlider = HitBoxSection:AddSlider({
    Text = "Y",
    Default = 40,
    Min = 0,
    Max = 250,
    Rounding = 0,
})

HitBoxZSlider = HitBoxSection:AddSlider({
    Text = "Z",
    Default = 40,
    Min = 0,
    Max = 250,
    Rounding = 0,
})

local core, originalHitBox
pcall(function() core = require(ReplicatedStorage:WaitForChild("Core", 9e9)) end)

function initializeHitbox()
    if core and not originalHitBox then
        local combat = core.Get("Combat", "Hit")
        if combat and combat.Box then originalHitBox = combat.Box end
    end
end

function toggleHitbox(enabled)
    if not core then return end
    local combat = core.Get("Combat", "Hit")
    if not combat then return end
    if enabled then
        if not originalHitBox then initializeHitbox() end
        if not originalHitBox then
            return
        end
        combat.Box = function(...)
            local args = {...}
            if not args[3] or type(args[3]) ~= "table" then
                return originalHitBox(...)
            end
            local newSize
            if true then
                local originalSize = args[3].Size or Vector3.new(0, 0, 0)
                newSize = Vector3.new(
                    originalSize.X + HitBoxXSlider:GetValue(),
                    originalSize.Y + HitBoxYSlider:GetValue(),
                    originalSize.Z + HitBoxZSlider:GetValue()
                )
            end
            if HitboxVisualizer then
                local cf = args[3].CFrame or args[3].cf or args[3].Frame
                if not cf and typeof(args[2]) == "CFrame" then
                    cf = args[2]
                elseif not cf and typeof(args[2]) == "Instance" and args[2]:IsA("BasePart") then
                    cf = args[2].CFrame
                end
                if not cf then
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    cf = hrp and hrp.CFrame or CFrame.new()
                end
                local p = Instance.new("Part")
                p.Name = "HitboxVisualizer"
                p.Anchored = true
                p.CanCollide = false
                p.Material = Enum.Material.ForceField
                p.Color = Color3.fromRGB(90, 208, 255)
                p.Transparency = 0.4
                p.Size = newSize
                p.CFrame = cf
                p.CastShadow = false
                p.Parent = workspace
                game:GetService("Debris"):AddItem(p, 0.08)
            end
            if HitboxLegitfy then
                local modifiedArg3 = {}
                for k, v in pairs(args[3]) do
                    modifiedArg3[k] = v
                end
                modifiedArg3.Size = newSize
                local bestTarget, validTargets = originalHitBox(args[1], args[2], modifiedArg3)
                if HitboxIgnoreFriends then
                    if bestTarget and isExcludedCharacter(bestTarget) then
                        bestTarget = nil
                    end
                    if validTargets and type(validTargets) == "table" then
                        for i = #validTargets, 1, -1 do
                            if isExcludedCharacter(validTargets[i]) then
                                table.remove(validTargets, i)
                            end
                        end
                    end
                end
                return bestTarget, validTargets
            else
                local bestTarget, validTargets = originalHitBox(args[1], args[2], {Size = newSize})
                if HitboxIgnoreFriends then
                    if bestTarget and isExcludedCharacter(bestTarget) then
                        bestTarget = nil
                    end
                    if validTargets and type(validTargets) == "table" then
                        for i = #validTargets, 1, -1 do
                            if isExcludedCharacter(validTargets[i]) then
                                table.remove(validTargets, i)
                            end
                        end
                    end
                end
                return bestTarget, validTargets
            end
        end
    else
        if originalHitBox then
            combat.Box = originalHitBox
        end
    end
end

originalHitProcess = nil
		
function enableEnhancer()
    local PlayersService = game:GetService("Players")
    local ok_hit, hit = pcall(function() return require(PlayersService.LocalPlayer.PlayerScripts.Combat.Hit) end)
    if not ok_hit or type(hit) ~= "table" or type(hit.Process) ~= "function" then
        return
    end
    if not originalHitProcess then
        originalHitProcess = hit.Process
    end
    if not originalHitProcess then
        return
    end
    hit.Process = function(...)
        local bestTarget, validTargets, blockedTargets = originalHitProcess(...)
        if HitboxIgnoreFriends then
            if bestTarget and isExcludedCharacter(bestTarget) then
                bestTarget = nil
            end
            if validTargets and type(validTargets) == "table" then
                for i = #validTargets, 1, -1 do
                    if isExcludedCharacter(validTargets[i]) then
                        table.remove(validTargets, i)
                    end
                end
            end
        end
        if not validTargets or #validTargets == 0 then
            return bestTarget, validTargets, blockedTargets
        end
        pcall(function()
            if EnhancerHitboxSlider:GetValue() == 0 then
                ReplicatedStorage.Remotes.Abilities.Ability:FireServer(nil, 69)
                ReplicatedStorage.Remotes.Combat.Action:FireServer(
                    nil,
                    "",
                    4,
                    69,
                    { BestHitCharacter = nil, HitCharacters = validTargets, Ignore = {}, Actions = {} }
                )
            else
                local charName = GetCurrentCharacter()
                local charFolder = ReplicatedStorage:FindFirstChild("Characters") and ReplicatedStorage.Characters:FindFirstChild(charName)
                if not charFolder then return end
                local wallCombo = charFolder:FindFirstChild(WallComboName)
                if wallCombo then
                    for i = 1,EnhancerHitboxSlider:GetValue() do
                        ReplicatedStorage.Remotes.Abilities.Ability:FireServer(wallCombo, 69)
                        ReplicatedStorage.Remotes.Combat.Action:FireServer(
                            wallCombo,
                            "",
                            4,
                            69,
                            { BestHitCharacter = nil, HitCharacters = validTargets, Ignore = {}, Actions = {} }
                        )
                    end
                end
            end
        end)
        return bestTarget, validTargets, blockedTargets
    end
end
		
function disableEnhancer()
    if originalHitProcess then
        local ok, hit = pcall(function() return require(game:GetService("Players").LocalPlayer.PlayerScripts.Combat.Hit) end)
        if ok then
            hit.Process = originalHitProcess
        end
    end
end
		
function toggleEnhancer(enabled)
    if enabled then
        enableEnhancer()
    else
        disableEnhancer()
    end
end

toggleEnhancer(false)

LegitTogglesSection = Tabs.Legit:AddSection({ Name = "LegitToggles", Position = "right" })

originalRunAttack = nil
runAttackHooked = false
targetRunAttackFunc = nil

_G.LegitKombatActive = false

function scanner(funcname)
    local targetScript = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Combat"):WaitForChild("Dash")
    local list = filtergc("function", { Name = funcname }, false)
    for _, v in ipairs(list) do
        if typeof(v) == "function" then
            local success, env = pcall(getfenv, v)
            if success and env and env.script == targetScript then
                return v
            end
        end
    end
    return nil
end

punchAnimation = scanner("punchAnimation")
vfx = scanner("vfx")

function customRunAttack(p_u_105, p_u_106, p107, p108)
    if not _G.LegitKombatActive then
        if originalRunAttack then
            return originalRunAttack(p_u_105, p_u_106, p107, p108)
        end
        return
    end

    local v_u_1 = require(game.ReplicatedStorage:WaitForChild("Core"))
    local v109 = v_u_1.Services.Camera.CFrame
    local v110 = os.clock()
    local v_u_111 = tostring(v110)
    local v112 = 0
    local v_u_113 = 0
    local v_u_114 = 0
    local v_u_115 = 0
    local v_u_116, v_u_117, v_u_118, v_u_119, v_u_120
    local v121, v122
    local v_u_13, v_u_12 = false, false

    local function v_u_135(p123, p124, p125, p126, p127)
        local v128 = v_u_1.Get("Combat", "Ragdoll").GetRagdollFrame(p123)
        local v129 = v_u_1.Get("Character", "FullCustomReplication").GetCFrame(p_u_105)
        local v130 = v_u_1.Get("Character", "FullCustomReplication").GetCFrame(p123)
        local v131 = not p125
        if not v131 then
            if v129 and v130 then
                local v132 = p124 + v129.Position.Y - v130.Position.Y
                v131 = math.abs(v132) < p125
            end
        end
        local v133 = not p126
        if v133 then
            v128 = v133
        elseif v128 then
            v128 = v128.Velocity.Y < 0
        end
        local v134 = not p127
        if v134 then
            v130 = v134
        elseif v129 and v130 then
            v130 = v130.Position.Y > v129.Position.Y
        end
        if v131 then
            if not v128 then
                v130 = v128
            end
        else
            v130 = v131
        end
        v_u_120 = v130
        return v_u_120
    end

    local function v140(p136, p137)
        local v138 = v_u_1.Get("Combat", "Ragdoll").GetRagdollFrame(p136)
        local v139 = v_u_1.Get("Combat", "Ragdoll").UpVelocities[p136]
        if v138 then
            if v138.Velocity.Y < 0 and v139 then
                v139 = v139 > 1 and p137.CollisionGroup ~= "NoCharacterCollisions"
            else
                v139 = false
            end
        end
        return v139
    end

    local function v148(p141, p142, p143)
        if v_u_1.Library("Instance").Exists(p_u_106) then
            local v144, v145 = v_u_1.Get("Combat", "Hit").Box(nil, p_u_105, {
                Size = p141,
                Offset = p142,
                IgnoreJump = true,
                IgnoreRagdolls = "Ground",
                IgnoreKnockback = true,
                NoBaseValidation = true,
                RequireInFront = true,
                BlockHitsThroughWalls = true,
                CustomValidation = p143
            })
            v_u_117, v_u_116 = v144, v145
            local v146, v147 = v_u_1.Get("Combat", "Hit").Box(nil, p_u_105, {
                Size = p141,
                Offset = p142,
                IgnoreJump = true,
                IgnoreRagdolls = "Ground",
                IgnoreKnockback = true,
                RequireInFront = true,
                BlockHitsThroughWalls = true,
                CustomValidation = p143
            })
            v_u_119, v_u_118 = v146, v147
            return #v_u_116 > 0
        end
    end

    local v_u_149, v150, v151, v152_val = v_u_119, v_u_114, v_u_113, v122
    local v_u_153, v_u_154, v155 = v_u_120, v121, nil
    
    local function v159(p156, p157)
        local v158 = not p156:GetAttribute("Ragdoll") or v_u_135(p156, 2, 0.25, true)
        if v158 then
            v158 = p157.CollisionGroup ~= "NoCharacterCollisions"
        end
        return v158
    end

    while true do
        task.wait()
        if not _G.LegitKombatActive then 
            break 
        end
        local v160 = v_u_1.Services.Camera.CFrame
        local _, v161, _ = v109:ToOrientation()
        local _, v162, _ = v160:ToOrientation()
        local v163 = v161 - v162
        local v164 = math.deg(v163)
        if v164 > 180 then
            v164 = v164 - 360
        elseif v164 < -180 then
            v164 = v164 + 360
        end
        v112 = v112 + v164
        v_u_113 = math.max(v151, v112)
        v_u_114 = math.min(v150, v112)
        v_u_115 = os.clock() - v110
        local v165 = p107 - v_u_115
        if v_u_115 > 0.2125 then
            v121 = v148(Vector3.new(1, 1, 1), CFrame.new(0, 7.5, -0.5), v140)
            v155 = v121 or v148(Vector3.new(5, 5, 4.5), CFrame.new(0, 0, -2), v159)
            v_u_154 = v121
        end
        if v155 or p108 < v_u_115 then
            local v_u_166 = v165 > 0 and true or v152_val
            local v167 = v155 or v148(Vector3.new(7.5, 5, 7), CFrame.new(0, 0, -2.75), v159)
            if v167 then
                v_u_1.Get("Character", "Move").SetJumpOverride("DashPunch", 0)
                task.delay(0.5, v_u_1.Get("Character", "Move").SetJumpOverride, "DashPunch", nil)
            end
            local function v188()
                local v182 = {
                    Guarantees = v_u_149,
                    Replace = function(p168)
                        local v169 = v_u_1.Get("Combat", "Knockback").CharacterPresets[p168] == "Uppercut" and 0.375 or 0.2625
                        local ok1, v170 = pcall(function() return v_u_1.Get("Combat", "Ragdoll").GetRagdoll(p168) end)
                        if not ok1 then v170 = nil end
                        local ok2, v170Frame = pcall(function() return v_u_1.Get("Combat", "Ragdoll").GetRagdollFrame(p168) end)
                        if not ok2 then v170Frame = nil end
                        local attrRagdoll = false
                        if p168 and p168.GetAttribute then
                            pcall(function() attrRagdoll = p168:GetAttribute("Ragdoll") end)
                        end
                        local isRagdolled = (v170 ~= nil) or (v170Frame ~= nil) or (attrRagdoll == true)
                        local v172 = nil
                        local ok4, gotCFrame = pcall(function() return p168 and v_u_1.Get("Character", "FullCustomReplication").GetCFrame(p168) end)
                        if ok4 and gotCFrame then
                            local tmp = p_u_106.CFrame:PointToObjectSpace(gotCFrame.Position)
                            local v174 = tmp.X * 180 / 2
                            v172 = p_u_106.CFrame * CFrame.Angles(0, math.rad(-math.clamp(v174, -180, 180)), 0)
                        end
                        local hasKB = false
                        if p168 and p168.GetAttribute then
                            local okKB, kbVal = pcall(function() return p168:GetAttribute("Knockback") end)
                            if okKB and kbVal then hasKB = true end
                        end
                        if isRagdolled then
                            return { ActionNumbers = {2, 6}, ForceDirection = v172 }
                        end
                        if v_u_115 < v169 then
                            if p168 and p168.SetAttribute then
                                pcall(function() p168:SetAttribute("Knockback", false) end)
                            end
                            return { ActionNumbers = {1, 6}, ForceDirection = nil }
                        end
                        local v179
                        if v_u_113 - v_u_114 > 180 then
                            v179 = not v170 or v_u_135(p168, 0, 2, nil, true)
                        else
                            v179 = false
                        end
                        local v180 = false
                        local v181 = v_u_166
                        if v181 then v181 = not v170 end
                        if v180 then
                            if v170 then v170 = v_u_154 end
                        else
                            v170 = v180
                        end
                        if v180 then v180 = not v170 end
                        if v_u_115 >= v169 then
                            pcall(function()
                                if p168 and p168.SetAttribute then p168:SetAttribute("Knockback", false) end
                            end)
                        end
                        local pick = 1
                        if hasKB then pick = 5
                        elseif v181 then pick = 4
                        elseif v180 then pick = 3
                        elseif v170 then pick = 2
                        else pick = 1
                        end
                        return { ActionNumbers = { pick, 6 }, ForceDirection = v181 and v172 }
                    end,
                    UseFromCFrame = v_u_166 and p_u_106.CFrame * CFrame.new(0, 0, -2) or nil
                }
                task.wait(0.15)
                v_u_12 = true
                local v183, v184, _, _, v185 = v_u_1.Get("Combat", "Action").Event(nil, p_u_105, "PunchDash", v_u_111, v182, 0)
                if v183 then
                    vfx("DashHit", v183, p_u_106.Position)
                    v_u_1.Get("Camera", "Shake").Shake(nil, nil, {
                        Amplitude = 1.25,
                        Frequency = 0.0875,
                        FadeInTime = 0.025,
                        FadeOutTime = 0.5
                    }, nil, p_u_105, table.unpack(v184))
                end
                local v186 = false
                for _, v187 in v185 and (v185.BlockedCharacters or {}) or {} do
                    if not table.find(v185.HitCharacters, v187) then
                        v186 = true
                    end
                end
                v_u_13 = v186
                v_u_12 = false
            end
            task.spawn(v188)
            if v165 > 0 then
                v_u_1.Services.Run.Heartbeat:Wait()
                task.wait(v165 + 0.025)
            end
            task.spawn(punchAnimation, p_u_105, v_u_111)
            return v165 > 0, v167
        end
        v150, v151, v109 = v_u_114, v_u_113, v160
    end
end

function enableLegitKombat()
    _G.LegitKombatActive = true
    getgenv().LegitKombatEnabled = true
    if runAttackHooked then return end
    local targetScript = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Combat"):WaitForChild("Dash")
    local list = filtergc("function", { Name = "runAttack" }, false)
    for _, v in ipairs(list) do
        if typeof(v) == "function" then
            local success, env = pcall(getfenv, v)
            if success and env and env.script == targetScript then
                targetRunAttackFunc = v
                originalRunAttack = hookfunction(v, customRunAttack)
                runAttackHooked = true
                break
            end
        end
    end
end

function disableLegitKombat()
    _G.LegitKombatActive = false
    getgenv().LegitKombatEnabled = false
    if runAttackHooked and originalRunAttack then
        local ok = pcall(function()
            if targetRunAttackFunc then
                hookfunction(targetRunAttackFunc, originalRunAttack)
            end
        end)
        if not ok then
            pcall(function()
                if targetRunAttackFunc then
                    debug.setmetatable(targetRunAttackFunc, getmetatable(originalRunAttack))
                end
            end)
        end
        originalRunAttack = nil
        targetRunAttackFunc = nil
    end
    runAttackHooked = false
end

dashHelperToggle = LegitTogglesSection:AddToggle({
    Text = "Dashhelper",
    Default = false,

    Callback = function(Value)
        if Value then
            enableLegitKombat()
        else
            disableLegitKombat()
        end
    end,
})
dashHelperToggle:ToolTip("makes loop dash easier and bone dash 100%")



-- ==============================================
-- NO RAGDOLL ON EVADE
-- Repro: an opponent uses their second ability (Gon:Abilities, the "Rock"
-- throw on character 1) and you evade out of the combo, yet you get
-- ragdolled anyway. The ability resolves against the position the server
-- already received, so the hit is credited regardless of your local evade
-- and the server leaves Ragdoll + Knockback set on you.
--
-- This only reacts to a ragdoll that is ALREADY applied: it clears the
-- attributes and pushes GettingUp. It deliberately never disables
-- FallingDown or touches PlatformStand on a timer, because doing that
-- breaks the DashHelper ragdoll->dash window.
-- ==============================================

NoRagdollOnEvade = NoRagdollOnEvade or { active = false, connection = nil }

function NoRagdollOnEvadeClear(character)
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local cleared = false

    if root:GetAttribute("Ragdoll") then
        pcall(function() root:SetAttribute("Ragdoll", false) end)
        cleared = true
    end
    if character:GetAttribute("Ragdoll") then
        pcall(function() character:SetAttribute("Ragdoll", false) end)
        cleared = true
    end
    if root:GetAttribute("Knockback") then
        pcall(function() root:SetAttribute("Knockback", false) end)
        cleared = true
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid:GetState() == Enum.HumanoidStateType.FallingDown then
        -- Re-enable the state first: if something disabled it, GettingUp
        -- is silently ignored and the character stays down.
        pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true) end)
        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        cleared = true
    end

    return cleared
end

function NoRagdollOnEvadeStart()
    if NoRagdollOnEvade.connection then return end
    NoRagdollOnEvade.active = true

    -- Note: NoStunOnMiss is NOT touched here. There is already a dedicated
    -- "No StunOnMiss" toggle in ExtraButtonsSection writing the same
    -- setting, and stomping it to false on stop would override the user.

    NoRagdollOnEvade.connection = RunService.Heartbeat:Connect(function()
        if not NoRagdollOnEvade.active then return end
        local character = LocalPlayer.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if root:GetAttribute("Ragdoll") or character:GetAttribute("Ragdoll") then
            pcall(NoRagdollOnEvadeClear, character)
        end
    end)
end

function NoRagdollOnEvadeStop()
    NoRagdollOnEvade.active = false
    if NoRagdollOnEvade.connection then
        NoRagdollOnEvade.connection:Disconnect()
        NoRagdollOnEvade.connection = nil
    end
end

noRagdollEvadeToggle = LegitTogglesSection:AddToggle({
    Text = "No ragdoll on evade",
    Default = false,

    Callback = function(Value)
        if Value then
            NoRagdollOnEvadeStart()
        else
            NoRagdollOnEvadeStop()
        end
    end,
})
noRagdollEvadeToggle:ToolTip("clears the stun the server still applies when you evade out of an ability combo")

ActionRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Action")
AbilityCanceledRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Abilities"):WaitForChild("AbilityCanceled")
RagdollPowerInstance = ReplicatedStorage:WaitForChild("Settings"):WaitForChild("Multipliers"):WaitForChild("RagdollPower")

legitKombatEnabled2 = false
v = false
loopThread = nil

getnamecallmethod = getnamecallmethod
typeof = typeof

mt = getrawmetatable(game)
old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    if not legitKombatEnabled2 then 
        return old(self, ...) 
    end
    local method = getnamecallmethod()
    if method ~= "FireServer" then 
        return old(self, ...) 
    end
if self == ActionRemote then
        local args = {...}
        if args[2] == "Gon:Abilities:1" then
            local data = args[5]
            if typeof(data) == "table" and data.BestHitCharacter ~= nil then
                v = (args[3] == 1)
            end
        else
            v = false
        end
    elseif self == AbilityCanceledRemote then
        local args = {...}
        local ability = args[1]
        if ability then
            local parent = ability.Parent
            if parent and parent.Name == "Abilities" then
                local grandParent = parent.Parent
                if grandParent and grandParent.Name == "Gon" and ability.Name == "1" then
                    v = false
                end
            end
        end
    end
    return old(self, ...)
end)

setreadonly(mt, true)

-- Installed after the legit Kombat hook above so that it chains on top of it
-- instead of being overwritten by it. Every Combat.Action payload carries the
-- final victim list, so stripping partners here is the only place that is
-- guaranteed to run no matter which internal path produced the hits.
NeverLose.PartnerRemoteFilter = NeverLose.PartnerRemoteFilter or { installed = false }

NeverLose.PartnerDebug = NeverLose.PartnerDebug or { prints = 0, MAXPRINTS = 3 }

local function WallComboV1Describe(value)
    local kind = typeof(value)
    if kind == "string" then
        return "string(" .. value .. ")"
    end
    if kind ~= "Instance" then
        return kind
    end
    local model = value:IsA("Model") and value or value:FindFirstAncestorOfClass("Model")
    if not model then
        return "Instance(" .. value.Name .. ")"
    end
    local owner = Players:GetPlayerFromCharacter(model)
    if owner then
        return "Char(" .. owner.Name .. ")"
    end
    return "Model(" .. model.Name .. ")"
end

local function WallComboV1DumpPartners()
    local names = {}
    local count = 0
    for name in pairs(PartnerVXNames) do
        count = count + 1
        names[#names + 1] = name
    end
    table.sort(names)
    print("[PartnerFilter] PartnerVXNames count=" .. count .. " -> " .. table.concat(names, ", "))
end

local function WallComboV1CleanPayload(args)
    for i = 1, args.n do
        local value = args[i]
        if type(value) == "table" then
            if NeverLose.PartnerDebug.prints < NeverLose.PartnerDebug.MAXPRINTS then
                NeverLose.PartnerDebug.prints = NeverLose.PartnerDebug.prints + 1
                local shape = {}
                for k = 1, args.n do
                    shape[k] = "arg" .. k .. "=" .. WallComboV1Describe(args[k])
                end
                print("[PartnerFilter] Action args: " .. table.concat(shape, " | "))
                if type(value.HitCharacters) == "table" then
                    local hitNames = {}
                    for _, entry in ipairs(value.HitCharacters) do
                        hitNames[#hitNames + 1] = WallComboV1Describe(entry)
                    end
                    print("[PartnerFilter] HitCharacters #" .. #value.HitCharacters .. " -> " .. table.concat(hitNames, ", "))
                end
                if value.BestHitCharacter ~= nil then
                    print("[PartnerFilter] BestHitCharacter -> " .. WallComboV1Describe(value.BestHitCharacter))
                end
                WallComboV1DumpPartners()
            end
            if type(value.HitCharacters) == "table" then
                WallComboV1StripPartners(value.HitCharacters)
            end
            if value.BestHitCharacter ~= nil and WallComboV1IsPartnerEntry(value.BestHitCharacter) then
                value.BestHitCharacter = nil
            end
        end
    end
end

local function WallComboV1InstallRemoteFilter()
    if NeverLose.PartnerRemoteFilter.installed then return end
    local gameMt = getrawmetatable(game)
    if type(gameMt) ~= "table" or type(gameMt.__namecall) ~= "function" then return end
    local previous = gameMt.__namecall
    setreadonly(gameMt, false)
    gameMt.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "FireServer" and self == ActionRemote then
            local args = table.pack(...)
            pcall(WallComboV1CleanPayload, args)
            return previous(self, table.unpack(args, 1, args.n))
        end
        return previous(self, ...)
    end)
    setreadonly(gameMt, true)
    NeverLose.PartnerRemoteFilter.installed = true
end

WallComboV1InstallRemoteFilter()

task.spawn(function()
    task.wait(2)
    print("[PartnerFilter] processHook=" .. tostring(NeverLose.PartnerFilter.installed) ..
        " remoteHook=" .. tostring(NeverLose.PartnerRemoteFilter.installed))
    WallComboV1DumpPartners()
end)

function enableLegitKombat2()
    if legitKombatEnabled2 then return end
    legitKombatEnabled2 = true
    v = false
    loopThread = task.spawn(function()
        while legitKombatEnabled2 do
            if RagdollPowerInstance then
                local targetValue = v and 70 or 100
                if RagdollPowerInstance.Value ~= targetValue then
                    RagdollPowerInstance.Value = targetValue
                end
            end
            task.wait(0.03)
        end
    end)
end

function disableLegitKombat2()
    legitKombatEnabled2 = false
    v = false
    if loopThread then
        task.cancel(loopThread)
        loopThread = nil
    end
    if RagdollPowerInstance then
        RagdollPowerInstance.Value = 100 
    end
end

rockHelperToggle = LegitTogglesSection:AddToggle({
    Text = "Rockhelper",
    Default = false,

    Callback = function(Value)
        if Value then
            enableLegitKombat2()
        else
            disableLegitKombat2()
        end
    end,
})
rockHelperToggle:ToolTip("does the low rock for you(spin to make it less obvious)")

localPlayer = Players.LocalPlayer
legitKombatEnabled3 = false

function enableLegitKombat3()
    if legitKombatEnabled3 then return end
    legitKombatEnabled3 = true
    task.spawn(function()
        while legitKombatEnabled3 do
            local character = localPlayer.Character
            if character then
                character:SetAttribute("Block", true)
            end
            task.wait(0.03) 
        end
    end)
end

function disableLegitKombat3()
    legitKombatEnabled3 = false
end

lessEndlagToggle = LegitTogglesSection:AddToggle({
    Text = "lessendlag block",
    Default = false,

    Callback = function(Value)
        if Value then
            enableLegitKombat3()
        else
            disableLegitKombat3()
        end
    end,
})
lessEndlagToggle:ToolTip("gives you less endlag on letting go of block(helpful)")

DesyncSection = Tabs.Legit:AddSection({ Name = "Desync", Position = "right" })

NeverLose.Desync = NeverLose.Desync or { active = nil, installed = false, knockback = true, ragdoll = true, selfHit = true, lastVel = nil, acc = 0, distance = 300, mode = "Offset", direction = Vector3.new(1, 0, 0), flipAt = 0, lastReal = 0 }

local function DesyncGetRemote()
    local ok, remotes = pcall(function() return ReplicatedStorage.Remotes.Replication end)
    if ok and remotes then
        return remotes:FindFirstChild("FullCustomReplicationUnreliable")
    end
    return nil
end

local function DesyncGetCombatRemote()
    local ok, remotes = pcall(function() return ReplicatedStorage.Remotes.Combat end)
    if ok and remotes then
        return remotes:FindFirstChild("Action")
    end
    return nil
end

local function DesyncGetAbilityRemote()
    local ok, remotes = pcall(function() return ReplicatedStorage.Remotes.Abilities end)
    if ok and remotes then
        return remotes:FindFirstChild("Ability")
    end
    return nil
end

local function DesyncFakeCFrame(state, hrp)
    local mode = state.mode
    local distance = state.distance
    if desyncModeDropdown then pcall(function() mode = desyncModeDropdown:GetValue() end) end
    if desyncDistanceSlider then pcall(function() distance = desyncDistanceSlider:GetValue() end) end
    local cf = hrp.CFrame
    if mode == "Below" then
        return cf + Vector3.new(0, -distance, 0)
    elseif mode == "Void" then
        return cf + Vector3.new(9e9, 90000, 9e9)
    end
    local now = os.clock()
    if now >= state.flipAt then
        state.direction = Vector3.new(math.cos(now * 1.7), 0, math.sin(now * 1.7)).Unit
        state.flipAt = now + 0.35
    end
    return cf + state.direction * distance
end

local function DesyncRevealTime()
    local value = 0.12
    if desyncRevealSlider then
        pcall(function() value = (desyncRevealSlider:GetValue() or 12) / 100 end)
    end
    return value
end

local function DesyncFlood()
    local state = NeverLose.Desync.active
    if not state then return end
    if state.revealUntil and os.clock() < state.revealUntil then return end
    if desyncSyncToggle then
        local syncOn = false
        pcall(function() syncOn = desyncSyncToggle:GetValue() and true or false end)
        if syncOn then return end
    end
    local remote = DesyncGetRemote()
    if not remote then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not hrp.Parent then return end
    local ok, serverTime = pcall(function() return workspace:GetServerTimeNow() end)
    if not ok then serverTime = 0 end
    local fake = DesyncFakeCFrame(state, hrp)
    pcall(function() remote:FireServer(serverTime, fake, false, nil, char) end)
end

local function DesyncSendReal()
    local remote = DesyncGetRemote()
    if not remote then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not hrp.Parent then return end
    local ok, serverTime = pcall(function() return workspace:GetServerTimeNow() end)
    if not ok then serverTime = 0 end
    pcall(function() remote:FireServer(serverTime, hrp.CFrame, false, nil, char) end)
end

local function DesyncRewritePayload(payload, hrp)
    if type(payload) ~= "table" then return end
    local real = hrp.CFrame
    local pos = real.Position
    local state = NeverLose.Desync.active
    local fakePos = nil
    if state then
        local ok, fake = pcall(DesyncFakeCFrame, state, hrp)
        if ok and typeof(fake) == "CFrame" then
            fakePos = fake.Position
        end
    end
    local function isMine(cf)
        if typeof(cf) ~= "CFrame" then return false end
        local p = cf.Position
        if (p - pos).Magnitude < 80 then return true end
        if fakePos and (p - fakePos).Magnitude < 200 then return true end
        return false
    end
    if payload.FromCFrame == nil or isMine(payload.FromCFrame) then
        payload.FromCFrame = real
    end
    local boxes = payload.HitboxCFrames
    if type(boxes) == "table" then
        for i = 1, #boxes do
            if isMine(boxes[i]) then boxes[i] = real end
        end
    end
    local info = payload.CustomInfo
    if type(info) == "table" then
        if isMine(info.CFrame) then info.CFrame = real end
        if isMine(info.ProjectileCFrame) then info.ProjectileCFrame = real end
    end
    local hitInfo = payload.HitInfo
    if type(hitInfo) == "table" then
        if isMine(hitInfo.CFrame) then hitInfo.CFrame = real end
    end
    if isMine(payload.RockCFrame) then payload.RockCFrame = real end
end

local function DesyncInstall()
    if NeverLose.Desync.installed then return end
    local mt = getrawmetatable(game)
    if not mt or not mt.__namecall then return end
    NeverLose.Desync.oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local state = NeverLose.Desync.active
        if state and NeverLose.Desync.selfHit then
            local method = getnamecallmethod()
            if method == "FireServer" then
                if self == DesyncGetCombatRemote() then
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp.Parent then
                        local packed = table.pack(...)
                        for i = 1, packed.n do
                            if type(packed[i]) == "table" then
                                pcall(DesyncRewritePayload, packed[i], hrp)
                            end
                        end
                    end
                    state.revealUntil = os.clock() + DesyncRevealTime()
                    DesyncSendReal()
                    task.delay(DesyncRevealTime(), function()
                        if NeverLose.Desync.active == state then
                            state.revealUntil = 0
                            DesyncFlood()
                        end
                    end)
                elseif self == DesyncGetAbilityRemote() then
                    state.revealUntil = os.clock() + DesyncRevealTime()
                    DesyncSendReal()
                    local result = NeverLose.Desync.oldNamecall(self, ...)
                    task.delay(DesyncRevealTime(), function()
                        if NeverLose.Desync.active == state then
                            state.revealUntil = 0
                            DesyncFlood()
                        end
                    end)
                    return result
                end
            end
        end
        return NeverLose.Desync.oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
    NeverLose.Desync.installed = true
end

DesyncInstall()

local function DesyncImmunity()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and NeverLose.Desync.ragdoll then
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
        if hum:GetState() == Enum.HumanoidStateType.FallingDown then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if NeverLose.Desync.ragdoll then
        pcall(function()
            if root:GetAttribute("Ragdoll") then root:SetAttribute("Ragdoll", false) end
            if char:GetAttribute("Ragdoll") then char:SetAttribute("Ragdoll", false) end
            if root:GetAttribute("Knockback") then root:SetAttribute("Knockback", false) end
        end)
    end
    if not NeverLose.Desync.knockback then return end
    local vel = root.AssemblyLinearVelocity
    local flat = Vector3.new(vel.X, 0, vel.Z)
    local prev = NeverLose.Desync.lastVel
    if prev then
        local delta = (flat - Vector3.new(prev.X, 0, prev.Z)).Magnitude
        if flat.Magnitude > 90 and delta > 60 and flat.Magnitude > 0.01 then
            local dir = flat.Unit
            pcall(function() root.AssemblyLinearVelocity = Vector3.new(dir.X * 85, vel.Y, dir.Z * 85) end)
            vel = root.AssemblyLinearVelocity
        end
    end
    if vel.Y < -80 then
        pcall(function() root.AssemblyLinearVelocity = Vector3.new(vel.X, -80, vel.Z) end)
    end
    NeverLose.Desync.lastVel = vel
end

if NeverLose.DesyncLoop then
    pcall(function() NeverLose.DesyncLoop:Disconnect() end)
    NeverLose.DesyncLoop = nil
end
NeverLose.Desync.active = nil
NeverLose.Desync.knockback = true
NeverLose.Desync.ragdoll = true
NeverLose.Desync.selfHit = true
NeverLose.Desync.lastVel = nil
NeverLose.Desync.acc = 0
NeverLose.DesyncLoop = RunService.Heartbeat:Connect(function()
    if not NeverLose.Desync.active then return end
    local acc = NeverLose.Desync.acc + 1
    if acc < 3 then NeverLose.Desync.acc = acc return end
    NeverLose.Desync.acc = 0
    pcall(DesyncFlood)
    pcall(DesyncImmunity)
end)

LocalPlayer.CharacterAdded:Connect(function()
    NeverLose.Desync.lastVel = nil
end)

desyncToggle = DesyncSection:AddToggle({
    Text = "Desync",
    Default = false,

    Callback = function(Value)
        if Value then
            NeverLose.Desync.active = {
                mode = NeverLose.Desync.mode,
                distance = NeverLose.Desync.distance,
                direction = NeverLose.Desync.direction,
                flipAt = 0,
                lastReal = 0,
                revealUntil = 0,
                sync = NeverLose.Desync.sync,
            }
            NeverLose.Desync.lastVel = nil
            pcall(DesyncImmunity)
        else
            NeverLose.Desync.active = nil
            NeverLose.Desync.lastVel = nil
        end
    end,
})
desyncToggle:ToolTip("Sends extra fake positions to the server, incoming hits and abilities miss, yours still land")

desyncModeDropdown = DesyncSection:AddDropdown({
    Text = "Desync Method",
    Default = "Void",
    Options = { "Void", "Offset", "Below" },
})
desyncModeDropdown:ToolTip("Void is the safest fake position, Offset rotates it, Below hides you under the map")

desyncDistanceSlider = DesyncSection:AddSlider({
    Text = "Desync Distance",
    Default = 300,
    Min = 50,
    Max = 1200,
    Rounding = 10,
})
desyncDistanceSlider:ToolTip("How far the fake position is from your real one")

desyncRevealSlider = DesyncSection:AddSlider({
    Text = "Reveal Time",
    Default = 12,
    Min = 5,
    Max = 40,
    Rounding = 1,
})
desyncRevealSlider:ToolTip("How long your real position stays revealed when you activate an ability, in hundredths of a second. Attacks no longer use this window")

desyncSyncToggle = DesyncSection:AddToggle({
    Text = "Keep Sync",
    Default = false,

    Callback = function(Value)
        NeverLose.Desync.sync = Value and true or false
    end,
})
desyncSyncToggle:ToolTip("Sends the real position every 0.5s so the game stops correcting you, but you can be hit in that window")

desyncSelfHitToggle = DesyncSection:AddToggle({
    Text = "Let Me Hit",
    Default = true,

    Callback = function(Value)
        NeverLose.Desync.selfHit = Value and true or false
    end,
})
desyncSelfHitToggle:ToolTip("Rewrites the origin inside your own attack packets to your real position, so your hits land while the server still thinks you are desynced")

desyncKnockbackToggle = DesyncSection:AddToggle({
    Text = "Block Knockback",
    Default = true,

    Callback = function(Value)
        NeverLose.Desync.knockback = Value and true or false
    end,
})
desyncKnockbackToggle:ToolTip("Cuts incoming knockback spikes and hard falls")

desyncRagdollToggle = DesyncSection:AddToggle({
    Text = "Anti Ragdoll",
    Default = true,

    Callback = function(Value)
        NeverLose.Desync.ragdoll = Value and true or false
    end,
})
desyncRagdollToggle:ToolTip("Cancels ragdoll/knockback attributes and stands you up")

PingSection = Tabs.Legit:AddSection({ Name = "PingFreeze", Position = "right" })

FreezePingOldNamecall = nil
FreezePingItemOldNamecall = nil
FreezePingHookInstalled = false
FreezePingPingRemote = nil

function GetPingRemoteInstance()
    if FreezePingPingRemote then
        return FreezePingPingRemote
    end
    pcall(function()
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        local services = remotes and remotes:FindFirstChild("Services")
        FreezePingPingRemote = services and services:FindFirstChild("Ping")
    end)
    return FreezePingPingRemote
end

function ApplyFreezePingGameHook()
    if FreezePingOldNamecall then return end
    local mt = getrawmetatable(game)
    FreezePingOldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        if FreezePingState.active then
            local method = getnamecallmethod()
            if (method == "FireServer" or method == "InvokeServer") and self == GetPingRemoteInstance() then
                return nil
            end
            if method == "GetValue" or method == "GetInteger" or method == "GetNumber" then
                local matches = false
                pcall(function()
                    matches = typeof(self) == "Instance" and self.Name == "Data Ping"
                end)
                if matches then
                    return FreezePingState.value
                end
            end
        end
        return FreezePingOldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end

function ApplyFreezePingItemHook()
    if FreezePingItemOldNamecall then return end
    local pingItem = nil
    pcall(function()
        pingItem = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
    end)
    if not pingItem then return end
    local itemMT = getrawmetatable(pingItem)
    if not itemMT or itemMT == getrawmetatable(game) then return end
    FreezePingItemOldNamecall = itemMT.__namecall
    setreadonly(itemMT, false)
    itemMT.__namecall = newcclosure(function(self, ...)
        if FreezePingState.active then
            local m = getnamecallmethod()
            if m == "GetValue" or m == "GetInteger" or m == "GetNumber" then
                return FreezePingState.value
            end
        end
        return FreezePingItemOldNamecall(self, ...)
    end)
    setreadonly(itemMT, true)
end

function ApplyFreezePingHook()
    if FreezePingHookInstalled then return end
    ApplyFreezePingGameHook()
    ApplyFreezePingItemHook()
    FreezePingHookInstalled = true
end

FreezePingValueSlider = PingSection:AddSlider({
    Text = "Freeze Ping (Р·РЅР°С‡РµРЅРёРµ)",
    Default = 50,
    Min = 1,
    Max = 5000,
    Rounding = 0,
    Callback = function(Value)
        FreezePingState.value = math.clamp(Value, 1, 5000)
    end,
})

freezePingToggle = PingSection:AddToggle({
    Text = "Freeze Ping",
    Default = false,

    Callback = function(Value)
        if Value then
            ApplyFreezePingHook()
            FreezePingState.active = true
        else
            FreezePingState.active = false
        end
    end,
})
freezePingToggle:ToolTip("Р—Р°РјРѕСЂРѕР·РёС‚СЊ РїРёРЅРі РЅР° Р·РЅР°С‡РµРЅРёРё РёР· РїРѕР»СЏ РІС‹С€Рµ: РїРёРЅРі РЅРµ РїРѕРґРЅРёРјР°РµС‚СЃСЏ (РіР»СѓС€РёС‚ СЃРїР°Рј Ping-СЂРµРјРѕСѓС‚Р°, РєР°Рє Сѓ scramblePing) Рё РѕС‚РѕР±СЂР°Р¶Р°РµС‚СЃСЏ РєР°Рє РІРІРµРґС‘РЅРЅРѕРµ С‡РёСЃР»Рѕ")

-- ==============================================
-- AURAV2 FUNCTION
-- ==============================================

do
AuraV2Data = {
    active = false,
    running = false,
}

AuraV2DashSide = 1

AuraV2Index = 0

AuraV2UltIndex = 0

AuraV2NextUlt = 0

function AuraV2StrafeTo(cf)
    local servertime = workspace:GetServerTimeNow()
    local args = {
        servertime,
        cf,
        false,
        nil,
        [5] = LocalPlayer.Character
    }
    pcall(function()
        ReplicatedStorage.Remotes.Replication.FullCustomReplicationUnreliable:FireServer(unpack(args, 1, 5))
    end)
end

function AuraV2Attack(Target)
    local charName = GetCurrentCharacter()
    if not Target then return end
    local actionNumber = generateActionNumber()
    local randomId = math.random(100000, 999999)
    local targetChar = Target.Character
    if not targetChar then return end
    local th = targetChar:FindFirstChild("Humanoid")
    if not th then return end
    local hp = th:GetAttribute("Health")
    if hp and hp <= 0 then return end
    pcall(function()
        local targetCF = GetTargetCFrame(Target)
        local servertime = getServerTime()
        local charFolder = ReplicatedStorage:FindFirstChild("Characters") and ReplicatedStorage.Characters:FindFirstChild(charName)
        if not charFolder then return end
        local ability = charFolder:FindFirstChild(WallComboName)
        if not ability then return end
        local remoteArgs = {
            ability,
            "Characters:" .. charName .. ":" .. WallComboName,
            2,
            randomId,
            {
                HitboxCFrames = {targetCF,targetCF,targetCF,targetCF,targetCF,targetCF},
                BestHitCharacter = targetChar,
                HitCharacters = {targetChar,targetChar,targetChar},
                Ignore = {},
                DeathInfo = {},
                BlockedCharacters = {},
                HitInfo = {
                    IsFacing = true,
                    IsInFront = true
                },
                ServerTime = servertime,
                Actions = {},
                FromCFrame = targetCF
            },
            actionNumber,
            0
        }
        pcall(function()
            ReplicatedStorage.Remotes.Abilities.Ability:FireServer(ability, randomId)
        end)
        pcall(function()
            ReplicatedStorage.Remotes.Combat.Action:FireServer(unpack(remoteArgs))
        end)
    end)
end

function AuraV2Ult(Target)
    if not Target then return end
    pcall(function()
        UseAbilities(Target, "Ultimates", AuraV2UltIndex)
    end)
end

function AuraV2Tick()
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hrp then return end
        local range = 500
        if KillAuraRangeSlider and KillAuraRangeSlider:GetValue() then
            range = math.max(range, KillAuraRangeSlider:GetValue() * 2)
        end
        local Targets = filterAndSortPlayers(TargetSystem_GetPlayerNames(), range) or {}
        removePartners(Targets)
        if IgrnoreFriendsAdminAbuse and removeFriends then
            removeFriends(Targets)
        end
        local maxLimit = math.min(24, #Targets)
        if maxLimit > 0 then
            local chunk = 6
            for step = 1, chunk do
                AuraV2Index = AuraV2Index % maxLimit + 1
                local targetPlayer = Targets[AuraV2Index] and Players:FindFirstChild(Targets[AuraV2Index])
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local tRoot = targetPlayer.Character.HumanoidRootPart
                    AuraV2DashSide = -AuraV2DashSide
                    AuraV2StrafeTo(tRoot.CFrame * CFrame.Angles(0, math.rad(90 * AuraV2DashSide), 0) * CFrame.new(0, 0, 6))
                    AuraV2Attack(targetPlayer)
                    if tick() >= AuraV2NextUlt then
                        AuraV2UltIndex = AuraV2UltIndex % 4 + 1
                        AuraV2Ult(targetPlayer)
                        AuraV2NextUlt = tick() + 0.35
                    end
                end
            end
        end
    end)
end

function AuraV2Cycle()
    if AuraV2Data.running then return end
    AuraV2Data.running = true
    while AuraV2Data.active do
        AuraV2Tick()
        task.wait()
    end
    AuraV2Data.running = false
end

function StartAuraV2()
    if AuraV2Data.active then return end
    AuraV2Data.active = true
    task.spawn(AuraV2Cycle)
    print("AuraV2: ON")
end

function StopAuraV2()
    AuraV2Data.active = false
    AuraV2Data.running = false
    print("AuraV2: OFF")
end
end

-- ==============================================
-- РљРћРќР•Р¦ AURAV2
-- ==============================================

ExtraSlidersSection = Tabs.Extra:AddSection({ Name = "ExtraSliders", Position = "left" })
SpeedHackSlider = ExtraSlidersSection:AddSlider({
    Text = "Speed Multiplier",
    Default = 1,
    Min = 1,
    Max = 4,
    Rounding = 0,
})

speedConnection = nil

function toggleSpeed(state)
    local character = LocalPlayer.Character
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    if state then
        if character and humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            humanoid.PlatformStand = false
        end
        speedConnection = RunService.Heartbeat:Connect(function()
            if character and rootPart then
                local moveDirection = humanoid.MoveDirection * SpeedHackSlider:GetValue()
                rootPart.CFrame = rootPart.CFrame + moveDirection
            end
        end)
    else
        if speedConnection then speedConnection:Disconnect(); speedConnection = nil end
        if character and humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
            humanoid.PlatformStand = false
        end
    end
end

speedHackToggleLib = ExtraSlidersSection:AddToggle({
    Text = "SpeedHack",
    Default = false,

    Callback = function(Value)
        toggleSpeed(Value)
    end,
})
speedHackToggleLib:ToolTip("self explanatory")

ExtraButtonsSection = Tabs.Extra:AddSection({ Name = "ExtraButtons", Position = "right" })

if not _G.CurrentScriptID then
    _G.CurrentScriptID = math.random(100000, 999999)
end
myScriptID = _G.CurrentScriptID

autoExecuteToggleLib = ExtraButtonsSection:AddToggle({
    Text = "auto exeute on telport",
    Default = false,

    Callback = function(Value)      
        if writefile then
            writefile("AutoExecuteConfig.txt", tostring(Value))
        end
        local queue = syn and syn.queue_on_teleport or queue_on_teleport
        if Value == false then
            if _G.ActiveQueueOwner == myScriptID then
                _G.ActiveQueueOwner = nil
            end
        end
        if queue and Value == true and _G.ActiveQueueOwner == nil then
            _G.ActiveQueueOwner = myScriptID
            local queuePayload = [[
                local nextQueue = syn and syn.queue_on_teleport or queue_on_teleport
                if isfile and isfile("AutoExecuteConfig.txt") then
                    local savedState = readfile("AutoExecuteConfig.txt")
                    if savedState == "true" then
                        if nextQueue then
                            nextQueue(...)
                        end
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/wolf950xx/blablablabl/refs/heads/main/scriptttt2"))()
                    end
                end
            ]]
            queue(string.format("local payload = %q\n%s", queuePayload, queuePayload:gsub("nextQueue%(%.%.%.%)", "nextQueue(payload)")))
        end
    end,
})
autoExecuteToggleLib:ToolTip("makes the script auto exeute on telport")

autoblockActive = false

autoBlockToggleLib = ExtraButtonsSection:AddToggle({
    Text = "auto block",
    Default = false,

    Callback = function(Value)
        local remoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Block")
        autoblockActive = Value
        if Value then
            task.spawn(function()
                while autoblockActive do
                    pcall(function()
                        remoteEvent:FireServer(true)
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end,
})
autoBlockToggleLib:ToolTip("makes you always block even while m1ing")

scramblePingActive = false

scramblePingToggleLib = ExtraButtonsSection:AddToggle({
    Text = "scramblePing",
    Default = false,

    Callback = function(Value)
        scramblePingActive = Value
        if scramblePingActive then
            task.spawn(function()
                while scramblePingActive do
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Services"):WaitForChild("Ping"):FireServer()
                    end)
                    task.wait(0) 
                end
            end)
        end
    end,
})
scramblePingToggleLib:ToolTip("gives you aura by making your ping skyrocket")

multipliers = ReplicatedStorage.Settings.Multipliers

fastM1sToggleLib = ExtraButtonsSection:AddToggle({
    Text = "faster m1s", 
    Default = false, 
    Callback = function(Value) 
        multipliers.MeleeSpeed.Value = Value and 135 or 100 
    end,
})
fastM1sToggleLib:ToolTip("makes your m1 faster for trolling")

noStunToggleLib = ExtraButtonsSection:AddToggle({
    Text = "No stun", 
    Default = false, 
    Callback = function(Value) 
        ReplicatedStorage.Settings.Toggles.DisableHitStun.Value = Value 
    end,
})
noStunToggleLib:ToolTip("self explanatory")

longerUltimateToggleLib = ExtraButtonsSection:AddToggle({
    Text = "Longer Ultimate", 
    Default = false, 
    Callback = function(Value) 
        ReplicatedStorage.Settings.Toggles.Endless.Value = Value 
    end,
})
longerUltimateToggleLib:ToolTip("self explanatory")

instantUltimateToggleLib = ExtraButtonsSection:AddToggle({
    Text = "instant Ultimate", 
    Default = false, 
    Callback = function(Value) 
        ReplicatedStorage.Settings.Toggles.InstantTransformation.Value = Value 
    end,
})
instantUltimateToggleLib:ToolTip("skips the animation of the Ultimate")

noSlowDownsToggleLib = ExtraButtonsSection:AddToggle({
    Text = "No SlowDowns", 
    Default = false, 
    Callback = function(Value) 
        ReplicatedStorage.Settings.Toggles.NoSlowdowns.Value = Value 
    end,
})
noSlowDownsToggleLib:ToolTip("self explanatory")

noStunOnMissToggleLib = ExtraButtonsSection:AddToggle({
    Text = "No StunOnMiss", 
    Default = false, 
    Callback = function(Value) 
        ReplicatedStorage.Settings.Toggles.NoStunOnMiss.Value = Value 
    end,
})
noStunOnMissToggleLib:ToolTip("self explanatory")

autoRagdollToggleLib = ExtraButtonsSection:AddToggle({
    Text = "Auto Ragdoll", 
    Default = false, 
    Callback = function(Value) 
        multipliers.MeleeDamage.Value = Value and 10000000 or 100 
    end,
})
autoRagdollToggleLib:ToolTip("ragdolls on any M1")

voidKillToggleLib = ExtraButtonsSection:AddToggle({
    Text = "Void kill", 
    Default = false, 
    Callback = function(Value) 
        if Value then
            multipliers.RagdollPower.Value = 999999
            multipliers.KnockbackPower.Value = 10000
        else
            multipliers.RagdollPower.Value = 100
            multipliers.KnockbackPower.Value = 100
        end 
    end,
})
voidKillToggleLib:ToolTip("Any thing that ragdolls sends to the void")

autoClaimEmoteToggleLib = ExtraButtonsSection:AddToggle({
    Text = "Auto Claim Emote", 
    Default = false, 
    Callback = function(Value) 
        if Value then
            task.spawn(function()
                local Event = game:GetService("ReplicatedStorage").Remotes.Combat.EmoteClaim
                while Value do
                    pcall(function()
                        Event:FireServer()
                    end)
                    task.wait(1)
                end
            end)
        end
    end,
})
autoClaimEmoteToggleLib:ToolTip("self explanatory")

ExtraButtonsSection:AddButton({ Name = "ResetCharacter", Callback = function()
    resetCharacterForced()
end })

ExtraButtonsSection:AddButton({ Name = "RejoinServer", Callback = function()
    rejoinCurrentServer()
end })

-- ==============================================
-- VISUAL TAB UI
-- ==============================================

VisualSection = Tabs.Visual:AddSection({ Name = "VisualEffects", Position = "left" })
VisualSettingsSection = Tabs.Visual:AddSection({ Name = "VisualSettings", Position = "right" })

function showNotification(title, message)
    pcall(function()
        print(("[" .. tostring(title) .. "] " .. tostring(message)))
    end)
end

AuraSection = VisualSection

auraTypeDropdown = AuraSection:AddDropdown({
    Text = "Aura Type",
    Values = { "None", "Gon", "Mob", "Nanami", "Sukuna" },
    Default = "None",
    Multi = false,
    Callback = function(Value)
        AuraSystem.ApplyAura(Value)
    end,
})

AuraColorMap = {
    Yellow = Color3.fromRGB(255, 200, 60), -- РґРµС„РѕР»С‚, РєР°Рє РЅР° СЃРєСЂРёРЅРµ
    Cyan   = Color3.fromRGB(90, 208, 255),
    Purple = Color3.fromRGB(170, 80, 255),
    Red    = Color3.fromRGB(255, 50, 50),
    Green  = Color3.fromRGB(50, 255, 100),
    Pink   = Color3.fromRGB(255, 100, 200),
    Orange = Color3.fromRGB(255, 140, 40),
    White  = Color3.fromRGB(255, 255, 255),
    Blue   = Color3.fromRGB(50, 100, 255),
    Black  = Color3.fromRGB(80, 0, 120),
}

AuraColorDropdown = AuraSection:AddDropdown({
    Text = "Aura Color",
    Values = { "Yellow", "Cyan", "Purple", "Red", "Green", "Pink", "Orange", "White", "Blue", "Black" },
    Default = "Yellow",
    Multi = false,
    Callback = function(Value)
        local c = AuraColorMap[Value]
        if c then
            Cfg.AuraColor = c
            if not Cfg.RainbowAura then
                AuraSystem.RecolorAuras(c)
            end
        end
    end,
})

AuraColorPicker = AuraSection:AddColorPicker({
    Name = "Aura Color Picker",
    Default = Color3.fromRGB(255, 200, 60),
    Callback = function(color)
        Cfg.AuraColor = color
        if not Cfg.RainbowAura then
            AuraSystem.RecolorAuras(color)
        end
    end,
})

rainbowAuraToggleLib = AuraSection:AddToggle({
    Text = "Rainbow Aura",
    Default = false,

    Callback = function(Value)
        AuraSystem.SetRainbow(Value)
    end,
})
rainbowAuraToggleLib:ToolTip("РњРµРґР»РµРЅРЅРѕ РїРµСЂРµР»РёРІР°РµС‚ Р°СѓСЂСѓ РІСЃРµРјРё С†РІРµС‚Р°РјРё СЂР°РґСѓРіРё")

AuraSection:AddButton({ Name = "Reset to Default Colors", Callback = function()
    AuraSystem.ResetAurasToDefault()
    showNotification("Aura System", "Aura colors reset to default!")
end })

atmosphereToggleLib = VisualSection:AddToggle({
    Text = "Atmosphere",
    Default = false,

    Callback = function(Value)
        if Value then
            StartAtmosphere()
        else
            StopAtmosphere()
        end
    end,
})
atmosphereToggleLib:ToolTip("Beautiful atmosphere with bloom and color correction")

-- Р”СЂРѕРїРґР°СѓРЅ РІС‹Р±РѕСЂР° С†РІРµС‚Р° Р°С‚РјРѕСЃС„РµСЂС‹ (РєР°Рє Сѓ Aura Color)
AtmosphereColorDropdown = VisualSection:AddDropdown({
    Text = "Atmosphere Color",
    Values = { "Purple", "Blue", "Cyan", "Red", "Green", "Orange", "Pink", "White", "Night", "Sunset" },
    Default = "Purple",
    Multi = false,
    Callback = function(Value)
        local c = AtmosphereColorMap[Value]
        if c then
            applyAtmosphereColor(c)
        end
    end,
})

trailsToggleLib = VisualSection:AddToggle({
    Text = "Neon Trails",
    Default = false,

    Callback = function(Value)
        if Value then
            StartTrails()
        else
            StopTrails()
        end
    end,
})
trailsToggleLib:ToolTip("Shows neon trails on your character")

-- Р”СЂРѕРїРґР°СѓРЅ РІС‹Р±РѕСЂР° С†РІРµС‚Р° С‚СЂРµР№Р»РѕРІ (РєР°Рє Сѓ Aura Color)
TrailColorMap = {
    Cyan   = Color3.fromRGB(90, 208, 255),
    Purple = Color3.fromRGB(170, 80, 255),
    Red    = Color3.fromRGB(255, 50, 50),
    Green  = Color3.fromRGB(50, 255, 100),
    Pink   = Color3.fromRGB(255, 100, 200),
    Orange = Color3.fromRGB(255, 160, 50),
    White  = Color3.fromRGB(255, 255, 255),
    Blue   = Color3.fromRGB(50, 100, 255),
}

TrailColorDropdown = VisualSection:AddDropdown({
    Text = "Trail Color",
    Values = { "Cyan", "Purple", "Red", "Green", "Pink", "Orange", "White", "Blue" },
    Default = "Cyan",
    Multi = false,
    Callback = function(Value)
        local c = TrailColorMap[Value]
        if c then
            applyTrailColor(c)
        end
    end,
})

hpIndicatorToggleLib = VisualSection:AddToggle({
    Text = "HP Indicators",
    Default = false,

    Callback = function(Value)
        if Value then
            StartHPIndicators()
        else
            StopHPIndicators()
        end
    end,
})
hpIndicatorToggleLib:ToolTip("Shows HP bars above all players")

particlesToggleLib = VisualSection:AddToggle({
    Text = "Particles",
    Default = false,

    Callback = function(Value)
        if Value then
            StartParticles()
        else
            StopParticles()
        end
    end,
})
particlesToggleLib:ToolTip("РЎРІРµС‚Р»СЏС‡РєРё, Р»РµС‚Р°СЋС‰РёРµ РІРѕРєСЂСѓРі РїРµСЂСЃРѕРЅР°Р¶Р°")

-- Р”СЂРѕРїРґР°СѓРЅ РІС‹Р±РѕСЂР° С†РІРµС‚Р° СЃРІРµС‚Р»СЏС‡РєРѕРІ
ParticleColorDropdown = VisualSection:AddDropdown({
    Text = "Particles Color",
    Values = { "Warm", "Cyan", "Purple", "Green", "Pink", "Red", "White", "Blue" },
    Default = "Warm",
    Multi = false,
    Callback = function(Value)
        applyParticleColor(Value)
    end,
})

VisualSettingsSection:AddButton({ Name = "Spawn Snowflakes", Callback = function()
    CreateSnowflakes()
end })

VSXVisual = {}

do
    local Players = game:GetService("Players")
    local ReplicatedStorageService = game:GetService("ReplicatedStorage")
    local Plr = Players.LocalPlayer

    local DEFS = {
        [1] = { Name = "Rock", Label = "Rock Visual", Color = Color3.fromRGB(158, 160, 168), Shadow = Color3.fromRGB(18, 19, 24) },
        [2] = { Name = "Paper", Label = "Paper Visual", Color = Color3.fromRGB(238, 236, 226), Shadow = Color3.fromRGB(58, 60, 68) },
        [3] = { Name = "Scissors", Label = "Scissors Visual", Color = Color3.fromRGB(120, 216, 255), Shadow = Color3.fromRGB(16, 44, 60) },
        [4] = { Name = "Rod", Label = "Rod Visual", Color = Color3.fromRGB(219, 138, 58), Shadow = Color3.fromRGB(52, 28, 10) },
        [5] = { Name = "Dash", Label = "Front Dash", Color = Color3.fromRGB(150, 210, 255), Shadow = Color3.fromRGB(14, 32, 52) },
    }

    local EXTRA_ROOTS = {
        [5] = { Dash = true },
    }

    local State = {
        Enabled = { [1] = false, [2] = false, [3] = false, [4] = false, [5] = false },
        Color = {},
        Shadows = true,
        ShadowTransparency = 0.55,
        LastIndex = 1,
        DashWindow = 0,
    }
    for i = 1, 5 do State.Color[i] = DEFS[i].Color end

    local Roots = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {} }
    local Names = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {} }
    local Active = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {} }
    local Hot = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {} }
    local Touched = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {} }
    local ShadowParts = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {} }
    local Originals = {}
    local WatchedRoots = {}
    local BoundCharacter = nil
    local EffectsFolder = nil

    local function isColorable(inst)
        return inst:IsA("ParticleEmitter") or inst:IsA("Beam") or inst:IsA("Trail")
            or inst:IsA("PointLight") or inst:IsA("SpotLight") or inst:IsA("SurfaceLight")
            or inst:IsA("Highlight") or inst:IsA("BasePart") or inst:IsA("ImageLabel")
    end

    local function usableName(name)
        if #name < 2 then return false end
        if string.match(name, "^%d+$") then return false end
        return true
    end

    local function insideAura(inst)
        if not AuraSystem or not AuraSystem.IsAura then return false end
        local character = Plr.Character
        local cur = inst
        while cur and cur ~= character do
            if AuraSystem.IsAura(cur) then return true end
            cur = cur.Parent
        end
        return false
    end

    local function isCharacterPart(inst)
        if not inst:IsA("BasePart") then return false end
        local character = Plr.Character
        return character ~= nil and inst:IsDescendantOf(character)
    end

    local function insideVFX(inst)
        local cur = inst
        while cur do
            if insideAura(cur) then return true end
            if cur.Name == "VFX" then return true end
            cur = cur.Parent
        end
        return false
    end

    local function saveOriginal(inst)
        if Originals[inst] or not isColorable(inst) then return end
        local data = {}
        if inst:IsA("Highlight") then
            data.FillColor = inst.FillColor
            data.FillTransparency = inst.FillTransparency
            data.OutlineColor = inst.OutlineColor
            data.OutlineTransparency = inst.OutlineTransparency
            data.DepthMode = inst.DepthMode
            data.Enabled = inst.Enabled
        elseif inst:IsA("BasePart") then
            data.Color = inst.Color
            data.CastShadow = inst.CastShadow
            data.Transparency = inst.Transparency
        elseif inst:IsA("ImageLabel") then
            data.ImageColor3 = inst.ImageColor3
            data.ImageTransparency = inst.ImageTransparency
        else
            data.Color = inst.Color
        end
        Originals[inst] = data
    end

    local function restoreInstance(inst, saved)
        if not saved or not inst.Parent then return end
        if inst:IsA("Highlight") then
            inst.FillColor = saved.FillColor
            inst.FillTransparency = saved.FillTransparency
            inst.OutlineColor = saved.OutlineColor
            inst.OutlineTransparency = saved.OutlineTransparency
            inst.DepthMode = saved.DepthMode
            inst.Enabled = saved.Enabled
        elseif inst:IsA("BasePart") then
            inst.Color = saved.Color
            inst.CastShadow = saved.CastShadow
            inst.Transparency = saved.Transparency
        elseif inst:IsA("ImageLabel") then
            inst.ImageColor3 = saved.ImageColor3
            inst.ImageTransparency = saved.ImageTransparency
        else
            inst.Color = saved.Color
        end
    end

    local function paintInstance(inst, index)
        local def = DEFS[index]
        local color = State.Color[index]
        local shadow = def.Shadow
        local withShadow = State.Shadows
        pcall(function()
            if insideAura(inst) then return end
            if inst:IsA("ParticleEmitter") or inst:IsA("Beam") or inst:IsA("Trail") then
                inst.Color = ColorSequence.new(color)
                if inst:IsA("ParticleEmitter") then
                    inst.LightEmission = withShadow and 0.15 or 0.7
                    inst.LightInfluence = withShadow and 1 or 0
                else
                    inst.LightInfluence = withShadow and 1 or 0
                end
            elseif inst:IsA("PointLight") or inst:IsA("SpotLight") or inst:IsA("SurfaceLight") then
                inst.Color = color
                inst.Shadows = withShadow
                inst.Brightness = withShadow and 0.8 or 1.5
            elseif inst:IsA("Highlight") then
                inst.FillColor = withShadow and color:Lerp(shadow, 0.5) or color
                inst.FillTransparency = withShadow and State.ShadowTransparency or 0.9
                inst.OutlineColor = withShadow and shadow or color
                inst.OutlineTransparency = withShadow and math.max(0, State.ShadowTransparency - 0.3) or 0.4
            elseif inst:IsA("BasePart") then
                if isCharacterPart(inst) and not insideVFX(inst) then return end
                inst.Color = withShadow and color:Lerp(shadow, 0.25) or color
                inst.CastShadow = withShadow
            elseif inst:IsA("ImageLabel") then
                inst.ImageColor3 = color
            end
        end)
    end

    local function hostPart(inst)
        local cur = inst
        while cur and cur ~= workspace do
            if cur:IsA("BasePart") then return cur end
            cur = cur.Parent
        end
        return nil
    end

    local function ensureShadow(index, part)
        if not State.Shadows or ShadowParts[index][part] then return end
        if isCharacterPart(part) then return end
        if insideAura(part) then return end
        local ok, highlight = pcall(function()
            local h = Instance.new("Highlight")
            h.Name = "VSXShadow_" .. index
            h.Adornee = part
            h.DepthMode = Enum.HighlightDepthMode.Occluded
            h.FillColor = DEFS[index].Shadow
            h.OutlineColor = DEFS[index].Shadow
            h.FillTransparency = State.ShadowTransparency
            h.OutlineTransparency = math.max(0, State.ShadowTransparency - 0.3)
            h.Parent = part
            return h
        end)
        if ok and highlight then ShadowParts[index][part] = highlight end
    end

    local function paintTree(root, index)
        if isColorable(root) then
            saveOriginal(root)
            paintInstance(root, index)
            if root:IsA("BasePart") and not State.Shadows then
                root.CastShadow = false
            end
        end
        for _, child in ipairs(root:GetChildren()) do
            paintTree(child, index)
        end
    end

    local function restoreTree(root)
        if isColorable(root) then
            restoreInstance(root, Originals[root])
        end
        for _, child in ipairs(root:GetChildren()) do
            restoreTree(child)
        end
    end

    local function collectNames()
        local outRoots = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {} }
        local outNames = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {} }
        for name in pairs(EXTRA_ROOTS[5]) do
            outRoots[5][name] = true
        end
        local charName = GetCurrentCharacter() or "Gon"
        local characters = ReplicatedStorageService:FindFirstChild("Characters")
        local charFolder = characters and characters:FindFirstChild(charName)
        if not charFolder then return outRoots, outNames end
        for _, folderName in ipairs({ "Abilities", "Ultimates" }) do
            local folder = charFolder:FindFirstChild(folderName)
            if folder then
                for index = 1, 5 do
                    local ability = folder:FindFirstChild(tostring(index))
                    if ability then
                        for _, child in ipairs(ability:GetChildren()) do
                            if usableName(child.Name) then outRoots[index][child.Name] = true end
                        end
                        local ok, list = pcall(function() return ability:GetDescendants() end)
                        if ok then
                            for _, d in ipairs(list) do
                                if usableName(d.Name) then outNames[index][d.Name] = true end
                            end
                        end
                    end
                end
            end
        end
        return outRoots, outNames
    end

    local function refreshTemplates()
        Roots, Names = collectNames()
    end

    local function findEffectsFolder()
        local misc = workspace:FindFirstChild("Misc")
        if misc then
            local folder = misc:FindFirstChild("Effects")
            if folder then return folder end
        end
        local direct = workspace:FindFirstChild("Effects")
        if direct then return direct end
        local vfx = workspace:FindFirstChild("VFX")
        return vfx
    end

    local function trackEffect(root, index)
        Touched[index][root] = true
        Active[index][root] = true
        Hot[index][root] = tick() + 3
        pcall(function() paintTree(root, index) end)
    end

    local DASH_MARKERS = {
        DustOut = true, WindRing = true, WindBurst = true,
        WindCircle = true, TornadoFade = true,
    }

    local DashBusy = setmetatable({}, { __mode = "k" })

    local function isDashEffect(root)
        local ok, list = pcall(function() return root:GetDescendants() end)
        if not ok then return false end
        for _, d in ipairs(list) do
            if DASH_MARKERS[d.Name] then return true end
        end
        return false
    end

    local function flatDirection(root)
        local character = Plr.Character
        if not character then return nil end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local move = humanoid.MoveDirection
            local flat = Vector3.new(move.X, 0, move.Z)
            if flat.Magnitude > 0.1 then return flat.Unit end
        end
        local velocity = root.AssemblyLinearVelocity
        local flat = Vector3.new(velocity.X, 0, velocity.Z)
        if flat.Magnitude > 0.5 then return flat.Unit end
        return nil
    end

    local function paintCharacterDash()
        local character = Plr.Character
        local painted = {}
        if not character then return painted end
        local ok, list = pcall(function() return character:GetDescendants() end)
        if not ok then return painted end
        for _, d in ipairs(list) do
            if not insideAura(d) then
                if d:IsA("Trail") or d:IsA("Beam") or d:IsA("ParticleEmitter")
                    or d:IsA("PointLight") or d:IsA("SpotLight") or d:IsA("SurfaceLight") then
                    trackEffect(d, 5)
                    table.insert(painted, d)
                end
            end
        end
        return painted
    end

    local function trackDash(root)
        local character = Plr.Character
        local part = character and character:FindFirstChild("HumanoidRootPart")
        if not part then return end
        local startPos = part.Position
        local paintedRoots = {}
        local paintedInsts = {}

        if root.Parent then
            trackEffect(root, 5)
            paintedRoots[root] = true
            for inst in pairs(Touched[5]) do paintedInsts[inst] = true end
        end
        State.DashWindow = tick() + 1.5
        for _, inst in ipairs(paintCharacterDash()) do
            paintedInsts[inst] = true
        end

        local verdict = nil
        for step = 1, 10 do
            if step > 1 then task.wait(0.02) end
            local look = part.CFrame.LookVector
            local flatLook = Vector3.new(look.X, 0, look.Z)
            if flatLook.Magnitude > 0.01 then
                flatLook = flatLook.Unit
                local direction = flatDirection(part)
                if direction then
                    local dot = direction:Dot(flatLook)
                    if dot > 0.25 then
                        verdict = "forward"
                        break
                    elseif dot < -0.25 then
                        verdict = "backward"
                        break
                    end
                end
                local delta = part.Position - startPos
                local flatDelta = Vector3.new(delta.X, 0, delta.Z)
                if flatDelta.Magnitude > 0.35 then
                    verdict = flatDelta:Dot(flatLook) > 0 and "forward" or "backward"
                    break
                end
            end
        end

        if verdict ~= "backward" then return end
        for inst in pairs(paintedInsts) do
            pcall(function() restoreInstance(inst, Originals[inst]) end)
        end
        for rootPart in pairs(paintedRoots) do
            pcall(function() restoreTree(rootPart) end)
            local ok, list = pcall(function() return rootPart:GetDescendants() end)
            if ok then
                for _, d in ipairs(list) do
                    if d:IsA("BasePart") and ShadowParts[5][d] then
                        local hl = ShadowParts[5][d]
                        if hl and hl.Parent then hl:Destroy() end
                        ShadowParts[5][d] = nil
                    end
                end
            end
            Active[5][rootPart] = nil
            Hot[5][rootPart] = nil
        end
    end

    local function handleEffectFolder(folder)
        local isDash = State.Enabled[5] and (Roots[5][folder.Name] or isDashEffect(folder))
        if not isDash then
            for index = 1, 5 do
                if Active[index][folder] then return end
            end
        else
            if DashBusy[folder] then return end
            DashBusy[folder] = true
        end
        for index = 1, 4 do
            if State.Enabled[index] and Roots[index][folder.Name] then
                State.LastIndex = index
                trackEffect(folder, index)
                return
            end
        end
        if isDash then
            task.spawn(function()
                trackDash(folder)
                DashBusy[folder] = nil
            end)
        end
    end

    local function watchEffects(folder)
        if not folder or WatchedRoots[folder] then return end
        WatchedRoots[folder] = true
        folder.ChildAdded:Connect(function(child)
            task.defer(function() handleEffectFolder(child) end)
        end)
        for _, child in ipairs(folder:GetChildren()) do
            task.defer(function() handleEffectFolder(child) end)
        end
    end

    local function shouldAdopt(inst, index)
        if not State.Enabled[index] then return false end
        if index == 5 then
            local character = Plr.Character
            if not character then return false end
            if not inst:IsDescendantOf(character) then return false end
            if AuraSystem.IsAura and AuraSystem.IsAura(inst) then return false end
            if not (inst:IsA("Trail") or inst:IsA("Beam") or inst:IsA("ParticleEmitter")
                or inst:IsA("PointLight") or inst:IsA("SpotLight") or inst:IsA("SurfaceLight")) then
        return false
    end
            return tick() <= (State.DashWindow or 0)
        end
        if not usableName(inst.Name) then return false end
        if not Names[index][inst.Name] then return false end
        if inst:IsA("Model") or inst:IsA("Folder") then return true end
        if not isColorable(inst) then return false end
        if insideVFX(inst) then return true end
        if isCharacterPart(inst) then return false end
        local character = Plr.Character
        return character ~= nil and inst:IsDescendantOf(character)
    end

    local function adopt(inst, index)
        Touched[index][inst] = true
        Active[index][inst] = true
        Hot[index][inst] = tick() + 3
        pcall(function()
            if inst:IsA("Model") or inst:IsA("Folder") then
                paintTree(inst, index)
            else
                saveOriginal(inst)
                paintInstance(inst, index)
                local part = hostPart(inst)
                if part then ensureShadow(index, part) end
            end
        end)
    end

    local function watchCharacter(character)
        character.DescendantAdded:Connect(function(inst)
            for index = 1, 5 do
                if shouldAdopt(inst, index) then
                    task.defer(function() adopt(inst, index) end)
                end
            end
        end)
    end

    local function clearIndex(index)
        for root in pairs(Active[index]) do
            pcall(function() restoreTree(root) end)
            Active[index][root] = nil
            Hot[index][root] = nil
        end
        for inst in pairs(Touched[index]) do
            restoreInstance(inst, Originals[inst])
            Touched[index][inst] = nil
        end
        for part, highlight in pairs(ShadowParts[index]) do
            if highlight and highlight.Parent then highlight:Destroy() end
            ShadowParts[index][part] = nil
        end
    end

    function VSXVisual.Set(index, value)
        State.Enabled[index] = value and true or false
        if State.Enabled[index] then
            refreshTemplates()
            if EffectsFolder then
                for _, child in ipairs(EffectsFolder:GetChildren()) do
                    handleEffectFolder(child)
                end
            end
            return
        end
        clearIndex(index)
    end

    function VSXVisual.SetColor(index, color)
        State.Color[index] = color
        for inst in pairs(Active[index]) do
            if inst.Parent then pcall(function() paintTree(inst, index) end) end
        end
        for part, highlight in pairs(ShadowParts[index]) do
            if highlight and highlight.Parent then
                pcall(function()
                    highlight.FillColor = DEFS[index].Shadow
                    highlight.OutlineColor = DEFS[index].Shadow
                    highlight.FillTransparency = State.ShadowTransparency
                    highlight.OutlineTransparency = math.max(0, State.ShadowTransparency - 0.3)
                end)
            end
        end
    end

    function VSXVisual.SetShadows(value)
        State.Shadows = value and true or false
        if not State.Shadows then
            for index = 1, 5 do
                for part, highlight in pairs(ShadowParts[index]) do
                    if highlight and highlight.Parent then highlight:Destroy() end
                    ShadowParts[index][part] = nil
                end
            end
        end
        for index = 1, 5 do
            if State.Enabled[index] then
                for inst in pairs(Active[index]) do
                    if inst.Parent then
                        pcall(function() paintTree(inst, index) end)
                        if State.Shadows then
                            local part = hostPart(inst)
                            if part then ensureShadow(index, part) end
                        end
                    end
                end
            end
        end
    end

    function VSXVisual.SetShadowStrength(percent)
        State.ShadowTransparency = 1 - (percent / 100)
        for index = 1, 5 do
            for part, highlight in pairs(ShadowParts[index]) do
                if highlight and highlight.Parent then
                    pcall(function()
                        highlight.FillTransparency = State.ShadowTransparency
                        highlight.OutlineTransparency = math.max(0, State.ShadowTransparency - 0.3)
                    end)
                end
            end
        end
    end

    function VSXVisual.Refresh()
        refreshTemplates()
        if EffectsFolder then
            for _, child in ipairs(EffectsFolder:GetChildren()) do
                handleEffectFolder(child)
            end
        end
    end

    function VSXVisual.ClearAll()
        for index = 1, 5 do
            VSXVisual.Set(index, false)
        end
    end

    VSXVisual.Defs = DEFS
    VSXVisual.Toggles = {}

    task.spawn(function()
        local tickCount = 0
        while task.wait(0.2) do
            tickCount = tickCount + 1
            local character = Plr.Character
            if character and character ~= BoundCharacter then
                BoundCharacter = character
                refreshTemplates()
                watchCharacter(character)
            end
            if not EffectsFolder then
                EffectsFolder = findEffectsFolder()
                if EffectsFolder then watchEffects(EffectsFolder) end
            end
            if EffectsFolder then
                for _, child in ipairs(EffectsFolder:GetChildren()) do
                    handleEffectFolder(child)
                end
            end
            if character then
                for index = 1, 5 do
                    if State.Enabled[index] then
                        local ok, list = pcall(function() return character:GetDescendants() end)
                        if ok then
                            for _, d in ipairs(list) do
                                if not Active[index][d] and shouldAdopt(d, index) then
                                    adopt(d, index)
                                end
                            end
                        end
                    end
                end
            end
            local now = tick()
            for index = 1, 5 do
                for inst, expiry in pairs(Hot[index]) do
                    if expiry < now then
                        Hot[index][inst] = nil
                    end
                end
                for inst in pairs(Active[index]) do
                    if not inst.Parent then
                        Active[index][inst] = nil
                        Touched[index][inst] = nil
                    elseif Hot[index][inst] or tickCount % 3 == 0 then
                        pcall(function() paintTree(inst, index) end)
                    end
                end
            end
        end
    end)
end

VSXSection = Tabs.VSX:AddSection({ Name = "VSX", Position = "left" })
VSXSettingsSection = Tabs.VSX:AddSection({ Name = "VSXSettings", Position = "right" })

for index = 1, 5 do
    local def = VSXVisual.Defs[index]
    VSXVisual.Toggles[index] = VSXSection:AddToggle({
        Text = def.Label,
        Default = false,
        Callback = function(Value)
            VSXVisual.Set(index, Value)
        end,
    })
    VSXVisual.Toggles[index]:ToolTip("Color and shadows of ability " .. index)
end

for index = 1, 5 do
    local def = VSXVisual.Defs[index]
    VSXSettingsSection:AddColorPicker({
        Text = def.Name .. " Color",
        Default = def.Color,
        Callback = function(Value)
            VSXVisual.SetColor(index, Value)
        end,
    })
end

VSXShadowsToggle = VSXSettingsSection:AddToggle({
    Text = "Shadows",
    Default = true,
    Callback = function(Value)
        VSXVisual.SetShadows(Value)
    end,
})
VSXShadowsToggle:ToolTip("Dark layer under the VSX effects")

VSXShadowSlider = VSXSettingsSection:AddSlider({
    Text = "Shadow Strength",
    Default = 45,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Type = "%",
    Callback = function(Value)
        VSXVisual.SetShadowStrength(Value)
    end,
})

VSXSettingsSection:AddButton({
    Name = "Refresh VFX",
    Callback = function()
        VSXVisual.Refresh()
    end,
})

VSXSettingsSection:AddButton({
    Name = "Clear VSX Visuals",
    Callback = function()
        VSXVisual.ClearAll()
    end,
})

VisualSettingsSection:AddLabel("======================================", false)
VisualSettingsSection:AddLabel("Keybinds: click the box next to any toggle", false)
VisualSettingsSection:AddLabel("Keylist shows your binds (Backspace = clear)", false)
VisualSettingsSection:AddLabel("======================================", false)

-- ==============================================
-- BINDS: РєРІР°РґСЂР°С‚РёРє РІРѕР·Р»Рµ РєР°Р¶РґРѕРіРѕ С‚СѓРјР±Р»РµСЂР°
-- РќР°Р·РЅР°С‡РµРЅРёРµ РєР»Р°РІРёС€Рё = СЃРѕС…СЂР°РЅСЏРµС‚СЃСЏ РІ РєРѕРЅС„РёРіРµ NeverLose
-- Р¤РёР·РёС‡РµСЃРєРѕРµ РЅР°Р¶Р°С‚РёРµ РѕС‚Р»Р°РІР»РёРІР°РµС‚СЃСЏ РІРЅРёР·Сѓ С‡РµСЂРµР· InputBegan
-- ==============================================

-- ========================================================
-- OPEN ACCESS: passes / emotes / cosmetics (ported from the
-- standalone script). Hardcoded G / H keys removed; the menus
-- are now driven by hub toggles that can be bound below.
-- ========================================================
OpenAccess = {}

do
    local OA_Players = game:GetService("Players")
    local OA_ReplicatedStorage = game:GetService("ReplicatedStorage")
    local OA_HttpService = game:GetService("HttpService")
    local OA_LocalPlayer = OA_Players.LocalPlayer

    local EMOTES = {
        Emote = {"Griddy", "Fright Funk","Aurora Miracle","Blizzard","Candy Cane Duel","Candy Cane Walk","Cold World","Gift Exchange","Ice Skating","Snow Angels","Snowball Barrage","Snowball Juggle","Snowball Throw","Snowman","Carry","Sleddies","Cocoa Cheers","Ice Trick","Nutcracker March","Popcorn","Gravedigger","Death Day","Jingle Bell Shake","Cold World","Mic Drop","Spit","T-Pose","Drag","Yawn","Facepalm","Falling Asleep","Sleepy","Calculated","Rambunctious","Sobbing","Sorcerer Stretch","Shadow Boxing","Floss","Relentless Laughing","Phone Call","Rock Paper Scissors","One-Armed Pickup","Stay Down","Push-Ups","Take the L","Fancy Feet","Hakari Dance","Taco Time","Think","Cutthroat","Shoulder Brush","Heartfelt Salute","Boogie Down","Nerd","Npt Like Us","Paparazzi","Frolic","Sad Rain","Kodo Pose","BOO!","Eating Ramen","Come At Me","Sweet Death","Poppin' Bottles","Mog","Lifting","Star of Hope","Santa Sack","Domain Expansion"},
        KillEmote = {"Vampire", "Surprise!","ACME","Avra Kadoovra","Baldie's Demise","Barbarian","Bee","Blood Sugar","Cauldron","Curb Stomp","Figure Skater","Frost Breath","Frostbound Prison","Frozen Impalement","Gingerbread","Glacial Burial","Goblin Bomb","Heart Rip","Impostor","Laser Eyes","Mistletoe","Naughty List","Neck Snap","Orthax","Pollen Overload","Possession","Rudolph's Revenge","Selfie","Serious Sneeze","Sick Burn","Smite","Snowball Cannon","Snowflakes","Sore Winner","Spine Breaker","Spirit Trap","Think Mark","Tinsel Strangle","Tree Topper Slice","Werewolf","Wrap It Up"}
    }
    local EMOTE_SLOTS = 8

    local COSMETICS_DATA = {
        AccessoriesEquipped = {"Chunin Exam Vest", "Halo","Frozen Gloves","Devil's Eye","Devil's Tail","Devil's Wings","Flower Wings","Frozen Crown","Frozen Tail","Frozen Wings","Garland Scarf","Hades Helmet","Holiday Scarf","Krampus Hat","Red Kagune","Rudolph Antlers","Snowflake Wings","Sorting Hat","Sorting Hat","VIP Crown"},
        AurasEquipped = {"Butterflies", "Northern Lights","Ki","Blue Lightning","Green Lightning","Purple Lightning","Purple Lightning","Yellow Lightning"},
        CapesEquipped = {"Ice Lord", "Viking","Christmas Lights","Dracula","Krampus","Krampus Supreme","Santa","VIP","Webbed"}
    }

    local emoteData = {}
    local emoteGui, emoteWheelFrame, emoteSelectionFrame, cosmeticsFrame
    local currentSlotIndex = nil

    -- Passes the hub switched on itself. A pass that was already true when
    -- we touched it is owned by the player (bought with Robux), so it is
    -- never recorded and never revoked: turning Open Access / Visual VIP
    -- off can not strip a gamepass that was actually purchased.
    local grantedPasses = {}

    local function isVipPassName(name)
        return string.find(string.lower(name), "vip", 1, true) ~= nil
    end

    local function activatePasses()
        local passesFolder = OA_LocalPlayer:FindFirstChild("Passes")
        if not passesFolder then return end
        for _, passValue in ipairs(passesFolder:GetChildren()) do
            -- VIP is granted only by the Visual VIP toggle.
            if not isVipPassName(passValue.Name) then
                if passValue:IsA("BoolValue") then
                    if passValue.Value == false then
                        passValue.Value = true
                        grantedPasses[passValue.Name] = true
                    end
                elseif passValue:IsA("NumberValue") then
                    if passValue.Value ~= 1 then
                        passValue.Value = 1
                        grantedPasses[passValue.Name] = true
                    end
                end
            end
        end
    end

    local function deactivatePasses()
        local passesFolder = OA_LocalPlayer:FindFirstChild("Passes")
        if not passesFolder then return end
        for _, passValue in ipairs(passesFolder:GetChildren()) do
            -- Only revoke what the hub itself granted: owned passes keep
            -- their value, so the game still sees the purchase.
            if not isVipPassName(passValue.Name) and grantedPasses[passValue.Name] then
                if passValue:IsA("BoolValue") then
                    passValue.Value = false
                elseif passValue:IsA("NumberValue") then
                    passValue.Value = 0
                end
                grantedPasses[passValue.Name] = nil
            end
        end
    end

    -- The "visual VIP" gamepass is granted by SetupGamePass / Passes.
    -- Match every pass whose name mentions "vip" so it can be toggled alone.
    local function setVipPass(enabled)
        local passesFolder = OA_LocalPlayer:FindFirstChild("Passes")
        if not passesFolder then
            warn("[OpenAccess] Passes folder not found")
            return
        end
        local matched = false
        for _, passValue in ipairs(passesFolder:GetChildren()) do
            if isVipPassName(passValue.Name) then
                matched = true
                if passValue:IsA("BoolValue") then
                    if enabled then
                        if passValue.Value == false then
                            passValue.Value = true
                            grantedPasses[passValue.Name] = true
                        end
                    elseif grantedPasses[passValue.Name] then
                        passValue.Value = false
                        grantedPasses[passValue.Name] = nil
                    end
                elseif passValue:IsA("NumberValue") then
                    if enabled then
                        if passValue.Value ~= 1 then
                            passValue.Value = 1
                            grantedPasses[passValue.Name] = true
                        end
                    elseif grantedPasses[passValue.Name] then
                        passValue.Value = 0
                        grantedPasses[passValue.Name] = nil
                    end
                end
            end
        end
        if not matched then
            local names = {}
            for _, passValue in ipairs(passesFolder:GetChildren()) do
                table.insert(names, passValue.Name)
            end
            warn("[OpenAccess] No VIP pass found. Passes: " .. table.concat(names, ", "))
        end
    end

    local function setupRemotes()
        local remotesFolder = OA_ReplicatedStorage:WaitForChild("Remotes")
        local combatFolder = remotesFolder:WaitForChild("Combat")
        if not combatFolder then return end

        local emoteStop = combatFolder:FindFirstChild("EmoteStop")
        if emoteStop then
            emoteStop:Destroy()
        end

        task.wait(1)

        local emoteStart = combatFolder:FindFirstChild("EmoteStart")
        if emoteStart then
            local newEmoteStop = emoteStart:Clone()
            newEmoteStop.Name = "EmoteStop"
            newEmoteStop.Parent = combatFolder
        end
    end

    local function createDefaultEmoteData()
        local data = {}
        for i = 1, EMOTE_SLOTS do
            table.insert(data, {"Emote", "None"})
        end
        for i = 1, 4 do
            table.insert(data, true)
        end
        return data
    end

    local function updateEmoteValue()
        local dataFolder = OA_LocalPlayer:WaitForChild("Data")
        local equippedValue = dataFolder:FindFirstChild("EmoteEquipped")

        if equippedValue and equippedValue:IsA("StringValue") then
            local success, encodedData = pcall(function()
                return OA_HttpService:JSONEncode(emoteData)
            end)
            if success then
                equippedValue.Value = encodedData
            else
                warn("Failed to encode emote data to JSON.")
            end
        else
            warn("EmoteEquipped StringValue not found in Player.Data")
        end
    end

    local function updateDataValue(valueName, dataTable)
        local dataFolder = OA_LocalPlayer:WaitForChild("Data")
        local valueObject = dataFolder:FindFirstChild(valueName)

        if not valueObject or not valueObject:IsA("StringValue") then
            warn(valueName .. " is not a StringValue or does not exist. Creating a new one.")
            if valueObject then valueObject:Destroy() end
            valueObject = Instance.new("StringValue")
            valueObject.Name = valueName
            valueObject.Parent = dataFolder
        end

        local success, encodedData = pcall(function()
            return OA_HttpService:JSONEncode(dataTable)
        end)

        if success then
            valueObject.Value = encodedData
        else
            warn("Failed to encode " .. valueName .. " data to JSON.")
        end
    end

    local function loadEmoteData()
        local dataFolder = OA_LocalPlayer:WaitForChild("Data")
        local equippedValue = dataFolder:WaitForChild("EmoteEquipped")

        if not equippedValue or not equippedValue:IsA("StringValue") then
            warn("EmoteEquipped is not a StringValue or does not exist. Creating a new one.")
            if equippedValue then equippedValue:Destroy() end
            equippedValue = Instance.new("StringValue")
            equippedValue.Name = "EmoteEquipped"
            equippedValue.Parent = dataFolder
            emoteData = createDefaultEmoteData()
            updateEmoteValue()
            return
        end

        local success, decodedData = pcall(function()
            if equippedValue.Value == "" then return nil end
            return OA_HttpService:JSONDecode(equippedValue.Value)
        end)

        if success and type(decodedData) == "table" and #decodedData == (EMOTE_SLOTS + 4) then
            emoteData = decodedData
        else
            emoteData = createDefaultEmoteData()
            updateEmoteValue()
        end
    end

    local function createUI()
        emoteGui = Instance.new("ScreenGui")
        emoteGui.Name = "EmoteGUI"
        emoteGui.ResetOnSpawn = false
        emoteGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        emoteWheelFrame = Instance.new("Frame")
        emoteWheelFrame.Name = "EmoteWheel"
        emoteWheelFrame.Size = UDim2.new(0, 300, 0, 300)
        emoteWheelFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        emoteWheelFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        emoteWheelFrame.BackgroundTransparency = 1
        emoteWheelFrame.Visible = false
        emoteWheelFrame.Parent = emoteGui

        emoteSelectionFrame = Instance.new("ScrollingFrame")
        emoteSelectionFrame.Name = "EmoteSelection"
        emoteSelectionFrame.Size = UDim2.new(0, 300, 0, 400)
        emoteSelectionFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        emoteSelectionFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        emoteSelectionFrame.BackgroundTransparency = 0.2
        emoteSelectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        emoteSelectionFrame.BorderSizePixel = 0
        emoteSelectionFrame.Visible = false
        emoteSelectionFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        emoteSelectionFrame.Parent = emoteGui

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 5)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = emoteSelectionFrame

        local function filterEmoteList(searchText)
            local lowerSearchText = searchText:lower()
            local visibleCategories = {}

            for _, child in ipairs(emoteSelectionFrame:GetChildren()) do
                if child:IsA("TextButton") and child.Name ~= "BackButton" then
                    local isVisible = child.Name:lower():find(lowerSearchText, 1, true)
                    child.Visible = isVisible
                    if isVisible then
                        local category = child:GetAttribute("Category")
                        if category then
                            visibleCategories[category] = true
                        end
                    end
                end
            end

            for _, child in ipairs(emoteSelectionFrame:GetChildren()) do
                if child:IsA("TextLabel") then
                    child.Visible = visibleCategories[child.Text] or false
                end
            end
        end

        local searchBar = Instance.new("TextBox")
        searchBar.Name = "SearchBar"
        searchBar.Size = UDim2.new(1, -10, 0, 30)
        searchBar.Position = UDim2.new(0.5, 0, 0, 0)
        searchBar.AnchorPoint = Vector2.new(0.5, 0)
        searchBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        searchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
        searchBar.PlaceholderText = "Search Emotes..."
        searchBar.ClearTextOnFocus = false
        searchBar.Font = Enum.Font.SourceSans
        searchBar.TextSize = 16
        searchBar.LayoutOrder = 0
        searchBar.Parent = emoteSelectionFrame

        searchBar:GetPropertyChangedSignal("Text"):Connect(function()
            filterEmoteList(searchBar.Text)
        end)

        local layoutOrder = 1
        for category, emotes in pairs(EMOTES) do
            local categoryLabel = Instance.new("TextLabel")
            categoryLabel.Name = category .. "Label"
            categoryLabel.Size = UDim2.new(1, 0, 0, 30)
            categoryLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            categoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            categoryLabel.Text = category
            categoryLabel.Font = Enum.Font.SourceSansBold
            categoryLabel.TextSize = 20
            categoryLabel.LayoutOrder = layoutOrder
            categoryLabel.Parent = emoteSelectionFrame
            layoutOrder = layoutOrder + 1

            for _, emoteName in ipairs(emotes) do
                local emoteButton = Instance.new("TextButton")
                emoteButton.Name = emoteName
                emoteButton.Size = UDim2.new(1, 0, 0, 40)
                emoteButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                emoteButton.TextColor3 = Color3.fromRGB(220, 220, 220)
                emoteButton.Text = emoteName
                emoteButton.Font = Enum.Font.SourceSans
                emoteButton.TextSize = 18
                emoteButton.LayoutOrder = layoutOrder
                emoteButton:SetAttribute("Category", category)
                emoteButton.Parent = emoteSelectionFrame
                layoutOrder = layoutOrder + 1

                emoteButton.MouseButton1Click:Connect(function()
                    if currentSlotIndex then
                        emoteData[currentSlotIndex] = {category, emoteName}
                        updateEmoteValue()
                        emoteSelectionFrame.Visible = false
                        currentSlotIndex = nil
                    end
                end)
            end
        end

        local radius = 120
        for i = 1, EMOTE_SLOTS do
            local angle = ((i - 1) / EMOTE_SLOTS) * 2 * math.pi - (math.pi / 2)
            local x = math.cos(angle) * radius
            local y = math.sin(angle) * radius

            local slotButton = Instance.new("TextButton")
            slotButton.Name = "Slot_" .. i
            slotButton.Size = UDim2.new(0, 50, 0, 50)
            slotButton.Position = UDim2.new(0.5, x, 0.5, y)
            slotButton.AnchorPoint = Vector2.new(0.5, 0.5)
            slotButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            slotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            slotButton.Text = tostring(i)
            slotButton.Font = Enum.Font.SourceSansBold
            slotButton.TextSize = 24
            slotButton.Parent = emoteWheelFrame

            slotButton.MouseButton1Click:Connect(function()
                currentSlotIndex = i
                if emoteWheelToggleLib then
                    emoteWheelToggleLib:SetValue(false)
                else
                    emoteWheelFrame.Visible = false
                end
                emoteSelectionFrame.Visible = true
                searchBar.Text = ""
                filterEmoteList("")
            end)
        end

        emoteGui.Parent = OA_LocalPlayer:WaitForChild("PlayerGui")
    end

    local function filterList(scrollingFrame, searchText)
        local lowerSearchText = searchText:lower()
        for _, button in ipairs(scrollingFrame:GetChildren()) do
            if button:IsA("TextButton") then
                button.Visible = button.Name:lower():find(lowerSearchText, 1, true)
            end
        end
    end

    local function createCosmeticsUI()
        cosmeticsFrame = Instance.new("Frame")
        cosmeticsFrame.Name = "CosmeticsSelection"
        cosmeticsFrame.Size = UDim2.new(0, 600, 0, 450)
        cosmeticsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        cosmeticsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        cosmeticsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        cosmeticsFrame.BorderSizePixel = 1
        cosmeticsFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
        cosmeticsFrame.Visible = false
        cosmeticsFrame.Parent = emoteGui

        local horizontalLayout = Instance.new("UIListLayout")
        horizontalLayout.FillDirection = Enum.FillDirection.Horizontal
        horizontalLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        horizontalLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        horizontalLayout.SortOrder = Enum.SortOrder.LayoutOrder
        horizontalLayout.Padding = UDim.new(0, 10)
        horizontalLayout.Parent = cosmeticsFrame

        local columnIndex = 1
        for valueName, items in pairs(COSMETICS_DATA) do
            local columnFrame = Instance.new("Frame")
            columnFrame.Name = valueName .. "Column"
            columnFrame.Size = UDim2.new(0, 180, 1, 0)
            columnFrame.BackgroundTransparency = 1
            columnFrame.LayoutOrder = columnIndex
            columnFrame.Parent = cosmeticsFrame

            local columnLayout = Instance.new("UIListLayout")
            columnLayout.SortOrder = Enum.SortOrder.LayoutOrder
            columnLayout.Padding = UDim.new(0, 5)
            columnLayout.Parent = columnFrame

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Name = "Title"
            titleLabel.Size = UDim2.new(1, 0, 0, 30)
            titleLabel.Text = valueName:gsub("Equipped", "")
            titleLabel.Font = Enum.Font.SourceSansBold
            titleLabel.TextSize = 20
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            titleLabel.Parent = columnFrame

            local searchBar = Instance.new("TextBox")
            searchBar.Name = "SearchBar"
            searchBar.Size = UDim2.new(1, 0, 0, 25)
            searchBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            searchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
            searchBar.PlaceholderText = "Search..."
            searchBar.ClearTextOnFocus = false
            searchBar.Font = Enum.Font.SourceSans
            searchBar.TextSize = 14
            searchBar.Parent = columnFrame

            local scrollingFrame = Instance.new("ScrollingFrame")
            scrollingFrame.Name = "ItemList"
            scrollingFrame.Size = UDim2.new(1, 0, 1, -60)
            scrollingFrame.BackgroundTransparency = 0.5
            scrollingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            scrollingFrame.BorderSizePixel = 0
            scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
            scrollingFrame.Parent = columnFrame

            searchBar:GetPropertyChangedSignal("Text"):Connect(function()
                filterList(scrollingFrame, searchBar.Text)
            end)

            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 5)
            listLayout.Parent = scrollingFrame

            for _, itemName in ipairs(items) do
                local itemButton = Instance.new("TextButton")
                itemButton.Name = itemName
                itemButton.Size = UDim2.new(1, 0, 0, 40)
                itemButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                itemButton.TextColor3 = Color3.fromRGB(220, 220, 220)
                itemButton.Text = itemName
                itemButton.Font = Enum.Font.SourceSans
                itemButton.TextSize = 16
                itemButton.Parent = scrollingFrame

                itemButton.MouseButton1Click:Connect(function()
                    local dataToSave = {itemName}
                    updateDataValue(valueName, dataToSave)
                    print(valueName .. " set to: " .. itemName)
                end)
            end
            columnIndex = columnIndex + 1
        end
    end

    OpenAccess.ActivatePasses = activatePasses
    OpenAccess.DeactivatePasses = deactivatePasses
    OpenAccess.SetVipPass = setVipPass
    OpenAccess.LoadEmotes = loadEmoteData
    OpenAccess.CreateUI = createUI
    OpenAccess.CreateCosmeticsUI = createCosmeticsUI

    OpenAccess.SetEmoteWheel = function(value)
        if emoteWheelFrame then
            emoteWheelFrame.Visible = value and true or false
            if not value and emoteSelectionFrame then
                emoteSelectionFrame.Visible = false
            end
        end
    end

    OpenAccess.SetCosmetics = function(value)
        if cosmeticsFrame then
            cosmeticsFrame.Visible = value and true or false
        end
    end

    -- Initial setup, matching the original standalone script.
    -- Pass grants removed from boot: they belong to the "Open Access" /
    -- "Visual VIP" toggles, so a fresh launch must start with them off.
    loadEmoteData()
    createUI()
    createCosmeticsUI()
    task.spawn(setupRemotes)
end

OpenAccessSection = Tabs.OpenAccess:AddSection({ Name = "OpenAccess", Position = "left" })
OpenAccessMenusSection = Tabs.OpenAccess:AddSection({ Name = "Menus", Position = "right" })

openAccessToggleLib = OpenAccessSection:AddToggle({
    Text = "Open Access (all passes)",
    Default = false,
    Callback = function(Value)
        if Value then
            OpenAccess.ActivatePasses()
        else
            OpenAccess.DeactivatePasses()
        end
    end,
})
openAccessToggleLib:ToolTip("Grants every pass in the game and prepares the emote remotes")

visualVipToggleLib = OpenAccessSection:AddToggle({
    Text = "Visual VIP",
    Default = false,
    Callback = function(Value)
        OpenAccess.SetVipPass(Value)
    end,
})
visualVipToggleLib:ToolTip("Toggles the VIP gamepass (visual) on and off")

emoteWheelToggleLib = OpenAccessMenusSection:AddToggle({
    Text = "Emote Wheel",
    Default = false,
    Callback = function(Value)
        OpenAccess.SetEmoteWheel(Value)
    end,
})
emoteWheelToggleLib:ToolTip("Opens the emote wheel (bind a key to it)")

cosmeticsToggleLib = OpenAccessMenusSection:AddToggle({
    Text = "Cosmetics",
    Default = false,
    Callback = function(Value)
        OpenAccess.SetCosmetics(Value)
    end,
})
cosmeticsToggleLib:ToolTip("Opens the cosmetics menu (bind a key to it)")

BindableToggles = {
    { Text = "Godmode", Toggle = godmodeToggleLib },
    { Text = "WallSpam", Toggle = wallSpamToggleLib },
    { Text = "Aura V2", Toggle = auraV2ToggleLib },
    { Text = "HideWallcombo", Toggle = hideWallcomboToggleLib },
    { Text = "Invisible", Toggle = invisibleToggleLib },
    { Text = "WallcomboV1", Toggle = wallComboV1Toggle },
    { Text = "Anti-Godmode", Toggle = antiGodmodeToggle },
    { Text = "AntigodmodeV2", Toggle = antiGodmodeV2Toggle },
    { Text = "GodmodeV3", Toggle = godmodeV3Toggle },
    { Text = "Kill Aura V2", Toggle = killAuraV2Toggle },
    { Text = "GodmodeV1", Toggle = godmodeV1Toggle },
    { Text = "Invulnerability", Toggle = invuln1ToggleLib },
    { Text = "Invulnerability 2", Toggle = invuln2ToggleLib },
    { Text = "Infinite Lives", Toggle = duelGodmodeToggleLib },
    { Text = "Kill Farm", Toggle = killFarmToggleLib },
    { Text = "Kill then grab", Toggle = killThenGrabToggle },
    { Text = "Teleport to target", Toggle = telportToggle },
    { Text = "Abilities spam", Toggle = abilitiesSpamToggle },
    { Text = "Server Bullying", Toggle = serverbullyingtoggle },
    { Text = "KillAura", Toggle = killAuraAdmToggle },
    { Text = "Ignore Friends", Toggle = ignoreFriendsAdmToggle },
    { Text = "Show Range Circle", Toggle = showRangeToggle },
    { Text = "Anti-Serverlagger", Toggle = antiLaggerToggle },
    { Text = "Serverlagger", Toggle = serverLaggerToggle },
    { Text = "Hitbox", Toggle = hitBoxToggleLib },
    { Text = "Enhancer", Toggle = enhancerToggleLib },
    { Text = "Hitbox Legitify", Toggle = HitboxLegitifytoggle },
    { Text = "Hitbox Ignore Friends", Toggle = HitboxIgnoreFriendstoggle },
    { Text = "Hitbox Visualizer", Toggle = HitboxVisualizertoggle },
    { Text = "Dashhelper", Toggle = dashHelperToggle },
    { Text = "Rockhelper", Toggle = rockHelperToggle },
    { Text = "Less endlag block", Toggle = lessEndlagToggle },
    { Text = "Freeze Ping", Toggle = freezePingToggle },
    { Text = "SpeedHack", Toggle = speedHackToggleLib },
    { Text = "Auto execute on teleport", Toggle = autoExecuteToggleLib },
    { Text = "Auto block", Toggle = autoBlockToggleLib },
    { Text = "Scramble Ping", Toggle = scramblePingToggleLib },
    { Text = "Faster M1s", Toggle = fastM1sToggleLib },
    { Text = "No stun", Toggle = noStunToggleLib },
    { Text = "Longer Ultimate", Toggle = longerUltimateToggleLib },
    { Text = "Instant Ultimate", Toggle = instantUltimateToggleLib },
    { Text = "No SlowDowns", Toggle = noSlowDownsToggleLib },
    { Text = "No StunOnMiss", Toggle = noStunOnMissToggleLib },
    { Text = "Auto Ragdoll", Toggle = autoRagdollToggleLib },
    { Text = "Void kill", Toggle = voidKillToggleLib },
    { Text = "Auto Claim Emote", Toggle = autoClaimEmoteToggleLib },
    { Text = "Rainbow Aura", Toggle = rainbowAuraToggleLib },
    { Text = "Atmosphere", Toggle = atmosphereToggleLib },
    { Text = "Neon Trails", Toggle = trailsToggleLib },
    { Text = "HP Indicators", Toggle = hpIndicatorToggleLib },
    { Text = "Particles", Toggle = particlesToggleLib },
    { Text = "Fly", Toggle = flyToggle },
    { Text = "Noclip", Toggle = noclipToggle },
    { Text = "Click TP", Toggle = clickTPToggle },
    { Text = "Spin", Toggle = spinToggle },
    { Text = "Radar", Toggle = radarToggle },
    { Text = "Rock Visual", Toggle = VSXVisual.Toggles[1] },
    { Text = "Paper Visual", Toggle = VSXVisual.Toggles[2] },
    { Text = "Scissors Visual", Toggle = VSXVisual.Toggles[3] },
    { Text = "Rod Visual", Toggle = VSXVisual.Toggles[4] },
    { Text = "Front Dash", Toggle = VSXVisual.Toggles[5] },
    { Text = "Open Access", Toggle = openAccessToggleLib },
    { Text = "Visual VIP", Toggle = visualVipToggleLib },
    { Text = "Emote Wheel", Toggle = emoteWheelToggleLib },
    { Text = "Cosmetics", Toggle = cosmeticsToggleLib },
}

BindedKeybinds = {}
for _, entry in ipairs(BindableToggles) do
    entry.Keybind = entry.Toggle:AddKeybind({ Text = entry.Text, Dark = true })
    table.insert(BindedKeybinds, entry)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local name = input.KeyCode.Name
        for _, entry in ipairs(BindedKeybinds) do
            if entry.Keybind:GetValue() == name then
                entry.Toggle:SetValue(not entry.Toggle:GetValue())
            end
        end
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        for _, entry in ipairs(BindedKeybinds) do
            if entry.Keybind:GetValue() == "M1B" then
                entry.Toggle:SetValue(not entry.Toggle:GetValue())
            end
        end
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        for _, entry in ipairs(BindedKeybinds) do
            if entry.Keybind:GetValue() == "M2B" then
                entry.Toggle:SetValue(not entry.Toggle:GetValue())
            end
        end
    end
end)

print("Keybinds added to all features!")

-- ==============================================
-- РљРћРќР•Р¦ VISUAL TAB
-- ==============================================

print("Concept Hub successfully loaded!")

-- ==============================================
-- TEXTUR TAB: in-game effect reduction
-- ==============================================

Textur = Textur or {}

local function TextureGetContainer()
    return ReplicatedStorage:FindFirstChild("Characters")
end

TexturLeftSection = Tabs.Textur:AddSection({ Name = "TexturEffects", Position = "left" })

TexturToggles = {}

local function TextureAddToggle(label, tooltip, callback)
    local t = TexturLeftSection:AddToggle({
        Text = label,
        Default = false,
        Callback = function(Value)
            pcall(callback, Value)
        end,
    })
    t:ToolTip(tooltip)
    table.insert(TexturToggles, t)
    return t
end

-- "Abilities" and WallCombo are the heavy ones: renaming the folder is
-- what the game's own "Hide Wallcombo" feature relies on.
TextureAddToggle("Remove Abilities FX", "Hides ability visuals from every character (rename, reversible)", function(Value)
    local chars = TextureGetContainer()
    if not chars then return end
    for _, char in pairs(chars:GetChildren()) do
        if Value then
            renameObject(char, "Abilities", "ab")
        else
            renameObject(char, "ab", "Abilities")
        end
    end
end)

TextureAddToggle("Remove WallCombo FX", "Hides WallCombo visuals from every character (rename, reversible)", function(Value)
    local chars = TextureGetContainer()
    if not chars then return end
    for _, char in pairs(chars:GetChildren()) do
        if Value then
            renameObject(char, "WallCombo", "wall")
        else
            renameObject(char, "wall", "WallCombo")
        end
    end
    WallComboName = Value and "wall" or "WallCombo"
end)

TexturRightSection = Tabs.Textur:AddSection({ Name = "TexturRendering", Position = "right" })

-- Cosmetic strip: hides parts of your own character that cost draw calls.
TexturParts = TexturParts or {}

-- Hides any descendant (BasePart or Decal-like) and restores what it saved.
function TextureHideInstance(hidden, instance)
    if hidden then
        if instance:IsA("BasePart") then
            TexturParts[instance] = { transparency = instance.Transparency, material = instance.Material }
            instance.Transparency = 1
            pcall(function() instance.Material = Enum.Material.SmoothPlastic end)
        else
            TexturParts[instance] = { transparency = instance.Transparency }
            pcall(function() instance.Transparency = 1 end)
        end
    else
        local saved = TexturParts[instance]
        if not saved then return end
        instance.Transparency = saved.transparency or 0
        if instance:IsA("BasePart") and saved.material then
            pcall(function() instance.Material = saved.material end)
        end
        TexturParts[instance] = nil
    end
end

TextureAddToggle("Hide Eyebrows", "Hides the eyebrow decals on your character", function(Value)
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if string.find(string.lower(part.Name), "eyebrow", 1, true) then
            TextureHideInstance(Value, part)
        end
    end
end)

TextureAddToggle("Hide Hair", "Hides hair accessories on your character", function(Value)
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if string.find(string.lower(part.Name), "hair", 1, true) then
            TextureHideInstance(Value, part)
        end
    end
end)

TextureAddToggle("Hide Accessories", "Hides hats, accessories, wings and trails on your character", function(Value)
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        local lower = string.lower(part.Name)
        if string.find(lower, "hat", 1, true)
            or string.find(lower, "accessory", 1, true)
            or string.find(lower, "wing", 1, true)
            or string.find(lower, "trail", 1, true) then
            TextureHideInstance(Value, part)
        end
    end
end)

TextureAddToggle("Disable World FX", "Removes particle emitters and light effects from the workspace", function(Value)
    if Value then
        if Textur.worldConn then return end
        Textur.worldConn = workspace.DescendantAdded:Connect(function(inst)
            pcall(function()
                if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") then
                    inst.Enabled = false
                end
            end)
        end)
        for _, inst in ipairs(workspace:GetDescendants()) do
            pcall(function()
                if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") then
                    inst.Enabled = false
                end
            end)
        end
    else
        if Textur.worldConn then
            Textur.worldConn:Disconnect()
            Textur.worldConn = nil
        end
        for _, inst in ipairs(workspace:GetDescendants()) do
            pcall(function()
                if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") then
                    inst.Enabled = true
                end
            end)
        end
    end
end)

-- Re-apply cosmetic hides after respawn, otherwise the character rebuild
-- resets every Transparency we set and the toggle silently stops working.
TexturApplyConn = LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    for toggle in ipairs(TexturToggles) do
        if toggle:GetValue() then
            pcall(function() toggle:SetValue(true) end)
        end
    end
end)

print("Textur tab loaded!")

-- ========================================================
-- CONFIGURATION TAB
-- Full config manager on top of NeverLose's built-in ConfigLib
-- (GetData / LoadData walk every registered Flag, so toggles,
-- sliders, dropdowns, keybinds and colors are all covered).
-- Save / Save As / Load / Rename / Delete / Export / Import,
-- plus an autoload marker applied on the next execute.
-- ========================================================

do

local Logger = NeverLose:CreateLogger()
local CFG = {}

CFG.ConfigLib = Window and Window.ConfigLib
CFG.Folder = (Window and Window.ConfigFolder) or "ConceptHub"
CFG.MetaFolder = "ConceptHubData"
CFG.MetaFile = CFG.MetaFolder .. "/autoload"

if not isfolder(CFG.Folder) then makefolder(CFG.Folder) end
if not isfolder(CFG.MetaFolder) then makefolder(CFG.MetaFolder) end

-- NeverLose boots Default on its own ~1s in; we take over from there.
CFG.Busy = false

-- ------------------------------------------------------------
-- helpers
-- ------------------------------------------------------------

function CFG.Notify(icon, text)
    pcall(function()
        Logger.new(icon, text, 3)
    end)
end

local function Sanitize(name)
    if type(name) ~= "string" then return nil end
    name = name:gsub("%s+", " ")
    name = name:gsub("[/\\:%*%?\"<>|]", "")
    name = name:gsub("^%s+", ""):gsub("%s+$", "")
    if #name == 0 then return nil end
    return name:sub(1, 24)
end

local function ValidName(name)
    if type(name) ~= "string" then return false end
    if name == "" or name == "Default" then return false end
    return not (name:find("/", 1, true) or name:find("\\", 1, true))
end

-- Loading must accept "Default" as well, so it gets its own check that only
-- rejects empty strings and path separators.
local function IsConfigFileName(name)
    if type(name) ~= "string" or name == "" then return false end
    return not (name:find("/", 1, true) or name:find("\\", 1, true))
end

-- Only real config files: skips Default (always offered separately) and any
-- stray helper file.
local function ListConfigs()
    local list = {}
    local ok, files = pcall(listfiles, CFG.Folder)
    if not ok or type(files) ~= "table" then return list end
    for _, file in ipairs(files) do
        local name = tostring(file)
        -- listfiles may return "ConceptHub/Name" or a bare "Name"
        if name:sub(1, #CFG.Folder + 1) == CFG.Folder .. "/" then
            name = name:sub(#CFG.Folder + 2)
        end
        name = name:gsub("^.*[/\\]", "")
        if name ~= "" and name ~= "Default" then
            table.insert(list, name)
        end
    end
    table.sort(list)
    return list
end

local function Path(name)
    return CFG.Folder .. "/" .. name
end

function CFG.GetAutoload()
    if not isfile(CFG.MetaFile) then return nil end
    local ok, raw = pcall(readfile, CFG.MetaFile)
    if not ok or type(raw) ~= "string" then return nil end
    local name = raw:match("^%s*(.-)%s*$")
    if name == "" then return nil end
    return name
end

function CFG.SetAutoload(name)
    pcall(function()
        if name and ValidName(name) then
            writefile(CFG.MetaFile, name)
        else
            if isfile(CFG.MetaFile) then delfile(CFG.MetaFile) end
        end
    end)
end

function CFG.GetSelected()
    if not CFG.ConfigLib then return "Default" end
    local name = CFG.ConfigLib.SelectedConfig
    if type(name) ~= "string" or name == "" then return "Default" end
    return name
end

function CFG.SetSelected(name)
    if CFG.ConfigLib then
        pcall(function() CFG.ConfigLib.SelectedConfig = name end)
    end
    if CFG.ActiveLabel and CFG.ActiveLabel.SetText then
        pcall(function() CFG.ActiveLabel:SetText("Active: " .. name) end)
    end
end

-- Serialise every registered Flag into one encoded blob.
-- GetData() is called without the "performance" flag on purpose: the
-- performance path does task.wait(), and this runs inside a click callback.
function CFG.Capture()
    if not CFG.ConfigLib or not CFG.ConfigLib.GetData then return nil end
    local ok, data = pcall(function() return CFG.ConfigLib:GetData() end)
    if not ok then return nil end
    return data
end

function CFG.Apply(name)
    if not name or not IsConfigFileName(name) then
        CFG.Notify("x-small", "Config not found")
        return false
    end
    if not isfile(Path(name)) then
        CFG.Notify("x-small", "Config not found: " .. name)
        return false
    end
    if not CFG.ConfigLib or not CFG.ConfigLib.LoadData then return false end

    local okRead, data = pcall(readfile, Path(name))
    if not okRead or type(data) ~= "string" then
        CFG.Notify("x-small", "Could not read " .. name)
        return false
    end

    -- Guard both callbacks while LoadData walks the Flags: the saved "Active
    -- Config" dropdown and "Autoload Config" toggle are Flags too, and letting
    -- them fire here would re-enter Apply or rewrite the autoload marker.
    CFG.Busy = true
    CFG.Syncing = true
    local okLoad, err = pcall(function() CFG.ConfigLib:LoadData(data) end)
    CFG.Syncing = false
    CFG.Busy = false
    if not okLoad then
        CFG.Notify("x-small", "Corrupt config: " .. name)
        print("[ConfigManager] LoadData failed for " .. tostring(name) .. ": " .. tostring(err))
        return false
    end

    CFG.SetSelected(name)
    return true
end

-- Keep the built-in browser (gear button) in sync with what we do.
local function SyncBuiltin()
    if CFG.ConfigLib and CFG.ConfigLib.RefreshConfig then
        pcall(function() CFG.ConfigLib:RefreshConfig() end)
    end
end

function CFG.Refresh()
    if not CFG.List then return end
    local list = ListConfigs()

    -- Default is always offered first; the dropdown holds every name.
    local values = { "Default" }
    for _, name in ipairs(list) do
        values[#values + 1] = name
    end
    CFG.List:SetValues(values)

    local selected = CFG.GetSelected()
    local found = false
    for _, name in ipairs(values) do
        if name == selected then found = true break end
    end
    if not found then
        selected = "Default"
    end

    -- Set the selection before pushing it into the dropdown, so the dropdown's
    -- own callback sees value == selection and does not re-trigger Apply.
    CFG.SetSelected(selected)
    pcall(function() CFG.List:SetValue(selected) end)

    local auto = CFG.GetAutoload()
    if CFG.AutoToggle and not CFG.Syncing then
        -- SetValue fires the toggle Callback, which would call Refresh again.
        CFG.Syncing = true
        pcall(function() CFG.AutoToggle:SetValue(auto ~= nil) end)
        CFG.Syncing = false
    end
    if CFG.AutoLabel and CFG.AutoLabel.SetText then
        pcall(function()
            CFG.AutoLabel:SetText(auto and ("Autoload: " .. auto) or "Autoload: off")
        end)
    end
    if CFG.CountLabel and CFG.CountLabel.SetText then
        pcall(function() CFG.CountLabel:SetText("Configs: " .. tostring(#list)) end)
    end
end

-- ------------------------------------------------------------
-- UI
-- ------------------------------------------------------------

local Tab = Tabs["Configurations"]

if Tab then

    local CfgLeft = Tab:AddSection({ Name = "Configuration", Position = "left" })
    local CfgRight = Tab:AddSection({ Name = "Autoload", Position = "right" })

    -- Picking in the dropdown loads that config straight away.
    function CFG.OnPick(value)
        if CFG.Busy then return end
        if type(value) ~= "string" then return end
        if value == CFG.GetSelected() then return end
        CFG.Busy = true
        CFG.SetSelected(value)
        local ok = CFG.Apply(value)
        CFG.Busy = false
        if ok then
            CFG.Notify("folder", "Loaded " .. value)
        end
    end

    -- Active config picker
    CFG.List = CfgLeft:AddDropdown({
        Text = "Active Config",
        Default = "Default",
        Values = { "Default" },
        Multi = false,
        Callback = CFG.OnPick,
    })

    -- Row holding a real TextBox.
    -- Deliberately built by hand instead of AddTextInput: registered Flags
    -- are serialised into every config, so a saved config name would be
    -- restored over the user's input on load.
    local nameRow = CfgLeft:AddLabel("", false)
    local root = nameRow and nameRow.Root

    if root then
        pcall(function() root.MouseEnter:Disconnect() end)
        pcall(function() root.MouseLeave:Disconnect() end)

        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("TextLabel") then
                pcall(function() d.Visible = false end)
            elseif d:IsA("Frame") and d.Name ~= root.Name then
                pcall(function() d.Visible = false end)
            end
        end
        pcall(function() root.BackgroundTransparency = 1 end)

        local input = Instance.new("TextBox")
        input.Name = "ConfigNameInput"
        input.BackgroundColor3 = Color3.fromRGB(31, 34, 42)
        input.BackgroundTransparency = 0
        input.BorderSizePixel = 0
        input.ClearTextOnFocus = false
        input.Font = Enum.Font.GothamMedium
        input.PlaceholderText = "Config name..."
        input.PlaceholderColor3 = Color3.fromRGB(120, 126, 140)
        input.Text = ""
        input.TextColor3 = Color3.fromRGB(235, 238, 245)
        input.TextSize = 13
        input.TextTransparency = 0
        input.Size = UDim2.new(1, -22, 1, -10)
        input.Position = UDim2.new(0, 11, 0, 5)
        input.ZIndex = root.ZIndex + 4
        input.Parent = root

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = input

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(56, 62, 78)
        stroke.Thickness = 1
        stroke.Transparency = 0.35
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = input

        CFG.NameInput = input
    end

    local function InputName()
        if not CFG.NameInput then return nil end
        return Sanitize(CFG.NameInput.Text)
    end

    local function ClearInput()
        if CFG.NameInput then
            pcall(function() CFG.NameInput.Text = "" end)
        end
    end

    CfgLeft:AddButton({
        Name = "Save",
        Icon = "arrow-down-to-line",
        ToolTip = "Overwrite the active config with your current settings",
        Callback = function()
            local name = CFG.GetSelected()
            if not ValidName(name) then
                CFG.Notify("x-small", "Default cannot be overwritten - use Save As")
                return
            end
            local data = CFG.Capture()
            if not data then
                CFG.Notify("x-small", "Nothing to save")
                return
            end
            local ok = pcall(function() writefile(Path(name), data) end)
            if ok then
                SyncBuiltin()
                CFG.Notify("folder", "Saved " .. name)
            else
                CFG.Notify("x-small", "Save failed")
            end
        end,
    })

    CfgLeft:AddButton({
        Name = "Save As New",
        Icon = "plus-small",
        ToolTip = "Create a new config from your current settings",
        Callback = function()
            local name = InputName()
            if not name then
                CFG.Notify("x-small", "Type a name first")
                return
            end
            if not ValidName(name) then
                CFG.Notify("x-small", "Invalid name")
                return
            end
            if isfile(Path(name)) then
                CFG.Notify("x-small", "Already exists: " .. name)
                return
            end
            local data = CFG.Capture()
            if not data then
                CFG.Notify("x-small", "Nothing to save")
                return
            end
            local ok = pcall(function() writefile(Path(name), data) end)
            if ok then
                CFG.SetSelected(name)
                CFG.Refresh()
                ClearInput()
                CFG.Notify("folder", "Created " .. name)
            else
                CFG.Notify("x-small", "Save failed")
            end
        end,
    })

    CfgLeft:AddButton({
        Name = "Load",
        Icon = "circle-check",
        ToolTip = "Apply the active config",
        Callback = function()
            local name = CFG.GetSelected()
            if name == "Default" then
                CFG.Notify("x-small", "Default is already active")
                return
            end
            if CFG.Apply(name) then
                CFG.Notify("folder", "Loaded " .. name)
            end
        end,
    })

    CfgLeft:AddButton({
        Name = "Rename",
        Icon = "pencil",
        ToolTip = "Rename the active config to the name in the field",
        Callback = function()
            local from = CFG.GetSelected()
            if not ValidName(from) then
                CFG.Notify("x-small", "Default cannot be renamed")
                return
            end
            local to = InputName()
            if not to or not ValidName(to) then
                CFG.Notify("x-small", "Type a valid new name")
                return
            end
            if to == from then return end
            if isfile(Path(to)) then
                CFG.Notify("x-small", "Already exists: " .. to)
                return
            end
            local ok, data = pcall(readfile, Path(from))
            if not ok or type(data) ~= "string" then
                CFG.Notify("x-small", "Could not read " .. from)
                return
            end
            pcall(function() writefile(Path(to), data) end)
            pcall(function() delfile(Path(from)) end)
            if CFG.GetAutoload() == from then CFG.SetAutoload(to) end
            CFG.SetSelected(to)
            CFG.Refresh()
            ClearInput()
            CFG.Notify("folder", "Renamed to " .. to)
        end,
    })

    CfgLeft:AddButton({
        Name = "Delete",
        Icon = "trash-can",
        ToolTip = "Delete the active config",
        Callback = function()
            local name = CFG.GetSelected()
            if not ValidName(name) then
                CFG.Notify("x-small", "Default cannot be deleted")
                return
            end
            pcall(function() delfile(Path(name)) end)
            if CFG.GetAutoload() == name then
                CFG.SetAutoload(nil)
            end
            CFG.SetSelected("Default")
            CFG.Refresh()
            CFG.Notify("trash-can", "Deleted " .. name)
        end,
    })

    CfgLeft:AddButton({
        Name = "Refresh List",
        Icon = "arrow-rotate-right",
        ToolTip = "Re-read the config folder",
        Callback = function()
            CFG.Refresh()
            SyncBuiltin()
            CFG.Notify("arrow-rotate-right", "List refreshed")
        end,
    })

    CFG.ActiveLabel = CfgLeft:AddLabel("Active: Default", true)
    CFG.CountLabel = CfgLeft:AddLabel("Configs: 0", true)

    -- --- right column ---

    CFG.AutoToggle = CfgRight:AddToggle({
        Text = "Autoload Config",
        Default = false,
        Callback = function(value)
            if CFG.Syncing then return end
            if value then
                local name = CFG.GetSelected()
                if not ValidName(name) then
                    CFG.Notify("x-small", "Pick a config to autoload")
                    pcall(function() CFG.AutoToggle:SetValue(false) end)
                    return
                end
                CFG.SetAutoload(name)
                CFG.Notify("folder", "Autoload set: " .. name)
            else
                CFG.SetAutoload(nil)
                CFG.Notify("folder", "Autoload off")
            end
            CFG.Refresh()
        end,
    })

    CFG.AutoLabel = CfgRight:AddLabel("Autoload: off", true)

    CfgRight:AddButton({
        Name = "Apply Autoload Now",
        Icon = "circle-play",
        ToolTip = "Load the autoload config immediately",
        Callback = function()
            local name = CFG.GetAutoload()
            if not name then
                CFG.Notify("x-small", "No autoload config set")
                return
            end
            if CFG.Apply(name) then
                CFG.Notify("folder", "Loaded " .. name)
            end
        end,
    })

    CfgRight:AddButton({
        Name = "Export to Clipboard",
        Icon = "rectangle-list",
        ToolTip = "Copy the active config as text",
        Callback = function()
            local name = CFG.GetSelected()
            if not isfile(Path(name)) then
                CFG.Notify("x-small", "Config not found")
                return
            end
            local ok, data = pcall(readfile, Path(name))
            if not ok or type(data) ~= "string" then
                CFG.Notify("x-small", "Could not read " .. name)
                return
            end
            if setclipboard then
                pcall(function() setclipboard(data) end)
                CFG.Notify("rectangle-list", "Copied " .. name)
            else
                CFG.Notify("x-small", "setclipboard unavailable")
            end
        end,
    })

    CfgRight:AddButton({
        Name = "Import from Clipboard",
        Icon = "list-bulleted",
        ToolTip = "Write the clipboard as a new config named below",
        Callback = function()
            local name = InputName()
            if not name or not ValidName(name) then
                CFG.Notify("x-small", "Type a valid name first")
                return
            end
            if not getclipboard then
                CFG.Notify("x-small", "getclipboard unavailable")
                return
            end
            local ok, data = pcall(getclipboard)
            if not ok or type(data) ~= "string" or data == "" then
                CFG.Notify("x-small", "Clipboard is empty")
                return
            end
            pcall(function() writefile(Path(name), data) end)
            CFG.SetSelected(name)
            CFG.Refresh()
            ClearInput()
            CFG.Notify("rectangle-list", "Imported " .. name)
        end,
    })

    CfgRight:AddButton({
        Name = "Reset Everything",
        Icon = "trash-can",
        ToolTip = "Wipe every saved config and start over",
        Callback = function()
            for _, name in ipairs(ListConfigs()) do
                if name ~= "Default" then
                    pcall(function() delfile(Path(name)) end)
                end
            end
            CFG.SetAutoload(nil)
            CFG.SetSelected("Default")
            CFG.Refresh()
            SyncBuiltin()
            CFG.Notify("trash-can", "All configs removed")
        end,
    })

    CfgRight:AddLabel("======================================", false)
    CfgRight:AddLabel("Configs save every toggle, slider,", false)
    CfgRight:AddLabel("dropdown, keybind and colour.", false)
    CfgRight:AddLabel("Autoload applies on next execute.", false)

    CFG.Refresh()

    -- Give NeverLose time to apply Default, then honour the autoload config.
    task.delay(2.5, function()
        local name = CFG.GetAutoload()
        if not name then return end
        if not isfile(Path(name)) then
            CFG.SetAutoload(nil)
            return
        end
        if CFG.Apply(name) then
            CFG.Refresh()
            CFG.Notify("folder", "Autoloaded " .. name)
        end
    end)

end

end

print("Configuration tab loaded!")

return NeverLose

end)(NeverLose_Module)
