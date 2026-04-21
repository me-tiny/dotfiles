set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx MANPAGER "nvim +Man!"
set -gx DOTFILES $HOME/.dotfiles

fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin

set -gx SKIM_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
set -gx SKIM_CTRL_T_COMMAND $SKIM_DEFAULT_COMMAND
set -gx SKIM_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"
