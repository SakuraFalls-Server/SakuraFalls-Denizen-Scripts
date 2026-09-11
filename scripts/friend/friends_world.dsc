friends_world:
    debug: false
    type: world
    events:

        on player joins:
            - wait 1s
            - define joining_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<player>]>
            - foreach <server.online_players> as:friend:
                - if <[friend]> == <player>:
                    - foreach next
                - if !<[friend].has_flag[friends]>:
                    - foreach next
                - define friend_list <[friend].flag[friends].if_null[<list[]>]>
                - if <[friend_list].contains[<[joining_master_uuid]>]>:
                    - narrate "<&a>Your friend <&f><player.name><&a> has come online." targets:<[friend]>

        on player quits:
            - define leaving_master_uuid <proc[liteprofilesutils_get_master_uuid].context[<player>]>
            - foreach <server.online_players> as:friend:
                - if <[friend]> == <player>:
                    - foreach next
                - if !<[friend].has_flag[friends]>:
                    - foreach next
                - define friend_list <[friend].flag[friends].if_null[<list[]>]>
                - if <[friend_list].contains[<[leaving_master_uuid]>]>:
                    - narrate "<&7>Your friend <&f><player.name><&7> has gone offline." targets:<[friend]>