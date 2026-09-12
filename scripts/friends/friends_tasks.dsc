friends_has:
    debug: false
    type: procedure
    definitions: player|target
    script:
        - define player_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
        - define target_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
        - define master <player[<[player_master_uuid]>]>
        - define friends <[master].flag[friends].if_null[<list[]>]>
        - determine <[friends].filter_tag[<[filter_value].equals[<[target_master_uuid]>]>].is_empty.not>


friends_add:
    debug: false
    type: task
    definitions: player|target
    script:
        - define player_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
        - define target_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
        - define player_master <player[<[player_master_uuid]>]>
        - define target_master <player[<[target_master_uuid]>]>
        - define player_friends <[player_master].flag[friends].if_null[<list[]>]>
        - define target_friends <[target_master].flag[friends].if_null[<list[]>]>
        - flag <[player_master]> friends:<[player_friends].include[<[target_master_uuid]>].deduplicate>
        - flag <[target_master]> friends:<[target_friends].include[<[player_master_uuid]>].deduplicate>
        - adjust server save


friends_remove:
    debug: false
    type: task
    definitions: player|target
    script:
    - define player_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
    - define target_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
    - define player_master <player[<[player_master_uuid]>]>
    - define target_master <player[<[target_master_uuid]>]>
    - define player_friends <[player_master].flag[friends].if_null[<list[]>]>
    - define target_friends <[target_master].flag[friends].if_null[<list[]>]>
    - define new_player_friends <[player_friends].exclude[<[target_master_uuid]>]>
    - define new_target_friends <[target_friends].exclude[<[player_master_uuid]>]>
    - if <[new_player_friends].is_empty>:
        - flag <[player_master]> friends:!
    - else:
        - flag <[player_master]> friends:<[new_player_friends]>
    - if <[new_target_friends].is_empty>:
        - flag <[target_master]> friends:!
    - else:
        - flag <[target_master]> friends:<[new_target_friends]>
    - adjust server save


friends_send_request:
    debug: false
    type: task
    definitions: player|target|message
    script:
        - define player_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
        - define target_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
        - define target_master <player[<[target_master_uuid]>]>
        - define requests <[target_master].flag[friends_requests].if_null[<list[]>]>
        - if <[requests].filter_tag[<[filter_value].equals[<[player_master_uuid]>]>].is_empty.not>:
            - narrate format:formats_prefix "<&c>You already sent <[target].name> a friend request."
            - stop
        - flag <[target_master]> friends_requests:->:<[player_master_uuid]>
        - adjust server save
        - narrate format:formats_prefix "<&a>Friend request sent to <[target].name>."
        - define online_target <server.match_player[<[target_master].name>].if_null[null]>
        - if <[online_target]> != null:
            - narrate "<&e><[player].name> has sent you a friend request." targets:<[online_target]>
            - if <[message].length> > 0:
                - narrate "<&7>Message: <&f><[message]>" targets:<[online_target]>
            - narrate "<&7>Use <&f>/friend accept <[player].name><&7> to accept." targets:<[online_target]>
            - narrate "<&7>Use <&f>/friend deny <[player].name><&7> to deny it." targets:<[online_target]>

friends_accept_request:
    debug: false
    type: task
    definitions: player|target
    script:
    - define player_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
    - define player_master <player[<[player_master_uuid]>]>
    - if !<[player_master].has_flag[friends_requests]>:
        - narrate format:formats_prefix "<&c>You do not have pending friend requests."
        - stop
    - define target_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
    - define target_master <player[<[target_master_uuid]>]>
    - if !<[player_master].flag[friends_requests].contains[<[target_master_uuid]>]>:
        - narrate format:formats_prefix "<&c>You do not have a pending friend request from <[target_master].name>."
        - stop
    - run friends_add def.player:<[player]> def.target:<[target]>
    - flag <[player_master]> friends_requests:<[player_master].flag[friends_requests].exclude[<[target_master_uuid]>]>
    - adjust server save
    - narrate format:formats_prefix "<&a>You are now friends with <[target_master].name>."
    - define online_target <server.match_player[<[target_master].name>].if_null[null]>
    - if <[online_target]> != null:
        - narrate "<&a><player.name> accepted your friend request." targets:<[online_target]>

