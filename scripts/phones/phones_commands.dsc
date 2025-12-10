## CALL
phones_commands_phonecall:
    debug: false
    type: command
    name: phonecall
    aliases:
    - call
    description: Call using a phone!
    usage: /phonecall (number/contact/message)
    permission: phones.command.phonecall
    tab complete:
    - if <context.server>:
        - determine <list[]>
    - if <player.has_flag[phones_call]>:
        - determine <list[<&lt>message<&gt>]>
    - determine <player.flag[phones].get[contacts].keys.if_null[<list[]>]>
    script:
    # checks...
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define incall <player.has_flag[phones_call_clickable].not.and[<player.has_flag[phones_call]>]>
    # mid call?
    - if !<[incall]>:
        # waiting call?
        - if <player.has_flag[phones_call_clickable]>:
            - narrate "<&c>Please wait for the call to be accepted, or unequip to cancel the call."
            - stop
        # no
        - if <context.args.size> < 1:
            - narrate "<&c>Invalid use. First, call a number. Please try /<context.alias> (number/contact)."
            - stop
        # definitions
        - define receiver <context.args.get[1]>
        - define target <proc[phones_get_owner].context[<player>|<[receiver]>]>
        - if !<player.item_in_hand.flag[phones].if_null[false]>:
            - narrate "<&c>Please hold a phone in your hand, and ensure it is powered on."
            - stop
        # invalid number/contact
        - if <[target]> == null:
            - narrate "<&c>Invalid phone number or contact <[receiver]>. Please try again."
            - stop
        # lmao
        - if <player> == <[target]>:
            - narrate "<&c>You can't call yourself!"
            - stop
        # blocked
        - if <player.flag[phones].get[blocked].contains[<[target]>].if_null[false]>:
            - narrate "<&c>The receiver is currently in your blocked numbers."
            - stop
        - if <[target].flag[phones].get[blocked].contains[<player>].if_null[false]>:
            - narrate "<&c>The receiver is unable to be contacted at this time. Try again later."
            - stop
        # not online/no phone/phone is off/etc...
        - if !<proc[phones_has_phone].context[<[target]>]>:
            - narrate "<&c>The receiver is unable to be contacted at this time. Try again later."
            - stop
        # mid call...
        - if <[target].has_flag[phones_call]>:
            - narrate "<&c>The receiver is currently busy. Try again later."
            - stop
        # call...
        - define relative <proc[phones_relative_name].context[<[target]>|<player>]>
        - define player <player>
        # if accepted, go in
        - clickable save:accept until:30s:
            - if !<[target].item_in_hand.flag[phones].if_null[false]>:
                - narrate targets:<[target]> "<&c>Please hold a phone before accepting the call, and ensure it is powered on."
                - stop
            - nbs stop targets:<[target]>
            - clickable cancel:<[player].flag[phones_call_clickable]>
            - flag <[target]> phones_call:<[player]>
            - flag <[player]> phones_call:<[target]>
            - flag <[player]> phones_call_clickable:!
            - flag <[target]> phones_is_maybe_called:!
            - narrate targets:<[player]> "<&2>*** <&a><[receiver]> <&a>picked up the phone."
            - narrate targets:<[target]> "<&2>*** <&a>You picked up the phone."
            - define callgroup <list[<[player]>|<[target]>]>
            - narrate targets:<[callgroup]> <&f>
            - narrate targets:<[callgroup]> "<&7>Talk using <&e>/call (message)<&7>."
            - narrate targets:<[callgroup]> "<&e>Unequip <&7>your phone to <&c>end <&7>the call."
            - narrate targets:<[callgroup]> <&f>
        #
        # before accepted
        - if !<[target].has_flag[phones_is_maybe_called]>:
            - nbs file:data/phones/songs/<[target].flag[phones].get[ringtone].if_null[Bad Apple]> play targets:<[target]>
        - narrate targets:<[target]> "<&6>*** <&e>You're being called by <&e><[relative]><&7>."
        - narrate targets:<[target]> <&hover[<&a>Click to accept call from <[relative]>...]><element[<&a><&l>[ ACCEPT ]].on_click[<entry[accept].command>]><&end_hover>
        # wait...
        - flag <player> phones_call:<[target]>
        - flag <player> phones_call_clickable:<entry[accept].id>
        - flag <[target]> phones_is_maybe_called:true expire:30s
        - narrate "<&6>*** <&e>You started to ring <&7><[receiver]>"
        - narrate "<&7>Unequip your phone to cancel the call."
    - else:
        # yes
        - if <context.args.size> < 1:
            - narrate "<&c>Invalid use. You are mid-call - please try /<context.alias> (message)."
            - narrate "<&7>Note: you can unequip the phone to end the current call."
            - stop
        # definitions
        - define target <player.flag[phones_call]>
        - define message <context.args.get[1].to[last].space_separated>
        # speak...
        - define final "<&6>[<&7>P<&6>] <&f><placeholder[essentials_nickname].player[<player>]> <proc[chat_special_group].context[<player>]><proc[chat_roles_group].context[<player>]> <proc[character_get_name].context[<player>]> <&f>says <&dq><[message]><&f><&dq> over the phone."
        - narrate targets:<player.location.find_players_within[10].include[<[target]>].deduplicate> <[final]>

