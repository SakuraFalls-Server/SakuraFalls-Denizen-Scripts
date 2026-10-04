buildworld_teleport:
    debug: false
    type: task
    definitions: player
    script:
    - define spawn_location <world[buildworld].spawn_location.center>
    - chunkload <[spawn_location].chunk>
    - while <[spawn_location].material.is_solid>:
        - define spawn_location <[spawn_location].above>
    - define spawn_location <[spawn_location].with_y[<[spawn_location].y.round_down>]>
    - teleport <[player]> <[spawn_location]>
