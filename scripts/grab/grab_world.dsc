grab_world:
    debug: false
    type: world
    events:
        on player animates:
            - if <context.animation> != ARM_SWING:
                - stop

            - if !<player.has_flag[grab_mode_timed]> && !<player.has_flag[grab_mode_toggle]>:
                - stop

            - ratelimit <player> 2t

            - run grab_attempt def.player:<player>