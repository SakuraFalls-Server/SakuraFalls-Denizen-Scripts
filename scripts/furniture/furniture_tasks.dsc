furniture_cmd_to_noteblock:
    debug: false
    type: procedure
    definitions: cmd
    script:
    - define data <script[furniture_config].data_key[noteblock]>
    - if !<[data].contains[<[cmd]>]>:
        - determine null
    - define noteblock_data <[data].get[<[cmd]>].get[is].split[,]>
    - define instrument <[noteblock_data].get[1]>
    - define note <[noteblock_data].get[2]>
    - define switched <[noteblock_data].get[3]>
    - determine <material[note_block[instrument=<[instrument]>;note=<[note]>;switched=<[switched]>]]>

furniture_custom_block_any:
    debug: false
    type: procedure
    definitions: material|cmd
    script:
    - define data <script[furniture_config].data_key[custom_block]>
    - determine <[data].contains[<[material].name>,<[cmd]>]>

furniture_cmd_to_custom_block_collision:
    debug: false
    type: procedure
    definitions: material|cmd
    script:
    - define data <script[furniture_config].data_key[custom_block]>
    - if !<[data].contains[<[material].name>,<[cmd]>]>:
        - determine null
    - determine <[data].get[<[material].name>,<[cmd]>].get[collision]>

furniture_all_items_sorted:
    debug: false
    type: procedure
    script:
    - define items <list[]>
    - foreach <script[furniture_config].data_key[noteblock]> key:noteblock_cmd as:noteblock_data:
        - define noteblock <item[note_block[display=<&f><[noteblock_data].get[represents]>;custom_model_data=<[noteblock_cmd]>]]>
        - define items <[items].include[<[noteblock]>]>
    - foreach <script[furniture_config].data_key[custom_block]> key:custom_block_item_details as:custom_block_data:
        - define custom_block_type_cmd_split <[custom_block_item_details].split[,]>
        - define custom_item <item[<[custom_block_type_cmd_split].get[1]>[display=<&f><[custom_block_data].get[represents]>;custom_model_data=<[custom_block_type_cmd_split].get[2]>;hides=all]]>
        - define items <[items].include[<[custom_item]>]>
    - define items <[items].sort_by_value[display]>
    - determine <[items]>

furniture_menu:
    debug: false
    type: task
    definitions: player|page
    script:
    - define page <[page].if_null[0]>
    - define items <proc[furniture_all_items_sorted].get[<[page].mul[45].add[1]>].to[<[page].add[1].mul[45]>]>
    - define contents <map[]>
    - foreach <[items]> as:item:
        - definemap item_entry:
            item: <[item]>
            script: furniture_menu_give
            definitions:
                player: <[player]>
                item: <[item]>
        - define contents <[contents].with[<[loop_index]>].as[<[item_entry]>]>
    - if <[page]> > 0:
        - definemap contents_extra:
            49:
                item: <item[ender_pearl[display=<&a><&lt><&lt>]]>
                script: furniture_menu
                definitions:
                    player: <[player]>
                    page: <[page].sub[1]>
        - define contents <[contents].include[<[contents_extra]>]>
    - if <[page].add[1].mul[27]> < <[contents].size>:
        - definemap contents_extra:
            51:
                item: <item[ender_eye[display=<&a><&gt><&gt>]]>
                script: furniture_menu
                definitions:
                    player: <[player]>
                    page: <[page].add[1]>
        - define contents <[contents].include[<[contents_extra]>]>
    - run menu_open def.player:<[player]> "def.title:<&b> 邑邑<&f>邑邑邑邑鄊" def.size:54 def.contents:<[contents]>

furniture_menu_give:
    debug: false
    type: task
    definitions: player|item
    script:
    - if !<[player].inventory.can_fit[<[item]>]>:
        - narrate targets:<[player]> "<&c>You do not have enough space in your inventory!"
        - stop
    - give player:<[player]> <[item]> quantity:1
