--[[
    â•”â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•—
    â•‘     ESSENTIALS GUI  Â·  V3.0  Â·  REFORGED      â•‘
    â•‘  Compatible: Arceus X, Delta, Fluxus,          â•‘
    â•‘             Electron, Synapse X, KRNL           â•‘
    â•šâ•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

    CHANGELOG v3.0:
    â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    + Tabbed UI (Movement / Player / Misc)
    + Fixed fly direction (true camera-relative 6DOF)
    + WalkSpeed slider (16â€“100)
    + JumpPower slider (50â€“400)
    + Infinite Jump toggle
    + Anti-AFK toggle
    + Player ESP (Highlight + BillboardGui tags)
    + God Mode toggle (MaxHealth / Health loop)
    + Gravity control slider (0.01â€“196.2)
    + Toast notification system
    + Header-only drag (no accidental drags from buttons)
    + Keybind: Right Shift â†’ Toggle GUI visibility
    + Mutual-exclusion cleanup on all toggles
    â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
]]

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚                   SERVICES                       â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Workspace        = game:GetService("Workspace")

local LocalPlayer      = Players.LocalPlayer
local Camera           = Workspace.CurrentCamera
local DEFAULT_GRAVITY  = Workspace.Gravity -- preserve the game's default

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚                  CONFIGURATION                   â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
local CFG = {
    -- Movement
    FlyEnabled       = false,
    FlySpeed         = 40,
    NoclipEnabled    = false,
    AirWalkEnabled   = false,
    AirWalkYLevel    = 0,
    InfJumpEnabled   = false,

    -- Player
    WalkSpeed        = 16,
    JumpPower        = 50,
    GodModeEnabled   = false,
    AntiAFKEnabled   = false,

    -- Misc
    ESPEnabled       = false,
    GravityValue     = DEFAULT_GRAVITY,

    -- Theme
    Theme = {
        BG        = Color3.fromRGB(12, 12, 16),
        Surface   = Color3.fromRGB(22, 22, 30),
        Surface2  = Color3.fromRGB(32, 32, 44),
        Accent    = Color3.fromRGB(100, 200, 255),
        AccentDim = Color3.fromRGB(40, 80, 120),
        Success   = Color3.fromRGB(80, 220, 130),
        Danger    = Color3.fromRGB(255, 80, 80),
        Text      = Color3.fromRGB(230, 230, 240),
        TextDim   = Color3.fromRGB(130, 130, 150),
        Stroke    = Color3.fromRGB(50, 50, 70),
    }
}
local T = CFG.Theme

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚                 UTILITY HELPERS                  â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
local function tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

local function fastTween(obj, props)
    tween(obj, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thick)
    local s = Instance.new("UIStroke")
    s.Color = color or T.Stroke
    s.Thickness = thick or 1.5
    s.Parent = parent
    return s
end

local function label(parent, text, size, color, bold, xa)
    local l = Instance.new("TextLabel")
    l.Text = text
    l.TextSize = size or 13
    l.TextColor3 = color or T.Text
    l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.BackgroundTransparency = 1
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Parent = parent
    return l
end

local function newFrame(parent, size, pos, bg, transparency)
    local f = Instance.new("Frame")
    f.Size = size or UDim2.new(1, 0, 0, 30)
    f.Position = pos or UDim2.new(0, 0, 0, 0)
    f.BackgroundColor3 = bg or T.Surface
    f.BackgroundTransparency = transparency or 0
    f.BorderSizePixel = 0
    f.Parent = parent
    return f
end

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚              TOAST NOTIFICATION                  â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
local ToastQueue = {}
local ToastActive = false

