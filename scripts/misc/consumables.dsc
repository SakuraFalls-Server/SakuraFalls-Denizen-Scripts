consumables_world:
    debug: false
    type: world
    events:
        on player right clicks block:
        - if !<player.item_in_hand.has_flag[consumable]>:
            - stop
        - playsound sound:entity.player.burp <player.location>
        - take iteminhand quantity:1
