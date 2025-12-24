local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Moon - Hub",
    LoadingTitle = "MOON - X HUB",
    LoadingSubtitle = "by - Lotus",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "MoonConfig"
    },
    Theme = {
        TextColor = Color3.fromRGB(230, 225, 219),
        Background = Color3.fromRGB(18, 16, 13),
        Topbar = Color3.fromRGB(22, 19, 15),
        Shadow = Color3.fromRGB(10, 8, 6),
        NotificationBackground = Color3.fromRGB(26, 23, 19),
        NotificationActionsBackground = Color3.fromRGB(34, 30, 25),
        TabBackground = Color3.fromRGB(26, 23, 19),
        TabStroke = Color3.fromRGB(42, 37, 31),
        TabBackgroundSelected = Color3.fromRGB(36, 32, 26),
        TabTextColor = Color3.fromRGB(170, 165, 158),
        SelectedTabTextColor = Color3.fromRGB(235, 230, 224),
        ElementBackground = Color3.fromRGB(31, 27, 22),
        ElementBackgroundHover = Color3.fromRGB(38, 33, 27),
        SecondaryElementBackground = Color3.fromRGB(26, 23, 19),
        ElementStroke = Color3.fromRGB(46, 40, 33),
        SecondaryElementStroke = Color3.fromRGB(38, 33, 27),
        SliderBackground = Color3.fromRGB(44, 38, 31),
        SliderProgress = Color3.fromRGB(150, 145, 138),
        SliderStroke = Color3.fromRGB(90, 82, 74),
        ToggleBackground = Color3.fromRGB(34, 30, 25),
        ToggleEnabled = Color3.fromRGB(165, 160, 152),
        ToggleDisabled = Color3.fromRGB(85, 78, 70),
        ToggleEnabledStroke = Color3.fromRGB(130, 122, 114),
        ToggleDisabledStroke = Color3.fromRGB(60, 55, 49),
        ToggleEnabledOuterStroke = Color3.fromRGB(110, 102, 94),
        ToggleDisabledOuterStroke = Color3.fromRGB(50, 45, 40),
        DropdownSelected = Color3.fromRGB(38, 33, 27),
        DropdownUnselected = Color3.fromRGB(30, 26, 22),
        InputBackground = Color3.fromRGB(31, 27, 22),
        InputStroke = Color3.fromRGB(55, 48, 41),
        PlaceholderColor = Color3.fromRGB(155, 148, 140)
    }
})

-- ========================================
-- CONFIG
-- ========================================
local CONFIG = {
    WELCOME_NOTIFICATION = 13492315901,
    HOME_ICON = 515816713,
    LAUNCH_ICON = 16149155528,
    DISABLED_ICON = 10844111750,
    ERROR_ICON = 17829927053,
}

-- ========================================
-- SERVICES
-- ========================================
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

-- ========================================
-- CAMERA SETTINGS
-- ========================================

local player = Players.LocalPlayer

local cameraSettings = {
    maxZoom = 555,
    minZoom = 0.5
}

local function unlockCamera()
    player.CameraMaxZoomDistance = cameraSettings.maxZoom
    player.CameraMinZoomDistance = cameraSettings.minZoom
end

local function setupCameraMonitor()
    player:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
        if player.CameraMaxZoomDistance ~= cameraSettings.maxZoom then
            player.CameraMaxZoomDistance = cameraSettings.maxZoom
        end
    end)
    
    player:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function()
        if player.CameraMinZoomDistance ~= cameraSettings.minZoom then
            player.CameraMinZoomDistance = cameraSettings.minZoom
        end
    end)
end

player.CharacterAdded:Connect(function()
    task.wait(0.1)
    unlockCamera()
end)

unlockCamera()
setupCameraMonitor()

-- ========================================
-- ANTI-AFK
-- ========================================
Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ========================================
-- NIGHT MODE SYSTEM
-- ========================================
local NightMode = {
    enabled = true,
    renderConnection = nil,
    timeConnection = nil,
    originalBrightness = nil,
    originalClockTime = nil,
    targetBrightness = 0.05,
    targetTime = 0
}

local function startNightMode()
    if not NightMode.originalBrightness then
        NightMode.originalBrightness = Lighting.Brightness
    end
    if not NightMode.originalClockTime then
        NightMode.originalClockTime = Lighting.ClockTime
    end
    
    Lighting.Brightness = NightMode.targetBrightness
    Lighting.ClockTime = NightMode.targetTime
    
    if NightMode.renderConnection then
        NightMode.renderConnection:Disconnect()
    end
    
    NightMode.renderConnection = RunService.RenderStepped:Connect(function()
        if NightMode.enabled then
            if Lighting.Brightness ~= NightMode.targetBrightness then
                Lighting.Brightness = NightMode.targetBrightness
            end
            if Lighting.ClockTime ~= NightMode.targetTime then
                Lighting.ClockTime = NightMode.targetTime
            end
        end
    end)
end

local function stopNightMode()
    if NightMode.renderConnection then
        NightMode.renderConnection:Disconnect()
        NightMode.renderConnection = nil
    end
    
    if NightMode.originalBrightness then
        Lighting.Brightness = NightMode.originalBrightness
    end
    if NightMode.originalClockTime then
        Lighting.ClockTime = NightMode.originalClockTime
    end
end

startNightMode()

-- ========================================
-- WALK SPEED SYSTEM
-- ========================================
local WalkSpeed = {
    enabled = false,
    speed = 28,
    defaultSpeed = 16,
    connection = nil
}

local function setWalkSpeed(speed)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end

