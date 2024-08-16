# Part 3: Creating a Slash Command

Difficulty: 🟢 Easy

**Now that we have a frame created with a title, have it movable, closable and making sound, we need to make it more interesting.**

Right now, the frame doesn't show because we've hidden it with `mainFrame:Hide()` and as you can expect, we can either delete that line, or show it on command with `mainFrame:Show()` to get it to show again.

We're going to handle that by creating a slash command to show it if it's hidden, or close it if it's shown. In the future, this will be handled by a minimap icon that we can create utilizing a library.

---

### Step 1: The Slash Command


To tell an addon about a slash command, we'll need to use the following code:

```lua
SLASH_MYADDON1 = "/myaddon"
SlashCmdList["MYADDON"] = function()
end
```

With the above code, we're defining a few things: `SLASH_` and `MYADDON` in a single line, separated by `_`. This is important as the below `SlashCmdList` uses the same exact thing. For example:

```lua
SLASH_THISISUNIQUE1 = "/unique"
SLASH_THISISUNIQUE2 = "/uni"
SlashCmdList["THISISUNIQUE"] = function()
end
```

The above code utilizes `THISISUNIQUE` and `SlashCmdList` also includes this exact string in the quotes to know what slash commands to read. For now, we're going to stick to using the above code in any fashion you want. Keep in mind, can have multiple slash commands. You can stick with just one for now.

Your code should look somewhat like this:

```lua
SLASH_MYADDON1 = "/myaddon"
SlashCmdList["MYADDON"] = function()
end
```

---

### Step 2: The Function

Now, we need to tell the addon what to do when either of those slash commands are typed in. If a user type `/myaddon` or `/ma` we want the addon to show on the screen. To do that, inside of the `SlashCmdList["MYADDON"] = function()` portion of the code, we will use `mainFrame:Show()`.

Your code should appear as such now:

```lua
SLASH_MYADDON1 = "/myaddon"
SLASH_MYADDON2 = "/ma"
SlashCmdList["MYADDON"] = function()
    mainFrame:Show()
end
```

Now, anytime someone uses your slash commands, the function will perform all of the actions inside `function()` and `end`. In this case, it's simply showing the window.

Now, with `"BasicFrameTemplateWithInset"` that we used earlier, we have a close button. When clicked, the template already knows the call the `Hide()` function, as that's included in the template already. However, it is good practice to code for all possibilities, and our function above should also close the window if the slash command is typed and the window is opened.

*How can we do that?*

We need our function to ask a question to answer this.

> Is the frame showing or not?

We can ask this question in Lua by using an `if then, else` statement. Inside of the function, we're going to delete `mainFrame:Show()` and instead replace it with the below code:

```lua
if mainFrame:IsShown() then
    mainFrame:Hide()
else
    mainFrame:Show()
end
```

This code essentially asks, in Lua:

> If the main frame of the addon is currently showing, then we should hide it, or else we should show it.

We know when the game loads, the frame is not going to be showing. The code will show it and mark the frame as **shown** in the background somewhere. The next time we run the slash command, it will know it's showing and hide it instead. Go ahead and try this now without using the close button.

---

### Step 3: Making Our Frame Important

Now, sometimes we want to close our frame with 'Escape' on our keyboard. It's essential that your addon's main starting frame does this. We can tell the game to do this by simply adding your frame to the list of "special" frames in World of Warcraft. To do this, we can use one line of code appeneded to the end of our existing code:

```lua
table.insert(UISpecialFrames, "MyAddonMainFrame")
```

In the above line of code, we're inserting our mainFrame (which is named `"MyAddonMainFrame"`, or whatever name you gave it during Part 2) into a table called UISpecialFrames, which Blizzard creates for our interface automatically.

You can kind of think of this table as such:

```lua
UISpecialFrames = { "CharacterScreen", "FriendsScreen", "MyAddonMainFrame" }
```

We know the friends panel, character panel, etc. all close when you press the 'Escape' key, so this is just adding to the list of frames that are special and should be closed when pressing the 'Escape' key.

And with that, Part 3 has been completed. The code block we implemented should be as such:

```lua
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

Once you feel good and ready, head to the [next step in the tutorial](https://google.com) where we'll be writing more Lua code to provide a "Dashboard" kinda feel to the addon!
