#
# Textbox - a lib/framework to display an Undertale/RPG style text box.
# Requires resource pack to be set up correctly.
# The magic character is U+9300, i.e 錀, which you can change in the code.
#

# Writes into the text box display.
# You should provide at most 3 lines into the textbox (though other values are technically allowed).
# Lines are split using $$nl: line3s should be simple text, not a list directly.
# Optionally, provide an avatar_unicode character that should be placed next to the textbox.
textbox_write:
    debug: false
    type: task
    definitions: player|queue|line3s|avatar_unicode
    script:
    - define avatar_unicode <[avatar_unicode].if_null[null]>
    - if <[player].flag[textbox_state].if_null[null]> == writing:
        - stop
    - if !<[player].is_online>:
        - if <[queue].if_null[null]> != null:
            - debug log "[Textbox] Write; cancelled queue <[queue].numeric_id><&at><[queue].script.name> for <[player].name>; offline player."
            - queue stop <[queue]>
            - run textbox_flush def.player:<[player]>
        - stop
    - if !<[player].is_on_ground> && <player.gamemode> != spectator:
        - if <[player].location.below.material.is_solid>:
            - teleport <[player]> <[player].location.below.above.with_y[<[player].location.below.above.y.round_down>]>
        - else:
            - stop
    - waituntil <[player].flag[textbox_state].if_null[null]> == null max:5s
    - ~run textbox_flush def.player:<[player]>
    - if !<[player].is_online>:
        - if <[queue].if_null[null]> != null:
            - debug log "[Textbox] Write; cancelled queue <[queue].numeric_id><&at><[queue].script.name> for <[player].name>; offline player."
            - queue stop <[queue]>
            - run textbox_flush def.player:<[player]>
        - stop
    - define lines <[line3s].split[$$nl].parse_tag[<[parse_value].trim>]>
    - flag <[player]> textbox_state:writing
    - flag <[player]> textbox_input:<[lines]>
    - flag <[player]> textbox_lines:<[lines].size>
    - bossbar create textbox_<[player].uuid>_ui players:<[player]> title:錀
    - bossbar create textbox_<[player].uuid>_1 players:<[player]> title:<empty>
    - bossbar create textbox_<[player].uuid>_2 players:<[player]> title:<empty>
    - bossbar create textbox_<[player].uuid>_3 players:<[player]> title:<empty>
    - wait 1t
    - if <[avatar_unicode]> != null:
        - bossbar create textbox_<[player].uuid>_avatar players:<[player]> title:<element[ ].repeat[64]><[avatar_unicode]>
    - foreach <[lines]> as:line:
        - if <[player].flag[textbox_state].if_null[null]> != writing:
            - stop
        - if !<[player].is_online>:
            - stop
        - repeat <[line].length>:
            - if <[player].flag[textbox_state].if_null[null]> != writing:
                - stop
            - if !<[player].is_online>:
                - stop
            - bossbar update textbox_<[player].uuid>_<[loop_index]> title:<black><bold><[line].substring[1,<[value]>]>
            - if <[value].sub[1].mod[3]> == 0:
                - playsound sound:textbox.text <[player]> custom pitch:<util.random.decimal[0.98].to[1]>
            - wait 1t
            - if <[line].substring[<[value].add[1]>,<[value].add[1]>].trim.length.if_null[1]> == 0:
                - if <[line].substring[<[value]>,<[value]>]> == ".":
                    - wait 2t
                - if <[line].substring[<[value]>,<[value]>]> == "!":
                    - wait 2t
                - if <[line].substring[<[value]>,<[value]>]> == "?":
                    - wait 2t
                - if <[line].substring[<[value]>,<[value]>]> == "-":
                    - wait 2t
                - if <[line].substring[<[value]>,<[value]>]> == ",":
                    - wait 2t
        - wait <duration[1t]>
    - if <[player].flag[textbox_state].if_null[null]> != writing:
        - if <[queue].if_null[null]> != null && <[player].flag[textbox_state].if_null[null]> != continue:
            - debug log "[Textbox] Write; cancelled queue <[queue].numeric_id><&at><[queue].script.name> for <[player].name>; state mismatch."
            - queue stop <[queue]>
            - run textbox_flush def.player:<[player]>
        - stop
    - if !<[player].is_online>:
        - if <[queue].if_null[null]> != null:
            - debug log "[Textbox] Write; cancelled queue <[queue].numeric_id><&at><[queue].script.name> for <[player].name>; offline player."
            - queue stop <[queue]>
            - run textbox_flush def.player:<[player]>
        - stop
    - flag <[player]> textbox_state:continue