## callw, cally use similar routines
phones_command_call_common_routine:
    debug: false
    type: task
    script:
    # checks...
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - define continue false
        - stop
    - define incall <player.has_flag[phones_call_clickable].not.and[<player.has_flag[phones_call]>]>
    # mid call?
    - if !<[incall]>:
        # waiting call?
        - if <player.has_flag[phones_call_clickable]>:
            - narrate "<&c>Please wait for the call to be accepted, or unequip to cancel the call."
            - define continue false
            - stop
        # no
        - narrate "<&c>Invalid use. First, call a number. Please try /call (number/contact)."
        - define continue false
    - else:
        # yes
        - if <context.args.size> < 1:
            - narrate "<&c>Invalid use. You are mid-call - please try /<context.alias> (message)."
            - narrate "<&7>Note: you can unequip the phone to end the current call."
            - define continue false
            - stop
        # definitions
        - define target <player.flag[phones_call]>
        - define message <context.args.get[1].to[last].space_separated>

phones_command_phonecallwhisper:
    debug: false
    type: command
    name: phonecallwhisper
    aliases:
    - callwhisper
    - callw
    description: Whisper over the phone while in a call.
    usage: /phonecallwhisper (message)
    permission: phones.command.phonecallwhisper
    tab complete:
    - if <context.server>:
        - determine <list[]>
    - if <player.has_flag[phones_call]>:
        - determine <list[<&lt>message<&gt>]>
    - determine <list[]>
    script:
    - define continue true
    - inject phones_command_call_common_routine
    - if !<[continue]>:
        - stop
    # speak...
    - define final "<&6>[<&7>P<&6>] <&f><placeholder[essentials_nickname].player[<player>]> <proc[chat_special_group].context[<player>]><proc[chat_roles_group].context[<player>]> <proc[character_get_name].context[<player>]> <&8>whispers <&6><&sq><&7><[message]><&6><&sq> <&8>over the phone."
    - narrate targets:<player.location.find_players_within[3].include[<[target]>].deduplicate> <[final]>

