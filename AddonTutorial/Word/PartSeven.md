# Part 7: Writing to our Database

Difficulty: 🟡🟡 Medium

**We're going to be writing to our database using the information given. Not only will it track the kills you get, but also any kills you log while in a party. This will be a long-ish one (but semi-easy), so buckle up!**

---

## Step 1: Filtering Our `eventType` Variable

First, we'll be filtering out `eventType` so we aren't printing so much to the combat log. If you *did* print the `eventType` to the chat box, I'm sure you saw a few events print. The one we're looking for specifically is `"PARTY_KILL"`, letting us know the mob has died from us, or someone in our party.

> How are we going to modify the code to only work with `"PARTY_KILL"` sub events?

Well, let's use the following code:

In our eventHandler function, we're going to insert this line of code inside of our event check code:

```lua
if eventType and eventType == "PARTY_KILL" then
end
```

This code states:

> If `eventType` is not `nil` and `eventType` is equal to "PARTY_KILL", then we can proceed.

Both of the requirements in the `if statement` need to be true for the code to proceed. 

We're making sure that `eventType` is not `nil` ***and*** that `eventType` is equal to `"PARTY_KILL"` as well.

If these are both `true` then we need to debug by printing another nice message. Let's modify our above code to *this*:

```lua
if eventType and eventType == "PARTY_KILL" then
    print("An enemy has been successfully defeated!")
end
```

Nice, now let's head into the game and kill something to check if this works. If you get this message after killing an enemy, we can move on!

---

## Step 2: Finally, Let's Write to the Database

Since we have the message printing to our chat box when we kill something, we're going to modify our code to write to the **`MyAddonDB`** database we created in our previous code. Since we're not actually logging *what* monster was killed, we can modify the code we have slightly to work for us in this context.

To do this, we're going to need to handle two things:
* Does `MyAddonDB.kills` exist yet? If not, write it and make it equal `1`.
* If it does exist, get the value of `MyAddonDB.kills` and add `1` to it.

To do this, let's write the first part of our code below:

```lua
if eventType and eventType == "PARTY_KILL" then
    if not MyAddonDB.kills then
        MyAddonDB.kills = 1
    end
end
```

This is the first bullet point that our code needs to handle.

> If `MyAddonDB.kills` **is** nil, then we need to create it.

You'll notice we used `if not`, essentially meaning `if there isn't MyAddonDB.kills`. We could also use `if MyAddonDB.kills == nil then`, but the above short-hand method is quicker to write *and* clearer to read. Remember, we always want to check for `nil` before attempting to modify a piece of data or access a piece of data.

Now how do we handle the second bullet point of our code handling? Well, this is where the `else` portion of an `if then (elseif) else` statement comes in to play.

Let's modify our code to this now:

```lua
if eventType and eventType == "PARTY_KILL" then
    if not MyAddonDB.kills then
        MyAddonDB.kills = 1
    else
        MyAddonDB.kills = MyAddonDB.kills + 1
    end
