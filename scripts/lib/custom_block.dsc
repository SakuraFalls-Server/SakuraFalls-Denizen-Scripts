#
# Custom Block - a lib/framework to create custom blocks with display entities easily.
# Note: this prioritizes being very fast even for many blocks, players, and without lag even on Vanilla.
# As a result, the range and scope of this is limited to that; you should *really* use note-blocks or
# tripwire block states for most things if you can help it. A mix of both is best!
#
# Historically, this was written purely in Denizen, however due to performance considerations a port is now
# maintained for Java. You will need to install the FastCustomBlock plugin first for this API to function.
# If you need the pure Denizen implementation, the latest complete version that works correctly with a
# performance cost can be found here in the Git history:
# https://github.com/SakuraFalls-Server/SakuraFalls-Denizen-Scripts/
#

custom_block_create:
    debug: false
    type: task
    # headless parameter is now ignored.
    definitions: at|material|pitch|yaw|headless
    script:
    - fastcustomblock <[at].with_pitch[<[pitch]>].with_yaw[<[yaw]>]> <[material]>

custom_block_destroy:
    debug: false
    type: task
    # headless parameter is now ignored.
    definitions: at|headless
    script:
    - fastcustomblock <[at]> cancel

custom_block_at:
    debug: false
    type: procedure
    definitions: at
    script:
    - determine <fastcustomblock[<[at].x>,<[at].y>,<[at].z>,<[at].world.name>].item.if_null[null]>

custom_block_migrate:
    debug: false
    type: task
    script:
    - if <server.has_flag[custom_block_migrate]>:
        - narrate "<&c>Cannot migrate. Migration already happened at <server.flag[custom_block_migrate].format>."
        - stop
    - flag server custom_block_migrate:<util.time_now>
    - define data_keys <server.flag_map.keys.filter_tag[<[filter_value].starts_with[custom_block]>]>
    - define size <[data_keys].size>
    - foreach <[data_keys]> as:key:
        - announce to_ops "[custom_block.dsc] Migrating chunk <[loop_index]> / <[size]> to FastCustomBlock."
        - define data <server.flag[<[key]>]>
        - foreach <[data]> as:cblock:
            - define split <[cblock].split[,]>
            - define world <[key].split[_].get[3].split[,].get[1]>
            - define x <[split].get[1]>
            - define y <[split].get[2]>
            - define z <[split].get[3]>
            - define pitch <[split].get[4]>
            - define yaw <[split].get[5]>
            - define item <[split].get[6]>
            - define at <location[<[x]>,<[y]>,<[z]>,<[pitch]>,<[yaw]>,<[world]>]>
            - run custom_block_create def.at:<[at]> def.material:<[item]> def.pitch:<[pitch]> def.yaw:<[yaw]> def.headless:unused
        - wait 5t
