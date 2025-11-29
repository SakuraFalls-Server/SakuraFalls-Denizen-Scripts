tabcomplete_fetch:
    debug: false
    type: procedure
    definitions: player
    script:
    - define result <list[]>
    - define data <script[tabcomplete_config].data_key[groups]>
    - foreach <[data]> key:group as:group_data:
        - if <[group]> == default || <[player].has_permission[<[group_data].get[permission].if_null[true]>]>:
            - define result <[result].include[<[group_data].get[commands].if_null[<list[]>]>]>
    - determine <[result]>
