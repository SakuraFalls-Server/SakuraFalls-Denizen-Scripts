settings_config:
    debug: false
    type: data
    tabs:
    - General
    - Game
    - Text
    - Sounds
    - Accessibility
    keys:
        general_see_player_join_leave:
            tab: General
            name: See player join and leave messages
            description: If enabled, will show in chat when other players join or leave.
            type: boolean
            default: true
        general_ignore_version_compatibility_check:
            tab: General
            name: Ignore version compatibility warning
            description: If enabled, will not show the compatibility warning when joining the server on an old unsupported version.
            type: boolean
            default: false
        ##
        game_see_auto_money_announcements:
            tab: Game
            name: See auto money announcements
            description: If enabled, will show in chat when you receive money for being online.
            type: boolean
            default: true
        game_disable_phone_ringtone:
            tab: Game
            name: Disable phone ringtone
            description: If enabled, the ringtone won't play when your phone is calling.
            type: boolean
            default: false
        ##
        text_rp_chat_color:
            tab: Text
            name: Roleplay chat color
            description: Changes the color used for actions when using in character chat channels. Can also be changed using /chatcolor.
            type: list
            default: yellow
            values:
            - aqua
            - blue
            - fuchsia
            - gray
            - green
            - lime
            - maroon
            - navy
            - olive
            - orange
            - purple
            - red
            - silver
            - teal
            - yellow
        text_rp_chat_channel:
            tab: Text
            name: Current roleplay chat channel
            description: The channel you are currently using. Can also be changed using /chsw.
            type: list
            default: ic
            values:
            - ic
            - ooc
        text_rp_chat_distance_warning:
            tab: Text
            name: Warn when no message receivers
            description: If enabled, will warn you when your in character chat channel message was not seen by any other player.
            type: boolean
            default: true
        text_textbox_write_speed:
            tab: Text
            name: Textbox write speed
            description: How fast textboxes should write text.
            type: number
            default: 2
            min: 1
            max: 3
            increment: 1
        ##
        sound_textbox_volume:
            tab: Sounds
            name: Textbox volume
            description: Changes the volume when the textbox is writing.
            type: number
            default: 80
            min: 0
            max: 100
            increment: 5
        sound_vehicles_volume:
            tab: Sounds
            name: Vehicles volume
            description: Changes the volume of vehicle engines.
            type: number
            default: 50
            min: 0
            max: 100
        ##
        accessibility_rp_chat_disable_colors:
            tab: Accessibility
            name: Disable colors in chat channels
            description: If enabled, hides all colors in chat channels, instead using plain white.
            type: boolean
            default: false
        accessibility_rp_chat_space_messages:
            tab: Accessibility
            name: Space messages for in character chat channels
            description: If enabled, in character chat channel messages will be begin and end with a new line to distinguish where the message begins and ends.
            type: boolean
            default: false
        ##
        # example1_key:
        #     tab: General
        #     name: example1 setting key
        #     description: example1 description
        #     type: boolean
        #     default: true
        # example2_key:
        #     tab: General
        #     name: example2 setting key
        #     description: example2 description
        #     type: number
        #     default: 5
        #     min: 0
        #     max: 10
        #     increment: 0.5
        # example3_key:
        #     tab: Miscellaneous
        #     name: example3 setting key
        #     description: example3 description
        #     type: list
        #     default: male
        #     values:
        #     - male
        #     - female
        #     - prefer not to say
        # example4_key:
        #     tab: Miscellaneous
        #     name: example4 setting key
        #     description: example4 description
        #     type: text
        #     default: text
        #     max-length: 64
        #     regex: "[a-z]+"
