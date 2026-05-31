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

character_print_description:
    debug: false
    type: task
    definitions: player|target
    script:
    - define name <proc[character_get_name].context[<[target]>]>
    - define description <proc[character_get_description].context[<[target]>]>
    - narrate format:formats_prefix targets:<[player]> "<&e><[target].name> <&7>Character Info"
    - narrate targets:<[player]>  "<&7>Name<&c>: <&f><[name]>"
    - narrate targets:<[player]> "<&7>Description<&c>: <&f><[description]>"
    - narrate targets:<[player]> "<&7>Height<&c>: <proc[height_nice_format].context[<[target]>]>"