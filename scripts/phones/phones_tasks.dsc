####
## GENERAL STUFF
####

phones_get_owner:
    debug: false
    type: procedure
    definitions: player|receiver
    script:
    - define receiver <[receiver].replace[(].with[].replace[)].with[].replace[-].with[]>
    - define isnumber <[receiver].regex_matches[^[0-9]+$]>
    - define target null
    - if <[isnumber]>:
        - define target <server.flag[phones].get[<[receiver]>].if_null[null]>
    - else:
        - define target <[player].flag[phones].get[contacts].get[<[receiver]>].if_null[null]>
    - determine <[target]>

phones_has_phone:
    debug: false
    type: procedure
    definitions: player
    script:
    - if !<[player].is_online>:
        - determine false
    - if <[player].inventory.title.contains[鄀].if_null[false]>:
        - determine true
    - foreach <[player].inventory.map_slots> key:slot as:item:
        - if <[item].flag[phones].if_null[false]>:
            - determine true
    - determine false

phones_relative_name:
    debug: false
    type: procedure
    definitions: player|who
    script:
    - if <[player].flag[phones].get[contacts].values.contains[<[who]>].if_null[false]>:
        - determine <[player].flag[phones].get[contacts].filter_tag[<[filter_value].equals[<[who]>]>].keys.get[1]>
    - determine <[who].flag[phones].get[number]>

