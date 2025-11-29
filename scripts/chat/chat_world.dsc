chat_world:
    debug: false
    type: world
    events:
        on player chats:
        - determine cancelled passively
        - define channel <player.flag[chat_channel].if_null[ic]>
        - if <[channel]> == ic:
            - run chat_channel_ic def.player:<player> def.message:<context.message.parse_color.escaped.replace[&].with[&\]>
        - else if <[channel]> == ooc:
            - run chat_channel_ooc def.player:<player> def.message:<context.message.escaped.replace[&].with[&\]>
