character_world:
    debug: false
    type: world
    events:
        on player right clicks player:
        - define target <context.entity>
        - if <[target].is_npc>:
            - stop
        - if <[target].has_flag[spirit]>:
            - stop
        - determine cancelled passively
        - ratelimit <player> 1s
        - run character_print_description def.player:<player> def.target:<[target]>
