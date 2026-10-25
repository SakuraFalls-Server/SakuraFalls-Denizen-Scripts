buildworld_world:
    debug: false
    type: world
    events:
        after player joins:
        - if <player.is_op>:
            - stop
        - if <player.world.name.equals[buildworld]>:
            - if !<player.has_permission[buildworld.access]>:
                # make sure to "adjust <world[world]> spawn_location:..." if wrong
                - teleport <player> <world[world].spawn_location>
        on player teleports bukkit_priority:lowest:
        - if <player.is_op>:
            - stop
        - if <context.destination.world.name.equals[buildworld]>:
            - if !<player.has_permission[buildworld.access]>:
                - determine cancelled passively
                - narrate "<&c>You cannot teleport here right now!"
