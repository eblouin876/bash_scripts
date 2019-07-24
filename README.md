# bash_scripts
Useful bash scripts related to git. The file goes in ~/.bash_profile as an import (see below)

## setup
Create a .env file in the same directory that includes email="", pass="", and adminpass="" with your respective email and passwords (used in some of the scripts)

## Checkout
Run ```checkout``` in terminal and it will either switch to a branch if it exists or ask if you want to create a new branch with that name

## Commit
Run ```commit``` in terminal and it will capture all text after and put it in as your commit message. (No quotes necessary) Takes a -a flag if you want to commit all tracked files (like git commit -am). If there are staged changes it will commit those with the message provided. If there are no staged changes but modified files it will prompt you to select files to include in the commit. If there are no staged changes and only a single modified file, it will automatically stage that file and commit it. If there are untracked files, it will prompt asking if you want to add any of them to commit.

## Delete Branch
Run ```dbranch \branch-name\``` in terminal and it will capture the branch name passed in and delete it as well as the remote repository for that branch. This will throw an error if you try to delete the branch you are on, master, beta, staging, or production.

## Open
This requires a directory at ~/work and for vscode command line integration. It will open the file ~/work if you run ```copen``` by itself, or will open ~/work/#filename# if you run ```copen #filename#```

## Pull
This can be used in two ways. If you run ```pull``` in a directory that has git, it will pull from whatever branch you are currently on. If you run ```pull #branchname#```, it will pull from the branch name you pass in.

## Push
This can also be used in two ways. If you run ```push``` in a directory that has git, it will push to whatever branch you are currently on. If you run ```push #branchname#```, it will push to the branch you pass in.

## Update
This works in a couple of different ways. It only works if you have a ~/work directory. If you run ```update``` in a git directory, it will store your unsaved changes, checkout and update beta, staging, and master, checkout the branch you were on when you started, and reapply all changes.
You can also run ```update #filename#```, and it will do the same for the project you pass in as long as that project is in your ~/work directory.

## Update All
This method runs update for all the projects in your ~/work directory. Run ```updateAll``` in terminal.

## Branches
```branches``` prints out all local and remote branches with their last commit message.

## Git Diff (wrapper)
```gd``` prints out ```git diff``` but excludes gemfile.lock and yarn.lock. It can also take an argument and show the difference between your local file and the remote version of the input branch name. E.g. ```gd <inputBranch>``` is like running ```git diff remotes/origin/<inputBranch>..<currentBranch>```

## Status
```status``` is a wrapper around ```git status```

## Import DB
```importDb``` takes two arguments, the name of the database you are importing into and the filepath for the file you are importing. It will prompt you for your password.

## Drop
```drop``` gets rid of any uncommitted changes that you have made. **This is not reversible**

## Stash (wrapper)
```stash``` will stash any changes that are made. Any text after stash will be captured as the stash message. (No quotes necessary)

## Reload
```reload``` updates your current terminal instance and imports .bashrc and .bash_profile, so any changes made can be brought into that instance of the window

## ~/.bash_profile
```
[[ -f ~/.scripts/bashMethods.sh ]] && source path/to/bashMethods.sh

if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  GIT_PROMPT_ONLY_IN_REPO=1
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi
```
