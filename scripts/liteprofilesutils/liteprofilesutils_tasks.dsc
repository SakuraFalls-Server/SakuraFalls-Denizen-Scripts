liteprofilesutils_load_data:
    debug: false
    type: task
    script:
    - ~yaml load:../LiteProfiles/data.yml id:liteprofiles_data

liteprofilesutils_get_master_uuid:
    debug: false
    type: procedure
    definitions: player
    script:
    - determine <server.match_offline_player[<[player].name.split[.].first.if_null[<[player].name>]>.0].uuid>

liteprofilesutils_get_profile_limit:
    debug: false
    type: procedure
    definitions: player
    script:
    - determine <placeholder[liteprofiles_limit].player[<[player]>]>

liteprofilesutils_get_profile_count:
    debug: false
    type: procedure
    definitions: player
    script:
    - determine <placeholder[liteprofiles_count].player[<[player]>]>

liteprofilesutils_show_menu:
    debug: false
    type: task
    definitions: player|page
    script:
    - define page <[page].if_null[0]>
    - ~run liteprofilesutils_load_data
    - define masteruuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
    - define profilelimit <proc[liteprofilesutils_get_profile_limit].context[<[player]>]>
    - define profilecount <proc[liteprofilesutils_get_profile_count].context[<[player]>]>
    - define all <list[]>
    # master profile
    - define masterplayer <player[<[masteruuid]>]>
    - define mastername <proc[character_get_name].context[<[masterplayer]>]>
    - if <[mastername]> == null:
        - define mastername "Unnamed Character"
    - define masteritem <item[emerald_block]>
    - adjust def:masteritem display:<&f><[mastername]>
    - adjust def:masteritem lore:<list[<&6>Master Profile|<&f>|<&e>Offline Username:|<&f><[masterplayer].name> <&6>or <&f><[masterplayer].name>.0|<&f>|<&8>UUID:|<&8><[masteruuid]>]>
    - definemap master_entry:
        item: <[masteritem]>
        script: liteprofilesutils_menu_use
        definitions:
            player: <[player]>
            value: <[masteruuid]>
    - define all <[all].include[<[master_entry]>]>
    # alt profiles
    - foreach <yaml[liteprofiles_data].read[<[masteruuid]>].keys.exclude[active].exclude[<[masteruuid]>].if_null[<list[]>]> as:slaveuuid:
        - define slaveplayer <player[<[slaveuuid]>]>
        - define slavename <proc[character_get_name].context[<[slaveplayer]>]>
        - if <[slavename]> == null:
            - define slavename "Unnamed Character"
        - define slaveitem <item[emerald]>
        - adjust def:slaveitem display:<&f><[slavename]>
        - adjust def:slaveitem lore:<list[<&e>Alt Profile|<&f>|<&e>Offline Username:|<&f><[slaveplayer].name>.<[loop_index]>|<&f>|<&8>UUID:|<&8><[slaveuuid]>]>
        - definemap slave_entry:
            item: <[slaveitem]>
            script: liteprofilesutils_menu_use
            definitions:
                player: <[player]>
                value: <[slaveuuid]>
        - define all <[all].include[<[slave_entry]>]>
    # free slots
    - define remaining <[profilelimit].sub[<[profilecount]>]>
    - if <[remaining].is_more_than[0]>:
        - define freeitem <item[light_blue_dye]>
        - adjust def:freeitem "display:<&b>Free Slot"
        - adjust def:freeitem lore:<list[<&f>Click here to create a new profile|<&f>|<&7>You own <&e><[profilecount]><&7> out of <&e><[profilelimit]><&7> profiles]>
        - definemap free_entry:
            item: <[freeitem]>
            script: liteprofilesutils_menu_create
            definitions:
                player: <[player]>
                page: <[page]>
        - define all <[all].include[<[free_entry]>]>
        - repeat <[remaining].sub[1]>:
            - define unuseditem <item[gray_dye]>
            - adjust def:unuseditem "display:<&7>Free Slot"
            - define all <[all].include[<map[].with[item].as[<[unuseditem]>]>]>
    # paginate: 9 entries per page in slots 1-9, help on slot 10, navigation on slots 13 and 15
    - define contents <map[]>
    - define sublist <[all].get[<[page].mul[9].add[1]>].to[<[page].add[1].mul[9]>].if_null[<list[]>]>
    - foreach <[sublist]> as:entry:
        - define contents <[contents].with[<[loop_index]>].as[<[entry]>]>
    - definemap help_entry:
        10:
            item: <item[paper[display=<&6>How to use;lore=<&7>Your master profile is your original UUID (your main account).|<&7>You will see your other profiles in the menu. Click on any button|<&7>to change to that profile.|<&f>|<&7>You may also create new profiles if you have free slots.|<&7>You currently own <&e><[profilecount]><&7> out of <&e><[profilelimit]><&7> profiles. You may obtain more|<&7>with donation ranks or for animal characters.|<&f>|<&7>You can also use the specified offline player names in most|<&7>commands, and administrators may ask for the offline|<&7>username when you request a rank in game.]]>
    - define contents <[contents].include[<[help_entry]>]>
    - if <[page]> > 0:
        - definemap previous_entry:
            13:
                item: <item[ender_pearl[display=<&a><&lt><&lt>]]>
                script: liteprofilesutils_show_menu
                definitions:
                    player: <[player]>
                    page: <[page].sub[1]>
        - define contents <[contents].include[<[previous_entry]>]>
    - if <[page].add[1].mul[9]> < <[all].size>:
        - definemap next_entry:
            15:
                item: <item[ender_eye[display=<&a><&gt><&gt>]]>
                script: liteprofilesutils_show_menu
                definitions:
                    player: <[player]>
                    page: <[page].add[1]>
        - define contents <[contents].include[<[next_entry]>]>
    - run menu_open def.player:<[player]> def.title:<&f>邑邑邑邑鄈 def.size:18 def.contents:<[contents]>

