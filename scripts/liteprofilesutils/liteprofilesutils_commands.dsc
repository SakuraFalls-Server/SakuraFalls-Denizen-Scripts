liteprofilesutils_command_profiles:
    debug: false
    type: command
    name: profiles
    description: Manage your profiles, neatly.
    aliases:
    - accountmenu
    - pfm
    usage: /profiles [player]
    tab completions:
        1: <server.online_players.parse[name]>
    permission: liteprofilesutils.command.profiles
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Run this command as a player"
        - stop
    - define player <player>
    - if !<context.args.is_empty>:
        - if !<[player].has_permission[liteprofilesutils.command.profiles.other]>:
            - narrate "<&c>You do not have permission to do this."
            - stop
        - define target <server.match_player[<context.args.get[1]>].if_null[<server.match_offline_player[<context.args.get[1]>].if_null[null]>]>
        - if <[target]> == null:
            - narrate "<&c>Player not found. Has this player joined before?"
            - stop
        - run liteprofilesutils_list_other def.player:<[player]> def.target:<[target]>
    - else:
        - if <proc[settings_get].context[<player>|general_ignore_profile_menu_warning].if_null[false]>:
            - run liteprofilesutils_show_menu def.player:<player>
        - else:
            - clickable save:accept usages:1 until:30s:
                - run liteprofilesutils_show_menu def.player:<player>
            - narrate <empty>
            - narrate format:formats_prefix "Our profile system lets you own multiple 'unique accounts' by tricking the server to hand you new unique IDs, which may cause the server to incorrectly save your inventory, ranks, or other data."
            - narrate <empty>
            - narrate "<&c>[<&4><&l>!<&c>] <&7>Consider this feature <&6>experimental<&7>; take screenshots of your items and ranks if you are concerned."
            - narrate <element[<&a><&l>[ I UNDERSTAND ]].on_click[<entry[accept].command>]>
            - narrate <empty>
