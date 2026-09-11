radio_command:
    debug: false
    type: command
    name: radio
    description: Radio communication.
    usage: /radio <&lt>message<&gt>
    permission: radio.command
    aliases:
    - r
    script:
        - if <context.source_type> != player:
            - narrate format:formats_prefix "<&c>Please run this command as a player."
            - stop

        - if <context.args.is_empty>:
            - narrate format:formats_prefix "<&c>Invalid usage. Run <&f>/radio help<&c> to view radio commands."
            - stop

        - define first <context.args.get[1].to_lowercase>

        - if <[first]> == help:
            - run radio_help
            - stop

        - if <[first]> == give:
            - if !<player.has_permission[radio.command.give]>:
                - narrate format:formats_prefix "<&c>You do not have permission to give radios."
                - stop

            - if <context.args.size> > 1:
                - define target <server.match_player[<context.args.get[2]>].if_null[null]>
                - if <[target]> == null:
                    - narrate format:formats_prefix "<&c>Player not found."
                    - stop

                - run radio_give def:<[target]>
                - stop

            - run radio_give def:<player>
            - stop

        - if <[first]> == channel:
            - if <context.args.size> < 2:
                - narrate format:formats_prefix "<&c>Invalid usage. Run <&f>/radio help<&c> to view radio commands."
                - stop

            - define channel <context.args.get[2].to_lowercase>
            - run radio_set_channel def:<player>|<[channel]>
            - stop

        - if <[first]> == status:
            - run radio_status def:<player>
            - stop

        - if <[first]> == create:
            - run radio_give def:<player>
            - stop

        - run radio_speak def:<player>|<context.raw_args>


radio_whisper_command:
    debug: false
    type: command
    name: radiowhisper
    description: Whisper over the radio.
    usage: /radiowhisper <&lt>message<&gt>
    aliases:
    - radiow
    - rw
    permission: radio.command
    script:
        - if <context.source_type> != player:
            - narrate format:formats_prefix "<&c>Please run this command as a player."
            - stop

        - if <context.args.is_empty>:
            - narrate format:formats_prefix "<&c>Invalid usage. Run <&f>/radio help<&c> to view radio commands."
            - stop

        - run radio_whisper def:<player>|<context.raw_args>


radio_yell_command:
    debug: false
    type: command
    name: radioyell
    description: Yell over the radio.
    usage: /radioyell <&lt>message<&gt>
    aliases:
    - radioy
    - ry
    permission: radio.command
    script:
        - if <context.source_type> != player:
            - narrate format:formats_prefix "<&c>Please run this command as a player."
            - stop

        - if <context.args.is_empty>:
            - narrate format:formats_prefix "<&c>Invalid usage. Run <&f>/radio help<&c> to view radio commands."
            - stop

        - run radio_yell def:<player>|<context.raw_args>


radio_panic_command:
    debug: false
    type: command
    name: radiopanic
    description: Sends an emergency radio alert.
    usage: /radiopanic
    aliases:
    - rpanic
    permission: radio.command
    script:
        - if <context.source_type> != player:
            - narrate format:formats_prefix "<&c>Please run this command as a player."
            - stop

        - if <context.args.size> > 0:
            - narrate format:formats_prefix "<&c>Invalid usage. Run <&f>/radio help<&c> to view radio commands."
            - stop

        - run radio_panic def:<player>


radio_help:
    debug: false
    type: task
    script:
        - narrate format:formats_prefix "<&d>Radio Commands"
        - narrate "<&7>/radio <&lt>message<&gt> <&8>— <&f>Speak over the radio."
        - narrate "<&7>/r <&lt>message<&gt> <&8>— <&f>Shortcut for radio."
        - narrate "<&7>/radio channel <&lt>channel<&gt> <&8>— <&f>Switch channels."
        - narrate "<&7>/radio status <&8>— <&f>View your radio status."
        - narrate "<&7>/radiowhisper <&lt>message<&gt> <&8>— <&f>Whisper over the radio."
        - narrate "<&7>/radiow <&lt>message<&gt> <&8>— <&f>Shortcut for radio whisper."
        - narrate "<&7>/rw <&lt>message<&gt> <&8>— <&f>Shortcut for radio whisper."
        - narrate "<&7>/radioyell <&lt>message<&gt> <&8>— <&f>Yell over the radio."
        - narrate "<&7>/radioy <&lt>message<&gt> <&8>— <&f>Shortcut for radio yell."
        - narrate "<&7>/ry <&lt>message<&gt> <&8>— <&f>Shortcut for radio yell."
        - narrate "<&7>/radiopanic <&8>— <&f>Send an emergency alert."
        - narrate "<&7>Channels: <&ftown<&7>, <&fhospital<&7>, <&fpolice<&7>, <&fschool<&7>, <&femergency"

        - if <player.has_permission[radio.command.give]>:
            - narrate "<&7>/radio give [player] <&8>— <&f>Give a radio."