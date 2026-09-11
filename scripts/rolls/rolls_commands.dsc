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
    - run roll_task def.player:<player> def.amount:<[amount]> def.distance:10


roll_command_rollloud:
    debug: false
    type: command
    name: rolll
    usage: /rolll [amount?]
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
    - run roll_task def.player:<player> def.amount:<[amount]> def.distance:25

