# arch install script todo

> list of minimum needed installs and custom stuff, for automating later

## makepkg use all the cores

change /etc/makepkg.conf:

```bash
# /etc/makepkg.conf
COMPRESSXZ=(xz -c -T {cores} -z -)
MAKEFLAGS="-f{cores}"
# use nproc to set it?
```

## paru install

```bash
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

## packages

remove:
kitty
dolphin

packages (pacman):
fish?
zsh?
just
ghostty
hyprlock
hypridle
hyprpaper
hyprshot
xdg-desktop-portal
xdg-desktop-portal-hyprland
wlsunset
libinput-tools
thunar
thunar-volman
rofi-wayland
rofi-calc
rofi-emoji
calf
mandoc
lsp-plugins
easyeffects
wl-clipboard
cliphist
wl-clip-persist
discord
spotify-launcher
swaync
playerctl
hyprpicker
ripgrep
eza
bat
vlc-plugin-ffmpeg
zip
unzip
btop
tmux
pavucontrol
nwg-look
noto-fonts
noto-fonts-cjk
noto-fonts-emoji
noto-fonts-extra
tectonic
imagemagick
tree-sitter-cli
clang
gvfs
gvfs-mtp
sass
adw-gtk-theme
tectonic
imagemagick
tree-sitter-cli
tmux
pavucontrol
nwg-look
noto-fonts
noto-fonts-cjk
noto-fonts-emoji
noto-fonts-extra
tectonic
imagemagick
tree-sitter-cli
clang
gvfs
gvfs-mtp
sass
adw-gtk-theme
fd
uv
git
rustup
typst
github-cli
gamemode
mangohud
nix

packages (aur):
1password
1password-cli
waybar-cava
zen-browser-bin
betterbird-bin
calibre-bin
ghidra-desktop
hyprqt6engine
libdeep_filder_ladspa-bin
localsend-bin
obsbot-camera-control
obsidian-headless-bin
prettierd
ungoogled-chromium-bin

## general

### graphical-session.target

> without uwsm, need to spin up/kill graphical-session{-pre}.target manually

```
; ~/.config/systemd/user/hyprland-session.target, ran in autostart.lua
[Unit]
Description=Hyprland session
BindsTo=graphical-session.target
Before=graphical-session.target
Wants=graphical-session-pre.target
After=graphical-session-pre.target
```

### add 1password zen-browser entry to allowed browsers so plugin and desktop app can interact

```bash
mkdir /etc/1password
echo "zen-bin" > /etc/1password/custom_allowed_browsers
```

### disable ps5 touchpad

> https://old.reddit.com/r/hyprland/comments/1hkv6qx/disabling_touchpad_on_dualsense_controller/m3m53x5/

make rule file in etc/udev/rules.d/72-ds5tp.rules
fill with:

```bash
# disable dualsense touchpad acting as mouse
# usb (check libinput --list-devices (libinput-tools package))
ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
# bluetooth
ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
# then reload udev and reconnect controller
sudo udevadm control --reload-rules && sudo udevadm trigger
```

### disable recent files

```bash
gsettings set org.gnome.desktop.privacy remember-recent-files false
```

### ssh agent

> stop sshd from littering `~/.ssh/agent/`

```bash
echo "StreamLocalBindUnlink yes" > /etc/ssh/sshd_config
```

### sudo default editor/visual

> when doing something like `sudo systemctl edit {}`, it defaults to nano,
> overide to pass user env EDITOR/VISUAL

```bash
sudo visudo
```

then add the following, probably around where `env_keep` commented out options
are

```
Defaults env_keep += "EDITOR VISUAL"
```

### networkd wait only on ethernet

> [!NOTE] ideally do above before, nano sucks

> networkd hangs when wlan adapter is present but not set up, tries connecting
> until timeout (120s), so pin it ethernet interface

find link name first

```bash
networkctl list
```

edit

```bash
sudo systemctl edit systemd-networkd-wait-online.service
```

and add, replacing `{}` with proper one

```conf
[Service]
ExecStart=
ExecStart=/usr/lib/systemd/systemd-networkd-wait-online --interface=enp{}s{}
```

### nix

```
sudo pacman -S nix
sudo systemctl enable --now nim-daemon.service
sudo usermod -aG nix-users $USER
```

### wooting chromium access

make rule file in etc/udev/rules.d/70-wooting.rules
fill with:

```
# Wooting One Legacy
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", MODE:="0660", GROUP="input", TAG+="uaccess", TAG+="snap_chromium_chromedriver", TAG+="snap_chromium_chromium"
SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", MODE:="0660", GROUP="input", TAG+="uaccess"
# Wooting One update mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", MODE:="0660", GROUP="input", TAG+="uaccess", TAG+="snap_chromium_chromedriver", TAG+="snap_chromium_chromium"

# Wooting Two Legacy
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", MODE:="0660", GROUP="input", TAG+="uaccess", TAG+="snap_chromium_chromedriver", TAG+="snap_chromium_chromium"
SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", MODE:="0660", GROUP="input", TAG+="uaccess"
# Wooting Two update mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403", MODE:="0660", GROUP="input", TAG+="uaccess", TAG+="snap_chromium_chromedriver", TAG+="snap_chromium_chromium"

# Generic Wootings
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", MODE:="0660", GROUP="input", TAG+="uaccess", TAG+="snap_chromium_chromedriver", TAG+="snap_chromium_chromium"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", MODE:="0660", GROUP="input", TAG+="uaccess"
```

### sora chromium access

make rule file in etc/udev/rules.d/70-wooting.rules
fill with:

```
# Ninjutso Sora V3
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="093a", ATTRS{idProduct}=="eb02", MODE:="0660", GROUP="input", TAG+="uaccess"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="093a", ATTRS{idProduct}=="e010", MODE:="0660", GROUP="input", TAG+="uaccess"
```

## gaming

### steam vulkan shaders speed up

> steam processing shaders is slow af cause it just uses one thread

```bash
echo "unShaderBackgroudProcessingThreads {num}" > ~/.steam/steam/steam_dev.cfg
```
