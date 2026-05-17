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
        iron_horse_armor,9:
            represents: Barstool
            collision: barrier
        iron_horse_armor,10:
            represents: Two Shelf Table (Light)
            collision: barrier
        iron_horse_armor,11:
            represents: Two Shelf Table (Dark)
            collision: barrier
        iron_horse_armor,12:
            represents: Air Conditioner (White)
            collision: barrier
            always_upright: true
        iron_horse_armor,13:
            represents: Air Conditioner (Black)
            collision: barrier
            always_upright: true
        iron_horse_armor,14:
            represents: Aquarium (White)
            collision: barrier
        iron_horse_armor,15:
            represents: Aquarium (Black)
            collision: barrier
        iron_horse_armor,16:
            represents: Bookshelf (White)
            collision: barrier
        iron_horse_armor,17:
            represents: Bookshelf (Black)
            collision: barrier
        iron_horse_armor,18:
            represents: Bookshelf (Wooden)
            collision: barrier
        iron_horse_armor,19:
            represents: Bookshelf (Dark)
            collision: barrier
        iron_horse_armor,20:
            represents: Ceiling Fan (White)
            collision: skeleton_skull
            always_upright: true
        iron_horse_armor,21:
            represents: Ceiling Fan (Black)
            collision: skeleton_skull
            always_upright: true
        iron_horse_armor,22:
            represents: Coffee Table (White)
            collision: barrier
        iron_horse_armor,23:
            represents: Coffee Table (Black)
            collision: barrier
        iron_horse_armor,24:
            represents: Coffee Table (Wooden)
            collision: barrier
        iron_horse_armor,25:
            represents: Coffee Table (Dark)
            collision: barrier
    # List of collision blocks - disables interaction without perms
    collision_blocks:
    #- skeleton_skull
    #- red_sandstone_Wall
    - warped_trapdoor
