# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


export YARN_GLOBAL_PREFIX=$HOME/.yarn/
export PATH="$HOME/opt/bin:$YARN_GLOBAL_PREFIX/bin/$HOME/go/bin:$HOME/.local/bin:$PATH"

# Compilers
export CC=clang
export CXX=clang++
export CMAKE_CXX_COMPILER_LAUNCHER=ccache
export CMAKE_C_COMPILER_LAUNCHER=ccache
export CMAKE_EXPORT_COMPILE_COMMANDS=1
export CLICOLOR_FORCE=1

# Yubikey
export SSH_AUTH_SOCK=`gpgconf --list-dirs agent-ssh-socket`
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye > /dev/null

function smartcard() {
    local retval=0
    case $1 in
        'load')
            local server
            server=$(smartcard keyserver) && \
                gpg --fetch-keys $server && \
                gpg --card-status && \
                ssh-add -K && \
                smartcard reload
            retval=$?
            ;;
        'reload')
            local key
            key=$(smartcard key) && \
                gpg-connect-agent "scd serialno" "learn --force" /bye && \
                git config --global user.signingkey $key
            retval=$?
            ;;
        'key')
            local key
            key=$(gpg --card-status) && \
                key=$(echo $key | grep 'General key info') && \
                key=$(echo $key | awk -F'/' '{print $2}') && \
                key=$(echo $key | sed 's/ .*//') && \
                echo $key
            retval=$?
            ;;
        'keyserver')
            local server
            server=$(gpg --card-status) && \
                server=$(echo $server | grep 'URL of public key') && \
                server=$(echo $server | awk -F': ' '{print $2}') && \
                echo $server
            retval=$?
            ;;
        *)
            echo "invalid argument:" $1
            retval=1
            ;;
        esac
    return retval
}

# NVM
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # Load NVM
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # NVM bash completion
#
#nvm use node > /dev/null

# Shell utils
alias pbcopy='xclip -selection clipboard'
alias ls='ls --color=auto'
