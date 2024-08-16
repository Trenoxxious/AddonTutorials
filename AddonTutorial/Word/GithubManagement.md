# Managing a GitHub Repository

**A GitHub repository helps manage your code-base by providing version control tools to you for free.** Things like reviewing history of your code changes can save you countless headaches in finding where you may have made a mistake and broke something. When you get into the heat of coding, you can make several hundred or thousand adjustments and snuff something without realizing it until after the commit. This will help you find and revert or fix that change. Not to mention, you can directly update your Curseforge addon when you commit changes. Let's get into it.

> This walkthrough assumes that you already have an addon created and VSCode setup. This is also going to be an extremely beginner-friendly walkthrough of setting up and managing a GitHub Repository in the most simple sense to get you started. We'll be using the VSCode Source Control GUI to do everything. No command line experience is necessary. No prior experience in Git at all is necessary.

In this walk through, we'll be attempting to accomplish the following:
* Create a New GitHub Account
* Create a New GitHub Repository (in the easiest way, via VSCode directly)
* Define the Initial Commit
* Setup Curseforge to Use GitHub
* Learn How to Clone a GitHub Repository

## What is GitHub?

GitHub is a verson control system for code that helps you organize your code and manage changes to your code. GitHub has a system to help control code that will help you even work on code alongside other developers using a `Push` and `Pull` system. When you make changes to your code, you can "upload" those changes in the form of a `Commit` to GitHub and your code will be updated with the changes you make.

You can think of this even more simply as: Let's say you build a website to host all of your code's files. When you make a change, instead of re-uploading the file with its changes and overwriting the files, GitHub manages these things for you, inserting changes into the files or replacing the files if necessary. GitHub recommends you do not exceed a file storage limit of 5GB or you may run into issues.

## How can I get started?

First, we're going to head over to [GitHub](https://github.com/) to create a new account. Follow the prior link here and click 'Sign Up' to create an account.

Once you have an account created, note the username and password you signed up with as you will need it in a bit. Make sure to also set up 2FA (two factor authentication) so your code cannot be manipulated by anyone that should not have access to modify it. It's the standard in account security and we should always be following it when possible.

Once you have the account created and 2FA setup, let's move back into VSCode and initialize a GitHub Repository.

## Initializing Our Repository

With VSCode open, if you don't already, open the main folder to your addon. On the left side of the VSCode screen, next to where it shows the hierarchy of your files, you'll see a symbol with 3 circles and connecting lines. When hovered, it will show `Source Control` as the tab name. Click that tab.

You'll likely be prompted to sign in to your GitHub account. Go ahead and sign in.

Once signed in, you'll see a button that says `Initialize Repository` and we'll want to click that. You'll notice that the window changes, showing all of the files you've made adjustments to. In our case, it should show *all* of your files since we've never committed them.

At the very top of this window, it will ask for a `Message (Ctrl + Enter to commit on "main")` and we'll want to enter a message here. Typically, our first commit should have the message of "Initial commit." Go ahead and type "Initial commit" in the `Message` box and press `Commit`. If you get a popup that asks if you'd like to stage your changes automatically, please answer `Yes` to this, and any additional following questions. This makes committing changes extremely quick.