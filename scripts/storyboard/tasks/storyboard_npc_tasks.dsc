#
# Storyboard NPC Tasks
#
# Adds a complex set of per-player state managed NPC routines which
# allow for the creation of RPG-like stories, similar to Undertale.
#
# The routines and state system is also as memory efficient and lazy
# as possible. It utilizes Denizen and Citizens to their best, taking
# advantage of Denizen's innate scripting possibilites.
#

# Allocates an NPC with a given name at some location for the current player.
#
# Optionally, specify a display name, display name visibility, and a skin_blob.
# Generate Skin Blobs using https://mineskin.org - it cannot be done automatically
# at this time.
#
# If the NPC is reallocated from player state, it will try to re-fill these values.
# You can specify new values to change these.
# Note it will only try to fill these optional values, not "name", "type", and "at".
#
# The name of the NPC must be unique - this is not the same as the display
# name of the NPC; rather it is an internal name, so it's recommended to
# keep it lowercase.
#
# If the NPC is not allocated but was saved in the player's mem state, it
# will be created and its state will be restored.
# If the NPC is already allocated, it will simply teleport the NPC.
#
# All NPCs are memfree'd when a player leaves, which does not reduce storage
# overhead, but does greatly reduce overhead when hiding/showing per-player NPCs.
# They are automatically memalloc'ed when a player rejoins.
storyboard_npc_memalloc:
    debug: false
    type: task
    definitions: player|name|type|at|display_name|show_name|skin_blob
    script:
    - define registry registry_<[player].uuid>
    - define npc_id npc_<[player].uuid>_<[name]>
    - if !<server.npcs[<[registry]>].if_null[<list[]>].contains[<[npc_id]>]>:
        - define npcs <[player].flag[storyboard_state].get[npcs].if_null[<map[]>]>
        - create <[type]> <[npc_id]> <[at]> registry:<[registry]> save:npc
        - define npc <entry[npc].created_npc>
        - playeffect at:<[npc].location.above[1]> offset:0.35,1,0.35 effect:SOUL_FIRE_FLAME quantity:20
        - define npc_state <map[]>
        - define assignment null
        - if <[npcs].contains[<[name]>]>:
            - define npc_data <[npcs].get[<[name]>]>
            - define npc_state <[npc_data].get[state]>
            - if <[display_name].if_null[null]> == null:
                - define display_name <[npc_data].get[display_name]>
            - if <[show_name].if_null[null]> == null:
                - define show_name <[npc_data].get[show_name]>
            - if <[skin_blob].if_null[null]> == null:
                - define skin_blob <[npc_data].get[skin_blob]>
            - define assignment <[npc_data].get[assignment].if_null[null]>
        - else:
            - if <[display_name].if_null[null]> == null:
                - define display_name <[display_name].if_null[<[name].to_sentence_case>]>
            - if <[show_name].if_null[null]> == null:
                - define show_name <[show_name].if_null[true]>
            - if <[skin_blob].if_null[null]> == null:
                - define skin_blob <[skin_blob].if_null[null]>
        - definemap npc_data:
            name: <[name]>
            type: <[type]>
            at: <[at]>
            state: <[npc_state]>
            display_name: <[display_name]>
            show_name: <[show_name]>
            skin_blob: <[skin_blob]>
            allocated: true
            assignment: <[assignment]>
        - define npcs <[npcs].with[<[name]>].as[<[npc_data]>]>
        - flag <[player]> storyboard_state:<[player].flag[storyboard_state].if_null[<map[]>].with[npcs].as[<[npcs]>]>
        - adjust <[npc]> auto_update_skin:false
        - adjust <[npc]> name_visible:false
        - lookclose <[npc]> state:true range:4
        - if !<[show_name]>:
            - adjust <[npc]> hologram_lines:<list[]>
        - else:
            - adjust <[npc]> "hologram_lines:<&f>鐓 <[display_name]>"
        - if <[skin_blob]> != null:
            - adjust <[npc]> skin_blob:<[skin_blob]>
        - if <[assignment]> != null:
            - assignment set script:<[assignment]> to:<[npc]>
        - wait 2t
        - run storyboard_npc_internal_show_to_player def.player:<[player]> def.npc:<[npc]>
    - else:
        - define index <server.npcs[<[registry]>].find[<[npc_id]>]>
        - define npc <npc[<[index]>,<[registry]>]>
        - teleport <[npc]> <[at]>

