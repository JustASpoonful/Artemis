-- ==================== ARTEMIS - PREMIUM AI ASSISTANT FOR ROBLOX ==================== -- Pro Edition with sidebar navigation and dedicated Pro page
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- ==================== EXECUTOR HTTP BYPASS ====================
local httpRequest = syn and syn.request or http and http.request or http_request or request
if not httpRequest then
	warn("Artemis → Your executor does not provide an http_request function.")
end

-- ==================== YOUR COMMANDS ====================
local commandUrls = {
	["essentials"] = "https://raw.githubusercontent.com/justaspoonful/Artemis/main/luau/noclip.lua",
	["fly"] = "https://yourdomain.com/lua/fly.lua",
	["infiniteyield"] = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",
	["speed"] = "https://example.com/lua/speed.lua",
}

-- ==================== GROQ CONFIG ====================
local GROQ_API_KEY = "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"
local GROQ_MODEL = "llama-3.1-8b-instant"
local messages = {
	{ role = "system", content = "You are Artemis, a premium, witty AI assistant running inside a Roblox executor. Be helpful, concise, and fun. Built-in commands (noclip, fly, infiniteyield, etc.) are handled locally." }
}

if player.PlayerGui:FindFirstChild("ArtemisUI") then
	player.PlayerGui.ArtemisUI:Destroy()
	wait(0.1)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ArtemisUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- ==================== COLORS ====================
local ACCENT_COLOR = Color3.fromRGB(190, 100, 210)
local GRAD_PURPLE = Color3.fromRGB(130, 80, 220)
local GRAD_MAGENTA = Color3.fromRGB(220, 70, 180)
local GRAD_PINK = Color3.fromRGB(255, 90, 170)
local GRAD_ORANGE = Color3.fromRGB(255, 140, 60)
local PRO_WHITE = Color3.fromRGB(255, 255, 255)

-- ==================== MAIN FRAME ====================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 380)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Subtle background gradient
local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(18,18,28)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(8,8,18))
}
mainGradient.Rotation = 135
mainGradient.Parent = mainFrame

-- Outer glow
local outerGlow = Instance.new("UIStroke")
outerGlow.Color = ACCENT_COLOR
outerGlow.Thickness = 4
outerGlow.Transparency = 0.88
outerGlow.Parent = mainFrame

-- Inner stroke
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = ACCENT_COLOR
mainStroke.Thickness = 1.2
mainStroke.Transparency = 0.75
mainStroke.Parent = mainFrame

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- ==================== SLIM SIDEBAR ====================
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 40, 1, -32)  -- Slimmer: 40px instead of 45
sidebar.Position = UDim2.new(0, 0, 0, 32)
sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 15)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarGradient = Instance.new("UIGradient")
sidebarGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(12,12,20)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(5,5,12))
}
sidebarGradient.Rotation = 90
sidebarGradient.Parent = sidebar

-- Sidebar divider
local sidebarDivider = Instance.new("Frame")
sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
sidebarDivider.Position = UDim2.new(1, -1, 0, 0)
sidebarDivider.BackgroundColor3 = ACCENT_COLOR
sidebarDivider.BorderSizePixel = 0
sidebarDivider.BackgroundTransparency = 0.7
sidebarDivider.Parent = sidebar

-- Home button with house emoji
local homeBtn = Instance.new("TextButton")
homeBtn.Name = "HomeBtn"
homeBtn.Size = UDim2.new(1, -8, 0, 36)  -- Slightly smaller
homeBtn.Position = UDim2.new(0, 4, 0, 8)
homeBtn.BackgroundColor3 = ACCENT_COLOR
homeBtn.BackgroundTransparency = 0.85
homeBtn.Text = "🏠"  -- House icon
homeBtn.TextColor3 = Color3.new(1, 1, 1)
homeBtn.Font = Enum.Font.GothamBold
homeBtn.TextSize = 18
homeBtn.BorderSizePixel = 0
homeBtn.Parent = sidebar

local homeBtnCorner = Instance.new("UICorner")
homeBtnCorner.CornerRadius = UDim.new(0, 8)
homeBtnCorner.Parent = homeBtn

local homeBtnStroke = Instance.new("UIStroke")
homeBtnStroke.Color = ACCENT_COLOR
homeBtnStroke.Thickness = 1
homeBtnStroke.Transparency = 0.5
homeBtnStroke.Parent = homeBtn

