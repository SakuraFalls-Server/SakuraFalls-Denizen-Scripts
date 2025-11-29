animations_command_animationmode:
    debug: false
    type: command
    name: animationmode
    description: Animate your hands in a certain direction.
    usage: /animationmode
    aliases:
    - am
    permission: animations.command.animationmode
    tab completions:
        1: <empty>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <player.item_in_hand.material.name> != air:
        - narrate "<&c>You must run this command with an empty hand."
        - stop
    - define arrow <item[arrow]>
    - adjust def:arrow custom_model_data:1
    - adjust def:arrow display:<&f>
    - flag <[arrow]> animations:true
    - if !<player.inventory.can_fit[<[arrow]>]>:
        - narrate "<&c>Your inventory is too full. You must have one empty slot in your inventory!"
        - stop
    - define bow <item[bow]>
    - adjust def:bow "display:<&f>Hold right-click to Animate"
    - adjust def:bow custom_model_data:1
    - flag <[bow]> animations:true
    - inventory set slot:hand origin:<[bow]>
    - give <[arrow]>
    - narrate format:formats_prefix "Hold right-click to animate your hands!"

animations_command_raisehand:
    debug: false
    type: command
    name: raisehand
    description: Animate your hand so it looks like you're raising it.
    usage: /raisehand
    aliases:
    - rh
    permission: animations.command.raisehand
    tab completions:
        1: <empty>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <player.item_in_hand.material.name> != air:
        - narrate "<&c>You must run this command with an empty hand."
        - stop
    - define trident <item[trident]>
    - adjust def:trident custom_model_data:1
    - adjust def:trident "display:<&f>Hold right-click to Raise Hand"
    - flag <[trident]> animations:true
    - inventory set slot:hand origin:<[trident]>
    - narrate format:formats_prefix "Hold right-click to raise your hand!"

animations_command_handshake:
    debug: false
    type: command
    name: handshake
    description: Animate your hand so it looks like you're handshaking.
    usage: /handshake
    permission: animations.command.handshake
    tab completions:
        1: <empty>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <player.item_in_hand.material.name> != air:
        - narrate "<&c>You must run this command with an empty hand."
        - stop
    - define shield <item[shield]>
    - adjust def:shield custom_model_data:1
    - adjust def:shield "display:<&f>Hold right-click to Handshake"
    - flag <[shield]> animations:true
    - inventory set slot:hand origin:<[shield]>
    - narrate format:formats_prefix "Hold right-click to handshake!"
