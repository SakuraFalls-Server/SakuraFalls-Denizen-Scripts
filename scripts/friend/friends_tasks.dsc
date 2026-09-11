friends_has:
    debug: false
    type: procedure
    definitions: player|target
    script:
        - define target_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
        - define friends <[player].flag[friends].if_null[<list[]>]>
        - determine <[friends].filter_tag[<[filter_value].equals[<[target_master_uuid]>]>].is_empty.not>

friends_add:
    debug: false
    type: task
    definitions: player|target
    script:
        - define player_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
        - define target_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
        - define player_friends <[player].flag[friends].if_null[<list[]>]>
        - define target_friends <[target].flag[friends].if_null[<list[]>]>
        - if <[player_friends].filter_tag[<[filter_value].equals[<[target_master_uuid]>]>].is_empty>:
            - flag <[player]> friends:->:<[target_master_uuid]>
        - if <[target_friends].filter_tag[<[filter_value].equals[<[player_master_uuid]>]>].is_empty>:
            - flag <[target]> friends:->:<[player_master_uuid]>

friends_remove:
    debug: false
    type: task
    definitions: player|target
    script:
        - define player_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
        - define target_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
        - define player_friends <[player].flag[friends].if_null[<list[]>]>
        - define target_friends <[target].flag[friends].if_null[<list[]>]>
        - define new_player_friends <[player_friends].filter_tag[<[filter_value].equals[<[target_master_uuid]>].not>]>
        - define new_target_friends <[target_friends].filter_tag[<[filter_value].equals[<[player_master_uuid]>].not>]>
        - if <[new_player_friends].is_empty>:
            - flag <[player]> friends:!
        - else:
            - flag <[player]> friends:<[new_player_friends]>
        - if <[new_target_friends].is_empty>:
            - flag <[target]> friends:!
        - else:
            - flag <[target]> friends:<[new_target_friends]>


friends_send_request:
    debug: false
    type: task
    definitions: player|target|message
    script:
        - define player_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
        - flag <[target]> friend_request:<[player_master_uuid]>
        - narrate format:formats_prefix "<&a>Friend request sent to <[target].name>."
        - if <[message].is_empty>:
            - narrate "<&e><player.name> has sent you a friend request." targets:<[target]>
            - narrate "<&7>Use <&f>/friend accept <player.name><&7> to accept." targets:<[target]>
            - narrate "<&7>Use <&f>/friend deny <player.name><&7> to deny it." targets:<[target]>
            - stop
        - narrate "<&e><player.name> has sent you a friend request." targets:<[target]>
        - narrate "<&7>Message: <&f><[message]>" targets:<[target]>
        - narrate "<&7>Use <&f>/friend accept <player.name><&7> to accept." targets:<[target]>
        - narrate "<&7>Use <&f>/friend deny <player.name><&7> to deny it." targets:<[target]>


friends_accept_request:
    debug: false
    type: task
    definitions: player|target
    script:
        - if !<[player].has_flag[friend_request]>:
            - narrate format:formats_prefix "<&c>You do not have a pending friend request."
            - stop
        - define target_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
        - if <[player].flag[friend_request]> != <[target_master_uuid]>:
            - narrate format:formats_prefix "<&c>You do not have a pending friend request from <[target].name>."
            - stop
        - if <proc[friends_has].context[<[player]>|<[target]>]>:
            - flag <[player]> friend_request:!
            - narrate format:formats_prefix "<&c>You are already friends with <[target].name>."
            - stop
        - run friends_add defmap:<map[player=<[player]>;target=<[target]>]>
        - flag <[player]> friend_request:!
        - narrate format:formats_prefix "<&a>You are now friends with <[target].name>."
        - narrate "<&a><player.name> accepted your friend request." targets:<[target]>

