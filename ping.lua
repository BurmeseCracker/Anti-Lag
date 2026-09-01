-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 1. Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PingFPSGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- =========================================
-- A. PING & FPS UI (အမြဲတမ်း Visible = True)
-- =========================================
local statsFrame = Instance.new("Frame")
statsFrame.Name = "StatsFrame"
statsFrame.Size = UDim2.new(0, 110, 0, 50)
statsFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
statsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
statsFrame.BorderSizePixel = 0
statsFrame.Active = true
statsFrame.Visible = true -- Ping & FPS ကို အမြဲမြင်ရမည်
statsFrame.Parent = screenGui

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 8)
statsCorner.Parent = statsFrame

local statsStroke = Instance.new("UIStroke")
statsStroke.Color = Color3.fromRGB(50, 50, 70)
statsStroke.Thickness = 1.5
statsStroke.Parent = statsFrame

local statsPadding = Instance.new("UIPadding")
statsPadding.PaddingTop = UDim.new(0, 6)
statsPadding.PaddingLeft = UDim.new(0, 10)
statsPadding.Parent = statsFrame

local statsList = Instance.new("UIListLayout")
statsList.SortOrder = Enum.SortOrder.LayoutOrder
statsList.Padding = UDim.new(0, 2)
statsList.Parent = statsFrame

-- Ping Display Label
local pingLabel = Instance.new("TextLabel")
pingLabel.Name = "PingLabel"
pingLabel.Size = UDim2.new(1, 0, 0, 18)
pingLabel.BackgroundTransparency = 1
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 12
pingLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.Text = "PING: -- ms"
pingLabel.LayoutOrder = 1
pingLabel.Parent = statsFrame

-- FPS Display Label
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSLabel"
fpsLabel.Size = UDim2.new(1, 0, 0, 18)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 12
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Text = "FPS: --"
fpsLabel.LayoutOrder = 2
fpsLabel.Parent = statsFrame

-- =========================================
-- B. LAG DETECTION PROMPT BOX (သီးသန့် GUI Frame)
-- =========================================
local lagFrame = Instance.new("Frame")
lagFrame.Name = "LagFrame"
lagFrame.Size = UDim2.new(0, 240, 0, 140)
lagFrame.Position = UDim2.new(0.5, -120, 0.4, -70) -- စခရင်အလယ်တွင် ပေါ်မည်
lagFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
lagFrame.BorderSizePixel = 0
lagFrame.Active = true
lagFrame.Visible = false -- ၁ မိနစ်ပြည့်မှ ပေါ်မည်
lagFrame.Parent = screenGui

local lagCorner = Instance.new("UICorner")
lagCorner.CornerRadius = UDim.new(0, 12)
lagCorner.Parent = lagFrame

local lagStroke = Instance.new("UIStroke")
lagStroke.Color = Color3.fromRGB(255, 60, 60)
lagStroke.Thickness = 1.5
lagStroke.Parent = lagFrame

local lagPadding = Instance.new("UIPadding")
lagPadding.PaddingTop = UDim.new(0, 12)
lagPadding.PaddingBottom = UDim.new(0, 12)
lagPadding.PaddingLeft = UDim.new(0, 12)
lagPadding.PaddingRight = UDim.new(0, 12)
lagPadding.Parent = lagFrame

local lagList = Instance.new("UIListLayout")
lagList.SortOrder = Enum.SortOrder.LayoutOrder
lagList.Padding = UDim.new(0, 8)
lagList.Parent = lagFrame

-- Title: Lag Detection
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 15
titleLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Text = "Lag Detection"
titleLabel.LayoutOrder = 1
titleLabel.Parent = lagFrame

-- Description
local descLabel = Instance.new("TextLabel")
descLabel.Name = "DescLabel"
descLabel.Size = UDim2.new(1, 0, 0, 36)
descLabel.BackgroundTransparency = 1
descLabel.Font = Enum.Font.Gotham
descLabel.TextSize = 11
descLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
descLabel.TextWrapped = true
descLabel.TextXAlignment = Enum.TextXAlignment.Left
descLabel.TextYAlignment = Enum.TextYAlignment.Top
descLabel.Text = "Rejoining will be more better experienced, wanna rejoin ?"
descLabel.LayoutOrder = 2
descLabel.Parent = lagFrame

-- Buttons Container
local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(1, 0, 0, 32)
buttonContainer.BackgroundTransparency = 1
buttonContainer.LayoutOrder = 3
buttonContainer.Parent = lagFrame

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.Padding = UDim.new(0, 8)
buttonLayout.Parent = buttonContainer

-- Yes Button
local yesBtn = Instance.new("TextButton")
yesBtn.Name = "YesButton"
yesBtn.Size = UDim2.new(0.5, -4, 1, 0)
yesBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
yesBtn.Font = Enum.Font.GothamBold
yesBtn.TextSize = 13
yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
yesBtn.Text = "Yes"
yesBtn.Parent = buttonContainer

local yesCorner = Instance.new("UICorner")
yesCorner.CornerRadius = UDim.new(0, 6)
yesCorner.Parent = yesBtn

-- No Button
local noBtn = Instance.new("TextButton")
noBtn.Name = "NoButton"
noBtn.Size = UDim2.new(0.5, -4, 1, 0)
noBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
noBtn.Font = Enum.Font.GothamBold
noBtn.TextSize = 13
noBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noBtn.Text = "No"
noBtn.Parent = buttonContainer

local noCorner = Instance.new("UICorner")
noCorner.CornerRadius = UDim.new(0, 6)
noCorner.Parent = noBtn

-- =========================================
-- 3. Draggable System (Frame နှစ်ခုလုံးအတွက်)
-- =========================================
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

-- =========================================
-- 4. Color Logic
-- =========================================
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

-- =========================================
-- 5. Realtime Ping/FPS Tracker + 1-Min Lag Logic
-- =========================================
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

		-- Ping > 200 ms ဖြစ်ပါက Timer စမှတ်မည်
		if ping > 200 then
			highPingTimer = highPingTimer + interval
		else
			if not isPromptShown then
				highPingTimer = 0
			end
		end

		-- ၁ မိနစ် (၆၀ စက္ကန့်) ပြည့်ပါက Lag Detection Box ပေါ်လာမည်
		if highPingTimer >= 30 and not isPromptShown then
			isPromptShown = true
			lagFrame.Visible = true
		end

		frameCount = 0
		lastUpdate = currentTime
	end
end)

-- =========================================
-- 6. Rejoin Logic & Fast FFlags
-- =========================================
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

-- No Button: Lag Box ကို ပိတ်မည်
noBtn.MouseButton1Click:Connect(function()
	lagFrame.Visible = false
	isPromptShown = false
	highPingTimer = 0
end)

-- Yes Button: Rejoin မည်
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
