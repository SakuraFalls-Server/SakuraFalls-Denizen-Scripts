patdown_command_patdown:
    debug: false
    type: command
    name: patdown
    description: Allows PD to search people
    usage: /patdown
    permission: patdown.command
    aliases:
    - rs
    - requestsearch
    - pd
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this as a player"
        - stop
    - define target <player.target[player].within[3].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Please look at a player you want to search"
        - stop
    - define player <player>
    - clickable usages:1 save:accept:
        - narrate targets:<[target]> "Your Pockets are being searched"
        - run invsee_open def.player:<[player]> def.target:<[target]>
    - clickable usages:1 save:deny:
        - narrate targets:<player> "Your search was denied"
        - narrate targets:<[target]> "You denied the search"
    - narrate targets:<[target]> "<&e><player.name> requested to search your inventory"
    - narrate targets:<[target]> "<element[<&a><&l>[ACCEPT]].on_click[<entry[accept].command>]> <element[<&c><&l>[DENY]].on_click[<entry[deny].command>]>"
