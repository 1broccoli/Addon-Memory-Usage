-- Variable to track if the message has already been printed
local messagePrinted = false

-- Function to initialize settings with default values
local function InitializeSettings()
    if not AMU_Settings then
        AMU_Settings = {}
    end
    AMU_Settings.scale = AMU_Settings.scale or 1
    AMU_Settings.alpha = AMU_Settings.alpha or 0.7
    AMU_Settings.textAlpha = AMU_Settings.textAlpha or 1
    AMU_Settings.showFPS = AMU_Settings.showFPS ~= false  -- Default to true if nil
    AMU_Settings.showHomeLatency = AMU_Settings.showHomeLatency ~= false  -- Default to true if nil
    AMU_Settings.showWorldLatency = AMU_Settings.showWorldLatency ~= false  -- Default to true if nil
    AMU_Settings.showMemoryUsage = AMU_Settings.showMemoryUsage ~= false  -- Default to true if nil
    AMU_Settings.showBackground = AMU_Settings.showBackground ~= false  -- Default to true if nil
    AMU_Settings.showMainFrame = AMU_Settings.showMainFrame ~= false  -- Default to true if nil
    AMU_Settings.horizontalLayout = AMU_Settings.horizontalLayout or false  -- Default to vertical layout
end

-- Ensure settings are initialized
InitializeSettings()

-- Create the main frame
local frame = CreateFrame("Frame", "MyStatsFrame", UIParent, "BackdropTemplate")
frame:SetPoint("CENTER")
frame:SetSize(170, 80)  -- Frame size
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

-- Create text labels with white color
local latencyHomeLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
latencyHomeLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
latencyHomeLabel:SetTextColor(1, 1, 1)
latencyHomeLabel:SetText("Local")

local latencyHomeValue = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
latencyHomeValue:SetPoint("LEFT", latencyHomeLabel, "RIGHT", 5, 0)

local latencyWorldLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
latencyWorldLabel:SetPoint("TOPLEFT", latencyHomeLabel, "BOTTOMLEFT", 0, -10)
latencyWorldLabel:SetText("World")
latencyWorldLabel:SetTextColor(1, 1, 1)

local latencyWorldValue = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
latencyWorldValue:SetPoint("LEFT", latencyWorldLabel, "RIGHT", 5, 0)

local memoryUsageLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
memoryUsageLabel:SetPoint("TOPLEFT", latencyWorldLabel, "BOTTOMLEFT", 0, -10)
memoryUsageLabel:SetText("Memory")
memoryUsageLabel:SetTextColor(1, 1, 1)

local memoryUsageValue = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
memoryUsageValue:SetPoint("LEFT", memoryUsageLabel, "RIGHT", 5, 0)

local fpsLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fpsLabel:SetPoint("TOPLEFT", memoryUsageLabel, "BOTTOMLEFT", 0, -10)
fpsLabel:SetText("FPS")
fpsLabel:SetTextColor(1, 1, 1)

local fpsValue = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fpsValue:SetPoint("LEFT", fpsLabel, "RIGHT", 5, 0)