-- Pro button with star emoji
local proBtn = Instance.new("TextButton")
proBtn.Name = "ProBtn"
proBtn.Size = UDim2.new(1, -8, 0, 36)
proBtn.Position = UDim2.new(0, 4, 0, 52)  -- Adjusted for new size
proBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
proBtn.Text = "⭐"  -- Star icon
proBtn.TextColor3 = PRO_WHITE
proBtn.Font = Enum.Font.GothamBold
proBtn.TextSize = 18
proBtn.BorderSizePixel = 0
proBtn.Parent = sidebar

local proBtnCorner = Instance.new("UICorner")
proBtnCorner.CornerRadius = UDim.new(0, 8)
proBtnCorner.Parent = proBtn

local proBtnStroke = Instance.new("UIStroke")
proBtnStroke.Color = PRO_WHITE
proBtnStroke.Thickness = 1
proBtnStroke.Transparency = 0.7
proBtnStroke.Parent = proBtn

-- ==================== TITLE BAR ====================
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(22,22,32)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(45,35,65))
}
titleGradient.Parent = titleBar

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleBarLabel = Instance.new("TextLabel")
titleBarLabel.Size = UDim2.new(1, -56, 1, 0)
titleBarLabel.Position = UDim2.new(0, 10, 0, 0)
titleBarLabel.BackgroundTransparency = 1
titleBarLabel.Text = "Artemis"
titleBarLabel.Font = Enum.Font.GothamBold
titleBarLabel.TextSize = 11
titleBarLabel.TextColor3 = ACCENT_COLOR
titleBarLabel.TextXAlignment = Enum.TextXAlignment.Left
titleBarLabel.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 22, 0, 22)
minimizeBtn.Position = UDim2.new(1, -50, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 14
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 5)
minCorner.Parent = minimizeBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -24, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn

-- ==================== CONTENT CONTAINER ====================
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -40, 1, -32)  -- Adjusted for slimmer sidebar
contentContainer.Position = UDim2.new(0, 40, 0, 32)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- ==================== HOME PAGE ====================
local homePage = Instance.new("Frame")
homePage.Name = "HomePage"
homePage.Size = UDim2.new(1, 0, 1, 0)
homePage.BackgroundTransparency = 1
homePage.Visible = true
homePage.Parent = contentContainer

local artemisTitle = Instance.new("TextLabel")
artemisTitle.Name = "ArtemisTitle"
artemisTitle.Size = UDim2.new(1, -20, 0, 48)
artemisTitle.Position = UDim2.new(0, 10, 0, 8)
artemisTitle.BackgroundTransparency = 1
artemisTitle.Text = "Artemis"
artemisTitle.Font = Enum.Font.GothamBold
artemisTitle.TextSize = 38
artemisTitle.TextColor3 = Color3.new(1, 1, 1)
artemisTitle.Parent = homePage

-- Extended gradient for seamless looping
local gradientEffect = Instance.new("UIGradient")
gradientEffect.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.00, GRAD_PURPLE),
	ColorSequenceKeypoint.new(0.20, GRAD_MAGENTA),
	ColorSequenceKeypoint.new(0.40, GRAD_PINK),
	ColorSequenceKeypoint.new(0.60, GRAD_ORANGE),
	ColorSequenceKeypoint.new(0.80, GRAD_PURPLE),
	ColorSequenceKeypoint.new(1.00, GRAD_MAGENTA)
}
gradientEffect.Parent = artemisTitle

-- SEAMLESS flowing animation
task.spawn(function()
	local offset = 0
	while task.wait(0.025) do
		offset = offset + 0.008
		gradientEffect.Offset = Vector2.new(offset, 0)
	end
end)

local titleStroke = Instance.new("UIStroke")
titleStroke.Thickness = 2
titleStroke.Color = Color3.new(0,0,0)
titleStroke.Transparency = 0.65
titleStroke.Parent = artemisTitle

local greetingLabel = Instance.new("TextLabel")
greetingLabel.Name = "Greeting"
greetingLabel.Size = UDim2.new(1, -20, 0, 20)
greetingLabel.Position = UDim2.new(0, 10, 0, 60)
greetingLabel.BackgroundTransparency = 1
greetingLabel.Text = "What should I call you?"
greetingLabel.Font = Enum.Font.Gotham
greetingLabel.TextSize = 11
greetingLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
greetingLabel.Parent = homePage

