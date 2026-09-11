staffmessage_command:
    debug: false
    type: command
    name: staffmessage
    description: Send a private message to a player.
    usage: /staffmessage <&lt>player<&gt> <&lt>message<&gt>
    permission: staffmessage.command
    script:
        - if <context.source_type> != player:
            - narrate "<&c>This command can only be used by a player."
            - stop
        - if <context.args.size> < 2:
            - narrate "<&c>Usage: /staffmessage <&lt>player<&gt> <&lt>message<&gt>"
            - stop
        - define target <server.match_player[<context.args.get[1]>]>
        - if !<[target].exists>:
            - narrate "<&c>Player not found."
            - stop
        - define message <context.raw_args.after[<context.args.get[1]>].trim>
        - run staffmessage_send def.staff:<player> def.target:<[target]> def.message:<[message]>

stafflooc_command:
    debug: false
    type: command
    name: stafflooc
    description: Send local staff LOOC.
    usage: /stafflooc <&lt>message<&gt>
    permission: staffmessage.command
    script:
        - if <context.source_type> != player:
            - narrate "<&c>This command can only be used by a player."
            - stop
        - if <context.args.size> <= 0:
            - narrate "<&c>Usage: /stafflooc <&lt>message<&gt>"
            - stop
        - run staffmessage_looc def.staff:<player> def.message:<context.raw_args>

staffooc_command:
    debug: false
    type: command
    name: staffooc
    description: Send global staff OOC.
    usage: /staffooc <&lt>message<&gt>
    permission: staffmessage.command
    script:
        - if <context.source_type> != player:
            - narrate "<&c>This command can only be used by a player."
            - stop
        - if <context.args.size> <= 0:
            - narrate "<&c>Usage: /staffooc <&lt>message<&gt>"
            - stop
        - run staffmessage_ooc def.staff:<player> def.message:<context.raw_args>

staffreply_command:
    debug: false
    type: command
    name: staffreply
    description: Reply to the last staff member who contacted you.
    usage: /staffreply <&lt>message<&gt>
    permission: staffmessage.reply
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
        - run staffmessage_reply def.player:<player> def.staff:<[staff]> def.message:<context.raw_args>