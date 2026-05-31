itemregistry_command_itemregistry:
    debug: false
    type: command
    name: itemregistry
    usage: /itemregistry
    description: Opens the Item Registry.
    permission: itemregistry.command.itemregistry
    tab completions:
        1: <list[]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - run itemregistry_menu def.player:<player>

itemregistry_command_verblicense:
    debug: false
    type: command
    name: verblicense
    usage: /verblicense
    description: See verbose license info on an inventory.
    permission: itemregistry.command.verblicense
    tab completions:
        1: <server.online_players.parse[name]>
    script:
    - if <context.args.size> == 0:
        - if <context.source_type> != player:
            - narrate "<&c>Please run this command as a player."
            - stop
        - define cursor <player.cursor_on_solid>
        - define inventory <[cursor].inventory>
    - else:
        - define target <server.match_player[<context.args.get[1]>].if_null[null]>
        - define inventory <[target].inventory>
    - if <[inventory].if_null[null]> == null:
        - narrate "<&c>No inventory was found. If you are looking up a player, is the player online?"
        - stop
    - run itemregistry_print_licenses def.player:<player> def.inventory:<[inventory]>