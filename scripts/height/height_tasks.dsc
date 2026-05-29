height_tasks_feet_to_cm:
    type: procedure
    debug: false
    definitions: height
    script:
    # IDK if theres a better way to do it into a 1 liner or less lines
    - define h:<[height].split[']>
    - if <[h].size> != 2:
        - determine null
        - stop
    - determine <[h].get[1].mul[30.48].add[<[h].get[2].mul[2.54]>]>

height_tasks_cm_to_feet:
    type: procedure
    debug: false
    definitions: height
    script:
    - define feet <[height].div[30.48].round_down>
    - define inches <[height].sub[<[feet].mul[30.48]>].div[2.54].round>
    - determine <[feet]>'<[inches]>

height_tasks_update_height:
    type: task
    debug: false
    definitions: player|height
    script:
    - flag <[player]> height:<[height]>
    # Lord forgive me for I had to use AI to figure this horribly traumatizing thing... WDYM generic_scale= bro
    - adjust <[player]> attribute_base_values:[generic_scale=<[height].div[171.4]>]
