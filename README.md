# bash_scripts
Useful bash scripts related to git. The file goes in ~/.bash_profile as an import 

## Checkout
Run ```checkout``` in terminal and it will either switch to a branch if it exists or ask if you want to create a new branch with that name

## Commit
Run ```commit``` in terminal and it will capture all text after and put it in as your commit message. Like running ```git commit -am ""```

## Delete Branch
Run ```dbranch \branch-name\``` in terminal and it will capture the branch name passed in and delete it. This will throw an error if you try to delete the branch you are on, master, beta, staging, or production.

## Open
This requires a directory at ~/work and for vscode command line integration. It will open the file ~/work if you run ```copen``` by itself, or will open ~/work/#filename# if you run ```copen #filename#``` 

## Pull
This can be used in two ways. If you run ```pull``` in a directory that has git, it will pull from whatever branch you are currently on. If you run ```pull #branchname#```, it will pull from the branch name you pass in.

## Push
This can also be used in two ways. If you run ```push``` in a directory that has git, it will push to whatever branch you are currently on. If you run ```push #branchname#```, it will push to the branch you pass in.

## Update
This works in a couple of different ways. Like open, it works best if you have a ~/work directory. If you run ```update``` in a git directory, it will check to see if you are on beta or master and pull from the appropriate branch. If you are on another branch, it will ask if you want to pull from beta or master. 
You can also run ```update #filename#```, and it will pull from either the beta or master branch that project is currently on as long as that project is in your ~/work directory.

## ~/.bash_profile
```eval "$(rbenv init -)"
[[ -f ~/.scripts/bashMethods.sh ]] && source ~/.scripts/bashMethods.sh

    PS1='\n'                           # begin with a newline
    PS1=$PS1'\[\e[38;5;101m\]\! \t '   # time and command history number
    PS1=$PS1'\[\e[38;5;106m\]\u@\h '   # user@host
    PS1=$PS1'\[\e[38;5;33m\]\w '        # working directory
    PS1=$PS1'\[\e[0;36m\]$(git_branch_4_ps1) ' # git_branch_4_ps1 defined below
    [[ -z $(git status -s) ]] || PS1=$PS1'\[\e[0;31m\]*modified*'
   # PS1=$PS1'\[\e[38;5;33m\]\w'        # working directory
    PS1=$PS1'\n\[\e[32m\]\$ '          # "$"/"#" sign on a new line
    PS1=$PS1'\[\e[0m\]'                # restore to default color

    function git_branch_4_ps1 {     # get git branch of pwd
        local branch="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
        if [ -n "$branch" ]; then
            echo "($branch)$DIRTY"
        fi
    }

if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  GIT_PROMPT_ONLY_IN_REPO=1
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi
```
