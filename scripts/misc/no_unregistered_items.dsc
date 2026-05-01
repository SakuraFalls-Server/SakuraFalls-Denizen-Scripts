no_unregistered_items_temp_patch:
    debug: false
    type: world
    events:
        on player clicks in inventory:
        - if <player.is_op>:
            - stop
        # clicked item
        - if <context.item.material.advanced_matches[iron_sword]>:
            - if <context.item.custom_model_data.if_null[0]> != 0:
                - if !<context.item.has_flag[itemregistry]>:
                    - determine cancelled passively
                    - inventory set slot:<context.slot> origin:air
                    - inventory update
        # hover item
        - if <context.cursor_item.material.advanced_matches[iron_sword]>:
            - if <context.cursor_item.custom_model_data.if_null[0]> != 0:
                - if !<context.item.has_flag[itemregistry]>:
                    - determine cancelled passively
                    - adjust <player> item_on_cursor:air
        on player drags in inventory:
        - if <player.is_op>:
            - stop
        - if <context.item.material.advanced_matches[iron_sword]>:
            - if <context.item.custom_model_data.if_null[0]> != 0:
                - if !<context.item.has_flag[itemregistry]>:
                    - determine cancelled passively
                    - adjust <player> item_on_cursor:air
                    - narrate "<&6>[<&c>!<&6>] <&c>Unregistered weapon/item prone to duping will be removed from inventory."
        on player scrolls their hotbar:
        - if <player.is_op>:
            - stop
        - define item <player.inventory.slot[<context.new_slot>]>
        - if <[item].material.advanced_matches[iron_sword]>:
            - if <[item].custom_model_data.if_null[0]> != 0:
                - if !<[item].has_flag[itemregistry]>:
                    - determine cancelled passively
                    - inventory set slot:<context.new_slot> origin:air
                    - inventory update
                    - narrate "<&6>[<&c>!<&6>] <&c>Unregistered weapon/item prone to duping will be removed from inventory."
        on player drops item:
        - if <player.is_op>:
            - stop
        - define item <context.item>
        - if <[item].material.advanced_matches[iron_sword]>:
            - if <[item].custom_model_data.if_null[0]> != 0:
                - if !<[item].has_flag[itemregistry]>:
                    - determine cancelled
        on player picks up item:
        - if <player.is_op>:
            - stop
        - define item <context.item>
        - if <[item].material.advanced_matches[iron_sword]>:
            - if <[item].custom_model_data.if_null[0]> != 0:
                - if !<[item].has_flag[itemregistry]>:
                    - determine cancelled
        on player swaps items:
        - if <player.is_op>:
            - stop
        - define item <context.main>
        - if <[item].material.advanced_matches[iron_sword]>:
            - if <[item].custom_model_data.if_null[0]> != 0:
                - if !<[item].has_flag[itemregistry]>:
                    - determine cancelled passively
                    - inventory set slot:hand item:air
                    - inventory update
                    - narrate "<&6>[<&c>!<&6>] <&c>Unregistered weapon/item prone to duping will be removed from inventory."
        - define item <context.offhand>
        - if <[item].material.advanced_matches[iron_sword]>:
            - if <[item].custom_model_data.if_null[0]> != 0:
                - if !<[item].has_flag[itemregistry]>:
                    - determine cancelled passively
                    - inventory set slot:offhand item:air
                    - inventory update
                    - narrate "<&6>[<&c>!<&6>] <&c>Unregistered weapon/item prone to duping will be removed from inventory."


