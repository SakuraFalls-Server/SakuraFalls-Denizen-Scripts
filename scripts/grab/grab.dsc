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
        - if <player.has_flag[grab_cooldown]>:
            - define remaining <player.flag_expiration[grab_cooldown].from_now>
            - narrate "<&c>You cannot use grab again for <&f><[remaining].formatted><&c>."
            - stop
        - if <context.args.size> <= 0:
            - if <player.has_flag[grab_mode_timed]> || <player.has_flag[grab_mode_toggle]>:
                - narrate "<&7>Grab mode is currently <&a>enabled<&7>."
            - else:
                - narrate "<&7>Grab mode is currently <&c>disabled<&7>."
            - narrate "<&7>Usage: <&f>/grab 5s <&7>or<&f>/grab toggle"
            - stop
        - define mode <context.args.get[1].to_lowercase>
        - if <[mode]> == toggle:
            - if <player.has_flag[grab_mode_toggle]>:
                - flag player grab_mode_toggle:!
                - narrate "<&7>Grab mode <&c>disabled<&7>."
            - else:
                - flag player grab_mode_toggle
                - narrate "<&7>Grab mode <&a>enabled<&7>."
            - stop
        - define duration <[mode].as_duration.if_null[null]>
        - if <[duration]> == null:
            - narrate "<&c>Invalid duration. Use something like 5s, 10s, 30s, or /grab toggle."
            - stop
        - flag player grab_mode_timed duration:<[duration]>
        - narrate "<&7>Grab mode <&a>enabled<&7> for <&f><[mode]><&7>."

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
            - define target <player.eye_location.ray_trace_target[range=4.5;blocks=true;entities=player;ignore=<player>;raysize=0.3]||null>
            - if <[target]> == null:
                - stop
            - define target_name <[target].flag[character_rpname].if_null[<[target].name>]>
            - define player_name <player.flag[character_rpname].if_null[<player.name>]>
            - define message "grabbed <[target_name]>"
            - run chat_channel_ic_me def.player:<player> def.message:<[message]>
            - narrate "<&c>You have grabbed <&f><[target_name]><&c>. Remember to roll!" targets:<player>
            - narrate "<&c>You have been grabbed by <&f><[player_name]><&c>. Remember to roll!" targets:<[target]>
            - flag player grab_mode_timed:!
            - flag player grab_mode_toggle:!
            - flag player grab_cooldown duration:30s