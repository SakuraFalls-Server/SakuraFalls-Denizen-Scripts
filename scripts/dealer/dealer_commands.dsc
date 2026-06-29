order:
    type: command
    name: order
    description: Place an order for stock
    usage: /order
    cooldown: 5s
    script:
    - define player <player>
    - if <context.source.type> != player:
        - narrate "This command can only be used by players."
        - stop
    # Please edit this list if you want to add or remove locations for the dealer to spawn at.
    - define locationMap <list["415, 2, -140, world", "370, 2, -43, world", "336, 2, 84, world","246, 2, -521, world", "239, 2 ,-498, world"]>
    - define location <[locationMap].random>