local function startWalkSpeedMonitor()
    if WalkSpeed.connection then return end
    
    WalkSpeed.connection = RunService.RenderStepped:Connect(function()
        if WalkSpeed.enabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.WalkSpeed ~= WalkSpeed.speed then
                player.Character.Humanoid.WalkSpeed = WalkSpeed.speed
            end
        end
    end)
end

local function stopWalkSpeedMonitor()
    if WalkSpeed.connection then
        WalkSpeed.connection:Disconnect()
        WalkSpeed.connection = nil
    end
end

player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    if WalkSpeed.enabled then
        task.wait(0.1)
        setWalkSpeed(WalkSpeed.speed)
    end
end)

-- ========================================
-- AUTO CLICKER SYSTEM
-- ========================================
local AutoClicker = {
    enabled = false,
    interval = 50,
    connection = nil,
    lastClick = 0
}

local function performClick()
    local mouse = player:GetMouse()
    if mouse then
        mouse1click()
    end
end

local function startAutoClicker()
    if AutoClicker.connection then return end
    
    AutoClicker.connection = RunService.RenderStepped:Connect(function()
        if AutoClicker.enabled then
            local currentTime = tick()
            if (currentTime - AutoClicker.lastClick) >= (AutoClicker.interval / 1000) then
                performClick()
                AutoClicker.lastClick = currentTime
            end
        end
    end)
end

local function stopAutoClicker()
    if AutoClicker.connection then
        AutoClicker.connection:Disconnect()
        AutoClicker.connection = nil
    end
end

-- ========================================
-- MAIN TAB
-- ========================================
local MainTab = Window:CreateTab("Main", CONFIG.HOME_ICON)

MainTab:CreateSection("Fish It - Features")

MainTab:CreateInput({
    Name = "Walk Speed Value",
    PlaceholderText = "28",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local speed = tonumber(Text)
        if speed and speed >= 16 and speed <= 500 then
            WalkSpeed.speed = speed
            if WalkSpeed.enabled then
                setWalkSpeed(speed)
            end
            Rayfield:Notify({
                Title = "Walk Speed",
                Content = "Speed set to " .. speed,
                Duration = 3,
                Image = CONFIG.LAUNCH_ICON
            })
        else
            Rayfield:Notify({
                Title = "Walk Speed",
                Content = "Invalid speed (16-500)",
                Image = CONFIG.ERROR_ICON,
                Duration = 3
            })
        end
    end
})

MainTab:CreateKeybind({
    Name = "Custom Walk Speed",
    CurrentKeybind = "R",
    HoldToInteract = false,
    Flag = "WalkSpeedKeybind",
    Callback = function(Keybind)
        WalkSpeed.enabled = not WalkSpeed.enabled
        
        if WalkSpeed.enabled then
            setWalkSpeed(WalkSpeed.speed)
            startWalkSpeedMonitor()
            Rayfield:Notify({
                Title = "Walk Speed",
                Content = "Enabled (Speed: " .. WalkSpeed.speed .. ")",
                Duration = 3,
                Image = CONFIG.LAUNCH_ICON
            })
        else
            stopWalkSpeedMonitor()
            setWalkSpeed(WalkSpeed.defaultSpeed)
            Rayfield:Notify({
                Title = "Walk Speed",
                Content = "Disabled (Reset to default)",
                Duration = 3,
                Image = CONFIG.DISABLED_ICON
            })
        end
    end,
})

-- ========================================
-- MISCH TAB
-- ========================================
local MischTab = Window:CreateTab("Misch", 14930022773)

MischTab:CreateSection("Visual Settings")

MischTab:CreateToggle({
    Name = "Night Mode (Forced)",
    CurrentValue = true,
    Flag = "NightModeToggle",
    Callback = function(Value)
        NightMode.enabled = Value
        
        if Value then
            startNightMode()
            Rayfield:Notify({
                Title = "Night Mode",
                Content = "Forced night mode enabled",
                Duration = 3,
                Image = CONFIG.LAUNCH_ICON
            })
        else
            stopNightMode()
            Rayfield:Notify({
                Title = "Night Mode",
                Content = "Night mode disabled",
                Duration = 3,
                Image = CONFIG.DISABLED_ICON
            })
        end
    end
})

MischTab:CreateSection("Auto Clicker Settings")

MischTab:CreateInput({
    Name = "Auto Clicker Interval (ms)",
    PlaceholderText = "50",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local interval = tonumber(Text)
        if interval and interval >= 10 and interval <= 1000 then
            AutoClicker.interval = interval
            Rayfield:Notify({
                Title = "Auto Clicker",
                Content = "Interval set to " .. interval .. "ms",
                Duration = 3,
                Image = CONFIG.LAUNCH_ICON
            })
        else
            Rayfield:Notify({
                Title = "Auto Clicker",
                Content = "Invalid interval (10-1000ms)",
                Image = CONFIG.ERROR_ICON,
                Duration = 3
            })
        end
    end
})

MischTab:CreateKeybind({
    Name = "Toggle Auto Clicker",
    CurrentKeybind = "F6",
    HoldToInteract = false,
    Flag = "AutoClickerKeybind",
    Callback = function(Keybind)
        AutoClicker.enabled = not AutoClicker.enabled
        
        if AutoClicker.enabled then
            startAutoClicker()
            Rayfield:Notify({
                Title = "Auto Clicker",
                Content = "Enabled (" .. AutoClicker.interval .. "ms interval)",
                Duration = 3,
                Image = CONFIG.LAUNCH_ICON
            })
        else
            stopAutoClicker()
            Rayfield:Notify({
                Title = "Auto Clicker",
                Content = "Disabled",
                Duration = 3,
                Image = CONFIG.DISABLED_ICON
            })
        end
    end,
})
