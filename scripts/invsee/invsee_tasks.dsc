invsee_open:
    debug: true
    type: task
    definitions: player|target
    script:
    - define inventory <[target].inventory.list_contents>
    - define contents <map[]>
    - foreach <[inventory]> as:item:
        - define slot <[loop_index]>
        - define contents <[contents].with[<[slot]>].as[<map[].with[item].as[<[item]>].with[script].as[invsee_take].with[definitions].as[<map[].with[player].as[<[player]>].with[item].as[<[item]>].with[slot].as[<[slot]>]>]>]>
    - define menu_title "<[target].name>'s Inventory"
    - flag <[player]> inv_open:<[target].name>
    - run menu_open def.player:<[player]> def.title:<&a>邑邑邑<&f>邑<[menu_title]><&a><&sp><&b><&sp><&f><&sp> def.size:36 def.contents:<[contents]>



invsee_take:
    debug: false
    type: task
    definitions: player|item
    script:
    - define target <[player].flag[inv_open]>
    - define uuid <server.match_player[<[target]>]>
    - take item:<[item]> from:<[uuid].inventory>
    - give item:<[item]> to:<[player].inventory>
    - flag <[player]> itemregistry_mid_transaction:!