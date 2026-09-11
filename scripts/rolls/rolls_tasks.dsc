roll_task:
    type: task
    definitions: player|amount|distance
    script:
    - define roll <util.random.int[1].to[<[amount]>]>
    - define final "<&f><placeholder[essentials_nickname].player[<player>]> <proc[chat_special_group].context[<player>]><proc[chat_roles_group].context[<player>]> <proc[character_get_name].context[<player>]> <&6>rolls <&f><[roll]> <&6>out of <&f><[amount]>"
    - narrate targets:<player.location.find_players_within[<[distance]>]> <[final]>
    - announce to_console <[final]>