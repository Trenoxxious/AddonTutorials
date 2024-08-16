# Part 6: Parsing Data Using Variables and Functions

Difficulty: 🟡🟡 Medium

**Now that our print statement is sending messages to the chat window when we engage with combat, we can replace the print statement with variables, functions and if statements to do the things we want to do: record NPC deaths**

---

## Step 1: Defining Local Function Variables

Let's start by defining some variables inside of our `eventHandler` function to hold or define some information we will be using.

To start, we are going to define a few variables just to make writing and reading our function easier.

##### 1. Variables that parse the most recent combat log event

```lua
local _, eventType = CombatLogGetCurrentEventInfo()
```

According to the WoW API documentation, using `CombatLogGetCurrentEventInfo()` will always return the current combat event information if we use it during the `"COMBAT_LOG_EVENT_UNFILTERED"` event.

The above code is defining a variable of `eventType` (which we can name anything) using the returned data from the function `CombatLogGetCurrentEventInfo()`.

`CombatLogGetCurrentEventInfo()` actually returns 11-13 pieces of information when called, but we only have use out of the first 2 returned pieces of information in this context. And, out of those first 2, we ***really*** only need *1* of them (the first piece of data returned is timestamp data, which we won't be using). 

So, we can mark the unneeded timestamp variable as `_` instead of giving it a name, because it will go unused and doesn't need to take up space in our limited local variable limit (200 in Lua).

Let's use the print function to try and print the information from the `eventType` variable.

```lua
print(eventType)
```

If we were to print this code in-game with our addon, it should print the sub event of our combat log entry... or we could get an error.

Sometimes our code can try to access information that does not exist. Functions or variables will usually return `nil` if it cannot find the requested information, or something went wrong when trying to retrieve information.

---

## Step 2: Always Check for `nil`

> A type of 'nil' is returned anytime information is not available, and can cause loads of errors if not dealt with properly.

Safe code is code that will **always** return a value. In the case of `eventType`, there is a chance it may return `nil` information instead of actual information. There are many reasons for this happening and most of the time it's hard to know everything that can cause a `nil` error.

Instead of trying to find every possible scenario where we may run into a return of `nil` on `eventType`, we will instead write our code to handle `nil` and if our eventType is not `nil`, we can write our code to handle that as well.

The correct way we want to check this type of **"unsafe"** code is to check for `nil` first. We can do this by using the below code:

```lua
if eventType ~= nil then
    print(eventType)
end
```

However, we can shorten this a bit by removing the `~= nil` part. Using just `if eventType` basically asks if eventType is not `nil`. See below:

```lua
if eventType then
    print(eventType)
else
    print("No data found!")
end
```

In english, or "pseudocode", the above code states:

> If eventType **has** data associated with it, let's go ahead and print that data, *otherwise*, let me know that it does not.

If we actually put the above code into the game, every sub event during combat should print its type. At the ***end*** of our combat, it should print a sub type of `"PARTY_KILL"`. This is the event type we want our function to listen to.

Now that we have this information gathered from the `CombatLogGetCurrentEventInfo()` function and stored in variables called `_` (unused), and `eventType`, we can move on and use this to start recording our kills to our **`MyAddonDB`** database.

Our code should currently read as follows:

```lua
local eventListenerFrame = CreateFrame("Frame", "MyAddonEventListenerFrame", UIParent)

local function eventHandler(self, event, ...)
    local _, eventType = CombatLogGetCurrentEventInfo()

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        if eventType then
            print(eventType)
        else
            print("No data found!")
        end
    end
end

eventListenerFrame:SetScript("OnEvent", eventHandler)
eventListenerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
```

This code will get pretty annoying after a while because of the constant printing to the chat box while in combat, so let's move on and make it less annoying and do what we want it to do.

Let's move onto [Part 7 of our series to do this now](https://reddit.com/r/wowaddondev).