local checkboxes = 0
local version = "v1.0.0"

local settings = {
    {
        settingText = "Enable tracking of Kills",
        settingKey = "enableKillTracking",
        settingTooltip = "While enabled, your kills will be tracked.",
    },
    {
        settingText = "Enable tracking of Currency",
        settingKey = "enableCurrencyTracking",
        settingTooltip = "While enabled, your currency gained will be tracked.",
    },
    {
        settingText = "Enable Milestone Messages",
        settingKey = "enableMilestoneMessages",
        settingTooltip = "While enabled, you will receive milestone message updates.",
    },
}

local settingsFrame = CreateFrame("Frame", "MyAddonSettingsFrame", UIParent, "BasicFrameTemplateWithInset")
settingsFrame:SetSize(400, 300)
settingsFrame:SetPoint("CENTER")
settingsFrame:Hide()
settingsFrame.TitleBg:SetHeight(30)
settingsFrame.title = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
settingsFrame.title:SetPoint("TOP", settingsFrame.TitleBg, "TOP", 0, -3)
settingsFrame.title:SetText("MyAddon Settings")
settingsFrame:EnableMouse(true)
settingsFrame:SetMovable(true)
settingsFrame:RegisterForDrag("LeftButton")
settingsFrame:SetScript("OnDragStart", function(self)
	self:StartMoving()
end)

settingsFrame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
end)

local function CreateCheckbox(checkboxText, key, checkboxTooltip)
    local checkbox = CreateFrame("CheckButton", "MyAddonCheckboxID" .. checkboxes, settingsFrame, "UICheckButtonTemplate")
    checkbox.Text:SetText(checkboxText)
    checkbox:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -30 + (checkboxes * -30))

    if MyAddonDB.settingsKeys[key] == nil then
        MyAddonDB.settingsKeys[key] = true
    end

    checkbox:SetChecked(MyAddonDB.settingsKeys[key])

    checkbox:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(checkboxTooltip, nil, nil, nil, nil, true)
    end)

    checkbox:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    checkbox:SetScript("OnClick", function(self)
        MyAddonDB.settingsKeys[key] = self:GetChecked()
    end)

    checkboxes = checkboxes + 1

    return checkbox
end

local eventListenerFrame = CreateFrame("Frame", "MyAddonSettingsEventListenerFrame", UIParent)

eventListenerFrame:RegisterEvent("PLAYER_LOGIN")

eventListenerFrame:SetScript("OnEvent", function(self, event)
  if event == "PLAYER_LOGIN" then
    print("MyAddon " .. version .. " successfully loaded!")

    if not MyAddonDB.settingsKeys then
        MyAddonDB.settingsKeys = {}
    end

    for _, setting in pairs(settings) do
        CreateCheckbox(setting.settingText, setting.settingKey, setting.settingTooltip)
    end
  end
end)

local addon = LibStub("AceAddon-3.0"):NewAddon("MyAddon")
MyAddonMinimapButton = LibStub("LibDBIcon-1.0", true)

local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject("MyAddon", {
	type = "data source",
	text = "MyAddon",
	icon = "Interface\\AddOns\\MyAddon\\images\\minimap.tga",
	OnClick = function(self, btn)
        if btn == "LeftButton" then
		    MyAddon:ToggleMainFrame()
        elseif btn == "RightButton" then
            if settingsFrame:IsShown() then
                settingsFrame:Hide()
            else
                settingsFrame:Show()
            end
        end
	end,

	OnTooltipShow = function(tooltip)
		if not tooltip or not tooltip.AddLine then
			return
		end

		tooltip:AddLine("MyAddon\n\nLeft-click: Open MyAddon\nRight-click: Open MyAddon Settings", nil, nil, nil, nil)
	end,
})

function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("MyAddonMinimapPOS", {
		profile = {
			minimap = {
				hide = false,
			},
		},
	})

	MyAddonMinimapButton:Register("MyAddon", miniButton, self.db.profile.minimap)
end

MyAddonMinimapButton:Show("MyAddon")