-- Pro banner on home
local proHomeBanner = Instance.new("Frame")
proHomeBanner.Name = "ProBanner"
proHomeBanner.Size = UDim2.new(1, -16, 0, 48)
proHomeBanner.Position = UDim2.new(0, 8, 0, 84)
proHomeBanner.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
proHomeBanner.BorderSizePixel = 0
proHomeBanner.Parent = homePage

local proBannerCorner = Instance.new("UICorner")
proBannerCorner.CornerRadius = UDim.new(0, 8)
proBannerCorner.Parent = proHomeBanner

local proBannerStroke = Instance.new("UIStroke")
proBannerStroke.Color = PRO_WHITE
proBannerStroke.Thickness = 1.5
proBannerStroke.Transparency = 0.4
proBannerStroke.Parent = proHomeBanner

local proBannerGradient = Instance.new("UIGradient")
proBannerGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(28,28,35)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(18,18,25))
}
proBannerGradient.Rotation = 45
proBannerGradient.Parent = proHomeBanner

local proLabel = Instance.new("TextLabel")
proLabel.Name = "ProLabel"
proLabel.Size = UDim2.new(0, 40, 0, 18)
proLabel.Position = UDim2.new(0, 8, 0, 6)
proLabel.BackgroundColor3 = PRO_WHITE
proLabel.Text = "PRO"
proLabel.Font = Enum.Font.GothamBold
proLabel.TextSize = 10
proLabel.TextColor3 = Color3.fromRGB(15, 15, 20)
proLabel.BorderSizePixel = 0
proLabel.Parent = proHomeBanner

local proLabelCorner = Instance.new("UICorner")
proLabelCorner.CornerRadius = UDim.new(0, 4)
proLabelCorner.Parent = proLabel

local proText = Instance.new("TextLabel")
proText.Name = "ProText"
proText.Size = UDim2.new(1, -16, 0, 22)
proText.Position = UDim2.new(0, 8, 0, 24)
proText.BackgroundTransparency = 1
proText.Text = "Access to the most powerful AI model, one of a kind stealth technology"
proText.Font = Enum.Font.Gotham
proText.TextSize = 9
proText.TextColor3 = Color3.fromRGB(200, 200, 210)
proText.TextXAlignment = Enum.TextXAlignment.Left
proText.TextWrapped = true
proText.Parent = proHomeBanner

-- Chat container
local chatContainer = Instance.new("Frame")
chatContainer.Size = UDim2.new(1, -12, 1, -220)
chatContainer.Position = UDim2.new(0, 6, 0, 138)
chatContainer.BackgroundTransparency = 1
chatContainer.Parent = homePage

local chatLog = Instance.new("ScrollingFrame")
chatLog.Size = UDim2.new(1, 0, 1, 0)
chatLog.BackgroundTransparency = 1
chatLog.BorderSizePixel = 0
chatLog.ScrollBarThickness = 3
chatLog.ScrollBarImageColor3 = ACCENT_COLOR
chatLog.CanvasSize = UDim2.new(0, 0, 0, 0)
chatLog.Parent = chatContainer

local chatLayout = Instance.new("UIListLayout")
chatLayout.Padding = UDim.new(0, 6)
chatLayout.SortOrder = Enum.SortOrder.LayoutOrder
chatLayout.Parent = chatLog
chatLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	chatLog.CanvasSize = UDim2.new(0, 0, 0, chatLayout.AbsoluteContentSize.Y + 12)
	chatLog.CanvasPosition = Vector2.new(0, chatLog.AbsoluteCanvasSize.Y)
end)

-- Input container
local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(1, -12, 0, 34)
inputContainer.Position = UDim2.new(0, 6, 1, -42)
inputContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
inputContainer.BorderSizePixel = 0
inputContainer.Parent = homePage

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 17)
inputCorner.Parent = inputContainer

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(60, 60, 70)
inputStroke.Thickness = 1
inputStroke.Parent = inputContainer

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -48, 1, 0)
inputBox.Position = UDim2.new(0, 12, 0, 0)
inputBox.BackgroundTransparency = 1
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.PlaceholderText = "Type here..."
inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 11
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.ClearTextOnFocus = false
inputBox.Text = ""
inputBox.Parent = inputContainer

