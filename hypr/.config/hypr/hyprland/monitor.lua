hl.monitor({
    output = "DP-3",
    mode = "3840x2160@144",
    position = "0x0",
    scale = "1.33",
})

hl.monitor({
    output = "DP-4",
    mode = "2560x1440@144",
    -- HACK: was auto-right, broken after lua conversion
    -- relevant pr: https://github.com/hyprwm/Hyprland/pull/14393
    position = "2880x0",
    scale = "1",
})

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})
