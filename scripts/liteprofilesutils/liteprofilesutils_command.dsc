liteprofilesutils_command_profiles:
    debug: false
    type: command
    name: profiles
    description: Manage your profiles, neatly.
    aliases:
    - accountmenu
    - pfm
    usage: /profiles
    tab completions:
        1: <list[]>
    permission: liteprofilesutils.command.profiles
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Run this command as a player"
        - stop
    - define player <player>
    - clickable save:accept usages:1 until:30s:
    	- flag <[player]> liteprofiles_legacy_menu:!
        - run liteprofilesutils_show_menu def.player:<[player]>
    - narrate <empty>
    - narrate format:formats_prefix "Our profile system lets you own multiple 'unique accounts' by tricking the server to hand you new unique IDs, which may cause the server to incorrectly save your inventory, ranks, or other data."
    - narrate <empty>
    - narrate "<&c>[<&4><&l>!<&c>] <&7>Consider this feature <&6>experimental<&7>; take screenshots of your items and ranks if you are concerned."
    - narrate <element[<&a><&l>[ I UNDERSTAND ]].on_click[<entry[accept].command>]>
    - narrate <empty>
