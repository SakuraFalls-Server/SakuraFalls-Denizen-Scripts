#
# Storyboard Player Tasks
#
# Adds a set of tasks for managing player storyboard state.
# Pretty common in use.
#
# Note: These actions are **committed** - so should be executed LAST in a script.
# This allows the actions to "rollback" in case the server crashes/player disconnects.
#

# Sets a named key to any value in the player state.
storyboard_player_state_set:
    debug: false
    type: task
    definitions: player|key|value
    script:
    - define state <[player].flag[storyboard_state].get[state].if_null[<map[]>]>
    - define state <[state].with[<[key]>].as[<[value]>]>
    - flag <[player]> storyboard_state:<[player].flag[storyboard_state].if_null[<map[]>].with[state].as[<[state]>]>
    - adjust server save

# Removes a named key from player state.
# If the key doesn't exist, silently fails.
storyboard_player_state_clear:
    debug: false
    type: task
    definitions: player|key
    script:
    - define state <[player].flag[storyboard_state].get[state].if_null[<map[]>]>
    - define state <[state].exclude[<[key]>]>
    - flag <[player]> storyboard_state:<[player].flag[storyboard_state].if_null[<map[]>].with[state].as[<[state]>]>
    - adjust server save

# Gets a named key from player state.
# If the key doesn't exist, "null" is returned.
storyboard_player_state_get:
    debug: false
    type: procedure
    definitions: player|key
    script:
    - define state <[player].flag[storyboard_state].get[state].if_null[<map[]>]>
    - determine <[state].get[<[key]>].if_null[null]>

# Freezes a player in place by setting their speed to 0.
# On relogs, automatically 'unfreezes' them.
# See the complementary task storyboard_player_unfreeze
storyboard_player_freeze:
    debug: false
    type: task
    definitions: player
    script:
    - flag <player> storyboard_freeze_speed:<player.walk_speed>
    - adjust <player> walk_speed:0

# Unfreezes a player. Always happens automatically on relogs.
# See the complementary task storyboard_player_freeze
storyboard_player_unfreeze:
    debug: false
    type: task
    definitions: player
    script:
    - adjust <player> walk_speed:<player.flag[storyboard_freeze_speed].if_null[0.2]>
    - flag <player> storyboard_freeze_speed:!

# Marks the script after this task as an atomic sequence, meaning that
# the script either fully completes or is restored back to this point.
# This task does not ensure the atomicity, instead it will block any
# futher executions of the given script (deduced from the queue) until
# storyboard_player_end_atomic_sequence is called, or until the player
# logs off (which basically negates the atomicity). The developer must
# ensure that the script enclosed by the begin and end tasks is atomic.
storyboard_player_begin_atomic_sequence:
    debug: false
    type: task
    definitions: queue|player
    script:
    - if <[player].flag[storyboard_atomic].if_null[<map[]>].contains[<[queue].script.name>]>:
        - queue <[queue]> stop
        - stop
    - flag <[player]> storyboard_atomic:<[player].flag[storyboard_atomic].if_null[<map[]>].with[<[queue].script.name>].as[<util.time_now>]>
    - adjust server save

# Ends the atomic sequence above this task. See the sibling task
# storyboard_player_begin_atomic_sequence for more details.
storyboard_player_end_atomic_sequence:
    debug: false
    type: task
    definitions: queue|player
    script:
    - if !<[player].flag[storyboard_atomic].if_null[<map[]>].contains[<[queue].script.name>]>:
        - debug error "Tried ending storyboard atomic sequence <[queue].script.name> before storyboard_player_begin_atomic_sequence was called! (Player UUID <[player].uuid>)"
        - stop
    - waituntil !<player.has_flag[textbox_state]>
    - wait 5t
    - flag <[player]> storyboard_atomic:<[player].flag[storyboard_atomic].if_null[<map[]>].exclude[<[queue].script.name>]>
    - adjust server save

## Internal only!
storyboard_player_freeze_check:
    debug: false
    type: world
    events:
        on player joins:
        - if <player.has_flag[storyboard_freeze_speed]>:
            - run storyboard_player_unfreeze def.player:<player>

storyboard_player_atomic_sequence_disconnect_handler:
    debug: false
    type: world
    events:
        on player quit:
        - flag <player> storyboard_atomic:!
        on player joins:
        - flag <player> storyboard_atomic:!
