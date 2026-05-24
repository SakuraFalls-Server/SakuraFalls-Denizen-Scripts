character_get_name:
    debug: false
    type: procedure
    definitions: player
    script:
    - determine <[player].flag[character_rpname].if_null[<[player].name>]>

character_get_description:
    debug: false
    type: procedure
    definitions: player
    script:
    - determine <[player].flag[character_description].if_null[No<&sp>description<&sp>set.]>

character_resync_all_names:
    debug: false
    type: task
    script:
    - define names <map[]>
    - foreach <server.players> as:player:
        - define name <[player].flag[character_rpname].if_null[null]>
        - if <[name]> != null:
            - define names <[names].with[<[name]>].as[<[player]>]>
    - flag server character_rpnames:<[names]>
    - adjust server save