-- Function to apply settings
local function ApplySettings()
    frame:SetScale(AMU_Settings.scale)
    frame:SetBackdrop({
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",  -- Border texture
        tile = true, tileSize = 16, edgeSize = 10,  -- Larger edge size for thick border
        insets = { left = -6, right = -6, top = -6, bottom = -6 }  -- Negative insets for outer extension
    })
    frame:SetBackdropColor(0, 0, 0, AMU_Settings.showBackground and AMU_Settings.alpha or 0)  -- Toggle backdrop visibility
    frame:SetBackdropBorderColor(0, 0, 0, AMU_Settings.showBackground and 1 or 0)
    
    local textAlpha = AMU_Settings.textAlpha or 1
    fpsLabel:SetAlpha(textAlpha)
    fpsValue:SetAlpha(textAlpha)
    latencyHomeLabel:SetAlpha(textAlpha)
    latencyHomeValue:SetAlpha(textAlpha)
    latencyWorldLabel:SetAlpha(textAlpha)
    latencyWorldValue:SetAlpha(textAlpha)
    memoryUsageLabel:SetAlpha(textAlpha)
    memoryUsageValue:SetAlpha(textAlpha)
    
    -- Adjust visibility and position of elements
    local yOffset = -10
    if AMU_Settings.showHomeLatency then
        latencyHomeLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, yOffset)
        latencyHomeLabel:Show()
        latencyHomeValue:SetPoint("LEFT", latencyHomeLabel, "RIGHT", 5, 0)
        latencyHomeValue:Show()
        yOffset = yOffset - 20
    else
        latencyHomeLabel:Hide()
        latencyHomeValue:Hide()
    end

    if AMU_Settings.showWorldLatency then
        latencyWorldLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, yOffset)
        latencyWorldLabel:Show()
        latencyWorldValue:SetPoint("LEFT", latencyWorldLabel, "RIGHT", 5, 0)
        latencyWorldValue:Show()
        yOffset = yOffset - 20
    else
        latencyWorldLabel:Hide()
        latencyWorldValue:Hide()
    end

    if AMU_Settings.showMemoryUsage then
        memoryUsageLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, yOffset)
        memoryUsageLabel:Show()
        memoryUsageValue:SetPoint("LEFT", memoryUsageLabel, "RIGHT", 5, 0)
        memoryUsageValue:Show()
        yOffset = yOffset - 20
    else
        memoryUsageLabel:Hide()
        memoryUsageValue:Hide()
    end

    if AMU_Settings.showFPS then
        fpsLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, yOffset)
        fpsLabel:Show()
        fpsValue:SetPoint("LEFT", fpsLabel, "RIGHT", 5, 0)
        fpsValue:Show()
        yOffset = yOffset - 20
    else
        fpsLabel:Hide()
        fpsValue:Hide()
    end

    -- Adjust frame height based on visible elements
    local height = -yOffset + 10  -- Base height plus padding
    frame:SetHeight(height)
    
    -- Hide frame if all checkboxes are unchecked
    if not (AMU_Settings.showFPS or AMU_Settings.showHomeLatency or AMU_Settings.showWorldLatency or AMU_Settings.showMemoryUsage) then
        frame:Hide()
    else
        frame:Show()
    end

    -- Show or hide the main frame based on the setting
    if AMU_Settings.showMainFrame then
        frame:Show()
    else
        frame:Hide()
    end

       -- Adjust layout based on the setting (Up & Down , Left & Right)
    if AMU_Settings.horizontalLayout then
        latencyHomeLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
        latencyHomeValue:SetPoint("LEFT", latencyHomeLabel, "RIGHT", 5, 0)
        
        latencyWorldLabel:SetPoint("TOPLEFT", latencyHomeLabel, "TOPLEFT", 85, 0)
        latencyWorldValue:SetPoint("LEFT", latencyWorldLabel, "RIGHT", 5, 0)

        memoryUsageLabel:SetPoint("TOPLEFT", latencyWorldLabel, "TOPLEFT", 90, 0)
        memoryUsageValue:SetPoint("LEFT", memoryUsageLabel, "RIGHT", 5, 0)

        fpsLabel:SetPoint("TOPLEFT", memoryUsageLabel, "TOPLEFT", 110, 0)
        fpsValue:SetPoint("LEFT", fpsLabel, "RIGHT", 5, 0)
    else
        latencyHomeLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
        latencyHomeValue:SetPoint("LEFT", latencyHomeLabel, "RIGHT", 5, 0)

        latencyWorldLabel:SetPoint("LEFT", latencyHomeValue, "RIGHT", 20, 0)
        latencyWorldValue:SetPoint("LEFT", latencyWorldLabel, "RIGHT", 5, 0)

        memoryUsageLabel:SetPoint("LEFT", latencyWorldValue, "RIGHT", 20, 0)
        memoryUsageValue:SetPoint("LEFT", memoryUsageLabel, "RIGHT", 5, 0)

        fpsLabel:SetPoint("LEFT", memoryUsageValue, "RIGHT", 20, 0)
        fpsValue:SetPoint("LEFT", fpsLabel, "RIGHT", 5, 0)
    end

    -- Adjust frame width based on layout
    if AMU_Settings.horizontalLayout then
        frame:SetWidth(370)  -- Default width for horizontal layout
        frame:SetHeight(30)  -- Adjust height for horizontal layout
    else
        frame:SetWidth(170)  -- Increased width for vertical layout
        frame:SetHeight(height)  -- Adjust height based on visible elements
    end
end

-- Save the checkbox and slider states when the player logs out
local function SaveSettings()
    AMU_Settings.showBackground = frameBorderCheckbox:GetChecked()
    AMU_Settings.showFPS = fpsCheckbox:GetChecked()
    AMU_Settings.showHomeLatency = homeLatencyCheckbox:GetChecked()
    AMU_Settings.showWorldLatency = worldLatencyCheckbox:GetChecked()
    AMU_Settings.showMemoryUsage = memoryUsageCheckbox:GetChecked()
    AMU_Settings.showMainFrame = mainFrameCheckbox:GetChecked()
    AMU_Settings.horizontalLayout = layoutCheckbox:GetChecked()
    AMU_Settings.scale = scaleSlider:GetValue()
    AMU_Settings.textAlpha = textAlphaSlider:GetValue()
end

-- This function runs when the player logs in
local function OnPlayerLogin()
    -- Check if the message has already been printed
    if not messagePrinted then
        -- Constructing the welcome message with colored text
        local message = string.format(
            "|cFF000000Addon Memory Usage|r |cFF808080by|r |cFFFFFFFFPegga|r"
        )
        -- Print the message
        print(message)

        -- Mark the message as printed
        messagePrinted = true
    end

    -- Apply settings on login to ensure the frame displays correctly
    ApplySettings()
end

