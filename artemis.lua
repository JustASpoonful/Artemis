local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- ==================== YOUR COMMANDS ====================
local commandUrls = {
	["noclip"] = "https://poopoo.github.io/lua/pie.lua",
	["fly"] = "https://yourdomain.com/lua/fly.lua",
	["infiniteyield"] = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",
	["speed"] = "https://example.com/lua/speed.lua",
}
-- ======================================================

if player.PlayerGui:FindFirstChild("ArtemisUI") then
	player.PlayerGui.ArtemisUI:Destroy()
	wait(0.1)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ArtemisUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- 20% smaller clean UI
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 256, 0, 336)
mainFrame.Position = UDim2.new(0.5, -128, 0.5, -168)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

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
titleBarLabel.Name = "TitleLabel"
titleBarLabel.Size = UDim2.new(1, -56, 1, 0)
titleBarLabel.Position = UDim2.new(0, 10, 0, 0)
titleBarLabel.BackgroundTransparency = 1
titleBarLabel.Text = "Artemis"
titleBarLabel.Font = Enum.Font.GothamBold
titleBarLabel.TextSize = 11
titleBarLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
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
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn

local artemisTitle = Instance.new("TextLabel")
artemisTitle.Name = "ArtemisTitle"
artemisTitle.Size = UDim2.new(0, 224, 0, 48)
artemisTitle.Position = UDim2.new(0.5, -112, 0, 40)
artemisTitle.BackgroundTransparency = 1
artemisTitle.Text = "Artemis"
artemisTitle.Font = Enum.Font.GothamBold
artemisTitle.TextSize = 38
artemisTitle.TextColor3 = Color3.fromRGB(138, 43, 226)
artemisTitle.Parent = mainFrame

local gradientEffect = Instance.new("UIGradient")
gradientEffect.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))
})
gradientEffect.Rotation = 45
gradientEffect.Parent = artemisTitle

local greetingLabel = Instance.new("TextLabel")
greetingLabel.Name = "Greeting"
greetingLabel.Size = UDim2.new(1, -24, 0, 20)
greetingLabel.Position = UDim2.new(0, 12, 0, 92)
greetingLabel.BackgroundTransparency = 1
greetingLabel.Text = "What should I call you?"
greetingLabel.Font = Enum.Font.Gotham
greetingLabel.TextSize = 12
greetingLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
greetingLabel.Parent = mainFrame

local chatContainer = Instance.new("Frame")
chatContainer.Name = "ChatContainer"
chatContainer.Size = UDim2.new(1, -16, 1, -168)
chatContainer.Position = UDim2.new(0, 8, 0, 116)
chatContainer.BackgroundTransparency = 1
chatContainer.Parent = mainFrame

local chatLog = Instance.new("ScrollingFrame")
chatLog.Name = "ChatLog"
chatLog.Size = UDim2.new(1, 0, 1, 0)
chatLog.BackgroundTransparency = 1
chatLog.BorderSizePixel = 0
chatLog.ScrollBarThickness = 3
chatLog.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
chatLog.CanvasSize = UDim2.new(0, 0, 0, 0)
chatLog.Parent = chatContainer

local chatLayout = Instance.new("UIListLayout")
chatLayout.Padding = UDim.new(0, 5)
chatLayout.SortOrder = Enum.SortOrder.LayoutOrder
chatLayout.Parent = chatLog

chatLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	chatLog.CanvasSize = UDim2.new(0, 0, 0, chatLayout.AbsoluteContentSize.Y + 8)
	chatLog.CanvasPosition = Vector2.new(0, chatLog.AbsoluteCanvasSize.Y)
end)

local inputContainer = Instance.new("Frame")
inputContainer.Name = "InputContainer"
inputContainer.Size = UDim2.new(1, -16, 0, 34)
inputContainer.Position = UDim2.new(0, 8, 1, -42)
inputContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
inputContainer.BorderSizePixel = 0
inputContainer.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 17)
inputCorner.Parent = inputContainer

local inputBox = Instance.new("TextBox")
inputBox.Name = "Input"
inputBox.Size = UDim2.new(1, -48, 1, 0)
inputBox.Position = UDim2.new(0, 12, 0, 0)
inputBox.BackgroundTransparency = 1
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.PlaceholderText = "Type here..."
inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 12
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.ClearTextOnFocus = false
inputBox.Text = ""
inputBox.Parent = inputContainer

local sendBtn = Instance.new("TextButton")
sendBtn.Name = "SendBtn"
sendBtn.Size = UDim2.new(0, 28, 0, 28)
sendBtn.Position = UDim2.new(1, -34, 0.5, -14)
sendBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
sendBtn.Text = ">"
sendBtn.TextColor3 = Color3.new(1, 1, 1)
sendBtn.Font = Enum.Font.GothamBold
sendBtn.TextSize = 14
sendBtn.BorderSizePixel = 0
sendBtn.Parent = inputContainer

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(1, 0)
sendCorner.Parent = sendBtn

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

