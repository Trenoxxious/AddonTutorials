# Step 4: The Addon Does Stuff?

Difficulty: 🟢 Easy

**Now that we have our addon working entirely as expected, let's get it doing some "useful" things.**

---

### Step 1: Display the Character Name

The first thing we want the addon to do is print the character name at the top of the `mainFrame` screen we've created.

This is going to be done using official Blizzard API for getting names in-game. We're going to again short-hand this off mainFrame to achieve a simple result. The code will use `UnitName()` API from Blizzard to get the `UnitId` name.

> How does it know what unit ID to get the name of?

Well, there are several `UnitIds` which you can pass to this function. The one we're interested in right now is `"player"` specifically. You can find a [list of applicable unitIds to pass to this function](https://warcraft.wiki.gg/wiki/UnitId) on the Warcraft Wiki.

Let's code this as such:

```lua
mainFrame.playerName = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.playerName:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 15, -35)
mainFrame.playerName:SetText("Character: " .. UnitName("player"))
```

We can put this block of code anywhere we want really, but we need to make sure it's below our intial statement of `local mainFrame` and good practice is to keep it close to all of our other `mainFrame` code.

The mainFrame we've created will now display the current character's name at the top of the addon on the left side. It will also have a nice padding of about 10 pixels/units from the top and the left.

The character name is affixed to this position, meaning when the window moves the text will move as well. We've set the `SetPoint()` to the `mainFrame` parent to allow this. It's how everything inside of a window gets "stuck" to its position.

For the `playerName` variable of `mainFrame` we are using `"Character: " .. UnitName("player")`. For example, a person playing on their character named Noxxious will have this printed to MyAddon:

> Character: Noxxious

We can go a step further and also print their level in parenthesis next to it. You've probably guessed how we can do this. Take a look at the below code:

```lua
mainFrame.playerName:SetText("Character: " .. UnitName("player") .. " (Level " .. UnitLevel("player") .. ")")
```

We should now see something like this in the addon, depending on your character of course:

> Character: Noxxious (Level 50)

Using the above code, we added the players level to the string. To concatenate strings together, between quotes, `..` is used. To concatenate booleans (true or false values) to strings, you can use the `tostring` function:

```lua
local trueOrFalse = true
print("trueOrFalse is " .. tostring(trueOrFalse))
```

or

```lua
local trueOrFalse = tostring(true)
print("trueOrFalse is " .. trueOrFalse)
```

Using the above code can be very useful in debugging code, but will give errors if you don't turn the boolean into a string before printing it.

---

### Step 2: Variables, Tables and Saving Them, Oh My!

Moving on, we need to actually define some variables and tables for our addon, and modify our .toc file to save those variables and tables even after the character logs out.

To start, we're going to make a saved variable in our .toc file under the `## SavedVariablesPerCharacter` section. We're going to open our .toc file and make the below adjustment:

```toc
## SavedVariablesPerCharacter: MyAddonDB
```

What this does is tell our addon that anything stored under the MyAddonDB variable will persist even after a character logs out. We will be able to write and read from this table.

Without adding this to our SavedVariablesPerCharacter section of the .toc file, each reload or re-log would erase this information. If we want all the data we store to save across **ALL** characters, we can instead move MyAddonDB to `## SavedVariables` instead. For the purpose of this addon, the data we store is going to be per-character, so we'll keep it as is. Your .toc file code should now read something like (using my tag-along addon names as example):

```toc
## Interface: 11502
## Title: NoxxAddon
## Notes: An addon that does nothing yet.
## Author: Noxxious
## Version: 1.0.0
## RequiredDeps:
## X-Curse-Project-ID: 99999
## SavedVariables:
## SavedVariablesPerCharacter: MyAddonDB

NoxxAddon.lua
```

So now that we have told our addon to save anything "MyAddonDB" forever, we'll need to define it in our addon now.

Let's open our addon's .lua file again. At the top, we're going to define this variable, but make it blank to start. We do this by using Lua to make a statement:

> If this variable does not exist already, please create it, and it should be blank.

We do this by using the following code **at the top of all of our code**, as it needs defined before it can be used by any code below it:

```lua
if not MyAddonDB then
    MyAddonDB = {}
end

-- local mainFrame code is here...
```

This sets us up to use the MyAddonDB variable without any errors or conflicts, as we're essentially defining it the same way we would by using the below code to initialize the table each time the player logs in:

```lua
local MyAddonDB = {}
```

But, we won't be doing it the above way because we want the variable to persist across game sessions.

The `{}` symbols indicate that we won't be storing a number or a string, we'll instead be storing a **table** of data. Tables in Lua are always between curly braces. Here is an example of how our table might look if we were to *directly write it* instead of having functions write it for us in the future:

```lua
local MyAddonDB = {
    kills = 16,
    gold = 10,
    silver = 56,
    copper = 12,
}
```

If we wanted to check how many total kills a player has in the database, we could do so via calling `MyAddonDB.kills` as such:

```lua
print("MyAddonDB currently has " .. tostring(MyAddonDB.kills) .. " kills.")
-- Prints: "MyAddonDB currently has 16 kills."
```

The difference between `if not MyAddonDB then` and `MyAddonDB = {}` is the overwrite factor. If we use the second one, each time a player logs in, the table will be reset to blank. The first one checks if the table exists or not yet, and if it does, leave it alone. We again use the english-form statement below and translate it to Lua:

> If this variable does not exist already, please create it...

Now, it's time to use some different types of Blizzard API and functions to start recording information about events and actions the player takes!

---

### Step 3: Code Review

Before we proceed, your code should appear as such in its entirety:

**Your .toc file**

```toc
## Interface: 11502
## Title: MyAddon
## Notes: A description here.
## Author: Your Name
## Version: 1.0.0
## RequiredDeps:
## X-Curse-Project-ID: 99999
## SavedVariables:
## SavedVariablesPerCharacter: MyAddonDB

MyAddon.lua
```

**Your .lua file**


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

mainFrame:SetScript("OnShow", function()
        PlaySound(808)
end)

mainFrame:SetScript("OnHide", function()
        PlaySound(808)
end)

mainFrame.playerName = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.playerName:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 15, -35)
mainFrame.playerName:SetText("Character: " .. UnitName("player") .. " (Level " .. UnitLevel("player") .. ")")

SLASH_MYADDON1 = "/myaddon"
SlashCmdList["MYADDON"] = function()
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        mainFrame:Show()
    end
end

table.insert(UISpecialFrames, "MyAddonMainFrame")
```

Really quick here: Some of the code above, such as UnitName and UnitLevel should typically always check for `nil` before attempting to print or do anything with them. This can save you from running into errors with your code. In the worst case scenario, addon errors could crash someones game during a critical moment, which is never good.

We will cover checking for `nil` in a bit. For now, the above code is considered **safe** because the player has to be present to use the addon in the first place.

If you're ready to move on to the next tutorial, [please do so here](https://google.com)! Thank you for following along up to this point!
