grab_world:
    debug: false
    type: world
    events:
        on player animates:
        - if <context.animation> != ARM_SWING:
            - stop
        - if !<player.has_flag[grab_mode]>:
            - stop
        - ratelimit <player> 5t
        - run grab_attempt def.player:<player>
