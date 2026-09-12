friends_command_friend:
    debug: false
    type: command
    name: friend
    description: Manage your friends.
    usage: /friend
    permission: friends.command.friend
    aliases:
    - f
    # TODO: should use the 'tab complete' key
    # tab complete:
    # - determine blablabla
    tab completions:
        1: <list[]>
    script:
        - if <context.source_type> != player:
            - narrate format:formats_prefix "<&c>Please run this command as a player."
            - stop
        - if <context.args.is_empty>:
            - run friends_command_friend_help
            - stop
        - choose <context.args.first.to_lowercase>:
            - case help:
                - run friends_command_friend_help
            - case add:
                - if <context.args.size> < 2:
                    - narrate format:formats_prefix "<&c>Usage: /friend add <&lt>IGN<&gt>"
                    - stop
                - define target <server.match_offline_player[<context.args.get[2]>].if_null[null]>
                - if <[target]> == null:
                    - narrate format:formats_prefix "<&c>Player not found."
                    - stop
                - define player_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<player>]>
                - define target_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
                - if <[target_master_uuid]> == <[player_master_uuid]>:
                    - narrate format:formats_prefix "<&c>You cannot add yourself as a friend."
                    - stop
                - if <proc[friends_has].context[<player>|<[target]>]>:
                    - narrate format:formats_prefix "<&c>You are already friends with <[target].name>."
                    - stop
                - define target_master <player[<[target_master_uuid]>]>
                - if <[target_master].has_flag[friend_requests]>:
                    - if <[target_master].flag[friend_requests].contains[<[player_master_uuid]>]>:
                        - narrate format:formats_prefix "<&c>You already sent <[target].name> a friend request."
                        - stop
                - define message <empty>
                - if <context.args.size> >= 3:
                    - define message <context.args.get[3].to[last].space_separated>
                - run friends_send_request def.player:<player> def.target:<[target]> def.message=<[message]>
            - case accept:
                - if <context.args.size> < 2:
                    - narrate format:formats_prefix "<&c>Usage: /friend accept <&lt>IGN<&gt>"
                    - stop
                - define target <server.match_offline_player[<context.args.get[2]>].if_null[null]>
                - if <[target]> == null:
                    - narrate format:formats_prefix "<&c>Player not found."
                    - stop
                - run friends_accept_request def.player:<player> def.target:<[target]>
            - case deny:
                - if <context.args.size> < 2:
                    - narrate format:formats_prefix "<&c>Usage: /friend deny <&lt>IGN<&gt>"
                    - stop
                - define target <server.match_offline_player[<context.args.get[2]>].if_null[null]>
                - if <[target]> == null:
                    - narrate format:formats_prefix "<&c>Player not found."
                    - stop
                - run friends_deny_request def.player:<player> def.target:<[target]>
            - case remove:
                - if <context.args.size> < 2:
                    - narrate format:formats_prefix "<&c>Usage: /friend remove <&lt>IGN<&gt>"
                    - stop
                - define target <server.match_offline_player[<context.args.get[2]>].if_null[null]>
                - if <[target]> == null:
                    - narrate format:formats_prefix "<&c>Player not found."
                    - stop
                - if !<proc[friends_has].context[<player>|<[target]>]>:
                    - narrate format:formats_prefix "<&c>You are not friends with <[target].name>."
                    - stop
                - run friends_remove def.player:<player> def.target:<[target]>
                - narrate format:formats_prefix "<&e>You removed <[target].name> from your friends."
                - define target_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
                - define online_target <proc[friends_find_online].context[<[target_master_uuid]>]>
                - if <[online_target]> != null:
                    - narrate format:formats_prefix "<&e><player.name> removed you from their friends." targets:<[online_target]>
            - case list:
                - run friends_list def.player:<player>
            - case message msg:
                - if <context.args.size> < 3:
                    - narrate format:formats_prefix "<&c>Usage: /friend message <&lt>IGN<&gt> <&lt>message<&gt>"
                    - stop
                - define target <server.match_offline_player[<context.args.get[2]>].if_null[null]>
                - if <[target]> == null:
                    - narrate format:formats_prefix "<&c>Player not found."
                    - stop
                - define message <context.args.get[3].to[last].space_separated>
                - run friends_message def.player:<player> def.target:<[target]> def.message:<[message]>
            - case reply r:
                - if <context.args.size> < 2:
                    - narrate format:formats_prefix "<&c>Usage: /friend reply <&lt>message<&gt>"
                    - stop
                - define message <context.args.get[2].to[last].space_separated>
                - run friends_reply def.player:<player> def.message:<[message]>
            - case wipe:
                - if <player.has_flag[friend_wipe_confirm]>:
                    - narrate format:formats_prefix "<&e>You already have a pending friend list wipe."
                    - narrate "<&7>Use <&f>/<context.alias> confirm<&7> to continue."
                - else:
                    - flag <player> friend_wipe_confirm:true expire:30s
                    - narrate format:formats_prefix "<&c>This will permanently remove everyone from your friend list."
                    - narrate "<&7>Use <&f>/<context.alias> confirm<&7> within 30 seconds to confirm."
            - case confirm:
                - if !<player.has_flag[friend_wipe_confirm]>:
                    - narrate format:formats_prefix "<&c>You do not have a pending friend list wipe."
                - else:
                    - flag <player> friend_wipe_confirm:!
                    - run friends_wipe def.player:<player>
            - default:
                - run friends_command_friend_help

friends_command_friend_help:
    debug: false
    type: task
    script:
        - narrate format:formats_prefix "<&d>Friend Commands"
        - narrate "<&7>/friend add <&lt>IGN<&gt> <&8>- <&f>Send a friend request."
        - narrate "<&7>/friend accept <&lt>IGN<&gt> <&8>- <&f>Accept a friend request."
        - narrate "<&7>/friend deny <&lt>IGN<&gt> <&8>- <&f>Deny a friend request."
        - narrate "<&7>/friend remove <&lt>IGN<&gt> <&8>- <&f>Remove a friend."
        - narrate "<&7>/friend list <&8>- <&f>View your friends."
        - narrate "<&7>/friend message <&lt>IGN<&gt> <&lt>message<&gt> <&8>- <&f>Message a friend."
        - narrate "<&7>/friend reply <&lt>message<&gt> <&8>- <&f>Reply to your last friend."
        - narrate "<&7>/friend wipe <&8>- <&f>Prepare to wipe your friend list."
        - narrate "<&7>/friend confirm <&8>- <&f>Confirm the friend list wipe."
