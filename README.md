# bash_scripts
Useful bash scripts related to git. These must also be aliased in order to work. 

# Aliases:
alias checkout='sh ~/.scripts/checkout.sh'\
alias update='sh ~/.scripts/update.sh'\
alias pull='sh ~/.scripts/pull.sh'\
alias push='sh ~/.scripts/push.sh'\
alias copen='sh ~/.scripts/open.sh'\
alias dbranch='sh ~/.scripts/delete_branch.sh'\
alias commit='sh ~/.scripts/checkout.sh'

## Checkout
Run ```checkout``` in terminal and it will either switch to a branch if it exists or ask if you want to create a new branch with that name

## Commit
Run ```commit``` in terminal and it will capture all text after and put it in as your commit message. Like running ```git commit -am ""```

## Delete Branch
Run ```dbranch \branch-name\``` in terminal and it will capture the branch name passed in and delete it. This will throw an error if you try to delete the branch you are on, master, beta, staging, or production.

## Open
This requires a directory at ~/work and for vscode command line integration. It will open the file ~/work if you run ```copen``` by itself, or will open ~/work/#filename# if you run ```copen #filename#``` 

# Pull
This can be used in two ways. If you run ```pull``` in a directory that has git, it will pull from whatever branch you are currently on. If you run ```pull #branchname#```, it will pull from the branch name you pass in.

# Push
This can also be used in two ways. If you run ```push``` in a directory that has git, it will push to whatever branch you are currently on. If you run ```push #branchname#```, it will push to the branch you pass in.

# Update
This works in a couple of different ways. Like open, it works best if you have a ~/work directory. If you run ```update``` in a git directory, it will check to see if you are on beta or master and pull from the appropriate branch. If you are on another branch, it will ask if you want to pull from beta or master. 
You can also run ```update #filename#```, and it will pull from either the beta or master branch that project is currently on as long as that project is in your ~/work directory.
