local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

--------------------------------------------------------------------------------
-- CONFIGURATION
--------------------------------------------------------------------------------
local SETTINGS = {
	PreloadCoreAssets = true,
	OptimizeParticles = true,
	
	EnableDistanceCulling = true,
	MaxRenderDistance = 300, -- Studs ၃၀၀ ထက် ဝေးပါက ခဏဖျောက်မည်
	CullCheckInterval = 1.5   -- စက္ကန့် ၁.၅ စက္ကန့်မှ တစ်ခါပဲ စစ်မည် (CPU Lag သက်သာစေရန်)
}

--------------------------------------------------------------------------------
-- 1. OPTIMIZED PRELOAD (Lag မဖြစ်အောင် ခွဲဆွဲခြင်း)
--------------------------------------------------------------------------------
local function syncPreloadAssets()
	if not SETTINGS.PreloadCoreAssets then return end

	local assetsToPreload = Workspace:GetChildren()
	
	-- Asset များကို တစ်ပြိုင်နက်တည်း မဆွဲဘဲ ခွဲဆွဲခြင်းဖြင့် Freeze Lag ကို ကာကွယ်သည်
	task.spawn(function()
		for i = 1, #assetsToPreload do
			pcall(function()
				ContentProvider:PreloadAsync({assetsToPreload[i]})
			end)
			if i % 5 == 0 then task.wait() end -- Frame Drop မဖြစ်အောင် ခဏနားသည်
		end
	end)
end

--------------------------------------------------------------------------------
-- 2. OBJECT OPTIMIZATION
--------------------------------------------------------------------------------
local function optimizeObject(obj)
	-- Particle Effects လျှော့ချခြင်း
	if SETTINGS.OptimizeParticles and obj:IsA("ParticleEmitter") then
		obj.Rate = math.max(1, math.floor(obj.Rate * 0.4))
	end
end

--------------------------------------------------------------------------------
-- 3. LAG-FREE DISTANCE CULLING SYSTEM
--------------------------------------------------------------------------------
local lastCullCheck = 0

local function processDistanceCulling()
	if not SETTINGS.EnableDistanceCulling then return end

	local character = LocalPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end

	local hrpPosition = character.HumanoidRootPart.Position

	-- Workspace တစ်ခုလုံးကို မရှာတော့ဘဲ တကယ့် BasePart များကိုသာ သီးသန့် ရယူစစ်ဆေးမည်
	task.spawn(function()
		for _, part in ipairs(Workspace:GetChildren()) do
			-- Player Character များကို မထိခိုက်စေရန်
			if part:IsA("BasePart") and part.Anchored and part.Transparency < 1 then
				local distance = (part.Position - hrpPosition).Magnitude
				if distance > SETTINGS.MaxRenderDistance then
					part.LocalTransparencyModifier = 1
				else
					part.LocalTransparencyModifier = 0
				end
			end
		end
	end)
end

--------------------------------------------------------------------------------
-- INITIALIZATION
--------------------------------------------------------------------------------
task.spawn(function()
	syncPreloadAssets()

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
