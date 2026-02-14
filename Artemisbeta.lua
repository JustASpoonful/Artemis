-- ==================== GEMINI-INSPIRED FLOWING GRADIENT (NO BLUE) ====================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- ==================== YOUR COMMANDS (still work exactly as before) ====================
local commandUrls = {
	["noclip"] = "https://raw.githubusercontent.com/justaspoonful/Artemis/main/luau/noclip.lua",
	["fly"] = "https://yourdomain.com/lua/fly.lua",
	["infiniteyield"] = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",
	["speed"] = "https://example.com/lua/speed.lua",
}

-- ==================== GROQ CONFIG (MOST GENEROUS FREE MODEL) ====================
local GROQ_API_KEY = "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"   -- ← REPLACE WITH YOUR KEY (free @ console.groq.com)
local GROQ_MODEL   = "openai/gpt-oss-120b"                    -- 120B, best reasoning model on Groq's free tier

if GROQ_API_KEY == "gsk_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" then
	warn("Artemis → Please replace GROQ_API_KEY with your real key!")
end

-- Conversation history (keeps context)
local messages = {
	{
		role = "system",
		content = "You are Artemis, a premium, witty AI assistant running inside a Roblox executor. Be helpful, concise, and fun. The user can ask you to run built-in commands (noclip, fly, infiniteyield, etc.) — those are handled locally. For everything else, answer normally."
	}
}

-- (Rest of the UI code is 100% unchanged — only the logic below is modified)

if player.PlayerGui:FindFirstChild("ArtemisUI") then
	player.PlayerGui.ArtemisUI:Destroy()
	wait(0.1)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ArtemisUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- ... [ALL YOUR ORIGINAL UI CODE GOES HERE — title, gradient, buttons, chatLog, inputBox, etc.] ...
-- (I kept it exactly as you pasted, so just copy-paste your original UI block here)

-- Draggable, minimize, close, etc. — unchanged

-- ====================== MODIFIED LOGIC ======================

local function addMessage(sender, text, color)
	-- (your original addMessage function — unchanged)
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

local function trimHistory()
	while #messages > 21 do  -- system + 10 full exchanges
		table.remove(messages, 2)
	end
end

local function processCommand(text)
	local lower = string.lower(text)

	-- 1. Check for built-in script commands first
	if commandUrls[lower] then
		local url = commandUrls[lower]
		addMessage("Artemis", "Fetching " .. text .. "...", ACCENT_COLOR)

		local success, content = pcall(function()
			return game:HttpGet(url, true)
		end)

		if success and content and #content > 50 then
			local loadSuccess, loadedFunc = pcall(loadstring, content)
			if loadSuccess and loadedFunc then
				local execSuccess, execErr = pcall(loadedFunc)
				if execSuccess then
					addMessage("Artemis", "✅ " .. text .. " loaded and executed!", Color3.fromRGB(50, 255, 150))
				else
					addMessage("Artemis", "❌ Script execution error: " .. tostring(execErr), Color3.fromRGB(255, 100, 100))
				end
			else
				addMessage("Artemis", "❌ Failed to load script: " .. tostring(loadedFunc), Color3.fromRGB(255, 100, 100))
			end
		else
			addMessage("Artemis", "❌ Could not load script from that URL.", Color3.fromRGB(255, 150, 150))
		end
		return
	end

	-- 2. Everything else → Groq chat
	table.insert(messages, {role = "user", content = text})
	trimHistory()

	local body = HttpService:JSONEncode({
		model = GROQ_MODEL,
		messages = messages,
		temperature = 0.75,
		max_tokens = 1024,
	})

	local success, response = pcall(function()
		return HttpService:PostAsync(
			"https://api.groq.com/openai/v1/chat/completions",
			body,
			Enum.HttpContentType.ApplicationJson,
			false,
			{
				["Authorization"] = "Bearer " .. GROQ_API_KEY,
				["Content-Type"] = "application/json"
			}
		)
	end)

	if success then
		local decodeSuccess, decoded = pcall(HttpService.JSONDecode, HttpService, response)
		if decodeSuccess and decoded.choices and decoded.choices[1] then
			local reply = decoded.choices[1].message.content
			table.insert(messages, {role = "assistant", content = reply})
			addMessage("Artemis", reply, ACCENT_COLOR)
		else
			addMessage("Artemis", "❌ Failed to parse Groq response.", Color3.fromRGB(255, 150, 150))
		end
	else
		addMessage("Artemis", "❌ Groq API error: " .. tostring(response), Color3.fromRGB(255, 100, 100))
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
		addMessage("Artemis", greetings[math.random(#greetings)], ACCENT_COLOR)
	else
		wait(0.3)
		processCommand(text)
	end
end

inputBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then processInput() end
end)
sendBtn.MouseButton1Click:Connect(processInput)

-- Typing animation (unchanged)
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

print("Artemis loaded — now powered by Groq (openai/gpt-oss-120b) • most generous free model")