phones_command_phonecallyell:
    debug: false
    type: command
    name: phonecallyell
    aliases:
    - callyell
    - cally
    description: Yell over the phone while in a call.
    usage: /phonecallyell (message)
    permission: phones.command.phonecallyell
    tab complete:
    - if <context.server>:
        - determine <list[]>
    - if <player.has_flag[phones_call]>:
        - determine <list[<&lt>message<&gt>]>
    - determine <list[]>
    script:
    - define continue true
    - inject phones_command_call_common_routine
    - if !<[continue]>:
        - stop
    # speak...
    - define final "<&6>[<&7>P<&6>] <&f><placeholder[essentials_nickname].player[<player>]> <proc[chat_special_group].context[<player>]><proc[chat_roles_group].context[<player>]> <proc[character_get_name].context[<player>]> <&6>yells <&sq><&f><[message].to_uppercase><&6><&sq> over the phone."
    - narrate targets:<player.location.find_players_within[25].include[<[target]>].deduplicate> <[final]>

## langcall, langcallw, langcally use similar routines
phones_command_call_language_common_routine:
    debug: false
    type: task
    script:
    # checks...
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - define continue false
        - stop
    - define incall <player.has_flag[phones_call_clickable].not.and[<player.has_flag[phones_call]>]>
    # mid call?
    - if !<[incall]>:
        # waiting call?
        - if <player.has_flag[phones_call_clickable]>:
            - narrate "<&c>Please wait for the call to be accepted, or unequip to cancel the call."
            - define continue false
            - stop
        # no
        - narrate "<&c>Invalid use. First, call a number. Please try /call (number/contact)."
        - define continue false
    - else:
        # yes
        - if <context.args.size> < 2:
            - narrate "<&c>Invalid use. You are mid-call - please try /<context.alias> (language) (message)."
            - narrate "<&7>Note: you can unequip the phone to end the current call."
            - define continue false
            - stop
        # definitions
        - define target <player.flag[phones_call]>
        - define language <context.args.get[1].to_sentence_case>
        - if !<player.flag[chat_languages].contains[<[language]>].if_null[false]>:
            - narrate "<&c>Your character cannot speak in <[language]>."
            - define continue false
            - stop
        - define message <context.args.get[2].to[last].space_separated>

phones_command_phonelangcall:
    debug: false
    type: command
    name: phonelangcall
    aliases:
    - langcall
    description: Speak over the phone in a different language.
    usage: /phonelangcall (language) (message)
    permission: phones.command.phonelangcall
    tab complete:
    - if <context.server>:
        - determine <list[]>
    - if <player.has_flag[phones_call]>:
        - if <context.args.size> <= 0:
            - determine <player.flag[chat_languages].if_null[<list[]>]>
        - if <context.args.size> <= 1:
            - determine <list[<&lt>message<&gt>]>
    - determine <list[]>
    script:
    - define continue true
    - inject phones_command_call_language_common_routine
    - if !<[continue]>:
        - stop
    # speak...
    - define final_known "<&6>[<&7>P<&6>] <&f><placeholder[essentials_nickname].player[<player>]> <proc[chat_special_group].context[<player>]><proc[chat_roles_group].context[<player>]> <proc[character_get_name].context[<player>]> <&f>says <&dq><&o><[message]><&f><&dq> in <[language]> over the phone."
    - define final_unknown "<&6>[<&7>P<&6>] <&f><placeholder[essentials_nickname].player[<player>]> <proc[chat_special_group].context[<player>]><proc[chat_roles_group].context[<player>]> <proc[character_get_name].context[<player>]> <&f>says something in <[language]> over the phone."
    - define all <player.location.find_players_within[10].include[<[target]>].deduplicate>
    - define speakers <[all].filter_tag[<[filter_value].flag[chat_languages].contains[<[language]>].if_null[false]>]>
    - define others <[all].exclude[<[speakers]>]>
    - narrate targets:<[speakers]> <[final_known]>
    - narrate targets:<[others]> <[final_unknown]>