local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0, 28, 0, 28)
sendBtn.Position = UDim2.new(1, -34, 0.5, -14)
sendBtn.BackgroundColor3 = ACCENT_COLOR
sendBtn.Text = ">"
sendBtn.TextColor3 = Color3.new(1, 1, 1)
sendBtn.Font = Enum.Font.GothamBold
sendBtn.TextSize = 15
sendBtn.BorderSizePixel = 0
sendBtn.Parent = inputContainer

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(1, 0)
sendCorner.Parent = sendBtn

-- ==================== PRO PAGE ====================
local proPage = Instance.new("Frame")
proPage.Name = "ProPage"
proPage.Size = UDim2.new(1, 0, 1, 0)
proPage.BackgroundTransparency = 1
proPage.Visible = false
proPage.Parent = contentContainer

-- Pro page title
local proPageTitle = Instance.new("TextLabel")
proPageTitle.Size = UDim2.new(1, -20, 0, 48)
proPageTitle.Position = UDim2.new(0, 10, 0, 15)
proPageTitle.BackgroundTransparency = 1
proPageTitle.Text = "Artemis Pro"
proPageTitle.Font = Enum.Font.GothamBold
proPageTitle.TextSize = 32
proPageTitle.TextColor3 = PRO_WHITE
proPageTitle.Parent = proPage

local proPageTitleStroke = Instance.new("UIStroke")
proPageTitleStroke.Thickness = 2
proPageTitleStroke.Color = Color3.new(0,0,0)
proPageTitleStroke.Transparency = 0.65
proPageTitleStroke.Parent = proPageTitle

-- Pro subtitle
local proSubtitle = Instance.new("TextLabel")
proSubtitle.Size = UDim2.new(1, -20, 0, 16)
proSubtitle.Position = UDim2.new(0, 10, 0, 60)
proSubtitle.BackgroundTransparency = 1
proSubtitle.Text = "Unlock the ultimate experience"
proSubtitle.Font = Enum.Font.Gotham
proSubtitle.TextSize = 11
proSubtitle.TextColor3 = Color3.fromRGB(180, 180, 190)
proSubtitle.Parent = proPage

-- Feature card 1
local feature1 = Instance.new("Frame")
feature1.Size = UDim2.new(1, -20, 0, 70)
feature1.Position = UDim2.new(0, 10, 0, 90)
feature1.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
feature1.BorderSizePixel = 0
feature1.Parent = proPage

local feature1Corner = Instance.new("UICorner")
feature1Corner.CornerRadius = UDim.new(0, 10)
feature1Corner.Parent = feature1

local feature1Stroke = Instance.new("UIStroke")
feature1Stroke.Color = PRO_WHITE
feature1Stroke.Thickness = 1.5
feature1Stroke.Transparency = 0.3
feature1Stroke.Parent = feature1

local feature1Icon = Instance.new("TextLabel")
feature1Icon.Size = UDim2.new(0, 40, 0, 40)
feature1Icon.Position = UDim2.new(0, 12, 0, 15)
feature1Icon.BackgroundTransparency = 1
feature1Icon.Text = "🧠"  -- Brain icon
feature1Icon.Font = Enum.Font.GothamBold
feature1Icon.TextSize = 24
feature1Icon.Parent = feature1

local feature1Title = Instance.new("TextLabel")
feature1Title.Size = UDim2.new(1, -65, 0, 18)
feature1Title.Position = UDim2.new(0, 58, 0, 12)
feature1Title.BackgroundTransparency = 1
feature1Title.Text = "Advanced AI Model"
feature1Title.Font = Enum.Font.GothamBold
feature1Title.TextSize = 12
feature1Title.TextColor3 = PRO_WHITE
feature1Title.TextXAlignment = Enum.TextXAlignment.Left
feature1Title.Parent = feature1

local feature1Desc = Instance.new("TextLabel")
feature1Desc.Size = UDim2.new(1, -65, 0, 32)
feature1Desc.Position = UDim2.new(0, 58, 0, 32)
feature1Desc.BackgroundTransparency = 1
feature1Desc.Text = "Access to the most powerful AI models with superior reasoning"
feature1Desc.Font = Enum.Font.Gotham
feature1Desc.TextSize = 9
feature1Desc.TextColor3 = Color3.fromRGB(160, 160, 170)
feature1Desc.TextXAlignment = Enum.TextXAlignment.Left
feature1Desc.TextWrapped = true
feature1Desc.Parent = feature1

