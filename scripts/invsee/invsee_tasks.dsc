invsee_open:
    debug: false
    type: task
    definitions: player|target
    script:
    - define inventory <[target].inventory.map_slots>
    - define contents <map[]>
    - foreach <[inventory]> key:slot as:item:
        - define contents <[contents].with[<[slot]>].as[<map[].with[item].as[<[item]>].with[script].as[invsee_take].with[definitions].as[<map[].with[player].as[<[player]>].with[item].as[<[item]>].with[slot].as[<[slot]>]>]>]>
    - flag <[player]> invsee_open:<[target]>
    - run menu_open def.player:<[player]> def.title:<&a>邑邑邑<&f>邑鄅<&d><&sp><&d><&sp><&f><&sp> def.size:45 def.contents:<[contents]>

invsee_take:
    debug: false
    type: task
    definitions: player|item|slot
    script:
    - flag <[item]> _menu_script:!
    - flag <[item]> _menu_definitions:!
    - define itemregistry <[item].has_flag[itemregistry].if_null[false]>
    - define target <[player].flag[invsee_open]>
    - if <[itemregistry]>:
        - flag <[player]> itemregistry_mid_transaction:true expire:1s
    - take slot:<[slot]> from:<[target].inventory> quantity:1
    - if <[itemregistry]>:
        - ~run itemregistry_update_tracker def.item:<[item]> def.new_inventory:<[player].inventory>
    - give item:<[item]> to:<[player].inventory> quantity:1
    - if <[itemregistry]>:
        - flag <[player]> itemregistry_mid_transaction:!
    - inventory close
    - run invsee_open def.player:<[player]> def.target:<[target]> path:script