phones_clean_message:
    debug: false
    type: procedure
    definitions: message
    script:
    - define clean <empty>
    # remove channel marker
    - if <[message].starts_with[#]>:
        - define message <[message].substring[3]>
    # format actions
    - foreach <[message].split[*]> as:section:
        - if <[section].trim.length> == 0:
            - foreach next
        - if <[loop_index].is_odd>:
            - define clean "<[clean]> <&f><&dq><[section].trim><&f><&dq>"
        - else:
            - define clean "<[clean]> <&e><[section].trim>"
    # good
    - determine <[clean].trim>


phones_get_contact_state:
    debug: false
    type: procedure
    definitions: player|target
    script:
    - if <[target].flag[phones].get[contacts].values.contains[<[player]>].if_null[false]>:
        - if <[target].is_online>:
            - if <proc[phones_has_phone].context[<[target]>]>:
                - determine online
        - determine offline
    - determine invisible

phones_nicer_format:
    debug: false
    type: procedure
    definitions: number
    script:
    - determine "<&7>(+81) <&e>(<[number].substring[1,3]>)-<[number].substring[4,6]>-<[number].substring[7,10]>"

phones_get_number:
    debug: false
    type: procedure
    definitions: player
    script:
    - determine <[player].flag[phones].get[number]>

####
## GUIS
####

phones_gui_home:
    debug: false
    type: task
    definitions: player
    script:
    - define inventory <inventory[generic[size=54;title=<&f>邑邑邑邑鄀<&0>邒]]>
    # settings
    - define settings <item[name_tag]>
    - adjust def:settings display:<&6>Settings
    - inventory set destination:<[inventory]> slot:13 origin:<[settings]>
    # contacts
    - define contacts <item[book]>
    - adjust def:contacts display:<&6>Contacts
    - inventory set destination:<[inventory]> slot:14 origin:<[contacts]>
    # texts
    - define texts <item[writable_book]>
    - adjust def:texts display:<&6>Messages
    - define notifications_textmessages <[player].flag[phones_notifications].get[textmessages].values.size.if_null[null]>
    - if <[notifications_textmessages]> != null && <[notifications_textmessages]> != 0:
        - if <[notifications_textmessages]> > 99:
            - define notifications_textmessages 99+
        - adjust texts lore:<list[<&c>● <&7>You have <&6><[notifications_textmessages]> <&7>unread|<&7>text conversations.]>
    - inventory set destination:<[inventory]> slot:15 origin:<[texts]>
    # music
    - define music <item[jukebox]>
    - adjust def:music "display:<&6>Blocky Music <&3>♫"
    - adjust def:music "lore:<&7>(music from <&e>noteblock.world<&7>)"
    - inventory set destination:<[inventory]> slot:22 origin:<[music]>
    # number
    - define number <item[player_head]>
    - adjust def:number "display:<&6>Your Number"
    - adjust def:number lore:<list[<&e><proc[phones_nicer_format].context[<[player].flag[phones].get[number]>]>||<&7>You may also view your number|<&7>using /phonenumber.]>
    - inventory set destination:<[inventory]> slot:41 origin:<[number]>
    - inventory adjust destination:<[inventory]> slot:41 skull_skin:<[player].uuid>|<proc[wardrobe_skin_texture_base64].context[<[player]>]>|<[player].name>
    #
    - inventory open player:<[player]> destination:<[inventory]>

# ---
# --- contacts related
# ---

phones_contacts_print:
    debug: false
    type: task
    definitions: player|page
    script:
    - define contacts <[player].flag[phones].get[contacts].if_null[<map[]>]>
    - if <[contacts].is_empty>:
        - narrate targets:<[player]> format:formats_prefix "You don't have any contacts."
        - stop
    - define contactslist <[contacts].keys.get[<[page].mul[6].add[1]>].to[<[page].add[1].mul[6]>].if_null[<list[]>]>
    - narrate targets:<[player]> format:formats_prefix "<&e>OpenPhones Contacts<&nl>"
    # show contacts
    - foreach <[contactslist]> as:receiver:
        - define target <[contacts].get[<[receiver]>]>
        # state
        - define contactstate <proc[phones_get_contact_state].context[<[player]>|<[target]>]>
        - if <[contactstate]> == invisible:
            - define contactstate <&7>⏺
        - else if <[contactstate]> == online:
            - define contactstate <&a>⏺
        - else if <[contactstate]> == offline:
            - define contactstate <&c>⏺
        #
        - define contact "<[contactstate]> <&e><proc[phones_nicer_format].context[<proc[phones_get_number].context[<[target]>]>]> <&7><&o>(<[receiver]>)"
        - narrate <[contact]>
    # page buttons
    - define prevpage <&7><&lt>--
    - define nextpage <&7>--<&gt>
    - if <[page]> > 0:
        - clickable usages:1 until:60s save:prev:
            - execute as_player "phonecontacts <[page]>"
        - define prevpage <element[<&a><&lt>--].on_click[<entry[prev].command>]>
    - if <[contacts].size> > <[page].add[1].mul[6]>:
        - clickable usages:1 until:60s save:next:
            - execute as_player "phonecontacts <[page].add[2]>"
        - define nextpage <element[<&a>--<&gt>].on_click[<entry[next].command>]>
    - narrate targets:<[player]> "<&nl><[prevpage]> <&6>Page <[page].add[1]>/<[contacts].size.sub[1].div[6].round_down.add[1]> <[nextpage]>"

# ---
# --- texts related
# ---

phones_texts_store:
    debug: false
    type: task
    definitions: player|target|contents
    script:
    - narrate targets:<[player]> format:formats_prefix Sending...
    #
    - define playertexts phones_texts_<[player].uuid>_<[target].uuid>
    - if <util.has_file[data/phones/texts/<[player].uuid>_<[target].uuid>.yml]>:
        - ~yaml id:<[playertexts]> load:data/phones/texts/<[player].uuid>_<[target].uuid>.yml
    - else:
        - ~yaml id:<[playertexts]> create
    - yaml id:<[playertexts]> set messages.<util.time_now.escaped>:<map[].with[origin].as[sender].with[value].as[<[contents]>]>
    - ~yaml savefile:data/phones/texts/<[player].uuid>_<[target].uuid>.yml id:<[playertexts]>
    - ~yaml id:phones_texts_<[player].uuid>_<[target].uuid> unload
    #
    - define targettexts phones_texts_<[target].uuid>_<[player].uuid>
    - if <util.has_file[data/phones/texts/<[target].uuid>_<[player].uuid>.yml]>:
        - ~yaml id:<[targettexts]> load:data/phones/texts/<[target].uuid>_<[player].uuid>.yml
    - else:
        - ~yaml id:<[targettexts]> create
    - yaml id:<[targettexts]> set messages.<util.time_now.escaped>:<map[].with[origin].as[receiver].with[value].as[<[contents]>]>
    - ~yaml savefile:data/phones/texts/<[target].uuid>_<[player].uuid>.yml id:<[targettexts]>
    - ~yaml id:phones_texts_<[target].uuid>_<[player].uuid> unload
    # send
    - define relative <proc[phones_relative_name].context[<[player]>|<[target]>]>
    - narrate targets:<[player]> "<&6>[<&7>T<&6>] <&e>You ➠ <[relative]> <&2>sent '<[contents]>' via text"
    # notify or send
    - if <[target].is_online>:
        - if <[target].item_in_hand.has_flag[phones]>:
            - define inverserelative <proc[phones_relative_name].context[<[target]>|<[player]>]>
            - narrate targets:<[target]> "<&6>[<&7>T<&6>] <&e><[inverserelative]> ➠ You <&2>sent '<[contents]>' via text"
        - else:
            - narrate targets:<[target]> "<&6>[<&7>T<&6>] <&e>You received a text message."
    - else:
        - define notifications <[target].flag[phones_notifications].if_null[<map[]>]>
        - define textnotifications <[notifications].get[textmessages].if_null[<map[]>]>
        - define textnotifications <[textnotifications].with[<[player]>].as[<[textnotifications].get[<[player]>].if_null[0].add[1]>]>
        - define notifications <[notifications].with[textmessages].as[<[textnotifications]>]>
        - flag <[target]> phones_notifications:<[notifications]>
        - adjust server save

phones_texts_print:
    debug: false
    type: task
    definitions: player|target|page
    script:
    - narrate targets:<[player]> format:formats_prefix Loading...
    #
    - define playertexts phones_texts_<[player].uuid>_<[target].uuid>
    - ~yaml id:<[playertexts]> load:data/phones/texts/<[player].uuid>_<[target].uuid>.yml
    - define messages_size <yaml[<[playertexts]>].read[messages].size>
    - define message_keys <yaml[<[playertexts]>].read[messages].keys.reverse.get[<[page].mul[5].add[1]>].to[<[page].add[1].mul[5]>].if_null[<list[]>]>
    - define messages <map[]>
    - foreach <[message_keys]> as:timestamp:
        - define messages <[messages].with[<time[<[timestamp].unescaped>]>].as[<yaml[<[playertexts]>].read[messages.<[timestamp]>]>]>
    - ~yaml id:phones_texts_<[player].uuid>_<[target].uuid> unload
    #
    - define relative <proc[phones_relative_name].context[<[player]>|<[target]>]>
    - narrate targets:<[player]> format:formats_prefix "<&e>Messages with <[relative]><&nl>"
    - foreach <[messages]> key:timestamp as:message:
        - define when <util.time_now.duration_since[<[timestamp]>].formatted>
        - if <[message].get[origin]> == sender:
            - narrate targets:<[player]> "<&7>You: <&f><[message].get[value]> <&7>(<[when]> ago)"
        - else:
            - narrate targets:<[player]> "<&e><[relative]><&7>: <&f><[message].get[value]> <&7>(<[when]> ago)"
    # page buttons
    - define prevpage <&7><&lt>--
    - define nextpage <&7>--<&gt>
    - if <[page]> > 0:
        - clickable usages:1 until:60s save:prev:
            - run phones_texts_print def.player:<[player]> def.target:<[target]> def.page:<[page].sub[1]>
        - define prevpage <element[<&a><&lt>--].on_click[<entry[prev].command>]>
    - if <[messages_size]> > <[page].add[1].mul[5]>:
        - clickable usages:1 until:60s save:next:
            - run phones_texts_print def.player:<[player]> def.target:<[target]> def.page:<[page].add[1]>
        - define nextpage <element[<&a>--<&gt>].on_click[<entry[next].command>]>
    - narrate targets:<[player]> "<&nl><[prevpage]> <&6>Page <[page].add[1]>/<[messages_size].sub[1].div[5].round_down.add[1]> <[nextpage]>"
    # clear notifications?
    - if <[player].flag[phones_notifications].get[textmessages].get[<[target]>].if_null[0]> > 0:
        - define notifications <[player].flag[phones_notifications].if_null[<map[]>]>
        - define textnotifications <[notifications].get[textmessages].if_null[<map[]>]>
        - define textnotifications <[textnotifications].exclude[<[target]>]>
        - define notifications <[notifications].with[textmessages].as[<[textnotifications]>]>
        - flag <[player]> phones_notifications:<[notifications]>
        - adjust server save

phones_gui_texts:
    debug: false
    type: task
    definitions: player|page
    script:
    - define inventory <inventory[generic[size=54;title=<&f>邑邑邑邑鄀<&1>邒]]>
    - define texts <util.list_files[data/phones/texts].filter[starts_with[<player.uuid>]].parse[split[_].get[2].split[.].get[1]].parse_tag[<player[<[parse_value]>]>].if_null[<list[]>]>
    - define textslist <[texts].get[<[page].mul[15].add[1]>].to[<[page].add[1].mul[15]>].if_null[<list[]>]>
    - define textssize <[texts].size>
    # show contacts/numbers
    - foreach <[textslist]> as:target:
        - define receiver <proc[phones_relative_name].context[<[player]>|<[target]>]>
        - define textsender <item[player_head]>
        - adjust def:textsender display:<&e><[receiver]>
        - adjust def:textsender lore:<list[<&7>Click to view your conversation.]>
        # notifications
        - define notifications_text <[player].flag[phones_notifications].get[textmessages].get[<[target]>].if_null[null]>
        - if <[notifications_text]> != null:
            - if <[notifications_text]> > 99:
                - define notifications_text 99+
            - adjust def:textsender lore:<[textsender].lore.include[|<&7>You have <&6><[notifications_text]> <&7>unread messages.]>
        #
        - flag <[textsender]> phones:<[target]>
        - define slot <[loop_index].sub[1].div[3].round_down.mul[9].add[4].add[<[loop_index].sub[1].mod[3]>]>
        - inventory set destination:<[inventory]> slot:<[slot]> origin:<[textsender]>
        - inventory adjust destination:<[inventory]> slot:<[slot]> skull_skin:<[target].uuid>|<proc[wardrobe_skin_texture_base64].context[<[target]>]>|<[target].name>
    # back
    - define back <item[oak_door]>
    - adjust def:back display:<&7>Back
    - inventory set destination:<[inventory]> slot:50 origin:<[back]>
    # page buttons
    - if <[page]> > 0:
        - define prevpage <item[ender_pearl]>
        - adjust def:prevpage "display:<&a>Previous Page"
        - inventory set destination:<[inventory]> slot:49 origin:<[prevpage]>
    - if <[textssize]> > <[page].add[1].mul[15]>:
        - define nextpage <item[ender_eye]>
        - adjust def:nextpage "display:<&a>Next Page"
        - inventory set destination:<[inventory]> slot:51 origin:<[nextpage]>
    #
    - inventory open player:<[player]> destination:<[inventory]>

####
## NOTIFICATIONS
####

phones_notify_text_messages:
    debug: false
    type: task
    definitions: player|delayseconds
    script:
    - wait <[delayseconds]>s
    - if !<[player].is_online>:
        - stop
    - define notifications_textmessages <[player].flag[phones_notifications].get[textmessages].values.filter[equals[0].not].sum.if_null[null]>
    - if <[notifications_textmessages]> == null || <[notifications_textmessages]> == 0:
        - stop
    - if <[notifications_textmessages]> > 99:
        - define notifications_textmessages 99+
    - narrate targets:<[player]> format:formats_prefix "You have <&6><[notifications_textmessages]> <&7>unread text conversations."

####
## MUSIC APP
####

phones_music_play:
    debug: false
    type: task
    definitions: player|songfile
    script:
    - if <[player].nbs_is_playing>:
        - nbs stop targets:<[player]>
    - nbs file:data/phones/songs/<[songfile]> play targets:<[player]>
    - narrate targets:<[player]> format:formats_prefix "Playing song..."

phones_music_stop:
    debug: false
    type: task
    definitions: player
    script:
    - if !<[player].nbs_is_playing>:
        - narrate targets:<[player]> format:formats_prefix "No song is playing right now."
        - stop
    - nbs stop targets:<[player]>
    - narrate targets:<[player]> format:formats_prefix "Stopped song."

phones_gui_music:
    debug: false
    type: task
    definitions: player|page|ringtone
    script:
    # ringtone selection mode?
    - define ringtone <[ringtone].if_null[false]>
    # make inventory
    - define inventory <inventory[generic[size=54;title=<&f>邑邑邑邑鄀<&2>邒]]>
    - if <[ringtone]>:
        - define inventory <inventory[generic[size=54;title=<&f>邑邑邑邑鄀<&4>邒]]>
    - define songsize <util.list_files[data/phones/songs].size>
    - define songsonpage <tern[<[ringtone]>].pass[15].fail[14]>
    - define songlist <util.list_files[data/phones/songs].parse[split[.].get[1]].filter[length.is_more_than[0]].get[<[page].mul[<[songsonpage]>].add[1]>].to[<[page].add[1].mul[<[songsonpage]>]>].if_null[<list[]>]>
    # show songs
    - foreach <[songlist]> as:songname:
        - define song <item[jukebox]>
        - adjust def:song display:<&e><[songname]>
        - adjust def:song lore:<list[<&7>Click to start playing.]>
        - flag <[song]> phones:<[songname]>
        - inventory set destination:<[inventory]> slot:<[loop_index].sub[1].div[3].round_down.mul[9].add[4].add[<[loop_index].sub[1].mod[3]>]> origin:<[song]>
    # stop
    - if !<[ringtone]>:
        - define stop <item[redstone_block]>
        - adjust def:stop display:<&c>Stop
        - inventory set destination:<[inventory]> slot:42 origin:<[stop]>
    # back
    - define back <item[oak_door]>
    - adjust def:back display:<&7>Back
    - inventory set destination:<[inventory]> slot:50 origin:<[back]>
    # page buttons
    - if <[page]> > 0:
        - define prevpage <item[ender_pearl]>
        - adjust def:prevpage "display:<&a>Previous Page"
        - inventory set destination:<[inventory]> slot:49 origin:<[prevpage]>
    - if <[songsize]> > <[page].add[1].mul[<[songsonpage]>]>:
        - define nextpage <item[ender_eye]>
        - adjust def:nextpage "display:<&a>Next Page"
        - inventory set destination:<[inventory]> slot:51 origin:<[nextpage]>
    #
    - inventory open player:<[player]> destination:<[inventory]>

###
## SETTINGS
###
phones_gui_settings:
    debug: false
    type: task
    definitions: player
    script:
    - define inventory <inventory[generic[size=54;title=<&f>邑邑邑邑鄀<&3>邒]]>
    # ringtone
    - define ringtone <item[note_block]>
    - adjust def:ringtone display:<&6>Ringtone
    - adjust def:ringtone "lore:<&7>(music from <&e>noteblock.world<&7>)"
    - inventory set destination:<[inventory]> slot:4 origin:<[ringtone]>
    # blocked
    - define blocked <item[barrier]>
    - adjust def:blocked "display:<&6>Blocked Numbers"
    - inventory set destination:<[inventory]> slot:5 origin:<[blocked]>
    # back
    - define back <item[oak_door]>
    - adjust def:back display:<&7>Back
    - inventory set destination:<[inventory]> slot:50 origin:<[back]>
    #
    - inventory open player:<[player]> destination:<[inventory]>

phones_gui_settings_blocked:
    debug: false
    type: task
    definitions: player|page
    script:
    - define inventory <inventory[generic[size=54;title=<&f>邑邑邑邑鄀<&5>邒]]>
    - define blockedlist <[player].flag[phones].get[blocked].get[<[page].mul[15].add[1]>].to[<[page].add[1].mul[15]>].if_null[<list[]>]>
    # show blocked numbers
    - foreach <[blockedlist]> as:target:
        - define blockednumber <proc[phones_nicer_format].context[<[target].flag[phones].get[number]>]>
        - define blocked <item[player_head]>
        - adjust def:blocked display:<&e><[blockednumber]>
        - adjust def:blocked lore:<list[<&7>You may use /phoneunblock to unblock this number.]>
        - adjust def:blocked skull_skin:<[target].uuid>|<proc[wardrobe_skin_texture_base64].context[<[target]>]>|<[target].name>
        - inventory set destination:<[inventory]> slot:<[loop_index].sub[1].div[3].round_down.mul[9].add[4].add[<[loop_index].sub[1].mod[3]>]> origin:<[blocked]>
    # back
    - define back <item[oak_door]>
    - adjust def:back display:<&7>Back
    - inventory set destination:<[inventory]> slot:50 origin:<[back]>
    # page buttons
    - if <[page]> > 0:
        - define prevpage <item[ender_pearl]>
        - adjust def:prevpage "display:<&a>Previous Page"
        - inventory set destination:<[inventory]> slot:49 origin:<[prevpage]>
    - if <[blockedlist].size> > <[page].add[1].mul[15]>:
        - define nextpage <item[ender_eye]>
        - adjust def:nextpage "display:<&a>Next Page"
        - inventory set destination:<[inventory]> slot:51 origin:<[nextpage]>
    #
    - inventory open player:<[player]> destination:<[inventory]>
