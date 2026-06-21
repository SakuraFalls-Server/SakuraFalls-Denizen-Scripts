itemdb_command_itemdb:
    debug: false
    type: command
    name: itemdb
    usage: /itemdb [filter]
    description: Opens the Item Database, optionally with a filter name.
    permission: itemdb.command.itemdb
    tab completions:
        1: <&lt>filter<&gt>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define filter <context.args.get[1].if_null[null]>
    - run itemdb_menu def.player:<player> def.filter:<[filter]>

itemdb_command_itemdbadd:
    debug: false
    type: command
    name: itemdbadd
    usage: /itemdbadd
    description: Adds the item you hold in your hand to the Item Database.
    permission: itemdb.command.itemdbadd
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define item <player.item_in_hand>
    - if <[item].advanced_matches[air]>:
        - narrate "<&c>Please hold the item you want to add in your hand."
        - stop
    - if <proc[itemdb_has].context[<[item]>]>:
        - narrate "<&c>An item with this name or custom model data already exists in the database!"
        - stop
    - run itemdb_store def.item:<[item]>
    - narrate format:formats_prefix "Added item <[item].display> <&7>to the Item Database!"

itemdb_command_itemdbremove:
    debug: false
    type: command
    name: itemdbremove
    usage: /itemdbremove (name)
    description: Removes an item from the Item Database by name.
    permission: itemdb.command.itemdbremove
    tab completions:
        1: <server.flag[itemdb].if_null[<list[]>].parse[display].parse[strip_color].parse[to_lowercase].parse_tag[<[parse_value].replace[<&sp>].with[_]>]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> < 1:
        - narrate "<&c>Invalid use. Please try /<context.alias> (name)."
        - stop
    - define name <context.args.get[1].replace[_].with[<&sp>]>
    - if <proc[itemdb_get].context[<[name]>]> == null:
        - narrate "<&c>An item with this name could not be found in the database!"
        - stop
    - run itemdb_unstore def.name:<[name]>
    - narrate format:formats_prefix "Removed item <[name].to_lowercase> <&7>from the Item Database!"
