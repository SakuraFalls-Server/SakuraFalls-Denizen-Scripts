height_commands_height:
    debug: false
    type: command
    name: height
    usage: /height
    aliases:
    - Height
    description: Changes the player's height
    permission: height.command.height
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define last_use <player.flag[height_last_change].if_null[<time[2000/01/01]>]>
    - if <util.time_now.duration_since[<[last_use]>].is_less_than[<duration[1s]>]>:
        - narrate "<bold>Woah!<reset><italic> Slow down..."
        - stop
    - flag <player> height_last_change:<util.time_now>
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter the desired height<&nl>Anything from 4'5<&7> (145cm)<&c> to 6'5<&7> (195cm)<&c>!"
        - stop
    # Checking if the number is on ft (contains ') or cm (decimal)
    - if <proc[height_tasks_feet_to_cm].context[<context.args.get[1]>].if_null[false]>:
        - define h <proc[height_tasks_feet_to_cm].context[<context.args.get[1]>]>
    - else if <context.args.get[1].is_decimal>:
        - define h <context.args.get[1]>
    - else:
        - narrate "<&c>Something went wrong! Did you enter the right number?"
        - stop
    - define max <script[height_data].data_key[max]>
    - define min <script[height_data].data_key[min]>
    - if <[h]> < <[min]> or <[h]> > <[max]>:
        - narrate "<&c>Please enter an allowed height<&nl>Anything from 4'5<&7> (145cm)<&c> to 6'5<&7> (195cm)<&c>!"
        - stop
    # After all the annoying checks are done, finally change height :D Wait till the update runs fully before narrating
    - ~run height_tasks_update_height def.player:<player> def.height:<[h]>
    - narrate format:formats_prefix "Your new height is: <&e><player.flag[height]>cm <&7>/ <&e><proc[height_tasks_cm_to_feet].context[<player.flag[height]>]>!"



height_commands_height_display:
    debug: false
    type: command
    name: heightDisplay
    usage: /heightDisplay
    aliases:
    - heightdisplay
    - disheight
    description: Displays player's height.
    permission: height.command.height_display
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define last_use <player.flag[height_dis_last_change].if_null[<time[2000/01/01]>]>
    - if <util.time_now.duration_since[<[last_use]>].is_less_than[<duration[1s]>]>:
        - narrate "<&7><bold>Woah!<reset><&7><italic> Slow down..."
        - stop
    - flag <player> height_dis_last_change:<util.time_now>
    - narrate format:formats_prefix "Your height is: <&e><player.flag[height]>cm <&7>/ <&e><proc[height_tasks_cm_to_feet].context[<player.flag[height]>]>"