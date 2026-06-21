compatibility_check_compare_versions:
    debug: false
    type: procedure
    definitions: version1|version2
    script:
    - define v1split <[version1].split[.]>
    - define v2split <[version2].split[.]>
    - foreach <[v1split]> as:v1splitpart:
        - define v2splitpart <[v2split].get[<[loop_index]>].if_null[0]>
        - if <[v1splitpart]> > <[v2splitpart]>:
            - determine 1
        - if <[v1splitpart]> < <[v2splitpart]>:
            - determine -1
    - if <[v2split].size> > <[v1split].size>:
        - determine -1
    - determine 0

compatibility_check_world:
    debug: false
    type: world
    events:
        after player joins:
        - if <proc[settings_get].context[<player>|general_ignore_version_compatibility_check]>:
            - stop
        - define player_version <player.viaversion_version.split[-].get[2].if_null[<player.viaversion_version>]>
        - define server_version <server.version.split[(].get[2].split[:].get[2].split[)].get[1].trim>
        - if <proc[compatibility_check_compare_versions].context[<[player_version]>|<[server_version]>]> == -1:
            - wait 3s
            - if !<player.is_online>:
                - stop
            - narrate <&f>
            - narrate "<&c><&l>[<&4><&l>!<&c><&l>] <&c>You are using an outdated Minecraft version!"
            - narrate "<&6>Your version: <&f><[player_version]>"
            - narrate "<&6>Server version: <&f><[server_version]>"
            - narrate <&f>
            - narrate "<&f>You can still play, however we strongly encourage you to consider <&e>updating your game<&f>."
            - narrate "<&f>We will not offer bug support if you are using an outdated version!"
            - narrate <&f>
            - narrate "<&7>(Your ViaVersion protocol: <player.viaversion_protocol>)"
            - narrate <&f>