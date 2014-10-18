--[[

		..                                             .                     ....        .                  ..
	  :**888H: `: .xH""                                @88>                .x88" `^x~  xH(`                dF
	 X   `8888k XX888       u.    u.      u.    u.     %8P                X888   x8 ` 8888h          u.   '88bu.
	'8hx  48888 ?8888     x@88k u@88c.  x@88k u@88c.    .         .u     88888  888.  %8888    ...ue888b  '*88888bu
	'8888 '8888 `8888    ^"8888""8888" ^"8888""8888"  .@88u    ud8888.  <8888X X8888   X8?     888R Y888r   ^"*8888N
	 %888>'8888  8888      8888  888R    8888  888R  ''888E` :888'8888. X8888> 488888>"8888x   888R I888>  beWE "888L
	   "8 '888"  8888      8888  888R    8888  888R    888E  d888 '88%" X8888>  888888 '8888L  888R I888>  888E  888E
	  .-` X*"    8888      8888  888R    8888  888R    888E  8888.+"    ?8888X   ?8888>'8888X  888R I888>  888E  888E
		.xhx.    8888      8888  888R    8888  888R    888E  8888L       8888X h  8888 '8888~ u8888cJ888   888E  888F
	  .H88888h.~`8888.>   "*88*" 8888"  "*88*" 8888"   888&  '8888c. .+   ?888  -:8*"  <888"   "*888*P"   .888N..888
	 .~  `%88!` '888*~      ""   'Y"      ""   'Y"     R888"  "88888%      `*88.      :88%       'Y"       `"888*""
		   `"     ""                                    ""      "YP'          ^"~====""`                      ""

	Script:		AnnieGod
	Version:	2.00
	Author:		Devn
	
--]]

-- Champion Check
if myHero.charName ~= "Annie" then return end

--[[ Script Members ]]--

local SCRIPT_NAME = "AnnieGod"
local AUTO_UPDATE = true -- Change to false to disable auto updating.
local VERSION = 2.00

--[[ Print Function ]]--

function PrintMessage(message)
	PrintChat("<font color=\"#81BEF7\">"..SCRIPT_NAME..":</font> <font color=\"#00FF00\">"..message.."</font>")
end

--[[ Check for SourceLib ]]--

function SourceLibCheck()

	local path = LIB_PATH.."SourceLib.lua"

	if FileExist(path) then
		require("SourceLib")
		return true
	else
		DownloadFile("https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua", path, function()
			PrintMessage("SourceLib downloaded successfully. Please reload the script!")
		end)
		return false
	end

end

if not SourceLibCheck() then return end

--[[ Auto Update & Load Libraries ]]--

if AUTO_UPDATE then
	SourceUpdater(SCRIPT_NAME, VERSION, "dl.dropboxusercontent.com", "/u/80293382/BoL%20Scripts/AnnieGod/AnnieGod.lua", SCRIPT_PATH..GetCurrentEnv().FILE_NAME, "/u/80293382/BoL%20Scripts/AnnieGod/Version.txt"):CheckUpdate()
end

function LibraryChecks()

	local libRequire = Require(SCRIPT_NAME)
	
	libRequire:Add("vPrediction", "https://raw.github.com/Hellsing/BoL/master/common/VPrediction.lua")
	libRequire:Add("SOW", "https://raw.github.com/Hellsing/BoL/master/common/SOW.lua")
	libRequire:Add("CustomPermaShow", "https://raw.github.com/Superx321/BoL/master/common/CustomPermaShow.lua")
	
	libRequire:Check()
	return not libRequire.downloadNeeded

end

if not LibraryChecks() then return end

--[[ Script Setup ]]--

function OnLoad()

	InitTracker()
	SetupVariables()
	SetupMenu()
	SetupPriorities()
	
	PrintMessage("Version "..VERSION.." loaded successfully!")

end

function InitTracker()

	BOL_TRACKER = {
		ID = 25,
		HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION"))),
	}
	
	assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()
	UpdateWeb(true, SCRIPT_NAME, BOL_TRACKER.ID, BOL_TRACKER.HWID)

end

function SetupVariables()

	gameEnded = false
	annie = GetMyHero()
	currentTarget = nil
	enemyTable = { }
	towerRange = 900
	defaultCircleRadius = 250
	fogRange = 1200
	lastLevel = annie.level - 1
	tibbers = nil
	recalling = false
	stunReady = false
	controllingTibbers = false
	vPrediction = VPrediction()
	sow = SOW(vPrediction)
	simpleTS = SimpleTS(STS_PRIORITY_LESS_CAST_MAGIC)
	damageLib = DamageLib()
	
	_DFG = 3128
	_FQC = 3092
	_HPPOT = 2003
	_MPPOT = 2004
	_FLASK = 2041
	
	spells = {
		[_Q] = { name = "Disintegrate", range = 625, radius = -1, delay = 0.25, speed = 1400, base = nil },
		[_W] = { name = "Incinerate", range = 625, radius = 50 * math.pi / 180, delay = 0.25, speed = math.huge, base = nil },
		[_E] = { name = "Molten Shield", range = -1, radius = -1, delay = 0.5, speed = -1, base = nil },
		[_R] = { name = "Summon: Tibbers", range = 600, radius = 250, delay = 0.25, speed = math.huge, base = nil },
		[_DFG] = { name = "Deathfire Grasp", range = 650, base = nil },
		[_FQC] = { name = "Frost Queen's Claim", range = 850, radius = 250, base = nil },
	}
	
	levelSequences = {
		[1] = { _Q, _W, _Q, _E, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E },
		[2] = { _W, _Q, _W, _E, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E },
		[3] = { _Q, _W, _Q, _E, _W, _R, _Q, _W, _W, _W, _R, _Q, _Q, _E, _E, _R, _E, _E },
	}
	
	priorityTable = {
		adc = { "Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "Jinx", "KogMaw", "Lucian", "MasterYi", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir", "Talon","Tryndamere", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Yasuo","Zed" },
		apc = { "Annie", "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus", "Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna", "Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra" },
		support = { "Alistar", "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Nunu", "Sona", "Soraka", "Taric", "Thresh", "Zilean", "Braum" },
		bruiser = { "Aatrox", "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nocturne", "Olaf", "Poppy", "Renekton", "Rengar", "Riven", "Rumble", "Shyvana", "Trundle", "Udyr", "Vi", "MonkeyKing", "XinZhao" },
		tank = { "Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Nautilus", "Shen", "Singed", "Skarner", "Volibear", "Warwick", "Yorick", "Zac" },
	}
	
	priorityOrder = {
		[1] = { 5, 5, 5, 5, 5 },
        [2] = { 5, 5, 4, 4, 4 },
        [3] = { 5, 5, 4, 3, 3 },
		[4] = { 5, 4, 3, 2, 2 },
        [5] = { 5, 4, 3, 2, 1 },
    }
	
	defaultBindings = {
		["AutoLastHit"] = string.byte("T"),
		["AutoHarass"] = string.byte("A"),
	}
	
	combos = {
		{ _Q },
		{ _W },
		{ _W, _Q },
		{ _R },
		{ _R, _Q },
		{ _R, _W },
		{ _R, _W, _Q }, -- Smart KS only checks to here
		{ _DFG, _Q },
		{ _DFG, _W },
		{ _DFG, _W, _Q },
		{ _DFG, _R },
		{ _DFG, _R, _Q },
		{ _DFG, _R, _W },
		{ _DFG, _R, _W, _Q },
		{ _FQC, _Q },
		{ _FQC, _W },
		{ _FQC, _W, _Q },
		{ _FQC, _R },
		{ _FQC, _R, _Q },
		{ _FQC, _R, _W },
		{ _FQC, _R, _W, _Q },
		{ _FQC, _DFG, _Q },
		{ _FQC, _DFG, _W },
		{ _FQC, _DFG, _W, _Q },
		{ _FQC, _DFG, _R },
		{ _FQC, _DFG, _R, _Q },
		{ _FQC, _DFG, _R, _W },
		{ _FQC, _DFG, _R, _W, _Q },
		{ _IGNITE, _Q },
		{ _IGNITE, _W },
		{ _IGNITE, _W, _Q },
		{ _IGNITE, _R },
		{ _IGNITE, _R, _Q },
		{ _IGNITE, _R, _W },
		{ _IGNITE, _R, _W, _Q },
		{ _IGNITE, _DFG, _Q },
		{ _IGNITE, _DFG, _W },
		{ _IGNITE, _DFG, _W, _Q },
		{ _IGNITE, _DFG, _R },
		{ _IGNITE, _DFG, _R, _Q },
		{ _IGNITE, _DFG, _R, _W },
		{ _IGNITE, _DFG, _R, _W, _Q },
		{ _FQC, _IGNITE, _Q },
		{ _FQC, _IGNITE, _W },
		{ _FQC, _IGNITE, _W, _Q },
		{ _FQC, _IGNITE, _R },
		{ _FQC, _IGNITE, _R, _Q },
		{ _FQC, _IGNITE, _R, _W },
		{ _FQC, _IGNITE, _R, _W, _Q },
		{ _FQC, _IGNITE, _DFG, _Q },
		{ _FQC, _IGNITE, _DFG, _W },
		{ _FQC, _IGNITE, _DFG, _W, _Q },
		{ _FQC, _IGNITE, _DFG, _R },
		{ _FQC, _IGNITE, _DFG, _R, _Q },
		{ _FQC, _IGNITE, _DFG, _R, _W },
		{ _FQC, _IGNITE, _DFG, _R, _W, _Q }, -- Main combo
	}
	
	tickManagers = {
		tick = TickManager(20),
		draw = TickManager(30),
	}
	
	spells[_Q].base = Spell(_Q, spells[_Q].range)
	spells[_W].base = Spell(_W, spells[_W].range)
	spells[_E].base = Spell(_E, spells[_E].range)
	spells[_R].base = Spell(_R, spells[_R].range)
	spells[_DFG].base = Item(_DFG, spells[_DFG].range)
	spells[_FQC].base = Item(_FQC, spells[_FQC].range)
	
	spells[_W].base:SetSkillshot(vPrediction, SKILLSHOT_CONE, spells[_W].radius, spells[_W].delay, spells[_W].speed, false):SetAOE(true)
	spells[_R].base:SetSkillshot(vPrediction, SKILLSHOT_CIRCULAR, spells[_R].radius, spells[_R].delay, spells[_R].speed, false):SetAOE(true)
	
	damageLib:RegisterDamageSource(_Q, _MAGIC, 45, 35, _MAGIC, _AP, 0.8, function() return spells[_Q].base:IsReady() end)
	damageLib:RegisterDamageSource(_W, _MAGIC, 25, 45, _MAGIC, _AP, 0.85, function() return spells[_W].base:IsReady() end)
	damageLib:RegisterDamageSource(_R, _MAGIC, 85, 125, _MAGIC, _AP, 1.0, function() return spells[_R].base:IsReady() and not tibbers end)
	damageLib:RegisterDamageSource(_DFG, _MAGIC, 0, 0, _MAGIC, _AP, 0, function() return spells[_DFG].base:GetSlot() and spells[_DFG].base:IsReady() end, function(target) return 0.15 * target.maxHealth end)
	damageLib:RegisterDamageSource(_FQC, _MAGIC, 0, 0, _MAGIC, _AP, 0, function() return spells[_FQC].base:GetSlot() and spells[_FQC].base:IsReady() end, function() return 50 + (5 * annie.level) end)
	
	enemyMinions = minionManager(MINION_ENEMY, spells[_Q].range, annie, MINION_SORT_HEALTH_ASC)
	jungleMinions = minionManager(MINION_JUNGLE, spells[_Q].range, annie, MINION_SORT_MAXHEALTH_DEC)
	
	for i = 1, heroManager.iCount do
		local enemy = heroManager:GetHero(i)
		if enemy.team ~= annie.team then
			table.insert(enemyTable, { hero = enemy, text = "", spells = { } })
		end
	end
	
	if _IGNITE then
		spells[_IGNITE] = { name = "Ignite", range = 600, base = nil }
		spells[_IGNITE].base = Summoner(_IGNITE, spells[_IGNITE].range)
		damageLib:RegisterDamageSource(_IGNITE, _TRUE, 0, 0, _TRUE, _AP, 0, function() return _IGNITE and spells[_IGNITE].base:IsReady() end, function() return 50 + (20 * annie.level) end)
	end
	
end

function SetupMenu()

	menu = scriptConfig("AnnieGod", "DevnAnnieGod")
	
	menu:addSubMenu("Target Selector", "ts")
	simpleTS:AddToMenu(menu.ts)
	
	menu:addSubMenu("Orbwalking Settings", "orbwalking")
	sow:LoadToMenu(menu.orbwalking)
	
	menu:addSubMenu("Combo Mode", "combo")
	menu.combo:addParam("permaShow", "Perma Show", SCRIPT_PARAM_ONOFF, true)
	AddTitleRow(menu.combo, "Spells")
	menu.combo:addParam("useQ", "Use "..spells[_Q].name.." (Q)", SCRIPT_PARAM_ONOFF, true)
	menu.combo:addParam("useW", "Use "..spells[_W].name.." (W)", SCRIPT_PARAM_ONOFF, true)
	menu.combo:addParam("useR", "Use "..spells[_R].name.." (R)", SCRIPT_PARAM_ONOFF, true)
	AddTitleRow(menu.combo, "Summoners")
	if _IGNITE then menu.combo:addParam("useIgnite", "Use "..spells[_IGNITE].name, SCRIPT_PARAM_ONOFF, true) end
	AddTitleRow(menu.combo, "Items")
	menu.combo:addParam("useDFG", "Use "..spells[_DFG].name, SCRIPT_PARAM_ONOFF, true)
	menu.combo:addParam("useFQC", "Use "..spells[_FQC].name, SCRIPT_PARAM_ONOFF, true)
	AddTitleRow(menu.combo, "Info")
	menu.combo:addParam("nil", "Binding: Setup binding in SOW menu", SCRIPT_PARAM_INFO, "")
	
	menu:addSubMenu("Mixed Mode", "mixed")
	menu.mixed:addParam("permaShow", "Perma Show", SCRIPT_PARAM_ONOFF, true)
	AddTitleRow(menu.mixed, "Info")
	menu.mixed:addParam("nil", "Binding: Setup binding in SOW menu", SCRIPT_PARAM_INFO, "")
	
	menu:addSubMenu("Xóa Lính Nhanh", "laneClear")
	menu.laneClear:addParam("permaShow", "Perma Show", SCRIPT_PARAM_ONOFF, true)
	menu.laneClear:addParam("useTibbers", "Dung Tibbers ", SCRIPT_PARAM_ONOFF, true)
	AddTitleRow(menu.laneClear, "Spells")
	menu.laneClear:addParam("useQ", "Use "..spells[_Q].name.." (Q)", SCRIPT_PARAM_ONOFF, true)
	menu.laneClear:addParam("useW", "Use "..spells[_W].name.." (W)", SCRIPT_PARAM_ONOFF, false)
	AddTitleRow(menu.laneClear, "Info")
	menu.laneClear:addParam("nil", "Binding: Setup binding in SOW menu", SCRIPT_PARAM_INFO, "")
	
	menu:addSubMenu("Last Hit Mode", "lastHit")
	menu.lastHit:addParam("permaShow", "Perma Show", SCRIPT_PARAM_ONOFF, true)
	AddTitleRow(menu.lastHit, "Spells")
	menu.lastHit:addParam("useQ", "Use "..spells[_Q].name.." (Q)", SCRIPT_PARAM_ONOFF, true)
	menu.lastHit:addParam("useW", "Use "..spells[_W].name.." (W)", SCRIPT_PARAM_ONOFF, false)
	AddTitleRow(menu.lastHit, "Info")
	menu.lastHit:addParam("nil", "Binding: Setup binding in SOW menu", SCRIPT_PARAM_INFO, "")
	
	menu:addSubMenu("Killstealing", "ks")
	menu.ks:addParam("enabled", "Enable Killstealing", SCRIPT_PARAM_ONOFF, true)
	menu.ks:addParam("permaShow", "Perma Show", SCRIPT_PARAM_ONOFF, true)
	menu.ks:addParam("mode", "Killsteal Mode", SCRIPT_PARAM_LIST, 2, { "Simple", "Smart" })
	menu.ks:addParam("recalling", "Disable if Recalling", SCRIPT_PARAM_ONOFF, false)
	AddTitleRow(menu.ks, "Spells")
	menu.ks:addParam("useQ", "Use "..spells[_Q].name.." (Q)", SCRIPT_PARAM_ONOFF, true)
	menu.ks:addParam("useW", "Use "..spells[_W].name.." (W)", SCRIPT_PARAM_ONOFF, true)
	menu.ks:addParam("useR", "Use "..spells[_R].name.." (R)", SCRIPT_PARAM_ONOFF, true)
	AddTitleRow(menu.ks, "Summoners")
	if _IGNITE then menu.ks:addParam("useIgnite", "Use "..spells[_IGNITE].name, SCRIPT_PARAM_ONOFF, true) end
	AddTitleRow(menu.ks, "Items")
	menu.ks:addParam("useDFG", "Use "..spells[_DFG].name, SCRIPT_PARAM_ONOFF, true)
	menu.ks:addParam("useFQC", "Use "..spells[_FQC].name, SCRIPT_PARAM_ONOFF, true)
	AddTitleRow(menu.ks, "Info")
	menu.ks:addParam("nil", "Simple: Only use Q/W/R", SCRIPT_PARAM_INFO, "")
	menu.ks:addParam("nil", "Smart: Use least amount of spells", SCRIPT_PARAM_INFO, "")
	menu:addSubMenu("Auto-Skill Settings", "auto")
	--menu.auto:addParam("shield", spells[_E].name.." (E) When Damaged", SCRIPT_PARAM_ONOFF, true)
	menu.auto:addParam("tibbers", "Auto Command Tibbers", SCRIPT_PARAM_LIST, 2, { "Off", "Attack Target", "Follow Annie" })
	AddTitleRow(menu.auto, "Stun Proc.")
	menu.auto:addParam("base", "Use Skills in Base", SCRIPT_PARAM_ONOFF, true)
	menu.auto:addParam("spamShield", "Spam Shield", SCRIPT_PARAM_ONOFF, false)
	menu.auto:addParam("shieldMinMana", "Min. Mana (%) to Shield", SCRIPT_PARAM_SLICE, 80, 0, 100, 0)
	AddTitleRow(menu.auto, "Auto Stun")
	menu.auto:addParam("useW", "Use "..spells[_W].name.." (W) if Can Stun", SCRIPT_PARAM_LIST, 3, { "Off", "Over 0 Enemies", "Over 1 Enemy", "Over 2 Enemies", "Over 3 Enemies", "Over 4 Enemies" })
	menu.auto:addParam("useR", "Use "..spells[_R].name.." (R) if Can Stun", SCRIPT_PARAM_LIST, 5, { "Off", "Over 0 Enemies", "Over 1 Enemy", "Over 2 Enemies", "Over 3 Enemies", "Over 4 Enemies" })
	AddTitleRow(menu.auto, "Auto Potion")
	menu.auto:addParam("autoPotions", "Use Potions When Below (%)", SCRIPT_PARAM_ONOFF, false)
	menu.auto:addParam("hpPotion", "Min. HP (%) to Use HP Pot", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
	menu.auto:addParam("mpPotion", "Min. MP (%) to Use MP Pot", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
	menu.auto:addParam("flaskHP", "Min. HP (%) to Use Flask", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
	menu.auto:addParam("flaskMP", "Min. MP (%) to Use Flask", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
	AddTitleRow(menu.auto, "Info")
	menu.auto:addParam("nil", "Auto Potion Sliders: 0 = Off", SCRIPT_PARAM_INFO, "")
	
	menu:addSubMenu("Miscellaneous", "misc")
	menu.misc:addParam("autoLevel", "Auto Level Spells", SCRIPT_PARAM_LIST, 1, { "Off", "RQWE", "RWQE", "Mixed" })
	menu.misc:addParam("useTM", "Use Tick Manager", SCRIPT_PARAM_ONOFF, false)
	
	menu:addSubMenu("Auto-Interrupt Settings", "interrupt")
	Interrupter(menu.interrupt, OnTargetInterruptable)
	AddTitleRow(menu.interrupt, "Spells")
	menu.interrupt:addParam("useQ", "Use "..spells[_Q].name.." (Q)", SCRIPT_PARAM_ONOFF, true)
	menu.interrupt:addParam("useW", "Use "..spells[_W].name.." (W)", SCRIPT_PARAM_ONOFF, true)
	menu.interrupt:addParam("useR", "Use "..spells[_R].name.." (R)", SCRIPT_PARAM_ONOFF, true)
	
	menu:addSubMenu("Drawing", "draw")
	menu.draw:addParam("disable", "Disable All Drawing", SCRIPT_PARAM_ONOFF, false)
	AddTitleRow(menu.draw, "Spells")
	menu.draw:addParam("comboRange", "Draw Combo Range", SCRIPT_PARAM_ONOFF, true)
	menu.draw:addParam("comboRangeColor", "Combo Range Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
	AddTitleRow(menu.draw, "Enemies")
	menu.draw:addParam("enemyDamage", "Draw Combo Damage on Enemies", SCRIPT_PARAM_ONOFF, true)
	menu.draw:addParam("killableEnemies", "Draw Circle Under Killable Enemies", SCRIPT_PARAM_ONOFF, true)
	menu.draw:addParam("killableEnemiesColor", "Killable Enemies Circle Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
	
	menu:addParam("nil", "", SCRIPT_PARAM_INFO, "", "")
	menu:addParam("author", "Author:", SCRIPT_PARAM_INFO, "Devn")
	menu:addParam("version", "Version:", SCRIPT_PARAM_INFO, VERSION)
	
end

function SetupPriorities()
	
	for i = 1, #enemyTable do
		local enemy = enemyTable[i].hero
		if table.contains(priorityTable.adc, enemy.charName) then
			STS_MENU.STS[enemy.hash] = priorityOrder[#enemyTable][1]
		elseif table.contains(priorityTable.apc, enemy.charName) then
			STS_MENU.STS[enemy.hash] = priorityOrder[#enemyTable][2]
		elseif table.contains(priorityTable.support, enemy.charName) then
			STS_MENU.STS[enemy.hash] = priorityOrder[#enemyTable][3]
		elseif table.contains(priorityTable.bruiser, enemy.charName) then
			STS_MENU.STS[enemy.hash] = priorityOrder[#enemyTable][4]
		elseif table.contains(priorityTable.tank, enemy.charName) then
			STS_MENU.STS[enemy.hash] = priorityOrder[#enemyTable][5]
		else
			PrintMessage("Champion "..enemy.charName.." could not be found in priority table. Please manually set the priority for this champion!")
		end
	end
	
end

--[[ Callback Methods ]]--

function OnTick()

	if not CheckTickManager(tickManagers.tick) or gameEnded then return end

	AutoLevel()
	AutoPotions()
	UpdateVariables()
	ProcStun()
	DamageCalculation()
	HandlePerforms()
	CommandTibbers()
	UpdatePermaShow()

end

function OnDraw()

	if not CheckTickManager(tickManagers.draw) or menu.draw.disable or annie.dead then return end
	
	if menu.draw.comboRange then DrawCircle(annie.x, annie.y, annie.z, spells[_Q].range, GetARGB(menu.draw.comboRangeColor)) end
	
	for i = 1, #enemyTable do
		local enemy = enemyTable[i].hero
		
		if menu.draw.enemyDamage and ValidTarget(enemy) then
			local barPos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
			local pos = { x = barPos.x - 35, y = barPos.y - 50 }
			DrawText(enemyTable[i].text, 15, pos.x, pos.y, (#enemyTable[i].spells > 0 and ARGB(255, 0, 255, 0)) or ARGB(255, 255, 220, 0))
		end
		
		if menu.draw.killableEnemies and #enemyTable[i].spells > 0 and ValidTarget(enemy, fogRange) then
			DrawCircle(enemy.x, enemy.y, enemy.z, defaultCircleRadius, GetARGB(menu.draw.killableEnemiesColor))
		end
		
	end
	
end

function OnCreateObj(object)

	if object.name:find("StunReady") and GetDistance(object, annie) < 1 then
		stunReady = true
	elseif object.name:lower():find("annietibbers") and object.name:lower():find("body") and GetDistance(object, annie) < 1 then
		tibbers = object
	elseif object.name:find("TeleportHome") and GetDistance(object) <= 70 then
		recalling = true
	end

end

function OnDeleteObj(object)

	if object.name:find("StunReady") and GetDistance(object, annie) < 1 then
		stunReady = false
	elseif object.name:lower():find("annietibbers") and object.name:lower():find("body") and GetDistance(object, annie) < 1 then
		tibbers = nil
	elseif object.name:find("TeleportHome") and GetDistance(object) <= 70 then
		recalling = false
	end

end

function OnTargetInterruptable(unit, spell)

	if not stunReady and spells[_E].base:IsReady() then spells[_E].base:Cast() end
	
	if stunReady and ValidTarget(unit, spells[_Q].range) then
		if menu.interrupt.useW and spells[_W].base:IsReady() then
			spells[_W].base:Cast(unit)
		elseif menu.interrupt.useR and spells[_R].base:IsReady() then
			spells[_R].base:Cast(unit)
		elseif menu.interrupt.useQ and spells[_Q].base:IsReady() then
			spells[_Q].base:Cast(unit)
		end
	end

end

function OnBugsplat()

	UpdateWeb(false, SCRIPT_NAME, BOL_TRACKER.ID, BOL_TRACKER.HWID)
	
end

function OnUnload()

	UpdateWeb(false, SCRIPT_NAME, BOL_TRACKER.ID, BOL_TRACKER.HWID)
	
end

--[[ Script Methods ]]--

function AutoLevel()

	if menu.misc.autoLevel == 1 or annie.level <= lastLevel then return end

	LevelSpell(levelSequences[menu.misc.autoLevel - 1][annie.level])
	lastLevel = annie.level

end

function AutoPotions()

	if not menu.auto.autoPotions or InFountain() or recalling or TargetHaveBuff("SummonerTeleport", annie) then return end
	
	if menu.auto.hpPotion > 0 and StatOverMin("Health", menu.auto.hpPotion) and not TargetHaveBuff("RegenerationPotion", annie) then
		local slot = GetInventoryItemSlot(_HPPOT)
		if slot then CastSpell(slot) end
	end
	
	if menu.auto.mpPotion > 0 and StatOverMin("Mana", menu.auto.mpPotion) and not TargetHaveBuff("FlaskOfCrystalWater", annie) then
		local slot = GetInventoryItemSlot(_MPPOT)
		if slot then CastSpell(slot) end
	end
	
	if not TargetHaveBuff("ItemCrystalFlask", annie) then
		local slot = GetInventoryItemSlot(_FLASK)
		if slot then
			if menu.auto.flaskHP > 0 and StatOverMin("Health", menu.auto.flaskHP) then CastSpell(slot) end
			if menu.auto.flaskMP > 0 and StatOverMin("Mana", menu.auto.flaskMP) then CastSpell(slot) end
		end
	end

end

function UpdateVariables()

	if GetGame().isOver then
		UpdateWeb(false, SCRIPT_NAME, BOL_TRACKER.ID, BOL_TRACKER.HWID)
		gameEnded = true
	end

	currentTarget = simpleTS:GetTarget(spells[_Q].range)
	controllingTibbers = false
	
	enemyMinions:update()
	jungleMinions:update()

end

function ProcStun()

	if stunReady then return end
	
	if InFountain() and menu.auto.base then
		if spells[_W].base:IsReady() then spells[_W].base:Cast(annie.x, annie.z) end
		if not stunReady and spells[_E].base:IsReady() then spells[_E].base:Cast() end
	elseif menu.auto.spamShield and StatOverMin("Mana", menu.auto.shieldMinMana) and not recalling and spells[_E].base:IsReady() then
		spells[_E].base:Cast()
	end

end

function DamageCalculation()

	for i = 1, #enemyTable do
		local enemy = enemyTable[i].hero
		if ValidTarget(enemy) then
			local foundCombo = false
			if ValidTarget(enemy, spells[_Q].range) then
				for _, combo in ipairs(combos) do
					if damageLib:IsKillable(enemy, combo) then
						foundCombo = true
						enemyTable[i].text = KillComboToString(combo)
						enemyTable[i].spells = combo
						break
					end
				end
			end
			if not foundCombo then
				local damageTotal = damageLib:CalcComboDamage(enemy, { _Q, _W })
				local percentHp = math.round((damageTotal / enemy.health) * 100)
				enemyTable[i].text = "Q + W = "..percentHp.."% Current HP"
				enemyTable[i].spells = { }
			end
		end
	end

end

function PerformKillsteal()

	if not menu.ks.enabled or menu.ks.recalling and recalling then return false end
	
	local performed = false
	
	for i = 1, #enemyTable do
		local enemy = enemyTable[i].hero
		if menu.ks.mode == 1 then
			for i = 1, 7 do
				if damageLib:IsKillable(enemy, combos[i]) then
					performed = CastCombo(enemy, menu.ks.useQ, menu.ks.useW, menu.ks.useR, false, false, false, combos[i])
				end
			end
		elseif menu.ks.mode == 2 then
			if #enemyTable[i].spells > 0 then
				performed = CastCombo(enemy, menu.ks.useQ, menu.ks.useW, menu.ks.useR, menu.ks.useDFG, menu.ks.useFQC, menu.ks.useIgnite, enemyTable[i].spells)
			end
		end
	end
	
	return performed

end

function PerformAutoStun()

	if not currentTarget or not stunReady or UnderEnemyTower() then return false end
	
	local performed = true
	
	if menu.auto.useW > 1 and spells[_W].base:IsReady() then
		local minTargets = menu.auto.useW - 1
		spells[_W].base:SetAOE(true, spells[_W].radius, minTargets)
		if spells[_W].base:Cast(currentTarget) == SPELLSTATE_NOT_ENOUGH_TARGETS then performed = false end
		spells[_W].base:SetAOE(true)
	elseif menu.auto.useR > 1 and spells[_R].base:IsReady() then
		local minTargets = menu.auto.useR - 1
		spells[_R].base:SetAOE(true, spells[_R].radius, minTargets)
		if spells[_R].base:Cast(currentTarget) == SPELLSTATE_NOT_ENOUGH_TARGETS then performed = false end
		spells[_R].base:SetAOE(true)
	end
	
	return performed

end

function PerformCombo()

	if not menu.orbwalking.Mode0 or not currentTarget then return false end
	
	local combo = nil
	if damageLib:IsKillable(currentTarget, combos[#combos]) then
		combo = combos[#combos]
	end
	
	CastCombo(currentTarget, menu.combo.useQ, menu.combo.useW, menu.combo.useR, menu.combo.useDFG, menu.combo.useFQC, menu.combo.useIgnite, combo)
	return true
	
end

function PerformMixed()

	if not menu.orbwalking.Mode1 then return false end
	
	sow:DisableAttacks()
	if currentTarget and not UnderEnemyTower() then
		if spells[_Q].base:IsReady() then spells[_Q].base:Cast(currentTarget) end
		if stunReady and spells[_W].base:IsReady() then spells[_W].base:Cast(currentTarget) end
	end
	if not stunReady then
		if spells[_Q].base:IsReady() and ValidTarget(enemyMinions.objects[1], spells[_Q].range) then
			local delay = spells[_Q].delay + GetDistance(enemyMinions.objects[1].visionPos, annie.visionPos) / spells[_Q].speed - 0.07
			local predictedHealth = vPrediction:GetPredictedHealth(enemyMinions.objects[1], delay)
			if predictedHealth <= damageLib:CalcSpellDamage(enemyMinions.objects[1], _Q) and predictedHealth > 0 then
				spells[_Q].base:Cast(enemyMinions.objects[1])
			end
		end
	end	
	sow:EnableAttacks()
	
	return true

end

function PerformLastHit()

	if not menu.orbwalking.Mode3 then return false end
	
	local lowestMinion = nil
	for _, minion in ipairs(enemyMinions.objects) do
		if ValidTarget(minion, spells[_Q].range) then
			if not lowestMinion then
				lowestMinion = minion
			else
				if minion.health < lowestMinion.health then lowestMinion = minion end
			end
		end
	end
	
	if not lowestMinion then return end
	
	sow:DisableAttacks()
	if menu.lastHit.useQ and spells[_Q].base:IsReady() then
		local delay = spells[_Q].delay + GetDistance(lowestMinion.visionPos, annie.visionPos) / spells[_Q].speed - 0.07
		local predictedHealth = vPrediction:GetPredictedHealth(lowestMinion, delay)
		if predictedHealth <= damageLib:CalcSpellDamage(lowestMinion, _Q) and predictedHealth > 0 then
			spells[_Q].base:Cast(lowestMinion)
		end
	elseif menu.lastHit.useW and spells[_W].base:IsReady() then
		if damageLib:IsKillable(lowestMinion, { _W }) then spells[_W].base:Cast(lowestMinion) end
	end
	sow:EnableAttacks()
	
	return true

end

function PerformLaneClear()

	if not menu.orbwalking.Mode2 then return false end
	
	local lowestMinion = nil
	for _, minion in ipairs(enemyMinions.objects) do
		if ValidTarget(minion, spells[_Q].range) then
			if not lowestMinion then
				lowestMinion = minion
			else
				if minion.health < lowestMinion.health then lowestMinion = minion end
			end
		end
	end
	
	if not lowestMinion then return end
	
	sow:DisableAttacks()
	if menu.laneClear.useQ and spells[_Q].base:IsReady() then
		local delay = spells[_Q].delay + GetDistance(lowestMinion.visionPos, annie.visionPos) / spells[_Q].speed - 0.07
		local predictedHealth = vPrediction:GetPredictedHealth(lowestMinion, delay)
		if predictedHealth <= damageLib:CalcSpellDamage(lowestMinion, _Q) and predictedHealth > 0 then
			spells[_Q].base:Cast(lowestMinion)
		end
	elseif menu.laneClear.useW and spells[_W].base:IsReady() then
		if damageLib:IsKillable(lowestMinion, { _W }) then spells[_W].base:Cast(lowestMinion) end
	end
	sow:EnableAttacks()
	
	return true

end

function CommandTibbers()

	if not tibbers or menu.auto.tibbers == 1 or controllingTibbers then return end

	if menu.auto.tibbers == 2 then
		if currentTarget then
			spells[_R].base:Cast(currentTarget)
		else
			local target = simpleTS:GetTarget(fogRange)
			if ValidTarget(target) then spells[_R]:Cast(target) end
		end
	elseif menu.auto.tibbers == 3 then
		spells[_R].base:Cast(annie.x, annie.z)
	end

end

function UpdatePermaShow()

	CustomPermaShow("Tư Combo (space)", menu.orbwalking.Mode0, menu.combo.permaShow, nil, nil, nil, 1)
	CustomPermaShow("Mixed Mode Active", menu.orbwalking.Mode1, menu.mixed.permaShow, nil, nil, nil, 2)
	CustomPermaShow("Xóa Lính Nhanh", menu.orbwalking.Mode2, menu.laneClear.permaShow, nil, nil, nil, 3)
	CustomPermaShow("Tư Ăn Lính", menu.orbwalking.Mode3, menu.lastHit.permaShow, nil, nil, nil, 4)
	CustomPermaShow("Auto KS", menu.ks.enabled, menu.ks.permaShow, nil, nil, nil, 5)

end

--[[ Misc. Methods ]]--

function AddTitleRow(menu, title)

	menu:addParam("nil", "", SCRIPT_PARAM_INFO, "")
	menu:addParam("nil", "-- "..title.." --", SCRIPT_PARAM_INFO, "")

end

function GetARGB(array)

	return ARGB(array[1], array[2], array[3], array[4])

end

function StatOverMin(stat, slider)

	if stat == "Health" then
		return annie.health > (annie.maxHealth * (slider / 100))
	elseif stat == "Mana" then
		return annie.mana > (annie.maxMana * (slider / 100))
	end

end

function HaveEnoughMana(combo)

	local canCast = true
	local totalMana = 0
	
	for _, spell in pairs(combo) do
		if not spells[spell].base:IsReady() then
			canCast = false
		elseif spell == _Q or spell == _W or spell == _R then
			totalMana = totalMana + spells[spell].base:GetManaUsage()
		end
	end
	
	return canCast and totalMana <= annie.mana

end

function UnderEnemyTower()

	for _, turret in ipairs(GetTurrets()) do
		if turret and turret.team ~= annie.team then
			if GetDistanceSqr(annie, turret) <= towerRange * towerRange then
				return true
			end
		end
	end
	
	return false

end

function KillComboToString(combo)

	local comboString = nil
	
	for _, spell in ipairs(combo) do
		local spellString = ""
		if spell == _Q then
			spellString = "Q"
		elseif spell == _W then
			spellString = "W"
		elseif spell == _E then
			spellString = "E"
		elseif spell == _R then
			spellString = "R"
		elseif spell == _DFG then
			spellString = "DFG"
		elseif spell == _FQC then
			spellString = "FQC"
		elseif spell == _IGNITE then
			spellString = "Ignite"
		end
		if not comboString then
			comboString = spellString
		else
			comboString = comboString.."/"..spellString
		end
	end
	
	return comboString.." = Kill"

end

function CheckTickManager(tm)

	if not menu.misc.useTM then
		return true
	else
		return tm:IsReady()
	end

end

function HandlePerforms()

	if PerformKillsteal() then return end
	if PerformAutoStun() then return end
	if PerformCombo() then return end
	if PerformMixed() then return end
	if PerformLastHit() then return end
	if PerformLaneClear() then return end
	
end

function CastCombo(target, useQ, useW, useR, useDFG, useFQC, useIgnite, combo)

	combo = combo or { }
	local performed = true
	
	sow:DisableAttacks()
	if #combo > 0 then
		if HaveEnoughMana(combo) then
			for _, spell in pairs(combo) do
				spells[spell].base:Cast(target)
			end
		else
			performed = false
		end
	else
		if useR and stunReady and spells[_R].base:IsReady() then spells[_R].base:Cast(target) end
		if useQ and spells[_Q].base:IsReady() then spells[_Q].base:Cast(target) end
		if useW and spells[_W].base:IsReady() then spells[_W].base:Cast(target) end
	end
	sow:EnableAttacks()
	
	return performed

end

--[[ Classes ]]--

class "Summoner"
function Summoner:__init(slot, range)

	self.slot = slot
	self.range = range

end

function Summoner:IsReady()

	return self.slot and annie:CanUseSpell(self.slot) == READY

end

function Summoner:InRange(target)

	return GetDistanceSqr(target, annie) <= self.range * self.range

end

function Summoner:Cast(param1, param2)

	if self.slot then
		if param1 ~= nil and param2 ~= nil then
			CastSpell(self.slot, param1, param2)
		elseif param1 ~= nil then
			CastSpell(self.slot, param1)
		end
	end

end

class "TickManager"
function TickManager:__init(ticks)
	
	self._ticks = ticks
	self._lastClock = 0
	self._currentClock = 0

end

function TickManager:IsReady()

	self._currentClock = os.clock()
	
	if self._currentClock < self._lastClock + (1 / self._ticks) then
		return false
	else
		self._lastClock = self._currentClock
		return true
	end

end
