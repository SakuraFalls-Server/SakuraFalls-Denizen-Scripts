radio_world:
    debug: false
    type: world
    events:
        on player left clicks block:
        - ratelimit <player> 60t
        - if !<player.item_in_hand.has_flag[radio_item]>:
            - stop
        - if <player.item_in_hand.has_flag[radio_enabled]>:
            - inventory flag slot:hand radio_enabled:!
            - narrate format:formats_prefix "<&c>Radio turned off."
        - else:
            - inventory flag slot:hand radio_enabled
            - narrate format:formats_prefix "<&a>Radio turned on."
        - determine cancelled
