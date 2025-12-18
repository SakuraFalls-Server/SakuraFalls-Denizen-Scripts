carry_command_carry:
    debug: false
    type: command
    name: carry
    description: Carry another player on your shoulders!
    usage: /carry [who?]
    permission: carry.command.carry
    tab completions:
        1: <player.location.find_players_within[5].exclude[<player>].parse[name]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if !<player.is_empty>:
        - narrate "<&c>You're already carrying someone!"
        - stop
    - define target <player.target[player].within[5].if_null[null]>
    - if <[target]> == null:
        - define target <server.match_player[<context.args.get[1]>].if_null[null]>
        - if <[target]> == null:
            - narrate "<&c>Please look at the player to carry or specify their username."
            - stop
        - else:
            - if <[target].location.distance[<player>]> > 5:
                - narrate "<&c>That player is too far away!"
                - stop
    - if <[target].is_npc>:
        - narrate "<&c>Please look at the player to carry or specify their username."
        - stop
    - if <[target]> == <player>:
        - narrate "<&c>You cannot carry yourself!"
        - stop
    - if <[target].is_inside_vehicle>:
        - narrate "<&c>This player is already being carried!"
        - stop
    - define player <player>
    - clickable usages:1 until:10s save:carry:
        - if !<player.is_empty>:
            - narrate "<&c>That player is already carrying someone!"
            - stop
        - if <[target].is_inside_vehicle>:
            - narrate targets:<[target]> "<&c>You're already being carried!"
            - stop
        - adjust <[player]> passengers:<[player].passengers.include[<[target]>]>
    - narrate format:formats_prefix "Sent a carry request to <&e><proc[character_get_name].context[<[target]>]>"
    #
    - narrate format:formats_prefix targets:<[target]> "<&e><proc[character_get_name].context[<player>]> <&7> would like to carry you."
    - narrate targets:<[target]> <element[<&a><&l>[ACCEPT]].on_click[<entry[carry].command>]>

carry_command_uncarry:
    debug: false
    type: command
    name: uncarry
    description: Stop carrying someone.
    usage: /uncarry
    permission: carry.command.uncarry
    tab completions:
        1: <empty>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <player.is_empty>:
        - narrate "<&c>You're not carrying anyone!"
        - stop
    - adjust <player> passengers:<list[]>
