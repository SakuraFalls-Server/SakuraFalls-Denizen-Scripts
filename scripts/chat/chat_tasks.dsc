chat_name_ooc:
    debug: false
    type: procedure
    definitions: player
    script:
    - determine <placeholder[luckperms_prefix_element_highest_on_track_color].player[<[player]>].if_null[<&7>].parse_color><[player].name>

chat_special_group:
    debug: false
    type: procedure
    definitions: player
    script:
    - define result <placeholder[luckperms_prefix_element_highest_on_track_special].player[<[player]>].if_null[<&f>].parse_color>
    - if <[result].strip_color.length> > 0:
        - define result <[result]><&sp>
    - determine <[result]>

chat_roles_group:
    debug: false
    type: procedure
    definitions: player
    script:
    - determine <placeholder[luckperms_prefix_element_highest_on_track_roles].player[<[player]>].if_null[<&f>].parse_color><&f>

chat_channel_ooc:
    debug: false
    type: task
    definitions: player|message
    script:
    - define message <[message].strip_color.replace[&\].with[&].unescaped>
    - define final "<&8>[<&7><&l>OOC<&8>] <proc[chat_special_group].context[<[player]>]><proc[chat_name_ooc].context[<[player]>]><&7>: <&l><[message]>"
    - define targets <server.online_players.filter_tag[<[filter_value].has_flag[chat_disableooc].not>]>
    - narrate targets:<[targets]> <[final]>
    - announce to_console <[final]>

chat_channel_looc:
    debug: false
    type: task
    definitions: player|message
    script:
    - define message <[message].strip_color.replace[&\].with[&].unescaped>
    - define final "<&8>[<&7>LOOC<&8>] <proc[chat_special_group].context[<[player]>]><&7><proc[character_get_name].context[<[player]>]> <proc[chat_name_ooc].context[<[player]>]><&7>: <[message]>"
    - define targets <[player].location.find_players_within[10]>
    - narrate targets:<[targets]> <[final]>
    - announce to_console <[final]>

chat_allowed_colors:
    debug: false
    type: procedure
    script:
    - determine <util.color_names.exclude[black].exclude[transparent].exclude[white]>

chat_tokenize_actions:
    debug: false
    type: procedure
    definitions: message|initializer|actioncolor|speechcolor|separator|forcecaps
    script:
    - define result <empty>
    - define index 1
    - if <[message].starts_with[*]>:
        - define index 2
    - else:
        - define result <[actioncolor]><[initializer]>
    - foreach <[message].split[*]> as:token:
        - if <[token].trim.parse_color.strip_color.length> <= 0:
            - foreach next
        - if <[index].is_odd>:
            - if <[forcecaps]>:
                - define token <[token].replace[&\].with[&].unescaped.to_uppercase>
            - define result "<[result]> <[separator]><[speechcolor]><[token].trim><[separator]>"
        - else:
            - define result "<[result]> <[actioncolor]><[token].trim>"
        - define index <[index].add[1]>
    - determine <[result].trim>

chat_channel_check_targets:
    debug: false
    type: task
    script:
    - if <[targets].size> <= 1:
        - if <proc[settings_get].context[<[player]>|text_rp_chat_distance_warning]>:
            - narrate "<&6>* <&7><&o>It seemed like nobody could hear you." targets:<[player]>

chat_channel_check_targets_language:
    debug: false
    type: task
    script:
    - if <[all].size> <= 1:
        - if <proc[settings_get].context[<[player]>|text_rp_chat_distance_warning]>:
            - narrate "<&6>* <&7><&o>It seemed like nobody could hear you." targets:<[player]>

chat_accessibility_space_message_inject_define:
    debug: false
    type: task
    script:
    - define space_targets <[targets].filter_tag[<proc[settings_get].context[<[filter_value]>|accessibility_rp_chat_space_messages]>]>

chat_accessibility_space_message_inject_define_language:
    debug: false
    type: task
    script:
    - define space_targets <[all].filter_tag[<proc[settings_get].context[<[filter_value]>|accessibility_rp_chat_space_messages]>]>

chat_accessibility_space_message_inject_apply:
    debug: false
    type: task
    script:
    - narrate targets:<[space_targets]> <&f>

