radio_has_item:
    debug: false
    type: procedure
    definitions: player
    script:
    - foreach <[player].inventory.list_contents> as:item:
        - if <[item].has_flag[radio_item]>:
            - determine true
    - determine false

radio_get_item:
    debug: false
    type: procedure
    definitions: player
    script:
    - foreach <[player].inventory.list_contents> as:item:
        - if <[item].has_flag[radio_item]>:
            - determine <[item]>
    - determine null

radio_is_active:
    debug: false
    type: procedure
    definitions: player
    script:
    - define radio <proc[radio_get_item].context[<[player]>]>
    - if <[radio]> == null:
        - determine false
    - determine <[radio].has_flag[radio_enabled]>

radio_get_default_channel:
    debug: false
    type: procedure
    definitions: player
    script:
    - if <[player].has_permission[radio.category.police]>:
        - determine police
    - if <[player].has_permission[radio.category.hospital]>:
        - determine hospital
    - if <[player].has_permission[radio.category.school]>:
        - determine school
    - determine town

radio_get_channel:
    debug: false
    type: procedure
    definitions: player
    script:
    - define default <proc[radio_get_default_channel].context[<[player]>]>
    - if <[player].has_flag[radio_channel]>:
        - define override <[player].flag[radio_channel]>
        - if <[override]> == emergency:
            - if <[player].has_permission[radio.category.police]> || <[player].has_permission[radio.category.hospital]>:
                - determine emergency
            - flag <[player]> radio_channel:!
        - if <[override]> == police:
            - if <[player].has_permission[radio.category.police]>:
                - determine police
            - flag <[player]> radio_channel:!
        - if <[override]> == hospital:
            - if <[player].has_permission[radio.category.hospital]>:
                - determine hospital
            - flag <[player]> radio_channel:!
        - if <[override]> == school:
            - if <[player].has_permission[radio.category.school]>:
                - determine school
            - flag <[player]> radio_channel:!
        - if <[override]> == town:
            - determine town
        - flag <[player]> radio_channel:!
    - determine <[default]>

radio_channel_label:
    debug: false
    type: procedure
    definitions: channel
    script:
    - if <[channel]> == police:
        - determine <&b>[R-POLICE]
    - if <[channel]> == hospital:
        - determine <&1>[R-HOSPITAL]
    - if <[channel]> == school:
        - determine <&e>[R-SCHOOL]
    - if <[channel]> == town:
        - determine <&3>[R-TOWN]
    - if <[channel]> == emergency:
        - determine <&c>[R-EMERGENCY]
    - determine <&7>[R-UNKNOWN]