-- Feature card 2
local feature2 = Instance.new("Frame")
feature2.Size = UDim2.new(1, -20, 0, 70)
feature2.Position = UDim2.new(0, 10, 0, 170)
feature2.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
feature2.BorderSizePixel = 0
feature2.Parent = proPage

local feature2Corner = Instance.new("UICorner")
feature2Corner.CornerRadius = UDim.new(0, 10)
feature2Corner.Parent = feature2

local feature2Stroke = Instance.new("UIStroke")
feature2Stroke.Color = PRO_WHITE
feature2Stroke.Thickness = 1.5
feature2Stroke.Transparency = 0.3
feature2Stroke.Parent = feature2

local feature2Icon = Instance.new("TextLabel")
feature2Icon.Size = UDim2.new(0, 40, 0, 40)
feature2Icon.Position = UDim2.new(0, 12, 0, 15)
feature2Icon.BackgroundTransparency = 1
feature2Icon.Text = "🛡️"  -- Shield icon
feature2Icon.Font = Enum.Font.GothamBold
feature2Icon.TextSize = 24
feature2Icon.Parent = feature2

local feature2Title = Instance.new("TextLabel")
feature2Title.Size = UDim2.new(1, -65, 0, 18)
feature2Title.Position = UDim2.new(0, 58, 0, 12)
feature2Title.BackgroundTransparency = 1
feature2Title.Text = "Stealth Technology"
feature2Title.Font = Enum.Font.GothamBold
feature2Title.TextSize = 12
feature2Title.TextColor3 = PRO_WHITE
feature2Title.TextXAlignment = Enum.TextXAlignment.Left
feature2Title.Parent = feature2

local feature2Desc = Instance.new("TextLabel")
feature2Desc.Size = UDim2.new(1, -65, 0, 32)
feature2Desc.Position = UDim2.new(0, 58, 0, 32)
feature2Desc.BackgroundTransparency = 1
feature2Desc.Text = "One of a kind stealth technology for undetectable operation"
feature2Desc.Font = Enum.Font.Gotham
feature2Desc.TextSize = 9
feature2Desc.TextColor3 = Color3.fromRGB(160, 160, 170)
feature2Desc.TextXAlignment = Enum.TextXAlignment.Left
feature2Desc.TextWrapped = true
feature2Desc.Parent = feature2

-- Feature card 3
local feature3 = Instance.new("Frame")
feature3.Size = UDim2.new(1, -20, 0, 70)
feature3.Position = UDim2.new(0, 10, 0, 250)
feature3.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
feature3.BorderSizePixel = 0
feature3.Parent = proPage

local feature3Corner = Instance.new("UICorner")
feature3Corner.CornerRadius = UDim.new(0, 10)
feature3Corner.Parent = feature3

local feature3Stroke = Instance.new("UIStroke")
feature3Stroke.Color = PRO_WHITE
feature3Stroke.Thickness = 1.5
feature3Stroke.Transparency = 0.3
feature3Stroke.Parent = feature3

local feature3Icon = Instance.new("TextLabel")
feature3Icon.Size = UDim2.new(0, 40, 0, 40)
feature3Icon.Position = UDim2.new(0, 12, 0, 15)
feature3Icon.BackgroundTransparency = 1
feature3Icon.Text = "⚡"  -- Lightning
feature3Icon.Font = Enum.Font.GothamBold
feature3Icon.TextSize = 24
feature3Icon.Parent = feature3

local feature3Title = Instance.new("TextLabel")
feature3Title.Size = UDim2.new(1, -65, 0, 18)
feature3Title.Position = UDim2.new(0, 58, 0, 12)
feature3Title.BackgroundTransparency = 1
feature3Title.Text = "Priority Support"
feature3Title.Font = Enum.Font.GothamBold
feature3Title.TextSize = 12
feature3Title.TextColor3 = PRO_WHITE
feature3Title.TextXAlignment = Enum.TextXAlignment.Left
feature3Title.Parent = feature3