local function showToast(text, color)
    table.insert(ToastQueue, {text = text, color = color or T.Accent})
    if ToastActive then return end

    local function processNext()
        if #ToastQueue == 0 then ToastActive = false return end
        ToastActive = true
        local data = table.remove(ToastQueue, 1)

        local toast = Instance.new("Frame")
        toast.Size = UDim2.new(0, 220, 0, 36)
        toast.Position = UDim2.new(0.5, -110, 1, 60)
        toast.BackgroundColor3 = T.Surface2
        toast.BorderSizePixel = 0
        toast.ZIndex = 20
        toast.Parent = ScreenGui
        corner(toast, 8)
        local ts = stroke(toast, data.color, 1.5)
        ts.ZIndex = 20

        local accent = newFrame(toast, UDim2.new(0, 3, 1, 0), UDim2.new(0, 0, 0, 0), data.color)
        accent.ZIndex = 20
        corner(accent, 3)

        local lbl = label(toast, data.text, 12, T.Text, false, Enum.TextXAlignment.Center)
        lbl.Size = UDim2.new(1, -10, 1, 0)
        lbl.Position = UDim2.new(0, 5, 0, 0)
        lbl.ZIndex = 21

        tween(toast, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, -110, 1, -55)})
        task.wait(2)
        tween(toast, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, -110, 1, 80)})
        task.wait(0.3)
        toast:Destroy()
        task.wait(0.1)
        processNext()
    end

    task.spawn(processNext)
end

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚                  SCREEN GUI                      â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
-- Forward-declare ScreenGui so showToast can use it
ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EssentialsGUI_V3"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚                   MAIN FRAME                     â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
local GUI_W, GUI_H = 260, 320

local MainFrame = newFrame(ScreenGui, UDim2.new(0, GUI_W, 0, GUI_H),
    UDim2.new(0.5, -GUI_W/2, 0.5, -GUI_H/2), T.BG)
corner(MainFrame, 12)
stroke(MainFrame, T.Stroke, 1.5)
MainFrame.ClipsDescendants = true

-- Gradient overlay at top
local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 50, 80)),
    ColorSequenceKeypoint.new(1, T.BG)
}
grad.Rotation = 90

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚                    HEADER                        â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
local Header = newFrame(MainFrame, UDim2.new(1, 0, 0, 40), nil, T.Surface)
Header.ZIndex = 2

-- Header accent bar
local headerLine = newFrame(Header, UDim2.new(1, 0, 0, 2),
    UDim2.new(0, 0, 1, -2), T.Accent)
headerLine.ZIndex = 2

local titleLbl = label(Header, "ESSENTIALS  V3", 15, T.Accent, true)
titleLbl.Size = UDim2.new(1, -85, 1, 0)
titleLbl.Position = UDim2.new(0, 14, 0, 0)
titleLbl.ZIndex = 3

local subLbl = label(Header, "REFORGED EDITION", 9, T.TextDim, false, Enum.TextXAlignment.Left)
subLbl.Size = UDim2.new(1, -85, 0, 10)
subLbl.Position = UDim2.new(0, 14, 1, -14)
subLbl.ZIndex = 3

-- Header buttons factory
local function makeHeaderBtn(sym, xOffset, bg)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 26, 0, 26)
    btn.Position = UDim2.new(1, xOffset, 0.5, -13)
    btn.Text = sym
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = bg
    btn.ZIndex = 4
    btn.Parent = Header
    corner(btn, 6)
    return btn
end

local CloseBtn = makeHeaderBtn("âœ•", -10,  T.Danger)
local MinBtn   = makeHeaderBtn("â”€", -40,  T.Surface2)

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚                  TAB SYSTEM                      â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
local TabBar = newFrame(MainFrame, UDim2.new(1, 0, 0, 32),
    UDim2.new(0, 0, 0, 40), T.Surface)
TabBar.ZIndex = 2

local tabBarLayout = Instance.new("UIListLayout")
tabBarLayout.FillDirection = Enum.FillDirection.Horizontal
tabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabBarLayout.Padding = UDim.new(0, 4)
tabBarLayout.Parent = TabBar

local tabBarPad = Instance.new("UIPadding")
tabBarPad.PaddingLeft = UDim.new(0, 8)
tabBarPad.PaddingRight = UDim.new(0, 8)
tabBarPad.Parent = TabBar

-- Content area
local ContentHolder = newFrame(MainFrame,
    UDim2.new(1, 0, 1, -72), UDim2.new(0, 0, 0, 72),
    Color3.new(0,0,0), 1)
ContentHolder.ClipsDescendants = true

-- Tab page scaffold
local tabs = {}
local activeTab = nil

