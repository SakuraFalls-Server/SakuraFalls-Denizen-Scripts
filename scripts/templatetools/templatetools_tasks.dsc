templatetools_available_packs:
    debug: false
    type: procedure
    script:
    - determine <util.list_files[schematics].filter_tag[<[filter_value].advanced_matches[*.*].not>]>

templatetools_pack_length:
    debug: false
    type: procedure
    definitions: player
    script:
    - if !<[player].has_flag[templatetools_pack]>:
        - determine 0
    - determine <proc[templatetools_available_schematics].context[<[player]>].size>

templatetools_pack_increment:
    debug: false
    type: task
    definitions: player
    script:
    - define pack_length <proc[templatetools_pack_length].context[<[player]>]>
    - if <[pack_length]> == 0:
        - stop
    - define index <[player].flag[templatetools_pack_index].add[1]>
    - if <[index]> > <[pack_length]>:
        - define index 1
    - flag <[player]> templatetools_pack_index:<[index]>

templatetools_pack_decrement:
    debug: false
    type: task
    definitions: player
    script:
    - define pack_length <proc[templatetools_pack_length].context[<[player]>]>
    - if <[pack_length]> == 0:
        - stop
    - define index <[player].flag[templatetools_pack_index].sub[1]>
    - if <[index]> < 1:
        - define index <[pack_length]>
    - flag <[player]> templatetools_pack_index:<[index]>

templatetools_available_schematics:
    debug: false
    type: procedure
    definitions: player
    script:
    - if !<[player].has_flag[templatetools_pack]>:
        - determine <list[]>
    - determine <util.list_files[schematics/<[player].flag[templatetools_pack]>].parse_tag[<[parse_value].replace_text[regex:.schem$].with[]>].if_null[<list[]>].alphanumeric>

templatetools_schematic_set_index:
    debug: false
    type: task
    definitions: player
    script:
    - define schematics <proc[templatetools_available_schematics].context[<[player]>]>
    - if <schematic.list.contains[<[player].flag[templatetools_schematic]>]>:
    	- ~schematic unload name:<[player].flag[templatetools_schematic]>
    - schematic load name:templatetools_<[player].uuid> filename:<[player].flag[templatetools_pack]>/<[schematics].get[<[player].flag[templatetools_pack_index]>]>
    - actionbar "<&e>Schematic <[player].flag[templatetools_pack_index]>: <&f><[schematics].get[<[player].flag[templatetools_pack_index]>]>" targets:<[player]>

templatetools_preview_queue:
    debug: false
    type: task
    definitions: player|schematic
    script:
    - if <[player].has_flag[templatetools_preview_queue]>:
        - stop
    - flag <[player]> templatetools_preview_queue:true expire:0.5s
    - wait 0.5s
    - if !<schematic.list.contains[<[schematic]>]>:
        - stop
    - waituntil <schematic[<[schematic]>].width.if_null[-1]> != -1 max:2s
    - flag <[player]> templatetools_preview_queue:!
    - run templatetools_preview def.player:<[player]> def.schematic:<[schematic]>

templatetools_preview_show:
    debug: false
    type: task
    definitions: player|schematic
    script:
    - define cursor_on <[player].cursor_on.if_null[null]>
    - if <[cursor_on]> == null:
        - stop
    - if !<schematic.list.contains[<[schematic]>]>:
        - stop
    - define cuboid <schematic[<[schematic]>].cuboid[<[cursor_on]>]>
    - define middle <[cuboid].center>
    - define smallest_y <[cuboid].corners.get[first].y>
    - if <[cuboid].corners.get[last].y> < <[smallest_y]>:
        - define smallest_y <[cuboid].corners.get[last].y>
    - define difference_y <[cursor_on].y.sub[<[smallest_y]>]>
    - define cursor_on <[cursor_on].sub[0,<[difference_y].sub[1]>,0]>
    - define fakedlocations <list[]>
    - if !<[player].item_in_hand.advanced_matches[spider_eye]>:
        - run templatetools_preview_clear def.player:<[player]>
        - stop
    - define halfwidth <schematic[<[schematic]>].width.div[2]>
    - define halflength <schematic[<[schematic]>].length.div[2]>
    - repeat <schematic[<[schematic]>].width> from:0 as:x:
        - repeat <schematic[<[schematic]>].height> from:0 as:y:
            - repeat <schematic[<[schematic]>].length> from:0 as:z:
                - define location <location[<[x]>,<[y]>,<[z]>,<[player].world.name>]>
                - define block <schematic[<[schematic]>].block[<[location]>]>
                - if <[block].name> == air:
                    - repeat next
                - define fakedlocation <[cursor_on].add[<[location]>].sub[<[halfwidth]>,0,<[halflength]>].add[1,0,1]>
                - showfake <schematic[<[schematic]>].block[<[location]>]> <[fakedlocation]> players:<[player]> duration:1h
                - define fakedlocations <[fakedlocations].include[<[fakedlocation]>]>
    - flag <[player]> templatetools_preview_region:<[fakedlocations]>