-- Function to update checkbox and slider states from saved variables
local function UpdateSettingsStates()
    if frameBorderCheckbox and fpsCheckbox and homeLatencyCheckbox and worldLatencyCheckbox and memoryUsageCheckbox and mainFrameCheckbox and layoutCheckbox then
        frameBorderCheckbox:SetChecked(AMU_Settings.showBackground)
        fpsCheckbox:SetChecked(AMU_Settings.showFPS)
        homeLatencyCheckbox:SetChecked(AMU_Settings.showHomeLatency)
        worldLatencyCheckbox:SetChecked(AMU_Settings.showWorldLatency)
        memoryUsageCheckbox:SetChecked(AMU_Settings.showMemoryUsage)
        mainFrameCheckbox:SetChecked(AMU_Settings.showMainFrame)
        layoutCheckbox:SetChecked(AMU_Settings.horizontalLayout)
        
        -- Set text color based on checkbox state
        frameBorderCheckbox.Text:SetTextColor(AMU_Settings.showBackground and 1 or 0.5, AMU_Settings.showBackground and 1 or 0.5, AMU_Settings.showBackground and 0 or 0.5)
        fpsCheckbox.Text:SetTextColor(AMU_Settings.showFPS and 1 or 0.5, AMU_Settings.showFPS and 1 or 0.5, AMU_Settings.showFPS and 0 or 0.5)
        homeLatencyCheckbox.Text:SetTextColor(AMU_Settings.showHomeLatency and 1 or 0.5, AMU_Settings.showHomeLatency and 1 or 0.5, AMU_Settings.showHomeLatency and 0 or 0.5)
        worldLatencyCheckbox.Text:SetTextColor(AMU_Settings.showWorldLatency and 1 or 0.5, AMU_Settings.showWorldLatency and 1 or 0.5, AMU_Settings.showWorldLatency and 0 or 0.5)
        layoutCheckbox .Text:SetTextColor(AMU_Settings.horizontalLayout and 1 or 0.5, AMU_Settings.horizontalLayout and 1 or 0.5, AMU_Settings.horizontalLayout and 0 or 0.5)
        
    end
    if scaleSlider and textAlphaSlider then
        scaleSlider:SetValue(AMU_Settings.scale)
        textAlphaSlider:SetValue(AMU_Settings.textAlpha)
    end
end

-- Register the event
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_LOGOUT")
eventFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin()
        UpdateSettingsStates()
        self:UnregisterEvent("PLAYER_LOGIN")  -- Unregister to prevent multiple prints
    elseif event == "PLAYER_LOGOUT" then
        SaveSettings()
    end
end)

-- Create a tooltip
frame:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Right-click to open/close", 1, 1, 1, true)
    GameTooltip:Show()
end)

frame:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- Create background
local background = frame:CreateTexture(nil, "BACKGROUND")
background:SetAllPoints(true)
background:SetColorTexture(0, 0, 0, 0.5)

local addonMemoryFrame = CreateFrame("Frame", "AddonMemoryFrame", UIParent, "BackdropTemplate")
addonMemoryFrame:SetSize(350, 600)  -- Frame size
addonMemoryFrame:SetPoint("CENTER")  -- Center the frame

addonMemoryFrame:SetBackdrop({

    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",  -- Border texture
    tile = true, tileSize = 16, edgeSize = 12,  -- Larger edge size to extend the border
    insets = { left = -6, right = -6, top = -6, bottom = -6 }  -- Negative insets for outer extension
})

-- Set the backdrop colors: black border and a transparent black background
addonMemoryFrame:SetBackdropColor(0, 0, 0, 0.1)  -- Black background with transparency
addonMemoryFrame:SetBackdropBorderColor(0, 0, 0)  -- Black border
addonMemoryFrame:SetMovable(true)
addonMemoryFrame:EnableMouse(true)
addonMemoryFrame:RegisterForDrag("LeftButton")
addonMemoryFrame:SetScript("OnDragStart", addonMemoryFrame.StartMoving)
addonMemoryFrame:SetScript("OnDragStop", addonMemoryFrame.StopMovingOrSizing)
addonMemoryFrame:Hide()  -- Initially hidden

-- Create a tooltip for the addonMemoryFrame
addonMemoryFrame:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Right click to close", 1, 1, 1, true)  -- White text
    GameTooltip:Show()
end)

addonMemoryFrame:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)


-- Create a background for the addon frame
local addonBackground = addonMemoryFrame:CreateTexture(nil, "BACKGROUND")
addonBackground:SetAllPoints(true)
addonBackground:SetColorTexture(0, 0, 0, 0.8)

-- Create a title for the addon memory frame
local title = addonMemoryFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -10)
title:SetText("Addon Memory Usage")
title:SetTextColor(1, 0.5, 0.5) -- Color of title: light red

-- Function to clean memory and update the title temporarily
local function CleanMemory()
    -- Collect garbage and calculate the amount collected
    local before = collectgarbage("count")
    collectgarbage("collect")
    local after = collectgarbage("count")
    local collected = before - after

    -- Determine the unit and color based on the value of collected memory
    local memoryText
    if collected < 1 then
        memoryText = string.format("|cff00FFFF%d b|r", math.ceil(collected * 1024))  -- Bytes in cyan
    elseif collected < 1000 then
        memoryText = string.format("|cff00FF00%d kb|r", math.ceil(collected))  -- Kilobytes in green
    else
        memoryText = string.format("|cffFFD700%d mb|r", math.ceil(collected / 1024))  -- Megabytes in yellow
    end

    -- Change title to show amount of memory cleaned
    title:SetText(string.format("Cleaned: %s", memoryText))
    
    -- Revert title back after 3 seconds
    C_Timer.After(3, function()
        title:SetText("Addon Memory Usage") -- Revert back to original title
    end)
end

-- Create total addons text
local totalAddonsLabel = addonMemoryFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
totalAddonsLabel:SetPoint("TOPLEFT", addonMemoryFrame, "TOPLEFT", 10, -40)
totalAddonsLabel:SetText("Addons Loaded: ") --total number of addons out of e.g. 56/100 
totalAddonsLabel:SetTextColor(0.68, 0.85, 0.95) -- Light Blue


