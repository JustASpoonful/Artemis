-- ============================================
-- Advanced Noclip Script with Mobile Support
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Prevent duplicate execution
if getgenv().AdvancedNoclip then
    getgenv().AdvancedNoclip:Destroy()
end

-- Firebase Colors
local FIREBASE_ORANGE = Color3.fromRGB(255, 111, 0)
local FIREBASE_YELLOW = Color3.fromRGB(255, 202, 40)
local FIREBASE_DARK = Color3.fromRGB(10, 10, 15)

-- Global State Table
local Noclip = {
    Enabled = false,
    Keybind = Enum.KeyCode.N,
    Connections = {},
    CharacterParts = {},
    GUI = nil
}
getgenv().AdvancedNoclip = Noclip

-- ==================== GUI CREATION ====================
local function createMobileGUI()
    -- Check if GUI already exists
    if LocalPlayer.PlayerGui:FindFirstChild("NoclipGUI") then
        LocalPlayer.PlayerGui.NoclipGUI:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NoclipGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer.PlayerGui

    -- Main Button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "NoclipToggle"
    toggleButton.Size = UDim2.new(0, 80, 0, 80)
    toggleButton.Position = UDim2.new(1, -90, 0.5, -40)
    toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = screenGui

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 16)
    btnCorner.Parent = toggleButton

    -- Icon/Status Indicator
    local statusCircle = Instance.new("Frame")
    statusCircle.Name = "StatusCircle"
    statusCircle.Size = UDim2.new(0, 40, 0, 40)
    statusCircle.Position = UDim2.new(0.5, -20, 0.5, -20)
    statusCircle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    statusCircle.BorderSizePixel = 0
    statusCircle.Parent = toggleButton

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = statusCircle

    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 16)
    label.Position = UDim2.new(0, 0, 1, -18)
    label.BackgroundTransparency = 1
    label.Text = "OFF"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.TextColor3 = Color3.fromRGB(150, 150, 150)
    label.Parent = toggleButton

    Noclip.GUI = {
        ScreenGui = screenGui,
        ToggleButton = toggleButton,
        StatusCircle = statusCircle,
        Label = label
    }

    -- Make draggable
    local dragging = false
    local dragInput, dragStart, startPos

    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = toggleButton.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    toggleButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            toggleButton.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Toggle on tap/click
    toggleButton.MouseButton1Click:Connect(function()
        Noclip:Toggle()
    end)

    return screenGui
end

-- ==================== UPDATE GUI ====================
local function updateGUI()
    if not Noclip.GUI then return end

    if Noclip.Enabled then
        -- Active state
        Noclip.GUI.StatusCircle.BackgroundColor3 = FIREBASE_ORANGE
        Noclip.GUI.Label.Text = "ON"
        Noclip.GUI.Label.TextColor3 = FIREBASE_ORANGE
        Noclip.GUI.ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    else
        -- Inactive state
        Noclip.GUI.StatusCircle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        Noclip.GUI.Label.Text = "OFF"
        Noclip.GUI.Label.TextColor3 = Color3.fromRGB(150, 150, 150)
        Noclip.GUI.ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    end
end

-- ==================== PART CACHING ====================
local function updatePartCache(character)
    table.clear(Noclip.CharacterParts)
    if not character then return end
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(Noclip.CharacterParts, part)
        end
    end
end

-- Listen for new parts
local function setupCharacter(character)
    updatePartCache(character)
    
    if Noclip.Connections.DescendantAdded then 
        Noclip.Connections.DescendantAdded:Disconnect() 
    end
    
    Noclip.Connections.DescendantAdded = character.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(Noclip.CharacterParts, part)
        end
    end)
end

-- ==================== CORE LOOP ====================
local function onStepped()
    if not Noclip.Enabled then return end
    
    for _, part in ipairs(Noclip.CharacterParts) do
        if part and part.CanCollide then
            part.CanCollide = false
        end
    end
end

-- ==================== API FUNCTIONS ====================
function Noclip:Enable()
    self.Enabled = true
    updateGUI()
    print("[Noclip]: ON")
end

function Noclip:Disable()
    self.Enabled = false
    
    -- Re-enable collision on all parts
    for _, part in ipairs(self.CharacterParts) do
        if part and part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    
    updateGUI()
    print("[Noclip]: OFF")
end

function Noclip:Toggle()
    if self.Enabled then
        self:Disable()
    else
        self:Enable()
    end
end

function Noclip:Destroy()
    self.Enabled = false
    
    -- Restore collision
    for _, part in ipairs(self.CharacterParts) do
        if part and part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    
    -- Disconnect all connections
    for _, connection in pairs(self.Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    
    -- Destroy GUI
    if self.GUI and self.GUI.ScreenGui then
        self.GUI.ScreenGui:Destroy()
    end
    
    table.clear(self.Connections)
    table.clear(self.CharacterParts)
    getgenv().AdvancedNoclip = nil
    print("[Noclip]: Script Terminated.")
end

-- ==================== INITIALIZE ====================
-- Create GUI
createMobileGUI()

-- Bind to Stepped
Noclip.Connections.Stepped = RunService.Stepped:Connect(onStepped)

-- Bind to Keyboard (PC only)
Noclip.Connections.Input = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Noclip.Keybind then
        Noclip:Toggle()
    end
end)

-- Handle Character
if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end

Noclip.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
    setupCharacter(character)
    
    -- Recreate GUI if it was destroyed
    if not Noclip.GUI or not Noclip.GUI.ScreenGui.Parent then
        createMobileGUI()
        updateGUI()
    end
end)

-- Success Message
print("ðŸ”¥ [Advanced Noclip]: Loaded!")
print("ðŸ“± [Mobile]: Tap the button on the right")
print("âŒ¨ï¸  [PC]: Press '" .. Noclip.Keybind.Name .. "' to toggle")
