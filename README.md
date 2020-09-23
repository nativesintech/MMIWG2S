# MMIW AR Face Mesh App WOOOHOOOO This is fun

## Project
Our goal is to bring awareness to MMIW through the use of augmented reality face meshing technology. Users will learn about MMIW and then be able to take a picture with the iconic red hand over their face. They will then be able to share that picture with whatever social media or device they choose.  
[Project Specs](PROJECT_SPECS.md)

### Team Members (In joining order)
Stephen (Mehequanna) Emery, *Chickahominy Eastern* - Product Owner (and Android, iOS as I can)  
Rachel Emery - Researcher and the reason the project got started  
Mark Amaro, *Quechua* - iOS  
Teressa Chizeck - UI/UX Design  
Caleb Paul - Android  
Callum Johnston - iOS  
Hằng Dao - Quality Assurance  
Kaitlyn Anderson - Android  

## Things to know
This is a mono-repo, so check each folder's README to learn about each piece.

### iOS
We will write the iOS portion using Swift and Google's ARCore. We will use the repo's Projects section to manage tickets.

[iOS Readme](iOS/README.md)

### Android
We will write the Android portion using Kotlin and Google's ARCore.

[Android Readme](Android/README.md)

### Web/Database/Backend

TBD - There's an idea to have each user share their photos to a central location
and we can have a large collage. A bit of a stretch goal at the moment.

### Merging
Before merging, we should use 1 of 2 paths.  
Path 1, We want to do a defensive merge of `main` into our branch.  
• From your ready to be merged branch, run in terminal: `git checkout main`  
• Then run `git fetch` and `git pull`  
• Then go back to your branch by running, `git checkout -`  
• Run `git status` to make sure you are in your branch.  
• If you are in your branch, run `git merge main`  
• From here, deal with any conflicts, make sure your code runs as expected, and all looks good.  
• Finally, run `git push`.

Path 2, is the interactive squash and rebase on to main.  
Feel free to use this one if you know it. Otherwise ask for help first or don't use it. You can lose work this way.  
If you run into problems with the below, run `git rebase --abort` and ask for help.

• From your ready to be merged branch run in terminal: `git checkout main`  
• Then run `git fetch` and `git pull`  
• Then go back to your branch by running, `git checkout -`  
• Run `git status` to make sure you are in your branch.  
• Then run, `git rebase -i main`  
• You will see a list of your commits. Leave `pick` on the first commit on your branch.  
If you see commits before your branch commits start, press `i` and replace `pick` with `d` for drop on commits not on your branch.  
For all other commits from your branch, use `i` to replace `pick` with `s` for squash.  
• Hit `esc` on the keyboard and press `shft + z, z`. This will save and close Vim.  
• If you have squashed any commits, then you will see another screen with all your commit messages.  
You can keep those and just press `shft + z, z` again to save and quit Vim.  
• Run `git status`. You will see a message about your branch having diverged from origin.  
After making sure you are on your branch, you can run `git push -f` to force push your branch back up to github.  
• Your branch should be now rebased onto the tip of `main` branch and be ready to merge.

Tip:
When squashing, you may need to fix a merge conflict more than once.  
You can get around this by running these two commands in terminal:  
`git config --global rerere.enabled true`  
`git config --global rerere.autoupdate true`  