local totalAddonsValue = addonMemoryFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
totalAddonsValue:SetPoint("LEFT", totalAddonsLabel, "RIGHT", 5, 0)
totalAddonsValue:SetTextColor(1, 1, 1) -- White color

-- Create a scroll frame for memory list
local scrollFrame = CreateFrame("ScrollFrame", "AddonMemoryScrollFrame", addonMemoryFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -70)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 40)

-- Create a content frame for the scroll frame
local contentFrame = CreateFrame("Frame", "AddonMemoryContentFrame", scrollFrame)
contentFrame:SetSize(300, 400) -- Set the size of the content frame
scrollFrame:SetScrollChild(contentFrame)

-- Function to update the addon memory list
local function UpdateAddonMemoryList()
    -- Clear existing memory labels
    for _, child in ipairs({contentFrame:GetChildren()}) do
        child:Hide()
        child:SetParent(nil) -- Remove from parent to avoid clutter
    end

    local addons = {}
    local numAddOns = GetNumAddOns()
    for i = 1, numAddOns do
        if IsAddOnLoaded(i) then  -- Only show loaded addons
            local name = GetAddOnInfo(i)
            local memUsage = GetAddOnMemoryUsage(i)
            table.insert(addons, {name = name, memUsage = memUsage})
        end
    end

    -- Sort addons alphabetically by name
    table.sort(addons, function(a, b) return a.name < b.name end)

    local yOffset = 0
    for _, addon in ipairs(addons) do
        local name = addon.name
        local memUsage = addon.memUsage
        local memText
        local memColor

        -- Display memory usage based on its value
        if memUsage < 1 then
            memText = string.format("%d b", math.ceil(memUsage * 1024)) -- Always show bytes if < 1KB
            memColor = {0, 1, 1} -- Cyan for Bytes
        elseif memUsage < 1000 then
            memText = string.format("%d kb", math.ceil(memUsage)) -- Green KB
            memColor = {0, 1, 0} -- Green for KB
        else
            memText = string.format("%d mb", math.ceil(memUsage / 1024)) -- Yellow MB
            memColor = {1, 1, 0} -- Yellow for MB
        end

        -- Create a font string for the addon name
        local addonNameText = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        addonNameText:SetPoint("TOPLEFT", 10, -yOffset)
        addonNameText:SetText(name)
        addonNameText:SetTextColor(1, 1, 1) -- White color for addon names

        -- Create a font string for the memory usage
        local memoryUsageText = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        memoryUsageText:SetPoint("TOPRIGHT", -10, -yOffset) -- Align right with some padding
        memoryUsageText:SetText(memText)
        memoryUsageText:SetTextColor(unpack(memColor)) -- Apply color differential

        yOffset = yOffset + 20
    end

    contentFrame:SetHeight(yOffset) -- Update content frame height
    if yOffset > 0 then
        contentFrame:Show() -- Show the updated content only if there are addons to display
    else
        contentFrame:Hide() -- Hide if there are no addons
    end
end

-- Create the clean memory button with custom colors
local cleanButton = CreateFrame("Button", nil, addonMemoryFrame, "UIPanelButtonTemplate")
cleanButton:SetPoint("BOTTOMRIGHT", -120, 10)
cleanButton:SetSize(120, 30)

-- Set the normal texture to green
cleanButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
local normalTexture = cleanButton:GetNormalTexture()
normalTexture:SetTexCoord(0, 0.625, 0, 0.6875)  -- Crop the texture
normalTexture:SetVertexColor(0, 1, 0)  -- Green color for normal state

-- Set the highlight (hover) texture
cleanButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
local highlightTexture = cleanButton:GetHighlightTexture()
highlightTexture:SetTexCoord(0, 0.625, 0, 0.6875)  -- Crop the texture
highlightTexture:SetVertexColor(0, 0, 0)  -- Lighter green for hover

-- Set the pushed (clicked) texture
cleanButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
local pushedTexture = cleanButton:GetPushedTexture()
pushedTexture:SetTexCoord(0, 0.625, 0, 0.6875)  -- Crop the texture
pushedTexture:SetVertexColor(0.15, .5, 0.25)  -- Darker green for clicked

-- Set the disabled texture if needed (optional)
cleanButton:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")

-- Change the button text color to white for better readability
cleanButton:SetText("Clean Memory")
cleanButton:GetFontString():SetTextColor(0.3, 1, 0.5)  -- Green color

-- Set the font size (optional, adjust as needed)
cleanButton:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")

-- Set the button's click behavior
cleanButton:SetScript("OnClick", function()
    CleanMemory()  -- Call the CleanMemory function when clicked
end)

-- Add tooltip functionality
cleanButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("This helps reduce lag and improve performance.", nil, nil, nil, nil, true)
    GameTooltip:Show()
end)

cleanButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- Create a reload button
local reloadButton = CreateFrame("Button", nil, addonMemoryFrame, "UIPanelButtonTemplate")
reloadButton:SetPoint("TOPRIGHT", -5, -5)
reloadButton:SetSize(60, 30)
reloadButton:SetText("Reload")

-- Set the button textures for a dark theme
reloadButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
local normalTexture = reloadButton:GetNormalTexture()
normalTexture:SetTexCoord(0, 0.625, 0, 0.6875)  -- Crop the texture
normalTexture:SetVertexColor(0.2, 0.2, 0.2)  -- Dark gray for normal state

reloadButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
local highlightTexture = reloadButton:GetHighlightTexture()
highlightTexture:SetTexCoord(0, 0.625, 0, 0.6875)  -- Crop the texture
highlightTexture:SetVertexColor(0.4, 0.4, 0.4)  -- Lighter gray for hover

reloadButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
local pushedTexture = reloadButton:GetPushedTexture()
pushedTexture:SetTexCoord(0, 0.625, 0, 0.6875)  -- Crop the texture
pushedTexture:SetVertexColor(0.1, 0.1, 0.1)  -- Darker gray for clicked

-- Change the button text color to white for better visibility on dark background
reloadButton:GetFontString():SetTextColor(1, 1, 1)  -- White color text
reloadButton:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")  -- Font settings

-- Set the button's click behavior
reloadButton:SetScript("OnClick", function()
    ReloadUI()  -- Reload the interface when the button is clicked
end)

-- Create interface options panel
local optionsPanel = CreateFrame("Frame", "AMUOptionsPanel", UIParent, "BackdropTemplate")
optionsPanel.name = "Addon Memory Usage"  -- Ensure the name matches what you expect to see in the options
optionsPanel:SetSize(350, 400)  -- Adjusted height for contents
optionsPanel:SetPoint("CENTER")
optionsPanel:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",  -- Background texture
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",  -- Border texture
    tile = true, tileSize = 16, edgeSize = 10,  -- Larger edge size for thick border
    insets = { left = -2, right = -2, top = -2, bottom = -2 }  -- Negative insets for outer extension
})
optionsPanel:SetBackdropColor(0, 0, 0, 0.8)  -- Black background with transparency
optionsPanel:SetBackdropBorderColor(0, 0, 0)  -- Black border
optionsPanel:SetMovable(true)
optionsPanel:EnableMouse(true)
optionsPanel:RegisterForDrag("LeftButton")
optionsPanel:SetScript("OnDragStart", optionsPanel.StartMoving)
optionsPanel:SetScript("OnDragStop", optionsPanel.StopMovingOrSizing)
optionsPanel:Hide()

local title = optionsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -10)
title:SetText("AMU Settings")
title:SetTextColor(1, 0.5, 0.5) -- Color of title: light red

-- Create scale slider
local scaleSlider = CreateFrame("Slider", "AMUScaleSlider", optionsPanel, "OptionsSliderTemplate")
scaleSlider:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -100, -40)
scaleSlider:SetMinMaxValues(0.5, 2)
scaleSlider:SetValueStep(0.1)
scaleSlider:SetValue(AMU_Settings.scale)
scaleSlider:SetWidth(200)
scaleSlider:SetScript("OnValueChanged", function(self, value)
    AMU_Settings.scale = value
    ApplySettings()
end)
_G[scaleSlider:GetName() .. 'Low']:SetText('0')
_G[scaleSlider:GetName() .. 'High']:SetText('100')
_G[scaleSlider:GetName() .. 'Text']:SetText('Scale')

-- Create text alpha slider
local textAlphaSlider = CreateFrame("Slider", "AMUTextAlphaSlider", optionsPanel, "OptionsSliderTemplate")
textAlphaSlider:SetPoint("TOPLEFT", scaleSlider, "BOTTOMLEFT", 0, -40)
textAlphaSlider:SetMinMaxValues(0.1, 1)
textAlphaSlider:SetValueStep(0.1)
textAlphaSlider:SetValue(AMU_Settings.textAlpha or 1)
textAlphaSlider:SetWidth(200)
textAlphaSlider:SetScript("OnValueChanged", function(self, value)
    AMU_Settings.textAlpha = value
    ApplySettings()
end)
_G[textAlphaSlider:GetName() .. 'Low']:SetText('0')
_G[textAlphaSlider:GetName() .. 'High']:SetText('100')
_G[textAlphaSlider:GetName() .. 'Text']:SetText('Text Alpha')

-- Create a checkbox for frame border visibility
local function CreateCheckbox(name, label, settingKey, yOffset)
    local checkbox = CreateFrame("CheckButton", name, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", textAlphaSlider, "BOTTOMLEFT", 0, yOffset)
    checkbox.Text:SetText(label)
    checkbox.Text:SetTextColor(1, 1, 0)
    checkbox:SetChecked(AMU_Settings[settingKey])
    checkbox:SetScript("OnClick", function(self)
    AMU_Settings[settingKey] = self:GetChecked() 
        if AMU_Settings[settingKey] then
                checkbox.Text:SetTextColor(1, 1, 0) 
            elseif AMU_Settings[settingKey] == false then
                checkbox.Text:SetTextColor(.5, .5, .5) -- sets the text color to grey if unchecked
        end
        ApplySettings()
    end)
    return checkbox
end
local frameBorderCheckbox = CreateCheckbox("AMUFrameBorderCheckbox", "Show Frame Border", "showBackground", -40)
local fpsCheckbox = CreateCheckbox("AMUFPSCheckbox", "Show FPS", "showFPS", -70)
local homeLatencyCheckbox = CreateCheckbox("AMUHomeLatencyCheckbox", "Show Home Latency", "showHomeLatency", -100)
local worldLatencyCheckbox = CreateCheckbox("AMUWorldLatencyCheckbox", "Show World Latency", "showWorldLatency", -130)
local memoryUsageCheckbox = CreateCheckbox("AMUMemoryUsageCheckbox", "Show Memory Usage", "showMemoryUsage", -160)
local mainFrameCheckbox = CreateCheckbox("AMUMainFrameCheckbox", "Show Main Frame", "showMainFrame", -190)
local layoutCheckbox = CreateCheckbox("AMULayoutCheckbox", "Change Layout", "horizontalLayout", -220)

-- Apply settings on load
ApplySettings()

-- Create a texture to act as a button to open/close the settings panel
local settingsButton = addonMemoryFrame:CreateTexture(nil, "OVERLAY")
settingsButton:SetPoint("TOPLEFT", 5, -5)
settingsButton:SetSize(35, 30)
settingsButton:SetTexture("Interface\\AddOns\\AMU\\settings.png")

-- Make the texture interactive
settingsButton:EnableMouse(true)
settingsButton:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" then
        if optionsPanel:IsVisible() then
            optionsPanel:Hide()
        else
            optionsPanel:Show()
        end
    end
end)

