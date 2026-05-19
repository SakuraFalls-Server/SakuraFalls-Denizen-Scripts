chat_command_ooc:
    debug: false
    type: command
    name: ooc
    usage: /ooc (message)
    description: Sends a message in global OOC.
    permission: chat.command.chat.ooc
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - if !<player.has_flag[chat_disableooc]>:
            - if <player.flag[chat_channel].if_null[ic]> == ooc:
                - narrate "<&c>You are currently switched to OOC chat, so you cannot disable it."
                - stop
            - flag <player> chat_disableooc:true
            - narrate format:formats_prefix "Disabled OOC chat."
        - else:
            - flag <player> chat_disableooc:!
            - narrate format:formats_prefix "Enabled OOC chat."
        - stop
    - else if <player.has_flag[chat_disableooc]>:
        - narrate "<&c>You cannot use OOC chat while it is disabled. Please enable it first."
        - stop
    - run chat_channel_ooc def.player:<player> def.message:<context.raw_args.escaped.replace[&].with[&\]>

chat_command_looc:
    debug: false
    type: command
    name: looc
    usage: /looc (message)
    description: Sends a message in local LOOC.
    permission: chat.command.chat.looc
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a message!"
        - stop
    - run chat_channel_looc def.player:<player> def.message:<context.raw_args.escaped.replace[&].with[&\]>

chat_command_me:
    debug: false
    type: command
    name: me
    usage: /me (message)
    description: Sends a message in IC, 1st person action.
    permission: chat.command.chat.me
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a message!"
        - stop
    - run chat_channel_ic_me def.player:<player> def.message:<context.raw_args.parse_color.escaped.replace[&].with[&\]>

chat_command_meclose:
    debug: false
    type: command
    name: meclose
    usage: /meclose (message)
    aliases:
    - mec
    description: Sends a message in IC, 1st person action, close range.
    permission: chat.command.chat.mec
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a message!"
        - stop
    - run chat_channel_ic_mec def.player:<player> def.message:<context.raw_args.parse_color.escaped.replace[&].with[&\]>

chat_command_melong:
    debug: false
    type: command
    name: melong
    usage: /melong (message)
    aliases:
    - mel
    description: Sends a message in IC, 1st person action, long range.
    permission: chat.command.chat.mel
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a message!"
        - stop
    - run chat_channel_ic_mel def.player:<player> def.message:<context.raw_args.parse_color.escaped.replace[&].with[&\]>

chat_command_whisper:
    debug: false
    type: command
    name: whisper
    usage: /whisper (message)
    aliases:
    - w
    description: Sends a message in IC, whispering.
    permission: chat.command.chat.whisper
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a message!"
        - stop
    - run chat_channel_ic_whisper def.player:<player> def.message:<context.raw_args.parse_color.escaped.replace[&].with[&\]>

chat_command_yell:
    debug: false
    type: command
    name: yell
    usage: /yell (message)
    aliases:
    - y
    description: Sends a message in IC, yelling.
    permission: chat.command.chat.yell
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a message!"
        - stop
    - run chat_channel_ic_yell def.player:<player> def.message:<context.raw_args.parse_color.escaped.replace[&].with[&\]>

chat_command_my:
    debug: false
    type: command
    name: my
    usage: /my (message)
    description: Sends a message in IC, 1st person possessive.
    permission: chat.command.chat.my
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a message!"
        - stop
    - run chat_channel_ic_my def.player:<player> def.message:<context.raw_args.parse_color.escaped.replace[&].with[&\]>

chat_command_it:
    debug: false
    type: command
    name: it
    usage: /it (message)
    description: Sends a message in IC, 3rd person action.
    permission: chat.command.chat.it
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a message!"
        - stop
    - run chat_channel_ic_it def.player:<player> def.message:<context.raw_args.parse_color.escaped.replace[&].with[&\]>

