announcers_command_intercom:
    debug: false
    type: command
    name: intercom
    description: Broadcast a message through the intercom.
    usage: /intercom (message)
    permission: announcers.command.intercom
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a message!"
        - stop
    - define message <context.args.space_separated>
    - announce "<&6>[<&c><&l>INTERCOM<&6>] <&7><&o>(<player.name>) <&f><proc[character_get_name].context[<player>]> says <&dq><[message]><&dq>"

announcers_command_collegeintercom:
    debug: false
    type: command
    name: collegeintercom
    description: Broadcast a message through the college intercom.
    usage: /collegeintercom (message)
    permission: announcers.command.collegeintercom
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a message!"
        - stop
    - define message <context.args.space_separated>
    - define recipients <server.online_players.filter_tag[<[filter_value].has_permission[announcers.see.collegeintercom]>]>
    - narrate targets:<[recipients]> "<&6>[<&c><&l>COLLEGE INTERCOM<&6>] <&7><&o>(<player.name>) <&f><proc[character_get_name].context[<player>]> says <&dq><[message]><&dq>"

announcers_command_advert:
    debug: false
    type: command
    name: advert
    description: Broadcast a message for your shop.
    usage: /advert (message)
    permission: announcers.command.advert
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a message!"
        - stop
    - define message <context.args.space_separated>
    - announce "<&6>[<&2>Advert<&6>]<&f>: <&7><&o>(<player.name>) <&f><proc[character_get_name].context[<player>]> - <[message]>"

announcers_command_news:
    debug: false
    type: command
    name: news
    description: Broadcast a message for the news.
    usage: /news (message)
    permission: announcers.command.news
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define last_use <player.flag[announcers_news].if_null[<time[2000/01/01]>]>
    - if <util.time_now.duration_since[<[last_use]>].is_less_than[<duration[60s]>]>:
        - narrate "<bold>Woah!<reset><italic> Slow down... You have to wait <duration[60s].sub[<util.time_now.duration_since[<[last_use]>]>].in_seconds> more seconds."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a message!"
        - stop
    - flag <player> announcers_news:<util.time_now>
    - define message <context.args.space_separated>
    - announce "<&6>[<&d>News Report<&6>]<&f>: <&7><&o>(<player.name>) <&f><proc[character_get_name].context[<player>]> - <[message]>"
