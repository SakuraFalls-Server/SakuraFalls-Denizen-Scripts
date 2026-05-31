height_feet_to_cm:
    type: procedure
    debug: false
    definitions: height
    script:
    - define h <[height].split[']>
    - if <[h].size> != 2:
        - determine null
    - determine <[h].get[1].mul[30.48].add[<[h].get[2].mul[2.54]>]>

height_cm_to_feet:
    type: procedure
    debug: false
    definitions: height
    script:
    - define feet <[height].div[30.48].round_down>
    - define inches <[height].sub[<[feet].mul[30.48]>].div[2.54].round>
    - determine <[feet]>'<[inches]>

height_update_height:
    type: task
    debug: false
    definitions: player|height
    script:
    - define multiplier <script[height_data].data_key[multiplier]>
    - flag <[player]> height:<[height]>
    - adjust <[player]> attribute_base_values:<map[].with[generic_scale].as[<[height].div[171.4]>]>
    - adjust server save

height_nice_format:
    debug: false
    type: procedure
    definitions: player
    script:
    - determine "<&e><[player].flag[height].if_null[171.4]>cm <&7>/ <&e><proc[height_cm_to_feet].context[<[player].flag[height].if_null[171.4]>]>"
