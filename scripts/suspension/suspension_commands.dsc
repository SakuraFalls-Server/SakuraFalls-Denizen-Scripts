suspension_command_suspension:
    debug: false
    type: command
    name: suspension
    description: Check how long you have until suspension expires.
    usage: /suspension
    permission: suspension.command.suspension
    tab completions:
        1: <empty>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <player.in_group[suspended]>:
        - narrate format:formats_prefix "You are suspended for <&e><placeholder[luckperms_group_expiry_time_suspended].player[<player>]><&7>."
    - else:
        - narrate format:formats_prefix "You are not suspended."
