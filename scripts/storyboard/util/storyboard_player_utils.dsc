#
# Storyboard Player Utils
# Various optional utils which tend to be pretty helpful.
#

# Gets the player character's first name (or what should be the first name).
storyboard_character_first_name:
    debug: false
    type: procedure
    definitions: player
    script:
    - determine <[player].flag[character_rpname].split.first.to_sentence_case.if_null[<&lt>?<&gt>]>

# Effectively like a permanent waituntil, except checks if player's online, etc.; if not, kills the queue.
storyboard_waituntil_safe:
    debug: false
    type: task
    definitions: player|queue|condition
    script:
    - while true:
        - define condition_parsed <element[<&lt><[condition]><&gt>].parsed>
        - if <[condition_parsed]> || !<[player].is_online>:
            - while stop
        - wait 10t
    - if !<[player].is_online>:
        - queue stop <[queue]>
        - debug log "[Storyboard] Cancelled queue <[queue].numeric_id><&at><[queue].script.name> for <[player].name>; offline"

# Resets as much as possible from the player.
storyboard_reset_dev_only:
    debug: false
    type: task
    script:
    - if <player.if_null[null]> == null:
        - stop
    - define registry registry_<player.uuid>
    - define npcs <server.npcs[<[registry]>].if_null[<list[]>]>
    - foreach <[npcs]> as:npc:
        - define assignment <[npc].scripts.get[1].data_key[interact scripts].get[1].if_null[null]>
        - if <[assignment]> != null:
            - zap <[assignment]> 1
    - flag <player> storyboard_reset_dev_only:true

storyboard_internal_reset_dev_only_world:
    debug: false
    type: world
    events:
        after player quits:
        - if <player.has_flag[storyboard_reset_dev_only]>:
            - flag <player> storyboard_state:!
            - flag <player> storyboard_reset_dev_only:!
        on player joins:
        - if <player.has_flag[storyboard_reset_dev_only]>:
            - flag <player> storyboard_reset_dev_only:!
