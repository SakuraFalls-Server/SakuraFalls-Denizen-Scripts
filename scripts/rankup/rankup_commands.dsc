rankup_command_playtime:
    debug: false
    type: command
    name: playtime
    description: Check your total playtime.
    usage: /playtime
    permission: rankup.command.playtime
    tab completions:
        1: <empty>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - narrate format:formats_prefix "You've played for <&a><placeholder[autorank_total_time_of_player_formatted].player[<player>]>"

rankup_command_grade:
    debug: false
    type: command
    name: grade
    description: Check to see when you'll grade up next.
    usage: /grade
    permission: rankup.command.grade
    tab completions:
        1: <empty>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <yaml.list.contains[autorank_totaltime]>:
        - yaml load:../Autorank/data/Total_time.yml id:autorank_totaltime
    - if <yaml.list.contains[autorank_paths]>:
        - yaml load:../Autorank/Paths.yml id:autorank_paths
    - define activepath <placeholder[autorank_active_paths].player[<player>].if_null[null]>
    - if <[activepath]> == null || <[activepath].length> <= 0:
        - narrate format:formats_prefix "You have completed all grades!"
        - stop
    - define timeneeded <duration[<yaml[autorank_paths].read[<[activepath]>].get[requirements].get[time].get[value]>]>
    - define timepassed <duration[<yaml[autorank_totaltime].read[<player.uuid>]>m]>
    - define difference <[timeneeded].sub[<[timepassed]>]>
    - narrate format:formats_prefix "You need <&a><[difference].formatted> <&7>more till reaching <&a><[activepath].substring[1,5].to_lowercase> <[activepath].substring[6,7]>"
