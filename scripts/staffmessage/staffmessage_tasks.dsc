staffmessage_send:
    debug: false
    type: task
    definitions: staff|target|message
    script:
        - narrate format:formats_prefix "<&c>STAFF<&8>-> <&f>YOU<&7>: <&f><[message]>" targets:<[target]>
        - narrate format:formats_prefix "<&c>YOU <&8>-> <&f><[target].name><&7>: <&f><[message]>" targets:<[staff]>
        - flag <[target]> staffmessage_reply:<[staff].uuid>

staffmessage_looc:
    debug: false
    type: task
    definitions: staff|message
    script:
        - define targets <[staff].location.find_players_within[15]>
        - foreach <[targets]> as:target:
            - narrate "<&8>[<&7>LOOC<&8>] <&c>STAFF: <&7><[message]>" targets:<[target]>

staffmessage_ooc:
    debug: false
    type: task
    definitions: staff|message
    script:
        - foreach <server.online_players> as:target:
            - narrate "<&8>[<&7><&l>OOC<&8>] <&c>STAFF: <&7><&l><[message]>" targets:<[target]>

staffmessage_reply:
    debug: false
    type: task
    definitions: player|message
    script:
        - if !<[player].has_flag[staffmessage_reply]>:
            - narrate format:formats_prefix "<&c>You have no staff message to reply to."
            - stop
        - define staff <player[<[player].flag[staffmessage_reply]>].if_null[null]>
        - if <[staff]> == null:
            - flag <[player]> staffmessage_reply:!
            - narrate format:formats_prefix "<&c>The staff member who contacted you could not be found."
            - stop
        - if !<[staff].is_online>:
            - flag <[player]> staffmessage_reply:!
            - narrate format:formats_prefix "<&c>The staff member who contacted you is not online."
            - stop
        - narrate format:formats_prefix "<&f><[player].name> <&8>-> <&c>YOU<&7>: <&f><[message]>" targets:<[staff]>
        - narrate format:formats_prefix "<&f>YOU <&8>-> <&c>STAFF<&7>: <&f><[message]>" targets:<[player]>
        - flag <[staff]> staffmessage_reply:<[player].uuid>
        - flag <[player]> staffmessage_reply:<[staff].uuid>