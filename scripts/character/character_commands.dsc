character_command_rpname:
    debug: false
    type: command
    name: rpname
    description: Sets your roleplay name.
    usage: /rpname (name)
    permission: character.command.rpname
    tab completions:
        1: <&lt>name<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a RP name!"
        - stop
    - define name <context.args.space_separated.parse_color.strip_color>
    - if <[name].length> > 24:
        - narrate "<&c>Your RP name must not be longer than 24 characters."
        - stop
    - if !<[name].regex_matches[^[a-zA-Z0-9\-. <&sq>]+$]>:
        - narrate "<&c>Your RP name must only contain alphanumeric characters, spaces, dots, dashes, and single quotes."
        - stop
    - define used_already <server.flag[character_rpnames].get[<[name]>].if_null[null]>
    - if <[used_already]> != null:
        - if <[used_already]> != <player.uuid>:
            - narrate "<&c>This RP name is already taken!"
            - stop
    - define new_rpnames <server.flag[character_rpnames].if_null[<map[]>]>
    - if <player.has_flag[character_rpname]>:
        - define new_rpnames <[new_rpnames].exclude[<player.flag[character_rpname]>]>
    - define new_rpnames <[new_rpnames].with[<[name]>].as[<player.uuid>]>
    - flag <player> character_rpname:<[name]>
    - flag server character_rpnames:<[new_rpnames]>
    - adjust server save
    - narrate format:formats_prefix "Set your RP Name to <&e><[name]><&7>."

character_command_setdescription:
    debug: false
    type: command
    name: setdescription
    aliases:
    - setdesc
    description: Sets your roleplay description.
    usage: /setdescription (description)
    permission: character.command.setdescription
    tab completions:
        1: <&lt>description<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a description!"
        - stop
    - define description <context.args.space_separated.parse_color.strip_color>
    - flag <player> character_description:<[description]>
    - adjust server save
    - narrate format:formats_prefix "Changed your description! View it with /viewdescription."

character_command_viewdescription:
    debug: false
    type: command
    name: viewdescription
    aliases:
    - viewdesc
    description: Sets your roleplay description.
    usage: /viewdescription
    permission: character.command.viewdescription
    tab completions:
        1: <empty>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define name <proc[character_get_name].context[<player>]>
    - define description <proc[character_get_description].context[<player>]>
    - narrate format:formats_prefix "<&e><player.name> <&7>Character Info"
    - narrate "<&7>Your name<&c>: <&f><[name]>"
    - narrate "<&7>Your description<&c>: <&f><[description]>"

character_command_findname:
    debug: false
    type: command
    name: findname
    aliases:
    - fn
    description: Find name of player based on RP name.
    usage: /findname (rpname)
    permission: character.command.findname
    tab completions:
        1: <&lt>rpname<&gt>
    script:
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a RP name!"
        - stop
    - define query <context.args.space_separated.parse_color.strip_color>
    - define found_player <server.flag[character_rpnames].if_null[<map[]>].get[<[query]>].if_null[null]>
    - if <[found_player]> == null:
        - narrate format:formats_prefix "No player with this RP name could be found."
        - stop
    - else:
        - define found_player <player[<[found_player]>]>
        - narrate format:formats_prefix "The actual name of <[query]> is <&e><[found_player].name>"
