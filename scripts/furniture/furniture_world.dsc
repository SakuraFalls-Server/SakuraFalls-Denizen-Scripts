# NOTE BLOCK HANDLERS
furniture_world_noteblock:
    debug: false
    type: world
    events:
        on player places note_block:
        - if <player.item_in_hand.custom_model_data.if_null[0]> > 0:
            - define noteblock <proc[furniture_cmd_to_noteblock].context[<context.item_in_hand.custom_model_data.if_null[null]>]>
            - if <[noteblock]> != null:
                - modifyblock <context.location> <[noteblock]> no_physics
                - stop
        - adjustblock <context.location> note:0
        - adjustblock <context.location> instrument:piano
        - adjustblock <context.location> switched:false
        on player right clicks note_block:
        - if !<player.is_sneaking>:
            - determine cancelled
        on player breaks block:
        - if <context.location.below.material.advanced_matches[note_block]>:
            - run furniture_world_note_block_undo_update def.at:<context.location.below>
        - if <context.location.above.material.advanced_matches[note_block]>:
            - run furniture_world_note_block_undo_update def.at:<context.location.above>
        on player places block:
        - if <context.location.below.material.advanced_matches[note_block]>:
            - run furniture_world_note_block_undo_update def.at:<context.location.below>
        - if <context.location.above.material.advanced_matches[note_block]>:
            - run furniture_world_note_block_undo_update def.at:<context.location.above>

furniture_world_note_block_undo_update:
    debug: false
    type: task
    definitions: at
    script:
    - define old_material <[at].material>
    - modifyblock <[at]> <[old_material]> no_physics delayed

# CUSTOM BLOCK HANDLERS
furniture_world_custom_block:
    debug: false
    type: world
    events:
        on player right clicks block:
        - if !<player.has_permission[furniture.customblock.place]> && !<player.is_op>:
            - stop
        - if <context.item.material.advanced_matches[air]>:
        	- stop
        - if !<proc[furniture_custom_block_any].context[<context.item.material>|<context.item.custom_model_data.if_null[0]>]>:
            - stop
        - ratelimit <player> 5t
        - determine cancelled passively
        #
        - define cursor_solid <player.cursor_on_solid[5].if_null[null]>
        - if <[cursor_solid]> == null:
            - stop
        - define block_face_normal <player.eye_location.ray_trace[range=10;return=normal;ignore=<player>;fluids=false;nonsolids=false]>
        - define target_block <[cursor_solid].add[<[block_face_normal]>]>
        - if <[target_block].material.is_solid>:
            - stop
        #
        - define material <context.item.material.name>[custom_model_data=<context.item.custom_model_data>]
        #
        - define pitch <tern[<player.eye_location.pitch.is_more_than_or_equal_to[0]>].pass[0].fail[180]>
        - define yaw <player.eye_location.yaw.div_int[45].add[1].div_int[2]>
        - if <[yaw]> == 1:
            - define yaw 90
        - if <[yaw]> == 2:
            - define yaw 180
        - if <[yaw]> == 3:
            - define yaw -90
        - if <[yaw]> == 4:
            - define yaw 0
        #
        - define collision_block <proc[furniture_cmd_to_custom_block_collision].context[<context.item.material>|<context.item.custom_model_data>]>
        - modifyblock <[target_block]> <[collision_block]> no_physics
        #
        - run custom_block_create def.at:<[target_block]> def.material:<[material]> def.pitch:<[pitch]> def.yaw:<[yaw]>
        - animate <player> animation:ARM_SWING
        - playsound sound:BLOCK_STONE_PLACE <player> sound_category:blocks pitch:0.7
        on player breaks block:
        - if <proc[custom_block_at].context[<context.location>]> == null:
            - stop
        - if !<player.has_permission[furniture.customblock.break]> && !<player.is_op>:
        	- determine cancelled passively
            - stop
        - run custom_block_destroy def.at:<context.location>
        #
        # WORLDEDIT COMPATIBILITY
        #
        on custom event id:worldedit_edit:
        - announce to_ops "Actor: <context.actor>; Locations: <context.locations>"

# COLLISION BLOCK HANDLERS
furniture_world_collision_block:
    debug: false
    type: world
    events:
        on player right clicks block bukkit_priority:high:
        - if <context.location.if_null[null]> == null:
        	- stop
        - if !<player.has_permission[furniture.collisionblock.interact]> && !<player.is_op>:
            - stop
        - if <context.location.material.advanced_matches[air].if_null[false]>:
            - stop
        - if <script[furniture_config].data_key[collision_blocks].contains[<context.location.material.name>].if_null[false]>:
            - determine cancelled