# Skips the textbox and fills in the text quickly - i.e. text mashing
textbox_skip:
    debug: false
    type: task
    definitions: player
    script:
    - if <[player].flag[textbox_state].if_null[null]> != writing:
        - stop
    - repeat <[player].flag[textbox_lines]>:
        - if !<server.current_bossbars.contains[textbox_<[player].uuid>_<[value]>]>:
            - bossbar create textbox_<[player].uuid>_<[value]> players:<[player]> title:<empty>
    - define lines <[player].flag[textbox_input]>
    - foreach <[lines]> as:line:
        - bossbar update textbox_<[player].uuid>_<[loop_index]> title:<black><bold><[line]>
    - flag <[player]> textbox_state:continue

# Clears textbox and flushes all flag memory values
textbox_flush:
    debug: false
    type: task
    definitions: player
    script:
    - if <server.current_bossbars.contains[textbox_<[player].uuid>_ui]>:
        - bossbar remove textbox_<[player].uuid>_ui
    - repeat 3:
        - if <server.current_bossbars.contains[textbox_<[player].uuid>_<[value]>]>:
            - bossbar remove textbox_<[player].uuid>_<[value]>
    - if <server.current_bossbars.contains[textbox_<[player].uuid>_avatar]>:
        - bossbar remove textbox_<[player].uuid>_avatar
    - if <server.current_bossbars.contains[textbox_<[player].uuid>_top]>:
        - bossbar remove textbox_<[player].uuid>_top
        - bossbar remove textbox_<[player].uuid>_mid
        - bossbar remove textbox_<[player].uuid>_bottom
    - flag <[player]> textbox_state:!
    - flag <[player]> textbox_input:!
    - flag <[player]> textbox_lines:!
    - flag <[player]> textbox_choices:!
    - wait 10t

# Handle textbox events
# Internal only!
textbox_world:
    debug: false
    type: world
    events:
        # Skip the text and close the textbox by right click
        on player right clicks block bukkit_priority:lowest:
        - ratelimit <player> 5t
        - if <context.hand> == OFF_HAND:
            - stop
        - inject textbox_handle_click
        on player right clicks entity bukkit_priority:lowest:
        - ratelimit <player> 5t
        - if <context.hand> == OFF_HAND:
            - stop
        - inject textbox_handle_click
        on player animates arm_swing:
        - ratelimit <player> 5t
        - inject textbox_handle_click
        # Disallow block breaking (because skip is done via clicking, even in Creative Mode)
        on player breaks block:
        - define state <player.flag[textbox_state].if_null[false]>
        - if <[state]> == writing || <[state]> == continue:
            - determine cancelled
        # Disallow damage when textbox is active
        on player damages entity:
        - define state <player.flag[textbox_state].if_null[false]>
        - if <[state]> == writing || <[state]> == continue:
            - determine cancelled
        # Flush if rejoin
        on player joins:
        - run textbox_flush def.player:<player>
        # No movement on text
        on player walks:
        - define state <player.flag[textbox_state].if_null[false]>
        - if <[state]> == writing || <[state]> == continue:
            - if <context.old_location.with_pitch[0].with_yaw[0]> != <context.new_location.with_pitch[0].with_yaw[0]>:
                - determine cancelled
        - if <[state]> == choice:
            - if <context.old_location.with_pitch[0].with_yaw[0]> != <context.new_location.with_pitch[0].with_yaw[0]>:
                - determine cancelled passively
                - ratelimit <player> 5t
                #
                - define reference <context.old_location>
                - define left <[reference].left[0.001]>
                - define right <[reference].right[0.001]>
                - define up <[reference].forward[0.001]>
                - define down <[reference].backward[0.001]>
                #
                - define min <[left].sub[<context.new_location>].vector_length_squared>
                - define min_dir left
                #
                - define right_check <[right].sub[<context.new_location>].vector_length_squared>
                - if <[right_check]> < <[min]> :
                    - define min <[right_check]>
                    - define min_dir right
                #
                - define up_check <[up].sub[<context.new_location>].vector_length_squared>
                - if <[up_check]> < <[min]> :
                    - define min <[up_check]>
                    - define min_dir top
                #
                - define down_check <[down].sub[<context.new_location>].vector_length_squared>
                - if <[down_check]> < <[min]> :
                    - define min <[down_check]>
                    - define min_dir bottom
                #
                - run textbox_internal_choice_select def.player:<player> def.choice_dir:<[min_dir]>

# Internal only!
textbox_handle_click:
    debug: false
    type: task
    script:
    - define state <player.flag[textbox_state].if_null[false]>
    - if <[state]> == writing:
        - determine cancelled passively
        - run textbox_skip def.player:<player>
        - ratelimit <player> 5t
    - else if <[state]> == continue:
        - determine cancelled passively
        - playsound sound:textbox.close <player> custom
        - ~run textbox_flush def.player:<player>
        - ratelimit <player> 10t
    - else if <[state]> == choice:
        - determine cancelled passively
        - playsound sound:input.ok <player> custom
        - flag <player> textbox_choice_select:<player.flag[textbox_choices].get[current]>
        - ~run textbox_flush def.player:<player>
        - ratelimit <player> 10t

