guns_unfreeze:
    debug: false
    definitions: player
    type: task
    script:
    - waituntil max:10s <[player].is_online.not.or[<[player].has_flag[guns_frozen].not>]>
    - if !<[player].has_flag[guns_frozen]>:
        - stop
    - animate <[player]> animation:stop_sitting
    - flag <[player]> guns_frozen:!
