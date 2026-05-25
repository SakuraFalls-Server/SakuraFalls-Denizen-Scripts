# Attributes scripts

attribute_cardio_total_distance:
    type: procedure
    debug: false
    definitions: player
    script:
    - determine <player.statistic[walk_one_cm].add[<player.statistic[sprint_one_cm]>].div[100]>

attribute_precent_cardio_getter:
    type: procedure
    debug: false
    definitions: player
    script:
    - define distance <proc[attribute_cardio_total_distance].context[<player>].div[<script[attribute_cardio_data].data_key[max]>].mul[100]>
    - if <[distance]> > 100:
        - determine 100
    - determine <[distance]>

attribute_precent_acro_getter:
    type: procedure
    debug: false
    definitions: player
    script:
    - if <player.has_flag[attribute_jump]>:
        - define jumps <player.flag[attribute_jump]>
        - determine <[jumps].div[<script[attribute_acro_data].data_key[max]>].mul[100]>

attribute_precent_swim_getter:
    type: procedure
    debug: false
    definitions: player
    script:
    - define distance <player.statistic[swim_one_cm].div[<script[attribute_swim_data].data_key[max]>].mul[100]>
    - if <[distance]> > 100:
        - determine 100
    - determine <[distance]>