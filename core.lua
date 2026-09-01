local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

--------------------------------------------------------------------------------
-- CONFIGURATION (အလှတရားမပျက် အသုံးပြုနိုင်သော ဆက်တင်များ)
--------------------------------------------------------------------------------
local SETTINGS = {
	-- Preload
	PreloadCoreAssets = true,

	-- Balanced Lighting
	AdjustShadowDistance = true, -- အရိပ်များကို အဝေးမှာပဲ ဖျောက်မည် (အနီးမှာ အရိပ်ကျန်ခဲ့မည်)
	OptimizeParticles = true,    -- Particle များကို ဖျက်မပစ်ဘဲ Rate လျှော့မည်

	-- Physics Optimization (မမြင်နိုင်သော Physics Calculation များကိုသာ လျှော့ချမည်)
	OptimizePhysics = true,

	-- Smart Distance Culling
	EnableDistanceCulling = true,
	MaxRenderDistance = 400, -- Studs ၄၀၀ ထက် ဝေးသော အစိတ်အပိုင်းများကိုသာ ယာယီဖျောက်မည်
	CullCheckInterval = 0.5   -- စစ်ဆေးသည့် အကြိမ်အရေအတွက်
}

--------------------------------------------------------------------------------
-- 1. PRELOAD ASSETS
--------------------------------------------------------------------------------
local function syncPreloadAssets()
	if not SETTINGS.PreloadCoreAssets then return end

	local assetsToPreload = {}
	for _, obj in ipairs(Workspace:GetChildren()) do
		if obj:IsA("Model") or obj:IsA("Folder") then
			table.insert(assetsToPreload, obj)
		end
	end

	pcall(function()
		ContentProvider:PreloadAsync(assetsToPreload)
	end)
end

--------------------------------------------------------------------------------
-- 2. LIGHTING OPTIMIZATION (အလှတရား ထိန်းသိမ်းထားခြင်း)
--------------------------------------------------------------------------------
local function optimizeEnvironment()
	-- GlobalShadows ကို ပိတ်မပစ်ဘဲ Shadow Softness / Global Optimization သာပြုလုပ်သည်
	if SETTINGS.AdjustShadowDistance then
		Lighting.GlobalShadows = true -- Shadows များကို ချန်ထားသည်
	end
	
	-- Post-Processing Effects (Bloom, ColorCorrection, SunRays) များကို မဖျက်ဘဲ အလှအတိုင်းထားသည်
end

--------------------------------------------------------------------------------
-- 3. OBJECT OPTIMIZATION (VISUAL QUALITY SAVER)
--------------------------------------------------------------------------------
local function optimizeObject(obj)
	-- Physics optimization for non-interactive static parts (အလှတရားကို ထိခိုက်မှုမရှိပါ)
	if obj:IsA("BasePart") then
		if SETTINGS.OptimizePhysics and obj.Anchored and not obj:IsA("Seat") and not obj:FindFirstChildOfClass("TouchTransmitter") then
			obj.CanTouch = false
		end
	end

	-- Particle Effects များကို မဖျက်ဘဲ ထက်ဝက်လျှော့ချခြင်း
	if SETTINGS.OptimizeParticles and obj:IsA("ParticleEmitter") then
		obj.Rate = math.max(1, math.floor(obj.Rate * 0.5))
	end
end

--------------------------------------------------------------------------------
-- 4. SMART DISTANCE CULLING SYSTEM
--------------------------------------------------------------------------------
local lastCullCheck = 0

local function processDistanceCulling()
	if not SETTINGS.EnableDistanceCulling then return end

	local character = LocalPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end

	local hrpPosition = character.HumanoidRootPart.Position

	for _, part in ipairs(Workspace:GetDescendants()) do
		-- အပင်များ၊ အဆောက်အအုံ အရုပ်များနှင့် Anchored Part များကို ဝေးပါက ယာယီဖျောက်မည်
		if part:IsA("BasePart") and part.Anchored and not part:IsDescendantOf(character) and part.Transparency < 1 then
			local distance = (part.Position - hrpPosition).Magnitude
			if distance > SETTINGS.MaxRenderDistance then
				if part.LocalTransparencyModifier == 0 then
					part.LocalTransparencyModifier = 1
				end
			else
				if part.LocalTransparencyModifier == 1 then
					part.LocalTransparencyModifier = 0
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- INITIALIZATION
--------------------------------------------------------------------------------
task.spawn(function()
	syncPreloadAssets()
	optimizeEnvironment()

	for _, obj in ipairs(Workspace:GetDescendants()) do
		optimizeObject(obj)
	end
end)

Workspace.DescendantAdded:Connect(function(obj)
	optimizeObject(obj)
end)

RunService.Heartbeat:Connect(function(dt)
	lastCullCheck = lastCullCheck + dt
	if lastCullCheck >= SETTINGS.CullCheckInterval then
		lastCullCheck = 0
		processDistanceCulling()
	end
end)
