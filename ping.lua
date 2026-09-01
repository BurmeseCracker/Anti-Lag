-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 1. ScreenGui ဖန်တီးခြင်း
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PingFPSGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- 2. Main Frame (Draggable Box) - စစချင်း မမြင်ရအောင် Enabled = false ပြုလုပ်ထားမည်
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 200)
mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Visible = false -- ၁ မိနစ်ပြည့်မှ ပေါ်လာမည်
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(50, 50, 70)
uiStroke.Thickness = 1.5
uiStroke.Parent = mainFrame

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 12)
uiPadding.PaddingBottom = UDim.new(0, 12)
uiPadding.PaddingLeft = UDim.new(0, 12)
uiPadding.PaddingRight = UDim.new(0, 12)
uiPadding.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)
listLayout.Parent = mainFrame

-- 3. Header Title (Lag Detection)
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
titleLabel.Parent = mainFrame

-- 4. FPS & Ping Display
local statsContainer = Instance.new("Frame")
statsContainer.Name = "StatsContainer"
statsContainer.Size = UDim2.new(1, 0, 0, 24)
statsContainer.BackgroundTransparency = 1
statsContainer.LayoutOrder = 2
statsContainer.Parent = mainFrame

local statsLayout = Instance.new("UIListLayout")
statsLayout.FillDirection = Enum.FillDirection.Horizontal
statsLayout.HorizontalAlignment = Enum.HorizontalAlignment.SpaceBetween
statsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
statsLayout.Parent = statsContainer

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSLabel"
fpsLabel.Size = UDim2.new(0.48, 0, 1, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 13
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Text = "FPS: --"
fpsLabel.Parent = statsContainer

local pingLabel = Instance.new("TextLabel")
pingLabel.Name = "PingLabel"
pingLabel.Size = UDim2.new(0.48, 0, 1, 0)
pingLabel.BackgroundTransparency = 1
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 13
pingLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
pingLabel.TextXAlignment = Enum.TextXAlignment.Right
pingLabel.Text = "PING: -- ms"
pingLabel.Parent = statsContainer

-- 5. Notice Message
local descLabel = Instance.new("TextLabel")
descLabel.Name = "DescLabel"
descLabel.Size = UDim2.new(1, 0, 0, 40)
descLabel.BackgroundTransparency = 1
descLabel.Font = Enum.Font.Gotham
descLabel.TextSize = 12
descLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
descLabel.TextWrapped = true
descLabel.TextXAlignment = Enum.TextXAlignment.Left
descLabel.TextYAlignment = Enum.TextYAlignment.Top
descLabel.Text = "Rejoining will be more better experienced, wanna rejoin ?"
descLabel.LayoutOrder = 3
descLabel.Parent = mainFrame

-- 6. Buttons Container (Yes / No)
local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(1, 0, 0, 32)
buttonContainer.BackgroundTransparency = 1
buttonContainer.LayoutOrder = 4
buttonContainer.Parent = mainFrame

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
-- 7. Draggable System (ဖိဆွဲရွှေ့နိုင်သည့်စနစ်)
-- =========================================
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- =========================================
-- 8. Dynamic Color Logic
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
-- 9. FPS & Ping Tracker + 1 Minute High Ping Detection
-- =========================================
local lastUpdate = tick()
local frameCount = 0
local highPingDuration = 0 -- Ping နီနေသော ကြာချိန် (စက္ကန့်)
local isPromptShown = false

RunService.RenderStepped:Connect(function(deltaTime)
	frameCount = frameCount + 1
	local currentTime = tick()

	-- ၀.၅ စက္ကန့်တိုင်း Ping/FPS Update လုပ်ခြင်း
	if currentTime - lastUpdate >= 0.5 then
		local interval = currentTime - lastUpdate
		local fps = math.round(frameCount / interval)
		fpsLabel.Text = string.format("FPS: %d", fps)
		fpsLabel.TextColor3 = getFpsColor(fps)

		local ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		pingLabel.Text = string.format("PING: %d ms", ping)
		pingLabel.TextColor3 = getPingColor(ping)

		-- Ping > 200 ms (Ping နီနေလျှင်) အချိန်စမှတ်မည်
		if ping > 200 then
			highPingDuration = highPingDuration + interval
		else
			-- Ping ပြန်ကောင်းသွားပါက Timer ပြန်စပါမည်
			if not isPromptShown then
				highPingDuration = 0
			end
		end

		-- Ping နီတာ စက္ကန့် ၆၀ (၁ မိနစ်) ဆက်တိုက်ဖြစ်ပါက GUI ပေါ်လာမည်
		if highPingDuration >= 60 and not isPromptShown then
			isPromptShown = true
			mainFrame.Visible = true
		end

		frameCount = 0
		lastUpdate = currentTime
	end
end)

-- =========================================
-- 10. MaxSlop & Fast Rejoin Logic
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

-- No Button: GUI ကို ခဏပြန်ပိတ်ထားပြီး Timer ကို ပြန်စမည်
noBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	isPromptShown = false
	highPingDuration = 0
end)

-- Yes Button: MaxSlop ချိန်ပြီး Fast Rejoin ဖြင့် Teleport လုပ်မည်
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
