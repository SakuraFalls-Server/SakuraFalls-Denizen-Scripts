timebar_commands_add_time:
    debug: true
    type: command
    description: Adds time to the current timebar time.
    name: addtime
    usage: /addtime [time]
    permissions: timebar.command.addtime
    script:
        - define input_time <context.args.get[1]>
        - if <duration[<[input_time]>].if_null[null]> != null:
            - define time <server.flag[timebar_time].if_null[<util.time_now>]>
            - define time <[time].add[<[input_time]>]>
            - flag server timebar_time:<[time]>
            - run timebar_sync_sun
        - else:
            - narrate "<&c>Invalid time format. Please use a valid time format (e.g., 10s, 5m, 2h)."
