attributes_display:
    debug: false
    type: command
    name: attributes
    usage: /attributes
    description: Displays player's stats.
    permission: chat.command.chat.looc
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    # I only found out during making the narrate, it somehow lets you use <player>
    - define acro <proc[attribute_percent_acro_getter].context[<context.source_type>]>
    - define cardio <proc[attribute_percent_cardio_getter].context[<context.source_type>]>
    - define swim <proc[attribute_percent_swim_getter].context[<context.source_type>]>
    - narrate format:formats_prefix "<&nl><player.name>'s attributes:<&nl>Acrobatics:<[acro]><&nl>Cardio:<[cardio]><&nl>Swim:<[swim]>"

# More need to be added once the rest of the mechanics are implemented