# Retrieves an NPC from the player's unique NPC registry by name.
storyboard_npc_by_name:
    debug: false
    type: procedure
    definitions: player|name
    script:
    - define registry registry_<[player].uuid>
    - define npc_id npc_<[player].uuid>_<[name]>
    - determine <server.npcs[<[registry]>].filter_tag[<[filter_value].name.equals[<[npc_id]>]>].get[1]>

# Frees an NPC from memory, but does not destroy its state.
#
# This is often done automatically when the player leaves the server, however it may
# be useful for programmers to manually call this routine for optimization purposes.
#
# If you don't want the server to reallocate the NPC on player join, provide
# the reallocate definition as 'reallocate' (or just don't provide it).
storyboard_npc_memfree:
    debug: false
    type: task
    definitions: player|name|reallocate
    script:
    - define npc <proc[storyboard_npc_by_name].context[<[player]>|<[name]>]>
    - define reallocate <[reallocate].if_null[false]>
    - define npcs <[player].flag[storyboard_state].get[npcs].if_null[<map[]>]>
    - define npc_data <[npcs].get[<[name]>]>
    - define npc_data <[npc_data].with[allocated].as[<[reallocate]>]>
    - define npcs <[npcs].with[<[name]>].as[<[npc_data]>]>
    - flag <[player]> storyboard_state:<[player].flag[storyboard_state].if_null[<map[]>].with[npcs].as[<[npcs]>]>
    - remove <[npc]>

# Destroys an NPC from memory, which destroys its state.
# Further memalloc's will re-create the NPC with new state data.
# Use this when you are 100% done with using an NPC.
# If you only want to remove an NPC until later, but keep its state,
# consider calling storyboard_npc_memfree instead.
storyboard_npc_memdestroy:
    debug: false
    type: task
    definitions: player|name
    script:
    - define npcs <[player].flag[storyboard_state].get[npcs].if_null[<map[]>]>
    - define npcs <[npcs].exclude[<[name]>]>
    - flag <[player]> storyboard_state:<[player].flag[storyboard_state].if_null[<map[]>].with[npcs].as[<[npcs]>]>
    - define npc <proc[storyboard_npc_by_name].context[<[player]>|<[name]>]>
    - remove <[npc]>

# Checks if an NPC exists for the given player.
storyboard_npc_exists:
    debug: false
    type: procedure
    definitions: player|name
    script:
    - determine <proc[storyboard_npc_by_name].context[<[player]>|<[name]>].if_null[null].equals[null].not>

# Flags the NPC by name, mapping the given key to the given value.
storyboard_npc_state_set:
    debug: false
    type: task
    definitions: player|name|key|value
    script:
    - define npc <proc[storyboard_npc_by_name].context[<[player]>|<[name]>]>
    - define npcs <[player].flag[storyboard_state].get[npcs].if_null[<map[]>]>
    - define npc_data <[npcs].get[<[name]>]>
    - define state <[npc_data].get[state].if_null[<map[]>]>
    - define state <[state].with[<[key]>].as[<[value]>]>
    - define npc_data <[npc_data].with[state].as[<[state]>]>
    - define npcs <[npcs].with[<[name]>].as[<[npc_data]>]>
    - flag <[player]> storyboard_state:<[player].flag[storyboard_state].if_null[<map[]>].with[npcs].as[<[npcs]>]>

# Gets a state value from the NPC by name and key; effectively like reading a flag.
# If the given key does not exist/is not set, determines null.
storyboard_npc_state_get:
    debug: false
    type: procedure
    definitions: player|name|key
    script:
    - define npcs <[player].flag[storyboard_state].get[npcs].if_null[<map[]>]>
    - define npc_data <[npcs].get[<[name]>]>
    - define state <[npc_data].get[state].if_null[<map[]>]>
    - determine <[state].get[<[key]>].if_null[null]>

