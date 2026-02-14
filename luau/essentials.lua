--[[
    ESSENTIALS GUI REMASTERED v2.1 (Air Walk Edition)
    Compatible with: Arceus X, Delta, Fluxus, Electron, Synapse
    Updates: 
    - V-Lock is now "Air Walk" (Jump + Walk off edges supported)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // CONFIGURATION //
local CONFIG = {
    FlySpeed = 20,
    FlyEnabled = false,
    NoclipEnabled = false,
    VLockEnabled = false,
    VLockYLevel = 0, -- Stores the height for the platform
    Theme = {
        Main = Color3.fromRGB(25, 25, 25),
        Accent = Color3.fromRGB(0, 170, 255),
        Text = Color3.fromRGB(240, 240, 240),
        Stroke = Color3.fromRGB(60, 60, 60)
    }
}

-- // UI CONSTRUCTION //
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EssentialsGUI_V2.1"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 270)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -135)
MainFrame.BackgroundColor3 = CONFIG.Theme.Main
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Rounded Corners & Stroke
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = CONFIG.Theme.Stroke
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "Essentials V2.1"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = CONFIG.Theme.Accent
Title.TextSize = 18
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Control Buttons (Close/Minimize)
local function createHeaderBtn(text, posOffset, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(1, posOffset, 0, 2)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = color
    btn.Parent = Header
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local CloseBtn = createHeaderBtn("X", -35, Color3.fromRGB(200, 60, 60))
local MinBtn = createHeaderBtn("-", -70, Color3.fromRGB(60, 60, 60))

-- Content Container
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = Content

-- // FUNCTIONAL ELEMENTS //
local function createToggleBtn(text, order)
    local btn = Instance.new("TextButton")
    btn.Name = text
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.TextColor3 = CONFIG.Theme.Text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.LayoutOrder = order
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 4, 1, 0)
    indicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    indicator.Parent = btn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 6)
    
    return btn, indicator
end

local FlyBtn, FlyInd = createToggleBtn("Fly Mode", 1)
local NoclipBtn, NoclipInd = createToggleBtn("Noclip", 2)
local VLockBtn, VLockInd = createToggleBtn("Air Walk (Jumpable)", 3)

-- Slider Construction
local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(1, 0, 0, 45)
SliderFrame.BackgroundTransparency = 1
SliderFrame.LayoutOrder = 4
SliderFrame.Parent = Content

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, 0, 0, 20)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Speed: 20"
SliderLabel.TextColor3 = CONFIG.Theme.Text
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.Parent = SliderFrame

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(1, 0, 0, 6)
SliderBar.Position = UDim2.new(0, 0, 0, 25)
SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderBar.Parent = SliderFrame
Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

local SliderKnob = Instance.new("TextButton")
SliderKnob.Size = UDim2.new(0, 16, 0, 16)
SliderKnob.Position = UDim2.new(0.2, -8, 0.5, -8) -- Start at roughly 20%
SliderKnob.BackgroundColor3 = CONFIG.Theme.Accent
SliderKnob.Text = ""
SliderKnob.Parent = SliderBar
Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1, 0)

-- // LOGIC SYSTEMS //

-- Smooth Dragging
local Dragging, DragInput, DragStart, StartPos
local function updateDrag(input)
    local delta = input.Position - DragStart
    MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        updateDrag(input)
    end
end)

-- Physics Variables
local BodyVel, BodyGyro
local AirWalkPart = nil

local function cleanupPhysics()
    if BodyVel then BodyVel:Destroy() BodyVel = nil end
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    -- Note: We don't destroy AirWalkPart here, we do it in the toggle function to manage state better
end

-- // AIR WALK (MAGIC CARPET) LOGIC //
local function createAirWalkPart(char)
    if AirWalkPart then AirWalkPart:Destroy() end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end
    
    AirWalkPart = Instance.new("Part")
    AirWalkPart.Name = "AirWalkPlatform"
    AirWalkPart.Size = Vector3.new(6, 1, 6) -- Big enough to walk on comfortably
    AirWalkPart.Transparency = 1 -- Invisible (Change to 0.5 to see it for debugging)
    AirWalkPart.Anchored = true
    AirWalkPart.CanCollide = true
    AirWalkPart.Parent = workspace
    
    -- Calculate height directly under feet
    -- HipHeight is distance from RootPart center to floor.
    local hipHeight = hum.HipHeight
    if hipHeight == 0 then hipHeight = 2 end -- Fallback for R6 if not set
    
    CONFIG.VLockYLevel = root.Position.Y - (hipHeight + 0.5) 
    
    AirWalkPart.Position = Vector3.new(root.Position.X, CONFIG.VLockYLevel, root.Position.Z)
end

local function updateAirWalk()
    if CONFIG.VLockEnabled and AirWalkPart and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            -- Constantly move the platform under the player's X and Z, keep Y fixed
            AirWalkPart.Position = Vector3.new(root.Position.X, CONFIG.VLockYLevel, root.Position.Z)
        end
    elseif not CONFIG.VLockEnabled and AirWalkPart then
        AirWalkPart:Destroy()
        AirWalkPart = nil
    end
end

