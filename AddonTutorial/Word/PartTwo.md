# Part 2: Creating a Frame

Difficulty: 🟢 Easy

**Creating a frame in World of Warcraft for your addon is a simple process once you do it a few times.**

When developing a World of Warcraft addon, a large part of that is creating frames and using Blizzard's API to do things in-game to make things easier, look better, etc. For the most part, a lot of this is really easy when you learn how to use libraries like Ace3 and LibDBIcon, etc.

We will not be using these to start with so we can learn the basics of creating frames, using API, etc. This will also teach us a good deal of Lua.

---

### Step 1: Creating the Frame

To start, let's load up your .lua file you created in the previous tutorial. It should look something like this:

```lua
print("MyAddon successfully loaded!")
```

We're going to adjust this by just adding code below it. The very first thing we're going to do is create a frame using Blizzard's frame template:

> "BasicFrameTemplateWithInset"

Using this template provides us with a "back bone" of sorts for our frame, including a close button, title bar, background and border. All of this can be done manually for a different aesthetic if you like, but for this tutorial we're going to use this template.

To start, let's define our frame by making a local variable, which starts with `local` and is given a name following it. For the purpose of readability (which I always recommend) we'll be starting with `local mainFrame` and giving it the information as seen below:

```lua
local mainFrame = CreateFrame("Frame", "MyAddonMainFrame", UIParent, "BasicFrameTemplateWithInset")
```

The above code shows how Blizzard's API handles frame creation of any sort using the `CreateFrame` global function. Keep in mind, functions are case sensitive. Usually global functions, like `CreateFrame` shown above, starts in uppercase and proceeds to use CamelCase for each word in the name. Local functions (functions only used in your addon/the file they are declared in) start lowercase and user camelCase for each word in the name.

For now, we are going to stick to official Blizzard API functions to create things in World of Warcraft. The above code has a few arguments that the function takes. The things inside the paranthesis are arguments.

###### First Argument

The `CreateFrame` global function accepts 4 arguments. The first is the kind of frame CreateFrame will create. In our case, we're sticking with `"Frame"`, but there are others like `"Button"`, `"ScrollFrame"`, etc. that can be used.

###### Second Argument

The second argument the function looks for is the name. This is not always needed, but in most cases, a name should be provided. We're using `"MyAddonMainFrame"` as the frame's official name. This will make things easier to debug in-game when using `/fstack` to debug our frames.

###### Third Argument

The third argument the function expects is the parent name. Every frame must have a parent. In our case, our addon is just coming to life and has no other parents that we've created, so we're using `UIParent` meaning the frame's parent is basically the game.

###### Fourth and Final Argument

The fourth and final argument the function expects is the template being used. This is an optional argument and isn't needed. Some frames don't need templates, but in our case we're using one. `"BasicFrameTemplateWithInset"` ensures that the frame we create will use the template named and include ease-of-use features like the close button.

---

### Step 2: Adjusting the Frame

Now that the frame has been created, we need to adjust it to our liking. For instance, we need to set a size for the frame. The frame does not have a default size, position, etc. That's all for us to decide. To start, we're going to set a size using a different function called `SetSize()`. `SetSize()` takes two arguments, an X and Y in units. We're making our frame 500x350 pixels in this case. The entire code so far should appear as such:

###### First Argument

X - How wide is the frame going to be?

###### Second Argument

Y - How tall is the frame going to be?

```lua
local mainFrame = CreateFrame("Frame", "MyAddonMainFrame", UIParent, "BasicFrameTemplateWithInset")
mainFrame:SetSize(500, 350)
```

Next, we'll need to set the position of the frame within our client. To do this, we use the function `SetPoint()`. This function expects 1 additional mandatory argument (besides itself, which is already called in SetPoint()) but can take up to 5 additional total arguments, 4 of which are optional. For our purposes, we're going to use all 5.

###### First Argument

The starting point of the region. We're going to use `"CENTER"` in all uppercase.

###### Second Argument

The relativeTo argument. We need to tell this frame basically what we're parenting it to. In our case, it's the game, so it will still be `UIParent`.

###### Third Argument

The relativePoint argument expects the other region to anchor to. In our case, we're sticking with `"CENTER"`.

###### Fourth and Fifth Argument

These are the offset-X and offset-Y arguments. We'll be using 0's for our purpose, causing the frame to start directly in the center of the screen.

Your code should look as such:

```lua
local mainFrame = CreateFrame("Frame", "MyAddonMainFrame", UIParent, "BasicFrameTemplateWithInset")
mainFrame:SetSize(500, 350)
mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
```

This tells the code to make the frame 500x350 and center it directly in the middle of our screen. Now, we need to give the frame a title. There are a few ways we can do this, but learning short-hand methods to do this is the best way, so we're going to learn that.

---

### Step 3: Title the Frame

We're now going to title the frame by "tacking onto" our mainFrame variable. We can do this by concatenating with `.`'s to extend mainFrame. There are a few things we'll need to add for this: `TitleBg` and `title`. `TitleBg` is included with `"BasicFrameTemplateWithInset"` by default, so we can modify its height before adding a title into it.

```lua
mainFrame.TitleBg:SetHeight(30)
```

In this code, we're setting the height to the title background to 30 units. This will be enough to fit our title inside of it. Next, we'll add the title and define what it is, since the template does not come with one included in the frame. We can concatenate onto `mainFrame` to do this.

```lua
mainFrame.title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
```

You'll notice the code above is slightly different because of the function we're calling `CreateFontString`. This function expects a total of 2 additional mandatory arguments. A name for the font string, how it's applied to its parent and, optionally, what font is being used.

We're not done yet, though. We also need to position this title and instruct it what text we are going to show. We can do that with the below code and its arguments.

```lua
mainFrame.title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
mainFrame.title:SetPoint("TOPLEFT", mainFrame.TitleBg, "TOPLEFT", 5, -3)
mainFrame.title:SetText("MyAddon")
```

You'll notice we're attaching `mainFrame.title` to `TitleBg` as its parent. Using `SetPoint()` and `SetText()` we can position and give text to the title.

---

### Step 4: Save and Check

Go ahead and save your .lua file. You can login or `/reload` your game if you're already logged in to check how the window looks. You'll notice fairly quickly that the window shows when you reload or login. We're going to fix that really quick by appending `mainFrame:Hide()` to the end of our currently written code.

Currently, your code should look like:

```lua
local mainFrame = CreateFrame("Frame", "MyAddonMainFrame", UIParent, "BasicFrameTemplateWithInset")
mainFrame:SetSize(500, 350)
mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
mainFrame.TitleBg:SetHeight(30)
mainFrame.title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
mainFrame.title:SetPoint("TOPLEFT", mainFrame.TitleBg, "TOPLEFT", 5, -3)
mainFrame.title:SetText("MyAddon")
mainFrame:Hide()
```

Finally, we're going to add a bit of code to make the frame interactable, movable and make sound when opened and closed. This code is fairly straightforward but some of the things we use in the below code will be explained later in more detail. Go ahead and append this below block of code to your current code:

```lua
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
```

Just for a little bit of context, `PlaySound()`, `StartMoving()` and `StopMovingOrSizing()` are all global functions that Blizzard's API supports. We will dive into more API in the future, and for the most part, you won't need to know exactly how the ones above function in order to use them.

Let's [move onto the next step of the tutorial](https://google.com)!
