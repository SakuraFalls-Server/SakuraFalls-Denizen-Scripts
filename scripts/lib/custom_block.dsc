#
# Custom Block - a lib/framework to create custom blocks with display entities easily.
# Note: this prioritizes being very fast even for many blocks, players, and without lag even on Vanilla.
# As a result, the range and scope of this is limited to that; you should *really* use note-blocks or
# tripwire block states for most things if you can help it. A mix of both is best!
#
# You should change the computations to handle more chunks instead of just a 3x3 area if you don't expect
# too many players, if your CPU is particularly powerful and fast, and if you don't mind client-side lag.
#
# This library will automatically "render" only the custom blocks in a certain range around the player.
# By default, this is a 3x3 chunk area around the player; the item displays have a 0.75 view-range.
# This will not show the custom entities particularly far, but it will ensure very good FPS & TPS.
# The algorithm should be fairly fast, especially for Denizen; likely a pure Java algorithm would
# have better performance but not by much, since the `fakespawn` and `flag` utils of Denizen are
# hard to beat.
#

# API
custom_block_create:
    debug: false
    type: task
    definitions: at|material|pitch|yaw|headless
    script:
    - define pitch <[pitch].if_null[0]>
    - define yaw <[yaw].if_null[0]>
    - define world <[at].world.name>
    - define chunk_x <[at].chunk.x>
    - define chunk_z <[at].chunk.z>
    #
    - define entry_key custom_block_<[world]>,<[chunk_x]>,<[chunk_z]>
    - define at <[at].center>
    - define where <[at].x>,<[at].y>,<[at].z>
    - define value_key <[where]>,<[pitch]>,<[yaw]>,<[material]>
    #
    - define block_set <server.flag[<[entry_key]>].if_null[<list[]>]>
    - if <[block_set].filter_tag[<[filter_value].starts_with[<[where]>]>].size> > 0:
        - debug error "[Custom Block Lib] Duplicate block add: <[where]>,<[world]>! Call custom_block_destroy first"
        - stop
    - define block_set <[block_set].include[<[value_key]>]>
    - flag server <[entry_key]>:<[block_set]>
    #
    - if <[headless].if_null[false]>:
        - stop
    - define players <list[]>
    - repeat 3 from:<[chunk_x].sub[1]> as:i:
        - repeat 3 from:<[chunk_z].sub[1]> as:k:
            - define chunk <chunk[<[i]>,<[k]>,<[world]>]>
            - foreach <[chunk].players> as:player:
                - define players <[players].include[<[player]>].deduplicate>
    - foreach <[players]> as:player:
        - run custom_block_render def.player:<[player]>

custom_block_destroy:
    debug: false
    type: task
    definitions: at|headless
    script:
    - define world <[at].world.name>
    - define chunk_x <[at].chunk.x>
    - define chunk_z <[at].chunk.z>
    - define entry_key custom_block_<[world]>,<[chunk_x]>,<[chunk_z]>
    #
    - define at <[at].center>
    - define where <[at].x>,<[at].y>,<[at].z>
    #
    - define block_set <server.flag[<[entry_key]>].if_null[<list[]>]>
    - define block_set_length <[block_set].size>
    - define block_set <[block_set].filter_tag[<[filter_value].starts_with[<[where]>].not>]>
    - if <[block_set].size> == <[block_set_length]>:
        - debug error "[Custom Block Lib] Tried removing inexistent custom block: <[where]>,<[world]>"
        - stop
    - if <[block_set].size> == 0:
        - flag server <[entry_key]>:!
    - else:
        - flag server <[entry_key]>:<[block_set]>
    #
    - if <[headless].if_null[false]>:
        - stop
    - define players <list[]>
    - repeat 3 from:<[chunk_x].sub[1]> as:i:
        - repeat 3 from:<[chunk_z].sub[1]> as:k:
            - define chunk <chunk[<[i]>,<[k]>,<[world]>]>
            - foreach <[chunk].players> as:player:
                - define players <[players].include[<[player]>].deduplicate>
    - foreach <[players]> as:player:
        - run custom_block_render def.player:<[player]>

