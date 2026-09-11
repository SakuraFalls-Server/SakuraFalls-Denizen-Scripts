staffmessage_send:
    debug: false
    type: task
    definitions: staff|target|message
    script:
        - define message <[message].replace[&\].with[&].unescaped>
        - define target_name <[target].name>
        - define player_message "<&7>Staff -> You<&f>: <[message]>"
        - define staff_message "<&7>You -> <[target_name]><&f>: <[message]>"

        - narrate format:formats_prefix <[player_message]> targets:<[target]>
        - narrate format:formats_prefix <[staff_message]> targets:<[staff]>

        - flag <[target]> staffmessage_last_staff:<[staff]>


staffmessage_looc:
    debug: false
    type: task
    definitions: staff|message
    script:
        - define message <[message].strip_color.replace[&\].with[&].unescaped>
        - define final "<&8>[<&7>LOOC<&8>] <&c>STAFF: <&7><[message]>"
        - define targets <[staff].location.find_players_within[15]>
        - narrate targets:<[targets]> <[final]>

staffmessage_ooc:
    debug: false
    type: task
    definitions: staff|message
    script:
        - define message <[message].replace[&\].with[&].unescaped>
        - define final "<&8>[<&7><&l>OOC<&8>] <&c>STAFF: <&7><&l><[message]>"
        - foreach <server.list_online_players> as:target:
            - narrate <[final]> targets:<[target]>


staffmessage_reply:
    debug: false
    type: task
    definitions: player|staff|message
    script:
        - define message <[message].replace[&\].with[&].unescaped>
        - define player_message "<&7>You -> Staff<&f>: <[message]>"
        - define staff_message "<&7><[player].name> -> You<&f>: <[message]>"
        - narrate format:formats_prefix <[player_message]> targets:<[player]>
        - narrate format:formats_prefix <[staff_message]> targets:<[staff]>
        - flag <[staff]> staffmessage_last_staff:<[player]>