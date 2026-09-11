radio_command:
    debug: false
    type: command
    name: radio
    aliases:
        - r
    description: Transmit over your radio.
    usage: /radio <&lt>message<&gt>
    permission: radio.command.use
    script:
        - if <context.source_type> != player:
            - narrate "<&c>This command can only be used by a player."
            - stop
        - if <context.args.size> <= 0:
            - narrate format:formats_prefix "Radio Commands & Information"
            - narrate "<&7>/radio <&lt>message<&gt> <&8>- <&f>Talk over the radio <&o>(/r)"
            - narrate "<&7>/radiowhisper <&lt>message<&gt> <&8>- <&f>Whisper over the radio <&o>(/rw)"
            - narrate "<&7>/radioyell <&lt>message<&gt> <&8>- <&f>Yell over the radio <&o>(/ry)"
            - narrate "<&7>/radioswap <&8>- <&f>Switch between your Police or Hospital to Emergency, and viceversa."
            - narrate "<&7>/radiopanic <&lt>message<&gt> <&8>- <&f>Sends your coordinates and a short message to both the Hospital and Police"
            - narrate "<&7>Channels: <&3>town <&7>, <&e>school <&7>, <&b>police <&7>, <&1>hospital <&7>, <&c>emergency"
            - if <player.has_permission[radio.command.admin]>:
                - narrate "<&7>/radioadmin <&lt>player<&gt> <&lt>channel<&gt>"
            - stop
        - define first <context.args.get[1].to_lowercase>
        - if <[first]> == help:
            - execute as_player "radio"
            - stop
        - define radio <proc[radio_get_item].context[<player>]>

        - if <[radio]> == null:
            - narrate "<&c>You need a radio in your inventory."
            - stop
        - if !<[radio].has_flag[radio_enabled]>:
            - narrate "<&c>Your radio is turned off. Hold it and left-click to turn it on."
            - stop
        - define message <context.raw_args.parse_color.escaped.replace[&].with[&\]>
        - if <[message].strip_color.length> <= 0:
            - narrate "<&c>You need to provide a message."
            - stop
        - run radio_transmit def.player:<player> def.message:<[message]> def.mode:normal def.forced_channel:auto

radiowhisper_command:
    debug: false
    type: command
    name: radiowhisper
    aliases:
        - radiow
        - rw
    description: Whisper over the radio.
    usage: /radiowhisper <&lt>message<&gt>
    permission: radio.command.use
    script:
        - if <context.source_type> != player:
            - narrate "<&c>This command can only be used by a player."
            - stop
        - if <context.args.size> <= 0:
            - narrate "<&c>Usage: /radiowhisper <&lt>message<&gt>"
            - stop
        - define radio <proc[radio_get_item].context[<player>]>
        - if <[radio]> == null:
            - narrate "<&c>You need a radio in your inventory."
            - stop
        - if !<[radio].has_flag[radio_enabled]>:
            - narrate "<&c>Your radio is turned off. Hold it and left-click to turn it on."
            - stop
        - define message <context.raw_args.parse_color.escaped.replace[&].with[&\]>
        - run radio_transmit def.player:<player> def.message:<[message]> def.mode:whisper def.forced_channel:auto

radioyell_command:
    debug: false
    type: command
    name: radioyell
    aliases:
        - radioy
        - ry
    description: Yell over the radio.
    usage: /radioyell <&lt>message<&gt>
    permission: radio.command.use
    script:
        - if <context.source_type> != player:
            - narrate "<&c>This command can only be used by a player."
            - stop
        - if <context.args.size> <= 0:
            - narrate "<&c>Usage: /radioyell <&lt>message<&gt>"
            - stop
        - define radio <proc[radio_get_item].context[<player>]>
        - if <[radio]> == null:
            - narrate "<&c>You need a radio in your inventory."
            - stop
        - if !<[radio].has_flag[radio_enabled]>:
            - narrate "<&c>Your radio is turned off. Hold it and left-click to turn it on."
            - stop
        - define message <context.raw_args.parse_color.escaped.replace[&].with[&\]>
        - run radio_transmit def.player:<player> def.message:<[message]> def.mode:yell def.forced_channel:auto

