#
#   GUI Restore - deletes & restores inventories that start with
#                 some specific special chars (usually color codes)
#				  (but also anvils because of anvil_input.dsc)
#

gui_restore_config:
    debug: false
    type: data
    special_chars: <&f>邑邑邑邑

gui_restore_set_later:
    debug: false
    type: task
    definitions: player|slot|item
    script:
    - flag <[player]> gui_restore_later:<[player].flag[gui_restore_later].if_null[<map[]>].with[<[slot]>].as[<[item]>]>
    - adjust server save

gui_restore_save:
    debug: false
    type: task
    definitions: player
    script:
    - if <[player].has_flag[gui_restore]>:
        - run gui_restore_load def.player:<player>
    - flag <[player]> gui_restore:<[player].inventory.map_slots>
    - adjust server save
    - define equipment <[player].inventory.equipment_map>
    - inventory clear player:<[player]>
    - foreach <[equipment]> key:slot as:item:
        - inventory set slot:<[slot]> origin:<[item]> player:<[player]>
    - foreach <[player].flag[gui_restore_later].if_null[<map[]>]> key:slot as:item:
        - inventory set slot:<[slot]> origin:<[item]> player:<[player]>

gui_restore_load:
    debug: false
    type: task
    definitions: player
    script:
    - if !<[player].has_flag[gui_restore]>:
        - stop
    - flag <[player]> gui_restore_later:!
    - inventory clear player:<[player]>
    - foreach <[player].flag[gui_restore]> key:slot as:item:
        - inventory set slot:<[slot]> origin:<[item]> player:<[player]>
    - flag <[player]> gui_restore:!
    - adjust server save

gui_restore_world:
    debug: false
    type: world
    events:
        on player joins:
        - if <player.has_flag[gui_restore_later]>:
            - flag <player> gui_restore_later:!
            - adjust server save
        - if <player.has_flag[gui_restore]>:
            - run gui_restore_load def.player:<player>
        on player opens inventory bukkit_priority:lowest:
        - if <context.inventory.title.starts_with[<script[gui_restore_config].data_key[special_chars].parsed>]>:
            - run gui_restore_save def.player:<player>
        - if <context.inventory.inventory_type> == anvil:
            - run gui_restore_save def.player:<player>
        on player closes inventory bukkit_priority:lowest:
        - if <player.has_flag[gui_restore]>:
            - run gui_restore_load def.player:<player>
        on player changes gamemode:
        - if <player.open_inventory.title.starts_with[<script[gui_restore_config].data_key[special_chars].parsed>]>:
            - determine cancelled