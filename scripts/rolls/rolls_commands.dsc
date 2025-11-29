roll_command_roll:
    debug: false
    type: command
    name: roll
    usage: /roll [amount?]
    description: Rolls a dice, optionally with an amount.
    permission: roll.command.roll
    tab completions:
        1: <&lt>amount<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define amount 100
    - if <context.args.size> >= 1:
        - define amount <context.args.get[1]>
        - if !<[amount].is_integer>:
            - narrate "<&c>The amount must be an integer between 2 and 200."
            - stop
        - if <[amount]> < 2 || <[amount]> > 200:
            - narrate "<&c>The amount must be an integer between 2 and 200."
            - stop
    - define roll <util.random.int[1].to[<[amount]>]>
    - define final "<&f><placeholder[essentials_nickname].player[<player>]> <proc[chat_special_group].context[<player>]><proc[chat_roles_group].context[<player>]> <proc[character_get_name].context[<player>]> <&6>rolls <&f><[roll]> <&6>out of <&f><[amount]>"
    - narrate targets:<player.location.find_players_within[10]> <[final]>
    - announce to_console <[final]>
