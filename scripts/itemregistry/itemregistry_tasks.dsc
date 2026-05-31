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
        - define message "<&6>[<&2>Item Registry<&6>] <&4>[ERROR] Quitting <queue.script.name> early. <&c>This item is not registered - <[new_item]>; attached player: <[attached_player]>."
        - announce to_ops <[message]>
        - debug error <[message]>
        - stop
    - define data <[data].with[item].as[<[new_item]>]>
    - flag server itemregistry:<server.flag[itemregistry].if_null[<map[]>].with[<[uuid]>].as[<[data]>]>
    - adjust server save

itemregistry_print_licenses:
    debug: false
    type: task
    definitions: player|inventory
    script:
    - narrate targets:<[player]> format:formats_prefix "Scanning <[inventory]>"
    - define count 0
    - foreach <[inventory].map_slots> key:slot as:item:
        - if <[item].has_flag[itemregistry]>:
            - narrate targets:<[player]> "<&6>License found at slot=<[slot]>, item is <&f>'<[item].display.if_null[<[item].material.name>]><&f>'"
            - narrate targets:<[player]> "<&e>License ID is <[item].flag[itemregistry]>"
            - if <[player].has_permission[itemregistry.menu]>:
                - clickable save:details usages:1 until:1m:
                    - run itemregistry_menu_actions def.player:<[player]> def.item:<[item]>
                - narrate targets:<[player]> <element[<&a><&l>[ VIEW DETAILS ]].on_click[<entry[details].command>]>
                - narrate targets:<[player]> <&f>
            - define count <[count].add[1]>
    - if <[count]> == 0:
        - narrate targets:<[player]> "<&7>No licensed items found."
    - else:
        - narrate targets:<[player]> "<&7>Found <&e><[count]> items<&7>."
    - narrate targets:<[player]> <&f>

itemregistry_revoke_license:
    debug: false
    type: task
    definitions: uuid
    script:
    - define data <server.flag[itemregistry].get[<[uuid]>].if_null[null]>
    - if <[data]> == null:
        - define attached_player <player.if_null[none]>
        - define message "<&6>[<&2>Item Registry<&6>] <&4>[ERROR] Quitting <queue.script.name> early. <&c>This item is not registered - <[new_item]>; attached player: <[attached_player]>."
        - announce to_ops <[message]>
        - debug error <[message]>
        - stop
    - flag server itemregistry:<server.flag[itemregistry].exclude[<[uuid]>]>
    - adjust server save
    - define item <[data].get[item]>
    - define inventory <[data].get[inventory]>
    - if <[inventory].inventory_type> != player:
        - if <[inventory].location.if_null[null]> != null:
            - chunkload <[inventory].location.chunk> duration:10s
            - wait 1t
            - define inventory <[inventory].location.inventory>
    - if <[inventory].contains_item[<[item]>]>:
        - take item:<[item]> from:<[inventory]>

itemregistry_resync:
    debug: false
    type: task
    speed: 1
    script:
    - if <server.has_flag[itemregistry_resync]>:
        - stop
    - flag server itemregistry_resync:true
    - define message "<&6>[<&2>Item Registry<&6>] <&e>Resynchronizing Item Registry. <tern[<player.if_null[null].equals[null].not>].pass[(started by <player.name>)].fail[<empty>]>"
    - announce to_ops <[message]>
    - debug log <[message]>
    - foreach <server.flag[itemregistry].if_null[<map[]>]> key:uuid as:data:
        - define item <[data].get[item]>
        - define inventory <[data].get[inventory]>
        - if <[inventory].inventory_type> != player:
            - if <[inventory].location.if_null[null]> != null:
                - chunkload <[inventory].location.chunk> duration:10s
                - wait 1t
                - define inventory <[inventory].location.inventory>
        - if !<[inventory].contains_item[<[item]>]>:
            - if <[inventory].can_fit[<[item]>]>:
                - if <[inventory].find_empty_slots.size> > 0:
                    - give <[item]> to:<[inventory]>
                    - define message "<&6>[<&2>Item Registry<&6>] <&e>Resynced item <[item]> for <[inventory]>."
                    - announce to_ops <[message]>
                    - debug log <[message]>
    - flag server itemregistry_resync:!
    - define message "<&6>[<&2>Item Registry<&6>] <&e>Completed resync."
    - announce to_ops <[message]>
    - debug log <[message]>