local feature3Desc = Instance.new("TextLabel")
feature3Desc.Size = UDim2.new(1, -65, 0, 32)
feature3Desc.Position = UDim2.new(0, 58, 0, 32)
feature3Desc.BackgroundTransparency = 1
feature3Desc.Text = "Lightning-fast responses and exclusive feature access"
feature3Desc.Font = Enum.Font.Gotham
feature3Desc.TextSize = 9
feature3Desc.TextColor3 = Color3.fromRGB(160, 160, 170)
feature3Desc.TextXAlignment = Enum.TextXAlignment.Left
feature3Desc.TextWrapped = true
feature3Desc.Parent = feature3

-- Coming soon badge
local comingSoonBadge = Instance.new("TextLabel")
comingSoonBadge.Size = UDim2.new(1, -20, 0, 24)
comingSoonBadge.Position = UDim2.new(0, 10, 1, -32)
comingSoonBadge.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
comingSoonBadge.BackgroundTransparency = 0.95
comingSoonBadge.Text = "COMING SOON"
comingSoonBadge.Font = Enum.Font.GothamBold
comingSoonBadge.TextSize = 10
comingSoonBadge.TextColor3 = PRO_WHITE
comingSoonBadge.BorderSizePixel = 0
comingSoonBadge.Parent = proPage

local comingSoonCorner = Instance.new("UICorner")
comingSoonCorner.CornerRadius = UDim.new(0, 6)
comingSoonCorner.Parent = comingSoonBadge

local comingSoonStroke = Instance.new("UIStroke")
comingSoonStroke.Color = PRO_WHITE
comingSoonStroke.Thickness = 1
comingSoonStroke.Transparency = 0.5
comingSoonStroke.Parent = comingSoonBadge

-- ==================== CHAT BUBBLES ====================
local function addMessage(isUser, text, textColor)
	local msgFrame = Instance.new("Frame")
	msgFrame.Size = UDim2.new(1, 0, 0, 0)
	msgFrame.BackgroundTransparency = 1
	msgFrame.AutomaticSize = Enum.AutomaticSize.Y
	msgFrame.Parent = chatLog

	local bubble = Instance.new("Frame")
	bubble.BackgroundColor3 = isUser and Color3.fromRGB(65, 115, 210) or Color3.fromRGB(32, 32, 42)
	bubble.Size = UDim2.new(0.75, 0, 0, 0)
	bubble.AutomaticSize = Enum.AutomaticSize.Y
	bubble.Parent = msgFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = bubble

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.PaddingTop = UDim.new(0, 7)
	padding.PaddingBottom = UDim.new(0, 7)
	padding.Parent = bubble

	local stroke = Instance.new("UIStroke")
	stroke.Color = isUser and Color3.fromRGB(110, 170, 255) or ACCENT_COLOR
	stroke.Thickness = 1
	stroke.Transparency = 0.4
	stroke.Parent = bubble

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 0, 0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Text = text
	label.TextColor3 = textColor or (isUser and Color3.fromRGB(235,235,235) or ACCENT_COLOR)
	label.Font = Enum.Font.Gotham
	label.TextSize = 10.5
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.Parent = bubble

	if isUser then
		bubble.Position = UDim2.new(1, -6, 0, 0)
		bubble.AnchorPoint = Vector2.new(1, 0)
	else
		bubble.Position = UDim2.new(0, 6, 0, 0)
		bubble.AnchorPoint = Vector2.new(0, 0)
	end
end

-- ==================== NAVIGATION ====================
local currentPage = "home"
local function switchPage(pageName)
	if pageName == "home" then
		homePage.Visible = true
		proPage.Visible = false
		homeBtn.BackgroundColor3 = ACCENT_COLOR
		homeBtn.BackgroundTransparency = 0.85
		homeBtnStroke.Color = ACCENT_COLOR
		proBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
		proBtn.BackgroundTransparency = 0
		proBtnStroke.Color = PRO_WHITE
		currentPage = "home"
	elseif pageName == "pro" then
		homePage.Visible = false
		proPage.Visible = true
		homeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
		homeBtn.BackgroundTransparency = 0
		homeBtnStroke.Color = ACCENT_COLOR
		proBtn.BackgroundColor3 = PRO_WHITE
		proBtn.BackgroundTransparency = 0.9
		proBtnStroke.Color = PRO_WHITE
		currentPage = "pro"
	end
