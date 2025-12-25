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

settings_menu_set_non_text:
    debug: false
    type: task
    definitions: player|key|value|tab|page
    script:
    - run settings_set def.player:<[player]> def.key:<[key]> def.value:<[value]> save:result
    - define error <entry[result].created_queue.determination.get[1].if_null[null]>
    - if <[error]> == null:
        - run settings_menu def.player:<[player]> def.tab:<[tab]> def.page:<[page]>
    - else:
        - narrate targets:<[player]> <&c><[error]>

settings_menu_set_text_callback:
    debug: false
    type: task
    definitions: player|input
    script:
    - define temp_state <[player].flag[settings_menu_temp_state]>
    - run settings_set def.player:<[player]> def.key:<[temp_state].get[key]> def.value:<[input]> save:result
    - define error <entry[result].created_queue.determination.get[1].if_null[null]>
    - if <[error]> != null:
        - narrate targets:<[player]> <&c><[error]>
    - wait 4t
    - run settings_menu def.player:<[player]> def.tab:<[temp_state].get[tab]> def.page:<[temp_state].get[page]>

settings_menu_set_text_helper:
    debug: false
    type: task
    definitions: player|key|tab|page
    script:
    - definemap temp_state:
        key: <[key]>
        tab: <[tab]>
        page: <[page]>
    - flag <[player]> settings_menu_temp_state:<[temp_state]>
    - run anvil_input def.player:<[player]> "def.prompt:New value" def.callback:settings_menu_set_text_callback

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
        - inject settings_menu_previous_page
    - if !<proc[settings_menu_is_last_page].context[<[tab]>|<[page]>]>:
        - inject settings_menu_next_page
    - inject settings_menu_render_tabs
    - inject settings_menu_render_settings
    - run menu_open def.player:<[player]> def.title:<&f>邑邑邑邑酕<&a><&sp><&b><&sp><&c><&sp> def.size:54 def.contents:<[contents]>

settings_menu_previous_page:
    debug: false
    type: task
    script:
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

settings_menu_next_page:
    debug: false
    type: task
    script:
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

settings_menu_render_tabs:
    debug: false
    type: task
    script:
    - foreach <[tabs]> as:t:
        - define tab_button <item[<tern[<[t].equals[<[tab]>]>].pass[enchanted_book].fail[book]>[display=<&b><[t]>]]>
        - definemap content_entry_value:
            item: <[tab_button]>
            script: settings_menu
            definitions:
                player: <[player]>
                tab: <[t]>
                page: 0
        - define content_entry <map[].with[<[loop_index]>].as[<[content_entry_value]>]>
        - define contents <[contents].include[<[content_entry]>]>

settings_menu_render_settings:
    debug: false
    type: task
    script:
    - foreach <proc[settings_all_settings_from_page_from_tab].context[<[tab]>|<[page]>]> as:setting_key:
        - define setting_item <item[paper[display=<&3><[keys].get[<[setting_key]>].get[name]>;lore=<[keys].get[<[setting_key]>].get[description].split_lines_by_width[<[keys].get[<[setting_key]>].get[name].text_width>].split[<&nl>].parse_tag[<&7><[parse_value]>]>]]>
        - definemap content_entry_value:
            item: <[setting_item]>
        - define position <[loop_index].mul[9].add[1]>
        - define content_entry <map[].with[<[position]>].as[<[content_entry_value]>]>
        - define data <[keys].get[<[setting_key]>]>
        - define type <[data].get[type]>
        - choose <[type].to_lowercase>:
            - case boolean:
                - inject settings_menu_render_settings_boolean
            - case number:
                - inject settings_menu_render_settings_number
            - case list:
                - inject settings_menu_render_settings_list
            - case text:
                - inject settings_menu_render_settings_text
            - default:
                - debug error "Unknown setting type for <[setting_key]>"
                - stop
        - define contents <[contents].include[<[content_entry]>]>

