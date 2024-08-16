# Part 13: Quality of Life Changes

Difficulty: 🟢 Easy

**Congratulations on *finishing* your first World of Warcraft addon! Below, we'll cover some quality of life changes we can make that you *may* have noticed while developing the addon. Let's get into it!**

---

## Final Step: Our Big QoL Change!

Our big quality of life change is... you guessed it! The `gold`, `silver` and `copper` display text in our addon's interface!

This was (purposely) made poorly. In an effort to get it working, we skimped on the appearance of this information to the player. Not only was it horrible looking, but it was syntactically wrong. We're going to correct that now.

There are several ways to improve this: icons, colored text, etc. We're going to take the colored text route for now. Feel free to try and add icons for the coins yourself! It's challenging but fruitful! For now, let's make some changes.

In our **main .lua file**, let's find our `mainFrame.totalCurrency` property. We're going to make a slight modification. On the `SetText()` line, we're going to change it to:

```lua
mainFrame.totalCurrency:SetText("Total Currency Collected:")
```

This is going to be our "start line" for our currency display. Next, we're going to add some more FontStrings that will display our `gold`, `silver` and `copper` separately, with some color!

Let's add this code right under the line we just modified!

```lua
mainFrame.currencyGold = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.currencyGold:SetPoint("TOPLEFT", mainFrame.totalCurrency, "BOTTOMLEFT", 10, -15)
mainFrame.currencyGold:SetText("|cFFFFD700Gold: |cFFFFFFFF" .. (MyAddonDB.gold or "0"))
mainFrame.currencySilver = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.currencySilver:SetPoint("TOPLEFT", mainFrame.currencyGold, "BOTTOMLEFT", 0, -15)
mainFrame.currencySilver:SetText("|cFFC7C7C7FSilver: |cFFFFFFFF" .. (MyAddonDB.silver or "0"))
mainFrame.currencyCopper = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.currencyCopper:SetPoint("TOPLEFT", mainFrame.currencySilver, "BOTTOMLEFT", 0, -15)
mainFrame.currencyCopper:SetText("|cFFD7BEA5Copper: |cFFFFFFFF" .. (MyAddonDB.copper or "0"))
```

You'll notice `|cFF` and `|r` are used to **color the text** and **reset the text color**.

The code following `|cFF` is `HEX` color coding. For example, red text would be: `|cFFFF0000`.

`|cFF` + `FF0000` (Hex Color Code)

Use `|r` to reset your text color **1 level**. By that I mean, if you use multiple `|c` color codes without using `|r`, you can overlap colors just fine, but using `|r` will only revert one level of color change back. Let me give an example:

`SetText("This is default yellow. |cFFFFFFFFThis is White! |cFFFF0000This is red! |r This is back to white, not default yellow!")`

Hopefully that clears it up a bit!

Go ahead and login or `/reload` your game to checkout the change we made! Visually, it should align much better with our standards! Once again, you can take this a step further and incorporate the icons into the text and make it pop even more!

We're also going to delete `totalCurrency:SetText()` from the `"OnShow"` script for `mainFrame` and add our `gold`, `silver` and `copper` currency strings instead.

The code, in its entirety for `mainFrame:SetScript("OnShow", function()`, should look like this:

```lua
mainFrame:SetScript("OnShow", function()
    PlaySound(808)
    mainFrame.totalPlayerKills:SetText("Total Kills: " .. (MyAddonDB.kills or "0"))
    mainFrame.currencyGold:SetText("|cFFFFD700Gold: |cFFFFFFFF" .. (MyAddonDB.gold or "0"))
    mainFrame.currencySilver:SetText("|cFFC7C7C7FSilver: |cFFFFFFFF" .. (MyAddonDB.silver or "0"))
    mainFrame.currencyCopper:SetText("|cFFD7BEA5Copper: |cFFFFFFFF" .. (MyAddonDB.copper or "0"))
end)
```

We can also go down a bit further in the code and do the *same thing* inside of our `eventHandler` function for `if mainFrame:IsShown() then` `if then` statement. The full code here should look as such:

```lua
if mainFrame:IsShown() then
        mainFrame.totalPlayerKills:SetText("Total Kills: " .. (MyAddonDB.kills or "0"))
        mainFrame.currencyGold:SetText("|cFFFFD700Gold: |cFFFFFFFF" .. (MyAddonDB.gold or "0"))
        mainFrame.currencySilver:SetText("|cFFC7C7C7FSilver: |cFFFFFFFF" .. (MyAddonDB.silver or "0"))
        mainFrame.currencyCopper:SetText("|cFFD7BEA5Copper: |cFFFFFFFF" .. (MyAddonDB.copper or "0"))
    end
```

---

## We're done! Our addon is functioning perfectly (for now, and without *much* testing)!

We can test this some more and call it a day, or we can go *one* step further with a few bonus tasks and include some nice, new, shiny features! If you feel like giving that a go, let's do it! Click below for the *bonus tasks*!

### [Take me to the Bonus Tasks! NOW!](reddit.com/r/wowaddondev)