-- // FLY LOGIC //
local function setupFlyPhysics(char)
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    cleanupPhysics()
    
    BodyVel = Instance.new("BodyVelocity")
    BodyVel.MaxForce = Vector3.new(1, 1, 1) * 10^5
    BodyVel.Velocity = Vector3.zero
    BodyVel.Parent = root
    
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 10^5
    BodyGyro.CFrame = root.CFrame
    BodyGyro.P = 3000
    BodyGyro.D = 100
    BodyGyro.Parent = root
end

-- Main Loop
RunService.Stepped:Connect(function()
    -- NOCLIP LOGIC (Must be in Stepped)
    if CONFIG.NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    -- Movement Loops
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChild("Humanoid")
    
    if not (char and root and humanoid) then return end
    
    -- 1. Fly Mode Logic
    if CONFIG.FlyEnabled then
        if not BodyVel or BodyVel.Parent ~= root then
            setupFlyPhysics(char)
        end
        
        local moveDir = humanoid.MoveDirection
        local camCFrame = Camera.CFrame
        
        if moveDir.Magnitude > 0 then
            local travelDir = (camCFrame.LookVector * moveDir.Z * -1) + (camCFrame.RightVector * moveDir.X)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                travelDir = travelDir + Vector3.new(0, 1, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                travelDir = travelDir - Vector3.new(0, 1, 0)
            elseif moveDir.Magnitude > 0 then
                 travelDir = (camCFrame.Rotation * moveDir)
            end

            BodyVel.Velocity = travelDir.Unit * CONFIG.FlySpeed
            BodyGyro.CFrame = CFrame.new(root.Position, root.Position + camCFrame.LookVector)
        else
            BodyVel.Velocity = Vector3.zero
            BodyGyro.CFrame = CFrame.new(root.Position, root.Position + camCFrame.LookVector)
        end
        
    else
        -- If Fly is OFF, ensure Fly physics are gone
        if BodyVel then cleanupPhysics() end
    end
    
    -- 2. Air Walk Logic (Update Platform Position)
    updateAirWalk()
end)

-- Button Events
local function toggleState(btn, indicator, stateVar)
    CONFIG[stateVar] = not CONFIG[stateVar]
    local isOn = CONFIG[stateVar]
    
    if stateVar == "FlyEnabled" then
        if isOn then 
            setupFlyPhysics(LocalPlayer.Character)
            -- Disable AirWalk if Fly is turned on to prevent glitches
            if CONFIG.VLockEnabled then 
                CONFIG.VLockEnabled = false 
                TweenService:Create(VLockInd, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(80,80,80)}):Play()
            end
        end
    elseif stateVar == "VLockEnabled" then
        if isOn then
            -- Disable Fly if AirWalk is turned on
            if CONFIG.FlyEnabled then 
                CONFIG.FlyEnabled = false 
                TweenService:Create(FlyInd, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(80,80,80)}):Play()
                cleanupPhysics()
            end
            createAirWalkPart(LocalPlayer.Character)
        else
            if AirWalkPart then AirWalkPart:Destroy() AirWalkPart = nil end
        end
    end
    
    -- Visual update
    TweenService:Create(indicator, TweenInfo.new(0.3), {BackgroundColor3 = isOn and CONFIG.Theme.Accent or Color3.fromRGB(80,80,80)}):Play()
end

FlyBtn.MouseButton1Click:Connect(function() toggleState(FlyBtn, FlyInd, "FlyEnabled") end)
NoclipBtn.MouseButton1Click:Connect(function() toggleState(NoclipBtn, NoclipInd, "NoclipEnabled") end)
VLockBtn.MouseButton1Click:Connect(function() toggleState(VLockBtn, VLockInd, "VLockEnabled") end)

-- Slider Logic
local draggingSlider = false
SliderKnob.MouseButton1Down:Connect(function() draggingSlider = true end)
UserInputService.InputEnded:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        draggingSlider = false 
    end 
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = UserInputService:GetMouseLocation().X
        local barPos = SliderBar.AbsolutePosition.X
        local barSize = SliderBar.AbsoluteSize.X
        
        local rel = math.clamp((pos - barPos) / barSize, 0, 1)
        SliderKnob.Position = UDim2.new(rel, -8, 0.5, -8)
        
        local s = math.floor(rel * 150) + 10 -- Speed 10 to 160
        CONFIG.FlySpeed = s
        SliderLabel.Text = "Speed: " .. s
    end
end)

-- Minimize & Close
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Content.Visible = false
        MainFrame:TweenSize(UDim2.new(0, 240, 0, 35), "Out", "Quad", 0.3, true)
        MinBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 240, 0, 270), "Out", "Quad", 0.3, true)
        task.wait(0.3)
        Content.Visible = true
        MinBtn.Text = "-"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    cleanupPhysics()
    if AirWalkPart then AirWalkPart:Destroy() end
    ScreenGui:Destroy()
end)

-- Handle Respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    if AirWalkPart then AirWalkPart:Destroy() AirWalkPart = nil end
    if CONFIG.VLockEnabled then
        task.wait(0.5)
        createAirWalkPart(newChar)
    end
end)

print("Essentials V2.1 (Air Walk) Loaded.")
