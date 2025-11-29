character_world:
    debug: false
    type: world
    events:
        on player right clicks player:
        - define target <context.entity>
        - if <[target].is_npc>:
            - stop
        - determine cancelled passively
        - ratelimit <player> 1s
        - define name <proc[character_get_name].context[<[target]>]>
        - define description <proc[character_get_description].context[<[target]>]>
        - narrate format:formats_prefix "<&e><[target].name> <&7>Character Info"
        - narrate "<&7>Name<&c>: <&f><[name]>"
        - narrate "<&7>Description<&c>: <&f><[description]>"
