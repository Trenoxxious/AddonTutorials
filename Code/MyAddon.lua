if not MyAddonDB then
    MyAddonDB = {}
end

MyAddon = MyAddon or {}

local mainFrame = CreateFrame("Frame", "MyAddonMainFrame", UIParent, "BasicFrameTemplateWithInset")
mainFrame:SetSize(500, 350)
mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
mainFrame.TitleBg:SetHeight(30)
mainFrame.title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
mainFrame.title:SetPoint("TOPLEFT", mainFrame.TitleBg, "TOPLEFT", 5, -3)
mainFrame.title:SetText("MyAddon")
mainFrame:Hide()
mainFrame:EnableMouse(true)
mainFrame:SetMovable(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", function(self)
	self:StartMoving()
end)

mainFrame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
end)

mainFrame:SetScript("OnHide", function()
        PlaySound(808)
end)

mainFrame.playerName = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.playerName:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 15, -35)
mainFrame.playerName:SetText("Character: " .. UnitName("player") .. " (Level " .. UnitLevel("player") .. ")")
mainFrame.totalPlayerKills = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.totalPlayerKills:SetPoint("TOPLEFT", mainFrame.playerName, "BOTTOMLEFT", 0, -10)
mainFrame.totalPlayerKills:SetText("Total Kills: " .. (MyAddonDB.kills or "0"))
mainFrame.totalCurrency = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.totalCurrency:SetPoint("TOPLEFT", mainFrame.totalPlayerKills, "BOTTOMLEFT", 0, -10)
mainFrame.totalCurrency:SetText("Total Currency Collected:")
mainFrame.currencyGold = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.currencyGold:SetPoint("TOPLEFT", mainFrame.totalCurrency, "BOTTOMLEFT", 10, -15)
mainFrame.currencyGold:SetText("|cFFFFD700Gold: |cFFFFFFFF" .. (MyAddonDB.gold or "0"))
mainFrame.currencySilver = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.currencySilver:SetPoint("TOPLEFT", mainFrame.currencyGold, "BOTTOMLEFT", 0, -15)
mainFrame.currencySilver:SetText("|cFFc0c2c0Silver: |cFFFFFFFF" .. (MyAddonDB.silver or "0"))
mainFrame.currencyCopper = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.currencyCopper:SetPoint("TOPLEFT", mainFrame.currencySilver, "BOTTOMLEFT", 0, -15)
mainFrame.currencyCopper:SetText("|cFFe86e2cCopper: |cFFFFFFFF" .. (MyAddonDB.copper or "0"))

mainFrame:SetScript("OnShow", function()
    PlaySound(808)
    mainFrame.totalPlayerKills:SetText("Total Kills: " .. (MyAddonDB.kills or "0"))
    mainFrame.currencyGold:SetText("|cFFFFD700Gold: |cFFFFFFFF" .. (MyAddonDB.gold or "0"))
    mainFrame.currencySilver:SetText("|cFFc0c2c0Silver: |cFFFFFFFF" .. (MyAddonDB.silver or "0"))
    mainFrame.currencyCopper:SetText("|cFFe86e2cCopper: |cFFFFFFFF" .. (MyAddonDB.copper or "0"))
end)

SLASH_MYADDON1 = "/myaddon"
SlashCmdList["MYADDON"] = function()
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        mainFrame:Show()
    end
end

table.insert(UISpecialFrames, "MyAddonMainFrame")

local eventListenerFrame = CreateFrame("Frame", "MyAddonEventListenerFrame", UIParent)

local function eventHandler(self, event, ...)
    local _, eventType = CombatLogGetCurrentEventInfo()

    if event == "COMBAT_LOG_EVENT_UNFILTERED" and MyAddonDB.settingsKeys.enableKillTracking then
        if eventType and eventType == "PARTY_KILL" then
            if not MyAddonDB.kills then
                MyAddonDB.kills = 1
            else
                MyAddonDB.kills = MyAddonDB.kills + 1
            end
        end

        if MyAddonDB.kills and MyAddonDB.kills % 250 == 0 and MyAddonDB.kills ~= 0 and MyAddonDB.settingsKeys.enableMilestoneMessages then
            print("|cFF00FF00Kill Milestone! |cFFFFFFFFYou have killed a total of " .. MyAddonDB.kills .. " enemies! You have looted a total of " .. MyAddonDB.gold .. " gold!|r|r")
        end
    elseif event == "CHAT_MSG_MONEY" then
        local msg = ...
        local gold = tonumber(string.match(msg, "(%d+) Gold")) or 0
        local silver = tonumber(string.match(msg, "(%d+) Silver")) or 0
        local copper = tonumber(string.match(msg, "(%d+) Copper")) or 0

        MyAddonDB.gold = (MyAddonDB.gold or 0) + gold
        MyAddonDB.silver = (MyAddonDB.silver or 0) + silver
        MyAddonDB.copper = (MyAddonDB.copper or 0) + copper

        if MyAddonDB.copper >= 100 then
            MyAddonDB.silver = MyAddonDB.silver + math.floor(MyAddonDB.copper / 100)
            MyAddonDB.copper = MyAddonDB.copper % 100
        end
          
        if MyAddonDB.silver >= 100 then
            MyAddonDB.gold = MyAddonDB.gold + math.floor(MyAddonDB.silver / 100)
            MyAddonDB.silver = MyAddonDB.silver % 100
        end
    end

    if mainFrame:IsShown() then
        mainFrame.totalPlayerKills:SetText("Total Kills: " .. (MyAddonDB.kills or "0"))
        mainFrame.currencyGold:SetText("|cFFFFD700Gold: |cFFFFFFFF" .. (MyAddonDB.gold or "0"))
        mainFrame.currencySilver:SetText("|cFFc0c2c0Silver: |cFFFFFFFF" .. (MyAddonDB.silver or "0"))
        mainFrame.currencyCopper:SetText("|cFFe86e2cCopper: |cFFFFFFFF" .. (MyAddonDB.copper or "0"))
    end
end

eventListenerFrame:SetScript("OnEvent", eventHandler)
eventListenerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventListenerFrame:RegisterEvent("CHAT_MSG_MONEY")

function MyAddon:ToggleMainFrame()
    if not mainFrame:IsShown() then
        mainFrame:Show()
    else
        mainFrame:Hide()
    end
end