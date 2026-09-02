local ContentProvider = game:GetService("ContentProvider")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

--------------------------------------------------------------------------------
-- CONFIGURATION
--------------------------------------------------------------------------------
local SETTINGS = {
	OptimizeParticles = true,
	DisableCastShadows = true, -- Block တွေရဲ့ အရိပ်ကို ပိတ်ပြီး FPS မြှင့်မည်
	LowPhysicsPrecision = true -- Non-anchored Parts များကို Physics စိစစ်မှု လျှော့မည်
}

--------------------------------------------------------------------------------
-- SAFE LIGHTING OPTIMIZATION
--------------------------------------------------------------------------------
local function optimizeLighting()
	-- Frame drop သက်သာစေရန် Global Shadow ကို ဖျောက်ထားပါမည်
	game:GetService("Lighting").GlobalShadows = false
end

--------------------------------------------------------------------------------
-- ONE-TIME OBJECT OPTIMIZER (Loop မသုံးဘဲ ၁ ကြိမ်သာ ပြင်မည်)
--------------------------------------------------------------------------------
local function optimizeObject(obj)
	-- 1. Particle Emitters (FPS လျှော့မသွားအောင် Particle အရေအတွက် လျှော့မည်)
	if SETTINGS.OptimizeParticles and obj:IsA("ParticleEmitter") then
		obj.Rate = math.clamp(math.floor(obj.Rate * 0.2), 1, 5)
	end

	-- 2. BaseParts Optimization
	if obj:IsA("BasePart") then
		-- CastShadow ပိတ်ခြင်းဖြင့် GPU Frame Drop ကို တားဆီးမည်
		if SETTINGS.DisableCastShadows then
			obj.CastShadow = false
		end
		
		-- Physics Calculation ကို အနည်းဆုံးအထိ လျှော့ချမည်
		if SETTINGS.LowPhysicsPrecision and obj.Anchored then
			obj.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
		end
	end

	-- 3. Decals & Textures (Frame Drop မဖြစ်အောင် Material ရှင်းမည်)
	if obj:IsA("Decal") or obj:IsA("Texture") then
		if obj.Parent and not obj.Parent:IsA("Model") then
			-- အရေးမကြီးသော Texture များကို လျှော့ချရန်
			obj.Texture = ""
		end
	end
end

--------------------------------------------------------------------------------
-- INITIALIZATION (BACKGROUND TASK)
--------------------------------------------------------------------------------
task.spawn(function()
	optimizeLighting()

	-- Workspace ထဲရှိ Object များကို Render Engine မထိခိုက်စေဘဲ ခွဲခြား ပြင်ဆင်မည်
	local descendants = Workspace:GetDescendants()
	for i = 1, #descendants do
		optimizeObject(descendants[i])
		
		-- Object 100 ခုတိုင်းမှာ Frame Drop မဖြစ်အောင် 1 Frame နားပါမည်
		if i % 100 == 0 then
			task.wait()
		end
	end
end)

-- Object သစ်များ ဝင်လာပါက သီးသန့် ပြင်ပေးမည်
Workspace.DescendantAdded:Connect(function(obj)
	optimizeObject(obj)
end)
