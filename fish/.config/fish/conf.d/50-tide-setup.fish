if status is-interactive
    if not set -q tide_left_prompt_items; and type -q tide
        tide configure --auto --style="Lean" --prompt_colors="True color" --show_time="No" --lean_prompt_height="Two lines" --prompt_connection="Disconnected" --prompt_spacing="Sparse" --icons="Few icons"
    end
end
