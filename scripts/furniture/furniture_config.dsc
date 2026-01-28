furniture_config:
    debug: false
    type: data
    # Furniture using note block states
    noteblock:
        # note_block, custom_model_data = 1 when held
        1:
            represents: Locker (East)
            is: piano,1,false
        2:
            represents: Locker (South)
            is: piano,2,false
        3:
            represents: Locker (West)
            is: piano,3,false
        4:
            represents: Locker (North)
            is: piano,4,false
    # Furniture using custom_block.dsc library
    custom_block:
        # iron_horse_armor, custom_model_data = 1 when held
        iron_horse_armor,1:
            represents: School Chair
            collision: skeleton_skull
        iron_horse_armor,2:
            represents: TV
            collision: barrier
        iron_horse_armor,3:
            represents: Book (open)
            collision: warped_trapdoor
        iron_horse_armor,4:
            represents: Book
            collision: warped_trapdoor
        iron_horse_armor,5:
            represents: Book Stack
            collision: skeleton_skull
        iron_horse_armor,6:
            represents: Desk Lamp
            collision: red_sandstone_wall
        iron_horse_armor,7:
            represents: Clipboard
            collision: warped_trapdoor
        iron_horse_armor,8:
            represents: Vending Machine
            collision: barrier
    # List of collision blocks - disables interaction without perms
    collision_blocks:
    #- skeleton_skull
    #- red_sandstone_Wall
    - warped_trapdoor