chat_channel_ic:
    debug: false
    type: task
    definitions: player|message
    script:
    - if <[message].starts_with[*]> && <[message].split[*].size> == 2:
        - if <[message].ends_with[*]>:
            - run chat_channel_ic_me def.player:<[player]> def.message:<[message].substring[2,<[message].length.sub[1]>]>
        - else:
            - run chat_channel_ic_me def.player:<[player]> def.message:<[message].substring[2,<[message].length>]>
        - stop
    - if !<[player].has_permission[chat.colors]>:
        - define message <[message].strip_color>
    - define tokenized <proc[chat_tokenize_actions].context[<[message]>|<element[&<color[<proc[settings_get].context[<[player]>|text_rp_chat_color]>].hex>].parse_color>says<&7>:|<element[&<color[<proc[settings_get].context[<[player]>|text_rp_chat_color]>].hex>].parse_color>|<&f>|<&f><&dq><&f>|false].replace[&\].with[&].unescaped>
    - define final "<&color[#b8b9ba]><placeholder[essentials_nickname].player[<[player]>]> <&f><proc[chat_special_group].context[<[player]>]><proc[chat_roles_group].context[<[player]>]> <proc[character_get_name].context[<[player]>]> <[tokenized]>"
    - define targets <[player].location.find_players_within[10]>
    - inject chat_accessibility_space_message_inject_define
    - inject chat_accessibility_space_message_inject_apply
    - inject chat_channel_check_targets
    - narrate targets:<[targets]> <[final]>
    - inject chat_accessibility_space_message_inject_apply
    - announce to_console <[final]>

chat_channel_ic_me:
    debug: false
    type: task
    definitions: player|message
    script:
    - define message <[message].replace[&\].with[&].unescaped>
    - if !<[player].has_permission[chat.colors]>:
        - define message <[message].strip_color>
    - define final "<&e>*** <&f><placeholder[essentials_nickname].player[<[player]>]> <proc[chat_special_group].context[<[player]>]><proc[chat_roles_group].context[<[player]>]> <proc[character_get_name].context[<[player]>]> <element[&<color[<proc[settings_get].context[<[player]>|text_rp_chat_color]>].hex>].parse_color><&o><[message]>"
    - define targets <[player].location.find_players_within[10]>
    - inject chat_accessibility_space_message_inject_define
    - inject chat_accessibility_space_message_inject_apply
    - inject chat_channel_check_targets
    - narrate targets:<[targets]> <[final]>
    - inject chat_accessibility_space_message_inject_apply
    - announce to_console <[final]>

chat_channel_ic_mec:
    debug: false
    type: task
    definitions: player|message
    script:
    - define message <[message].replace[&\].with[&].unescaped>
    - if !<[player].has_permission[chat.colors]>:
        - define message <[message].strip_color>
    - define final "<&e>* <&f><placeholder[essentials_nickname].player[<[player]>]> <proc[chat_special_group].context[<[player]>]><proc[chat_roles_group].context[<[player]>]> <proc[character_get_name].context[<[player]>]> <element[&<color[<proc[settings_get].context[<[player]>|text_rp_chat_color]>].hex>].parse_color><&o><[message]>"
    - define targets <[player].location.find_players_within[3]>
    - inject chat_accessibility_space_message_inject_define
    - inject chat_accessibility_space_message_inject_apply
    - inject chat_channel_check_targets
    - narrate targets:<[targets]> <[final]>
    - inject chat_accessibility_space_message_inject_apply
    - announce to_console <[final]>

chat_channel_ic_mel:
    debug: false
    type: task
    definitions: player|message
    script:
    - define message <[message].replace[&\].with[&].unescaped>
    - if !<[player].has_permission[chat.colors]>:
        - define message <[message].strip_color>
    - define final "<&e>**** <&f><placeholder[essentials_nickname].player[<[player]>]> <proc[chat_special_group].context[<[player]>]><proc[chat_roles_group].context[<[player]>]> <proc[character_get_name].context[<[player]>]> <element[&<color[<proc[settings_get].context[<[player]>|text_rp_chat_color]>].hex>].parse_color><&o><[message]>"
    - define targets <[player].location.find_players_within[25]>
    - inject chat_accessibility_space_message_inject_define
    - inject chat_accessibility_space_message_inject_apply
    - inject chat_channel_check_targets
    - narrate targets:<[targets]> <[final]>
    - inject chat_accessibility_space_message_inject_apply
    - announce to_console <[final]>

chat_channel_ic_whisper:
    debug: false
    type: task
    definitions: player|message
    script:
    - if <[message].starts_with[*]> && <[message].split[*].size> == 2:
        - if <[message].ends_with[*]>:
            - run chat_channel_ic_mec def.player:<[player]> def.message:<[message].substring[2,<[message].length.sub[1]>]>
        - else:
            - run chat_channel_ic_mec def.player:<[player]> def.message:<[message].substring[2,<[message].length>]>
        - stop
    - if !<[player].has_permission[chat.colors]>:
        - define message <[message].strip_color>
    - define tokenized <proc[chat_tokenize_actions].context[<[message]>|whispers|<&8>|<&7>|<&6><&sq>|false].replace[&\].with[&].unescaped>
    - define final "<&color[#d1d1d1]><placeholder[essentials_nickname].player[<[player]>]> <&f><proc[chat_special_group].context[<[player]>]><proc[chat_roles_group].context[<[player]>]> <proc[character_get_name].context[<[player]>]> <[tokenized]>"
    - define targets <[player].location.find_players_within[3]>
    - inject chat_accessibility_space_message_inject_define
    - inject chat_accessibility_space_message_inject_apply
    - inject chat_channel_check_targets
    - narrate targets:<[targets]> <[final]>
    - inject chat_accessibility_space_message_inject_apply
    - announce to_console <[final]>

