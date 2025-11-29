tabcomplete_world:
    debug: false
    type: world
    events:
        on player receives commands:
        - if <player.is_op>:
            - if <player.flag[tabcomplete_ignore].if_null[false]>:
                - stop
        - determine <proc[tabcomplete_fetch].context[<player>]>