local function makePage()
    local page = newFrame(ContentHolder, UDim2.new(1, 0, 1, 0), nil, Color3.new(0,0,0), 1)
    page.Visible = false

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = T.Accent
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.Parent = page

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft  = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop   = UDim.new(0, 8)
    pad.PaddingBottom= UDim.new(0, 8)
    pad.Parent = scroll

    return page, scroll
end

local function makeTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 72, 0, 24)
    btn.Text = name
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamSemibold
    btn.TextColor3 = T.TextDim
    btn.BackgroundColor3 = T.Surface2
    btn.LayoutOrder = order
    btn.ZIndex = 3
    btn.Parent = TabBar
    corner(btn, 6)

    local page, scroll = makePage()
    local tab = { btn = btn, page = page, scroll = scroll }
    tabs[name] = tab

    btn.MouseButton1Click:Connect(function()
        if activeTab == tab then return end
        if activeTab then
            activeTab.page.Visible = false
            fastTween(activeTab.btn, {TextColor3 = T.TextDim, BackgroundColor3 = T.Surface2})
        end
        activeTab = tab
        tab.page.Visible = true
        fastTween(btn, {TextColor3 = T.Accent, BackgroundColor3 = T.AccentDim})
    end)

    return tab
end

local MovTab  = makeTab("Movement", 1)
local PlrTab  = makeTab("Player",   2)
local MscTab  = makeTab("Misc",     3)

-- Activate first tab
do
    activeTab = MovTab
    MovTab.page.Visible = true
    fastTween(MovTab.btn, {TextColor3 = T.Accent, BackgroundColor3 = T.AccentDim})
end

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚               WIDGET CONSTRUCTORS                â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜

-- TOGGLE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function makeToggle(parent, text, desc, order, onToggle)
    local row = newFrame(parent.scroll, UDim2.new(1, 0, 0, desc and 50 or 38),
        nil, T.Surface)
    row.LayoutOrder = order
    corner(row, 8)

    local pill = newFrame(row, UDim2.new(0, 36, 0, 20),
        UDim2.new(1, -46, 0.5, -10), T.Surface2)
    corner(pill, 10)

    local knob = newFrame(pill, UDim2.new(0, 14, 0, 14),
        UDim2.new(0, 3, 0.5, -7), T.TextDim)
    corner(knob, 7)

    local lbl = label(row, text, 13, T.Text, true)
    lbl.Size = UDim2.new(1, -56, 0, 18)
    lbl.Position = UDim2.new(0, 10, 0, desc and 7 or 10)

    if desc then
        local dLbl = label(row, desc, 10, T.TextDim)
        dLbl.Size = UDim2.new(1, -56, 0, 14)
        dLbl.Position = UDim2.new(0, 10, 0, 27)
    end

    local isOn = false
    local function setState(v)
        isOn = v
        tween(pill, TweenInfo.new(0.2), {BackgroundColor3 = v and T.AccentDim or T.Surface2})
        tween(knob, TweenInfo.new(0.2), {
            Position = v and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
            BackgroundColor3 = v and T.Accent or T.TextDim
        })
    end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = row

    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        setState(isOn)
        onToggle(isOn)
    end)

    btn.MouseEnter:Connect(function() fastTween(row, {BackgroundColor3 = T.Surface2}) end)
    btn.MouseLeave:Connect(function() fastTween(row, {BackgroundColor3 = T.Surface}) end)

    return { setState = setState, getState = function() return isOn end }
end

