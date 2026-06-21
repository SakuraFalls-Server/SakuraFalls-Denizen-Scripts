dailyrewards_command_dailyreward:
    debug: false
    type: command
    name: dailyreward
    description: Collect your daily reward!
    usage: /dailyreward
    permission: dailyrewards.command.dailyreward
    tab completions:
        1: <list[]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - run dailyrewards_menu def.player:<player>
