#
# Anvil Input
# A library that lets you use anvil inputs instead of chat inputs.
#

#
# Requests input from the player with the given prompt, and then applies 
# the result to the callback.
#
# The callback is a task with two definitions: a player, and the input.
# The callback is called an filled automatically by this task once the anvil
# input is complete.
#
anvil_input:
    debug: false
    type: task
    definitions: player|prompt|callback
    script:
    - if !<[player].is_online>:
        - stop
    - define inventory <inventory[anvil[title=<&f>邑邑邑邑]]>
    - define rename <item[warped_trapdoor[display=<&f><[prompt]>]]>
    - flag <[rename]> anvil_input:true
    - inventory set slot:1 origin:<[rename]> destination:<[inventory]>
    - flag <[player]> anvil_input:<[callback]>
    - inventory open destination:<[inventory]> player:<[player]>

# Handles anvil input events
anvil_input_world:
    debug: false
    type: world
    events:
        on player prepares anvil craft item:
        - if !<player.has_flag[anvil_input]>:
            - stop
        - determine 0 passively
        - wait 1t
        - take flagged:anvil_input quantity:9999
        on player clicks in anvil:
        - if !<player.has_flag[anvil_input]>:
            - stop
        - determine cancelled passively
        - if <context.slot> != 3:
            - stop
        - define result <context.item.display.if_null[<context.inventory.slot[1].display.if_null[<empty>]>].strip_color>
        - define callback <player.flag[anvil_input]>
        - flag <player> anvil_input:!
        - playsound sound:input.ok <player> custom
        - run <[callback]> def.player:<player> def.input:<[result]>
        - inventory close
        - wait 1t
        - take flagged:anvil_input quantity:9999
        - adjust <player> item_on_cursor:<item[air]>
        on player closes anvil:
        - if !<player.has_flag[anvil_input]>:
            - stop
        - flag <player> anvil_input:!
        - wait 1t
        - take flagged:anvil_input quantity:9999
        - narrate "<&c>Cancelled input..."
        on player join:
        - take flagged:anvil_input quantity:9999
