# Part 9: Viewing Our Treasures

Difficulty: 🟢 Easy

**Now, we can show the fruit of our labors to the players- or... just us for now. Let's move on!**

---

## Step 1: Adding a `mainFrame.totalCurrency` property

First, we'll need to do exactly as the step above states. Find `mainFrame.totalPlayerKills` and add `mainFrame.totalCurrency` underneath that block of code.

If you'd like to try and do it yourself first, go ahead. I'll put the below code within Spoiler tags just in case. Don't be ashamed to open them!

```lua
mainFrame.totalCurrency = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.totalCurrency:SetPoint("TOPLEFT", mainFrame.totalPlayerKills, "BOTTOMLEFT", 0, -10)
mainFrame.totalCurrency:SetText("Gold: " .. (MyAddonDB.gold or "0") .. " Silver: " .. (MyAddonDB.silver or "0") .. " Copper: " .. (MyAddonDB.copper or "0"))
```

And that's it! We covered `nil` and everything! Go ahead and log in or `/reload` your game and let's check out how it works!

There is *one more thing* we will do later, which is update this to look nicer. Stick around for that!

---

## Step 2: Oh Wait, We Forgot Something...

We didn't account for the `Gold`, `Silver` and `Copper` fields changing after we loot things! No worries, we can adjust this in our `mainFrame:SetScript("OnShow", function())` again!

Let's add the below code to this block of existing code:

```lua
mainFrame.totalCurrency:SetText("Gold: " .. (MyAddonDB.gold or "0") .. " Silver: " .. (MyAddonDB.silver or "0") .. " Copper: " .. (MyAddonDB.copper or "0"))
```

And that's it! Or is it?

Let's handle a *"sorta-edge-casey"* scenario while we have it on our minds. 

> What if these players kill or loot things with the addon open?

Luckily we've structured our code well, so either of the functions we use to perform the addition of these things to our database is under our `FontStrings` that we've created to show it in the addon. So, the way we perform this is fairly straightforward!

Inside of our `eventHandler` function, at the bottom outside of all `if then else` statements, we're going to add this bit of code:

```lua
if mainFrame:IsShown() then
    mainFrame.totalPlayerKills:SetText("Total Kills: " .. (MyAddonDB.kills or "0"))
    mainFrame.totalCurrency:SetText("Gold: " .. (MyAddonDB.gold or "0") .. " Silver: " .. (MyAddonDB.silver or "0") .. " Copper: " .. (MyAddonDB.copper or "0"))
end
```

So, anytime an event that is registered takes place, if `mainFrame` is shown/open at that time, our `FontString` properties will update! Now you may be asking the question:

> Can't we just get rid of the `"OnShow"` `mainFrame` function and use this instead without `if mainFrame:IsShown()`?

or

> Can't we just get rid of the `SetText()`'s earlier in the file and just use the "OnShow" function?

Well... yes! We could! Either way you want to do this is up to you! In this specific case, neither one is a worse option and should function exactly the same! when you have an addon that gets bigger and the focus is on performance, then I would choose the second route of setting the `SetText()` functions `"OnShow"`.

---

## Step 3: Code Review

Before we head into our Settings interface development, let's review the entirety of our .lua code file below (our .toc file has not changed):

```lua
if not MyAddonDB then
    MyAddonDB = {}
end

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
mainFrame.totalCurrency:SetText("Gold: " .. (MyAddonDB.gold or "0") .. " Silver: " .. (MyAddonDB.silver or "0") .. " Copper: " .. (MyAddonDB.copper or "0"))

mainFrame:SetScript("OnShow", function()
    PlaySound(808)
    mainFrame.totalPlayerKills:SetText("Total Kills: " .. (MyAddonDB.kills or "0"))
    mainFrame.totalCurrency:SetText("Gold: " .. (MyAddonDB.gold or "0") .. " Silver: " .. (MyAddonDB.silver or "0") .. " Copper: " .. (MyAddonDB.copper or "0"))
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
        mainFrame.totalCurrency:SetText("Gold: " .. (MyAddonDB.gold or "0") .. " Silver: " .. (MyAddonDB.silver or "0") .. " Copper: " .. (MyAddonDB.copper or "0"))
    end
end

eventListenerFrame:SetScript("OnEvent", eventHandler)
eventListenerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventListenerFrame:RegisterEvent("CHAT_MSG_MONEY")
```

If your addon functions correctly and you aren't getting any errors, let's [head into Step 10](https://reddit.com/r/wowaddondev)! Developing a Settings screen!