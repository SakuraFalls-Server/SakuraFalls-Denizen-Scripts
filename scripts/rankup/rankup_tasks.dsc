# Needed because AutoRank likely has issues with LiteProfiles.
rankup_get_active_path_surely:
    debug: false
    type: procedure
    definitions: player
    script:
    - define activepath <placeholder[autorank_active_paths].player[<[player]>].if_null[null]>
    - if <[activepath]> == null:
        - if <[player].in_group[school-grade-10]>:
            - define activepath Grade11
        - else if <[player].in_group[school-grade-11]>:
            - define activepath Grade12
    - determine <[activepath]>

rankup_sync_school:
    debug: false
    type: task
    definitions: player
    script:
    - define activepath <proc[rankup_get_active_path_surely].context[<[player]>]>
    - define timeneeded <duration[<yaml[autorank_paths].read[<[activepath]>].get[requirements].get[time].get[value]>]>
    - define timepassed <duration[<yaml[autorank_totaltime].read[<[player].uuid>]>m]>
    - if <[timeneeded].is_more_than[<[timepassed]>]>:
        - if <[activepath]> == Grade11:
            - group remove school-grade-10 player:<[player]>
            - group add school-grade-11 player:<[player]>
        - else if <[activepath]> == Grade12:
            - group remove school-grade-11 player:<[player]>
            - group add school-grade-12 player:<[player]>
