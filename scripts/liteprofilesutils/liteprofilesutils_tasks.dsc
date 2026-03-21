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
    - determine <placeholder[liteprofiles_masteruuid].player[<[player]>]>

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
    - determine <placeholder[liteprofiles_count].player[<[player]>].sub[1]>

liteprofilesutils_show_menu:
    debug: false
    type: task
    definitions: player
    script:
    - ~run liteprofilesutils_load_data
    - define masteruuid <proc[liteprofilesutils_get_master_uuid].context[<[player]>]>
    - define profilelimit <proc[liteprofilesutils_get_profile_limit].context[<[player]>]>
    - define profilecount <proc[liteprofilesutils_get_profile_count].context[<[player]>]>
    - define contents <list[]>
    # master uuid
    - define masteritem <item[emerald_block]>
    - define mastername <proc[character_get_name].context[<player[<[masteruuid]>]>]>
    - if <[mastername]> == null:
        - define mastername "Unnamed Character"
    - adjust def:masteritem display:<&f><[mastername]>
    - adjust def:masteritem lore:<list[<&6>Master Profile|<&f>|<&8>UUID:|<&8><[masteruuid]>]>
    - flag <[masteritem]> liteprofiles:<map[].with[type].as[master].with[value].as[<[masteruuid]>]>
    - define contents <[contents].include[<[masteritem]>]>
    # slave uuids
    - define sortedslaveitems <list[]>
    - foreach <yaml[liteprofiles_data].read[<[masteruuid]>].keys.exclude[active].exclude[<[masteruuid]>]> as:slaveuuid:
        - define slaveitem <item[emerald]>
        - define slavename <proc[character_get_name].context[<player[<[slaveuuid]>]>]>
        - if <[slavename]> == null:
            - define slavename "Unnamed Character"
        - adjust def:slaveitem display:<&f><[slavename]>
        - adjust def:slaveitem lore:<list[<&e>Alt Profile|<&f>|<&8>UUID:|<&8><[slaveuuid]>]>
        - flag <[slaveitem]> liteprofiles:<map[].with[type].as[slave].with[value].as[<[slaveuuid]>]>
        - define sortedslaveitems <[sortedslaveitems].include[<[slaveitem]>]>
    - define sortedslaveitems <[sortedslaveitems].sort_by_value[display]>
    - define contents <[contents].include[<[sortedslaveitems]>]>
    # free slots
    - if <[profilecount]> < <[profilelimit].sub[1]>:
        - define freeitem <item[light_blue_dye]>
        - adjust def:freeitem "display:<&b>Free Slot"
        - adjust def:freeitem lore:<list[<&f>Click here to create a new profile]>
        - flag <[freeitem]> liteprofiles:<map[].with[type].as[free]>
        - define contents <[contents].include[<[freeitem]>]>
    - repeat <[profilelimit].sub[<[profilecount]>].sub[2]>:
        - define unuseditem <item[gray_dye]>
        - adjust def:unuseditem "display:<&7>Free Slot"
        - define contents <[contents].include[<[unuseditem]>]>
    # show
    - run liteprofiles_legacy_menus_open def.player:<[player]> def.id:liteprofiles def.page:0 def.contents:<[contents]>

# # # # # # # # # # # # # # # # # # # # # # # # #
# LEGACY MENU LIBRARY PROVIDED IN LITEPROFILES  #
# # # # # # # # # # # # # # # # # # # # # # # # #
# buttons
liteprofiles_legacy_menus_button_previous:
    debug: false
    type: item
    material: ender_pearl
    display name: <&a><&lt><&lt>

liteprofiles_legacy_menus_button_next:
    debug: false
    type: item
    material: ender_eye
    display name: <&a><&gt><&gt>

# generate menu
liteprofiles_legacy_menus_open:
    debug: false
    type: task
    definitions: player|id|page|contents
    script:
    - define inventory <inventory[generic[title=<&f>邑邑邑邑鄈;size=18]]>
    - foreach <[contents].get[<[page].mul[9].add[1]>].to[<[page].add[1].mul[9]>].if_null[<list[]>]> as:item:
        - inventory set origin:<[item]> destination:<[inventory]> slot:<[loop_index]>
    - if <[page]> > 0:
        - inventory set origin:<item[liteprofiles_legacy_menus_button_previous]> destination:<[inventory]> slot:13
    - if <[contents].size> > <[page].add[1].mul[9]>:
        - inventory set origin:<item[liteprofiles_legacy_menus_button_next]> destination:<[inventory]> slot:15
    - flag <[player]> liteprofiles_legacy_menu:<map[].with[id].as[<[id]>].with[page].as[<[page]>].with[contents].as[<[contents]>]>
    - define profilelimit <proc[liteprofilesutils_get_profile_limit].context[<[player]>]>
    - inventory set origin:<item[paper[display=<&6>How to use;lore=<&7>Your master profile is your original UUID (your main account).|<&7>You will see your other profiles in the menu. Click on any button|<&7>to change to that profile.|<&f>|<&7>You may also create new profiles if you have free slots.|<&7>You currently own <&e><[profilelimit]> profiles<&7>. You may obtain more|<&7>with donation ranks or for animal characters.]]> destination:<[inventory]> slot:10
    - inventory open player:<[player]> destination:<[inventory]>

# menu button handler
liteprofiles_legacy_menus_button_handler:
    debug: false
    type: world
    events:
        on player clicks in inventory:
        - if <context.inventory.title> != <&f>邑邑邑邑鄈:
            - stop
        - determine cancelled passively
        # if air ignore, means button doesnt exist or is to be handled elsewhere
        # 13 prev 15 next everything else ignore
        - if <context.slot> == 13:
            - if <context.item.material.advanced_matches[ender_pearl]>:
                - define data <player.flag[liteprofiles_legacy_menu]>
                - run liteprofiles_legacy_menus_open def.player:<player> def.id:<[data].get[id]> def.page:<[data].get[page].sub[1]> def.contents:<[data].get[contents]>
        - if <context.slot> == 15:
            - if <context.item.material.advanced_matches[ender_eye]>:
                - define data <player.flag[liteprofiles_legacy_menu]>
                - run liteprofiles_legacy_menus_open def.player:<player> def.id:<[data].get[id]> def.page:<[data].get[page].add[1]> def.contents:<[data].get[contents]>