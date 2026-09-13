staffmessage_command_staffmessage:
    debug: false
    type: command
    name: staffmessage
    description: Send a private message to a player.
    usage: /staffmessage <&lt>player<&gt> <&lt>message<&gt>
    permission: staffmessage.command.staffmessage
    tab completions:
        1: <server.online_players.parse[name]>
        2: <&gt>message<&lt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>This command can only be used by a player."
        - stop
    - if <context.args.size> < 2:
        - narrate "<&c>Usage: /staffmessage <&lt>player<&gt> <&lt>message<&gt>"
        - stop
    - define target <server.match_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found."
        - stop
    - define message <context.raw_args.after[<context.args.get[1]>].trim>
    - run staffmessage_send_staff_to_player def.staff:<player> def.target:<[target]> def.message:<[message]>

staffmessage_command_stafflooc:
    debug: false
    type: command
    name: stafflooc
    description: Send local staff LOOC.
    usage: /stafflooc <&lt>message<&gt>
    permission: staffmessage.command.stafflooc
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>This command can only be used by a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Usage: /stafflooc <&lt>message<&gt>"
        - stop
    - run staffmessage_looc def.staff:<player> def.message:<context.raw_args>

staffmessage_command_staffooc:
    debug: false
    type: command
    name: staffooc
    description: Send global staff OOC.
    usage: /staffooc <&lt>message<&gt>
    permission: staffmessage.command.staffooc
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>This command can only be used by a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Usage: /staffooc <&lt>message<&gt>"
        - stop
    - run staffmessage_ooc def.staff:<player> def.message:<context.raw_args>

staffmessage_command_staffreply:
    debug: false
    type: command
    name: staffreply
    description: Reply to the last staff member who contacted you.
    usage: /staffreply <&lt>message<&gt>
    permission: staffmessage.command.reply
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>This command can only be used by a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Usage: /staffreply <&lt>message<&gt>"
        - stop
    - if !<player.has_flag[staffmessage_last_staff]>:
        - narrate "<&c>No staff member has contacted you."
        - stop
    - define staff <player.flag[staffmessage_last_staff]>
    - if !<[staff].exists>:
        - flag player staffmessage_last_staff:!
        - narrate "<&c>The staff member is no longer online."
        - stop
    - run staffmessage_reply_player_to_staff def.player:<player> def.staff:<[staff]> def.message:<context.raw_args>
