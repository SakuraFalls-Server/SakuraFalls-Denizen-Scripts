autoshop_title_by_size:
    debug: false
    type: procedure
    definitions: size
    script:
    # U+9101 -> U+9106
    - if <[size]> == 9:
        - determine 鄁
    - else if <[size]> == 18:
        - determine 鄂
    - else if <[size]> == 27:
        - determine 鄃
    - else if <[size]> == 36:
        - determine 鄄
    - else if <[size]> == 45:
        - determine 鄅
    - else:
        - determine 鄆

autoshop_open:
    debug: false
    type: task
    definitions: player|shop
    script:
    - define config <script[autoshop_config].data_key[shops].get[<[shop]>]>
    - define items <[config].get[items]>
    - define size <[config].get[size]>
    - define contents <map[]>
    - foreach <[items]> key:slot as:itemdata:
        - define actual_item <[itemdata].get[item].parsed>
        - define price <[itemdata].get[price]>
        - define item_button <[actual_item]>
        - adjust def:item_button lore:<[item_button].lore.if_null[<list[]>].include[<&f>|<&f>Buy for <&e>¥<[price]>]>
        - define contents <[contents].with[<[slot]>].as[<map[].with[item].as[<[item_button]>].with[script].as[autoshop_buy].with[definitions].as[<map[].with[player].as[<[player]>].with[price].as[<[price]>].with[item].as[<[actual_item]>]>]>]>
    - define title <proc[autoshop_title_by_size].context[<[size]>]>
    - run menu_open def.player:<[player]> def.title:<&a>邑邑邑<&f>邑<[title]><&a><&sp><&b><&sp><&f><&sp> def.size:<[size]> def.contents:<[contents]>

autoshop_buy:
    debug: false
    type: task
    definitions: player|price|item
    script:
    - ratelimit <[player]> 10t
    - if <[player].money> < <[price]>:
        - narrate targets:<[player]> "<&c>You need at least ¥<[price]> for this item, but only have ¥<[player].money.as_money>!"
        - stop
    - if !<[player].inventory.can_fit[<[item]>]>:
        - narrate targets:<[player]> "<&c>You don't have space in your inventory for this item!"
        - stop
    - give <[item]> quantity:1 player:<[player]>
    - money take players:<[player]> quantity:<[price]>
    - narrate format:formats_prefix "Purchased <[item].display.strip_color> for ¥<[price]>."