phones_command_phonelangcallwhisper:
    debug: false
    type: command
    name: phonelangcallwhisper
    aliases:
    - langcallwhisper
    - langcallw
    description: Whisper over the phone in a different language.
    usage: /phonelangcallwhisper (language) (message)
    permission: phones.command.phonelangcallwhisper
    tab complete:
    - if <context.server>:
        - determine <list[]>
    - if <player.has_flag[phones_call]>:
        - if <context.args.size> <= 0:
            - determine <player.flag[chat_languages].if_null[<list[]>]>
        - if <context.args.size> <= 1:
            - determine <list[<&lt>message<&gt>]>
    - determine <list[]>
    script:
    - define continue true
    - inject phones_command_call_language_common_routine
    - if !<[continue]>:
        - stop
    # speak...
    - define final_known "<&6>[<&7>P<&6>] <&f><placeholder[essentials_nickname].player[<player>]> <proc[chat_special_group].context[<player>]><proc[chat_roles_group].context[<player>]> <proc[character_get_name].context[<player>]> <&f>whispers <&dq><&o><[message]><&f><&dq> in <[language]> over the phone."
    - define final_unknown "<&6>[<&7>P<&6>] <&f><placeholder[essentials_nickname].player[<player>]> <proc[chat_special_group].context[<player>]><proc[chat_roles_group].context[<player>]> <proc[character_get_name].context[<player>]> <&f>whispers something in <[language]> over the phone."
    - define all <player.location.find_players_within[3].include[<[target]>].deduplicate>
    - define speakers <[all].filter_tag[<[filter_value].flag[chat_languages].contains[<[language]>].if_null[false]>]>
    - define others <[all].exclude[<[speakers]>]>
    - narrate targets:<[speakers]> <[final_known]>
    - narrate targets:<[others]> <[final_unknown]>

phones_command_phonelangcallyell:
    debug: false
    type: command
    name: phonelangcallyell
    aliases:
    - langcallyell
    - langcally
    description: Yell over the phone in a different language.
    usage: /phonelangcallyell (language) (message)
    permission: phones.command.phonelangcallyell
    tab complete:
    - if <context.server>:
        - determine <list[]>
    - if <player.has_flag[phones_call]>:
        - if <context.args.size> <= 1:
            - determine <player.flag[chat_languages].if_null[<list[]>]>
        - if <context.args.size> <= 2:
            - determine <list[<&lt>message<&gt>]>
    - determine <list[]>
    script:
    - define continue true
    - inject phones_command_call_language_common_routine
    - if !<[continue]>:
        - stop
    # speak...
    - define final_known "<&6>[<&7>P<&6>] <&f><placeholder[essentials_nickname].player[<player>]> <proc[chat_special_group].context[<player>]><proc[chat_roles_group].context[<player>]> <proc[character_get_name].context[<player>]> <&f>yells <&dq><&o><[message].to_uppercase><&f><&dq> in <[language]> over the phone."
    - define final_unknown "<&6>[<&7>P<&6>] <&f><placeholder[essentials_nickname].player[<player>]> <proc[chat_special_group].context[<player>]><proc[chat_roles_group].context[<player>]> <proc[character_get_name].context[<player>]> <&f>yells something in <[language]> over the phone."
    - define all <player.location.find_players_within[25].include[<[target]>].deduplicate>
    - define speakers <[all].filter_tag[<[filter_value].flag[chat_languages].contains[<[language]>].if_null[false]>]>
    - define others <[all].exclude[<[speakers]>]>
    - narrate targets:<[speakers]> <[final_known]>
    - narrate targets:<[others]> <[final_unknown]>

## PHONE UTILITIES
phones_commands_phonenumber:
    debug: false
    type: command
    name: phonenumber
    aliases:
    - number
    - pn
    description: View your phone number.
    usage: /phonenumber
    permission: phones.command.phonenumber
    script:
    # checks...
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    # ok
    - define number <player.flag[phones].get[number]>
    - narrate format:formats_prefix <proc[phones_nicer_format].context[<[number]>]>