# Deletes a flag from the NPC by name and key.
storyboard_npc_state_clear:
    debug: false
    type: task
    definitions: player|name|key
    script:
    - define npc <proc[storyboard_npc_by_name].context[<[player]>|<[name]>]>
    - define npcs <[player].flag[storyboard_state].get[npcs].if_null[<map[]>]>
    - define npc_data <[npcs].get[<[name]>]>
    - define state <[npc_data].get[state].if_null[<map[]>]>
    - define state <[state].exclude[<[key]>]>
    - define npc_data <[npc_data].with[state].as[<[state]>]>
    - define npcs <[npcs].with[<[name]>].as[<[npc_data]>]>
    - flag <[player]> storyboard_state:<[player].flag[storyboard_state].if_null[<map[]>].with[npcs].as[<[npcs]>]>

# Sets an NPCs assignment, which also persists across memfrees.
storyboard_npc_set_assignment:
    debug: false
    type: procedure
    definitions: player|name|assignment
    script:
    - define npc <proc[storyboard_npc_by_name].context[<[player]>|<[name]>]>
    - define npcs <[player].flag[storyboard_state].get[npcs].if_null[<map[]>]>
    - define npc_data <[npcs].get[<[name]>]>
    - define npc_data <[npc_data].with[assignment].as[<[assignment]>]>
    - define npcs <[npcs].with[<[name]>].as[<[npc_data]>]>
    - flag <[player]> storyboard_state:<[player].flag[storyboard_state].if_null[<map[]>].with[npcs].as[<[npcs]>]>
    - assignment set script:<[assignment]> to:<[npc]>

# Moves an NPC to a new location, both physically, and in memory also.
# When an NPC is moved by normal teleports or the walk command, its location isn't stored.
# Use this to either commit its final position, or teleport it after a cutscene.
storyboard_npc_movement_commit:
    debug: false
    type: procedure
    definitions: player|name|new_location
    script:
    - define npc <proc[storyboard_npc_by_name].context[<[player]>|<[name]>]>
    - define npcs <[player].flag[storyboard_state].get[npcs].if_null[<map[]>]>
    - define npc_data <[npcs].get[<[name]>]>
    - define npc_data <[npc_data].with[at].as[<[new_location]>]>
    - define npcs <[npcs].with[<[name]>].as[<[npc_data]>]>
    - flag <[player]> storyboard_state:<[player].flag[storyboard_state].if_null[<map[]>].with[npcs].as[<[npcs]>]>
    - teleport <[npc]> <[new_location]>

## Internal only!
storyboard_npc_internal_auto_memory_management:
    debug: false
    type: world
    events:
        after player joins:
        - wait 1s
        - define npcs <player.flag[storyboard_state].get[npcs].if_null[<map[]>]>
        - foreach <[npcs]> key:name as:data:
            - define allocated  <[data].get[allocated].if_null[null]>
            - if <[allocated]> == reallocate || <[allocated]>:
                - define name <[data].get[name]>
                - define type <[data].get[type]>
                - define at <[data].get[at]>
                - run storyboard_npc_memalloc def.player:<player> def.name:<[name]> def.type:<[type]> def.at:<[at]>
        on player quits:
        - define registry registry_<player.uuid>
        - define npcs <server.npcs[<[registry]>].if_null[<list[]>]>
        - define substr_length <element[npc_<player.uuid>_].length.add[1]>
        - foreach <[npcs]> as:npc:
            - define name <[npc].name.substring[<[substr_length]>]>
            - run storyboard_npc_memfree def.player:<player> def.name:<[name]> def.reallocate:reallocate

storyboard_npc_internal_show_to_player:
    debug: false
    type: task
    definitions: player|npc
    script:
    - adjust <[npc]> hide_from_players
    - adjust <[player]> show_entity:<[npc]>
    - foreach <[npc].hologram_npcs.if_null[<list[]>]> as:hologram:
        - adjust <[hologram]> hide_from_players
        - adjust <[player]> show_entity:<[hologram]>

storyboard_npc_internal_auto_display_entities:
    debug: false
    type: world
    events:
        after player joins bukkit_priority:high:
        - wait 1t
        - foreach <server.online_players.exclude[<player>]> as:target:
            - define registry registry_<[target].uuid>
            - define npcs <server.npcs[<[registry]>].if_null[<list[]>]>
            - foreach <[npcs]> as:npc:
                - adjust <player> hide_entity:<[npc]>
                - foreach <[npc].hologram_npcs.if_null[<list[]>]> as:hologram:
                    - adjust <player> hide_entity:<[hologram]>