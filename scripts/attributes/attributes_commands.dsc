attributes_command_attributes:
    debug: false
    type: command
    name: attributes
    usage: /attributes
    description: Displays player's attributes.
    permission: attributes.command.attributes
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
    - narrate format:formats_prefix "<player.name>'s Attributes:<&nl><&e>Acrobatics: <&7><[acro]>%<&nl><&e>Cardio: <&7><[cardio]>%<&nl><&e>Swim: <&7><[swim]>%"

# More need to be added once the rest of the mechanics are implemented