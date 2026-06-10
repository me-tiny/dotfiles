export DOTFILES="$HOME/.dotfiles"
export HISTFILE="$ZDOTDIR/.zsh_history"

export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim +Man!"

typeset -U path PATH
path=(
    $ZDOTDIR/scripts
    $HOME/.cargo/bin
    $HOME/.local/bin
    $path
)
