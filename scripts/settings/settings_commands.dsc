settings_command_settings:
    debug: false
    type: command
    name: settings
    usage: /settings
    description: Opens the settings menu.
    permission: settings.command.settings
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - run settings_menu def.player:<player>