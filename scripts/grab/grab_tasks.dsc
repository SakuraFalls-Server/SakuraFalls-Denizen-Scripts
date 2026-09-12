grab_status:
    debug: false
    type: task
    definitions: player
    script:
    - if <[player].has_flag[grab_mode]>:
        - define grab_time <[player].flag_expiration[grab_mode].if_null[null]>
        - if <[grab_time]> != null:
            - define time_left <[grab_time].from_now>
            - narrate "<&7>Grab mode is currently <&a>enabled<&7> for <[time_left]>."
        - else:
            - narrate "<&7>Grab mode is currently <&a>enabled<&7>."
    - else:
        - narrate "<&7>Grab mode is currently <&c>disabled<&7>."
    - narrate "<&7>Usage: <&f>/grab 5s <&7>or<&f>/grab toggle"

grab_toggle:
    debug: false
    type: task
    definitions: player
    script:
    - if <[player].has_flag[grab_mode]>:
        - flag <[player]> grab_mode:!
        - narrate "<&7>Grab mode <&c>disabled<&7>."
    - else:
        - flag <[player]> grab_mode
        - narrate "<&7>Grab mode <&a>enabled<&7>."
    - adjust server save

grab_enable_timed:
    debug: false
    type: task
    definitions: player|duration
    script:
    - flag <[player]> grab_mode duration:<[duration]>
    - adjust server save
    - narrate "<&7>Grab mode <&a>enabled<&7> for <&f><[duration].formatted><&7>."

grab_attempt:
    debug: false
    type: task
    definitions: player
    script:
    - define target <[player].eye_location.ray_trace_target[range=4.5;blocks=true;entities=player;ignore=<[player]>;raysize=0.3].if_null[null]>
    - if <[target]> == null:
        - stop
    - define target_name <[target].flag[character_rpname].if_null[<[target].name>]>
    - define player_name <[player].flag[character_rpname].if_null[<[player].name>]>
    - define message "grabbed <[target_name]>"
    - run chat_channel_ic_me def.player:<[player]> def.message:<[message]>
    - narrate "<&c>You have grabbed <&f><[target_name]><&c>. Remember to roll!" targets:<[player]>
    - narrate "<&c>You have been grabbed by <&f><[player_name]><&c>. Remember to roll!" targets:<[target]>
    - flag <[player]> grab_mode:!
    - flag <[player]> grab_cooldown duration:15s