templatetools_preview_clear:
    debug: false
    type: task
    definitions: player
    script:
    - if !<[player].has_flag[templatetools_preview_region]>:
        - stop
    - showfake cancel <[player].flag[templatetools_preview_region]>
    - flag <[player]> templatetools_preview_region:!

templatetools_preview:
    debug: false
    type: task
    definitions: player|schematic
    script:
    - ~run templatetools_preview_clear def.player:<[player]>
    - run templatetools_preview_show def.player:<[player]> def.schematic:<[schematic]>

templatetools_preview_paste:
    debug: false
    type: task
    definitions: player|schematic
    script:
    - define cursor_on <[player].cursor_on.if_null[null]>
    - if <[cursor_on]> == null:
        - stop
    - define cuboid <schematic[<[schematic]>].cuboid[<[cursor_on]>]>
    - define middle <[cuboid].center>
    - define smallest_y <[cuboid].corners.get[first].y>
    - if <[cuboid].corners.get[last].y> < <[smallest_y]>:
        - define smallest_y <[cuboid].corners.get[last].y>
    - define difference_y <[cursor_on].y.sub[<[smallest_y]>]>
    - define cursor_on <[cursor_on].sub[0,<[difference_y].sub[1]>,0]>
    - if !<[player].item_in_hand.advanced_matches[spider_eye]>:
        - run templatetools_preview_clear def.player:<[player]>
        - stop
    - define halfwidth <schematic[<[schematic]>].width.div[2]>
    - define halflength <schematic[<[schematic]>].length.div[2]>
    - define count 0
    - define undodata <map[]>
    - repeat <schematic[<[schematic]>].width> from:0 as:x:
        - repeat <schematic[<[schematic]>].height> from:0 as:y:
            - repeat <schematic[<[schematic]>].length> from:0 as:z:
                - define location <location[<[x]>,<[y]>,<[z]>,<[player].world.name>]>
                - define block <schematic[<[schematic]>].block[<[location]>]>
                - if <[block].name> == air:
                    - repeat next
                - define fakedlocation <[cursor_on].add[<[location]>].sub[<[halfwidth]>,0,<[halflength]>].add[1,0,1]>
                - define previousmaterial <[fakedlocation].material>
                - modifyblock <schematic[<[schematic]>].block[<[location]>]> <[fakedlocation]> no_physics
                - define undodata <[undodata].with[<[fakedlocation]>].as[<[previousmaterial]>]>
                - define count <[count].add[1]>
    - run templatetools_push_undo def.player:<[player]> def.data:<[undodata]>
    - determine <[count]>

templatetools_push_undo:
    debug: false
    type: task
    definitions: player|data
    script:
    - flag <[player]> templatetools_undo:<[player].flag[templatetools_undo].if_null[<list[]>].include[<[data]>]>

templatetools_pop_undo:
    debug: false
    type: task
    definitions: player
    script:
    - if <[player].flag[templatetools_undo].if_null[<list[]>].is_empty>:
        - stop
    - foreach <[player].flag[templatetools_undo].last> key:location as:material:
        - modifyblock <[material]> <[location]> no_physics
    - flag <[player]> templatetools_undo:<[player].flag[templatetools_undo].remove[last]>
