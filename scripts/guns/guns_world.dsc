guns_world_common:
    debug: false
    type: world
    events:
        after player join:
        - if !<player.has_flag[guns_frozen]>:
            - stop
        - animate <player> animation:sit
        - run guns_unfreeze path:script def:<player>
        - narrate format:formats_prefix "You logged off before you were unstunned. You will remain stunned for 60 seconds."
        on player teleports:
        - if <player.has_flag[guns_frozen]>:
            - determine cancelled passively

guns_world_gun:
    debug: false
    type: world
    events:
        on player right clicks block:
        - if !<player.item_in_hand.has_flag[guns_gun]>:
            - stop
        - ratelimit <player> 1s
        - playsound <player.location> custom sound:item.anaconda
        - define target <player.precise_target[25].if_null[null]>
        - if <[target]> == null:
            - define location <player.cursor_on[25].if_null[null]>
            - if <[location]> == null:
                - define location <player.location.forward[25]>
            - playeffect effect:redstone at:<player.location.above[1].points_between[<[location]>].distance[0.1]> special_data:0.5|white visibility:16 quantity:6 offset:0,0,0
            - stop
        - playeffect effect:redstone at:<player.location.above[1].points_between[<[target].location.above[1]>].distance[0.1]> special_data:0.5|white visibility:16 quantity:6 offset:0,0,0
        - if !<[target].is_player>:
            - stop
        - if <[target].has_flag[guns_frozen]>:
            - stop
        - animate <[target]> animation:sit
        - flag <[target]> guns_frozen:true
        - run guns_unfreeze path:script def:<[target]>
        - narrate format:formats_prefix "You shot <proc[character_get_name].context[<[target]>]>"
        - narrate format:formats_prefix "You have been shot by <proc[character_get_name].context[<player>]>" targets:<[target]>

guns_world_taser:
    debug: false
    type: world
    events:
        on player right clicks block:
        - if !<player.item_in_hand.has_flag[guns_taser]>:
            - stop
        - ratelimit <player> 1s
        - define target <player.precise_target[7]||null>
        - if <[target]> == null:
            - stop
        - if !<[target].is_player>:
            - stop
        - if <[target].has_flag[guns_frozen]>:
            - stop
        - playeffect effect:redstone at:<player.location.above[1].points_between[<[target].location.above[1]>].distance[0.1]> special_data:0.5|white visibility:16 quantity:6 offset:0,0,0
        - playsound <player.location> custom sound:item.taser
        - animate <[target]> animation:sit
        - flag <[target]> guns_frozen:true
        - run guns_unfreeze path:script def:<[target]>
        - narrate format:formats_prefix "You tased <proc[character_get_name].context[<[target]>]>"
        - narrate format:formats_prefix "You have been tased by <proc[character_get_name].context[<player>]>" targets:<[target]>
