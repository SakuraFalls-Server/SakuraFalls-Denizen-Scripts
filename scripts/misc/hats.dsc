hats_world:
    debug: false
    type: world
    events:
        on player right clicks block:
        - if !<player.item_in_hand.has_flag[hat]>:
            - stop
        - if <player.equipment_map.get[helmet].if_null[null]> != null:
            - if !<player.inventory.can_fit[<player.equipment_map.get[helmet]>].if_null[true]>:
                - stop
        - define helmet <player.equipment_map.get[helmet].if_null[<item[air]>]>
        - define new_hat <player.item_in_hand>
        - adjust def:new_hat quantity:1
        - inventory set slot:helmet origin:<[new_hat]>
        - take iteminhand quantity:1
        - if !<[helmet].material.advanced_matches[air]>:
            - give <[helmet]> quantity:1