-- SLIDER â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function makeSlider(parent, text, minV, maxV, defaultV, order, onChange, fmt)
    local row = newFrame(parent.scroll, UDim2.new(1, 0, 0, 54), nil, T.Surface)
    row.LayoutOrder = order
    corner(row, 8)

    local fmt = fmt or function(v) return tostring(v) end

    local topLbl = label(row, text, 12, T.TextDim)
    topLbl.Size = UDim2.new(0.6, 0, 0, 18)
    topLbl.Position = UDim2.new(0, 10, 0, 6)

    local valLbl = label(row, fmt(defaultV), 12, T.Accent, true, Enum.TextXAlignment.Right)
    valLbl.Size = UDim2.new(0.4, -10, 0, 18)
    valLbl.Position = UDim2.new(0.6, 0, 0, 6)

    local track = newFrame(row, UDim2.new(1, -20, 0, 4), UDim2.new(0, 10, 0, 34), T.Surface2)
    corner(track, 4)

    local fill = newFrame(track, UDim2.new((defaultV - minV)/(maxV - minV), 0, 1, 0), nil, T.AccentDim)
    corner(fill, 4)

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((defaultV - minV)/(maxV - minV), -7, 0.5, -7)
    knob.BackgroundColor3 = T.Accent
    knob.Text = ""
    knob.Parent = track
    corner(knob, 7)
    stroke(knob, T.BG, 2)

    local function setByRatio(r)
        r = math.clamp(r, 0, 1)
        local v = math.floor(minV + r * (maxV - minV))
        fill.Size = UDim2.new(r, 0, 1, 0)
        knob.Position = UDim2.new(r, -7, 0.5, -7)
        valLbl.Text = fmt(v)
        onChange(v)
        return v
    end

    local dragging = false
    knob.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or
           inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement and
           inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local mx = UserInputService:GetMouseLocation().X
        local r = (mx - track.AbsolutePosition.X) / track.AbsoluteSize.X
        setByRatio(r)
    end)

    -- Also allow clicking the track
    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            local mx = UserInputService:GetMouseLocation().X
            local r = (mx - track.AbsolutePosition.X) / track.AbsoluteSize.X
            setByRatio(r)
            dragging = true
        end
    end)

    return { setValue = function(v)
        setByRatio((v - minV) / (maxV - minV))
    end }
end

-- SECTION HEADER â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function makeSection(parent, text, order)
    local row = newFrame(parent.scroll, UDim2.new(1, 0, 0, 22), nil, Color3.new(0,0,0), 1)
    row.LayoutOrder = order

    local l = label(row, text:upper(), 10, T.TextDim, true)
    l.Size = UDim2.new(1, -10, 1, 0)
    l.Position = UDim2.new(0, 0, 0, 0)

    local line = newFrame(row, UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 1, 0), T.Stroke)
end

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚            PHYSICS / EFFECT STATE                â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
local BodyVel, BodyGyro
local AirWalkPart = nil
local anAFKConn = nil
local godLoop   = nil
local espHighlights = {}

local function cleanupFlyPhysics()
    if BodyVel  then BodyVel:Destroy()  BodyVel  = nil end
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
end

local function cleanupAirWalk()
    if AirWalkPart then AirWalkPart:Destroy() AirWalkPart = nil end
end

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚              MOVEMENT TAB  WIDGETS               â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
makeSection(MovTab, "Locomotion", 1)

local flyToggle = makeToggle(MovTab, "Fly Mode",
    "WASD + Space/Ctrl for 6DOF flight", 2, function(on)
    CFG.FlyEnabled = on
    if not on then cleanupFlyPhysics() end
    if on and CFG.AirWalkEnabled then
        -- disable conflicting mode
        CFG.AirWalkEnabled = false
        cleanupAirWalk()
        -- airwalkToggle state reset handled after declaration
    end
    showToast(on and "âœˆ  Fly Mode  ON" or "âœˆ  Fly Mode  OFF", on and T.Success or T.Danger)
end)

makeSlider(MovTab, "Fly Speed", 5, 200, 40, 3, function(v)
    CFG.FlySpeed = v
end, function(v) return v .. " stud/s" end)

makeSection(MovTab, "Advanced", 10)

