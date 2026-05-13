no_duping_custom_items:
    debug: false
    type: world
    events:
        on player clicks item in inventory:
        - if <context.inventory.title.contains_any_text[<script[no_duping_custom_items_config].data_key[whitelist_titles]>]>:
            - stop
        - if <player.is_op>:
            - stop
        - if <player.gamemode> != creative:
            - stop
        - if <context.item.material.advanced_matches[note_block|iron_sword].if_null[true]> && <context.cursor_item.material.advanced_matches[note_block|iron_sword].if_null[true]>:
            - stop
        - if <context.item.has_custom_model_data.if_null[false]> || <context.cursor_item.has_custom_model_data.if_null[false]>:
            - determine cancelled passively
            - adjust <player> item_on_cursor:air
            - inventory update
        on player drags in inventory:
        - if <player.is_op>:
            - stop
        - if <player.gamemode> != creative:
            - stop
        - if <context.item.material.advanced_matches[note_block|iron_sword].if_null[true]> && <context.cursor_item.material.advanced_matches[note_block|iron_sword].if_null[true]>:
            - stop
        - if <context.item.has_custom_model_data.if_null[false]> || <context.cursor_item.has_custom_model_data.if_null[false]>:
            - determine cancelled passively
            - adjust <player> item_on_cursor:air
            - inventory update

no_duping_custom_items_config:
    debug: false
    type: data
    whitelist_titles:
    - 鄊
