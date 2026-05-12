local modules = {
    "hyprland.monitor",
    "hyprland.rules",
    "hyprland.env",
    "hyprland.binds",
    "hyprland.config",
    "hyprland.autostart",
}

for _, mod in ipairs(modules) do
    require(mod)
end
