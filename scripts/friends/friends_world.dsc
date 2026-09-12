friends_world:
    debug: false
    type: world
    events:
        after player joins:
        - define joining_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<player>]>
        - foreach <server.online_players.exclude[<player>]> as:friend:
            - define friend_master <player[<proc[liteprofilesutils_get_master_uuid].context[<[friend]>]>]>
            - if !<[friend_master].has_flag[friends]>:
                - foreach next
            - define friend_list <[friend_master].flag[friends].if_null[<list[]>]>
            - if <[friend_list].contains[<[joining_master_uuid]>]>:
                - narrate "<&a>Your friend <&f><player.name><&a> is now online." targets:<[friend]>

        on player quits:
        - define leaving_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<player>]>
        - foreach <server.online_players.exclude[<player>]> as:friend:
            - define friend_master <player[<proc[liteprofilesutils_get_master_uuid].context[<[friend]>]>]>
            - if !<[friend_master].has_flag[friends]>:
                - foreach next
            - define friend_list <[friend_master].flag[friends].if_null[<list[]>]>
            - if <[friend_list].contains[<[leaving_master_uuid]>]>:
                - narrate "<&7>Your friend <&f><player.name><&7> is now offline." targets:<[friend]>