-- Create a close button for the settings panel
local closeButton = CreateFrame("Button", nil, optionsPanel)
closeButton:SetPoint("TOPRIGHT", -5, -5)
closeButton:SetSize(20, 20)  -- Adjust size as needed
closeButton:SetNormalTexture("Interface\\AddOns\\AMU\\close.png")
closeButton:SetHighlightTexture("Interface\\AddOns\\AMU\\close.png")
closeButton:SetPushedTexture("Interface\\AddOns\\AMU\\close.png")
closeButton:SetScript("OnClick", function()
    optionsPanel:Hide()
end)

-- Function to initialize settings with default values
local function InitializeSettings()
    if not AMU_Settings then
        AMU_Settings = {}
    end
    AMU_Settings.scale = AMU_Settings.scale or 1
    AMU_Settings.alpha = AMU_Settings.alpha or 0.7
    AMU_Settings.textAlpha = AMU_Settings.textAlpha or 1
    AMU_Settings.showFPS = AMU_Settings.showFPS ~= false  -- Default to true if nil
    AMU_Settings.showHomeLatency = AMU_Settings.showHomeLatency ~= false  -- Default to true if nil
    AMU_Settings.showWorldLatency = AMU_Settings.showWorldLatency ~= false  -- Default to true if nil
    AMU_Settings.showMemoryUsage = AMU_Settings.showMemoryUsage ~= false  -- Default to true if nil
end

-- Ensure settings are initialized
InitializeSettings()

-- Function to apply settings
local function ApplySettings()
    frame:SetScale(AMU_Settings.scale)
    frame:SetBackdrop({
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",  -- Border texture
        tile = true, tileSize = 16, edgeSize = 10,  -- Larger edge size for thick border
        insets = { left = -6, right = -6, top = -6, bottom = -6 }  -- Negative insets for outer extension
    })
    frame:SetBackdropColor(0, 0, 0, AMU_Settings.showBackground and AMU_Settings.alpha or 0)  -- Toggle backdrop visibility
    frame:SetBackdropBorderColor(0, 0, 0, AMU_Settings.showBackground and 1 or 0)
    
    local textAlpha = AMU_Settings.textAlpha or 1
    fpsLabel:SetAlpha(textAlpha)
    fpsValue:SetAlpha(textAlpha)
    latencyHomeLabel:SetAlpha(textAlpha)
    latencyHomeValue:SetAlpha(textAlpha)
    latencyWorldLabel:SetAlpha(textAlpha)
    latencyWorldValue:SetAlpha(textAlpha)
    memoryUsageLabel:SetAlpha(textAlpha)
    memoryUsageValue:SetAlpha(textAlpha)
    
    -- Adjust visibility and position of elements
    local yOffset = -10
    if AMU_Settings.showHomeLatency then
        latencyHomeLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, yOffset)
        latencyHomeLabel:Show()
        latencyHomeValue:SetPoint("LEFT", latencyHomeLabel, "RIGHT", 5, 0)
        latencyHomeValue:Show()
        yOffset = yOffset - 20
    else
        latencyHomeLabel:Hide()
        latencyHomeValue:Hide()
    end

    if AMU_Settings.showWorldLatency then
        latencyWorldLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, yOffset)
        latencyWorldLabel:Show()
        latencyWorldValue:SetPoint("LEFT", latencyWorldLabel, "RIGHT", 5, 0)
        latencyWorldValue:Show()
        yOffset = yOffset - 20
    else
        latencyWorldLabel:Hide()
        latencyWorldValue:Hide()
    end

    if AMU_Settings.showMemoryUsage then
        memoryUsageLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, yOffset)
        memoryUsageLabel:Show()
        memoryUsageValue:SetPoint("LEFT", memoryUsageLabel, "RIGHT", 5, 0)
        memoryUsageValue:Show()
        yOffset = yOffset - 20
    else
        memoryUsageLabel:Hide()
        memoryUsageValue:Hide()
    end

    if AMU_Settings.showFPS then
        fpsLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, yOffset)
        fpsLabel:Show()
        fpsValue:SetPoint("LEFT", fpsLabel, "RIGHT", 5, 0)
        fpsValue:Show()
        yOffset = yOffset - 20
    else
        fpsLabel:Hide()
        fpsValue:Hide()
    end

    -- Adjust frame height based on visible elements
    local height = -yOffset + 10  -- Base height plus padding
    frame:SetHeight(height)
    
    -- Hide frame if all checkboxes are unchecked
    if not (AMU_Settings.showFPS or AMU_Settings.showHomeLatency or AMU_Settings.showWorldLatency or AMU_Settings.showMemoryUsage) then
        frame:Hide()
    else
        frame:Show()
    end

    -- Show or hide the main frame based on the setting
    if AMU_Settings.showMainFrame then
        frame:Show()
    else
        frame:Hide()
    end

    -- Adjust layout based on the setting
    if AMU_Settings.horizontalLayout then
        latencyHomeLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
        latencyHomeValue:SetPoint("LEFT", latencyHomeLabel, "RIGHT", 5, 0)
        
        latencyWorldLabel:SetPoint("TOPLEFT", latencyHomeLabel, "BOTTOMLEFT", 0, -10)
        latencyWorldValue:SetPoint("LEFT", latencyWorldLabel, "RIGHT", 5, 0)

        memoryUsageLabel:SetPoint("TOPLEFT", latencyWorldLabel, "BOTTOMLEFT", 0, -10)
        memoryUsageValue:SetPoint("LEFT", memoryUsageLabel, "RIGHT", 5, 0)
        fpsLabel:SetPoint("TOPLEFT", memoryUsageLabel, "BOTTOMLEFT", 0, -10)
        fpsValue:SetPoint("LEFT", fpsLabel, "RIGHT", 5, 0)
    else
        latencyHomeLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
        latencyHomeValue:SetPoint("LEFT", latencyHomeLabel, "RIGHT", 5, 0)

        latencyWorldLabel:SetPoint("LEFT", latencyHomeValue, "RIGHT", 20, 0)
        latencyWorldValue:SetPoint("LEFT", latencyWorldLabel, "RIGHT", 5, 0)

        memoryUsageLabel:SetPoint("LEFT", latencyWorldValue, "RIGHT", 20, 0)
        memoryUsageValue:SetPoint("LEFT", memoryUsageLabel, "RIGHT", 5, 0)

        fpsLabel:SetPoint("LEFT", memoryUsageValue, "RIGHT", 20, 0)
        fpsValue:SetPoint("LEFT", fpsLabel, "RIGHT", 5, 0)
    end

    -- Adjust frame width based on layout
    if AMU_Settings.horizontalLayout then
        frame:SetWidth(170)  -- Default width for horizontal layout
    else
        frame:SetWidth(500)  -- Increased width for vertical layout
    end
