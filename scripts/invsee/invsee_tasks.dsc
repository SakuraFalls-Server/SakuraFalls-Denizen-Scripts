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
    definitions: player|item
    script:
    - define itemregistry <[item].has_flag[itemregistry].if_null[false]>
    - if <[itemregistry]>:
        - flag <[player]> itemregistry_mid_transaction:true expire:1s
    - define target <[player].flag[invsee_open]>
    - take item:<[item]> from:<[target].inventory>
    - give item:<[item]> to:<[player].inventory>
    - if <[itemregistry]>:
        - flag <[player]> itemregistry_mid_transaction:!
    - inventory close
    - run invsee_open def.player:<[player]> def.target:<[target]>
    