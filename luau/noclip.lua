-- // Highly Advanced Executor Noclip Framework \\ --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- 1. Memory Management: Prevent duplication on re-execution
if getgenv().AdvancedNoclip then
    getgenv().AdvancedNoclip:Destroy()
end

-- 2. Global State Table
local Noclip = {
    Enabled = false,
    Keybind = Enum.KeyCode.N,
    Connections = {},
    CharacterParts = {}
}
getgenv().AdvancedNoclip = Noclip

-- 3. Part Caching (Performance Optimization)
-- Getting descendants every frame causes lag. We cache them instead.
local function updatePartCache(character)
    table.clear(Noclip.CharacterParts)
    if not character then return end
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(Noclip.CharacterParts, part)
        end
    end
end

-- Listen for new parts (e.g., equipping a tool or armor)
local function setupCharacter(character)
    updatePartCache(character)
    
    if Noclip.Connections.DescendantAdded then Noclip.Connections.DescendantAdded:Disconnect() end
    Noclip.Connections.DescendantAdded = character.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(Noclip.CharacterParts, part)
        end
    end)
end

-- 4. The Core Loop
local function onStepped()
    if not Noclip.Enabled then return end
    
    -- Loop through our cached parts incredibly fast
    for _, part in ipairs(Noclip.CharacterParts) do
        if part.CanCollide then
            part.CanCollide = false
        end
    end
end

-- 5. API Functions
function Noclip:Enable()
    self.Enabled = true
    print("[Noclip]: ON")
end

function Noclip:Disable()
    self.Enabled = false
    print("[Noclip]: OFF")
end

function Noclip:Toggle()
    if self.Enabled then
        self:Disable()
    else
        self:Enable()
    end
end

-- Complete cleanup function
function Noclip:Destroy()
    self.Enabled = false
    for _, connection in pairs(self.Connections) do
        connection:Disconnect()
    end
    table.clear(self.Connections)
    table.clear(self.CharacterParts)
    getgenv().AdvancedNoclip = nil
    print("[Noclip]: Script Terminated.")
end

-- 6. Event Hooking
-- Bind to Stepped (fires right before physics calculation)
Noclip.Connections.Stepped = RunService.Stepped:Connect(onStepped)

-- Bind to Keyboard
Noclip.Connections.Input = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Noclip.Keybind then
        Noclip:Toggle()
    end
end)

-- Handle Respawns
if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end
Noclip.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(setupCharacter)

-- Alert User
print("[Advanced Noclip]: Loaded successfully. Press " .. Noclip.Keybind.Name .. " to toggle.")
