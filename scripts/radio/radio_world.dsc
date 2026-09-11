radio_world:
    debug: false
    type: world
    events:
        on player animates:
            - if <context.animation> != ARM_SWING:
                - stop
            - ratelimit <player> 60t
            - if !<player.item_in_hand.has_flag[radio_item]>:
                - stop
            - if <player.item_in_hand.has_flag[radio_enabled]>:
                - inventory flag slot:hand radio_enabled:!
                - inventory adjust slot:hand "display:<&7>Radio | <&c>Off"
                - narrate format:formats_prefix "<&c>Radio turned off."
            - else:
                - inventory flag slot:hand radio_enabled
                - inventory adjust slot:hand "display:<&7>Radio | <&a>On"
                - narrate format:formats_prefix "<&a>Radio turned on."
            - determine cancelled
