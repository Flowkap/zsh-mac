export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

###############################################################################
# PATH etc.
###############################################################################

# Python
export PATH=/Users/fkappes/Library/Python/2.7/bin:~/.local/bin:$PATH

# JENV
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
# ensure that JAVA_HOME is correct
# jenv enable-plugin export
# make Maven aware of the Java version in use (and switch when your project does)
# jenv enable-plugin maven


###############################################################################
# functions
###############################################################################

# https://apple.stackexchange.com/a/346992
function macnst() {
    netstat -Watnlv | grep LISTEN | awk '{"ps -o comm= -p " $9 | getline procname;colred="\033[01;31m";colclr="\033[0m"; print colred "proto: " colclr $1 colred " | addr.port: " colclr $4 colred " | pid: " colclr $9 colred " | name: " colclr procname;  }' | column -t -s "|"
}

function git_recursive() {
    # Update all git directories below current directory or specified directory
    # Skips directories that contain a file called .ignore
    #
    # Originally: https://stackoverflow.com/questions/11981716/how-to-quickly-find-all-git-repos-under-a-directory

    HIGHLIGHT="\e[01;34m"
    NORMAL='\e[00m'

    OPERATION=status
    if [ "$1" != "" ]; then OPERATION=$@ > /dev/null; fi

    function update {
    local d="$1"
    if [ -d "$d" ]; then
        if [ -e "$d/.ignore" ]; then
            echo -e "\n${HIGHLIGHT}Ignoring $d${NORMAL}"
        else
        cd $d > /dev/null
        if [ -d ".git" ]; then
            echo -e "\n${HIGHLIGHT}Updating `pwd`$NORMAL"
            # echo $operation
            hub $OPERATION
        else
            scan * || true
        fi
        cd .. > /dev/null
        fi
    fi
    }

    function scan () {
        for x in $*; do
            update "$x" operation=$operation
        done
    }

    echo -e "${HIGHLIGHT}Scanning ${PWD}${NORMAL}"
    scan *
}

export GITLAB_TOKEN="CHANGEME"

function fail {
  echo $1 >&2
  exit 1
}

function retry {
  local n=1
  local max=8
  local delay=15
  while true; do
    "$@" && break || {
      if [[ $n -lt $max ]]; then
        ((n++))
        echo "Command failed. Attempt $n/$max:"
        sleep $delay;
      else
        fail "The command has failed after $n attempts."
      fi
    }
  done
}

###############################################################################
# custom extensions
###############################################################################

# Dock Settings
# defaults write com.apple.Dock autohide-delay -float 0; defaults write com.apple.dock autohide-time-modifier -float 0.5; killall Dock

#History bash_history 10Million
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000

alias idea='open -a "`ls -dt /Applications/IntelliJ\ IDEA*|head -1`"'

# make search up and down work, so partially type and hit up/down to find relevant stuff
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# Git stuff
alias git='hub'
alias gitr='git_recursive'
alias push='git push'
alias pull='git pull'
# git config --global alias.open '!f() { open $(cat .git/config | grep url | sed -r "s/.+url =//g" | sed -r "s/git@(.*):/http:\/\/\1\//g"); }; f'
# git config --global alias.co 'checkout'