friends_deny_request:
    debug: false
    type: task
    definitions: player|target
    script:
        - if !<[player].has_flag[friend_request]>:
            - narrate format:formats_prefix "<&c>You do not have a pending friend request."
            - stop
        - define target_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
        - if <[player].flag[friend_request]> != <[target_master_uuid]>:
            - narrate format:formats_prefix "<&c>You do not have a pending friend request from <[target].name>."
            - stop
        - flag <[player]> friend_request:!
        - narrate format:formats_prefix "<&e>You denied <[target].name>'s friend request."
        - narrate "<&e><player.name> denied your friend request." targets:<[target]>

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
        - narrate format:formats_prefix "<&d>YOU <&8>-> <&f><[target].name><&7>: <&f><[message]>"
        - narrate format:formats_prefix "<&d><[player].name> <&8>-> <&f>YOU<&7>: <&f><[message]>" targets:<[target]>
        - define player_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
        - define target_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
        - flag <[player]> friend_reply:<[target_master_uuid]>
        - flag <[target]> friend_reply:<[player_master_uuid]>

friends_find_online:
    debug: false
    type: procedure
    definitions: master_uuid
    script:
        - foreach <server.online_players> as:possible:
            - define possible_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[possible]>]>
            - if <[possible_master_uuid]> == <[master_uuid]>:
                - determine <[possible]>
        - determine null

friends_reply:
    debug: false
    type: task
    definitions: player|message
    script:
        - if !<[player].has_flag[friend_reply]>:
            - narrate format:formats_prefix "<&c>You have nobody to reply to."
            - stop
        - define target_master_uuid <[player].flag[friend_reply]>
        - define target <proc[friends_find_online].context[<[target_master_uuid]>]>
        - if <[target]> == null:
            - narrate format:formats_prefix "<&c>Your last friend is not online."
            - stop
        - if !<proc[friends_has].context[<[player]>|<[target]>]>:
            - flag <[player]> friend_reply:!
            - narrate format:formats_prefix "<&c>You are no longer friends with <[target].name>."
            - stop
        - run friends_message defmap:<map[player=<[player]>;target=<[target]>;message=<[message]>]>

friends_list:
    debug: false
    type: task
    definitions: player
    script:
        - define friends <[player].flag[friends].if_null[<list[]>]>
        - if <[friends].is_empty>:
            - narrate format:formats_prefix "<&7>You have no friends."
            - stop
        - narrate format:formats_prefix "<&d>Friends"
        - foreach <[friends]> as:friend_master_uuid:
            - define friend <proc[friends_find_online].context[<[friend_master_uuid]>]>
            - if <[friend]> != null:
                - narrate "<&a><[friend].name> <&8>• <&7>Online"
                - foreach next
            - define offline_friend <[friend_master_uuid].as[player]>
            - if <[offline_friend].exists>:
                - narrate "<&7><[offline_friend].name> <&8>• <&7>Offline"
            - else:
                - narrate "<&7>Unknown Player <&8>• <&7>Offline"

friends_wipe:
    debug: false
    type: task
    definitions: player
    script:
        - define player_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
        - foreach <server.players> as:friend:
            - if !<[friend].has_flag[friends]>:
                - foreach next
            - define friend_list <[friend].flag[friends].if_null[<list[]>]>
            - define new_friend_list <[friend_list].filter_tag[<[filter_value].equals[<[player_master_uuid]>].not>]>
            - if <[new_friend_list].is_empty>:
                - flag <[friend]> friends:!
            - else:
                - flag <[friend]> friends:<[new_friend_list]>

            - if <[friend]> != <[player]>:
                - if <[friend].has_flag[friend_reply]>:
                    - if <[friend].flag[friend_reply]> == <[player_master_uuid]>:
                        - flag <[friend]> friend_reply:!
                - if <[friend].is_online>:
                    - narrate format:formats_prefix "<&c>You have been /f wiped by <[player].name>." targets:<[friend]>
        - flag <[player]> friends:!
        - flag <[player]> friend_reply:!
        - flag <[player]> friend_wipe_confirm:!
        - narrate format:formats_prefix "<&a>Your friends list has been wiped."