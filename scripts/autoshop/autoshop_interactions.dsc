autoshop_interaction_vending:
    debug: false
    type: world
    events:
        on player right clicks block:
        - define at <context.location.if_null[null]>
        - if <[at]> == null:
            - stop
        - define below <context.location.below.if_null[<location[999999,0,999999]>]>
        - if <item[<proc[custom_block_at].context[<[at]>]>].custom_model_data.if_null[0]> == 8 || <item[<proc[custom_block_at].context[<[below]>]>].custom_model_data.if_null[0]> == 8:
            - if <player.gamemode> == creative:
                - actionbar "<&e>You cannot use the Vending Machine in Creative Mode."
                - stop
            - run autoshop_open def.player:<player> def.shop:vending
            - stop
autoshop_interaction_grocery_assign:
    debug: false
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - autoshop_interaction_grocery

autoshop_interaction_grocery:
    debug: false
    type: interact
    steps:
        1:
            click trigger:
                script:
                - run storyboard_player_begin_atomic_sequence def.queue:<queue> def.player:<player>
                - if <player.flag[textbox_state].if_null[null]> != null:
                    - stop
                - engage player
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:Hey, welcome!$$nlHow can we help you today"
                - wait 1s
                - disengage player
                - run storyboard_player_end_atomic_sequence def.queue:<queue> def.player:<player>
                - run autoshop_open def.player:<player> def.shop:grocery
                - stop
autoshop_interaction_drinks_assign:
    debug: false
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - autoshop_interaction_drinks

autoshop_interaction_drinks:
    debug: false
    type: interact
    steps:
        1:
            click trigger:
                script:
                - run storyboard_player_begin_atomic_sequence def.queue:<queue> def.player:<player>
                - if <player.flag[textbox_state].if_null[null]> != null:
                    - stop
                - engage player
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:Hey, welcome!$$nlHow can we help you today"
                - wait 1s
                - disengage player
                - run storyboard_player_end_atomic_sequence def.queue:<queue> def.player:<player>
                - run autoshop_open def.player:<player> def.shop:drinks
                - stop