local airwalkToggle = makeToggle(MovTab, "Air Walk",
    "Locks invisible platform under feet", 11, function(on)
    CFG.AirWalkEnabled = on
    if on then
        if CFG.FlyEnabled then
            CFG.FlyEnabled = false
            cleanupFlyPhysics()
            flyToggle.setState(false)
        end
        local char = LocalPlayer.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum  = char:FindFirstChild("Humanoid")
            if root and hum then
                cleanupAirWalk()
                AirWalkPart = Instance.new("Part")
                AirWalkPart.Name = "AirWalkPlatform"
                AirWalkPart.Size = Vector3.new(8, 0.5, 8)
                AirWalkPart.Transparency = 0.95
                AirWalkPart.Anchored = true
                AirWalkPart.CanCollide = true
                AirWalkPart.Material = Enum.Material.Neon
                AirWalkPart.Color = T.Accent
                AirWalkPart.Parent = Workspace
                local hip = math.max(hum.HipHeight, 2)
                CFG.AirWalkYLevel = root.Position.Y - (hip + 0.35)
                AirWalkPart.Position = Vector3.new(root.Position.X, CFG.AirWalkYLevel, root.Position.Z)
            end
        end
    else
        cleanupAirWalk()
    end
    showToast(on and "ðŸŸ¦ Air Walk  ON" or "ðŸŸ¦ Air Walk  OFF", on and T.Success or T.Danger)
end)

local noclipToggle = makeToggle(MovTab, "Noclip",
    "Walk through walls", 12, function(on)
    CFG.NoclipEnabled = on
    showToast(on and "ðŸ‘» Noclip  ON" or "ðŸ‘» Noclip  OFF", on and T.Success or T.Danger)
end)

local infJumpToggle = makeToggle(MovTab, "Infinite Jump", nil, 13, function(on)
    CFG.InfJumpEnabled = on
    showToast(on and "â¬†  Inf. Jump  ON" or "â¬†  Inf. Jump  OFF", on and T.Success or T.Danger)
end)

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚               PLAYER TAB  WIDGETS                â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
makeSection(PlrTab, "Character Stats", 1)

makeSlider(PlrTab, "Walk Speed", 1, 100, 16, 2, function(v)
    CFG.WalkSpeed = v
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = v end
end, function(v) return v end)

makeSlider(PlrTab, "Jump Power", 0, 400, 50, 3, function(v)
    CFG.JumpPower = v
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = v
    end
end, function(v) return v end)

makeSection(PlrTab, "Survival", 10)

local godToggle = makeToggle(PlrTab, "God Mode",
    "Locks health at max", 11, function(on)
    CFG.GodModeEnabled = on
    if on then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end
    end
    showToast(on and "ðŸ›¡  God Mode  ON" or "ðŸ›¡  God Mode  OFF", on and T.Success or T.Danger)
end)

local antiafkToggle = makeToggle(PlrTab, "Anti-AFK",
    "Prevents auto-disconnect", 12, function(on)
    CFG.AntiAFKEnabled = on
    if on then
        local vjs = LocalPlayer:FindFirstChild("Virtual")
        if not anAFKConn then
            anAFKConn = LocalPlayer.Idled:Connect(function()
                -- Simulate a tiny movement to reset AFK timer
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then
                    hum.Jump = true
                end
                LocalPlayer:GetMouse().KeyDown:Connect(function() end)
            end)
        end
    else
        if anAFKConn then anAFKConn:Disconnect() anAFKConn = nil end
    end
    showToast(on and "â° Anti-AFK  ON" or "â° Anti-AFK  OFF", on and T.Success or T.Danger)
end)

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚               MISC TAB  WIDGETS                  â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
makeSection(MscTab, "World", 1)

makeSlider(MscTab, "Gravity", 1, 300, math.floor(DEFAULT_GRAVITY), 2, function(v)
    CFG.GravityValue = v
    Workspace.Gravity = v
end, function(v)
    if v <= 5 then return "Moon ðŸŒ™"
    elseif v <= 50 then return "Low  (" .. v .. ")"
    elseif v <= 196 then return "Normal (" .. v .. ")"
    else return "High (" .. v .. ")" end
end)

makeSection(MscTab, "Visuals", 10)

