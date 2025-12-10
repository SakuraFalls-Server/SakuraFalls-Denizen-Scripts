requestsearch_command_requestsearch:
    debug: false
    type: command
    name: requestsearch
    description: Command to search someone's inventory.
    usage: /requestsearch
    aliases:
    - rs
    - patdown
    permission: invreq.patdown
    tab completions:
        1: <empty>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define target <player.target[player].within[5].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Please look at the player you want to search."
        - stop
    - if <[target].is_npc>:
        - narrate "<&c>Please look at the player you want to search."
        - stop
    - define player <player>
    - narrate format:formats_prefix "<&e>Sent an inventory search request to <placeholder[essentials_nickname].player[<[target]>]>"
    - clickable usages:1 save:yes:
        - narrate targets:<[target]> format:formats_prefix "Your inventory is being searched..."
        - inventory player:<[player]> open destination:<[target].inventory>
    - clickable usages:1 save:no:
        - narrate targets:<[player]> format:formats_prefix "Your inventory search request was denied."
        - narrate targets:<[target]> "You denied the inventory search request."
    - narrate format:formats_prefix targets:<[target]> "<&e>Do you allow <placeholder[essentials_nickname].player[<player>]><&e> to access your belongings?"
    - narrate targets:<[target]> "<&f> <&e> <&f> <element[<&7>[<&a>Accept<&7>]].on_click[<entry[yes].command>]><&f> <&e> <&f> <red><element[<&7>[<&c>Deny<&7>]].on_click[<entry[no].command>]>"