custom_block_at:
    debug: false
    type: procedure
    definitions: at
    script:
    - define world <[at].world.name>
    - define chunk_x <[at].chunk.x>
    - define chunk_z <[at].chunk.z>
    - define entry_key custom_block_<[world]>,<[chunk_x]>,<[chunk_z]>
    #
    - define at <[at].center>
    - define where <[at].x>,<[at].y>,<[at].z>
    #
    - if !<server.has_flag[<[entry_key]>]>:
        - determine null
    - define block_set <server.flag[<[entry_key]>]>
    - foreach <[block_set]> as:cblock:
        - if <[cblock].starts_with[<[where]>]>:
            - determine <[cblock].split[,].get[6]>
    - determine null

# Render routine
custom_block_flush:
    debug: false
    type: task
    definitions: player|complete
    script:
    - define complete <[complete].if_null[false]>
    - define prerendered <[player].flag[custom_block_prerendered].if_null[<map[]>]>
    - if <[complete]>:
        - foreach <[player].fake_entities> as:fentity:
            - if <[fentity].custom_name.contains[__CustomBlock__].if_null[false]>:
                - fakespawn <[fentity]> cancel player:<[player]>
    - else:
        - foreach <[player].fake_entities> as:fentity:
            - if <[fentity].custom_name.contains[__CustomBlock__].if_null[false]>:
                - if !<[prerendered].contains[<[fentity].location.escaped>]>:
                    - fakespawn <[fentity]> cancel player:<[player]>

custom_block_render:
    debug: false
    type: task
    definitions: player
    script:
    - define world <[player].location.world.name>
    - define chunk_x <[player].location.chunk.x>
    - define chunk_z <[player].location.chunk.z>
    - define player_y <[player].location.y>
    - flag <[player]> custom_block_lrx:<[chunk_x]>
    - flag <[player]> custom_block_lrz:<[chunk_z]>
    - flag <[player]> custom_block_lry:<[player_y]>
    - define prerendered <[player].flag[custom_block_prerendered].if_null[<map[]>]>
    - define valid <map[]>
    - repeat 3 from:<[chunk_x].sub[1]> as:i:
        - repeat 3 from:<[chunk_z].sub[1]> as:k:
            - define entry_key custom_block_<[world]>,<[i]>,<[k]>
            - if <server.has_flag[<[entry_key]>]>:
                - foreach <server.flag[<[entry_key]>]> as:cblock:
                    - define cblock <[cblock].split[,]>
                    - if <[cblock].get[2].sub[<[player_y]>].abs> > 24:
                        - foreach next
                    - define at <location[<[cblock].get[1]>,<[cblock].get[2]>,<[cblock].get[3]>,<[cblock].get[4]>,<[cblock].get[5]>,<[world]>]>
                    - define valid <[valid].with[<[at].escaped>].as[true]>
                    - if <[prerendered].contains[<[at].escaped>]>:
                        - foreach next
                    - define of <[cblock].get[6]>
                    - define display <entity[item_display]>
                    - adjust def:display item:<item[<[of]>]>
                    - adjust def:display display:fixed
                    - adjust def:display view_range:0.75
                    - adjust def:display custom_name:__CustomBlock__
                    - fakespawn <[display]> <[at]> player:<[player]> duration:-1
                    - define prerendered <[prerendered].with[<[at].escaped>].as[true]>
    - define prerendered <[prerendered].filter_tag[<[valid].contains[<[filter_key]>]>]>
    - flag <[player]> custom_block_prerendered:<[prerendered]>
    - run custom_block_flush def.player:<[player]>

custom_block_world:
    debug: false
    type: world
    events:
        after player joins:
        - flag <player> custom_block_prerendered:!
        - run custom_block_flush def.player:<player> def.complete:true
        - ~run custom_block_render def.player:<player>
        on player walks:
        - ratelimit <player> 5t
        - if <player.flag[custom_block_lrx].if_null[0]> == <context.new_location.chunk.x>:
            - if <player.flag[custom_block_lrz].if_null[0]> == <context.new_location.chunk.z>:
                - if <player.flag[custom_block_lry].if_null[0].sub[<context.new_location.y>].abs> <= 8:
                    - stop
        - ~run custom_block_render def.player:<player>
