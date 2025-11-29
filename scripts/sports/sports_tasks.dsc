sports_arena_register:
    debug: false
    type: task
    definitions: id|cuboid|max_per_team|ball_display|ball_size|ball_gravity|on_join_task|on_leave_task|on_redistribute_task|default_status|extra_data
    script:
    - definemap arena:
        id: <[id]>
        cuboid: <[cuboid]>
        max_per_team: <[max_per_team]>
        ball_display: <[ball_display]>
        ball_size: <[ball_size]>
        ball_gravity: <[ball_gravity]>
        on_join_task: <[on_join_task]>
        on_leave_task: <[on_leave_task]>
        on_redistribute_task: <[on_redistribute_task]>
        default_status: <[default_status]>
        extra_data: <[extra_data]>
    - flag server sports_arenas:<server.flag[sports_arenas].if_null[<map[]>].with[<[id]>].as[<[arena]>]>
    - flag server sports_status:<server.flag[sports_status].if_null[<map[]>].with[<[id]>].as[<[default_status]>]>

sports_arena_update_property:
    debug: false
    type: task
    definitions: id|property|new_value
    script:
    - define arena <server.flag[sports_arenas].if_null[<map[]>].get[<[id]>]>
    - if !<[arena].keys.contains[<[property]>]>:
        - narrate "<&c> Could not update arena property: <[property]> is an inexistent property."
        - stop
    - define arena <[arena].with[<[property]>].as[<[new_value]>]>
    - flag server sports_arenas:<server.flag[sports_arenas].if_null[<map[]>].with[<[id]>].as[<[arena]>]>

sports_arena_exists:
    debug: false
    type: procedure
    definitions: id
    script:
    - determine <server.flag[sports_arenas].contains[<[id]>].if_null[false]>

sports_arena_cleanup:
    debug: false
    type: task
    definitions: id
    script:
    - define on_leave_task <server.flag[sports_arenas].get[<[id]>].get[on_leave_task]>
    - foreach <server.flag[sports_teams].get[<[id]>].get[red].if_null[<list[]>]> as:player:
        - run <[on_leave_task]> def.id:<[id]> def.player:<[player]>
    - foreach <server.flag[sports_teams].get[<[id]>].get[blue].if_null[<list[]>]> as:player:
        - run <[on_leave_task]> def.id:<[id]> def.player:<[player]>
    - flag server sports_teams:<server.flag[sports_teams].if_null[<map[]>].exclude[<[id]>]>
    - define default_status <server.flag[sports_arenas].get[<[id]>].get[default_status]>
    - flag server sports_status:<server.flag[sports_status].if_null[<map[]>].with[<[id]>].as[<[default_status]>]>

sports_arena_unregister:
    debug: false
    type: task
    definitions: id
    script:
    - run sports_arena_cleanup def.id:<[id]>
    - flag server sports_arenas:<server.flag[sports_arenas].if_null[<map[]>].exclude[<[id]>]>
    - flag server sports_status:<server.flag[sports_status].if_null[<map[]>].exclude[<[id]>]>

sports_arena:
    debug: false
    type: procedure
    definitions: id
    script:
    - determine <server.flag[sports_arenas].if_null[<map[]>].get[<[id]>]>

sports_arena_can_join:
    debug: false
    type: procedure
    definitions: id|team
    script:
    - define max_per_team <server.flag[sports_arenas].get[<[id]>].get[max_per_team]>
    - define teams <server.flag[sports_teams].get[<[id]>].if_null[<map[].with[red].as[<list[]>].with[blue].as[<list[]>]>]>
    - define red <[teams].get[red]>
    - define blue <[teams].get[blue]>
    - if <[red].size> >= <[max_per_team]> && <[blue].size> >= <[max_per_team]>:
        - determine false
    - else if <[red].size> >= <[max_per_team]>:
        - determine blue
    - else if <[blue].size> >= <[max_per_team]>:
        - determine red
    - determine any

sports_arena_player_count:
    debug: false
    type: procedure
    definitions: id
    script:
    - define teams <server.flag[sports_teams].get[<[id]>].if_null[<map[].with[red].as[<list[]>].with[blue].as[<list[]>]>]>
    - define red <[teams].get[red]>
    - define blue <[teams].get[blue]>
    - determine <[red].size.add[<[blue].size>]>

sports_arena_teams:
    debug: false
    type: procedure
    definitions: id
    script:
    - define teams <server.flag[sports_teams].get[<[id]>].if_null[<map[].with[red].as[<list[]>].with[blue].as[<list[]>]>]>
    - define red <[teams].get[red]>
    - define blue <[teams].get[blue]>
    - determine <map[].with[red].as[<[red]>].with[blue].as[<[blue]>]>

# team is "red" or "blue"
sports_arena_join:
    debug: false
    type: task
    definitions: id|player|team
    script:
    - define teams <server.flag[sports_teams].get[<[id]>].if_null[<map[].with[red].as[<list[]>].with[blue].as[<list[]>]>]>
    - define teams <[teams].with[<[team]>].as[<[teams].get[<[team]>].include[<[player]>].deduplicate>]>
    - flag <[player]> sports:<map[].with[id].as[<[id]>].with[team].as[<[team]>]>
    - flag server sports_teams:<server.flag[sports_teams].if_null[<map[]>].with[<[id]>].as[<[teams]>]>
    - define on_join_task <server.flag[sports_arenas].get[<[id]>].get[on_join_task]>
    - run <[on_join_task]> def.id:<[id]> def.player:<[player]> def.team:<[team]>

