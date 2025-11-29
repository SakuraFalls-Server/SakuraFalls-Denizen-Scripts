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
    - adjust <player> walk_speed:<player.flag[storyboard_freeze_speed]>
    - flag <player> storyboard_freeze_speed:!

## Internal only!
storyboard_player_freeze_check:
    debug: false
    type: world
    events:
        on player joins:
        - if <player.has_flag[storyboard_freeze_speed]>:
            - run storyboard_player_unfreeze def.player:<player>
