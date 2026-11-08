radio_command_radio:
    debug: false
    type: command
    name: radio
    aliases:
        - r
    description: Transmit over your radio.
    usage: /radio (message)
    permission: radio.command.use
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>This command can only be used by a player."
        - stop
    - if <context.args.size> <= 0:
        - inject radio_command_radio_help
    - define first <context.args.get[1].to_lowercase>
    - if <[first]> == help:
        - inject radio_command_radio_help
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

radio_command_radio_help:
    debug: false
    type: task
    script:
    - narrate format:formats_prefix "Radio Commands & Information"
    - narrate "<&7>/radio (message) <&8>- <&f>Talk over the radio <&o>(/r)"
    - narrate "<&7>/radiowhisper (message) <&8>- <&f>Whisper over the radio <&o>(/rw)"
    - narrate "<&7>/radioyell (message) <&8>- <&f>Yell over the radio <&o>(/ry)"
    - narrate "<&7>/radioswap <&8>- <&f>Switch between your Police or Hospital to Emergency, and viceversa."
    - narrate "<&7>/radiopanic (message) <&8>- <&f>Sends your coordinates and a short message to both the Hospital and Police"
    - narrate "<&7>Channels: <&3>town <&7>, <&e>school <&7>, <&b>police <&7>, <&1>hospital <&7>, <&c>emergency"
    - if <player.has_permission[radio.command.admin]>:
        - narrate "<&7>/radioadmin (player) (channel)"
    - stop

radio_command_radiowhisper:
    debug: false
    type: command
    name: radiowhisper
    aliases:
        - radiow
        - rw
    description: Whisper over the radio.
    usage: /radiowhisper (message)
    permission: radio.command.use
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>This command can only be used by a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Usage: /radiowhisper (message)"
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

radio_command_radioyell:
    debug: false
    type: command
    name: radioyell
    aliases:
        - radioy
        - ry
    description: Yell over the radio.
    usage: /radioyell (message)
    permission: radio.command.use
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>This command can only be used by a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Usage: /radioyell (message)"
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

radio_command_radioswap:
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
    - define is_police <player.has_permission[radio.category.police]>
    - define is_hospital <player.has_permission[radio.category.hospital]>
    - if !<[is_police]> && !<[is_hospital]>:
        - narrate "<&c>You do not have access to the Police or Hospital radio."
        - stop
    - define current <proc[radio_get_channel].context[<player>]>
    - if <[current]> == emergency:
        - if <[is_hospital]>:
            - flag player radio_channel:hospital
            - narrate "<&7>Radio switched to <&1>[R-HOSPITAL]<&7>."
            - stop
        - else:
            - flag player radio_channel:police
            - narrate "<&7>Radio switched to <&b>[R-POLICE]<&7>."
            - stop
    - if <[current]> == hospital:
        - flag player radio_return_channel:hospital
        - flag player radio_channel:emergency
        - narrate "<&7>Radio switched to <&c>[R-EMERGENCY]<&7>."
        - stop
    - if <[current]> == police:
        - flag player radio_return_channel:police
        - flag player radio_channel:emergency
        - narrate "<&7>Radio switched to <&c>[R-EMERGENCY]<&7>."
        - stop
    - narrate "<&c>You do not have access to the Police or Hospital radio."

radio_command_radiopanic:
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

radio_command_radioadmin:
    debug: false
    type: command
    name: radioadmin
    description: Manage player radios.
    usage: /radioadmin (player) (channel)
    permission: radio.command.admin
    script:
    - define subcommand <context.args.get[1].if_null[null]>
    - if <[subcommand]> == null:
        - narrate "<&c>Usage: /radioadmin (player) (channel)"
        - narrate "<&7>Channels: <&3>town <&7>, <&e>school <&7>, <&b>police <&7>, <&1>hospital <&7>, <&c>emergency <&7>, <&f>default"
        - narrate "<&7>Give a radio: <&f>/radioadmin give (player)"
        - stop
    - define subcommand_argument <context.args.get[2].if_null[null]>
    - if <[subcommand].to_lowercase> == give:
        - if <[subcommand_argument]> == null:
            - narrate "<&c>Usage: /radioadmin give (player)"
            - stop
        - define target <server.match_player[<[subcommand_argument]>].if_null[null]>
        - if <[target]> == null:
            - narrate "<&c>Player not found: <&f><[subcommand_argument]>"
            - stop
        - define radio <proc[radio_make_item]>
        - give <[radio]> player:<[target]>
        - narrate "<&a>Radio given to <&f><[target].name><&a>."
        - narrate "<&a>You received a radio." targets:<[target]>
        - stop
    - if <[subcommand_argument]> == null:
        - narrate "<&c>Usage: /radioadmin (player) (channel)"
        - stop
    - define target <server.match_player[<[subcommand]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found: <&f><[subcommand]>"
        - stop
    - define channel <[subcommand_argument].to_lowercase>
    - flag <[target]> radio_channel:<[channel]>
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
