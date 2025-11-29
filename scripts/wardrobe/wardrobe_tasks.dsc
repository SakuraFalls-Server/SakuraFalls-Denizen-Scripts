####
## TARGET LIBRARY UTILITY FOR FILLING HEADS IN GUI ASYNC
####

# asynchronously and slowly updates all player skulls in any inventory
# each skull you want to change has to be flagged with wardrobe_skull_texture:<[target].uuid>
wardrobe_skull_texture_update:
    debug: false
    type: task
    definitions: player
    speed: 2t
    script:
    - define inventory <[player].open_inventory>
    - foreach <[inventory].map_slots> key:slot as:item:
        - if <[item].has_flag[wardrobe_skull_texture]>:
            - if <[inventory].viewers.if_null[<list[]>].is_empty>:
                - stop
            - define texture <[item].flag[wardrobe_skull_texture]>
            - run wardrobe_skull_texture_update_single def.inventory:<[inventory]> def.slot:<[slot]> def.texture:<[texture]>
# dont use by itself - always use wardrobe_skull_texture_update
# creates a new queue to prevent overloading the main task
wardrobe_skull_texture_update_single:
    debug: false
    type: task
    definitions: inventory|slot|texture
    script:
    - inventory adjust slot:<[slot]> skull_skin:<[texture]> destination:<[inventory]>

##

wardrobe_max_skins:
    debug: false
    type: procedure
    definitions: player
    script:
    - define max 9
    - while <[max]> > 3:
        - if <[player].has_permission[wardrobe.skins.<[max]>]>:
            - determine <[max]>
        - define max <[max].sub[1]>
    - determine <[max]>

wardrobe_texture_decode:
    debug: false
    type: procedure
    definitions: skin_blob
    script:
    - determine <[skin_blob].split[;].get[1].base64_decode.substring[197,298]>

wardrobe_save_latest:
    debug: false
    type: task
    definitions: player
    script:
    - define latest_texture <proc[wardrobe_texture_decode].context[<[player].flag[wardrobe_latest]>]>
    - define textures <[player].flag[wardrobe_all].values.if_null[<list[]>]>
    - if <[textures].contains[<[latest_texture]>]>:
        - narrate targets:<[player]> "<&c>You already have your latest Minecraft skin saved in your wardrobe."
        - stop
    - flag <[player]> wardrobe_all:<[player].flag[wardrobe_all].if_null[<map[]>].with[<[player].flag[wardrobe_latest]>].as[<[latest_texture]>]>
    - narrate format:formats_prefix "Saved latest Minecraft skin in your wardrobe."

wardrobe_delete:
    debug: false
    type: task
    definitions: player|skin_blob
    script:
    - flag <[player]> wardrobe_all:<[player].flag[wardrobe_all].exclude[<[skin_blob]>]>
    - narrate format:formats_prefix "Deleted saved skin."

wardrobe_apply:
    debug: false
    type: task
    definitions: player|skin_blob
    script:
    - adjust <[player]> skin_blob:<[skin_blob]>
    - flag <[player]> wardrobe_current:<[skin_blob]>
    - narrate format:formats_prefix "Applied saved skin from wardrobe."

wardrobe_clear:
    debug: false
    type: task
    definitions: player
    script:
    - adjust <[player]> skin:<[player].name>
    - flag <[player]> wardrobe_current:!
    - narrate format:formats_prefix "Cleared current skin. You are now using your latest Minecraft skin instead."

wardrobe_menu:
    debug: false
    type: task
    definitions: player
    script:
    - define inventory <inventory[generic[size=54;title=<&f>邑邑邑邑鄇]]>
    #
    - define max <proc[wardrobe_max_skins].context[<[player]>]>
    - define position 31
    - define i 0
    - foreach <[player].flag[wardrobe_all].if_null[<map[]>]> key:skin_blob as:texture:
        - define skinitem <item[player_head]>
        - adjust def:skinitem "display:<&e>Skin #<[loop_index]>"
        - adjust def:skinitem lore:<list[<&7>Left click to <&a>apply|<&7>Right click to <&c>delete]>
        - flag <[skinitem]> wardrobe:<[skin_blob]>
        - flag <[skinitem]> wardrobe_skull_texture:<[skin_blob].split[;].get[1]>
        - inventory set slot:<[position]> origin:<[skinitem]> destination:<[inventory]>
        - define position <[position].add[1]>
        - define i <[i].add[1]>
        - if <[i].mod[3]> == 0:
        	- define position <[position].add[6]>
    - repeat <element[<[max]>].sub[<[i]>]>:
        - define unusedskin <item[wither_skeleton_skull]>
        - adjust def:unusedskin "display:<&7>Unused Skin Slot"
        - adjust def:unusedskin lore:<list[<&7>Click to <&e>save <&7>your latest Minecraft skin.]>
        - inventory set slot:<[position]> origin:<[unusedskin]> destination:<[inventory]>
        - define position <[position].add[1]>
        - define i <[i].add[1]>
        - if <[i].mod[3]> == 0:
        	- define position <[position].add[6]>
    #
    - define clearitem <item[warped_trapdoor]>
    - adjust def:clearitem "display:<&f>Clear Skin"
    - run gui_restore_set_later def.player:<[player]> def.slot:13 def.item:<[clearitem]>
    - run gui_restore_set_later def.player:<[player]> def.slot:14 def.item:<[clearitem]>
    - run gui_restore_set_later def.player:<[player]> def.slot:15 def.item:<[clearitem]>
    #
    - inventory open destination:<[inventory]>
    - run wardrobe_skull_texture_update def.player:<[player]>