chat_command_itclose:
    debug: false
    type: command
    name: itclose
    usage: /itclose (message)
    aliases:
    - itc
    description: Sends a message in IC, 3rd person action, close range.
    permission: chat.command.chat.itc
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a message!"
        - stop
    - run chat_channel_ic_itc def.player:<player> def.message:<context.raw_args.parse_color.escaped.replace[&].with[&\]>

chat_command_itl:
    debug: false
    type: command
    name: itlong
    usage: /itlong (message)
    aliases:
    - itl
    description: Sends a message in IC, 3rd person action, long range.
    permission: chat.command.chat.itl
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a message!"
        - stop
    - run chat_channel_ic_itl def.player:<player> def.message:<context.raw_args.parse_color.escaped.replace[&].with[&\]>

chat_command_languageadd:
    debug: false
    type: command
    name: languageadd
    usage: /languageadd (player) (language)
    aliases:
    - langadd
    description: Allows a user to speak a new language.
    permission: chat.command.admin.languageadd
    tab completions:
        1: <server.online_players.parse[name]>
        2: <script[chat_data_languages].data_key[known]>
    script:
    - if <context.args.size> < 2:
        - narrate "<&c>Invalid use. Please try /<context.alias> (player) (language)."
        - stop
    - define player <server.match_offline_player[<context.args.get[1]>].if_null[null]>
    - if <[player]> == null:
        - narrate "<&c>A player with name <context.args.get[1]> was not found."
        - stop
    - define language <context.args.get[2].to_sentence_case>
    - define known <script[chat_data_languages].data_key[known]>
    - if !<[known].contains[<[language]>]>:
        - narrate "<&c>Language <[language]> is not a known language."
        - stop
    - flag <[player]> chat_languages:<[player].flag[chat_languages].if_null[<list[]>].include[<[language]>].deduplicate>
    - adjust server save
    - narrate format:formats_prefix "Player <&e><[player].name> <&7>may now speak in <[language]>."

chat_command_languageremove:
    debug: false
    type: command
    name: languageremove
    usage: /languageremove (player) (language)
    aliases:
    - langremove
    - langrem
    description: Removes a language that a player knows.
    permission: chat.command.admin.languageremove
    tab completions:
        1: <server.online_players.parse[name]>
        2: <script[chat_data_languages].data_key[known]>
    script:
    - if <context.args.size> < 2:
        - narrate "<&c>Invalid use. Please try /<context.alias> (player) (language)."
        - stop
    - define player <server.match_offline_player[<context.args.get[1]>].if_null[null]>
    - if <[player]> == null:
        - narrate "<&c>A player with name <context.args.get[1]> was not found."
        - stop
    - define language <context.args.get[2].to_sentence_case>
    - define known <script[chat_data_languages].data_key[known]>
    - if !<[known].contains[<[language]>]>:
        - narrate "<&c>Language <[language]> is not a known language."
        - stop
    - flag <[player]> chat_languages:<[player].flag[chat_languages].if_null[<list[]>].exclude[<[language]>]>
    - adjust server save
    - narrate format:formats_prefix "Player <&e><[player].name> <&7>cannot speak <[language]> any longer."

chat_command_language:
    debug: false
    type: command
    name: language
    usage: /language (language) (message)
    aliases:
    - lang
    description: Sends a message in IC, in a language.
    permission: chat.command.chat.language
    tab completions:
        1: <player.flag[chat_languages].if_null[<list[]>]>
        2: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 1:
        - narrate "<&c>Invalid use. Please use /<context.alias> (language) (message)."
        - stop
    - define language <context.args.get[1].to_sentence_case>
    - if !<player.flag[chat_languages].contains[<[language]>].if_null[false]>:
        - narrate "<&c>Your character cannot speak in <[language]>."
        - stop
    - run chat_channel_ic_language def.player:<player> def.message:<context.raw_args.split.get[2].to[last].space_separated.parse_color.escaped.replace[&].with[&\]> def.language:<[language]>