## PHONE CONTACTS
phones_commands_phonecontacts:
    debug: false
    type: command
    name: phonecontacts
    aliases:
    - contacts
    description: View your contacts.
    usage: /phonecontacts (page)
    permission: phones.command.contacts
    tab completions:
        1: <&lt>page<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define contacts <player.flag[phones].get[contacts].if_null[<map[]>]>
    - if <[contacts].is_empty>:
        - run phones_contacts_print def.player:<player> def.page:0
        - stop
    - define page 0
    - if <context.args.size> >= 1:
        - define page <context.args.get[1]>
        - if !<[page].is_integer>:
            - narrate "<&c>The page must be an integer between 1 and <[contacts].size.sub[1].div_int[6].add[1]>."
            - stop
        - define page <[page].sub[1]>
        - if <[page]> < 0 || <[page]> > <[contacts].size.sub[1].div_int[6]>:
            - narrate "<&c>The page must be an integer between 1 and <[contacts].size.sub[1].div_int[6].add[1]>."
            - stop
    - run phones_contacts_print def.player:<player> def.page:<[page]>

phones_commands_phoneaddcontact:
    debug: false
    type: command
    name: phoneaddcontact
    aliases:
    - addcontact
    - ac
    description: Add a contact.
    usage: /phoneaddcontact (number) (name)
    permission: phones.command.phoneaddcontact
    tab completions:
        1: <&lt>number<&gt>
        2: <&lt>unique name<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> < 2:
        - narrate "<&c>Invalid use. Please try /<context.alias> (number) (name)."
        - stop
    - define number <context.args.get[1].replace[-].with[]>
    - define isnumber <[number].regex_matches[^[0-9]+$]>
    - if !<[isnumber]> || !<server.flag[phones].contains[<[number]>]>:
        - narrate "<&c>Number <context.args.get[1]> <&c>is not a valid number. Did you type it correctly?"
        - stop
    - define name <context.args.get[2].to_lowercase>
    - define isvalid <[name].regex_matches[^[a-z_]+$]>
    - if !<[isvalid]>:
        - narrate "<&c>Name <context.args.get[2]> <&c>is invalid. Contact names must only contain alphabetical characters and/or the underscore (_) character."
        - stop
    - if <player.flag[phones].get[contacts].contains[<[name]>].if_null[false]>:
        - narrate "<&c>You already have a contact named <[name]><&c>. Please pick a new name or manage your contacts from your home screen."
        - stop
    - define target <server.flag[phones].get[<[number]>]>
    - if <[target]> == <player>:
        - narrate "<&c>You can't add yourself as a contact!"
        - stop
    - if <player.flag[phones].get[contacts].values.contains[<[target]>].if_null[false]>:
        - define found
        - foreach <player.flag[phones].get[contacts]> key:whoname as:who:
            - if <[who]> == <[target]>:
                - define found <[whoname]>
                - foreach stop
        - narrate "<&c>You already have this contact added, using the contact name: <[found]><&c>."
        - stop
    - define contacts <player.flag[phones].get[contacts].if_null[<map[]>]>
    - define contacts <[contacts].with[<[name]>].as[<[target]>]>
    - flag <player> phones:<player.flag[phones].with[contacts].as[<[contacts]>]>
    - narrate format:formats_prefix "Added new contact <[name]> <&7>, targetting phone number <[number]>."

phones_commands_phoneremovecontact:
    debug: false
    type: command
    name: phoneremovecontact
    aliases:
    - removecontact
    - rc
    description: Remove a contact.
    usage: /phoneremovecontact (number) (name)
    permission: phones.command.phoneremovecontact
    tab completions:
        1: <player.flag[phones].get[contacts].keys.if_null[<list[]>]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> < 1:
        - narrate "<&c>Invalid use. Please try /<context.alias> (name)."
        - stop
    - define name <context.args.get[1].to_lowercase>
    - if !<player.flag[phones].get[contacts].contains[<[name]>].if_null[false]>:
        - narrate "<&c>You do not have a contact named <[name]>."
        - stop
    - define contacts <player.flag[phones].get[contacts].if_null[<map[]>]>
    - define contacts <[contacts].exclude[<[name]>]>
    - flag <player> phones:<player.flag[phones].with[contacts].as[<[contacts]>]>
    - narrate format:formats_prefix "Removed contact <&e><[name]><&7>."

