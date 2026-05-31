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
        1: <&lt>height<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> == 0:
        - narrate format:formats_prefix "Your height is: <proc[height_nice_format].context[<player>]>"
        - stop
    - define last_use <player.flag[height_last_change].if_null[<time[2000/01/01]>]>
    - if <util.time_now.duration_since[<[last_use]>].is_less_than[<duration[1s]>]>:
        - narrate "<bold>Woah!<reset><italic> Slow down..."
        - stop
    - if <proc[height_feet_to_cm].context[<context.args.get[1]>].if_null[null]> != null:
        - define h <proc[height_feet_to_cm].context[<context.args.get[1]>]>
    - else if <context.args.get[1].is_decimal>:
        - define h <context.args.get[1]>
    - else:
        - narrate "<&c>Something went wrong! Did you enter a valid height? The height should be in cm or feet."
        - stop
    - define max <script[height_data].data_key[max]>
    - define min <script[height_data].data_key[min]>
    - if <[h]> < <[min]> or <[h]> > <[max]>:
        - narrate "<&c>Please enter an allowed height<&nl>Anything from 4'5<&7> (145cm)<&c> to 6'5<&7> (195cm)<&c>!"
        - stop
    - ~run height_update_height def.player:<player> def.height:<[h]>
    - flag <player> height_last_change:<util.time_now>
    - narrate format:formats_prefix "Your new height is: <proc[height_nice_format].context[<player>]>"
