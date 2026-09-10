grab_command:
    debug: false
    type: command
    name: grab
    usage: /grab (duration|toggle)
    description: Enables grab mode.
    permission: chat.command.grab
    script:
        - if <context.source_type> != player:
            - narrate "<&c>Please run this command as a player."
            - stop

        - if <context.args.size> <= 0:
            - run grab_status def.player:<player>
            - stop

        - if <player.has_flag[grab_cooldown]>:
            - define remaining <player.flag_expiration[grab_cooldown].from_now>
            - narrate "<&c>You cannot use grab again for <&f><[remaining].formatted><&c>."
            - stop

        - define mode <context.args.get[1].to_lowercase>

        - if <[mode]> == toggle:
            - run grab_toggle def.player:<player>
            - stop

        - define duration <[mode].as_duration.if_null[null]>

        - if <[duration]> == null:
            - narrate "<&c>Invalid duration. Use something like 5s, 10s, 30s, or /grab toggle."
            - stop

        - run grab_enable_timed def.player:<player> def.duration:<[duration]>
