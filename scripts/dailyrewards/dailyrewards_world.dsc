dailyrewards_world:
    debug: false
    type: world
    events:
        on player joins:
        - if <player.flag[intro].if_null[null]> != done:
            - stop
        - define day <player.flag[dailyrewards_last_reward_day].if_null[0]>
        - define next_day <proc[dailyrewards_day].context[<player>]>
        - if <[day]> < <[next_day]>:
            - wait 5s
            - narrate <&f>
            - narrate format:formats_prefix "You can collect your daily reward!"
            - clickable save:command:
                - run dailyrewards_menu def.player:<player>
            - narrate <element[<&a><&l>[ DAILY REWARD ]].on_click[<entry[command].command>]>
            - narrate <&f>
