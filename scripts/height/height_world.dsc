height_world:
    debug: false
    type: world
    events:
        after player joins:
        - define max_height <script[height_data].data_key[max]>
        - define min_height <script[height_data].data_key[min]>
        - define player_height <player.attribute_base_value[generic_scale].mul[171.4].add[10]>
        - if <[player_height]> < <[min_height]>:
            - run height_update_height def.player:<player> def.height:<[min_height]>
        - else if <[player_height]> > <[max_height]>:
            - run height_update_height def.player:<player> def.height:<[max_height]>
