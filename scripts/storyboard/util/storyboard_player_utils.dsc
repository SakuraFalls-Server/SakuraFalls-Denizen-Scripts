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