chat_channel_ic_yell:
    debug: false
    type: task
    definitions: player|message
    script:
    - if <[message].starts_with[*]> && <[message].split[*].size> == 2:
        - if <[message].ends_with[*]>:
            - run chat_channel_ic_mel def.player:<[player]> def.message:<[message].substring[2,<[message].length.sub[1]>]>
        - else:
            - run chat_channel_ic_mel def.player:<[player]> def.message:<[message].substring[2,<[message].length>]>
        - stop
    - if !<[player].has_permission[chat.colors]>:
        - define message <[message].strip_color>
    - define tokenized <proc[chat_tokenize_actions].context[<[message]>|yells|<&6>|<&f>|<&6><&sq>|true].replace[&\].with[&].unescaped>
    - define final "<&f><placeholder[essentials_nickname].player[<[player]>]> <proc[chat_special_group].context[<[player]>]><proc[chat_roles_group].context[<[player]>]> <proc[character_get_name].context[<[player]>]> <[tokenized]>"
    - define targets <[player].location.find_players_within[25]>
    - inject chat_accessibility_space_message_inject_define
    - inject chat_accessibility_space_message_inject_apply
    - narrate targets:<[targets]> <[final]>
    - inject chat_accessibility_space_message_inject_apply
    - announce to_console <[final]>

chat_channel_ic_my:
    debug: false
    type: task
    definitions: player|message
    script:
    - define message <[message].replace[&\].with[&].unescaped>
    - if !<[player].has_permission[chat.colors]>:
        - define message <[message].strip_color>
    - define possession_name <proc[character_get_name].context[<[player]>]>
    - if <[possession_name].to_lowercase.ends_with[s]>:
        - define possession_name <[possession_name]><&sq>
    - else:
        - define possession_name <[possession_name]><&sq>s
    - define final "<&e>*** <&f><placeholder[essentials_nickname].player[<[player]>]> <proc[chat_special_group].context[<[player]>]><proc[chat_roles_group].context[<[player]>]> <[possession_name]> <&f><[message]>"
    - define targets <[player].location.find_players_within[10]>
    - inject chat_accessibility_space_message_inject_define
    - inject chat_accessibility_space_message_inject_apply
    - narrate targets:<[targets]> <[final]>
    - inject chat_accessibility_space_message_inject_apply
    - announce to_console <[final]>

chat_channel_ic_it:
    debug: false
    type: task
    definitions: player|message
    script:
    - define message <[message].replace[&\].with[&].unescaped>
    - if !<[player].has_permission[chat.colors]>:
        - define message <[message].strip_color>
    - define final "<&6>*** <&e><[message]> <&7>(<proc[character_get_name].context[<[player]>]>)"
    - define targets <[player].location.find_players_within[10]>
    - inject chat_accessibility_space_message_inject_define
    - inject chat_accessibility_space_message_inject_apply
    - narrate targets:<[targets]> <[final]>
    - inject chat_accessibility_space_message_inject_apply
    - announce to_console <[final]>

chat_channel_ic_itc:
    debug: false
    type: task
    definitions: player|message
    script:
    - define message <[message].replace[&\].with[&].unescaped>
    - if !<[player].has_permission[chat.colors]>:
        - define message <[message].strip_color>
    - define final "<&6>* <&e><[message]> <&7>(<proc[character_get_name].context[<[player]>]>)"
    - define targets <[player].location.find_players_within[3]>
    - inject chat_accessibility_space_message_inject_define
    - inject chat_accessibility_space_message_inject_apply
    - narrate targets:<[targets]> <[final]>
    - inject chat_accessibility_space_message_inject_apply
    - announce to_console <[final]>

chat_channel_ic_itl:
    debug: false
    type: task
    definitions: player|message
    script:
    - define message <[message].replace[&\].with[&].unescaped>
    - if !<[player].has_permission[chat.colors]>:
        - define message <[message].strip_color>
    - define final "<&6>**** <&e><[message]> <&7>(<proc[character_get_name].context[<[player]>]>)"
    - define targets <[player].location.find_players_within[25]>
    - inject chat_accessibility_space_message_inject_define
    - inject chat_accessibility_space_message_inject_apply
    - narrate targets:<[targets]> <[final]>
    - inject chat_accessibility_space_message_inject_apply
    - announce to_console <[final]>