local espToggle = makeToggle(MscTab, "Player ESP",
    "Highlights all other players", 11, function(on)
    CFG.ESPEnabled = on
    if on then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local h = Instance.new("Highlight")
                h.Name = "ESP_Highlight"
                h.FillColor = T.Accent
                h.OutlineColor = Color3.new(1,1,1)
                h.FillTransparency = 0.6
                h.OutlineTransparency = 0
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Parent = plr.Character
                espHighlights[plr.Name] = h

                -- Name tag
                local bb = Instance.new("BillboardGui")
                bb.Name = "ESP_Tag"
                bb.Size = UDim2.new(0, 100, 0, 30)
                bb.StudsOffset = Vector3.new(0, 3.5, 0)
                bb.AlwaysOnTop = true
                bb.Parent = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character
                local tl = Instance.new("TextLabel", bb)
                tl.Size = UDim2.new(1, 0, 1, 0)
                tl.BackgroundTransparency = 1
                tl.Text = plr.Name
                tl.TextColor3 = T.Accent
                tl.TextSize = 13
                tl.Font = Enum.Font.GothamBold
                tl.TextStrokeTransparency = 0.4
            end
        end
    else
        for _, h in pairs(espHighlights) do
            if h and h.Parent then h:Destroy() end
        end
        espHighlights = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                local tag = plr.Character:FindFirstChild("ESP_Tag")
                if tag then tag:Destroy() end
            end
        end
    end
    showToast(on and "ðŸ” ESP  ON" or "ðŸ” ESP  OFF", on and T.Success or T.Danger)
end)

-- Cleanup ESP when player leaves
Players.PlayerRemoving:Connect(function(plr)
    if espHighlights[plr.Name] then
        local h = espHighlights[plr.Name]
        if h and h.Parent then h:Destroy() end
        espHighlights[plr.Name] = nil
    end
end)

-- Add ESP to new players joining
Players.PlayerAdded:Connect(function(plr)
    if not CFG.ESPEnabled then return end
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        local h = Instance.new("Highlight")
        h.Name = "ESP_Highlight"
        h.FillColor = T.Accent
        h.OutlineColor = Color3.new(1,1,1)
        h.FillTransparency = 0.6
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = char
        espHighlights[plr.Name] = h
    end)
end)

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚                HEADER DRAG ONLY                  â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
local dragging, dragStart, frameStart
Header.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or
       inp.UserInputType == Enum.UserInputType.Touch then
        dragging  = true
        dragStart = inp.Position
        frameStart= MainFrame.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if not dragging then return end
    if inp.UserInputType ~= Enum.UserInputType.MouseMovement and
       inp.UserInputType ~= Enum.UserInputType.Touch then return end
    local d = inp.Position - dragStart
    MainFrame.Position = UDim2.new(
        frameStart.X.Scale, frameStart.X.Offset + d.X,
        frameStart.Y.Scale, frameStart.Y.Offset + d.Y
    )
end)

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚              CLOSE / MINIMIZE                    â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
local minimized = false

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        ContentHolder.Visible = false
        TabBar.Visible = false
        tween(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, GUI_W, 0, 40)})
        MinBtn.Text = "+"
    else
        tween(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, GUI_W, 0, GUI_H)})
        task.wait(0.25)
        ContentHolder.Visible = true
        TabBar.Visible = true
        MinBtn.Text = "â”€"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    cleanupFlyPhysics()
    cleanupAirWalk()
    Workspace.Gravity = DEFAULT_GRAVITY
    if anAFKConn then anAFKConn:Disconnect() end
    for _, h in pairs(espHighlights) do if h and h.Parent then h:Destroy() end end
    tween(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
    task.wait(0.25)
    ScreenGui:Destroy()
end)

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚               KEYBIND: RSHIFT HIDE               â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
local guiVisible = true
UserInputService.InputBegan:Connect(function(inp, gameProc)
    if gameProc then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        guiVisible = not guiVisible
        MainFrame.Visible = guiVisible
    end
end)

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚                 RESPAWN HANDLER                  â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
LocalPlayer.CharacterAdded:Connect(function(char)
    cleanupAirWalk()
    cleanupFlyPhysics()

    task.wait(0.6)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        hum.WalkSpeed = CFG.WalkSpeed
        hum.UseJumpPower = true
        hum.JumpPower = CFG.JumpPower
        if CFG.GodModeEnabled then
            hum.MaxHealth = math.huge
            hum.Health    = math.huge
        end
    end

    if CFG.AirWalkEnabled then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root and hum then
            AirWalkPart = Instance.new("Part")
            AirWalkPart.Name = "AirWalkPlatform"
            AirWalkPart.Size = Vector3.new(8, 0.5, 8)
            AirWalkPart.Transparency = 0.95
            AirWalkPart.Anchored = true
            AirWalkPart.CanCollide = true
            AirWalkPart.Material = Enum.Material.Neon
            AirWalkPart.Color = T.Accent
            AirWalkPart.Parent = Workspace
            CFG.AirWalkYLevel = root.Position.Y - (math.max(hum.HipHeight, 2) + 0.35)
            AirWalkPart.Position = Vector3.new(root.Position.X, CFG.AirWalkYLevel, root.Position.Z)
        end
    end

    if CFG.ESPEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                if not plr.Character:FindFirstChild("ESP_Highlight") then
                    local h = Instance.new("Highlight")
                    h.Name = "ESP_Highlight"
                    h.FillColor = T.Accent
                    h.OutlineColor = Color3.new(1,1,1)
                    h.FillTransparency = 0.6
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Parent = plr.Character
                    espHighlights[plr.Name] = h
                end
            end
        end
    end
end)

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚                 MAIN GAME LOOPS                  â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜

