-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 1. Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PingFPSGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- =========================================
-- A. PING & FPS UI (အမြဲ Visible = True)
-- =========================================
local statsFrame = Instance.new("Frame")
statsFrame.Name = "StatsFrame"
statsFrame.Size = UDim2.new(0, 110, 0, 50)
statsFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
statsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
statsFrame.BorderSizePixel = 0
statsFrame.Active = true
statsFrame.Visible = true
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
-- B. LAG DETECTION PROMPT BOX (Visible = False)
-- =========================================
local lagFrame = Instance.new("Frame")
lagFrame.Name = "LagFrame"
lagFrame.Size = UDim2.new(0, 240, 0, 140)
lagFrame.Position = UDim2.new(0.5, -120, 0.4, -70)
lagFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
lagFrame.BorderSizePixel = 0
lagFrame.Active = true
lagFrame.Visible = false
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
