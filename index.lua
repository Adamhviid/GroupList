local button = CreateFrame("Button", "MyButton", Minimap)
button:SetSize(30, 30)
button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
button:SetPoint("TOPLEFT", Minimap, "TOPLEFT")

local linkFrame = CreateFrame("Frame", "LinkFrame", UIParent, "BasicFrameTemplateWithInset")
linkFrame.title = linkFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
linkFrame.title:SetPoint("CENTER", linkFrame.TitleBg, "CENTER", 5, 0)
linkFrame.title:SetText("Warcraft Group Logs")
linkFrame:SetSize(535, 140)
linkFrame:SetPoint("CENTER")
linkFrame:Hide()

table.insert(UISpecialFrames, "LinkFrame")

local linkText = linkFrame:CreateFontString(nil, "OVERLAY")
linkText:SetFontObject("GameFontHighlight")
linkText:SetPoint("CENTER", linkFrame, "CENTER")
linkText:SetText("")

local linkEditBox = CreateFrame("EditBox", nil, linkFrame, "InputBoxTemplate")
linkEditBox:SetSize(450, 30)
linkEditBox:SetPoint("CENTER", linkFrame, "CENTER")
linkEditBox:SetAutoFocus(false)
linkEditBox:SetScript("OnEscapePressed", linkEditBox.ClearFocus)

local copiedText = linkFrame:CreateFontString(nil, "OVERLAY")
copiedText:SetFontObject("GameFontHighlight")
copiedText:SetPoint("TOP", linkEditBox, "BOTTOM", 0, 0)
copiedText:SetText("")
copiedText:Hide()

linkEditBox:SetScript("OnMouseDown", function()
    local link = linkEditBox:GetText()
    if link and link ~= "" then
        linkEditBox:HighlightText()
        copiedText:SetText("Press Ctrl+C to copy the link.")
        copiedText:Show()
        C_Timer.After(4, function()
            copiedText:Hide()
        end)
    end
end)

local descriptionText = linkFrame:CreateFontString(nil, "OVERLAY")
descriptionText:SetFontObject("GameFontHighlight")
descriptionText:SetPoint("BOTTOM", linkEditBox, "TOP", 0, 10) -- position it above the linkEditBox
descriptionText:SetText("Copy the link and paste it into your browser to get a quick view of your groups logs.")

local function printMembers()
    local members = {}

    if IsInRaid() then
        for i = 1, GetNumGroupMembers() do
            local name = GetRaidRosterInfo(i)
            if name and type(name) == "string" then
                table.insert(members, name)
            end
        end
    elseif IsInGroup() then
        for i = 1, GetNumSubgroupMembers() do
            local name = UnitName("party" .. i)
            if name and type(name) == "string" then
                table.insert(members, name)
            end
        end

        local playerName = UnitName("player")
        if playerName and type(playerName) == "string" then
            table.insert(members, playerName)
        end
    end

    local realm = GetRealmName()
    realm = realm:gsub(" ", "-")
    local region = ({"US", "KR", "EU", "TW", "CN"})[GetCurrentRegion()]

    local url = "https://warcraftgrouplogs.onrender.com/?server=" .. realm .. "&region=" .. region ..
                    "&zone=2008&characters=" .. table.concat(members, ",")

    linkEditBox:SetText(url)
    linkFrame:Show()
    linkEditBox:HighlightText()
end

button:SetScript("OnClick", printMembers)
