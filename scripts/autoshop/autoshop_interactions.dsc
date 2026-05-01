autoshop_interaction_vending:
    debug: false
    type: world
    events:
        on player right clicks block:
        - define at <context.location>
        - define below <context.location.below.if_null[<location[999999,0,999999]>]>
        - if <item[<proc[custom_block_at].context[<[at]>]>].custom_model_data.if_null[0]> == 8 || <item[<proc[custom_block_at].context[<[below]>]>].custom_model_data.if_null[0]> == 8:
            - if <player.gamemode> == creative:
                - actionbar "<&e>You cannot use the Vending Machine in Creative Mode."
                - stop
            - run autoshop_open def.player:<player> def.shop:vending
            - stop