sports_arena_join_auto:
    debug: false
    type: task
    definitions: id|player
    script:
    - define teams <server.flag[sports_teams].get[<[id]>].if_null[<map[].with[red].as[<list[]>].with[blue].as[<list[]>]>]>
    - define red <[teams].get[red]>
    - define blue <[teams].get[blue]>
    - define on_join_task <server.flag[sports_arenas].get[<[id]>].get[on_join_task]>
    - if <[red].size> < <[blue].size>:
        - define teams <[teams].with[red].as[<[red].include[<[player]>].deduplicate>]>
        - flag <[player]> sports:<map[].with[id].as[<[id]>].with[team].as[red]>
        - flag server sports_teams:<server.flag[sports_teams].if_null[<map[]>].with[<[id]>].as[<[teams]>]>
        - run <[on_join_task]> def.id:<[id]> def.player:<[player]> def.team:red
    - else:
        - define teams <[teams].with[blue].as[<[blue].include[<[player]>].deduplicate>]>
        - flag <[player]> sports:<map[].with[id].as[<[id]>].with[team].as[blue]>
        - flag server sports_teams:<server.flag[sports_teams].if_null[<map[]>].with[<[id]>].as[<[teams]>]>
        - run <[on_join_task]> def.id:<[id]> def.player:<[player]> def.team:blue

sports_arena_leave:
    debug: false
    type: task
    definitions: id|player
    script:
    - define teams <server.flag[sports_teams].get[<[id]>].if_null[<map[].with[red].as[<list[]>].with[blue].as[<list[]>]>]>
    - define teams <[teams].with[red].as[<[teams].get[red].exclude[<[player]>]>]>
    - define teams <[teams].with[blue].as[<[teams].get[blue].exclude[<[player]>]>]>
    - flag <[player]> sports:!
    - flag server sports_teams:<server.flag[sports_teams].if_null[<map[]>].with[<[id]>].as[<[teams]>]>
    - define on_leave_task <server.flag[sports_arenas].get[<[id]>].get[on_leave_task]>
    - run <[on_leave_task]> def.id:<[id]> def.player:<[player]>

sports_arena_redistribute:
    debug: false
    type: task
    definitions: id
    script:
    - define teams <server.flag[sports_teams].get[<[id]>].if_null[<map[].with[red].as[<list[]>].with[blue].as[<list[]>]>]>
    - define red <[teams].get[red]>
    - define blue <[teams].get[blue]>
    - if <[red].size.sub[1]> > <[blue].size>:
        - define random <[red].random>
        - define teams <[teams].with[red].as[<[red].exclude[<[random]>].deduplicate>]>
        - define teams <[teams].with[blue].as[<[blue].include[<[random]>].deduplicate>]>
        - flag <[random]> sports:<map[].with[id].as[<[id]>].with[team].as[red]>
        - flag server sports_teams:<server.flag[sports_teams].if_null[<map[]>].with[<[id]>].as[<[teams]>]>
        - define on_redistribute_task <server.flag[sports_arenas].get[<[id]>].get[on_redistribute_task]>
        - run <[on_redistribute_task]> def.id:<[id]> def.player:<[random]> def.from:red def.to:blue
        - determine red
    - if <[blue].size.sub[1]> > <[red].size>:
        - define random <[blue].random>
        - define teams <[teams].with[blue].as[<[blue].exclude[<[random]>].deduplicate>]>
        - define teams <[teams].with[red].as[<[red].include[<[random]>].deduplicate>]>
        - flag <[random]> sports:<map[].with[id].as[<[id]>].with[team].as[blue]>
        - flag server sports_teams:<server.flag[sports_teams].if_null[<map[]>].with[<[id]>].as[<[teams]>]>
        - define on_redistribute_task <server.flag[sports_arenas].get[<[id]>].get[on_redistribute_task]>
        - run <[on_redistribute_task]> def.id:<[id]> def.player:<[random]> def.from:blue def.to:red
        - determine blue
    - determine none

sports_arena_set_status:
    debug: false
    type: task
    definitions: id|status
    script:
    - flag server sports_status:<server.flag[sports_status].if_null[<map[]>].with[<[id]>].as[<[status]>]>

sports_arena_get_status:
    debug: false
    type: procedure
    definitions: id
    script:
    - determine <server.flag[sports_status].if_null[<map[]>].get[<[id]>]>

sports_arena_enter_arena_prompt:
    debug: false
    type: task
    definitions: id|player
    script:
    - ratelimit <[player]> 2s
    - clickable save:join_arena usages:1 until:30s:
        - if <[player].has_flag[sports]>:
            - stop
        - run sports_arena_join_auto def.id:<[id]> def.player:<[player]>
    - narrate targets:<[player]> format:formats_prefix "Join this game? <element[<&a><&l>[YES]].on_click[<entry[join_arena].command>]>"

sports_arena_exit_arena_prompt:
    debug: false
    type: task
    definitions: id|player
    script:
    - ratelimit <[player]> 2s
    - clickable save:leave_arena usages:1 until:30s:
        - if !<[player].has_flag[sports]>:
            - stop
        - run sports_arena_leave def.id:<[id]> def.player:<[player]>
    - narrate targets:<[player]> format:formats_prefix "Leave this game? <element[<&a><&l>[YES]].on_click[<entry[leave_arena].command>]>"
