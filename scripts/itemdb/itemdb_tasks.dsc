itemdb_has:
    debug: false
    type: procedure
    definitions: item
    script:
    - determine <server.flag[itemdb].if_null[<list[]>].filter_tag[<[filter_value].display.strip_color.to_lowercase.equals[<[item].display>].or[<[filter_value].material.equals[<[item].material>].and[<[filter_value].custom_model_data.equals[<[item].custom_model_data>]>]>]>].is_empty.not>

itemdb_store:
    debug: false
    type: task
    definitions: item
    script:
    - flag server itemdb:<server.flag[itemdb].if_null[<list[]>].include[<[item]>].sort_by_value[display]>

itemdb_unstore:
    debug: false
    type: task
    definitions: name
    script:
    - flag server itemdb:<server.flag[itemdb].if_null[<list[]>].filter_tag[<[filter_value].display.strip_color.to_lowercase.equals[<[name]>].not>]>

itemdb_get:
    debug: false
    type: procedure
    definitions: name
    script:
    - determine <server.flag[itemdb].if_null[<list[]>].filter_tag[<[filter_value].display.strip_color.to_lowercase.equals[<[name]>]>].first.if_null[null]>

itemdb_menu:
    debug: false
    type: task
    definitions: player|page|filter
    script:
    - define page <[page].if_null[0]>
    - define contents <map[]>
    - if <[filter]> != null:
        - define itemdb <server.flag[itemdb].filter_tag[<[filter_value].display.strip_color.to_lowercase.contains[<[filter].to_lowercase>]>].if_null[<list[]>]>
    - else:
        - define itemdb <server.flag[itemdb].if_null[<list[]>]>
    - if <[itemdb].is_empty>:
        - if <[filter]> != null:
            - narrate targets:<[player]> "<&c>No item with filter '<[filter]>' exists in the database!"
        - else:
            - narrate targets:<[player]> "<&c>The database is empty!"
        - stop
    - define sublist <[itemdb].get[<[page].mul[45].add[1]>].to[<[page].add[1].mul[45]>].if_null[<list[]>]>
    - if <[page].add[1].mul[45]> < <[itemdb].size>:
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
    - foreach <[sublist]> as:item:
        - define item_button <[item]>
        - define contents <[contents].with[<[loop_index]>].as[<map[].with[item].as[<[item_button]>].with[script].as[itemdb_give].with[definitions].as[<map[].with[player].as[<[player]>].with[item].as[<[item]>]>]>]>
    - run menu_open def.player:<[player]> def.title:<&f>邑<&sp>邑邑邑邑酕<&a><&sp><&b><&sp><&e><&sp> def.size:54 def.contents:<[contents]>

itemdb_give:
    debug: false
    type: task
    definitions: player|item
    script:
    - if !<[player].inventory.can_fit[<[item]>]>:
        - narrate "<&c>You don't have enough space in your inventory."
        - stop
    - give <[item]> quantity:1 player:<[player]>
