invsee_command_invsee:
    debug: false
    type: command
    description: Allows you to view another player's inventory.
    name: invsee
    usage: /invsee [player]
    permission: invsee.admin
    tab completions:
        1: <server.offline_players.parse[name]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args> < 1:
        - narrate "<&c>Please specify a player"
        - stop
    - define target <server.match_offline_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found or not online."
        - stop
    - ~run invsee_open def.player:<player> def.target:<[target]>