chat_command_languagewhisper:
    debug: false
    type: command
    name: languagewhisper
    usage: /languagewhisper (language) (message)
    aliases:
    - langwhisper
    - langw
    description: Sends a message in IC, in a language, whispering.
    permission: chat.command.chat.languagewhisper
    tab completions:
        1: <player.flag[chat_languages].if_null[<list[]>]>
        2: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 1:
        - narrate "<&c>Invalid use. Please use /<context.alias> (language) (message)."
        - stop
    - define language <context.args.get[1].to_sentence_case>
    - if !<player.flag[chat_languages].contains[<[language]>].if_null[false]>:
        - narrate "<&c>Your character cannot speak in <[language]>."
        - stop
    - run chat_channel_ic_languagewhisper def.player:<player> def.message:<context.raw_args.split.get[2].to[last].space_separated.parse_color.escaped.replace[&].with[&\]> def.language:<[language]>

chat_command_languageyell:
    debug: false
    type: command
    name: languageyell
    usage: /languageyell (language) (message)
    aliases:
    - langyell
    - langy
    description: Sends a message in IC, in a language, yelling.
    permission: chat.command.chat.languageyell
    tab completions:
        1: <player.flag[chat_languages].if_null[<list[]>]>
        2: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 1:
        - narrate "<&c>Invalid use. Please use /<context.alias> (language) (message)."
        - stop
    - define language <context.args.get[1].to_sentence_case>
    - if !<player.flag[chat_languages].contains[<[language]>].if_null[false]>:
        - narrate "<&c>Your character cannot speak in <[language]>."
        - stop
    - run chat_channel_ic_languageyell def.player:<player> def.message:<context.raw_args.split.get[2].to[last].space_separated.parse_color.escaped.replace[&].with[&\]> def.language:<[language]>

chat_command_modchat:
    debug: false
    type: command
    name: modchat
    usage: /modchat (message)
    aliases:
    - mc
    description: Sends a message in moderator chat.
    permission: chat.command.chat.modchat
    tab completions:
        1: <&lt>message<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Please enter a message!"
        - stop
    - run chat_channel_modchat def.player:<player> def.message:<context.raw_args.escaped.replace[&].with[&\]>

##
## Channel switch
##

chat_command_channelswitch:
    debug: false
    type: command
    name: channelswitch
    usage: /channelswitch (channel)
    aliases:
    - chsw
    description: Changes your main channel.
    permission: chat.command.channelswitch
    tab completions:
        1: <list[ic|ooc]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Invalid use. Please use /<context.alias> (channel)."
        - stop
    - define channel <context.args.get[1].to_lowercase>
    - choose <[channel]>:
        - case ic:
            - run settings_set def.player:<player> def.key:text_rp_chat_channel def.value:ic
            - narrate format:formats_prefix "Changed channel to IC."
            - stop
        - case ooc:
            - if <player.has_flag[chat_disableooc]>:
                - narrate "<&c>You currently have OOC disabled. Use /ooc first to enable it."
                - stop
            - run settings_set def.player:<player> def.key:text_rp_chat_channel def.value:ooc
            - narrate format:formats_prefix "Changed channel to OOC."
            - stop
    - narrate "<&c>Unknown channel <[channel]>. Please try: ic, ooc."

##
## Chat Color
##

chat_command_chatcolor:
    debug: false
    type: command
    name: chatcolor
    usage: /chatcolor (color)
    description: Changes the chat color for your actions.
    permission: chat.command.chatcolor
    tab completions:
        1: <proc[chat_allowed_colors]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> <= 0:
        - narrate "<&c>Invalid use. Please use /<context.alias> (color)."
        - stop
    - define color <context.args.get[1].to_lowercase>
    - if !<proc[chat_allowed_colors].contains[<[color]>]>:
        - narrate "<&c>You must choose a color from this list: <proc[chat_allowed_colors].comma_separated>"
        - stop
    - run settings_set def.player:<player> def.key:text_rp_chat_color def.value:<[color]>
    - narrate format:formats_prefix "Changed chat color to <element[&<color[<[color]>].hex>].parse_color><[color]>."
