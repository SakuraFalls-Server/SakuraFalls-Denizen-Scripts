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
