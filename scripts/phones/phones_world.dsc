phones_world:
    debug: false
    type: world
    events:
        ## assign new random number & handle notifications
        after player joins:
        - run phones_notify_text_messages def.player:<player> def.delayseconds:5
        #
        - if <player.has_flag[phones]>:
            - stop
        - define number <util.random.int[1000000].to[9999999]>
        - while <server.flag[phones].if_null[<map[]>].contains[377<[number]>]>:
            - define number <util.random.int[1000000].to[9999999]>
        - define number 377<[number]>
        - flag <player> phones:<map[].with[number].as[<[number]>]>
        - flag server phones:<server.flag[phones].if_null[<map[]>].with[<[number]>].as[<player>]>
        ## phone drop, phone unequip, player logs off etc.
        on player drops item:
        - if <player.has_flag[phones_chat_input]>:
            - if <context.item.has_flag[phones].if_null[false]>:
                - determine cancelled
        - if <context.item.has_flag[phones].if_null[false]>:
            - nbs stop targets:<player>
        - inject phones_inject_end_call
        on player scrolls their hotbar:
        - if <player.inventory.slot[<context.previous_slot>].has_flag[phones]>:
            - inject phones_inject_end_call
        on player quits:
        - inject phones_inject_end_call
        after player clicks in inventory:
        - if !<player.item_in_hand.flag[phones].if_null[false]>:
            - inject phones_inject_end_call
        ## boot up/down phone
        on player left clicks block:
        - if !<player.item_in_hand.has_flag[phones].if_null[false]>:
            - stop
        - if <player.open_inventory> != <player.inventory>:
            - stop
        - determine cancelled passively
        - if <player.has_flag[phones_chat_input]>:
            - flag <player> phones_chat_input:!
        - define state <player.item_in_hand.flag[phones].not>
        - inventory flag slot:hand phones:<[state]>
        - if <[state]>:
            - narrate format:formats_prefix "Powered <&a>on <&7>your phone."
            #
            - run phones_notify_text_messages def.player:<player> def.delayseconds:2
        - else:
            - narrate format:formats_prefix "Powered <&c>off <&7>your phone."
            - nbs stop targets:<player>
            - inject phones_inject_end_call
        ## phone GUI
        on player right clicks block:
        - if !<player.item_in_hand.has_flag[phones].if_null[false]>:
            - stop
        - determine cancelled passively
        - if <player.has_flag[phones_call]>:
            - narrate "<&c>You are currently in the middle of a call (stop holding the phone to end the call)."
            - stop
        - if <player.has_flag[phones_chat_input]>:
            - flag <player> phones_chat_input:!
        - if !<player.item_in_hand.flag[phones]>:
            - narrate "<&c>Please turn on your phone (left click) to view the home screen."
            - stop
        - run phones_gui_home def.player:<player>
        ## discord bot interop
        after server start:
        - if <discord[phones_emergency].if_null[null]> == null:
            - ~discordconnect id:phones_emergency token:<secret[phones_emergency_discord_secret]>
            - announce to_ops "<&6>Connected to the Phones Emergency Discord Bot inteop."
            - announce to_console "[PHONES] <&6>Connected to the Phones Emergency Discord Bot inteop."
        on delta time minutely every:10:
        - if <discord[phones_emergency].if_null[null]> == null:
            - ~discordconnect id:phones_emergency token:<secret[phones_emergency_discord_secret]>
            - announce to_ops "<&6>Connected to the Phones Emergency Discord Bot inteop."
            - announce to_console "[PHONES] <&6>Connected to the Phones Emergency Discord Bot inteop."

# used in ending a call because code repeats a lot
phones_inject_end_call:
    debug: false
    type: task
    script:
    - if <player.has_flag[phones_is_maybe_called]>:
        - flag <player> phones_is_maybe_called:!
        - nbs stop
    - if !<player.has_flag[phones_call]>:
        - stop
    - define callwho <player.flag[phones_call]>
    - define iswaiting <player.has_flag[phones_call_clickable]>
    - flag <player> phones_call:!
    - if <[iswaiting]>:
        - clickable cancel:<player.flag[phones_call_clickable]>
        - flag <player> phones_call_clickable:!
    - if <[callwho].flag[phones_call].if_null[null]> == <player> || <[callwho].flag[phones_call].if_null[null].starts_with[110_]>:
        - if !<player.has_flag[phones_emergency]>:
            - narrate targets:<[callwho]> format:formats_prefix "Call was ended by the other side."
        - flag <[callwho]> phones_call:!
        - flag <[callwho]> phones_emergency:!
        - flag <[callwho]> phones_emergency_actual_target:!
    - else:
        - if <[callwho].uuid.if_null[null]> != null:
            - nbs stop targets:<[callwho]>
            - narrate targets:<[callwho]> format:formats_prefix "The person on the other side hung up before you answered."
        - else:
            - define emergency_type <[callwho].substring[5]>
            - narrate format:formats_prefix targets:<server.online_players.filter_tag[<[filter_value].has_permission[phones.emergency.<[emergency_type]>]>].filter_tag[<proc[phones_has_phone].context[<[filter_value]>]>]> "The person on the other side hung up."
    - narrate format:formats_prefix "You ended the call."
    - if <player.has_flag[phones_emergency]>:
        - define emergency_type <player.flag[phones_emergency].substring[5]>
        - narrate format:formats_prefix targets:<server.online_players.filter_tag[<[filter_value].has_permission[phones.emergency.<[emergency_type]>]>].include[<[callwho]>].filter_tag[<proc[phones_has_phone].context[<[filter_value]>]>]> "Call ended by the hotline service."
    - flag <player> phones_emergency:!
    - if <player.has_flag[phones_emergency_actual_target]>:
        - define actual_target <player.flag[phones_emergency_actual_target]>
        - flag <[actual_target]> phones_call:!
        - flag <[actual_target]> phones_call_clickable:!
        - flag <[actual_target]> phones_emergency:!
        - flag <[actual_target]> phones_emergency_actual_target:!
    - flag <player> phones_emergency_actual_target:!

