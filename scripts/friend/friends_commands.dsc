friends_command:
    debug: false
    type: command
    name: friend
    description: Manage your friends.
    usage: /friend [help|add|accept|deny|remove|list|msg|reply]
    permission: friend.command.friend
    aliases:
    - f
    tab completions:
        1: help|add|accept|deny|remove|list|msg|reply|r
        2: <server.online_players.parse[name]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop

    - if <context.args.size> <= 1:
        - run friends_command_help def.player:<player>
        - stop

    - choose <context.args.get[1].to_lowercase>:

        - case help:
            - run friends_command_help def.player:<player>

        - case add:
            - if <context.args.size> <= 2:
                - narrate "<&c>Usage: /friend add <player>"
                - stop

            - define target <server.match_player[<context.args.get[2]>].if_null[null]>

            - if <[target]> == null:
                - narrate "<&c>Player not found."
                - stop

            - if <[target]> == <player>:
                - narrate "<&c>You cannot add yourself."
                - stop

            - if <proc[friends_has].context[<player>|<[target]>]>:
                - narrate "<&c>You are already friends with <[target].name>."
                - stop

            - if <[target].has_flag[friend_request]>:
                - define master_player_uuid <proc[liteprofilesutils_get_master_uuid].context[<player>]>

                - if <[target].flag[friend_request]> == <[master_player_uuid]>:
                    - narrate "<&c>You already have a pending friend request with <[target].name>."
                    - stop

                - narrate "<&c><[target].name> already has a pending friend request."
                - stop

            - run friends_send_request def.player:<player> def.target:<[target]>

        - case accept:
            - if <context.args.size> <= 2:
                - narrate "<&c>Usage: /friend accept <player>"
                - stop

            - define requester <server.match_player[<context.args.get[2]>].if_null[null]>

            - if <[requester]> == null:
                - narrate "<&c>That player is not online."
                - stop

            - run friends_accept_request def.player:<player> def.requester:<[requester]>

        - case deny:
            - if <context.args.size> <= 2:
                - narrate "<&c>Usage: /friend deny <player>"
                - stop

            - define requester <server.match_player[<context.args.get[2]>].if_null[null]>

            - if <[requester]> == null:
                - narrate "<&c>That player is not online."
                - stop

            - run friends_deny_request def.player:<player> def.requester:<[requester]>

        - case remove:
            - if <context.args.size> <= 2:
                - narrate "<&c>Usage: /friend remove <player>"
                - stop

            - define target <server.match_player[<context.args.get[2]>].if_null[null]>

            - if <[target]> == null:
                - narrate "<&c>That player is not online."
                - stop

            - if !<proc[friends_has].context[<player>|<[target]>]>:
                - narrate "<&c>You are not friends with <[target].name>."
                - stop

            - run friends_remove def.player:<player> def.target:<[target]>

            - narrate "<&e>You removed <[target].name> from your friends."
            - narrate "<&e><player.name> removed you from their friends." targets:<[target]>

        - case list:
            - run friends_list_online def.player:<player>

        - case msg:
            - if <context.args.size> <= 2:
                - narrate "<&c>Usage: /friend msg <player> <message>"
                - stop

            - if <context.args.size> <= 3:
                - narrate "<&c>Usage: /friend msg <player> <message>"
                - stop

            - define target <server.match_player[<context.args.get[2]>].if_null[null]>

            - if <[target]> == null:
                - narrate "<&c>That player is not online."
                - stop

            - define message <context.raw_args.after[<context.args.get[2]>].trim>

            - if <[message].is_empty>:
                - narrate "<&c>Please enter a message."
                - stop

            - run friends_message def.player:<player> def.target:<[target]> def.message:<[message]>

        - case reply:
            - if <context.args.size> <= 2:
                - narrate "<&c>Usage: /friend reply <message>"
                - stop

            - define message <context.raw_args.after[<context.args.get[1]>].trim>

            - if <[message].is_empty>:
                - narrate "<&c>Please enter a message."
                - stop

            - run friends_reply def.player:<player> def.message:<[message]>

        - case r:
            - if <context.args.size> <= 2:
                - narrate "<&c>Usage: /friend r <message>"
                - stop

            - define message <context.raw_args.after[<context.args.get[1]>].trim>

            - if <[message].is_empty>:
                - narrate "<&c>Please enter a message."
                - stop

            - run friends_reply def.player:<player> def.message:<[message]>

        - default:
            - run friends_command_help def.player:<player>


friends_command_help:
    debug: false
    type: task
    definitions: player
    script:
    - narrate "<&6>---------- Friends ----------" targets:<[player]>
    - narrate "<&e>/friend add <player> <&7>- Send a friend request." targets:<[player]>
    - narrate "<&e>/friend accept <player> <&7>- Accept a friend request." targets:<[player]>
    - narrate "<&e>/friend deny <player> <&7>- Deny a friend request." targets:<[player]>
    - narrate "<&e>/friend remove <player> <&7>- Remove a friend." targets:<[player]>
    - narrate "<&e>/friend list <&7>- View your friends." targets:<[player]>
    - narrate "<&e>/friend msg <player> <message> <&7>- Message a friend." targets:<[player]>
    - narrate "<&e>/friend reply <message> <&7>- Reply to your last friend message." targets:<[player]>
    - narrate "<&e>/friend r <message> <&7>- Shortcut for reply." targets:<[player]>
    - narrate "<&6>-----------------------------" targets:<[player]>