radio_transmit:
    debug: false
    type: task
    definitions: player|message|mode|forced_channel
    script:
    - define channel <[forced_channel]>
    - if <[channel]> == auto:
        - define channel <proc[radio_get_channel].context[<[player]>]>
    - define message <[message].replace[&\].with[&].unescaped>
    - if !<[player].has_permission[chat.colors]>:
        - define message <[message].strip_color>
    - define label <proc[radio_channel_label].context[<[channel]>]>
    - define nickname <placeholder[essentials_nickname].player[<[player]>]>
    - define special <proc[chat_special_group].context[<[player]>]>
    - define roles <proc[chat_roles_group].context[<[player]>]>
    - define character <proc[character_get_name].context[<[player]>]>
    - define identity "<[nickname]> <[special]><[roles]> <[character]>"
    - define local_range 10
    - define tokenized <proc[chat_tokenize_actions].context[<[message]>|<element[&<color[<proc[settings_get].context[<[player]>|text_rp_chat_color]>].hex>].parse_color>says<&7>:|<element[&<color[<proc[settings_get].context[<[player]>|text_rp_chat_color]>].hex>].parse_color>|<&f>|<&f><&dq><&f>|false].replace[&\].with[&].unescaped>
    - define local_message "<&7><[identity]> <[tokenized]> <&8>over the radio"
    - define radio_message "<[label]> <&7><[identity]> <[tokenized]> <&8>over the radio"
    - if <[mode]> == whisper:
        - define local_range 3
        - define tokenized <proc[chat_tokenize_actions].context[<[message]>|whispers|<&8>|<&7>|<&6><&sq>|false].replace[&\].with[&].unescaped>
        - define local_message "<&7><[identity]> <[tokenized]> <&8>over the radio"
        - define radio_message "<[label]> <&7><[identity]> <[tokenized]> <&8>over the radio"
    - else if <[mode]> == yell:
        - define local_range 30
        - define tokenized <proc[chat_tokenize_actions].context[<[message]>|yells|<&6>|<&f>|<&6><&sq>|true].replace[&\].with[&].unescaped>
        - define local_message "<&f><[identity]> <[tokenized]> <&8>over the radio"
        - define radio_message "<[label]> <&f><[identity]> <[tokenized]> <&8>over the radio"
    - else if <[mode]> == panic:
        - define local_range 0
        - define panic_message "PANIC: <[message]>"
        - define tokenized <proc[chat_tokenize_actions].context[<[panic_message]>|yells|<&c>|<&f>|<&6><&sq>|true].replace[&\].with[&].unescaped>
        - define local_message "<&f><[identity]> <[tokenized]> <&8>over the radio"
        - define radio_message "<[label]> <&f><[identity]> <[tokenized]> <&8>over the radio"
    - foreach <server.online_players> as:recipient:
        - define sent_radio false
        - if <proc[radio_is_active].context[<[recipient]>]>:
            - define recipient_channel <proc[radio_get_channel].context[<[recipient]>]>
            - if <[recipient_channel]> == <[channel]>:
                - narrate <[radio_message]> targets:<[recipient]>
                - define sent_radio true
        - if !<[sent_radio]>:
            - if <[recipient].world> == <[player].world>:
                - if <[recipient].location.distance[<[player].location>]> <= <[local_range]>:
                    - narrate <[local_message]> targets:<[recipient]>

radio_panic_transmit:
    debug: false
    type: task
    definitions: player
    script:
        - define nickname <placeholder[essentials_nickname].player[<[player]>]>
        - define special <proc[chat_special_group].context[<[player]>]>
        - define roles <proc[chat_roles_group].context[<[player]>]>
        - define character <proc[character_get_name].context[<[player]>]>
        - define location <[player].location>
        - define x <[location].x.round>
        - define y <[location].y.round>
        - define z <[location].z.round>
        - define label <proc[radio_channel_label].context[emergency]>
        - define identity "<[nickname]> <[special]><[roles]> <[character]>"
        - define main_message "<[label]> <&7><[identity]> <&c>has activated their panic button."
        - define panic_warning "<&c><&l>PANIC BUTTON ACTIVATED"
        - define coordinates "<&c>Coordinates: <&f>X: <[x]> <&7>| <&f>Y: <[y]> <&7>| <&f>Z: <[z]>"
        - foreach <server.online_players> as:recipient:
            - if <[recipient].has_permission[radio.category.police]> || <[recipient].has_permission[radio.category.hospital]>:
                - if <proc[radio_is_active].context[<[recipient]>]>:
                    - narrate <[main_message]> targets:<[recipient]>
                    - narrate <[panic_warning]> targets:<[recipient]>
                    - narrate <[coordinates]> targets:<[recipient]>

radio_make_item:
    debug: false
    type: procedure
    script:
    # TODO: it's better if it's an ItemDB item
    - define radio <item[glistering_melon_slice]>
    - adjust def:radio "display:<&7>Radio| <&c>Off"
    - adjust def:radio "lore:<&b>Left click <&f>to turn on/off.|<&7>|<&7><&o>Use with care."
    - define radio <[radio].with_flag[radio_item]>
    - determine <[radio]>
