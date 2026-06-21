areashop_right_click_sign_patch:
    debug: false
    type: task
    definitions: player_name|region
    script:
    - define player <server.match_player[<[player_name]>].if_null[null]>
    - if <[player]> == null:
        - stop
    - define yaml_id areashop_temp_<util.random.int[100000].to[999999]>
    - ~yaml load:../AreaShop/regions/<[region]>.yml id:<[yaml_id]>
    - define buyer <yaml[<[yaml_id]>].read[buy.buyer].if_null[null]>
    - define renter <yaml[<[yaml_id]>].read[rent.renter].if_null[null]>
    - define is_rent <yaml[<[yaml_id]>].read[buy.price].is_more_than[-1].if_null[true]>
    - yaml unload id:<[yaml_id]>
    - narrate targets:<[player]> <&f>
    - narrate targets:<[player]> format:formats_prefix "Region <[region]>"
    - if <[buyer]> == null && <[renter]> == null:
        - narrate targets:<[player]> "<&7>Currently <&a>available<&7>."
        - clickable save:purchase:
            - if <[is_rent]>:
                - execute as_player "as rent --region <[region]>"
            - else:
                - execute as_player "as buy --region <[region]>"
            - execute as_server "as reload"
        - narrate targets:<[player]> <element[<&a><&l>[ <tern[<[is_rent]>].pass[RENT].fail[BUY]> ]].on_click[<entry[purchase].command>]>
    - else if <[buyer]> != null:
        - define buyer_player <player[<[buyer]>]>
        - narrate targets:<[player]> "<&7>Currently <&c>unavailable<&7>."
        - narrate targets:<[player]> "<&7>This region is <&6>purchased<&7> by <&e><[buyer_player].name>"
        - if <[player].equals[<[buyer_player]>]>:
            - clickable save:sell:
                - execute as_player "as sell --region <[region]>"
                - execute as_server "as reload"
            - narrate targets:<[player]> <element[<&c><&l>[ CANCEL PURCHASE ]].on_click[<entry[sell].command>]>
    - else:
        - define renter_player <player[<[renter]>]>
        - narrate targets:<[player]> "<&7>Currently <&c>unavailable<&7>."
        - narrate targets:<[player]> "<&7>This region is <&e>rented<&7> by <&e><[renter_player].name>"
        - if <[player].equals[<[renter_player]>]>:
            - clickable save:unrent:
                - execute as_player "as unrent --region <[region]>"
                - execute as_server "as reload"
            - narrate targets:<[player]> <element[<&c><&l>[ CANCEL YOUR RENT ]].on_click[<entry[unrent].command>]>
    - narrate targets:<[player]> <&f>
