dailyrewards_day:
    debug: false
    type: procedure
    definitions: player
    script:
    - define last_reward_day <[player].flag[dailyrewards_last_reward_day].if_null[0]>
    - define last_reward_time <[player].flag[dailyrewards_last_reward_time].if_null[<time[2000/01/01]>]>
    - define diff <util.time_now.duration_since[<[last_reward_time]>]>
    - if <[diff].is_less_than[<duration[16h]>]>:
        - determine <[last_reward_day]>
    - else if <[diff].is_more_than[<duration[32h]>]>:
        - determine 1
    - else:
        - determine <[last_reward_day].add[1]>

dailyrewards_menu:
    debug: false
    type: task
    definitions: player
    script:
    - define day <[player].flag[dailyrewards_last_reward_day].if_null[0]>
    - define time <[player].flag[dailyrewards_last_reward_time].if_null[<time[2000/01/01]>]>
    - define next_day <proc[dailyrewards_day].context[<[player]>]>
    - define remaining <element[7].sub[<[next_day]>]>
    - define config <script[dailyrewards_config].data_key[rewards]>
    - define contents <map[]>
    - repeat <[day]>:
        - define collected_item <item[gold_block[display=<&e>Reward Collected;lore=<&7>Day <[value]>|<&f>|<&7>Reward was collected already!]]>
        - define contents <[contents].with[<[value].add[1]>].as[<map[].with[item].as[<[collected_item]>]>]>
    - if <[next_day]> > <[day]> || <util.time_now.duration_since[<[time]>].is_more_than[<duration[32h]>]>:
        - define reward_value <[config].get[<[next_day]>]>
        - define reward_item <item[emerald_block[display=<&a>Reward Available!;lore=<&7>Day <[next_day]>|<&f>|<&f>Click to collect <&6>¥<[reward_value]>]]>
        - define contents <[contents].with[<[next_day].add[1]>].as[<map[].with[item].as[<[reward_item]>].with[script].as[dailyrewards_collect_reward].with[definitions].as[<map[].with[player].as[<[player]>].with[day].as[<[next_day]>]>]>]>
    - repeat <[remaining]> from:<[next_day].add[1]>:
        - define later_value <[config].get[<[value]>]>
        - define later_item <item[light_gray_wool[display=<&7>Not available yet!;lore=<&7>Day <[value]>|<&f>|<&f>Continue the streak for <&6>¥<[later_value]>]]>
        - define contents <[contents].with[<[value].add[1]>].as[<map[].with[item].as[<[later_item]>]>]>
    - run menu_open def.player:<[player]> def.title:<&f>邑邑邑邑酐<&a><&sp><&b><&sp><&d><&sp> def.size:9 def.contents:<[contents]>

dailyrewards_collect_reward:
    debug: false
    type: task
    definitions: player|day
    script:
    - define config <script[dailyrewards_config].data_key[rewards]>
    - money give players:<[player]> quantity:<[config].get[<[day]>]>
    - if <[day]> < 7:
        - flag <[player]> dailyrewards_last_reward_day:<[day]>
        - flag <[player]> dailyrewards_last_reward_time:<util.time_now>
    - else:
        - flag <[player]> dailyrewards_last_reward_day:!
        - flag <[player]> dailyrewards_last_reward_time:<util.time_now>
    - adjust server save
    - narrate format:formats_prefix "Collected day <[day]> reward! Come again tomorrow for the next reward!"
    - run dailyrewards_menu def.player:<[player]>