end

homeBtn.MouseButton1Click:Connect(function()
	switchPage("home")
end)

proBtn.MouseButton1Click:Connect(function()
	switchPage("pro")
end)

-- ==================== HOVER EFFECTS ====================
local function addHover(btn, normalColor, hoverColor)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = normalColor}):Play()
	end)
end

addHover(sendBtn, ACCENT_COLOR, Color3.fromRGB(210, 125, 235))
addHover(minimizeBtn, Color3.fromRGB(40,40,50), Color3.fromRGB(65,65,80))
addHover(closeBtn, Color3.fromRGB(220,38,38), Color3.fromRGB(245,55,55))

-- Focus glow
inputBox.Focused:Connect(function()
	TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = ACCENT_COLOR, Thickness = 1.8}):Play()
end)
inputBox.FocusLost:Connect(function(enter)
	TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60,60,70), Thickness = 1}):Play()
	if enter then processInput() end
end)

-- ==================== DRAGGABLE ====================
local function makeDraggable(frame, handle)
	local dragging = false
	local dragInput, dragStart, startPos
	local function updateDrag(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then updateDrag(input) end
	end)
end
makeDraggable(mainFrame, titleBar)

-- ==================== MINIMIZE / CLOSE ====================
local isMinimized = false
local originalSize = UDim2.new(0, 300, 0, 380)
local minimizedSize = UDim2.new(0, 300, 0, 32)

minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	local targetSize = isMinimized and minimizedSize or originalSize
	local tweenInfo = TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	if isMinimized then
		contentContainer.Visible = false
		sidebar.Visible = false
		TweenService:Create(mainFrame, tweenInfo, {Size = targetSize}):Play()
		minimizeBtn.Text = "+"
	else
		contentContainer.Visible = true
		sidebar.Visible = true
		TweenService:Create(mainFrame, tweenInfo, {Size = targetSize}):Play()
		minimizeBtn.Text = "-"
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	TweenService:Create(mainFrame, TweenInfo.new(0.25), {Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0)}):Play()
	wait(0.25)
	screenGui:Destroy()
end)

-- ==================== UTILITY FUNCTIONS ====================
local function trimHistory()
	while #messages > 21 do table.remove(messages, 2) end
end

local function fetchUrl(url)
	if httpRequest then
		local res = httpRequest({Url = url, Method = "GET"})
		return (res and res.StatusCode == 200) and res.Body or nil
	else
		local s, c = pcall(game.HttpGet, game, url, true)
		return s and c or nil
	end
end

local function postToGroq(body)
	if httpRequest then
		local res = httpRequest({
			Url = "https://api.groq.com/openai/v1/chat/completions",
			Method = "POST",
			Headers = { ["Authorization"] = "Bearer " .. GROQ_API_KEY, ["Content-Type"] = "application/json" },
			Body = body
		})
		if res and res.StatusCode == 200 then return res.Body end
		return nil, res and res.Body or "Unknown error"
	else
		local s, r = pcall(HttpService.PostAsync, HttpService, "https://api.groq.com/openai/v1/chat/completions", body, Enum.HttpContentType.ApplicationJson, false, {["Authorization"] = "Bearer " .. GROQ_API_KEY})
		return s and r or nil, not s and r
	end
end

-- ==================== COMMAND PROCESSING ====================
local thinkingMessage = nil  -- Reference to the "thinking" bubble