-- Noclip lives in Stepped (physics frame)
RunService.Stepped:Connect(function()
    if not CFG.NoclipEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if not CFG.InfJumpEnabled then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- Main render loop
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChild("Humanoid")
    if not (char and root and hum) then return end

    -- â”€â”€ GOD MODE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    if CFG.GodModeEnabled then
        if hum.MaxHealth ~= math.huge then hum.MaxHealth = math.huge end
        if hum.Health < hum.MaxHealth  then hum.Health   = math.huge end
    end

    -- â”€â”€ FLY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    if CFG.FlyEnabled then
        -- Ensure physics objects exist
        if not BodyVel or BodyVel.Parent ~= root then
            cleanupFlyPhysics()
            BodyVel = Instance.new("BodyVelocity")
            BodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            BodyVel.Velocity  = Vector3.zero
            BodyVel.Parent    = root

            BodyGyro = Instance.new("BodyGyro")
            BodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            BodyGyro.P   = 5000
            BodyGyro.D   = 200
            BodyGyro.CFrame = root.CFrame
            BodyGyro.Parent = root
        end

        local cam = Camera.CFrame
        local speed = CFG.FlySpeed
        local vel = Vector3.zero

        -- True camera-relative directions
        local fwd   = cam.LookVector
        local right = cam.RightVector
        local up    = Vector3.new(0, 1, 0)

        local kb = UserInputService

        -- Movement (ignoring humanoid MoveDirection for smoother camera follow)
        if kb:IsKeyDown(Enum.KeyCode.W) then vel = vel + fwd  * speed end
        if kb:IsKeyDown(Enum.KeyCode.S) then vel = vel - fwd  * speed end
        if kb:IsKeyDown(Enum.KeyCode.A) then vel = vel - right* speed end
        if kb:IsKeyDown(Enum.KeyCode.D) then vel = vel + right* speed end
        if kb:IsKeyDown(Enum.KeyCode.Space)     then vel = vel + up * speed end
        if kb:IsKeyDown(Enum.KeyCode.LeftControl) or
           kb:IsKeyDown(Enum.KeyCode.LeftShift)  then vel = vel - up * speed end

        BodyVel.Velocity  = vel
        BodyGyro.CFrame   = CFrame.lookAt(root.Position, root.Position + cam.LookVector)
        hum.PlatformStand = vel.Magnitude > 0
    else
        if BodyVel then
            cleanupFlyPhysics()
            hum.PlatformStand = false
        end
    end

    -- â”€â”€ AIR WALK â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    if CFG.AirWalkEnabled and AirWalkPart then
        AirWalkPart.Position = Vector3.new(root.Position.X, CFG.AirWalkYLevel, root.Position.Z)
    elseif not CFG.AirWalkEnabled and AirWalkPart then
        cleanupAirWalk()
    end
end)

-- â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
-- â”‚                 INIT TOAST                       â”‚
-- â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
task.wait(0.5)
showToast("âœ…  Essentials V3.0 Loaded", T.Success)
