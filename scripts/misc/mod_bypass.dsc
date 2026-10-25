mod_bypass:
    debug: false
    type: command
    name: modbypass
    description: Bypass some things as mod.
    usage: /modbypass
    permission: modbypass.command.modbypass
    aliases:
    - mbyp
    tab completions:
        1: <list[]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define at <player.cursor_on_solid[10].if_null[null]>
    - if <[at]> == null:
        - narrate "<&c>Nothing to bypass here."
        - stop
    - if <[at].inventory.if_null[null]> != null:
        - inventory open destination:<[at]>
        - narrate format:formats_prefix "Bypassed container at <[at].simple>."
    - else if <[at].material.switched.if_null[null]> != null:
        - switch <[at]> no_physics
        - narrate format:formats_prefix "Bypassed switchable block at <[at].simple>."
    - else:
        - narrate "<&c>Nothing to bypass here."
