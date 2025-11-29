settings_set:
    debug: false
    type: task
    definitions: player|key|value
    script:
    - define keys <script[settings_config].data_key[keys]>
    - if !<[keys].contains[<[key]>]>:
        - determine "Key not found: <[key]>"
    - if <[value]> == null:
        - determine "Value cannot be null"
    - define data <[keys].get[<[key]>]>
    - define type <[data].get[type]>
    - choose <[type].to_lowercase>:
        - case boolean:
            - if <[value]> != true && <[value]> != false:
                - determine "Value must be true or false"
        - case number:
            - define min <[data].get[min]>
            - define max <[data].get[max]>
            - if <[value]> < <[min]> || <[value]> > <[max]>:
                - determine "Value must be between <[min]> and <[max]>"
        - case list:
            - define values <[data].get[values]>
            - if !<[values].contains[<[value]>]>:
                - determine "Value must be one of the following: <[values].formatted>"
        - case text:
            - define max_length <[data].get[max-length]>
            - define regex <[data].get[regex]>
            - if <[value].length> > <[max_length]>:
                - determine "Value must be shorter than <[max_length]> characters"
            - if !<[value].regex_matches[<[regex]>]>:
                - determine "Value should match the regex <[regex]>"
        - default:
            - determine "Unknown type <[type]>"
    - define settings <[player].flag[settings].if_null[<map[]>]>
    - define settings <[settings].with[<[key]>].as[<[value]>]>
    - flag <[player]> settings:<[settings]>

settings_get:
    debug: false
    type: procedure
    definitions: player|key
    script:
    - define keys <script[settings_config].data_key[keys]>
    - if !<[keys].contains[<[key]>]>:
        - determine null
    - define settings <[player].flag[settings].if_null[<map[]>]>
    - define value <[settings].get[<[key]>].if_null[<[keys].get[<[key]>].get[default]>]>
    - determine <[value]>