## TEXT MESSAGES
phones_commands_phonetext:
    debug: false
    type: command
    name: phonetext
    aliases:
    - text
    description: Text a number or a contact!
    usage: /phonetext (number/contact) (message)
    permission: phones.command.phonetext
    tab completions:
        1: <player.flag[phones].get[contacts].keys.if_null[<list[]>]>
        2: <&lt>message<&gt>
    script:
    # checks...
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> < 2:
        - narrate "<&c>Invalid use. Please try /<context.alias> (number/contact) (message)."
        - stop
    # definitions
    - define receiver <context.args.get[1].replace[-].with[]>
    - define message <context.args.get[2].to[last].space_separated>
    - define target <proc[phones_get_owner].context[<player>|<[receiver]>]>
    # no phone
    - if !<player.item_in_hand.flag[phones].if_null[false]>:
        - narrate "<&c>Please hold a phone in your hand, and ensure it is powered on."
        - stop
    # invalid number/contact
    - if <[target]> == null:
        - narrate "<&c>Invalid phone number or contact <&e><[receiver]><&c>. Please try again."
        - stop
    # lmao
    - if <player> == <[target]>:
        - narrate "<&c>You can't text yourself!"
        - stop
    # blocked
    - if <player.flag[phones].get[blocked].contains[<[target]>].if_null[false]>:
        - narrate "<&c>The receiver is currently in your blocked numbers."
        - stop
    - if <[target].flag[phones].get[blocked].contains[<player>].if_null[false]>:
        - narrate "<&c>The receiver is unable to be contacted at this time. Try again later."
        - stop
    # send text...
    - run phones_texts_store def.player:<player> def.target:<[target]> def.contents:<[message]>

## BLOCKED
phones_commands_phoneblock:
    debug: false
    type: command
    name: phoneblock
    aliases:
    - phoneunblock
    - phblock
    - phunblock
    description: Add a contact.
    usage: /phoneblock (number))
    permission: phones.command.phoneblock
    tab completions:
        1: <list[<&lt>number<&gt>].include[<player.flag[phones].get[blocked].parse_tag[<[parse_value].flag[phones].get[number]>].if_null[<list[]>]>]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> < 1:
        - narrate "<&c>Invalid use. Please try /<context.alias> (number)."
        - stop
    #
    - define number <context.args.get[1].replace[-].with[]>
    - define isnumber <[number].regex_matches[^[0-9]+$]>
    - if !<[isnumber]> || !<server.flag[phones].contains[<[number]>]>:
        - narrate "<&c>Number <context.args.get[1]> <&c>is not a valid number. Did you type it correctly?"
        - stop
    #
    - define target <server.flag[phones].get[<[number]>]>
    - if <[target]> == <player>:
        - narrate "<&c>You can't block your own phone number!"
        - stop
    #
    - if !<player.flag[phones].get[blocked].contains[<[target]>].if_null[false]>:
        - define blocked <player.flag[phones].get[blocked].if_null[<list[]>]>
        - define blocked <[blocked].include[<[target]>]>
        - flag <player> phones:<player.flag[phones].with[blocked].as[<[blocked]>]>
        - narrate format:formats_prefix "<&c>Blocked <&7>phone number <&e><[number]><&7>."
    - else:
        - define blocked <player.flag[phones].get[blocked].if_null[<list[]>]>
        - define blocked <[blocked].exclude[<[target]>]>
        - flag <player> phones:<player.flag[phones].with[blocked].as[<[blocked]>]>
        - narrate format:formats_prefix "<&a>Unblocked <&7>phone number <&e><[number]><&7>."
