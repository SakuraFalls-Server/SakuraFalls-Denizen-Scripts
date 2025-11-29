stroll_world:
    debug: false
    type: world
    events:
        on player toggles sneaking:
        - if <player.has_flag[stroll_speed]>:
            - adjust <player> walk_speed:<player.flag[stroll_speed]>
            - flag <player> stroll_speed:!
        on player toggles sprinting:
        - if <player.has_flag[stroll_speed]>:
            - adjust <player> walk_speed:<player.flag[stroll_speed]>
            - flag <player> stroll_speed:!