liteprofilesutils_list_other:
    debug: false
    type: task
    definitions: player|target
    script:
    - ~run liteprofilesutils_load_data
    - define masteruuid <proc[liteprofilesutils_get_master_uuid].context[<[target]>]>
    - define section <yaml[liteprofiles_data].read[<[masteruuid]>].if_null[<map[]>]>
    - define active <[section].get[active].if_null[null]>
    - define slaveuuids <[section].keys.exclude[active].exclude[<[masteruuid]>].if_null[<list[]>]>
    - define masterplayer <player[<[masteruuid]>]>
    - narrate targets:<[player]> format:formats_prefix "Profiles of <&f><[masterplayer].name> <&7>(<[slaveuuids].size.add[1]> owned)"
    - foreach <list[<[masteruuid]>].include[<[slaveuuids]>]> as:uuid:
        - define account <player[<[uuid]>]>
        - define charname <proc[character_get_name].context[<[account]>].if_null[Unnamed Character]>
        - define prefix <proc[chat_roles_group].context[<[account]>]>
        - if <[uuid]> == <[masteruuid]>:
            - define role <&6>Master
        - else:
            - define role <&e>Alt
        - if <[uuid]> == <[active]>:
            - define role "<[role]> <&a>Active"
        - narrate targets:<[player]> "<&7>- <&f><[account].name>.<[loop_index].sub[1]> <&8>| <[prefix]> <&f><[charname]> <&8>(<[role]><&8>)"

liteprofilesutils_menu_use:
    debug: false
    type: task
    definitions: player|value
    script:
    - inventory close player:<[player]>
    - execute as_player "profile use <[value]>" player:<[player]>

liteprofilesutils_menu_create:
    debug: false
    type: task
    definitions: player|page
    script:
    - execute as_player "profile add" player:<[player]>
    - wait 20t
    - run liteprofilesutils_show_menu def.player:<[player]> def.page:<[page].if_null[0]>