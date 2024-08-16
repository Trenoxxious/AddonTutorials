# Part 5: More Functions & Other Lua

Difficulty: 🟡🟡 Medium

**Congratulations on making it this far! We're probably around 30% or so done with the addon. Let's keep going!**

We're getting pretty far. So far, our addon opens with a command, makes sound, prints the character's name to the top of the addon and we also have a saved variable named `MyAddonDB` that's blank and ready for writing to!

---

### Step 1: Understanding Events

Our first step is to call an event to "listen" for whenever the player has a combat log update. This is the `COMBAT_LOG_EVENT_UNFILTERED` event specifically.

The way that code works during these events is by listening for them to "fire."

A lot of World of Warcraft addons use multiple functions to create something unique. Take my addon NoxxLFG for example. It reads messages, but also reads the name of player who posts it, their class, the time they post it, the roles they are looking for, the dungeon/raid and sub dungeon/raid they post, etc. All of this information is gathered using different functions and methods, with a combined end result.

> So, how are we going to "listen" to these events to get information?

We are going to use multiple functions to read and record information to our `MyAddonDB` variable. Blizzard gives us a vast list of global API we can use in our addon to get information that normally doesn't appear on our screens. This is not only very helpful, but is the back bone to every single World of Warcraft addon ever created.

Okay, enough blabbering, let's get into some juicy code.

---

### Step 2: Using Events

To start listening to events, we now need an invisible frame that will listen to events for us. We need to register this frame with an event listener so it knows its purpose is to listen to events. We do this by using the following code:

###### I. Create the Frame

This frame is invisible, unlike the frame we created earlier. We will not define a template, size, position, etc. A frame is needed anytime we want to listen to an event.

````lua
local eventListenerFrame = CreateFrame("Frame", "MyAddonEventListenerFrame", UIParent)
````

##### II. Create a Function for the Event

This function will be called any time the event of `"COMBAT_LOG_EVENT_UNFILTERED"` fires, which is multiple times during combat.

```lua
local function eventHandler(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    end
end
```

###### III. Register the Frame to Listen to Events

The `"COMBAT_LOG_EVENT_UNFILTERED"` event will not fire without first registering the event with the frame.

```lua
eventListenerFrame:SetScript("OnEvent", eventHandler)
eventListenerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
```

Now that we have the `eventListenerFrame` registered with `RegisterEvent`, it will now listen for that event to fire in-game. When it does fire, it will call the `eventHandler` function from the `SetScript("OnEvent")` function.

Keep in mind, code reads from top to bottom. For `eventListenerFrame:SetScript("OnEvent", eventHandler)` to call the `eventHandler` function, `eventHandler` needs to be written **above** wherever it's called. The entire code block should read as follows:

```lua
local eventListenerFrame = CreateFrame("Frame", "MyAddonEventListenerFrame", UIParent)

local function eventHandler(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    end
end

eventListenerFrame:SetScript("OnEvent", eventHandler)
eventListenerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
```

Notice we have nothing for the function to do between `if event == "COMBAT_LOG_EVENT_UNFILTERED" then` and `end` - we will now write that function. First, we'll need to debug to make sure we're doing the correct thing, and that the event listening actually works.

For now, let's put a `print` statement in here to test it:

```lua
print("You have a new combat log event!")
```

The eventHandler function should now read as follows:

```lua
local function eventHandler(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        print("You have a new combat log event!")
    end
end
```

---

### Step 3: Debug and Test

Now, when the event fires, you should see a message print to the chat box. You should see the message print ***SEVERAL*** times during combat.

Log in or `/reload` your game and go kill some things to test this out! Critters, NPCs; whatever you can get your hands on.

If we can confirm this is working at this point, we're ready to move onto some Blizzard API to read some information from the combat log!

Whenever you're ready to proceed, go ahead and [meet me at Part Six](https://reddit.com/r/wowaddondev).