end

-- Flag to track if addon memory list was updated
local isAddonMemoryListUpdated = false

-- Toggle the addon memory frame
local function ToggleAddonMemoryFrame()
    if addonMemoryFrame:IsVisible() then
        addonMemoryFrame:Hide()
    else
        if not isAddonMemoryListUpdated then  -- Only update if it hasn't been done yet
            UpdateAddonMemoryList()  -- Refresh the list when showing
            isAddonMemoryListUpdated = true  -- Mark it as updated
        end

        -- Count loaded addons that are using memory
        local loadedAddonsCount = 0
        local numAddOns = GetNumAddOns()
        for i = 1, numAddOns do
            if IsAddOnLoaded(i) then
                loadedAddonsCount = loadedAddonsCount + 1
            end
        end

        -- Display loaded addons out of total addons
        totalAddonsValue:SetText(string.format("%d out of %d", loadedAddonsCount, numAddOns)) -- e.g. "56/100"
        addonMemoryFrame:Show()
    end
end



-- Register the right-click menu
addonMemoryFrame:SetScript("OnMouseDown", function(self, button)
    if button == "RightButton" then
        self:Hide() -- Close the addon memory frame on right click
    end
end)

-- Register the right-click menu for the main frame
frame:SetScript("OnMouseDown", function(self, button)
    if button == "RightButton" then
        ToggleAddonMemoryFrame()  -- Show or hide the addon memory frame
    end
end)

-- Function to update stats
local function UpdateStats()
    local homeMS = select(3, GetNetStats())
    local worldMS = select(4, GetNetStats())
    local memoryUsage = 0
    local numAddOns = GetNumAddOns()

    for i = 1, numAddOns do
        memoryUsage = memoryUsage + GetAddOnMemoryUsage(i)
    end
    local fps = floor(GetFramerate())

    -- Update text labels
    latencyHomeValue:SetText(homeMS .. " |cff808080ms|r")
    if homeMS <= 70 then
        latencyHomeValue:SetTextColor(0, 1, 0) -- Green
    elseif homeMS <= 140 then
        latencyHomeValue:SetTextColor(1, 1, 0) -- Yellow
    else
        latencyHomeValue:SetTextColor(1, 0, 0) -- Red
    end

    latencyWorldValue:SetText(worldMS .. " |cff808080ms|r")
    if worldMS <= 70 then
        latencyWorldValue:SetTextColor(0, 1, 0) -- Green
    elseif worldMS <= 140 then
        latencyWorldValue:SetTextColor(1, 1, 0) -- Yellow
    else
        latencyWorldValue:SetTextColor(1, 0, 0) -- Red
    end

    -- Update memory usage value
    local roundedMemoryUsage = math.ceil(memoryUsage / 1024)
    memoryUsageValue:SetText(string.format("%d |cff808080mb|r", roundedMemoryUsage))
    if roundedMemoryUsage <= 350 then
        memoryUsageValue:SetTextColor(0, 1, 0) -- Green
    elseif roundedMemoryUsage <= 500 then
        memoryUsageValue:SetTextColor(1, 1, 0) -- Yellow
    else
        memoryUsageValue:SetTextColor(1, 0, 0) -- Red
    end

    fpsValue:SetText(math.floor(fps))
    if fps >= 60 then
        fpsValue:SetTextColor(0, 1, 0) -- Green
    elseif fps >= 40 then
        fpsValue:SetTextColor(1, 1, 0) -- Yellow
    else
        fpsValue:SetTextColor(1, 0, 0) -- Red
    end
