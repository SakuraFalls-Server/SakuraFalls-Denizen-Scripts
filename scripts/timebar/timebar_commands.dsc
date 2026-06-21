timebar_commands_add_time:
    debug: false
    type: command
    name: addtime
    usage: /addtime [time]
    permissions: timebar.command.addtime
    script:
    - define time <server.flag[timebar_time].if_null[<util.time_now>]>
    - define input_time <context.args.get[1]>
    - define time <[time].add[<[input_time]>]>
    - flag server timebar_time:<[time]>
    - run timebar_sync_sun
