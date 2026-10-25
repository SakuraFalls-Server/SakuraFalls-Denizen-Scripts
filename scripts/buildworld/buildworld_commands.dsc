buildworld_command_buildworld:
    debug: false
    type: command
    name: buildworld
    description: Teleport to the Build World
    usage: /buildworld
    permission: buildworld.command.buildworld
    tab completions:
        1: <list[]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if !<player.has_permission[buildworld.access]>:
        - narrate "<&c>You don't have permission to access the Build World!"
        - stop
    - run buildworld_teleport def.player:<player>
