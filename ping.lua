-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Script 1 က ဖန်တီးထားသော UI များကို ရယူခြင်း
local screenGui = PlayerGui:WaitForChild("PingFPSGui")
local statsFrame = screenGui:WaitForChild("StatsFrame")
local pingLabel = statsFrame:WaitForChild("PingLabel")
local fpsLabel = statsFrame:WaitForChild("FPSLabel")

local lagFrame = screenGui:WaitForChild("LagFrame")
local buttonContainer = lagFrame:WaitForChild("ButtonContainer")
local yesBtn = buttonContainer:WaitForChild("YesButton")
local noBtn = buttonContainer:WaitForChild("NoButton")

-- 1. Draggable Function
local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

makeDraggable(statsFrame)
makeDraggable(lagFrame)

-- 2. Color Helper Functions
local function getFpsColor(fps)
	if fps >= 50 then return Color3.fromRGB(0, 255, 120)
	elseif fps >= 30 then return Color3.fromRGB(255, 200, 0)
	else return Color3.fromRGB(255, 50, 50) end
end

local function getPingColor(ping)
	if ping <= 100 then return Color3.fromRGB(0, 255, 120)
	elseif ping <= 200 then return Color3.fromRGB(255, 200, 0)
	else return Color3.fromRGB(255, 40, 40) end
end

-- 3. Ping/FPS Realtime Tracker & 1-Min Lag Detection
local lastUpdate = tick()
local frameCount = 0
local highPingTimer = 0
local isPromptShown = false

RunService.RenderStepped:Connect(function()
	frameCount = frameCount + 1
	local currentTime = tick()

	if currentTime - lastUpdate >= 0.5 then
		local interval = currentTime - lastUpdate
		
		-- FPS Update
		local fps = math.round(frameCount / interval)
		fpsLabel.Text = "FPS: " .. tostring(fps)
		fpsLabel.TextColor3 = getFpsColor(fps)

		-- Ping Update
		local ping = 0
		pcall(function()
			ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		end)
		pingLabel.Text = "PING: " .. tostring(ping) .. " ms"
		pingLabel.TextColor3 = getPingColor(ping)

		-- Ping > 200 ms ဖြစ်မှ စက္ကန့် စမှတ်မည်
		if ping > 200 then
			highPingTimer = highPingTimer + interval
		else
			if not isPromptShown then
				highPingTimer = 0
			end
		end

		-- ၁ မိနစ် (၆၀ စက္ကန့်) နီတာ ပြည့်သွားမှ Lag Box ပေါ်လာမည်
		if highPingTimer >= 30 and not isPromptShown then
			isPromptShown = true
			lagFrame.Visible = true
		end

		frameCount = 0
		lastUpdate = currentTime
	end
end)

-- 4. Fast Rejoin & FFlags
local function applyFastRejoinFFlags()
	local setfflag = setfflag or set_fflag or (setfflag and setfflag)
	if setfflag then
		pcall(function()
			setfflag("DFIntTaskSchedulerTargetFps", "9999")
			setfflag("FIntTaskSchedulerTargetFps", "9999")
			setfflag("MaxSlop", "-99999")
			setfflag("FIntMaxSlop", "-99999")
			setfflag("DFIntMaxSlop", "-99999")
			setfflag("TeleportInGameQueueMode", "True")
			setfflag("PreloadAllAssetsOnTeleport", "False")
			setfflag("FFlagDebugDisableTeleportGui", "True")
			setfflag("FFlagEnableFastTeleporting2", "True")
			setfflag("FFlagTeleportServerTimeoutMs", "3000")
		end)
	end
end

-- 5. Button Actions
noBtn.MouseButton1Click:Connect(function()
	lagFrame.Visible = false
	isPromptShown = false
	highPingTimer = 0
end)

yesBtn.MouseButton1Click:Connect(function()
	local queue_on_teleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
	
	applyFastRejoinFFlags()

	if queue_on_teleport then
		queue_on_teleport([[
			repeat task.wait() until game:IsLoaded()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/BurmeseCracker/Anti-Lag/refs/heads/main/opt.lua"))()
		]])
	end

	yesBtn.Text = "Rejoining..."

	task.spawn(function()
		if #Players:GetPlayers() <= 1 then
			TeleportService:Teleport(game.PlaceId, LocalPlayer)
		else
			TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
		end
	end)
end)
