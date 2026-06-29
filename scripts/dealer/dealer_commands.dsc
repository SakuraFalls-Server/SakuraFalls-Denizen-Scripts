order:
    type: command
    permission: dealer.command.order
    name: order
    debug: true
    description: Place an order for stock
    usage: /order [start|add|finish]
    tab completions:
    - define args <context.args>
    - define sub <[args].get[1].if_null[]>
    - if <[args].size> == 1:
        - determine <list[start|add|finish].filter[starts_with[<[sub]>]]>
    - else if <[args].size> == 2 && <[sub]> == add:
        - define allowed <list[hammer|baseball bat|metal bat|hunting knife|mechete|spiked baseball bat|katana|sledgehammer|riot helmet]>
        - determine <[allowed].filter[starts_with[<[args].get[2].if_null[]>]]>
    - else if <[args].size> == 3 && <[sub]> == add:
        - determine <list[1|2|3|4|5|6|7|8|9|10]>
    script:
    - if <context.source_type> != player:
        - narrate "This command can only be used by players."
        - stop
    - define sub <context.args.get[1].if_null[]>

    # order start
    - if <[sub]> == start:
        - if <server.has_flag[order_cooldown]>:
            - narrate "<&7>[Supplier]<&f> I'm already on my way, be patient."
            - stop
        - if <player.has_flag[order_session]>:
            - narrate "<&7>[Supplier]<&f> You already have an order open. Use /order add or /order finish."
            - stop
        - flag player order_session:<list[]>
        - narrate "<&7>[Supplier]<&f> Alright, what do you need? Use /order add <item> <amount>."
        - stop

    # order add
    - if <[sub]> == add:
        - if !<player.has_flag[order_session]>:
            - narrate "<&7>[Supplier]<&f> Start an order first with /order start."
            - stop
        - define allowed <list[hammer|baseball bat|metal bat|hunting knife|mechete|spiked baseball bat|katana|sledgehammer|riot helmet]>
        - define item <context.args.get[2].if_null[]>
        - define qty <context.args.get[3].if_null[1]>
        - if <[item]> == <empty>:
            - narrate "<&7>[Supplier]<&f> Specify an item. Usage: /order add [item] [amount]"
            - stop
        - if !<[allowed].contains[<[item]>]>:
            - narrate "<&7>[Supplier]<&f> I don't carry '<[item]>'."
            - stop
        - if !<[qty].is_integer>:
            - narrate "<&7>[Supplier]<&f> That's not a valid amount."
            - stop
        - define current <player.flag[order_session]>
        - flag player order_session:<[current].include[<[item]>:<[qty]>]>
        - narrate "<&7>[Supplier]<&f> Added <[qty]>x <[item]> to your order."
        - stop

    # order finish
    - if <[sub]> == finish:
        - if !<player.has_flag[order_session]>:
            - narrate "<&7>[Supplier]<&f> You don't have an open order."
            - stop
        - if <player.flag[order_session].is_empty>:
            - narrate "<&7>[Supplier]<&f> Your order is empty, add some items first."
            - flag player order_session:!
            - stop
        - flag server order_cooldown expire:5m
        - define location_list <list[415,2,-140,world|370,2,-43,world|336,2,84,world|246,2,-521,world|239,2,-498,world]>
        - flag server dealer_loc:<[location_list].random>
        - flag server dealer_order:<player.flag[order_session]>
        - flag player order_session:!
        - narrate "<&7>[Supplier]<&f> Give me 5 minutes to drop off your items."
        - wait 5s
        - narrate "<&7>[Supplier]<&f> Dropped the items, tell your boss to pay me."
        - stop

    - narrate "<&7>[Supplier]<&f> Usage: /order <start|add|finish>"