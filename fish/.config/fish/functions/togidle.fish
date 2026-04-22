function togidle -d "toggle pc idle"
    if not pgrep -x "hypridle" > /dev/null
        hypridle > /dev/null & disown
        notify-send "💤 PC will now sleep"
    else
        killall hypridle
        notify-send "☕ PC will stay awake"
    end
end
