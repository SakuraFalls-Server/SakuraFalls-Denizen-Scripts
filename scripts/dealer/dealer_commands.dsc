order:
    type: command
    permission: dealer.command.order
    name: order
    debug: true
    description: Place an order for stock
    usage: /order
    script:
    - if <context.source_type> != player:
        - narrate "This command can only be used by players."
        - stop
    - if <player.has_flag[order_cooldown]>:
        - narrate "<&7>[Supplier]<&f> I'm already on my way, be patient."
        - stop
    - flag player order_cooldown expire:5m
    - define location_list <list[415,2,-140,world|370,2,-43,world|336,2,84,world|246,2,-521,world|239,2,-498,world]>
    - flag server dealer_loc:<[location_list].random>
    - narrate "<&7>[Supplier]<&f> Give me 5 minutes to drop off your items"
    - wait 6s
    - narrate "<&7>[Supplier]<&f> Dropped the items, Tell your boss to pay me"
    - narrate "debug: <server.flag[dealer_loc]>"