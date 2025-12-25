chat_world:
    debug: false
    type: world
    events:
        on player chats:
        - determine cancelled passively
        - define channel <proc[settings_get].context[<player>|text_rp_chat_channel]>
        - if <[channel]> == ic:
            - run chat_channel_ic def.player:<player> def.message:<context.message.parse_color.escaped.replace[&].with[&\]>
        - else if <[channel]> == ooc:
            - run chat_channel_ooc def.player:<player> def.message:<context.message.escaped.replace[&].with[&\]>
        on player receives message:
        ## yes, we will sync the chat thread and live dangerously
        # manual settings_get because this event is very finnicky and dangerous
        - if <player.flag[settings].get[accessibility_chat_disable_colors].if_null[false]>:
            - determine MESSAGE:<context.message.strip_color>