settings_menu_render_settings_boolean:
    debug: false
    type: task
    script:
    - define value <proc[settings_get].context[<[player]>|<[setting_key]>]>
    - define boolean_value_button <tern[<[value]>].pass[<item[emerald[display=<&2>On]]>].fail[<item[redstone[display=<&c>Off]]>]>
    - definemap content_entry_value:
        item: <[boolean_value_button]>
        script: settings_menu_set_non_text
        definitions:
            player: <[player]>
            key: <[setting_key]>
            value: <[value].not>
            tab: <[tab]>
            page: <[page]>
    - define content_entry <[content_entry].with[<[position].add[8]>].as[<[content_entry_value]>]>

settings_menu_render_settings_number:
    debug: false
    type: task
    script:
    - define value <proc[settings_get].context[<[player]>|<[setting_key]>]>
    - define increment <[data].get[increment]>
    - define decrement_button <item[medium_amethyst_bud[display=<&9>-<[increment]>]]>
    - define increment_button <item[amethyst_cluster[display=<&9>+<[increment]>]]>
    - define value_item <item[name_tag[display=<&9><[value]>]]>
    - definemap content_entry_value:
        item: <[decrement_button]>
        script: settings_menu_set_non_text
        definitions:
            player: <[player]>
            key: <[setting_key]>
            value: <[value].sub[<[increment]>]>
            tab: <[tab]>
            page: <[page]>
    - define content_entry <[content_entry].with[<[position].add[6]>].as[<[content_entry_value]>]>
    - definemap content_entry_value:
        item: <[increment_button]>
        script: settings_menu_set_non_text
        definitions:
            player: <[player]>
            key: <[setting_key]>
            value: <[value].add[<[increment]>]>
            tab: <[tab]>
            page: <[page]>
    - define content_entry <[content_entry].with[<[position].add[8]>].as[<[content_entry_value]>]>
    - definemap content_entry_value:
        item: <[value_item]>
    - define content_entry <[content_entry].with[<[position].add[7]>].as[<[content_entry_value]>]>

settings_menu_render_settings_list:
    debug: false
    type: task
    script:
    - define value <proc[settings_get].context[<[player]>|<[setting_key]>]>
    - define values <[data].get[values]>
    - define index <[values].find[<[value]>]>
    - define previous_button <item[medium_amethyst_bud[display=<&9>Previous]]>
    - define next_button <item[amethyst_cluster[display=<&9>Next]]>
    - define value_item <item[name_tag[display=<&9><[value]>]]>
    - definemap content_entry_value:
        item: <[previous_button]>
        script: settings_menu_set_non_text
        definitions:
            player: <[player]>
            key: <[setting_key]>
            value: <tern[<[index].equals[1]>].pass[<[values].get[-1]>].fail[<[values].get[<[index].sub[1]>]>]>
            tab: <[tab]>
            page: <[page]>
    - define content_entry <[content_entry].with[<[position].add[6]>].as[<[content_entry_value]>]>
    - definemap content_entry_value:
        item: <[next_button]>
        script: settings_menu_set_non_text
        definitions:
            player: <[player]>
            key: <[setting_key]>
            value: <tern[<[index].equals[<[values].size>]>].pass[<[values].get[1]>].fail[<[values].get[<[index].add[1]>]>]>
            tab: <[tab]>
            page: <[page]>
    - define content_entry <[content_entry].with[<[position].add[8]>].as[<[content_entry_value]>]>
    - definemap content_entry_value:
        item: <[value_item]>
    - define content_entry <[content_entry].with[<[position].add[7]>].as[<[content_entry_value]>]>

settings_menu_render_settings_text:
    debug: false
    type: task
    script:
    - define value <proc[settings_get].context[<[player]>|<[setting_key]>]>
    - define value_item <item[name_tag[display=<&9><[value]>]]>
    - define change_button <item[writable_book[display=<&9>Change]]>
    - definemap content_entry_value:
        item: <[change_button]>
        script: settings_menu_set_text_helper
        definitions:
            player: <[player]>
            key: <[setting_key]>
            tab: <[tab]>
            page: <[page]>
    - define content_entry <[content_entry].with[<[position].add[8]>].as[<[content_entry_value]>]>
    - definemap content_entry_value:
        item: <[value_item]>
    - define content_entry <[content_entry].with[<[position].add[7]>].as[<[content_entry_value]>]>