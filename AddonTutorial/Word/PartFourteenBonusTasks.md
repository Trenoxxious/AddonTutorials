# *Secret* Part 14: Bonus Tasks

**Thanks for sticking around and going through the bonus tasks. It feels like I've tricked you into this section, because it's not going to be *all* fun and games...**

This section is going to be labeled with a **HARD** difficulty. Let's do that now.

Difficulty: 🔴🔴🔴🔴 Hard

> Yep... There it is.

Okay... okay... Each idea will have its *own difficulty level*. Doing them all can be somewhat hard to for beginners, so I don't want to scare you out of doing these activities.

I'm not going to outright give you the code to add a feature. At least not *immediately*. First, I'll be giving you the **idea** for what we're going to add, and *you're* going to add it, or do your best adding it, using the resources I will provide you.

Below all the information and resources for the idea, I will provide the code to accomplish the idea inside of `spoiler tags`.

This is an exercise to **prove to yourself that you've learned something**. That you can **add to this addon *in your own way***.

Enough of the pep talk. Let's get into some ideas you can start implementing yourself.

> Keep in mind, these are optional. You do not have to implement them. You can come up with your own if you'd like! This is just an excersize to get you thinking about WoW addon development and into the groove.

---

## Idea #1: Milestone Chat Messages
### Difficulty: 🟡🟡 Medium

The concept behind this idea is fairly simple. Every 250 Kills, print a chat message telling the player they've reached a new milestone. Tell them how many kills or how much gold they've gained since they've started tracking with your addon, or both! The gold is kind of hard to do alone, so it's not necessary to add this milestone message for gold unless you plan on creating a table with gold milestones that are hardcoded, which can get quite sloppy and unrealistic pretty quickly. You can instead tell the player how much gold they've gained when they reach a monster milestone!

We'll also want to add a new setting in our `Settings.lua` file so they can turn these messages off of course, but it should start as `true`, similar to the other settings.

To implement this, you'll need to use the following:

* `if then` statements
* The `print()` function
* Math (Hint: Modulo Operator)

##### Resources: None.

Try to implement this idea now! To start, and to debug, you can set the kill milestone threshold to something like `2` or `10` instead of `250`. When you have working code, you can change it to `250`.

#### See Below for the Spoiled Code

---

## Idea #2: Login Message
### Difficulty: 🟢 Easy

This one is fairly simple. We will want to print a message every time the player logs in or `/reload`s their game to tell them the addon has loaded. We can also print the version number in this print message.

To implement this, you'll need to use the following:

* A new version variable
* The `print()` function

##### Resources: None.

Give it a go!

#### See Below for the Spoiled Code

---

## Idea #3: Track Player Deaths
### Difficulty: 🟠🟠🟠 Medium

We can use our `eventListenerFrame` in our main addon .lua file to listen for player death events. There are **a few** ways we could do this, but we should try to stick to the easiest way.

To implement this, you'll need to use the following:

* `if then` statements
* A new database entry/variable
* Creating a Chat Listener (Hint: `"CHAT_MSG_SYSTEM"`)

##### Resources: [CHAT_MSG_SYSTEM - Wiki](https://warcraft.wiki.gg/wiki/CHAT_MSG_SYSTEM)

Let's see if you can get this working! No spoilers for this one!

I hope you've enjoyed the addon series so far, I've had a blast making it! And from a beginner addon developer to another, I hope you create awesome addons. Please let me know what addons you've created after this guide! I'd love to check them out!

In another unrelated part of from this guide, I will be posting a tutorial/walk through on how to most-easily create and maintain a GitHub repository for your code. This keeps your code-base safe and manageable. Be on the lookout for that soon!

> TehNoxx, NoxxLFG Author

# SPOILED CODE

## Monster Kill Milestones

```lua
    -- Code above...
if event == "COMBAT_LOG_EVENT_UNFILTERED" and MyAddonDB.settingsKeys.enableKillTracking then
    if eventType and eventType == "PARTY_KILL" then
        if not MyAddonDB.kills then
            MyAddonDB.kills = 1
        else
            MyAddonDB.kills = MyAddonDB.kills + 1
        end
    end

    -- ADDED CODE SHOWN BELOW
    if MyAddonDB.kills and MyAddonDB.kills % 250 == 0 then
         print("|cFF00FF00Kill Milestone! |cFFFFFFFFYou have killed a total of " .. MyAddonDB.kills .. " enemies! You have looted a total of " .. MyAddonDB.gold .. " gold!|r|r")
    end
elseif event == "CHAT_MSG_MONEY" then
    -- Code below...
```

## Print Version Number

### Code: Version Variable (Top of `Settings.lua` File)

```lua
local version = "1.0.0"
```

### Code: Print Login Message (Inside of `"PLAYER_LOGIN"`)

```lua
    -- Code above...
eventListenerFrame:SetScript("OnEvent", function(self, event)
  if event == "PLAYER_LOGIN" then
    print("MyAddon |cFFFFFFFFF" .. version .. "|r Loaded")

    -- Code below...
```