local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	local targetSize = isMinimized and UDim2.new(0, 256, 0, 32) or UDim2.new(0, 256, 0, 336)
	TweenService:Create(mainFrame, TweenInfo.new(0.25), {Size = targetSize}):Play()
	minimizeBtn.Text = isMinimized and "+" or "-"
end)

closeBtn.MouseButton1Click:Connect(function()
	TweenService:Create(mainFrame, TweenInfo.new(0.25), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	}):Play()
	wait(0.25)
	screenGui:Destroy()
end)

local function addMessage(sender, text, color)
	local msgFrame = Instance.new("Frame")
	msgFrame.Name = "Message"
	msgFrame.Size = UDim2.new(1, -4, 0, 0)
	msgFrame.BackgroundTransparency = 1
	msgFrame.Parent = chatLog

	local msgLabel = Instance.new("TextLabel")
	msgLabel.Name = "Label"
	msgLabel.Size = UDim2.new(1, 0, 1, 0)
	msgLabel.BackgroundTransparency = 1
	msgLabel.TextColor3 = color or Color3.new(1, 1, 1)
	msgLabel.Font = Enum.Font.Gotham
	msgLabel.TextSize = 11
	msgLabel.TextXAlignment = Enum.TextXAlignment.Left
	msgLabel.TextYAlignment = Enum.TextYAlignment.Top
	msgLabel.TextWrapped = true
	msgLabel.RichText = false
	msgLabel.Parent = msgFrame

	local displayName = sender == "Artemis" and sender or "You"
	msgLabel.Text = displayName .. ": " .. text
	msgFrame.Size = UDim2.new(1, -4, 0, msgLabel.TextBounds.Y + 4)
	wait(0.05)
	chatLog.CanvasPosition = Vector2.new(0, chatLog.AbsoluteCanvasSize.Y)
end

local responses = {
	hello = {"Hey there!", "Hello!", "Hi! How can I help?"},
	hi = {"Hey!", "Hi there!", "Hello!"},
	hey = {"Hey! What's up?", "Hi!", "Hello there!"},
	thanks = {"You're welcome!", "No problem!", "Anytime!"},
	thank = {"No problem!", "You're welcome!"},
	bye = {"See you later!", "Goodbye!", "Take care!"},
	help = {"Type any command you've added in the commandUrls table at the top!"}
}

local function processCommand(text)
	local lower = string.lower(text)

	if responses[lower] then
		local resp = responses[lower]
		addMessage("Artemis", resp[math.random(#resp)], Color3.fromRGB(138, 43, 226))
		return
	end
	for key, resp in pairs(responses) do
		if string.find(lower, key) then
			addMessage("Artemis", resp[math.random(#resp)], Color3.fromRGB(138, 43, 226))
			return
		end
	end

	if commandUrls[lower] then
		local url = commandUrls[lower]
		addMessage("Artemis", "Fetching " .. text .. "...", Color3.fromRGB(138, 43, 226))

		local success, content = pcall(function()
			return game:HttpGet(url, true)
		end)

		if success and content and #content > 50 then
			local execSuccess, err = pcall(loadstring, content)
			if execSuccess then
				addMessage("Artemis", "✅ " .. text .. " loaded and executed!", Color3.fromRGB(50, 255, 150))
			else
				addMessage("Artemis", "❌ Failed to run script: " .. tostring(err), Color3.fromRGB(255, 100, 100))
			end
		else
			addMessage("Artemis", "❌ Could not load script from that URL.", Color3.fromRGB(255, 150, 150))
		end
	else
		addMessage("Artemis", "❌ Unknown command. Add it to the commandUrls table at the top!", Color3.fromRGB(255, 150, 150))
	end
end

local isNamed = false
local preferredName = nil

local function processInput()
	local text = inputBox.Text
	if text == "" then return end
	inputBox.Text = ""
	addMessage("You", text, Color3.fromRGB(200, 200, 220))

	if not isNamed then
		preferredName = text
		isNamed = true
		wait(0.3)
		local greetings = {"Hello, " .. preferredName .. "!", "Welcome, " .. preferredName .. "!", "Hi, " .. preferredName .. "!"}
		greetingLabel.Text = greetings[math.random(#greetings)]
		addMessage("Artemis", greetings[math.random(#greetings)], Color3.fromRGB(138, 43, 226))
	else
		wait(0.3)
		processCommand(text)
	end
end

inputBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then processInput() end
end)
sendBtn.MouseButton1Click:Connect(processInput)

-- Typing animation
wait(0.5)
local fullText = "Artemis"
artemisTitle.Text = ""
for i = 1, #fullText do
	artemisTitle.Text = fullText:sub(1, i)
	wait(0.05)
end
wait(0.5)
greetingLabel.Text = ""
local greetText = "What should I call you?"
for i = 1, #greetText do
	greetingLabel.Text = greetText:sub(1, i)
	wait(0.02)
end

print("Artemis loaded — original clean UI, 20% smaller!")
