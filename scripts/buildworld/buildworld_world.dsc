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
