-- Combined Universal Anti-Lag & Preload System
-- Place in StarterPlayer -> StarterPlayerScripts

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
	-- Preload
	PreloadCoreAssets = true,

	-- Visual Stripping
	DisableShadows = true,
	DisablePostProcessing = true,
	OptimizeLighting = true,
	SimplifyMaterials = true,
	RemoveParticleEffects = true,
	RemoveDecalsAndTextures = false, -- Set to true for maximum FPS boost

	-- Physics Optimization
	OptimizePhysics = true,

	-- Distance Culling
	EnableDistanceCulling = true,
	MaxRenderDistance = 350, -- Studs away before parts hide
	CullCheckInterval = 1.0  -- Check distance every 1 second
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
-- 2. LIGHTING & POST-PROCESSING OPTIMIZATION
--------------------------------------------------------------------------------
local function optimizeEnvironment()
	if SETTINGS.DisableShadows then
		Lighting.GlobalShadows = false
	end

	if SETTINGS.DisablePostProcessing then
		for _, child in ipairs(Lighting:GetChildren()) do
			if child:IsA("PostEffect") or child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("BloomEffect") or child:IsA("DepthOfFieldEffect") then
				child.Enabled = false
			end
		end
	end

	if SETTINGS.OptimizeLighting then
		Lighting.FogEnd = 9e9
		Lighting.Technology = Enum.Technology.Compatibility
	end
end

--------------------------------------------------------------------------------
-- 3. OBJECT OPTIMIZATION (VISUALS & PHYSICS)
--------------------------------------------------------------------------------
local function optimizeObject(obj)
	-- BasePart Visuals & Physics
	if obj:IsA("BasePart") then
		if SETTINGS.DisableShadows then
			obj.CastShadow = false
		end

		if SETTINGS.SimplifyMaterials then
			obj.Material = Enum.Material.SmoothPlastic
		end

		-- Disable physics triggers for non-interactive decorative parts
		if SETTINGS.OptimizePhysics and obj.Anchored and not obj:IsA("Seat") then
			obj.CanTouch = false
			obj.CanQuery = false
		end
	end

	-- Particles & Visual FX
	if SETTINGS.RemoveParticleEffects and (obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles")) then
		obj.Enabled = false
	end

	-- Decals / Textures
	if SETTINGS.RemoveDecalsAndTextures and (obj:IsA("Decal") or obj:IsA("Texture")) then
		obj:Destroy()
	end

	-- Special Meshes
	if obj:IsA("SpecialMesh") then
		obj.TextureId = ""
	end
end

--------------------------------------------------------------------------------
-- 4. DISTANCE-BASED CULLING SYSTEM
--------------------------------------------------------------------------------
local lastCullCheck = 0

local function processDistanceCulling()
	if not SETTINGS.EnableDistanceCulling then return end

	local character = LocalPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end

	local hrpPosition = character.HumanoidRootPart.Position

	for _, part in ipairs(Workspace:GetDescendants()) do
		if part:IsA("BasePart") and part.Anchored and not part:IsDescendantOf(character) then
			local distance = (part.Position - hrpPosition).Magnitude
			if distance > SETTINGS.MaxRenderDistance then
				part.LocalTransparencyModifier = 1
			else
				part.LocalTransparencyModifier = 0
			end
		end
	end
end

--------------------------------------------------------------------------------
-- INITIALIZATION & CONNECTIONS
--------------------------------------------------------------------------------
task.spawn(function()
	-- 1. Sync Preload
	syncPreloadAssets()

	-- 2. Optimize Environment
	optimizeEnvironment()

	-- 3. Optimize Existing Objects
	for _, obj in ipairs(Workspace:GetDescendants()) do
		optimizeObject(obj)
	end
end)

-- Continuously handle new objects entering the Workspace
Workspace.DescendantAdded:Connect(function(obj)
	optimizeObject(obj)
end)

-- Run Distance Culling on Heartbeat Loop
RunService.Heartbeat:Connect(function(dt)
	lastCullCheck = lastCullCheck + dt
	if lastCullCheck >= SETTINGS.CullCheckInterval then
		lastCullCheck = 0
		processDistanceCulling()
	end
end)
