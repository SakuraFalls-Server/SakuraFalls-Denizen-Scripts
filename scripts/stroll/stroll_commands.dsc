stroll_command_stroll:
    debug: false
    type: command
    name: stroll
    usage: /stroll
    description: Makes you walk a lil slower, until you run or sneak.
    permission: stroll.command.stroll
    tab completions:
        1: <empty>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - flag <player> stroll_speed:<player.walk_speed>
    - adjust <player> walk_speed:0.1
    - narrate format:formats_prefix "You are now strolling. Sprint or sneak to stop strolling."
