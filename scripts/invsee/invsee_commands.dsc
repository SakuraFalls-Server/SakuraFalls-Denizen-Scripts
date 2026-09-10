invsee_command_invsee:
    debug: false
    type: command
    description: Allows you to view another player's inventory.
    name: invsee
    usage: /invsee [player]
    permission: invsee.admin
    tab completions:
        1: <server.online_players.parse[name]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> < 1:
        - narrate "<&c>Please specify a player"
        - stop
    - define target <server.match_player[<context.args.get[1]>].if_null[<server.match_offline_player[<context.args.get[1]>].if_null[null]>]>
    - if <[target]> == null:
        - narrate "<&c>Player not found. Has this player played here yet?"
        - stop
    - if <[target]> == <player>:
        - narrate "<&c>Open your inventory yourself!"
        - stop
    - ~run invsee_open def.player:<player> def.target:<[target]>
