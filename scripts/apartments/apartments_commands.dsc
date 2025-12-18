apartments_command_apartmentaddmember:
    debug: false
    type: command
    name: apartmentaddmember
    description: Add a member to the apartment you are currently in.
    usage: /apartmentaddmember (player)
    aliases:
    - aptaddmember
    - aptam
    permission: apartments.command.apartmentaddmember
    tab completions:
        1: <server.online_players.parse[name]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define apartment <proc[apartments_at].context[<player.location>]>
    - if <[apartment]> == null:
        - narrate "<&c>You can only use this command inside apartments."
        - stop
    - define owner <proc[apartments_owner].context[<[apartment]>]>
    - if <player> != <[owner]>:
        - narrate "<&c>You do not own this apartment!"
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Invalid use. Please try /<context.alias> (player)"
        - stop
    - define target <server.match_offline_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>A player with the username <context.args.get[1]> could not be found."
        - stop
    - if <[target]> == <player>:
        - narrate "<&c>You cannot add yourself as a member!"
        - stop
    - run apartments_add_member def.apartment:<[apartment]> def.member:<[target]>
    - narrate format:formats_prefix "<&a>Added <&7><[target].name> to your apartment (<&b>member<&7>)."

apartments_command_apartmentaddmoderator:
    debug: false
    type: command
    name: apartmentaddmoderator
    description: Adds a moderator to the apartment you are currently in.
    usage: /apartmentaddmoderator (player)
    aliases:
    - aptaddmod
    permission: apartments.command.apartmentaddmod
    tab completions:
        1: <server.online_players.parse[name]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define apartment <proc[apartments_at].context[<player.location>]>
    - if <[apartment]> == null:
        - narrate "<&c>You can only use this command inside apartments."
        - stop
    - define owner <proc[apartments_owner].context[<[apartment]>]>
    - if <player> != <[owner]>:
        - narrate "<&c>You do not own this apartment!"
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Invalid use. Please try /<context.alias> (player)"
        - stop
    - define target <server.match_offline_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>A player with the username <context.args.get[1]> could not be found."
        - stop
    - if <[target]> == <player>:
        - narrate "<&c>You cannot add yourself as a moderator!"
        - stop
    - run apartments_add_moderator def.apartment:<[apartment]> def.moderator:<[target]>
    - narrate format:formats_prefix "<&a>Added <&7><[target].name> to your apartment (<&6>moderator<&7>)."

apartments_command_apartmentremoveaccess:
    debug: false
    type: command
    name: apartmentremoveaccess
    description: Removes all access for a player from the apartment you are currently in.
    usage: /apartmentremoveaccess (player)
    aliases:
    - aptremoveaccess
    - aptrm
    permission: apartments.command.apartmentremoveaccess
    tab completions:
        1: <proc[apartments_all_with_access].context[<player>].parse[name]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define apartment <proc[apartments_at].context[<player.location>]>
    - if <[apartment]> == null:
        - narrate "<&c>You can only use this command inside apartments."
        - stop
    - define owner <proc[apartments_owner].context[<[apartment]>]>
    - if <player> != <[owner]>:
        - narrate "<&c>You do not own this apartment!"
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Invalid use. Please try /<context.alias> (player)"
        - stop
    - define target <server.match_offline_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>A player with the username <context.args.get[1]> could not be found."
        - stop
    - if <[target]> == <player>:
        - narrate "<&c>You cannot remove your own access!"
        - stop
    - if <[target].location.in_region[<[apartment].id>]>:
        - run apartments_end_edit def.player:<[target]>
    - run apartments_remove_access def.apartment:<[apartment]> def.member:<[target]>
    - narrate format:formats_prefix "<&c>Removed <&7>member <[target].name> from your apartment."

apartments_command_apartmenteditmode:
    debug: false
    type: command
    name: apartmenteditmode
    description: Toggle edit mode for the apartment you are currently in.
    usage: /apartmenteditmode
    aliases:
    - apteditmode
    - editmode
    permission: apartments.command.apartmenteditmode
    tab completions:
        1: <server.online_players.parse[name]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    # toggle off
    - if <player.has_flag[apartments_edit]>:
        - run apartments_end_edit def.player:<player>
        - narrate format:formats_prefix "<&e>Exiting <&6>Edit Mode..."
        - stop
    # toggle on
    - define apartment <proc[apartments_at].context[<player.location>]>
    - if <[apartment]> == null:
        - narrate "<&c>You can only use this command inside apartments."
        - stop
    - define owner <proc[apartments_owner].context[<[apartment]>]>
    - if <player> != <[owner]>:
        - define access_level <proc[apartments_access_level].context[<player>|<player.location>]>
        - if <[access_level]> != moderator:
            - narrate "<&c>You must own this apartment or be an apartment moderator to enable editing here!"
            - stop
    - run apartments_begin_edit def.apartment:<[apartment]> def.player:<player>
    - narrate format:formats_prefix "<&a>Entering <&6>Edit Mode..."