end

-- Set the update interval
frame:SetScript("OnUpdate", function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed >= 1 then
        UpdateStats()
        self.elapsed = 0
    end
end)

-- Function to open the options panel
local function OpenOptionsPanel()
    if not optionsPanel:IsVisible() then
        optionsPanel:Show()
    end
end

-- Create a slash command to open the options panel
SLASH_AMUOPTIONS1 = "/AMU Opt"
SlashCmdList["AMUOPT"] = OpenOptionsPanel

-- Create a slash command to toggle the addon memory frame
SLASH_MYADDON1 = "/AMU"
SlashCmdList["MYADDON"] = ToggleAddonMemoryFrame

-- Function to update checkbox and slider states from saved variables
local function UpdateSettingsStates()
    if frameBorderCheckbox and fpsCheckbox and homeLatencyCheckbox and worldLatencyCheckbox and memoryUsageCheckbox and mainFrameCheckbox and layoutCheckbox then
        frameBorderCheckbox:SetChecked(AMU_Settings.showBackground)
        fpsCheckbox:SetChecked(AMU_Settings.showFPS)
        homeLatencyCheckbox:SetChecked(AMU_Settings.showHomeLatency)
        worldLatencyCheckbox:SetChecked(AMU_Settings.showWorldLatency)
        memoryUsageCheckbox:SetChecked(AMU_Settings.showMemoryUsage)
        mainFrameCheckbox:SetChecked(AMU_Settings.showMainFrame)
        layoutCheckbox:SetChecked(AMU_Settings.horizontalLayout)
        
        -- Set text color based on checkbox state
        frameBorderCheckbox.Text:SetTextColor(AMU_Settings.showBackground and 1 or 0.5, AMU_Settings.showBackground and 1 or 0.5, AMU_Settings.showBackground and 0 or 0.5)
        fpsCheckbox.Text:SetTextColor(AMU_Settings.showFPS and 1 or 0.5, AMU_Settings.showFPS and 1 or 0.5, AMU_Settings.showFPS and 0 or 0.5)
        homeLatencyCheckbox.Text:SetTextColor(AMU_Settings.showHomeLatency and 1 or 0.5, AMU_Settings.showHomeLatency and 1 or 0.5, AMU_Settings.showHomeLatency and 0 or 0.5)
        worldLatencyCheckbox.Text:SetTextColor(AMU_Settings.showWorldLatency and 1 or 0.5, AMU_Settings.showWorldLatency and 1 or 0.5, AMU_Settings.showWorldLatency and 0 or 0.5)
        layoutCheckbox .Text:SetTextColor(AMU_Settings.horizontalLayout and 1 or 0.5, AMU_Settings.horizontalLayout and 1 or 0.5, AMU_Settings.horizontalLayout and 0 or 0.5)
        
    end
    if scaleSlider and textAlphaSlider then
        scaleSlider:SetValue(AMU_Settings.scale)
        textAlphaSlider:SetValue(AMU_Settings.textAlpha)
    end
end

AMUOptionsPanel:SetScript("OnShow", UpdateSettingsStates)

-- Save the checkbox states when the player logs out
local function AMU_Settings()
    frameBorderCheckbox:GetChecked(AMU_Settings.showBackground)
    fpsCheckbox:GetChecked(AMU_Settings.showFPS)
    homeLatencyCheckbox:GetChecked(AMU_Settings.showHomeLatency)
    worldLatencyCheckbox:GetChecked(AMU_Settings.showWorldLatency)
    memoryUsageCheckbox:GetChecked(AMU_Settings.showMemoryUsage)
    mainFrameCheckbox:GetChecked(AMU_Settings.showMainFrame)
    layoutCheckbox:GetChecked(AMU_Settings.horizontalLayout)
    scaleSlider:SetValue(AMU_Settings.scale)
    textAlphaSlider:SetValue(AMU_Settings.textAlpha)
end

-- Event handler for loading and saving variables
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGOUT")

eventFrame:SetScript("OnEvent", function(self, event, addon)
    if event == "ADDON_LOADED" then
        if addon == "AMU" then
            -- Ensure the UpdateCheckboxStates function exists before calling it
            if UpdateSettingsStates then
                UpdateSettingsStates()  -- Load checkbox states on addon load
            else
                print("Warning: UpdateSettingsStates function not found.")
            end
        end
    elseif event == "PLAYER_LOGOUT" then
        -- Ensure the MyCords_SaveVariables function exists before calling it
        if AMU_Settings then
            AMU_Settings()  -- Save checkbox states on logout
        else
            print("Warning: AMU_Settings function not found.")
        end
    end
end)
