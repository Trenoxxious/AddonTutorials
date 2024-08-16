# Part 8: Counting Currency

Difficulty: 🟠🟠🟠 Medium

**Now, we're going to get into some juicy stuff. Let's see what's in store for this part.**

We'll be doing the following: 
* Reading Chat Messages
* Utilizing pattern matching to find Gold, Silver and Copper amounts looted.

This will be a larger part of the tutorial as we will be explaining quite a bit of the code and exactly what it's doing. Let's not make this any longer and get onto some code!

> As a side note, you don't need to understand everything that's going on here. Matching strings to patterns would normally be considered fairly advanced code and these are things you can learn from documentation or future projects. Heck, you can just ask AI how to pattern match a string for what you're looking for and it can teach you a fairly good amount about how patterns work in any language.

---

## Step 1: Registering a New Event

For this portion of our addon to function, we will need to first register a new event that our addon is going to listen for.

We already have our `eventListenerFrame` created, and currently it's registered to the `COMBAT_LOG_EVENT_UNFILTERED` event. Now, we'll need to register it to another event called `"CHAT_MSG_MONEY"`.

This event, when fired, means that a player has looted money (gold, silver, copper), and that money is displayed as a message to the player. The great thing about using `"CHAT_MSG_MONEY"` is that even if the player has these messages hidden in the chat log, our addon can still read them.

Let's register this by finding our `eventListenerFrame:RegisterEvent` line and add a new one below it.

> Ctrl + F and searching for `eventListenerFrame` is a fast way to find this line. Ctrl + F is a fantastic way to search your code for something you need.

```lua
eventListenerFrame:RegisterEvent("CHAT_MSG_MONEY")
```

Now that we have that registered, we can modify our eventHandler to handle this event.

```lua
if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    if eventType == "PARTY_KILL" then
        if not MyAddonDB.kills then
            MyAddonDB.kills = 1
        else
            MyAddonDB.kills = MyAddonDB.kills + 1
        end
    end
elseif event == "CHAT_MSG_MONEY" then
    -- Our code for this event will go here.
end
```

Above, we changed the following code from:
```lua
if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    -- Our code for this event is here...
end
```

to:
```lua
if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    -- Our code for this event is here...
elseif event == "CHAT_MSG_MONEY" then
    -- Our code for this event is here...
end
```

With this modified code, when someone loots something, it fires an event. If that event is `"CHAT_MSG_MONEY"` then our code inside of that event in the function will execute. Currently, it does nothing.

Let's move on to doing *something* with that code instead of the nothing that it's doing now.

---

## Step 2: Using the Chat Message

To use this information, we will now append some code to our `if else` statement. We'll be using `string matching` to check if the chat message contains `Gold`, `Silver`, or `Copper`.

Inside of our `if else` statement, let's add this code:

```lua
local msg = ...
local gold = tonumber(string.match(msg, "(%d+) Gold")) or 0
local silver = tonumber(string.match(msg, "(%d+) Silver")) or 0
local copper = tonumber(string.match(msg, "(%d+) Copper")) or 0
```

The `msg` variable assigns `...` to it. `...` is pulling the only payload information from `"CHAT_MSG_MONEY"` that it provides, which is a string that says something along the lines of:

> You loot 42 Copper.

With this information, our `gold`, `silver` and `copper` variables are searching the `msg` string for a pattern. The `(%d+)` portion of our parse is looking for any `one or more digits (d+)` information before `" Gold"`, `" Silver"` or `" Copper"` and converts it to a `number`. Thankfully, the message you receive when looting money in-game is **always** followed by `' Copper'`, `' Silver'` or `' Gold'`. This makes this pattern work flawlessly for us forever unless Blizzard changes this message in the future.

---

## Step 3: Making Our Variables Work

We're now going to store this information to our database. Here's how we can do this:

```lua
MyAddonDB.gold = (MyAddonDB.gold or 0) + gold
```

The above code stores any looted `gold` into our **`MyAddonDB.gold`** database. This is short-hand code that checks to make sure MyAddonDB.gold exists, or makes it 0, before writing to it. If it doesn't exist, it will create it and make its value `0 + gold` upon creation.

We can simply copy and paste the above code for `silver` and `copper` as well.

```lua
local msg = ...
local gold = tonumber(string.match(msg, "(%d+) Gold")) or 0
local silver = tonumber(string.match(msg, "(%d+) Silver")) or 0
local copper = tonumber(string.match(msg, "(%d+) Copper")) or 0
```

> These strings we're parsing are case-sensitive in our case, hence the capitals in `Gold`, `Silver` and `Copper`. There is a way to ignore case sensitivity when searching for patterns, and if you'd like to do this, you're more than welcome to. Consider it a bonus project!

---

## Step 4: Handling `>= 100` for Our Currencies

We want to convert our copper and silver gained to their respective higher currencies, if they go above `100`. To do this, we're going to start with `copper`, as it's the lowest currency value **World of Warcraft** has.

```lua
if MyAddonDB.copper >= 100 then
    MyAddonDB.silver = MyAddonDB.silver + math.floor(MyAddonDB.copper / 100)
    MyAddonDB.copper = MyAddonDB.copper % 100
end
```
The above code checks for `copper`. If it exists and is `equal to` or `over 100`.

It then converts the `copper` to `silver`, dividing the `copper` by `100` in `whole number form` (using `math.floor`).

Let's duplicate this code for `silver` to convert to `gold`.

```lua
if MyAddonDB.copper >= 100 then
    MyAddonDB.silver = MyAddonDB.silver + math.floor(MyAddonDB.copper / 100)
    MyAddonDB.copper = MyAddonDB.copper % 100
end

if MyAddonDB.silver >= 100 then
    MyAddonDB.gold = MyAddonDB.gold + math.floor(MyAddonDB.silver / 100)
    MyAddonDB.silver = MyAddonDB.silver % 100
end
```

The entire above code will now write `gold`, `silver` and `copper` information to our database and convert any amount `>= 100`.

[See me in Part 9](https://reddit.com/r/wowaddondev) to move on to showing this information in our addon!