## only gui handling
phones_world_gui:
    debug: false
    type: world
    events:
        on player clicks in inventory:
        - if !<context.inventory.title.contains[鄀]>:
            - stop
        - determine cancelled passively
        - if <context.slot> > <context.inventory.size>:
            - stop
        - define title <context.inventory.title.substring[8]>
        # Home Page
        - if <[title]> == <&0>邒:
            - if <context.slot> == 13:
                - run phones_gui_settings def.player:<player>
            - if <context.slot> == 14:
                - inventory close
                - run phones_contacts_print def.player:<player> def.page:0
            - else if <context.slot> == 15:
                - flag <player> phones_gui_page:0
                - run phones_gui_texts def.player:<player> def.page:0
            - else if <context.slot> == 22:
                - flag <player> phones_gui_page:0
                - run phones_gui_music def.player:<player> def.page:0 def.ringtone:false
        - else if <[title]> == <&1>邒:
            - if <context.item.material.name> == ender_pearl:
                - define page <player.flag[phones_gui_page].sub[1]>
                - flag <player> phones_gui_page:<[page]>
                - run phones_gui_texts def.player:<player> def.page:<[page]>
            - else if <context.item.material.name> == ender_eye:
                - define page <player.flag[phones_gui_page].add[1]>
                - flag <player> phones_gui_page:<[page]>
                - run phones_gui_texts def.player:<player> def.page:<[page]>
            - else if <context.slot> == 50:
                - run phones_gui_home def.player:<player>
            - else if <context.item.material.name> == player_head:
                - inventory close
                - run phones_texts_print def.player:<player> def.target:<context.item.flag[phones]> def.page:0
        # Music
        - else if <[title]> == <&2>邒:
            - if <context.item.material.name> == ender_pearl:
                - define page <player.flag[phones_gui_page].sub[1]>
                - flag <player> phones_gui_page:<[page]>
                - run phones_gui_music def.player:<player> def.page:<[page]> def.ringtone:false
            - else if <context.item.material.name> == ender_eye:
                - define page <player.flag[phones_gui_page].add[1]>
                - flag <player> phones_gui_page:<[page]>
                - run phones_gui_music def.player:<player> def.page:<[page]> def.ringtone:false
            - else if <context.slot> == 50:
                - run phones_gui_home def.player:<player>
            - else if <context.slot> == 42:
                - inventory close
                - run phones_music_stop def.player:<player>
            - else if <context.item.material.name> == jukebox:
                - inventory close
                - run phones_music_play def.player:<player> def.songfile:<context.item.flag[phones]>
        # Settings
        - else if <[title]> == <&3>邒:
            - if <context.slot> == 4:
                - flag <player> phones_gui_page:0
                - run phones_gui_music def.player:<player> def.page:0 def.ringtone:true
            - if <context.slot> == 5:
                - flag <player> phones_gui_page:0
                - run phones_gui_settings_blocked def.player:<player> def.page:0
            - else if <context.slot> == 50:
                - run phones_gui_home def.player:<player>
        # Ringtone Select
        - else if <[title]> == <&4>邒:
            - if <context.item.material.name> == ender_pearl:
                - define page <player.flag[phones_gui_page].sub[1]>
                - flag <player> phones_gui_page:<[page]>
                - run phones_gui_music def.player:<player> def.page:<[page]> def.ringtone:true
            - else if <context.item.material.name> == ender_eye:
                - define page <player.flag[phones_gui_page].add[1]>
                - flag <player> phones_gui_page:<[page]>
                - run phones_gui_music def.player:<player> def.page:<[page]> def.ringtone:true
            - else if <context.slot> == 50:
                - run phones_gui_settings def.player:<player>
            - else if <context.item.material.name> == jukebox:
                - flag <player> phones:<player.flag[phones].with[ringtone].as[<context.item.flag[phones]>]>
                - run phones_gui_settings def.player:<player>
                - narrate format:formats_prefix "Changed your ringtone to <&e><context.item.display.strip_color><&7>."
        # Blocked
        - else if <[title]> == <&5>邒:
            - if <context.item.material.name> == ender_pearl:
                - define page <player.flag[phones_gui_page].sub[1]>
                - flag <player> phones_gui_page:<[page]>
                - run phones_gui_settings_blocked def.player:<player> def.page:<[page]>
            - else if <context.item.material.name> == ender_eye:
                - define page <player.flag[phones_gui_page].add[1]>
                - flag <player> phones_gui_page:<[page]>
                - run phones_gui_settings_blocked def.player:<player> def.page:<[page]>
            - else if <context.slot> == 50:
                - run phones_gui_settings def.player:<player>