local function processCommand(text)
	local lower = string.lower(text)
	if commandUrls[lower] then
		addMessage(false, "Fetching " .. text .. "...", ACCENT_COLOR)
		local content = fetchUrl(commandUrls[lower])
		if content and #content > 50 then
			local s, f = pcall(loadstring, content)
			if s and f then
				local es, ee = pcall(f)
				addMessage(false, es and "✅ " .. text .. " loaded!" or "❌ Execution error: " .. tostring(ee),
					es and Color3.fromRGB(80,255,160) or Color3.fromRGB(255,90,90))
			else
				addMessage(false, "❌ Failed to load script", Color3.fromRGB(255,90,90))
			end
		else
			addMessage(false, "❌ Could not fetch script", Color3.fromRGB(255,140,140))
		end
		return
	end

	-- Show typing indicator
	thinkingMessage = Instance.new("Frame")
	thinkingMessage.Name = "ThinkingIndicator"
	thinkingMessage.Size = UDim2.new(1, 0, 0, 0)
	thinkingMessage.BackgroundTransparency = 1
	thinkingMessage.AutomaticSize = Enum.AutomaticSize.Y
	thinkingMessage.Parent = chatLog

	local thinkingBubble = Instance.new("Frame")
	thinkingBubble.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
	thinkingBubble.Size = UDim2.new(0.5, 0, 0, 28)
	thinkingBubble.AutomaticSize = Enum.AutomaticSize.Y
	thinkingBubble.Parent = thinkingMessage

	local thinkCorner = Instance.new("UICorner")
	thinkCorner.CornerRadius = UDim.new(0, 12)
	thinkCorner.Parent = thinkingBubble

	local thinkPadding = Instance.new("UIPadding")
	thinkPadding.PaddingLeft = UDim.new(0, 10)
	thinkPadding.PaddingRight = UDim.new(0, 10)
	thinkPadding.PaddingTop = UDim.new(0, 5)
	thinkPadding.PaddingBottom = UDim.new(0, 5)
	thinkPadding.Parent = thinkingBubble

	local thinkLabel = Instance.new("TextLabel")
	thinkLabel.BackgroundTransparency = 1
	thinkLabel.Size = UDim2.new(1, 0, 0, 0)
	thinkLabel.AutomaticSize = Enum.AutomaticSize.Y
	thinkLabel.Text = "Artemis is thinking..."
	thinkLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
	thinkLabel.Font = Enum.Font.Gotham
	thinkLabel.TextSize = 10.5
	thinkLabel.TextWrapped = true
	thinkLabel.TextXAlignment = Enum.TextXAlignment.Left
	thinkLabel.Parent = thinkingBubble

	thinkingBubble.Position = UDim2.new(0, 6, 0, 0)
	thinkingBubble.AnchorPoint = Vector2.new(0, 0)

	-- Process Groq request
	table.insert(messages, {role = "user", content = text})
	trimHistory()
	local body = HttpService:JSONEncode({
		model = GROQ_MODEL,
		messages = messages,
		temperature = 0.75,
		max_tokens = 1024
	})

	local responseBody, err = postToGroq(body)

	-- Remove thinking indicator
	if thinkingMessage then
		thinkingMessage:Destroy()
		thinkingMessage = nil
	end

	if responseBody then
		local ok, decoded = pcall(HttpService.JSONDecode, HttpService, responseBody)
		if ok and decoded.choices and decoded.choices[1] then
			local reply = decoded.choices[1].message.content
			table.insert(messages, {role = "assistant", content = reply})
			addMessage(false, reply, ACCENT_COLOR)
		else
			addMessage(false, "❌ Failed to parse Groq response", Color3.fromRGB(255,140,140))
		end
	else
		addMessage(false, "❌ Groq API error: " .. (err or "Unknown"), Color3.fromRGB(255,90,90))
	end
end

-- ==================== INPUT HANDLING ====================
local isNamed = false
local preferredName = nil

function processInput()
	local text = inputBox.Text
	if text == "" then return end
	inputBox.Text = ""
	addMessage(true, text, Color3.fromRGB(200, 200, 220))

	if not isNamed then
		preferredName = text
		isNamed = true
		wait(0.3)
		local g = {"Hello, " .. preferredName .. "!", "Welcome, " .. preferredName .. "!", "Hi, " .. preferredName .. "!"}
		local greet = g[math.random(#g)]
		greetingLabel.Text = greet
		addMessage(false, greet, ACCENT_COLOR)
	else
		wait(0.3)
		processCommand(text)
	end
end

sendBtn.MouseButton1Click:Connect(processInput)

-- ==================== TYPING ANIMATION ====================
wait(0.5)
local fullText = "Artemis"
artemisTitle.Text = ""
for i = 1, #fullText do
	artemisTitle.Text = fullText:sub(1,i)
	wait(0.05)
end

wait(0.5)
greetingLabel.Text = ""
local greetText = "What should I call you?"
for i = 1, #greetText do
	greetingLabel.Text = greetText:sub(1,i)
	wait(0.02)
end

print("Artemis Pro loaded — white theme • slim sidebar • emoji icons • groq integration enhanced")