# FUN
# alias csn='echo H4sIAG9GYVsAA51Yba7sIAj9P6swMRJiDGzB/a/qAmprp0o7l+S9O231HMAjfnw+n0/4txEDQAKUX/KE5X9QBWq3GEJqvyCXnH+Ho1RnC6GjIQXCWn9GvMKpcacQVxWx1t8gb3hmidoHZkgo6ZBs/uTqGlW9bOEzSYpTDKUyAr9Hvod/AUfo8JrpLA/4GtoFNvAuChQnsvkBL8EpAHjI3VpsJeX+8x16KZGqjNILgu5/b0rv8HPNMvop1McQ4Pib3utQswoIRSN/l6Ck0smio1eyiXj4Fh3oUmMMFXMjMKL4LkXEU2oX2TiMITDcgnzBMBHMo3wPJ6ZUSZR/5XhRA7OTmW8OrQWl4pXjkaJ86/PynLIMVBRoS5rUbS3eBZGYSumTPj1x0CoKjCmeky/hMr1AIwVPHGk7zdTlYkMic/FoLk+IHAqryuVffCAovMJOgWowbQm/KVleGN7sWg1Q1YEn0S6ngQyAJOeiWV0BbP2ilkhjlih7ifVZyqpaaF4UIVi6Tdck7rCwxFwUH4qIIGuD3v+BZRWKfjgSQ2hZSg00ckBRBBJw+zwGz6fBBYvh5fjlzoCl/pzb80iGS7PKGAzgcjTjadTH66bro5dfGPc0asTJHLnOlFITK1eWdJYTweOhE/0igC9LMD/FmZZe8eSFnuN3o1j1f84T9BzcMagu0bm+bQPK9qIkqcQBOWphmZhOT13BrWrMFxEPUBJvuujCmckpEx7RStdwbVKXHYfRO6K43DpcFHYbsauNlAgQefVtxVMvZVJNaz2dTzDpZYqokjOPNkS2lEw2pi0mKIY+XswZCfsVekdzCeBCGCFRmV5cFkXYCtzf3H1xnQTTgnoVU9oxuTxqGNaRbRE22XuzIXaZ7s3Xax7uc3fxoazZaNlzyfQiouHp4CIav3b5WDFBrsXbLd+s7bJla1ho7+VGET9sPk9rlXX3cafyn6mym7rqlb1faKAvTKuCPGxf9n7ZvR++peVOU83ZaD/Bh1M0UiKwL0y79DkHk4fJq6vhsWrTYy+HaD37DuvYGlY81tl9tfQWQZdnrLpYxSM6Q9o75q3rHhOOJhq7BFae8uDuIDzpWRCyJTYmxW9dtrp72B47TJY52bYi1wx2iCwPPfzTixsUVQkaEZj0Aksqnq9V//Tt9YQWRdTwOGVW2flTHe83p/ZaTp/QRpi1wqQ2U1Rz7TAZ+um0nflq7xcA7GUCsMKkj2gjHpfXU/WcirWPQNK/7aqs1bbG1b7EmSvYhDZxot7A2LqVzUm6c51qOnpr42iERkeXuCDsuWqLe2T2powRyyIsOwmFg4qZaeK4U/Xqa2EtLwPUAb1iaP62PMfO1+M+MmjGo1VeRYU9g3bQvl+rR70o1ePToLYfYAKpPURgjgddbeJBe6G5sqvE206vttuQ0F3h7hW3/dBXg9bBPmC/Hs8d5L6F7HElCzWFMdG5jgp6NuiPJrIBbO/SrqTZteJAOBufjtIphTEOTx7XcSetwWnfMUQdWCGjHY8mj1sYYdJANjITaTGhy2B+/gAOXKA2KRkAAA== | base64 -d | gunzip && sleep 5s && clear'
# alias sw='telnet towel.blinkenlights.nl'
# alias shruggie="echo -n '¯\_(ツ)_/¯' | xclip -selection clipboard; xclip -o -selection clipboard; echo -e '\n'"
# alias trendmicrosuckz='echo "Lost time due to the fact that TrendMicro suckz?"; gdate -d@$(( (($(history | grep "mvn clean test" | wc -l) + $(history | grep "mvn test" | wc -l)) * 6 * 60) + ($(history | grep "mvn clean compile" | wc -l) * 60))) -u +%H:%M:%S'
alias clean-idea='rm -rf .idea && find . -name "*.iml" -type f -delete'

###############################################################################
# Kubernetes
###############################################################################
export KUBE_EDITOR="nano"

source <(kubectl completion zsh) &> /dev/null
alias kc='kubectl'
alias kt="stern -s 1s -E linkerd-proxy $@"

alias sub='docker run -it --rm efrecon/mqtt-client sub -h host.docker.internal -p 1883'
alias pub='docker run -it --rm efrecon/mqtt-client pub -h host.docker.internal -p 1883'

alias mount-vault="hdiutil attach ~/vault.dmg -mountroot ~"

###############################################################################
# Powerlevel10k
###############################################################################

function prompt_my_vpn() {
    p10k segment -f 31 -t $(if [[ $(ifconfig | grep ppp0 ) ]]; then echo VPN; else echo LOC; fi)
}

# The list of segments shown on the left. Fill it with the most important segments.
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    dir                     # current directory
    vcs                     # git status
    # =========================[ Line #2 ]=========================
    newline                 # \n
    kubecontext             # current kubernetes context (https://kubernetes.io/)
    prompt_char             # prompt symbol
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    status                  # exit code of the last command
    time                    # current time
    my_vpn                  # FortiClient status
    wifi                    # wifi speed
    battery                 # internal battery
    # =========================[ Line #2 ]=========================
    newline                 # \n
    load                    # CPU load
    ram                     # free RAM
    disk_usage              # disk usage
)

POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|kc|helm'
#typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
