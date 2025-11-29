furniture_command_furniture:
    debug: false
    type: command
    name: furniture
    usage: /furniture
    description: Opens the furniture menu.
    permission: furniture.command.furniture
    tab completions:
        1: <list[]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>You can only use this command as a player."
        - stop
    - run furniture_menu def.player:<player>
