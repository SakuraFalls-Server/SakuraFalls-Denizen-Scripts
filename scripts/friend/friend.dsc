friend_command:
    type: command
    name: friend
    description: Friends
    usage: /friend
    permission: friend.command.friend
    aliases:
        - f
    script:
        - if <context.args.size> == 0:
            - narrate "<&b>===== Friends ====="
            - narrate "<&f>/friend add [player] <&7>- Send a friend request"
            - narrate "<&f>/friend accept [player] <&7>- Accept a friend request"
            - narrate "<&f>/friend deny [player] <&7>- Deny a friend request"
            - narrate "<&f>/friend remove [player] <&7>- Remove a friend"
            - narrate "<&f>/friend list <&7>- View your friends"
            - narrate "<&f>/friend msg [player] [message] <&7>- Message a friend"
            - narrate "<&f>/friend reply [message] <&7>- Reply to the last message"
            - stop

        - define action <context.args.get[1]>

        - if <[action]> == add:
            - if <context.args.size> < 2:
                - narrate "<&c>Usage: /friend add [player]"
                - stop

            - define target <server.match_player[<context.args.get[2]>]||null>

            - if <[target]> == null:
                - narrate "<&c>That player is not online."
                - stop

            - if <[target].name> == <player.name>:
                - narrate "<&c>You cannot add yourself."
                - stop

            - if <player.flag[friends].contains[<[target].name>]>:
                - narrate "<&c>You are already friends with <[target].name>."
                - stop

            - flag <[target]> friend_request:<player.name>

            - narrate "<&a>Friend request sent to <[target].name>."
            - narrate "<&b><player.name> sent you a friend request!" targets:<[target]>
            - narrate "<&7>Use /friend accept <player.name> to accept it." targets:<[target]>
            - narrate "<&7>Use /friend deny <player.name> to deny it." targets:<[target]>
            - stop

        - if <[action]> == accept:
            - if <context.args.size> < 2:
                - narrate "<&c>Usage: /friend accept [player]"
                - stop

            - define target <server.match_player[<context.args.get[2]>]||null>

            - if <[target]> == null:
                - narrate "<&c>That player is not online."
                - stop

            - if !<player.has_flag[friend_request]>:
                - narrate "<&c>You don't have a friend request from that player."
                - stop

            - if <player.flag[friend_request]> != <[target].name>:
                - narrate "<&c>You don't have a friend request from <[target].name>."
                - stop

            - flag player friend_request:!

            - flag player friends:->:<[target].name>
            - flag <[target]> friends:->:<player.name>

            - narrate "<&a>You are now friends with <[target].name>!"
            - narrate "<&a><player.name> accepted your friend request!" targets:<[target]>
            - stop

        - if <[action]> == deny:
            - if <context.args.size> < 2:
                - narrate "<&c>Usage: /friend deny [player]"
                - stop

            - define target <server.match_player[<context.args.get[2]>]||null>

            - if <[target]> == null:
                - narrate "<&c>That player is not online."
                - stop

            - if !<player.has_flag[friend_request]>:
                - narrate "<&c>You don't have a friend request from that player."
                - stop

            - if <player.flag[friend_request]> != <[target].name>:
                - narrate "<&c>You don't have a friend request from <[target].name>."
                - stop

            - flag player friend_request:!

            - narrate "<&c>You denied <[target].name>'s friend request."
            - narrate "<&c><player.name> denied your friend request." targets:<[target]>
            - stop

        - if <[action]> == remove:
            - if <context.args.size> < 2:
                - narrate "<&c>Usage: /friend remove [player]"
                - stop

            - define target <server.match_player[<context.args.get[2]>]||null>

            - if <[target]> == null:
                - narrate "<&c>That player is not online."
                - stop

            - if !<player.flag[friends].contains[<[target].name>]>:
                - narrate "<&c>You are not friends with <[target].name>."
                - stop

            - flag player friends:<-:<[target].name>
            - flag <[target]> friends:<-:<player.name>

            - narrate "<&a>You removed <[target].name> from your friends list."
            - narrate "<&c><player.name> removed you from their friends list." targets:<[target]>
            - stop

        - if <[action]> == list:
            - if !<player.has_flag[friends]>:
                - narrate "<&7>You don't have any friends yet."
                - stop

            - narrate "<&b>===== Friends ====="

            - foreach <player.flag[friends]> as:friend:
                - define online <server.match_player[<[friend]>]||null>

                - if <[online]> == null:
                    - narrate "<&7><[friend]> <&8>- Offline"
                - else:
                    - narrate "<&a><[friend]> <&8>- Online"

            - stop

        - if <[action]> == msg:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /friend msg [player] [message]"
                - stop

            - define target <server.match_player[<context.args.get[2]>]||null>

            - if <[target]> == null:
                - narrate "<&c>That player is not online."
                - stop

            - if !<player.flag[friends].contains[<[target].name>]>:
                - narrate "<&c>You are not friends with <[target].name>."
                - stop

            - define message <context.args.get[3].to[<context.args.size>].space_separated>

            - flag <[target]> friend_reply:<player.name>

            - narrate "<&8>[<&b>To <[target].name><&8>] <&f><[message]>"
            - narrate "<&8>[<&b>From <player.name><&8>] <&f><[message]>" targets:<[target]>
            - stop

        - if <[action]> == reply:
            - if <context.args.size> < 2:
                - narrate "<&c>Usage: /friend reply [message]"
                - stop

            - if !<player.has_flag[friend_reply]>:
                - narrate "<&c>You have nobody to reply to."
                - stop

            - define target <server.match_player[<player.flag[friend_reply]>]||null>

            - if <[target]> == null:
                - narrate "<&c>Your last message sender is not online."
                - stop

            - if !<player.flag[friends].contains[<[target].name>]>:
                - narrate "<&c>You are no longer friends with <[target].name>."
                - stop

            - define message <context.args.get[2].to[<context.args.size>].space_separated>

            - flag <[target]> friend_reply:<player.name>

            - narrate "<&8>[<&b>To <[target].name><&8>] <&f><[message]>"
            - narrate "<&8>[<&b>From <player.name><&8>] <&f><[message]>" targets:<[target]>
            - stop

        - if <[action]> == r:
            - if <context.args.size> < 2:
                - narrate "<&c>Usage: /friend r [message]"
                - stop

            - if !<player.has_flag[friend_reply]>:
                - narrate "<&c>You have nobody to reply to."
                - stop

            - define target <server.match_player[<player.flag[friend_reply]>]||null>

            - if <[target]> == null:
                - narrate "<&c>Your last message sender is not online."
                - stop

            - if !<player.flag[friends].contains[<[target].name>]>:
                - narrate "<&c>You are no longer friends with <[target].name>."
                - stop

            - define message <context.args.get[2].to[<context.args.size>].space_separated>

            - flag <[target]> friend_reply:<player.name>

            - narrate "<&8>[<&b>To <[target].name><&8>] <&f><[message]>"
            - narrate "<&8>[<&b>From <player.name><&8>] <&f><[message]>" targets:<[target]>
            - stop

        - narrate "<&c>Unknown friend command."
        - narrate "<&7>Use /friend to view the available commands."