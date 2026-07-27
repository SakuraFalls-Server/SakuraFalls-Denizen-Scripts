dealer_command_order:
    type: command
    permission: dealer.command.order
    name: order
    debug: false
    description: Place an order for stock
    usage: /order (start|add|finish|cancel)
    script:
    - if <context.source_type> != player:
        - narrate "This command can only be used by players."
        - stop
    - define sub <context.args.get[1].if_null[]>
    # order start
    - if <[sub]> == start:
        - if <server.has_flag[dealer_order_cooldown]>:
            - narrate "<&7>[Supplier]<&f> I'm already on my way delivering, be patient."
            - stop
        - if <player.has_flag[dealer_order_session]>:
            - narrate "<&7>[Supplier]<&f> You already have an order open. Use /order add or /order finish."
            - stop
        - flag <player> dealer_order_session:<list[]>
        - narrate "<&7>[Supplier]<&f> Alright, what do you need? <&7>Use /order add (item) (amount)."
        - stop
    # order add
    - if <[sub]> == add:
        - if !<player.has_flag[dealer_order_session]>:
            - narrate "<&7>[Supplier]<&f> Start an order first with /order start."
            - stop
        - define allowed <script[dealer_data].data_key[items]>
        - define item <context.args.get[2].if_null[]>
        - define qty <context.args.get[3].if_null[1]>
        - define price <script[dealer_data].data_key[items].get[<[item]>].get[price]>
        - define weap_cost <[price].mul[<[qty]>]>
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
            - narrate "<&7>[Supplier]<&f> You can't sell to me!"
            - stop
        - define new_total_quantity <player.flag[dealer_order_total_quantity].if_null[0].add[<[qty]>]>
        - if <[new_total_quantity]> > 5:
            - narrate "<&7>[Supplier]<&f> Sorry, only 5 items max."
            - stop
        - flag <player> dealer_order_total:+:<[weap_cost]>
        - flag <player> dealer_order_session:<player.flag[dealer_order_session].if_null[<list[]>].include[<[item]>:<[qty]>]>
        - flag <player> dealer_order_total_quantity:<[new_total_quantity]>
        - adjust server save
        - narrate "<&7>[Supplier]<&f> Added <[qty]>x <[item]> to your order. Total cost so far is <player.flag[dealer_order_total].if_null[0]>."
        - stop
    # order finish
    - if <[sub]> == finish:
        - if !<player.has_flag[dealer_order_session]>:
            - narrate "<&7>[Supplier]<&f> You don't have an open order."
            - stop
        - if <player.flag[dealer_order_session].is_empty>:
            - narrate "<&7>[Supplier]<&f> Your order is empty, add some items first."
            - stop
        - if <player.money> < <player.flag[dealer_order_total]>:
            - narrate "<&7>[Supplier]<&f> You can't afford the drop"
            - stop
        #
        - flag server dealer_order_cooldown:true expire:5m
        - flag server dealer_loc:<script[dealer_data].data_key[locations].random>
        - flag server dealer_order:<player.flag[dealer_order_session]>
        - flag server dealer_order_total_quantity:<player.flag[dealer_order_total_quantity]>
        - flag server dealer_supplier_account:<server.flag[dealer_supplier_account].if_null[0].add[<player.flag[dealer_order_total].if_null[0]>]>
        #
        - money take players:<player> quantity:<player.flag[dealer_order_total].if_null[0]>
        - flag <player> dealer_order_session:!
        - flag <player> dealer_order_total:!
        - flag <player> dealer_order_total_quantity:!
        #
        - adjust server save
        #
        - narrate "<&7>[Supplier]<&f> Give me 5 minutes to drop off your items."
        - wait 5m
        - narrate "<&7>[Supplier]<&f> Dropped the items."
        - stop
    # cancel
    - if <[sub]> == cancel:
        - if !<player.has_flag[dealer_order_session]>:
            - narrate "<&7>[Supplier]<&f> You don't have an open order."
            - stop
        - if <player.flag[dealer_order_session].is_empty>:
            - narrate "<&7>[Supplier]<&f> Your order is empty, add some items first."
            - stop
        - flag <player> dealer_order_session:!
        - flag <player> dealer_order_total:!
        - flag <player> dealer_order_total_quantity:!
        - adjust server save
        - narrate "<&7>[Supplier]<&f> Order was cancelled."
        - stop
    #
    - narrate "<&7>[Supplier]<&f> Usage: /order (start|add|finish|cancel)"

dealer_command_withdraw:
    type: command
    permission: dealer.command.withdraw
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
    - if <[amount]> <= 0:
        - narrate "<&2>[Bank]<&f> You cannot withdraw a negative amount"
        - stop
    - define current_balance <server.flag[dealer_supplier_account].if_null[0]>
    - if <[amount].is_more_than[<[current_balance]>]>:
        - narrate "<&2>[Bank]<&f> Not enough funds in the supplier account. <&7>(max is <[current_balance].as_money>)"
        - stop
    - money give players:<player> quantity:<[amount]>
    - flag server dealer_supplier_account:-:<[amount]>
    - adjust server save
    - narrate "<&2>[Bank]<&f> Withdrew <[amount]> from the supplier account. Current balance is <server.flag[dealer_supplier_account].if_null[0].as_money>."
