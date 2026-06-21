wardrobe_world:
    debug: false
    type: world
    events:
        on player joins:
        - flag <player> wardrobe_latest:<player.skin_blob>
        - if <player.has_flag[wardrobe_current]>:
            - adjust <player> skin_blob:<player.flag[wardrobe_current]>
        on player clicks in inventory:
        - if !<context.inventory.title.contains[鄇]>:
            - stop
        - determine cancelled passively
        # - if <context.slot> > <context.inventory.size>:
        #     - stop
        - if <context.item.advanced_matches[wither_skeleton_skull]>:
            - run wardrobe_save_latest def.player:<player>
            - inventory close
            - wait 1t
            - run wardrobe_menu def.player:<player>
        - else if <context.item.advanced_matches[player_head]>:
            - if <context.click> == right:
                - run wardrobe_delete def.player:<player> def.skin_blob:<context.item.flag[wardrobe]>
                - inventory close
                - wait 1t
                - run wardrobe_menu def.player:<player>
            - else:
                - if <player.vehicle.if_null[null]> != null:
                    - stop
                - run wardrobe_apply def.player:<player> def.skin_blob:<context.item.flag[wardrobe]>
                - inventory close
        - else if <context.item.advanced_matches[warped_trapdoor]>:
            - if <player.vehicle.if_null[null]> != null:
                - stop
            - run wardrobe_clear def.player:<player>
