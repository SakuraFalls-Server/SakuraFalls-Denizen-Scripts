order:
    type: command
    permission: dealer.command.order
    name: order
    debug: false
    description: Place an order for stock
    usage: /order [start|add|finish]
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
        - narrate "<&7>[Supplier]<&f> Alright, what do you need? <&7>Use /order add <item> <amount>."
        - stop

    # order add
    - if <[sub]> == add:
        - if !<player.has_flag[order_session]>:
            - narrate "<&7>[Supplier]<&f> Start an order first with /order start."
            - stop
        - define allowed <script[dealer_data].data_key[items]>
        - define item <context.args.get[2].if_null[]>
        - define qty <context.args.get[3].if_null[1]>
        - define price <script[dealer_data].data_key[items].get[<[item]>]>
        - define weap_cost <[price].mul[<[qty]>]>
        - flag player order_total:+:<[weap_cost]>
        - if <[item]> == <empty>:
            - narrate "<&7>[Supplier]<&f> Specify an item. Usage: /order add [item] [amount]"
            - stop
        - if !<[allowed].contains[<[item]>]>:
            - narrate "<&7>[Supplier]<&f> I don't carry '<[item]>'."
            - stop
        - if !<[qty].is_integer>:
            - narrate "<&7>[Supplier]<&f> That's not a valid amount."
            - stop
        - if <[qty]> <= 0:
            - narrate "<&7>[Supplier]<&f> You can't sell to me"
            - stop
        - define current <player.flag[order_session]>
        - flag player order_session:<[current].include[<[item]>:<[qty]>]>
        - narrate "<&7>[Supplier]<&f> Added <[qty]>x <[item]> to your order. Total cost so far is <player.flag[order_total].if_null[0]>."
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
        - define location_list <script[dealer_data].data_key[locations]>
        - flag server dealer_loc:<[location_list].random>
        - flag server dealer_order:<player.flag[order_session]>
        - money take players:<context.source> quantity:<player.flag[order_total].if_null[0]>
        - flag server supplier_account:+:<player.flag[order_total].if_null[0]>
        - flag player order_total:!
        - flag player order_session:!
        - narrate "<&7>[Supplier]<&f> Give me 5 minutes to drop off your items."
        - wait 5m
        - narrate "<&7>[Supplier]<&f> Dropped the items."
        - stop

    - narrate "<&7>[Supplier]<&f> Usage: /order <start|add|finish>"

supplier_account_withdraw:
    type: command
    permission: dealer.admin.withdraw
    name: withdraw
    debug: false
    description: Withdraw money from the supplier account
    usage: /withdraw [amount]
    script:
    - if <context.source_type> != player:
        - narrate "This command can only be used by players."
        - stop
    - define amount <context.args.get[1].if_null[0]>
    - if !<[amount].is_integer>:
        - narrate "<&2>[Bank]<&f> That's not a valid amount."
        - stop
    - define current_balance <server.flag[supplier_account].if_null[0]>
    - if <[amount].is_more_than[<[current_balance]>]>:
        - narrate "<&2>[Bank]<&f> You don't have enough funds in the supplier account."
        - stop
    - money give players:<context.source> quantity:<[amount]>
    - flag server supplier_account:-:<[amount]>
    - narrate "<&2>[Bank]<&f> Withdrawn <[amount]> from the supplier account. Current balance is <server.flag[supplier_account].if_null[0]>."