itemregistry_menu:
    debug: false
    type: task
    definitions: player|page
    script:
    - if !<[player].has_permission[itemregistry.menu]>:
        - stop
    - define page <[page].if_null[0]>
    - define contents <map[]>
    - define itemregistry <server.flag[itemregistry].values.sort_by_value[get[item].display].if_null[<list[]>]>
    - if <[itemregistry].is_empty>:
        - narrate targets:<[player]> "<&c>The Item Registry is empty!"
        - stop
    - define sublist <[itemregistry].get[<[page].mul[18].add[1]>].to[<[page].add[1].mul[18]>].if_null[<list[]>]>
    - if <[page].add[1].mul[18]> < <[itemregistry].size>:
        - define next_button <item[ender_eye[display=<&2><&gt><&gt>]]>
        - definemap content_entry:
            51:
                item: <[next_button]>
                script: itemdb_menu
                definitions:
                    player: <[player]>
                    page: <[page].add[1]>
                    filter: <[filter]>
        - define contents <[contents].include[<[content_entry]>]>
    - if <[page]> > 0:
        - define previous_button <item[ender_pearl[display=<&2><&lt><&lt>]]>
        - definemap content_entry:
            49:
                item: <[previous_button]>
                script: itemdb_menu
                definitions:
                    player: <[player]>
                    page: <[page].sub[1]>
                    filter: <[filter]>
        - define contents <[contents].include[<[content_entry]>]>
    - foreach <[sublist]> as:data:
        - define item_button <[data].get[item]>
        - define inventory <[data].get[inventory]>
        - define player_maybe <player[<[inventory].escaped.substring[28,63].if_null[null]>].if_null[null]>
        - define location <tern[<[inventory].inventory_type.equals[PLAYER]>].pass[Held by <[player_maybe].name>].fail[At <[inventory].location.simple>]>
        - adjust def:item_button lore:<list[<&6>License ID: <&f><[data].get[uuid]>|<&6>Item: <&f><[data].get[item].material.name>,<[data].get[item].custom_model_data>|<&6>Location: <&f><[location]>]>
        - define contents <[contents].with[<[loop_index].add[9]>].as[<map[].with[item].as[<[item_button]>].with[script].as[itemregistry_menu_actions].with[definitions].as[<map[].with[player].as[<[player]>].with[item].as[<[data].get[item]>]>]>]>
    - run menu_open def.player:<[player]> def.title:<&f>邑<&sp>邑邑邑邑酕<&a><&sp><&b><&sp><&e><&sp> def.size:54 def.contents:<[contents]>

itemregistry_menu_actions:
    debug: false
    type: task
    definitions: player|item
    script:
    - if !<[player].has_permission[itemregistry.menu]>:
        - stop
    - inventory close player:<[player]>
    - define data <server.flag[itemregistry].get[<[item].flag[itemregistry]>]>
    - define inventory <[data].get[inventory]>
    - define player_maybe <player[<[inventory].escaped.substring[28,63].if_null[null]>].if_null[null]>
    - define location <tern[<[inventory].inventory_type.equals[PLAYER]>].pass[Held by <[player_maybe].name>].fail[At <[inventory].location.simple>]>
    - narrate targets:<[player]> <&f>
    - narrate targets:<[player]> format:formats_prefix "Item <&f><[item].display.if_null[<[item].material.name>]><&7>:"
    - narrate targets:<[player]> "<&6>License ID: <&f><[data].get[uuid]>"
    - narrate targets:<[player]> "<&6>Item: <&f><[data].get[item].material.name>,<[data].get[item].custom_model_data>"
    - narrate targets:<[player]> "<&6>Location: <&f><[location]>"
    - narrate targets:<[player]> <&f>
    - if <[player].has_permission[itemregistry.update]>:
        #
        - clickable save:update_confirm usages:1 until:1m:
            - if <[player].item_in_hand.flag[itemregistry].equals[<[data].get[uuid]>].not.if_null[true]>:
                - narrate targets:<[player]> "<&c>You are not updating this item correctly! First, obtain the licensed item from the current holder, change what you want, and while holding it re-use this operation."
                - stop
            - clickable save:update usages:1 until:1m:
                - if <[player].item_in_hand.flag[itemregistry].equals[<[data].get[uuid]>].not.if_null[true]>:
                    - narrate targets:<[player]> "<&c>You are not updating this item correctly! First, obtain the licensed item from the current holder, change what you want, and while holding it re-use this operation."
                    - stop
                - ~run itemregistry_adjust_actual_item def.uuid:<[data].get[uuid]> def.new_item:<[player].item_in_hand>
                - narrate targets:<[player]> format:formats_prefix "Adjusted licensed item <[data].get[uuid]>."
            - narrate targets:<[player]> "<&c>Are you sure? There is <&4>no way to undo this<&c>.<&nl><element[<&4>[ I UNDERSTAND ]].on_click[<entry[update].command>]>"
        - narrate targets:<[player]> <element[<&c><&l>[ UPDATE ITEM ]].on_click[<entry[update_confirm].command>]>
        #
        - clickable save:revoke_confirm usages:1 until:1m:
            - clickable save:revoke usages:1 until:1m:
                - ~run itemregistry_revoke_license def.uuid:<[data].get[uuid]>
                - narrate targets:<[player]> format:formats_prefix "Revoked license <[data].get[uuid]>."
            - narrate targets:<[player]> "<&c>Are you sure? There is <&4>no way to undo this<&c>.<&nl><element[<&4>[ I UNDERSTAND ]].on_click[<entry[revoke].command>]>"
        - narrate targets:<[player]> <element[<&c><&l>[ REVOKE LICENSE ]].on_click[<entry[revoke_confirm].command>]>
        - stop
    - narrate targets:<[player]> <&f>
