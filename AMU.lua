-- Variable to track if the message has already been printed
local messagePrinted = false

-- This function runs when the player logs in
local function OnPlayerLogin()
    -- Check if the message has already been printed
    if not messagePrinted then
        -- Constructing the welcome message with colored text
        local message = string.format(
            "|cFF000000Addon Memory Usage|r |cFF808080by|r |cFFFFFFFFThatdruid|r"
        )
        -- Print the message
        print(message)

        -- Mark the message as printed
        messagePrinted = true
    end
end

-- Register the event
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin()
        self:UnregisterEvent("PLAYER_LOGIN")  -- Unregister to prevent multiple prints
    end
end)

-- Create the main frame
local frame = CreateFrame("Frame", "MyStatsFrame", UIParent, "BackdropTemplate")
frame:SetPoint("CENTER")
frame:SetSize(170, 100)  -- Frame size
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

-- Set backdrop with extended black border
frame:SetBackdrop({

    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",  -- Border texture
    tile = true, tileSize = 16, edgeSize = 10,  -- Larger edge size for thick border
    insets = { left = -6, right = -6, top = -6, bottom = -6 }  -- Negative insets for outer extension
})
-- Set backdrop colors
frame:SetBackdropColor(0, 0, 0, 0.7)  -- Black background with transparency
frame:SetBackdropBorderColor(0, 0, 0)  -- Black border

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

-- Create text labels with white color
local latencyHomeLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
latencyHomeLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
latencyHomeLabel:SetTextColor(1, 1, 1)
latencyHomeLabel:SetText("Home Latency:")

local latencyHomeValue = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
latencyHomeValue:SetPoint("LEFT", latencyHomeLabel, "RIGHT", 5, 0)

local latencyWorldLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
latencyWorldLabel:SetPoint("TOPLEFT", latencyHomeLabel, "BOTTOMLEFT", 0, -10)
latencyWorldLabel:SetText("World Latency:")
latencyWorldLabel:SetTextColor(1, 1, 1)

local latencyWorldValue = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
latencyWorldValue:SetPoint("LEFT", latencyWorldLabel, "RIGHT", 5, 0)

local memoryUsageLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
memoryUsageLabel:SetPoint("TOPLEFT", latencyWorldLabel, "BOTTOMLEFT", 0, -10)
memoryUsageLabel:SetText("Mem. Usage:")
memoryUsageLabel:SetTextColor(1, 1, 1)

local memoryUsageValue = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
memoryUsageValue:SetPoint("LEFT", memoryUsageLabel, "RIGHT", 5, 0)

local fpsLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fpsLabel:SetPoint("TOPLEFT", memoryUsageLabel, "BOTTOMLEFT", 0, -10)
fpsLabel:SetText("FPS:")
fpsLabel:SetTextColor(1, 1, 1)

local fpsValue = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fpsValue:SetPoint("LEFT", fpsLabel, "RIGHT", 5, 0)

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
        memoryText = string.format("|cff00FFFF%d B|r", math.ceil(collected * 1024))  -- Bytes in cyan
    elseif collected < 1000 then
        memoryText = string.format("|cff00FF00%d KB|r", math.ceil(collected))  -- Kilobytes in green
    else
        memoryText = string.format("|cffFFD700%d MB|r", math.ceil(collected / 1024))  -- Megabytes in yellow
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

    local yOffset = 0
    local numAddOns = GetNumAddOns()
    for i = 1, numAddOns do
        if IsAddOnLoaded(i) then  -- Only show loaded addons
            local name = GetAddOnInfo(i)
            local memUsage = GetAddOnMemoryUsage(i)
            local memText
            local memColor

            -- Display memory usage based on its value
            if memUsage < 1 then
                memText = string.format("%d B", math.ceil(memUsage * 1024)) -- Always show bytes if < 1KB
                memColor = {0, 1, 1} -- Cyan for Bytes
            elseif memUsage < 1000 then
                memText = string.format("%d KB", math.ceil(memUsage)) -- Green KB
                memColor = {0, 1, 0} -- Green for KB
            else
                memText = string.format("%d MB", math.ceil(memUsage / 1024)) -- Yellow MB
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
    latencyHomeValue:SetText(homeMS .. " ms")
    if homeMS <= 70 then
        latencyHomeValue:SetTextColor(0, 1, 0) -- Green
    elseif homeMS <= 140 then
        latencyHomeValue:SetTextColor(1, 1, 0) -- Yellow
    else
        latencyHomeValue:SetTextColor(1, 0, 0) -- Red
    end

    latencyWorldValue:SetText(worldMS .. " ms")
    if worldMS <= 70 then
        latencyWorldValue:SetTextColor(0, 1, 0) -- Green
    elseif worldMS <= 140 then
        latencyWorldValue:SetTextColor(1, 1, 0) -- Yellow
    else
        latencyWorldValue:SetTextColor(1, 0, 0) -- Red
    end

    -- Update memory usage value
    local roundedMemoryUsage = math.ceil(memoryUsage / 1024)
    memoryUsageValue:SetText(string.format("%d MB", roundedMemoryUsage))
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

-- Create a slash command to toggle the addon memory frame
SLASH_MYADDON1 = "/AMU"
SlashCmdList["AMU"] = ToggleAddonMemoryFrame
