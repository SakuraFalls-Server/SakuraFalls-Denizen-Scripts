# Atrributes Listener

attributes_cardio_world:
    type: world
    debug: false
    events:
        on player walks:
        - if <context.old_location.simple> == <context.new_location.simple>:
            - stop
        - ratelimit <player> <script[attribute_cardio_data].data_key[ratelimit]>s
        - define distance <proc[attribute_cardio_total_distance].context[<player>]>
        - if <[distance]> > <script[attribute_cardio_data].data_key[max]>:
            - stop
        - adjust <player> walk_speed:<element[0.2].add[<element[0.2].mul[<[distance].div[10000]>]>]>


# When someone crawls it also increases the swimming stat. Although not by much so I doubt it's problematic
attributes_swim_world:
    type: world
    debug: false
    events:
        on player walks:
        - if <context.new_location.material.advanced_matches[water]>:
            - define swim_stat <player.statistic[swim_one_cm].div[100]>
            - if <[swim_stat]> >= <script[attribute_swim_data].data_key[max]>:
                - cast dolphins_grace duration:1 amplifier:<script[attribute_swim_data].data_key[at_max_precent]> <player>
            - else if <[swim_stat]> >= <script[attribute_swim_data].data_key[max].div[2]>:
                - cast dolphins_grace duration:1 amplifier:<script[attribute_swim_data].data_key[at_fifty_precent]> <player>


attributes_acro_world:
    type: world
    debug: false
    events:
        on player jumps:
            - ratelimit <player> <script[attribute_acro_data].data_key[ratelimit]>s
            - if !<player.has_flag[attribute_jump]>:
                - flag <player> attribute_jump
            # limiting to 10000 just to make it easier for the attribute_precent_acro_getter (we are not going over 100%)
            - if <player.flag[attribute_jump]> < <script[attribute_acro_data].data_key[max]>:
                - flag <player> attribute_jump:+:1
            - if <player.flag[attribute_jump]> >= <script[attribute_acro_data].data_key[max]>:
                - cast jump duration:99999 amplifier:<script[attribute_swim_data].data_key[at_max_precent]> <player>
            - else if <player.flag[attribute_jump]> >= <script[attribute_acro_data].data_key[max].div[2]>:
                - cast jump duration:99999 amplifier:<script[attribute_swim_data].data_key[at_fifty_precent]> <player>

# WHEN THE OTHER SKILLS (COOKING, FISHING, ENDURANCE, AND MORE IF IT GETS SUGGESTED) GET THEIR MECHANICS IMPLEMENTED, THEN TURN THEM INTO ATTRIBUTES