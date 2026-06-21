payto_command_payto:
    debug: false
    type: command
    name: payto
    usage: /payto (amount)
    description: Pays the player you're looking at.
    permission: essentials.pay
    tab completions:
        1: <&lt>amount<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter an amount to pay!"
        - stop
    - define amount <context.args.get[1]>
    - if !<context.args.get[1].is_decimal>:
        - narrate "<&c>You must enter a number to pay!"
        - stop
    - if <player.money> < <context.args.get[1]>:
        - narrate "<&c>You don't have <context.args.get[1].as_money>."
        - stop
    - define target <player.target[player].within[8].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Please look at a player to send money to."
        - stop
    - if <[target].is_npc>:
        - narrate "<&c>Please look at a player to send money to."
        - stop
    - clickable usages:1 until:1m save:pay:
        - execute as_player "pay <[target].name> <[amount]>"
    - narrate format:formats_prefix "<&7>Would you like to pay <&6><[amount].as_money><&7> to <&6><proc[character_get_name].context[<[target]>]>"
    - narrate <element[<&a><&l>[CLICK HERE]].on_click[<entry[pay].command>]>
