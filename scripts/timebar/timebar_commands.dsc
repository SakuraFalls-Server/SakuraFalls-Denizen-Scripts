timebar_commands_add_time:
    debug: false
    type: command
    name: add_time
    usage: /add_time [time]
    permissions: timebar.add_time
    script:
    - define time <server.flag[timebar_time].if_null[<util.time_now>]>
    - define input_time <context.args.get[1]>
    - if !<[input_time]>.is_integer:
        - narrate "<&c>The time must be an integer between 0 and 24000."
        - stop
    - else:
        - define time <[time].add[<[input_time]>]>
        - flag server timebar_time:<[time]>
        - run timebar_sync_sun