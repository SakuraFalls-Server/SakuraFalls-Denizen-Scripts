apartments_world:
    debug: false
    type: world
    events:
        ## session safety
        on player joins:
        - if <player.has_flag[apartments_edit]>:
            - run apartments_end_edit def.player:<player>
        ## extra details
        on delta time secondly every:2:
        - actionbar "<&6>Editing apartment <&7>[<player.flag[apartments_edit].get[apartment].id>]" targets:<server.players_flagged[apartments_edit]> per_player
        ## invalid access
        on player right clicks block:
        - if <player.is_op>:
            - stop
        - if <context.location.if_null[null]> == null:
            - stop
        - if !<proc[apartments_access].context[<player>|<context.location>]>:
            - determine cancelled
        ##
        ## complex creative safety cases
        ##
        # do not allow leaving actual apartment region
        on player walks:
        - if !<player.has_flag[apartments_edit]>:
            - stop
        - define apartment <player.flag[apartments_edit].get[apartment]>
        - if !<context.new_location.in_region[<[apartment].id>]>:
            - determine cancelled
        # forbid trying to touch non-blocks in creative inventory
        on player clicks item in inventory:
        - if !<player.has_flag[apartments_edit]>:
            - stop
        - if <context.click> != CREATIVE:
            - determine cancelled
        - if <player.open_inventory.inventory_type.if_null[CRAFTING]> != CRAFTING:
            - determine cancelled
        - if <context.item.material.is_block> && <context.cursor_item.material.is_block>:
            - stop
        - determine cancelled passively
        - wait 1t
        - inventory update destination:<player.inventory>
        - adjust <player> item_on_cursor:<item[air]>
        # handle container drops & illegal block breaks
        on player breaks block bukkit_priority:monitor:
        - if <player.is_op>:
            - stop
        # // careful: == null here; everywhere else it's != null
        - if <proc[apartments_at].context[<context.location>]> == null:
            - stop
        - if <context.location.has_inventory>:
            - if <player.gamemode> == creative:
                - if <context.location.inventory.map_slots.size> > 0:
                    - narrate "<&c>This container has items inside. You must clear it first before you can break it."
                    - determine cancelled
            - ratelimit <player> 1t
            - define contents <context.location.inventory.map_slots.values>
            - if <[contents].is_empty>:
                - stop
            - define half <context.location.material.half.if_null[null]>
            - if <[half]> == right:
                - define contents <[contents].get[1].to[27]>
            - else if <[half]> == left:
                - define contents <[contents].get[28].to[54]>
            - foreach <[contents]> as:item:
                - drop <[item]> <context.location> delay:10t
        # forbid block update and physics inside apartments
        on block physics:
        - if <context.location.material.half.if_null[null]> != null:
            - stop
        - if <proc[apartments_at].context[<context.location>]> != null:
            - determine cancelled passively
            - foreach <context.location.find_entities[dropped_item].within[1]> as:entity:
                - remove <[entity]>
        # forbid block update and physics for half blocks
        on player breaks block:
        # // careful: == null here; everywhere else it's != null
        - if <proc[apartments_at].context[<context.location>]> == null:
            - stop
        - define half <context.location.material.half.if_null[null]>
        - if <[half]> != null && !<context.location.material.advanced_matches[*trapdoor|*stairs]>:
            - if <context.new_material.name.if_null[air]> == air:
                - if <[half]> != left && <[half]> != right:
                    - modifyblock <context.location.add[<context.location.material.relative_vector>]> air no_physics
        # forbid blocks that have NBT data - such as prefilled chests
        on player places block:
        # // careful: == null here; everywhere else it's != null
        - if <proc[apartments_at].context[<context.location>]> == null:
            - stop
        - if <player.is_op>:
            - stop
        - if <context.item_in_hand.material.advanced_matches[*banner]>:
            - stop
        - if <context.item_in_hand.all_raw_nbt.exclude[display].exclude[SkullOwner].filter_tag[<[filter_value].size.is_more_than[0]>].size.if_null[0]> > 0:
            - determine cancelled
        ##
        ## simple creative safety cases
        ##
        # forbid picking up and dropping items
        on player drops item:
        - if <player.is_op>:
            - stop
        - if <player.has_flag[apartments_edit]>:
            - determine cancelled
        on player picks up item:
        - if <player.is_op>:
            - stop
        - if <player.has_flag[apartments_edit]>:
            - determine cancelled
        # forbid water flow in apartment regions
        - if <proc[apartments_at].context[<context.location>]> != null:
            - determine cancelled
        # forbid sapling/other growing things in apartment regions
        on structure grows:
        - if <proc[apartments_at].context[<context.location>]> != null:
            - determine cancelled
        on plant grows:
        - if <proc[apartments_at].context[<context.location>]> != null:
            - determine cancelled
        # forbid any items dropping even if broken in apartment regions
        on block drops item from breaking:
        - if <proc[apartments_at].context[<context.location>]> != null:
            - determine cancelled
        # forbid any tnt in apartment regions
        on tnt primes:
        - if <proc[apartments_at].context[<context.location>]> != null:
            - determine cancelled
        # forbid gravity on blocks inside apartments
        on block falls:
        - if <proc[apartments_at].context[<context.location>]> != null:
            - determine cancelled
        # forbid shulker box usage inside apartments
        on player places *shulker_box:
        - if <proc[apartments_at].context[<context.location>]> != null:
            - if !<player.is_op>:
                - determine cancelled
        # forbid mob spawner usage inside apartments
        on player places *spawner:
        - if <player.is_op>:
            - stop
        - if <proc[apartments_at].context[<context.location>]> != null:
            - determine cancelled
        # prevent lectern grab
        on player takes item from lectern:
        - if <player.is_op>:
            - stop
        - if !<proc[apartments_access].context[<player>|<context.location>]>:
            - determine cancelled
        # prevent redstone in apartments
        after redstone recalculated:
        - if <proc[apartments_at].context[<context.location>]> != null:
            - adjustblock <context.location> power:0 no_physics
        # prevent piston use in apartments
        on piston extends:
        - if <proc[apartments_at].context[<context.location>]> != null:
            - determine cancelled