radioswap_command:
    debug: false
    type: command
    name: radioswap
    description: Switch between your faction radio and Emergency.
    usage: /radioswap
    permission: radio.command.use
    script:
        - if <context.source_type> != player:
            - narrate "<&c>This command can only be used by a player."
            - stop
        - define has_police <player.has_permission[radio.category.police]>
        - define has_hospital <player.has_permission[radio.category.hospital]>
        - if !<[has_police]> && !<[has_hospital]>:
            - narrate "<&c>You do not have access to a faction radio."
            - stop
        - define current <proc[radio_get_channel].context[<player>]>
        - if <[current]> == emergency:
            - if <[has_hospital]> && !<[has_police]>:
                - flag player radio_channel:hospital
                - narrate "<&7>Radio switched to <&1>[R-HOSPITAL]<&7>."
                - stop
            - if <[has_police]>:
                - flag player radio_channel:police
                - narrate "<&7>Radio switched to <&b>[R-POLICE]<&7>."
                - stop
        - if <[current]> == hospital:
            - if <[has_hospital]>:
                - flag player radio_channel:emergency
                - narrate "<&7>Radio switched to <&c>[R-EMERGENCY]<&7>."
                - stop
        - if <[current]> == police:
            - if <[has_police]>:
                - flag player radio_channel:emergency
                - narrate "<&7>Radio switched to <&c>[R-EMERGENCY]<&7>."
                - stop
        - if <[has_hospital]> && !<[has_police]>:
            - flag player radio_channel:emergency
            - narrate "<&7>Radio switched to <&c>[R-EMERGENCY]<&7>."
            - stop
        - if <[has_police]>:
            - flag player radio_channel:emergency
            - narrate "<&7>Radio switched to <&c>[R-EMERGENCY]<&7>."
            - stop

radiopanic_command:
    debug: false
    type: command
    name: radiopanic
    description: Activate your emergency panic button.
    usage: /radiopanic
    permission: radio.command.panic
    script:
        - if <context.source_type> != player:
            - narrate "<&c>This command can only be used by a player."
            - stop
        - if !<player.has_permission[radio.category.police]> && !<player.has_permission[radio.category.hospital]>:
            - narrate "<&c>Only Police and Hospital personnel can use the panic button."
            - stop
        - define radio <proc[radio_get_item].context[<player>]>
        - if <[radio]> == null:
            - narrate "<&c>You need a radio in your inventory."
            - stop
        - if !<[radio].has_flag[radio_enabled]>:
            - narrate "<&c>Your radio is turned off."
            - stop
        - run radio_panic_transmit def.player:<player>

