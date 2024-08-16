# Part 1: A Fresh Start

Difficulty: 🟢 Easy

### So, you want to make a World of Warcraft addon?

Good news! This small series will show you how to build an addon from scratch. We won't be using any libraries to begin with. There's just something about coding an addon from scratch that hits the spot... but we will eventually reach a point where we use a library - to create a minimap button. Trust me, you don't want to do this yourself.

First, a little bit about me:

> I am a new-ish World of Warcraft addon developer that ran into a few issues creating my first few addons. Now, with all of those things ironed out, I'm here to help other new, aspiring addon developers.

To start, we're going to cover a few semi-important things.

* This addon guide is written using World of Warcraft: Classic (Season of Discovery) as a base. Though, most of the things in this guide can be used on any version of World of Warcraft. Some API may differ between game versions.
* We will be primarily using Visual Studio Code (VSCode) to code this.
  * Before starting, you'll want to install VSCode and then install a few extensions that are helpful for us. You can also use Project IDX (Google) and install these extensions with their appropriate VSIX files.
    1. Ketho's WoW API
    2. Septh's WoW Bundle
    3. Stanzilla's WoW TOC
  * We'll also want to grab a couple useful development addons. You can get these directly from Curseforge.
    1. DevTools
    2. TextureAtlasViewer
* This guide covers the following:
  * Creating frames
  * Creating variables, saved variables and functions
  * Creating frames that listen to events
  * Learning general Lua language syntax
  * Debugging and testing your addon
  * Creating a Github repository to store your addon code and manage versions
  * Publishing your addon to Curseforge

### We are going to be building an addon that records the total number of kills a character has and the total amount of gold they gain.

Let's get into the first part:

---

### Step 1: Your .TOC File

First, we'll need to make a folder for your addon to live. Navigate to your World of Warcraft install folder and into Interface/AddOns. In this folder we will make a new folder. Name this folder the same name you'll be giving your addon. In this case, I'll create a folder called "NoxxAddon" - I know, very original of me.

In this folder, you're going to create a new file. It will be called "NoxxAddon.toc" in my case, and this is where all of your addons settings will reside. You can name this your addon's name and add .toc to the end. Inside of this .toc file, we will paste the following:

```
## Interface: 99999
## Title: Your Addon Name
## Notes: Describe your addon.
## Author: Your Name
## Version: 1.0.0
## RequiredDeps:
## X-Curse-Project-ID: 999999
## SavedVariables:
## SavedVariablesPerCharacter:
```

Now, there are a few things we need to modify:

* Interface Number
* Title
* Notes
* Author
* X-Curse-Project-ID

##### Interface

To start, let's get that Interface number out of the way. To get the interface version you are developing your addon for, head into World of Warcraft and paste the following in your chat box and press 'Enter.'

```
/dump select(4, GetBuildInfo())
```

The number that prints is the game's interface version. If this number is not up to date, players who use your addon will get an Outdated error when attempting to load World of Warcraft or when they open their addon list. Make sure to update this number with each WoW version release.

##### Title, Notes & Author

For your Title, Notes and Author fields, just fill out your addon's name, a description of your addon and of course your name for the author field.

##### X-Curse-Project-ID

For this field, we will leave it as all 9's until we upload our addon to Curseforge for people to download. Once we have our project created with Curseforge, we will be able to find our project's unique ID and put it here.

*Let's proceed to Step 2, where we'll be officially building your addon's first file!*

---

### Step 2: MyAddon.lua

World of Warcraft addons are coded using a language known as Lua. It's a very straightforward language and is easy to learn once you get rolling. We're going to start by creating a new file in your addon's folder. I will be naming mine "NoxxAddon.lua" - keeping our file names consitent. At this point you should have the following folder setup:

* MyAddonFolder
  * MyAddon.toc
  * MyAddon.lua

If you have this set up correctly, we're going to move on and make sure this file is referenced in our .toc file so it loads. Before we reference this file in our .toc file, let's add a **Print** statement to make sure it loads correctly. In your .lua file we've just created, copy and paste this line of code, or change it to your liking:

```lua
print("MyAddon successfully loaded!")
```

Once you've saved your Lua file, let's head back into our .toc file and add our .lua file so it loads when we login to World of Warcraft. Open your .lua file and add the file name to the bottom. It should look as such (keep your interface number, title, etc.):

```
## Interface: 11502
## Title: NoxxAddon
## Notes: An addon that does nothing yet.
## Author: Noxxious
## Version: 1.0.0
## RequiredDeps:
## X-Curse-Project-ID: 99999
## SavedVariables:
## SavedVariablesPerCharacter:

NoxxAddon.lua
```

Once we have this saved, go ahead and load into WoW (or /reload if you're already logged in) and check your chat box to find your message printed. If it prints, you've successfully created and loaded your first addon!

Now for the sake of this tutorial, we'll be creating an addon that has a settings interface with a few simple settings and a main addon window. The main function, albeit kind of lame, will be a "Slayer" booklet of sorts:

* Log the amount of NPC kills the player has.
* Log the amount of gold looted since the addon has been installed.
* Add settings to:

  * Disable/Enable the tracking of these stats.
  * Reset the player's log.

Go ahead and move to the [second part of the tutorial](https://google.com) when you're ready!
