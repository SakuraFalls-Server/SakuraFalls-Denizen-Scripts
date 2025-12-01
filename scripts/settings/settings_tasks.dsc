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

settings_all_settings_from_tab:
    debug: false
    type: procedure
    definitions: tab
    script:
    - define keys <script[settings_config].data_key[keys]>
    - define keys_in_tab <[keys].keys.filter_tag[<[keys].get[<[filter_value]>].get[tab].equals[<[tab]>]>]>
    - determine <[keys_in_tab]>

settings_all_settings_from_page_from_tab:
    debug: false
    type: procedure
    definitions: tab|page
    script:
    - define keys_in_tab <proc[settings_all_settings_from_tab].context[<[tab]>]>
    - define start_index <[page].mul[4].add[1]>
    - define end_index <[page].add[1].mul[4]>
    - determine <[keys_in_tab].get[<[start_index]>].to[<[end_index]>]>

settings_menu_is_last_page:
    debug: false
    type: procedure
    definitions: tab|page
    script:
    - define keys_in_tab <proc[settings_all_settings_from_tab].context[<[tab]>]>
    - define end_index <[page].add[1].mul[4]>
    - determine <[end_index].is_more_than_or_equal_to[<[keys_in_tab].size>]>

settings_menu:
    debug: false
    type: task
    definitions: player|tab|page
    script:
    - define keys <script[settings_config].data_key[keys]>
    - define tabs <script[settings_config].data_key[tabs]>
    - define tab <[tab].if_null[<[tabs].get[1]>]>
    - define page <[page].if_null[0]>
    - define contents <map[]>
    - if <[page]> > 0:
        - define previous_button <item[ender_pearl[display=<&2><&lt><&lt>]]>
        - definemap content_entry:
            49:
                item: <[previous_button]>
                script: settings_menu
                definitions:
                    player: <[player]>
                    tab: <[tab]>
                    page: <[page].sub[1]>
        - define contents <[contents].include[<[content_entry]>]>
    - if !<proc[settings_menu_is_last_page].context[<[tab]>|<[page]>]>:
        - define next_button <item[ender_eye[display=<&2><&gt><&gt>]]>
        - definemap content_entry:
            51:
                item: <[next_button]>
                script: settings_menu
                definitions:
                    player: <[player]>
                    tab: <[tab]>
                    page: <[page].add[1]>
        - define contents <[contents].include[<[content_entry]>]>
    - foreach <[tabs]> as:t:
        - define tab_button <item[book[display=<&b><[t]>]]>
        - definemap content_entry_value:
            item: <[tab_button]>
            script: settings_menu
            definitions:
                player: <[player]>
                tab: <[t]>
                page: 0
        - define content_entry <map[].with[<[loop_index]>].as[<[content_entry_value]>]>
        - define contents <[contents].include[<[content_entry]>]>
    - foreach <proc[settings_all_settings_from_page_from_tab].context[<[tab]>|<[page]>]> as:setting_key:
        - define setting_item <item[paper[display=<&3><[keys].get[<[setting_key]>].get[name]>]]>
        - definemap content_entry_value:
            item: <[setting_item]>
        - define content_entry <map[].with[<[loop_index].mul[9].add[1]>].as[<[content_entry_value]>]>
        - define contents <[contents].include[<[content_entry]>]>
    - run menu_open def.player:<[player]> def.title:Settings def.size:54 def.contents:<[contents]>