radioadmin_command:
    debug: false
    type: command
    name: radioadmin
    description: Manage player radios.
    usage: /radioadmin <&lt>player<&gt> <&lt>channel<&gt>
    permission: radio.command.admin
    script:
        - define arg1 <context.args.get[1]||null>
        - define arg2 <context.args.get[2]||null>
        - if <[arg1]> == null:
            - narrate "<&c>Usage: /radioadmin <&lt>player<&gt> <&lt>channel<&gt>"
            - narrate "<&7>Channels: <&3>town <&7>, <&e>school <&7>, <&b>police <&7>, <&1>hospital <&7>, <&c>emergency <&7>, <&f>default"
            - narrate "<&7>Give a radio: <&f>/radioadmin give <&lt>player<&gt>"
            - stop
        - if <[arg1].to_lowercase> == give:
            - if <[arg2]> == null:
                - narrate "<&c>Usage: /radioadmin give <&lt>player<&gt>"
                - stop
            - define target <server.match_player[<[arg2]>]>
            - if !<[target].exists>:
                - narrate "<&c>Player not found: <&f><[arg2]>"
                - stop
            - define radio <proc[radio_make_item]>
            - give <[radio]> player:<[target]>
            - narrate "<&a>Radio given to <&f><[target].name><&a>."
            - narrate "<&a>You received a radio." targets:<[target]>
            - stop
        - if <[arg2]> == null:
            - narrate "<&c>Usage: /radioadmin <&lt>player<&gt> <&lt>channel<&gt>"
            - stop
        - define target <server.match_player[<[arg1]>]>
        - if !<[target].exists>:
            - narrate "<&c>Player not found: <&f><[arg1]>"
            - stop
        - define channel <[arg2].to_lowercase>
        - if <[channel]> == town:
            - flag <[target]> radio_channel:town
            - narrate "<&a><[target].name>'s radio channel is now <&3>[R-TOWN]<&a>."
            - narrate "<&7>Your radio channel was switched to <&3>[R-TOWN]<&7> by an administrator." targets:<[target]>
            - stop
        - if <[channel]> == school:
            - flag <[target]> radio_channel:school
            - narrate "<&a><[target].name>'s radio channel is now <&e>[R-SCHOOL]<&a>."
            - narrate "<&7>Your radio channel was switched to <&e>[R-SCHOOL]<&7> by an administrator." targets:<[target]>
            - stop
        - if <[channel]> == police:
            - flag <[target]> radio_channel:police
            - narrate "<&a><[target].name>'s radio channel is now <&b>[R-POLICE]<&a>."
            - narrate "<&7>Your radio channel was switched to <&b>[R-POLICE]<&7> by an administrator." targets:<[target]>
            - stop
        - if <[channel]> == hospital:
            - flag <[target]> radio_channel:hospital
            - narrate "<&a><[target].name>'s radio channel is now <&1>[R-HOSPITAL]<&a>."
            - narrate "<&7>Your radio channel was switched to <&1>[R-HOSPITAL]<&7> by an administrator." targets:<[target]>
            - stop
        - if <[channel]> == emergency:
            - flag <[target]> radio_channel:emergency
            - narrate "<&a><[target].name>'s radio channel is now <&c>[R-EMERGENCY]<&a>."
            - narrate "<&7>Your radio channel was switched to <&c>[R-EMERGENCY]<&7> by an administrator." targets:<[target]>
            - stop
        - if <[channel]> == default:
            - flag <[target]> radio_channel:!
            - define default <proc[radio_get_default_channel].context[<[target]>]>
            - if <[default]> == police:
                - narrate "<&a><[target].name>'s radio channel has been reset to <&b>[R-POLICE]<&a>."
                - narrate "<&7>Your radio channel was reset to <&b>[R-POLICE]<&7>." targets:<[target]>
                - stop
            - if <[default]> == hospital:
                - narrate "<&a><[target].name>'s radio channel has been reset to <&1>[R-HOSPITAL]<&a>."
                - narrate "<&7>Your radio channel was reset to <&1>[R-HOSPITAL]<&7>." targets:<[target]>
                - stop
            - if <[default]> == school:
                - narrate "<&a><[target].name>'s radio channel has been reset to <&e>[R-SCHOOL]<&a>."
                - narrate "<&7>Your radio channel was reset to <&e>[R-SCHOOL]<&7>." targets:<[target]>
                - stop
            - narrate "<&a><[target].name>'s radio channel has been reset to <&3>[R-TOWN]<&a>."
            - narrate "<&7>Your radio channel was reset to <&3>[R-TOWN]<&7>." targets:<[target]>
            - stop
        - narrate "<&c>Invalid channel: <&f><[channel]>"
        - narrate "<&7>Valid channels: <&3>town <&7>, <&e>school <&7>, <&b>police <&7>, <&1>hospital <&7>, <&c>emergency <&7>, <&f>default"