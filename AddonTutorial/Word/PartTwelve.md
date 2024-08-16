# Part 12: Creating a Minimap Button
### Using LibDBIcon 1.0 and Ace3 (WoW Addon Libraries)

Difficulty: 🟡🟡 Medium

**We've made it pretty far! This will bet the second to last step of our addon creation, where we'll be covering quality of life changes in Part 13! Let's get started with *using libraries*!**

---

## Step 1: Downloading and Installing the Libraries

The very first thing we'll need to do is to download and install two libraries to the folder ***for our addon***, and an image for our minimap button icon:

* Download LibDBIcon-1.0
* Download Ace3
* Download Image

Let's find these resources below.

1. We can find the LibDBIcon-1.0 Library download [here](curseforgedownload).

2. We can find the Ace3 Library download [here](curseforgedownload).

3. We're also going to need to download an image for our minimap button. This image needs to be a power of 2 in order to work, and typically should be in .TGA format. I recommend using a 512px square image. *If you cannot find a suitable image, you can [download and use the image here](image).*

Make sure to download the .zip files and don't install the addons directly to World of Warcraft, as this won't do much for us.

Once you have the files downloaded, extract the folders inside to the folder that contains your **main .lua file**.

The image file should be in the same folder that contains your **main .lua file** for the purposes of this tutorial. It should be named `minimap.tga`, as the code below will be looking for that image specifically.

But, let's take it a step further, and create a **NEW** folder for our libraries to live inside of. In your addon's folder, create a new folder called `libs`. Place our `LibDBIcon-1.0` folder and `Ace3` folder inside of it.

Your folder structure should now align as follows:

* MyAddon (your addon folder)

  * libs (folder)
    * LibDBIcon-1.0 (folder)
    * Ace3 (folder)

  * minimap.tga (image)
  * MyAddon.lua
  * MyAddon.toc
  * Settings.lua

Once you have **LibDBIcon** and **Ace3** installed into the `libs` folder for your addon, we'll need to tell our .toc file about them.

Let's modify our .toc file to appear as such:

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
# Libraries
libs/Ace3/AceAddon-3.0/AceAddon-3.0.lua
libs/Ace3/AceDB-3.0/AceDB-3.0.lua
libs/LibDBIcon-1.0/embeds.xml

# Main Files
MyAddon.lua
Settings.lua
```

We added `#Libraries` and `#Main Files` to our .toc file for ease of organization. Your library files should always load first, so they are *above* our other .lua files.

Now that we have our .toc file updated and our LibDBIcon files installed, let's create our button!

---

## Step 2: Creating the Minimap Button

To create the minimap button, we need to register our addon with the `Ace3` and `LibDBIcon-1.0` libraries by declaring a couple variables. Let's throw all of this code at the bottom of our `Settings.lua` file so we can keep track of it.

Go ahead and append the following code to the bottom of `Settings.lua`:

```lua
local addon = LibStub("AceAddon-3.0"):NewAddon("MyAddon")
MyAddonMinimapButton = LibStub("LibDBIcon-1.0", true)
```

The code above allows us to register `"MyAddon"` with the `Ace3` and `LibDBIcon-1.0` libraries through `LibStub()`.

Now that we're registered, let's go ahead and put the rest of our code for the minimap button below the above code we added:

```lua
local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject("MyAddon", {
	type = "data source",
	text = "MyAddon",
	icon = "Interface\\AddOns\\MyAddon\\minimap.tga",
	OnClick = function(self, btn)
        if btn == "LeftButton" then
		    MyAddon:ToggleMainFrame()
        elseif btn == "RightButton" then
            if settingsFrame:IsShown() then
                settingsFrame:Hide()
            else
                settingsFrame:Show()
            end
        end
	end,

	OnTooltipShow = function(tooltip)
		if not tooltip or not tooltip.AddLine then
			return
		end

		tooltip:AddLine("MyAddon\n\nLeft-click: Open MyAddon\nRight-click: Open MyAddon Settings", nil, nil, nil, nil)
	end,
})

function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("MyAddonMinimapPOS", {
		profile = {
			minimap = {
				hide = false,
			},
		},
	})

	MyAddonMinimapButton:Register("MyAddon", miniButton, self.db.profile.minimap)
end

MyAddonMinimapButton:Show("MyAddon")
```

We won't go into great detail how this code works, as most of this is pulled from the documentation provided by the libraries. But, we can pick out a couple things to note:

* We have an `OnClick` function being called, and within that function there is another function we have not yet written called `MyAddon:ToggleMainFrame()`. We will write this function in our other .lua file in a moment.

* There is a `tooltip:AddLine()` function being called. This will show a tooltip when a person hovers over the minimap button. We always want to make sure this gives instructions to the user on how to operate the minimap button.

Now, let's get to creating our `MyAddon:ToggleMainFrame()` function.

---

## Step 3: Creating the `MyAddon:ToggleMainFrame()` Function

This code is fairly simple, and we've already used it previously, but we're defining it as a global variable so we can call it across files.

First, we're going to throw this code at the top of our **main .lua file**.

```lua
MyAddon = MyAddon or {}
```

Here, we initialized `MyAddon` with a `blank` or `nil` state.

Next, put the below code ***at the bottom*** of your other **main .lua file**.

```lua
function MyAddon:ToggleMainFrame()
    if not mainFrame:IsShown() then
        mainFrame:Show()
    else
        mainFrame:Hide()
    end
end
```

You'll notice that we did not declare this function using `local`, meaning this can be called by **any** addon that wants to call it.

This is useful if you ever create an addon that another addon may want to use as a dependency, or for API purposes that gathers information that your addon can easily access.

In our case, we're defining it globally so we can call it inside of our `Settings.lua` file from our main .lua file.

*Now...*

## We're officially done developing MyAddon!

**Congratulations on developing your first World of Warcraft addon!** Go ahead and test it! Play around with it! Make changes to it! Delete it and start your own addon! Whatever you want to do from here is all you!

### However, there is still more to learn!

The next tutorial is going to be a *quaility of life* tutorial, and you can [find me in Part 13](https://reddit.com/r/wowaddondev) for that. 

At the end of *that* tutorial, there will be a **bonus task set** that I think you'll really like. At the end of **that** tutorial, we will be providing all the code to the addon in that state.