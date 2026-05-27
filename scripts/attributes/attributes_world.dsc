# Attributes Listeners

attributes_cardio_world:
    type: world
    debug: false
    events:
        on player walks:
        - if <context.old_location.simple> == <context.new_location.simple>:
            - stop
        - if <player.has_flag[stroll_speed]>:
            - stop
        - ratelimit <player> <script[attribute_cardio_data].data_key[ratelimit]>s
        - define distance <proc[attribute_cardio_total_distance].context[<player>]>
        - if <[distance]> > <script[attribute_cardio_data].data_key[max]>:
            - adjust <player> walk_speed:0.4
        - else:
            - adjust <player> walk_speed:<element[0.2].add[<element[0.2].mul[<[distance].div[10000]>]>]>


# When someone crawls it also increases the swimming stat. Although not by much so I doubt it's problematic
attributes_swim_world:
    type: world
    debug: false
    events:
        on player walks:
        - ratelimit <player> <script[attribute_swim_data].data_key[ratelimit]>t
        - if <context.new_location.material.advanced_matches[water]>:
            - define swim_stat <proc[attribute_percent_swim_getter].context[<player>]>
            - if <[swim_stat]> >= 100:
                - cast dolphins_grace duration:1 amplifier:<script[attribute_swim_data].data_key[at_max_precent]> <player> hide_particles no_ambient no_icon
            - else if <[swim_stat]> >= 50:
                - cast dolphins_grace duration:1 amplifier:<script[attribute_swim_data].data_key[at_fifty_precent]> <player> hide_particles no_ambient no_icon


attributes_acro_world:
    type: world
    debug: false
    events:
        on player jumps:
            # Rate limit so spam jumping under a block doesn't work
            - ratelimit <player> <script[attribute_acro_data].data_key[ratelimit]>s
            - if <player.flag[attribute_jump].if_null[0]> >= <script[attribute_acro_data].data_key[max]>:
                - cast jump duration:99999 amplifier:<script[attribute_acro_data].data_key[at_max_precent]> <player>
                - stop
            - flag <player> attribute_jump:<player.flag[attribute_jump].if_null[0].add[1]>
            - if <player.flag[attribute_jump].if_null[0]> >= <script[attribute_acro_data].data_key[max].div[2]>:
                - cast jump duration:99999 amplifier:<script[attribute_acro_data].data_key[at_fifty_precent]> <player>

# When more mechanics are added that can be turned into attriutes, add them here