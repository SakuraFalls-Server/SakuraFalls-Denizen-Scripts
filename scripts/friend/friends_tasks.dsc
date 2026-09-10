friends_has:
    debug: false
    type: procedure
    definitions: player|target
    script:
    - define master_target_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
    - define friends <[player].flag[friends].if_null[<list[]>]>
    - determine <[friends].contains_single[<[master_target_uuid]>]>


friends_get_list:
    debug: false
    type: procedure
    definitions: player
    script:
    - determine <[player].flag[friends].if_null[<list[]>]>


friends_add:
    debug: false
    type: task
    definitions: player|target
    script:
    - define master_player_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
    - define master_target_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>

    - define player_friends <[player].flag[friends].if_null[<list[]>]>
    - define target_friends <[target].flag[friends].if_null[<list[]>]>

    - if !<[player_friends].contains_single[<[master_target_uuid]>]>:
        - define player_friends <[player_friends].include[<[master_target_uuid]>]>

    - if !<[target_friends].contains_single[<[master_player_uuid]>]>:
        - define target_friends <[target_friends].include[<[master_player_uuid]>]>

    - flag <[player]> friends:<[player_friends]>
    - flag <[target]> friends:<[target_friends]>


friends_remove:
    debug: false
    type: task
    definitions: player|target
    script:
    - define master_player_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
    - define master_target_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>

    - define player_friends <[player].flag[friends].if_null[<list[]>]>
    - define target_friends <[target].flag[friends].if_null[<list[]>]>

    - define player_friends <[player_friends].exclude[<[master_target_uuid]>]>
    - define target_friends <[target_friends].exclude[<[master_player_uuid]>]>

    - flag <[player]> friends:<[player_friends]>
    - flag <[target]> friends:<[target_friends]>


friends_send_request:
    debug: false
    type: task
    definitions: player|target
    script:
    - define master_player_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
    - flag <[target]> friend_request:<[master_player_uuid]>

    - flag <[player]> friend_reply:<proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
    - flag <[target]> friend_reply:<[master_player_uuid]>

    - narrate "<&a>Friend request sent to <[target].name>." targets:<[player]>
    - narrate "<&e><[player].name> has sent you a friend request. Use <&f>/friend accept <[player].name><&e> to accept it, or <&f>/friend deny <[player].name><&e> to deny it." targets:<[target]>


friends_accept_request:
    debug: false
    type: task
    definitions: player|requester
    script:
    - define master_player_uuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
    - define master_requester_uuid <proc[liteprofilesutils_get_master_uuid].context[<[requester]>]>

    - if !<[player].has_flag[friend_request]>:
        - narrate "<&c>You do not have a pending friend request." targets:<[player]>
        - stop

    - if <[player].flag[friend_request]> != <[master_requester_uuid]>:
        - narrate "<&c>You do not have a pending friend request from <[requester].name>." targets:<[player]>
        - stop

    - run friends_add def.player:<[player]> def.target:<[requester]>

    - flag <[player]> friend_request:!
    - flag <[player]> friend_reply:<[master_requester_uuid]>
    - flag <[requester]> friend_reply:<[master_player_uuid]>

    - narrate "<&a>You are now friends with <[requester].name>." targets:<[player]>
    - narrate "<&a><[player].name> accepted your friend request." targets:<[requester]>


friends_deny_request:
    debug: false
    type: task
    definitions: player|requester
    script:
    - define master_requester_uuid <proc[liteprofilesutils_get_master_uuid].context[<[requester]>]>

    - if !<[player].has_flag[friend_request]>:
        - narrate "<&c>You do not have a pending friend request." targets:<[player]>
        - stop

    - if <[player].flag[friend_request]> != <[master_requester_uuid]>:
        - narrate "<&c>You do not have a pending friend request from <[requester].name>." targets:<[player]>
        - stop

    - flag <[player]> friend_request:!

    - narrate "<&e>You denied <[requester].name>'s friend request." targets:<[player]>
    - narrate "<&e><[player].name> denied your friend request." targets:<[requester]>


friends_clear_request:
    debug: false
    type: task
    definitions: player
    script:
    - if <[player].has_flag[friend_request]>:
        - flag <[player]> friend_request:!


friends_set_reply:
    debug: false
    type: task
    definitions: player|target
    script:
    - define master_target_uuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
    - flag <[player]> friend_reply:<[master_target_uuid]>


friends_message:
    debug: false
    type: task
    definitions: player|target|message
    script:
    - if <[player]> == <[target]>:
        - narrate "<&c>You cannot message yourself." targets:<[player]>
        - stop

    - if !<proc[friends_has].context[<[player]>|<[target]>]>:
        - narrate "<&c>You are not friends with <[target].name>." targets:<[player]>
        - stop

    - narrate "<&d>[Friend] <&f>You<&7>: <[message]>" targets:<[player]>
    - narrate "<&d>[Friend] <&f><[player].name><&7>: <[message]>" targets:<[target]>

    - run friends_set_reply def.player:<[player]> def.target:<[target]>
    - run friends_set_reply def.player:<[target]> def.target:<[player]>


friends_reply:
    debug: false
    type: task
    definitions: player|message
    script:
    - if !<[player].has_flag[friend_reply]>:
        - narrate "<&c>You have nobody to reply to." targets:<[player]>
        - stop

    - define master_target_uuid <[player].flag[friend_reply]>
    - define target_list <server.online_players.filter_tag[<proc[liteprofilesutils_get_master_uuid].context[<[filter_value]>].equals[<[master_target_uuid]>]>]>

    - if <[target_list].is_empty>:
        - narrate "<&c>Your last friend is not online." targets:<[player]>
        - stop

    - define target <[target_list].first>

    - if !<proc[friends_has].context[<[player]>|<[target]>]>:
        - narrate "<&c>You are no longer friends with <[target].name>." targets:<[player]>
        - stop

    - run friends_message def.player:<[player]> def.target:<[target]> def.message:<[message]>


friends_list_online:
    debug: false
    type: task
    definitions: player
    script:
    - define friends <[player].flag[friends].if_null[<list[]>]>

    - if <[friends].is_empty>:
        - narrate "<&7>You currently have no friends." targets:<[player]>
        - stop

    - narrate "<&6>---------- Friends ----------" targets:<[player]>

    - foreach <[friends]> as:friend_uuid:
        - define friend <[friend_uuid].as[player]>
        - if <[friend].has_played_before>:
            - if <[friend].is_online>:
                - narrate "<&a><[friend].name> <&7>(Online)" targets:<[player]>
            - else:
                - narrate "<&7><[friend].name> <&7>(Offline)" targets:<[player]>

    - narrate "<&6>-----------------------------" targets:<[player]>


friends_cleanup:
    debug: false
    type: task
    definitions: player
    script:
    - if <[player].has_flag[friend_request]>:
        - flag <[player]> friend_request:!