# Writes into the text box display.
# You should provide at least 2 and up to 4 choices.
# The choices are defined in the top, left, right, and bottom directions.
# The choices map has this structure:
# choices:
#   left:
#     text: 'Some Choice 1'
#     task: task_to_continue_to_1
#   right:
#     text: 'Some Choice 2'
#     task: task_to_continue_to_2
#   ...
# When selected, the task receives the player as input in the <[player]> definition.
# The task also receives the direction that was picked in <[choice]>: top, bottom, left or right
textbox_choice:
    debug: false
    type: task
    definitions: player|queue|choices
    script:
    - if <[player].flag[textbox_state].if_null[null]> == choice:
        - stop
    - if !<[player].is_online>:
        - if <[queue].if_null[null]> != null:
            - debug log "[Textbox] Choice; cancelled queue <[queue].numeric_id><&at><[queue].script.name> for <[player].name>; offline"
            - queue stop <[queue]>
            - run textbox_flush def.player:<[player]>
        - stop
    - if !<[player].is_on_ground> && <player.gamemode> != spectator:
        - if <[player].location.below.material.is_solid>:
            - teleport <[player]> <[player].location.below.above.with_y[<[player].location.below.above.y.round_down>]>
        - else:
            - stop
    - waituntil <[player].flag[textbox_state].if_null[null]> == null
    - ~run textbox_flush def.player:<[player]>
    - flag <[player]> textbox_state:choice
    - flag <[player]> textbox_choices:<map[].with[data].as[<[choices]>].with[current].as[left]>
    - define first_choice left
    - if <[choices].keys.contains[top]>:
        - define first_choice top
    - if !<[choices].keys.contains[left]>:
        - define first_choice <[choices].keys.first>
    - run textbox_internal_choice_select def.player:<[player]> def.choice_dir:<[first_choice]>
    - waituntil <[player].flag[textbox_choice_select].if_null[null]> != null || !<[player].is_online>
    - if !<[player].is_online>:
        - if <[queue].if_null[null]> != null:
            - debug log "[Textbox] Choice; cancelled queue <[queue].numeric_id><&at><[queue].script.name> for <[player].name>; offline"
            - queue stop <[queue]>
            - run textbox_flush def.player:<[player]>
        - stop
    - define result <[player].flag[textbox_choice_select]>
    - flag <[player]> textbox_choice_select:!
    - determine <[result]>

# Internal only!
textbox_internal_choice_select:
    debug: false
    type: task
    definitions: player|choice_dir
    script:
    - if !<server.current_bossbars.contains[textbox_<[player].uuid>_top]>:
        - bossbar create textbox_<[player].uuid>_ui players:<[player]> title:錀
        - bossbar create textbox_<[player].uuid>_top players:<[player]> title:<empty>
        - bossbar create textbox_<[player].uuid>_mid players:<[player]> title:<empty>
        - bossbar create textbox_<[player].uuid>_bottom players:<[player]> title:<empty>
    - define choices <[player].flag[textbox_choices].get[data]>
    #
    - define left <&0><&l><[choices].get[left].get[text].if_null[null]>
    - define right <&0><&l><[choices].get[right].get[text].if_null[null]>
    - define top <&0><&l><[choices].get[top].get[text].if_null[null]>
    - define bottom <&0><&l><[choices].get[bottom].get[text].if_null[null]>
    #
    - if <[choice_dir]> == left:
        - if <[left]> == <&0><&l>null:
            - stop
        - define left "<&4>❤ <&0><&l><[left]>"
    - else if <[choice_dir]> == right:
        - if <[right]> == <&0><&l>null:
            - stop
        - define right "<&4>❤ <&0><&l><[right]>"
    - else if <[choice_dir]> == top:
        - if <[top]> == <&0><&l>null:
            - stop
        - define top "<&4>❤ <&0><&l><[top]>"
    - else:
        - if <[bottom]> == <&0><&l>null:
            - stop
        - define bottom "<&4>❤ <&0><&l><[bottom]>"
    #
    - define mid_padding <element[<&sp>].repeat[<element[30].sub[<[left].strip_color.length>].sub[<[right].strip_color.length>]>]>
    #
    - if <[top]> != <&0><&l>null:
        - bossbar update textbox_<[player].uuid>_top title:<[top]>
    - if <[left]> != <&0><&l>null || <[right]> != <&0><&l>null:
        - bossbar update textbox_<[player].uuid>_mid title:<[left]><[mid_padding]><[right]>
    - if <[bottom]> != <&0><&l>null:
        - bossbar update textbox_<[player].uuid>_bottom title:<[bottom]>
    - flag <[player]> textbox_choices:<map[].with[data].as[<[choices]>].with[current].as[<[choice_dir]>]>
    - playsound BLOCK_NOTE_BLOCK_BIT <[player]> pitch:2