chat_channel_ic_language:
    debug: false
    type: task
    definitions: player|message|language
    script:
    - define message <[message].replace[&\].with[&].unescaped>
    - if !<[player].has_permission[chat.colors]>:
        - define message <[message].strip_color>
    - define final_known "<&6>[<&7>L<&6>] <&f><placeholder[essentials_nickname].player[<[player]>]> <proc[chat_special_group].context[<[player]>]><proc[chat_roles_group].context[<[player]>]> <proc[character_get_name].context[<[player]>]> <player.flag[chat_color].if_null[<&f>]>says <&f><&dq><&o><[message]><&f><&dq> in <[language]>"
    - define final_unknown "<&6>[<&7>L<&6>] <&f><placeholder[essentials_nickname].player[<[player]>]> <proc[chat_special_group].context[<[player]>]><proc[chat_roles_group].context[<[player]>]> <proc[character_get_name].context[<[player]>]> <player.flag[chat_color].if_null[<&f>]>says something in <[language]>"
    - define all <[player].location.find_players_within[10]>
    - inject chat_accessibility_space_message_inject_define_language
    - inject chat_accessibility_space_message_inject_apply
    - inject chat_channel_check_targets_language
    - define speakers <[all].filter_tag[<[filter_value].flag[chat_languages].contains[<[language]>].if_null[false]>]>
    - define others <[all].exclude[<[speakers]>]>
    - narrate targets:<[speakers]> <[final_known]>
    - narrate targets:<[others]> <[final_unknown]>
    - inject chat_accessibility_space_message_inject_apply
    - announce to_console <[final_known]>

chat_channel_ic_languagewhisper:
    debug: false
    type: task
    definitions: player|message|language
    script:
    - define message <[message].replace[&\].with[&].unescaped>
    - if !<[player].has_permission[chat.colors]>:
        - define message <[message].strip_color>
    - define final_known "<&6>[<&7>L<&6>] <&f><placeholder[essentials_nickname].player[<[player]>]> <proc[chat_special_group].context[<[player]>]><proc[chat_roles_group].context[<[player]>]> <proc[character_get_name].context[<[player]>]> <&f>whispers <&dq><&o><[message]><&f><&dq> in <[language]>"
    - define final_unknown "<&6>[<&7>L<&6>] <&f><placeholder[essentials_nickname].player[<[player]>]> <proc[chat_special_group].context[<[player]>]><proc[chat_roles_group].context[<[player]>]> <proc[character_get_name].context[<[player]>]> <&f>whispers something in <[language]>"
    - define all <[player].location.find_players_within[3]>
    - inject chat_accessibility_space_message_inject_define_language
    - inject chat_accessibility_space_message_inject_apply
    - inject chat_channel_check_targets_language
    - define speakers <[all].filter_tag[<[filter_value].flag[chat_languages].contains[<[language]>].if_null[false]>]>
    - define others <[all].exclude[<[speakers]>]>
    - narrate targets:<[speakers]> <[final_known]>
    - narrate targets:<[others]> <[final_unknown]>
    - inject chat_accessibility_space_message_inject_apply
    - announce to_console <[final_known]>

chat_channel_ic_languageyell:
    debug: false
    type: task
    definitions: player|message|language
    script:
    - define message <[message].replace[&\].with[&].unescaped>
    - if !<[player].has_permission[chat.colors]>:
        - define message <[message].strip_color>
    - define final_known "<&6>[<&7>L<&6>] <&f><placeholder[essentials_nickname].player[<[player]>]> <proc[chat_special_group].context[<[player]>]><proc[chat_roles_group].context[<[player]>]> <proc[character_get_name].context[<[player]>]> <&f>yells <&dq><&o><[message].to_uppercase><&f><&dq> in <[language]>"
    - define final_unknown "<&6>[<&7>L<&6>] <&f><placeholder[essentials_nickname].player[<[player]>]> <proc[chat_special_group].context[<[player]>]><proc[chat_roles_group].context[<[player]>]> <proc[character_get_name].context[<[player]>]> <&f>yells something in <[language]>"
    - define all <[player].location.find_players_within[25]>
    - inject chat_accessibility_space_message_inject_define_language
    - inject chat_accessibility_space_message_inject_apply
    - inject chat_channel_check_targets_language
    - define speakers <[all].filter_tag[<[filter_value].flag[chat_languages].contains[<[language]>].if_null[false]>]>
    - define others <[all].exclude[<[speakers]>]>
    - narrate targets:<[speakers]> <[final_known]>
    - narrate targets:<[others]> <[final_unknown]>
    - inject chat_accessibility_space_message_inject_apply
    - announce to_console <[final_known]>