friends_deny_request:
    debug: false
    type: task
    definitions: player|target
    script:
    - define player_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
    - define player_master <player[<[player_master_uuid]>]>
    - if !<[player_master].has_flag[friends_requests]>:
        - narrate format:formats_prefix "<&c>You do not have a pending friend request."
        - stop
    - define target_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
    - define target_master <player[<[target_master_uuid]>]>
    - if !<[player_master].flag[friends_requests].contains[<[target_master_uuid]>]>:
        - narrate format:formats_prefix "<&c>You do not have a pending friend request from <[target_master].name>."
        - stop
    - flag <[player_master]> friends_requests:<[player_master].flag[friends_requests].exclude[<[target_master_uuid]>]>
    - adjust server save
    - narrate format:formats_prefix "<&e>You denied <[target_master].name>'s friend request."
    - define online_target <server.match_player[<[target_master].name>].if_null[null]>
    - if <[online_target]> != null:
        - narrate "<&e><player.name> denied your friend request." targets:<[online_target]>

friends_message:
    debug: false
    type: task
    definitions: player|target|message
    script:
        - if <[player]> == <[target]>:
            - narrate format:formats_prefix "<&c>You cannot message yourself."
            - stop
        - if !<proc[friends_has].context[<[player]>|<[target]>]>:
            - narrate format:formats_prefix "<&c>You are not friends with <[target].name>."
            - stop
        - narrate format:formats_prefix "<&d>YOU <&8>-<&gt> <&f><[target].name><&7>: <&f><[message]>"
        - narrate format:formats_prefix "<&d><[player].name> <&8>-<&gt> <&f>YOU<&7>: <&f><[message]>" targets:<[target]>
        - define player_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
        - define target_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
        - flag <[player]> friends_reply:<[target_master_uuid]>
        - flag <[target]> friends_reply:<[player_master_uuid]>

friends_find_online:
    debug: false
    type: procedure
    definitions: master_uuid
    script:
        - determine <server.match_player[<player[<[master_uuid]>].name>].if_null[null]>

friends_reply:
    debug: false
    type: task
    definitions: player|message
    script:
        - if !<[player].has_flag[friends_reply]>:
            - narrate format:formats_prefix "<&c>You have nobody to reply to."
            - stop
        - define target_master_uuid <[player].flag[friends_reply]>
        - define target <proc[friends_find_online].context[<[target_master_uuid]>]>
        - if <[target]> == null:
            - narrate format:formats_prefix "<&c>Your last friend is not online."
            - stop
        - if !<proc[friends_has].context[<[player]>|<[target]>]>:
            - flag <[player]> friends_reply:!
            - narrate format:formats_prefix "<&c>You are no longer friends with <[target].name>."
            - stop
        - run friends_message def.player:<[player]> def.target:<[target]> def.message:<[message]>

friends_list:
    debug: false
    type: task
    definitions: player
    script:
        - define friends <[player].flag[friends].if_null[<list[]>]>
        - if <[friends].is_empty>:
            - narrate format:formats_prefix "<&7>You have no friends in your friend list."
            - stop
        - narrate format:formats_prefix <&d>Friends
        - foreach <[friends]> as:friend_master_uuid:
            - define friend <proc[friends_find_online].context[<[friend_master_uuid]>]>
            - if <[friend]> != null:
                - narrate "<&a><[friend].name> <&8>• <&7>Online"
                - foreach next
            - define offline_friend <player[<[friend_master_uuid]>]>
            - narrate "<&7><[offline_friend].name> <&8>• <&7>Offline"

friends_wipe:
    debug: false
    type: task
    definitions: player
    script:
    - define player_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
    - define player_master <player[<[player_master_uuid]>]>
    - define size <[player_master].flag[friends].size>
    - foreach <[player_master].flag[friends]> as:target_master_uuid:
        - define target_master <player[<[target_master_uuid]>]>
        - run friends_remove def.player:<[player]> def.target:<[target_master]>
        - define online_target <proc[friends_find_online].context[<[target_master_uuid]>]>
        - if <[online_target]> != null:
            - narrate format:formats_prefix targets:<[online_target]> "<&c>You were /friend wiped from <[player].name>'s friend list"
    - flag <[player_master]> friends:!
    - flag <[player_master]> friends_reply:!
    - flag <[player_master]> friends_wipe_confirm:!
    - adjust server save
    - narrate format:formats_prefix "<&a>Your friends list has been wiped. <&7>(<[size]> friends removed)"