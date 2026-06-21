templatetools_world_cleanup:
    debug: false
    type: world
    events:
        after server start:
        - foreach <schematic.list.filter_tag[<[filter_value].starts_with[templatetools_]>]> as:schematic:
            - schematic unload name:<[schematic]>
        - foreach <server.players_flagged[templatetools_undo]> as:player:
            - flag <[player]> templatetools_undo:!

templatetools_world_preview:
    debug: false
    type: world
    events:
        on player walks:
        - if !<player.item_in_hand.advanced_matches[spider_eye]>:
            - stop
        - if !<player.has_permission[templatetools.tools.schematic]>:
            - stop
        - if !<player.has_flag[templatetools_pack]>:
            - stop
        - if !<player.has_flag[templatetools_schematic]>:
            - stop
        - run templatetools_preview_queue def.player:<player> def.schematic:<player.flag[templatetools_schematic]>
        on player scrolls their hotbar:
        - if !<player.has_permission[templatetools.tools.schematic]>:
            - stop
        - if !<player.has_flag[templatetools_pack]>:
            - stop
        - if <player.is_sneaking>:
            - if !<player.item_in_hand.advanced_matches[spider_eye]>:
                - stop
            - determine cancelled passively
            - if <context.new_slot> > <context.previous_slot>:
                - if <context.previous_slot> == 1 && <context.new_slot> == 9:
                    - run templatetools_pack_increment def.player:<player>
                - else:
                    - run templatetools_pack_decrement def.player:<player>
            - else:
                - if <context.previous_slot> == 9 && <context.new_slot> == 1:
                    - run templatetools_pack_decrement def.player:<player>
                - else:
                    - run templatetools_pack_increment def.player:<player>
            - run templatetools_schematic_set_index def.player:<player>
            - run templatetools_preview_queue def.player:<player> def.schematic:<player.flag[templatetools_schematic]>
        - else:
            - if !<player.has_flag[templatetools_schematic]>:
                - stop
            - if <player.inventory.slot[<context.new_slot>].material.name> == spider_eye:
                - run templatetools_preview_queue def.player:<player> def.schematic:<player.flag[templatetools_schematic]>
            - else:
                - run templatetools_preview_clear def.player:<player>
        after player clicks in inventory:
        - if !<player.has_permission[templatetools.tools.schematic]>:
            - stop
        - if !<player.has_flag[templatetools_pack]>:
            - stop
        - if !<player.has_flag[templatetools_schematic]>:
            - stop
        - if <player.item_in_hand.advanced_matches[spider_eye]>:
            - run templatetools_preview def.player:<player> def.schematic:<player.flag[templatetools_schematic]>
            - determine cancelled passively
        - else:
            - run templatetools_preview_clear def.player:<player>
        on player left clicks block:
        - if !<player.has_permission[templatetools.tools.schematic]>:
            - stop
        - if !<player.item_in_hand.advanced_matches[spider_eye]>:
            - stop
        - if !<player.has_flag[templatetools_pack]>:
            - stop
        - if !<player.has_flag[templatetools_schematic]>:
            - stop
        - determine cancelled passively
        - if <player.is_sneaking>:
            - schematic rotate name:<player.flag[templatetools_schematic]> angle:90
            - run templatetools_preview_queue def.player:<player> def.schematic:<player.flag[templatetools_schematic]>
            - actionbar "<&e>Rotated schematic 90 degrees."
        - else:
            - run templatetools_preview_paste def.player:<player> def.schematic:<player.flag[templatetools_schematic]> save:return
            - define count <entry[return].created_queue.determination.get[1]>
            - narrate format:templatetools_formats_main "Placed schematic (<[count]>)."

templatetools_world_redtorchtool:
    debug: false
    type: world
    events:
        on player right clicks block:
        - if !<player.has_permission[templatetools.tools.redtorch]>:
            - stop
        - if !<player.item_in_hand.advanced_matches[redstone_torch]>:
            - stop
        - if <player.is_sneaking>:
            - stop
        - if <context.location.material.switched.if_null[null]> != null:
            - determine cancelled passively
            - switch <context.location> no_physics
            - narrate format:templatetools_formats_main "Switched block state."