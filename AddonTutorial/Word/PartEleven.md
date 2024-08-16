# Part 11: Telling Our Addon to Create Checkboxes

Difficulty: 🟡🟡 Medium

**Now that we have our `CreateCheckboxes` function setup, we can finally tell the addon to create those checkboxes by looping through our `settings` table.

---

## Step 1: Creating Our Checkboxes with a `for loop`

First, we'll need an invisible frame in our `Settings.lua` file to listen for the `"PLAYER_LOGIN"` event.

Let's add the following code to do so:

```lua
local eventListenerFrame = CreateFrame("Frame", "MyAddonSettingsEventListenerFrame", UIParent)

eventListenerFrame:RegisterEvent("PLAYER_LOGIN")

eventListenerFrame:SetScript("OnEvent", function(self, event)
  if event == "PLAYER_LOGIN" then
    for _, setting in pairs(settings) do
        CreateCheckbox(setting.settingText, setting.settingKey, setting.settingTooltip)
    end
  end
end)
```

The above code creates an invisible frame, very similarly to the frame we created to listen to events in our other .lua file.

Instead, this frame is registered to the `"PLAYER_LOGIN"` event. When that event fires, the `CreateCheckbox()` function is called, which creates all the checkboxes it needs by "looping" through our `settings` table.

You'll notice that it loops through the `settings` table, shown in `()`'s of the for loop. At each stop of the `settings` table, we're defining that specific table as `setting` and we can access the components of that table by using a `.` and its variable name within that table.

For instance, in our for loop, `setting.settingText` will equal `"Enable tracking of Kills"` on the first loop.

The line `for _, setting in pairs(settings) do` is an example of a "for loop", starting with `for`, giving a condition, and ending with `do` and `end`.

In this case, the condition isn't especially noticeable, but in english the for loop is basically stating:

#### FOR
> For every...

#### _, SETTING in PAIRS(settings)
> Entry in the `settings` table

#### DO
> Do the following until we reach the end of the `settings` table

Another example of a for loop is shown below:

```lua
for i = 1, 10 do
    print(i)
end
```

This for loop counts from 1 to 10 and prints out the number it is at each loop. Every time the code inside of the for loop is executed, `i` increases by `1` until it reaches the for loop condition, which is `10`.

Next, we'll need to define our `MyAddonDB.settingsKeys` table. Let's do so by appending the following code inside of our `"PLAYER_LOGIN"` `eventHandler` event, at the top:

```lua
if not MyAddonDB.settingsKeys then
    MyAddonDB.settingsKeys = {}
end
```

Our full `"PLAYER_LOGIN"` event should appear as such:

```lua
if event == "PLAYER_LOGIN" then
    if not MyAddonDB.settingsKeys then
        MyAddonDB.settingsKeys = {}
    end

    for _, setting in pairs(settings) do
        CreateCheckbox(setting.settingText, setting.settingKey, setting.settingTooltip)
    end
end
```

Let's move on and put these settings to use in our addon!

---

## Step 2: Using Our Settings in Our Addon

To access the value of one of our settings, we need to access it in the database.

Think of each step as "hopping into a box, and then another box, then another..."

`MyAddonDB` > `settingsKeys` > `key`

> The above, concatenated with `.`'s becomes...

`MyAddonDB.settingsKeys.enableKillTracking`

In our main addon .lua file, we will want to find this line of code: `if event == "COMBAT_LOG_EVENT_UNFILTERED" then`. Once we find this line, we're going to change it to this:

```lua
if event == "COMBAT_LOG_EVENT_UNFILTERED" and MyAddonDB.settingsKeys.enableKillTracking then
```

Since **both** conditions in the `if then` statement need to be true, the following code inside of it will not run unless the `event` equals `"COMBAT_LOG_EVENT_UNFILTERED"` and `MyAddonDB.settingsKeys.enableKillTracking` is `true`.

The other main addon event we can modify with our setting is `elseif event == "CHAT_MSG_MONEY" then`. We can modify this to instead be:

```lua
elseif event == "CHAT_MSG_MONEY" and MyAddonDB.settingsKeys.enableCurrencyTracking then
```

In our `Settings.lua` file, we made sure that these settings are a default of `true` if the setting has never loaded before, so we don't have to worry about our addon not working "right out of the box." 

The player will have to go into the settings menu to disable these manually.

Now, the question is...

> How are players going to open the settings for this addon?

The answer is... **a minimap button!** We'll [cover that in Part 12](https://reddit.com/r/wowaddondev)! Let's go!