friends_command:
    debug: false
    type: command
    name: friend
    description: Manage your friends.
    usage: /friend
    permission: friend.command.friend
    aliases:
    - f
    script:
        - if <context.source_type> != player:
            - narrate format:formats_prefix "<&c>Please run this command as a player."
            - stop
        - if <context.args.is_empty>:
            - run friends_command_help
            - stop
        - choose <context.args.first.to_lowercase>:
            - case help:
                - run friends_command_help
            - case add:
                - if <context.args.size> < 2:
                    - narrate format:formats_prefix "<&c>Usage: /friend add <&lt>IGN<&gt>"
                    - stop
                - define target <server.match_player[<context.args.get[2]>].if_null[null]>
                - if <[target]> == null:
                    - narrate format:formats_prefix "<&c>Player not found."
                    - stop
                - if <[target]> == <player>:
                    - narrate format:formats_prefix "<&c>You cannot add yourself as a friend."
                    - stop
                - if <proc[friends_has].context[<player>|<[target]>]>:
                    - narrate format:formats_prefix "<&c>You are already friends with <[target].name>."
                    - stop
                - if <[target].has_flag[friend_request]>:
                    - define player_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<player>]>
                    - if <[target].flag[friend_request]> == <[player_master_uuid]>:
                        - narrate format:formats_prefix "<&c>You already sent <[target].name> a friend request."
                        - stop
                    - narrate format:formats_prefix "<&c><[target].name> already has a pending friend request."
                    - stop
                - define message ""
                - if <context.args.size> >= 3:
                    - define message <context.args.get[3].to[last].space_separated>
                - run friends_send_request defmap:<map[player=<player>;target=<[target]>;message=<[message]>]>
            - case accept:
                - if <context.args.size> < 2:
                    - narrate format:formats_prefix "<&c>Usage: /friend accept <&lt>IGN<&gt>"
                    - stop
                - define target <server.match_player[<context.args.get[2]>].if_null[null]>
                - if <[target]> == null:
                    - narrate format:formats_prefix "<&c>Player not found."
                    - stop
                - run friends_accept_request defmap:<map[player=<player>;target=<[target]>]>
            - case deny:
                - if <context.args.size> < 2:
                    - narrate format:formats_prefix "<&c>Usage: /friend deny <&lt>IGN<&gt>"
                    - stop
                - define target <server.match_player[<context.args.get[2]>].if_null[null]>
                - if <[target]> == null:
                    - narrate format:formats_prefix "<&c>Player not found."
                    - stop
                - run friends_deny_request defmap:<map[player=<player>;target=<[target]>]>
            - case remove:
                - if <context.args.size> < 2:
                    - narrate format:formats_prefix "<&c>Usage: /friend remove <&lt>IGN<&gt>"
                    - stop
                - define target <server.match_player[<context.args.get[2]>].if_null[null]>
                - if <[target]> == null:
                    - narrate format:formats_prefix "<&c>Player not found."
                    - stop
                - if !<proc[friends_has].context[<player>|<[target]>]>:
                    - narrate format:formats_prefix "<&c>You are not friends with <[target].name>."
                    - stop
                - run friends_remove defmap:<map[player=<player>;target=<[target]>]>
                - narrate format:formats_prefix "<&e>You removed <[target].name> from your friends."
                - narrate "<&e><player.name> removed you from their friends." targets:<[target]>
            - case list:
                - run friends_list defmap:<map[player=<player>]>
            - case message:
                - if <context.args.size> < 3:
                    - narrate format:formats_prefix "<&c>Usage: /friend message <&lt>IGN<&gt> <&lt>message<&gt>"
                    - stop
                - define target <server.match_player[<context.args.get[2]>].if_null[null]>
                - if <[target]> == null:
                    - narrate format:formats_prefix "<&c>Player not found."
                    - stop
                - define message <context.args.get[3].to[last].space_separated>
                - run friends_message defmap:<map[player=<player>;target=<[target]>;message=<[message]>]>
            - case msg:
                - if <context.args.size> < 3:
                    - narrate format:formats_prefix "<&c>Usage: /friend msg <&lt>IGN<&gt> <&lt>message<&gt>"
                    - stop
                - define target <server.match_player[<context.args.get[2]>].if_null[null]>
                - if <[target]> == null:
                    - narrate format:formats_prefix "<&c>Player not found."
                    - stop
                - define message <context.args.get[3].to[last].space_separated>
                - run friends_message defmap:<map[player=<player>;target=<[target]>;message=<[message]>]>
            - case reply:
                - if <context.args.size> < 2:
                    - narrate format:formats_prefix "<&c>Usage: /friend reply <&lt>message<&gt>"
                    - stop
                - define message <context.args.get[2].to[last].space_separated>
                - run friends_reply defmap:<map[player=<player>;message=<[message]>]>
            - case wipe:
                - if <player.has_flag[friend_wipe_confirm]>:
                    - narrate format:formats_prefix "<&e>You already have a pending friends-list wipe."
                    - narrate "<&7>Use <&f>/f confirm<&7> to continue."
                    - stop
                - flag <player> friend_wipe_confirm:true expire:30s
                - narrate format:formats_prefix "<&c>This will permanently remove everyone from your friends list."
                - narrate "<&7>Use <&f>/f confirm<&7> within 30 seconds to confirm."
            - case confirm:
                - if !<player.has_flag[friend_wipe_confirm]>:
                    - narrate format:formats_prefix "<&c>You do not have a pending friends-list wipe."
                    - stop
                - flag <player> friend_wipe_confirm:!
                - run friends_wipe defmap:<map[player=<player>]>
            - default:
                - run friends_command_help

friends_command_help:
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
        - narrate "<&7>/friend wipe <&8>- <&f>Prepare to wipe your friends list."
        - narrate "<&7>/friend confirm <&8>- <&f>Confirm the friends-list wipe."