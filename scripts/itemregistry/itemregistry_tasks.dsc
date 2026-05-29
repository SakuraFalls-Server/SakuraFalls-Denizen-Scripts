itemregistry_update_tracker:
    debug: false
    type: task
    definitions: item|new_inventory
    script:
    - define uuid <[item].flag[itemregistry].if_null[null]>
    - if <[uuid]> == null:
        - define attached_player <player.if_null[none]>
        - define message "<&6>[<&2>Item Registry<&6>] <&4>[ERROR] Quitting <queue.script.name> early. <&c>Unknown uuid: uuid was null, for item <[item]>; attached player: <[attached_player]>; new inventory: <[new_inventory]>"
        - announce to_ops <[message]>
        - debug error <[message]>
        - stop
    - define data <map[].with[item].as[<[item]>].with[uuid].as[<[uuid]>].with[inventory].as[<[new_inventory]>]>
    - flag server itemregistry:<server.flag[itemregistry].if_null[<map[]>].with[<[uuid]>].as[<[data]>]>
    - adjust server save

itemregistry_registered_items_pattern:
    debug: false
    type: procedure
    script:
    - determine <script[itemregistry_config].data_key[registered].separated_by[|]>

itemregistry_generate_item:
    debug: false
    type: task
    definitions: initial_holder|item|cmd
    script:
    - define cmd <[cmd].if_null[0]>
    - if !<material[<[item]>].advanced_matches[<proc[itemregistry_registered_items_pattern]>]>:
        - define message "<&6>[<&2>Item Registry<&6>] <&4>[ERROR] Quitting <queue.script.name> early. <&c>Tried to generate non-registerable item <[item]> with custom model data <[cmd]>; initial holder: <[initial_holder]>"
        - announce to_ops <[message]>
        - debug error <[message]>
        - stop
    - if <[cmd].equals[0].if_null[true]>:
        - define message "<&6>[<&2>Item Registry<&6>] <&4>[ERROR] Quitting <queue.script.name> early. <&c>Tried to generate item <[item]> with custom model data zero (0), which is invalid; initial holder: <[initial_holder]>"
        - announce to_ops <[message]>
        - debug error <[message]>
        - stop
    - define uuid <util.random_uuid>
    - define item <item[<[item]>[custom_model_data=<[cmd]>]]>
    - flag <[item]> itemregistry:<[uuid]>
    - ~run itemregistry_update_tracker def.item:<[item]> def.new_inventory:<[initial_holder].inventory>
    - give <[item]> player:<[initial_holder]>
    - determine <[item]>

itemregistry_matches_known_data:
    debug: false
    type: procedure
    definitions: item|current_inventory
    script:
    - if <[item].custom_model_data.equals[0].if_null[true]>:
        - determine false
    - define uuid <[item].flag[itemregistry].if_null[null]>
    - if <[uuid]> == null:
        - determine false
    - define data <server.flag[itemregistry].get[<[uuid]>].if_null[null]>
    - if <[data]> == null:
        - determine false
    - if <[data].get[item]> != <[item]>:
        - determine false
    - determine <[current_inventory].equals[<[data].get[inventory]>]>

itemregistry_adjust_actual_item:
    debug: false
    type: task
    definitions: uuid|new_item
    script:
    - flag <[new_item]> itemregistry:<[uuid]>
    - define data <server.flag[itemregistry].get[<[uuid]>].if_null[null]>
    - if <[data]> == null:
        - define attached_player <player.if_null[none]>
        - define message "<&6>[<&2>Item Registry<&6>] <&4>[ERROR] Quitting <queue.script.name> early. <&c>This item is not registered - <[item]>; attached player: <[attached_player]>."
        - announce to_ops <[message]>
        - debug error <[message]>
        - stop
    - define data <[data].with[item].as[<[new_item]>]>
    - flag server itemregistry:<server.flag[itemregistry].if_null[<map[]>].with[<[uuid]>].as[<[data]>]>
    - adjust server save

itemregistry_print_licenses:
    debug: false
    type: task
    definitions: inventory
    script:
    - foreach <[inventory].map_slots> key:slot as:item:
        - if <[item].has_flag[itemregistry]>:
            - narrate "<&6>License at slot=<[slot]>, item is <&f>'<[item].display.if_null[<[item].material.name>]><&f>'"
            - narrate "<&e>== <[item].flag[itemregistry]>"
        - else:
            - narrate "<&7>None for slot=<[slot]>, item is <[item].display.if_null[<[item].material.name>]>"

itemregistry_revoke_license:
    debug: false
    type: task
    definitions: uuid
    script:
    - flag server itemregistry:<server.flag[itemregistry].exclude[<[uuid]>]>
    - adjust server save

itemregistry_resync:
    debug: false
    type: task
    speed: 1
    script:
    - define message "<&6>[<&2>Item Registry<&6>] <&e>Resynchronizing Item Registry. <tern[<player.if_null[null].equals[null].not>].pass[(started by <player.name>)].fail[<empty>]>"
    - announce to_ops <[message]>
    - debug log <[message]>
    - foreach <server.flag[itemregistry].if_null[<map[]>]> key:uuid as:data:
        - define item <[data].get[item]>
        - define inventory <[data].get[inventory]>
        - if <[inventory].inventory_type> != player:
            - if <[inventory].location.if_null[null]> != null:
                - ~chunkload <[inventory].location.chunk> duration:10s
        - if !<[inventory].contains_item[<[item]>]>:
            - if <[inventory].can_fit[<[item]>]>:
                - give <[item]> quantity:1 to:<[inventory]>
                - define message "<&6>[<&2>Item Registry<&6>] <&e>Resynced item <[item]> for <[inventory]>."
                - announce to_ops <[message]>
                - debug log <[message]>