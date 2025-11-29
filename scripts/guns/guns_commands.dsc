guns_command_unstun:
    debug: false
    type: command
    name: unstun
    description: Unstun a shot or tased player.
    usage: /unstun
    aliases:
    - untase
    permission: guns.command.unstun
    tab completions:
        default: PressEnter
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define target <player.target[player].within[5].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Please look towards the player you want to unstun."
        - stop
    - if <[target].is_npc>:
        - narrate "<&c>Please look towards the player you want to unstun."
        - stop
    - if !<[target].has_flag[guns_frozen]>:
        - narrate "<&c>This player is not stunned!"
        - stop
    - animate <[target]> animation:stop_sitting
    - flag <[target]> guns_frozen:!
    - narrate format:formats_prefix "You have unstunned <proc[character_get_name].context[<[target]>]>."
    - narrate format:formats_prefix "You have been unstunned." targets:<[target]>
