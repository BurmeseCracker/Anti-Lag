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

-- 2. Main Frame (Draggable Box) ဖန်တီးခြင်း
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 160, 110)
mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

-- Rounded Corner & Stroke
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(50, 50, 70)
uiStroke.Thickness = 1.5
uiStroke.Parent = mainFrame

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 10)
uiPadding.PaddingBottom = UDim.new(0, 10)
uiPadding.PaddingLeft = UDim.new(0, 12)
uiPadding.PaddingRight = UDim.new(0, 12)
uiPadding.Parent = mainFrame

-- UI Layout
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = mainFrame

-- 3. FPS Label
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSLabel"
fpsLabel.Size = UDim2.new(1, 0, 0, 22)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 14
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Text = "FPS  : --"
fpsLabel.LayoutOrder = 1
fpsLabel.Parent = mainFrame

-- 4. Ping Label
local pingLabel = Instance.new("TextLabel")
pingLabel.Name = "PingLabel"
pingLabel.Size = UDim2.new(1, 0, 0, 22)
pingLabel.BackgroundTransparency = 1
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 14
pingLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.Text = "PING : -- ms"
pingLabel.LayoutOrder = 2
pingLabel.Parent = mainFrame

-- 5. Rejoin Button
local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Name = "RejoinButton"
rejoinBtn.Size = UDim2.new(1, 0, 0, 24)
rejoinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.TextSize = 12
rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinBtn.Text = "Rejoin Server"
rejoinBtn.LayoutOrder = 3
rejoinBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = rejoinBtn

-- =========================================
-- 6. Draggable System
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
-- 7. Dynamic Color Logic
-- =========================================
local function getFpsColor(fps)
	if fps >= 50 then
		return Color3.fromRGB(0, 255, 120)
	elseif fps >= 30 then
		return Color3.fromRGB(255, 200, 0)
	else
		return Color3.fromRGB(255, 50, 50)
	end
end

local function getPingColor(ping)
	if ping <= 100 then
		return Color3.fromRGB(0, 255, 120)
	elseif ping <= 200 then
		return Color3.fromRGB(255, 200, 0)
	else
		return Color3.fromRGB(255, 40, 40)
	end
end

-- =========================================
-- 8. FPS & Ping Tracker Loop
-- =========================================
local lastUpdate = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
	frameCount = frameCount + 1
	local currentTime = tick()

	if currentTime - lastUpdate >= 0.5 then
		local fps = math.round(frameCount / (currentTime - lastUpdate))
		fpsLabel.Text = string.format("FPS  : %d", fps)
		fpsLabel.TextColor3 = getFpsColor(fps)

		local ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		pingLabel.Text = string.format("PING : %d ms", ping)
		pingLabel.TextColor3 = getPingColor(ping)

		frameCount = 0
		lastUpdate = currentTime
	end
end)

-- =========================================
-- 9. Rejoin Logic & Teleport Queue
-- =========================================
rejoinBtn.MouseButton1Click:Connect(function()
	local queue_on_teleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
	
	if queue_on_teleport then
		queue_on_teleport([[
			repeat task.wait() until game:IsLoaded()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/BurmeseCracker/Anti-Lag/refs/heads/main/opt.lua"))()
		]])
	end

	rejoinBtn.Text = "Rejoining..."
	if #Players:GetPlayers() <= 1 then
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	else
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
	end
end)
