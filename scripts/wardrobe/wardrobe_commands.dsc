wardrobe_command_wardrobe:
    debug: false
    type: command
    name: wardrobe
    usage: /wardrobe
    description: View and manage your skins in the wardrobe.
    permission: wardrobe.command.wardrobe
    tab completions:
        1: <list[]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - run wardrobe_menu def.player:<player>
