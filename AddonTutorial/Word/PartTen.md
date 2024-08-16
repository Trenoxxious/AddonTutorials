# Part 10: Developing a Separate Interface for Settings

Difficulty: 🟡🟡 Medium

**This isn't terribly difficult, but we will be implementing some things into this tutorial that aren't 100% necessary just to re-cover some things, like .toc file updating, creating a new file, etc. Let's do it!**

First, take a breath if you haven't yet. This is a lot to take in. Especially Part 8 and 9. Once you're ready, we can move on!

---

## Step 1: Creating Another File

To start, we will be creating a new file for all of our settings code to live in. This is not necessary, but will keep things cleaner and more organized for you in the future.

To start, let's create a *new file* in your addon folder called `Settings.lua`. Remember, this should be in the same folder as your main addon file, which is probably named `MyAddon.lua`.

Now, in your .toc file, make sure to add `Settings.lua` to the bottom of the file, right under your first .lua file.

After you've added the new file to your .toc file, let's re-open `Settings.lua` and make our settings frame!

---

## Step 2: Creating a Settings Frame

First, we'll start again by making a new frame. We can call this frame settingsFrame and it should be a local variable.

```lua
local settingsFrame = CreateFrame("Frame", "MyAddonSettingsFrame", UIParent, "BasicFrameTemplateWithInset")
settingsFrame:SetSize(400, 300)
settingsFrame:SetPoint("CENTER")
settingsFrame.TitleBg:SetHeight(30)
settingsFrame.title = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
settingsFrame.title:SetPoint("CENTER", settingsFrame.TitleBg, "CENTER", 0, -3)
settingsFrame.title:SetText("MyAddon Settings")
settingsFrame:Hide()
settingsFrame:EnableMouse(true)
settingsFrame:SetMovable(true)
settingsFrame:RegisterForDrag("LeftButton")
settingsFrame:SetScript("OnDragStart", function(self)
	self:StartMoving()
end)

settingsFrame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
end)
```

The above code creates a settings frame and a title for the frame. Once again, this frame will come with a close button. The frame will also be moveable!

By default, this frame will be hidden. It will only show when we press a button to show it. This is also going to be the file we create our minimap button in.

Once you have your settings frame created, save your file and log in or `/reload` your game. You shouldn't see anything show up, but feel free to remove the `settingsFrame:Hide()` line or add a slash command yourself to view the settings frame.

---

## Step 3: Creating Our Checkboxes

If all is good in `settingsFrame` land, let's move on to create two settings!

These settings are going to be `Checkbox` settings. If the checkbox is `checked` they equal `true`. If it is `unchecked` it equals `false`.

For this, we are actually going to be making a new function to create our checkboxes dynmically from a table. But first, we'll need a table to hold all of our settings.

In your `Settings.lua` file, at the very top, create a table called `settings`. We're making it local to the addon.

```lua
local settings = {}
```

This is how a table looks in Lua. Tables are defined by using `{}`'s. Currently, it is a blank table. Let's add a setting to it. Change `settings` to this:

```lua
local settings = {
    {
        settingText = "Enable tracking of Kills",
        settingKey = "enableKillTracking",
        settingTooltip = "While enabled, your kills will be tracked.",
    },
}
```

Once again we have `{}` that defines a table, and inside of those we have another set of `{}`'s. This means we have nested another table inside of our original table.

Let's make a second one so you can see how this table keeps expanding as we add to it.

```lua
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
}
```

Hopefully, with the above code laid out, you can see a pattern in how these tables are formed. Now, we'll need to make a function that will loop over these settings, set their default value, create a checkbox and lay them out on the settings frame accordingly.

To handle the display of these settings, let's create a variable above this table called `checkboxes` and we'll also make this local. Give it an initial value of `0`.

```lua
local checkboxes = 0
```

---

## Step 4: Creating Our Checkbox Creation Function

Let's start our **local** function and name it `CreateCheckbox`. We're also going to give it a few arguments.

* checkboxText
* key
* checkboxTooltip

```lua
local function CreateCheckbox(checkboxText, key, checkboxTooltip)
    -- Code to go here soon...
end
```

Inside of this function, we need to create the `Checkbox` frame, put text to the right of it, make it interactable and place it correctly onto the settings frame.

This function will also be our method of giving a default value to our settings. In our case, the default value will be `true` *(checked)*.

Let's do this now.

```lua
local function CreateCheckbox(checkboxText, key, checkboxTooltip)
    local checkbox = CreateFrame("CheckButton", "MyAddonCheckboxID" .. checkboxes, settingsFrame, "UICheckButtonTemplate")
    checkbox.Text:SetText(checkboxText)
    checkbox:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -30 + (checkboxes * -30))
end
```
The above code is a simple function that creates a **new** `Checkbox` anytime it is called. It will position it correctly on the settings frame as well.

In our `CreateCheckbox` function, we're going to make sure our `Checkbox` equals the state of the database key when it's created. If the setting is `true` (checked), we want the `Checkbox` to be checked as well.

We will do that by adding this into our `CreateCheckbox` function.

```lua
if MyAddonDB.settingsKeys[key] == nil then
    MyAddonDB.settingsKeys[key] = true
end

checkbox:SetChecked(MyAddonDB.settingsKeys[key])
```

Above, we check for the key in our `settingsKeys` table of **`MyAddonDB`** to see if it's `nil`. If it is, we will set it to the default value of `true`. If it is not `nil`, we will leave it alone.

We don't want to login to the game just yet, because we still have to create the event that will set `MyAddonDB.settingsKeys` to `nil` or `empty` before we use it.

Next, we're going to add our checkbox functionality and tooltip text that tells the player what exactly the setting does! 

We'll also be increasing the `checkboxes` variable we put at the top of the file by `1`. Add the below code to your `CreateCheckbox` function.

```lua
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
```

---

## Step 5: Code Review

Now that we've gotten this far, our entire `Settings.lua` file should be as such:

```lua
local checkboxes = 0

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
}

local settingsFrame = CreateFrame("Frame", "MyAddonSettingsFrame", UIParent, "BasicFrameTemplateWithInset")
settingsFrame:SetSize(400, 300)
settingsFrame:SetPoint("CENTER")
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
```

We're not quite done yet, and we won't *yet* notice any difference when pulling up our settings frame, if you can get to it without an error that is.

Next, we need to tell our addon to loop through and create these settings when the player logs in based on the entries we have in our `settings` table. We also need to define our `settingsKeys` table as `blank` so we can use it.

We're going to [take care of that in Part 11](https://reddit.com/r/wowaddondev) whenever you're ready!