end
```

This is basically stating (in english):

> If `MyAddonDB.kills` does not exist, let's make it and set it equal to `1`. If it does exist, we're going to get the amount that `MyAddonDB.kills` has stored already and add `1` to it.

You might ask, why not just initialize `MyAddonDB.kills` with `0` before ever accessing it? Great question, and the way we've handled the `nil` check in our addon interface basically takes care of this. You *can* do this either way you prefer though.

Now, have this information storing in our database. To debug this and make sure it's actually working, we're going to use an addon I mentioned in [Part 1](https://reddit.com/r/wowaddondev) of this tutorial called **DevTools** to view our database.

If you don't have the addon, go ahead and download it and install it using Curseforge. Once installed, login or `/reload` your game and type `/dev` in-game to open it.

Once opened, in the bottom left text field, we're going to type `MyAddonDB` and press the 'Enter' key. Our database should show in the top left-hand window of the `DevTools` addon.

Go ahead and click on `MyAddonDB` to open it. In the right-hand window, we should see our `MyAddonDB` table with (1) entry showing. If it says (0), we need to first kill a creature.

We can click on this table to view its content. It should show an entry called `kills` and that entry should be equal to the amount of kills we have recorded.

It goes without saying that we don't want our players checking `DevTools` to see how many kills they have. We need to implement this within our addon's `mainFrame` window so they can open *our* addon to view these stats. Let's go ahead and handle that.

---

## Step 3: Make Our Data Available in the Addon

In our `mainFrame` of the addon, we have our playerName variable showing the character name and level. Let's put some additional information below this showing the player's total kills.

Same as before, let's make a new variable called `mainFrame.totalPlayerKills` and set it to our database value. However, we will need an `if statement` here to make sure the data is not nil before we display it.

We can do an in-line `if statement` by simply putting `()`'s and an `or`. This is short-hand if-else that we'll explain a little bit about below.

```lua
mainFrame.totalPlayerKills = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.totalPlayerKills:SetPoint("TOPLEFT", mainFrame.playerName, "BOTTOMLEFT", 0, -10)
mainFrame.totalPlayerKills:SetText("Total Kills: " .. (MyAddonDB.kills or "0"))
```

> As a quick side note, VSCode may display some orange/yellow lines below our totalPlayerKills and playerName variables. You can ignore these.

Now that we have our totalPlayerKills showing, let's explain it a bit... specifically this line: `mainFrame.totalPlayerKills:SetText("Total Kills: " .. (MyAddonDB.kills or "0"))`

This line is going to always display "Total Kills: " and the number of kills we have. If MyAddonDB.kills does not exist, or returns `nil`, it will instead write "0" afterward instead of giving us an error.

If we just wrote `mainFrame.totalPlayerKills:SetText("Total Kills: " .. MyAddonDB.kills)` we would throw an error for any new players that install our addon because they may attempt to open our addon before they kill a creature. We handle this by the "0" portion of the code that states:

> If MyAddonDB.kills is `nil` then we'll resort to showing "0" instead of `MyAddonDB.kills` and ultimately throwing an error.

We have set the point of our "Total Kills: " line by parenting it to our `playerName` variable, and using the `offset-Y` parameter in `SetPoint()`. It will always be 10 units under our `playerName` string of the addon.

Now, we're not *entirely* done. You will notice that if we kill an enemy, our addon will not update our kill count that it shows. This is because font strings are not inherently dynamic. We can make this "appear" dynamic using the `"OnShow"` function event. Let's do that now.

---

## Step 4: Updating Text When Opening the Addon

There are a few ways to do this, but our addon is light-weight, meaning there isn't much memory being used by it and it's not going to hinder performance by updating a font string, or even fifty, by opening the addon.

What we're going to do is modify the `mainFrame:SetScript("OnShow", function())` we already have:

Let's make it say the below instead:

```lua
mainFrame:SetScript("OnShow", function()
    PlaySound(808)
    mainFrame.totalPlayerKills:SetText("Total Kills: " .. (MyAddonDB.kills or "0"))
end)
```

Importantly, we also need to move this function to be ***below*** our `mainFrame.totalPlayerKills` variable.

This tells our addon the following (in english):

> Any time we open/show the mainFrame of our addon, we want to set our totalPlayerKills variable to equal `MyAddonDB.kills` or `0` if we have none.

There are **many** ways to handle this, but in our situation, this is the best method to handle this. (We will talk later about niche cases like a player killing a monster while the window is showing/open. This is considered a quality of life improvement and isn't needed right away, but we *will* implement it.)

---

## Step 5: Code Review

And... *we're done with player kills showing in our addon!* Give yourself a pat on the back! You've made it very far and we should actually having a functioning addon! Before we proceed, our code should appear as such so far:

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

mainFrame:SetScript("OnShow", function()
    PlaySound(808)
    mainFrame.totalPlayerKills:SetText("Total Kills: " .. (MyAddonDB.kills or "0"))
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

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        if eventType and eventType == "PARTY_KILL" then
            if not MyAddonDB.kills then
                MyAddonDB.kills = 1
            else
                MyAddonDB.kills = MyAddonDB.kills + 1
            end
        end
    end
end

eventListenerFrame:SetScript("OnEvent", eventHandler)
eventListenerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
```

Let's [move on to Part 8](https://reddit.com/r/wowaddondev) where we'll be covering Gold, Silver and Copper tracking in our addon!