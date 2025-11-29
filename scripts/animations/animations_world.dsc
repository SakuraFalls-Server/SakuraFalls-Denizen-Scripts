animations_world:
    debug: false
    type: world
    events:
        # common
        on player joins:
        - foreach <player.inventory.map_slots> key:slot as:item:
            - if <[item].has_flag[animations]>:
                - inventory set slot:<[slot]> origin:air
        on player scrolls their hotbar:
        - if <player.item_in_hand.has_flag[animations]>:
            - take flagged:animations quantity:255
        on player clicks item in inventory:
        - if <context.item.has_flag[animations]>:
            - determine cancelled passively
            - inventory set slot:hand origin:air
            - inventory update
        on player drops item:
        - if <context.item.has_flag[animations]>:
            - remove <context.entity>
        # animationmode
        on player shoots bow:
        - if <context.bow.has_flag[animations]>:
            - determine cancelled passively
            - take flagged:animations quantity:255
        # raisehand
        on trident launched:
        - if <context.entity.item.has_flag[animations]>:
            - determine cancelled passively
            - take flagged:animations quantity:255 player:<context.entity.shooter>
        # shield
        on player lowers item:
        - if <context.item.has_flag[animations]>:
            - take flagged:animations quantity:255
