intro_world:
    debug: false
    type: world
    events:
        after player joins:
        - define intro <player.flag[intro].if_null[null]>
        - if <[intro]> != done:
            - adjust <player> hide_from_players
            - adjust <player> remove_effects
            - run textbox_flush def.player:<player>
            - if <[intro]> == null:
                - teleport <player> <location[313.5,3,258.5,0,270,world]>
                - flag <player> intro:progress
                - adjust server save
                - adjust <player> show_book:intro_book
        on player teleports bukkit_priority:lowest:
        - if <player.flag[intro].if_null[null]> == progress:
            - determine cancelled passively
            - narrate "<&c>You may not teleport at this time."
