#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
export TERMINAL="termite"

# Auto-activate/deactivate virtualenvs
function detect_venv {
    if [[ ! -z "$VIRTUAL_ENV" ]]; then
        if [[ "$_DIR" != "$PWD" ]] && grep --silent -v "$_DIR" <<< "$PWD"; then
            deactivate
            return
        fi
        # PS1="\[\033[0;37m\](\$(basename $VIRTUAL_ENV))${PS1}"
        PS1="(\$(basename $VIRTUAL_ENV))${PS1}"
        return
    fi

    declare -a possible_venvs
    possible_bin_dirs=$(find ${PWD} -maxdepth 2 -type d -name "bin" 2> /dev/null)
    
    for dir in $possible_bin_dirs; do
        results=$(find $dir -maxdepth 1 -type f -name "activate" 2> /dev/null)
        for file in $results; do
            grep --silent "deactivate ()" $file
            if [[ "$?" == 0 ]]; then
                possible_venvs+=($file)
            fi
        done
    done
    
    if [[ ${#possible_venvs[@]} -eq 1 ]]; then
        source ${possible_venvs[0]}
    elif [[ ${#possible_venvs[@]} -gt 1 ]]; then
        printf "Multiple possible python VirtualEnvs found, source?\n"
        i=0
        for x in ${possible_venvs[@]}; do
            printf "%d: %s\n" "$i" "${possible_venvs[$i]}"
            i+=1
        done
        read choice
        if [[ ! -z "$choice" ]]; then
            source ${possible_venvs[$choice]}
        fi
    fi

    export _DIR=$PWD
}

. ~/.git-prompt.sh

#Git prompt
PROMPT_COMMAND='GIT_PS1_SHOWCOLORHINTS=1;\
    GIT_PS1_SHOWDIRTYSTATE=1;\
    __git_ps1 "\[\e[1;33m\][\d \t \w\[\e[m\]" "\[\e[1;33m\]]\$\[\e[m\] ";'"detect_venv"


# Aliases
alias i3ed="vim ~/.config/i3/config"
alias vimed="vim ~/.vimrc"
alias dev-backup="drive push -depth 99 -destination /cauldron-dev /home/thad/dev"
alias xclip="xclip -selection clipboard"
alias k="kubectl"

# Custom env vars
export GOPATH="/home/thad/dev/go"
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/thad/dev/go"

# Make dir colors readable
LS_COLORS=$LS_COLORS:'di=0;36' ; export LS_COLORS

# Enable Z
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/thad/google-cloud-sdk/path.bash.inc' ]; then . '/home/thad/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/thad/google-cloud-sdk/completion.bash.inc' ]; then . '/home/thad/google-cloud-sdk/completion.bash.inc'; fi
