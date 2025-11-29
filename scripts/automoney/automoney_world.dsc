automoney_world:
    debug: false
    type: world
    events:
        on delta time minutely every:1:
        - foreach <server.online_players> as:player:
            - define last_payment <[player].flag[automoney_last].if_null[<time[2000/01/01_12:00:00:00]>]>
            - define time_passed <util.time_now.duration_since[<[last_payment]>]>
            - if <[time_passed].is_more_than[<duration[30m]>]>:
                - flag <[player]> automoney_last:<util.time_now>
                - money give players:<[player]> quantity:500
                - narrate format:formats_prefix targets:<[player]> "Thanks for being online! You have received ¥500."
