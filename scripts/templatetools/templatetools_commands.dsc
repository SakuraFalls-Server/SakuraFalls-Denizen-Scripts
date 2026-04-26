templatetools_command_templatetools:
    debug: false
    type: command
    name: templatetools
    description: TemplateTools info.
    usage: /templatetools
    aliases:
    - tt
    permission: templatetools.command.tt
    tab completions:
        1: <list[]>
    script:
    - narrate format:templatetools_formats_main "TemplateTools (Denizen impl.) v1.0.0.0"
    - narrate format:templatetools_formats_main "Author: unsafemalloc"

templatetools_command_ttpack:
    debug: false
    type: command
    name: ttpack
    description: Changes pack for Template Tool usage.
    usage: /ttpack (pack)
    permission: templatetools.command.ttpack
    tab completions:
        1: <proc[templatetools_available_packs].context[<player>]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> != 1:
        - narrate "<&c>Invalid use. Please try /<context.alias> (pack)."
        - stop
    - if !<proc[templatetools_available_packs].contains[<context.args.get[1]>]>:
        - narrate "<&c>There is no such pack: <context.args.get[1]>"
        - stop
    - flag <player> templatetools_pack:<context.args.get[1]>
    - flag <player> templatetools_pack_index:1
    - ~run templatetools_schematic_set_index def.player:<player>
    - run templatetools_preview_queue def.player:<player> def.schematic:<player.flag[templatetools_schematic]>
    - narrate format:templatetools_formats_main "Set TemplateTools pack to <context.args.get[1]> (use /ttschematic to select a schematic)"

templatetools_command_ttschematic:
    debug: false
    type: command
    name: ttschematic
    description: Changes schematic for Template Tool usage.
    usage: /ttschematic (schematic)
    permission: templatetools.command.ttschematic
    tab completions:
        1: <proc[templatetools_available_schematics].context[<player>]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.size> != 1:
        - narrate "<&c>Invalid use. Please try /<context.alias> (schematic)."
        - stop
    - if !<player.has_flag[templatetools_pack]>:
        - narrate "<&c>Please select a template pack first using /ttpack."
        - stop
    - if !<proc[templatetools_available_schematics].context[<player>].contains[<context.args.get[1]>]>:
        - narrate "<&c>There is no such schematic: <context.args.get[1]>"
        - stop
    - if <schematic.list.contains[templatetools_<player.uuid>]>:
        - ~schematic unload name:templatetools_<player.uuid>
    - schematic load name:templatetools_<player.uuid> filename:<player.flag[templatetools_pack]>/<context.args.get[1]>
    - flag <player> templatetools_schematic:templatetools_<player.uuid>
    - narrate format:templatetools_formats_main "Set TemplateTools schematic to <context.args.get[1]> (you can preview it using a Spider Eye)"

templatetools_command_ttundo:
    debug: false
    type: command
    name: ttundo
    description: Undoes last operation.
    usage: /ttundo
    permission: templatetools.command.ttundo
    tab completions:
        1: <list[]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <player.flag[templatetools_undo].if_null[<list[]>].is_empty>:
        - narrate format:templatetools_formats_main "Nothing left to undo."
        - stop
    - run templatetools_pop_undo def.player:<player>
    - narrate format:templatetools_formats_main "Undid previous operation."

templatetools_command_ttsetcursor:
    debug: false
    type: command
    name: ttsetcursor
    aliases:
    - ttsc
    description: Sets blocks in WorldEdit selection using the material you're looking at.
    usage: /ttsetcursor
    permission: templatetools.command.ttsetcursor
    tab completions:
        1: <list[]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define material <player.cursor_on.material.if_null[null]>
    - if <[material]> == null:
        - narrate "<&c>Invalid material. Please look at a material to set first!"
        - stop
    - define we_selection <player.we_selection.if_null[null]>
    - if <[we_selection]> == null:
        - narrate "<&c>You must first make a WorldEdit selection."
        - stop
    - ~modifyblock <[we_selection]> <[material]> no_physics
    - narrate format:templatetools_formats_main "Set cursor blocks (<[we_selection].volume.if_null[?]>)."

templatetools_command_that:
    debug: false
    type: command
    name: that
    description: TemplateTools info.
    usage: /that
    permission: templatetools.command.that
    tab completions:
        1: <list[]>
    script:
    - define material <player.cursor_on.material.if_null[null]>
    - if <[material]> == null:
        - narrate "<&c>Nothing to copy."
    - define item <item[<[material].name>].if_null[null]>:
        - narrate "<&c>Nothing to copy."
    - inventory set slot:hand origin:<[item]>
    - narrate format:templatetools_formats_main "Copied <[material].name>."

templatetools_command_distributeover:
    debug: false
    type: command
    name: distributeover
    description: Finds a given distribution over an area. Very good for windows, lightposts, ceiling lights, etc.
    usage: /distributeover (desired-x) (desired-z) (material)
    permission: templatetools.command.distributeover
    tab completions:
        1: x
        2: z
        3: material
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - define we_selection <player.we_selection.if_null[null]>
    - if <[we_selection]> == null:
        - narrate "<&c>You must first make a WorldEdit selection."
        - stop
    - if <context.args.length> < 3:
        - narrate "<&c>Please provide a desired-x, desired-y, and material value."
        - stop
    - define desired_x <context.args.get[1]>
    - define desired_z <context.args.get[2]>
    - define material <context.args.get[3]>
    - if !<[desired_x].is_integer> || !<[desired_z].is_integer>:
        - narrate "<&c>Desired-x and desired-z must be integers!"
        - stop
    - if <[desired_x]> <= 0 || <[desired_z]> <= 0:
        - narrate "<&c>Desired-x and desired-z must be greater than 0!"
        - stop
    - define material <material[<[material]>].if_null[null]>
    - if <[material]> == null:
        - narrate "<&c>Material '<[material]>' is invalid!"
        - stop
    - define x_length <[we_selection].min.x.sub[<[we_selection].max.x>].abs.add[1]>
    - define z_length <[we_selection].min.z.sub[<[we_selection].max.z>].abs.add[1]>
    - define avg_y <[we_selection].center.y>
    - define x_count <[x_length].div[<[desired_x]>]>
    - define z_count <[z_length].div[<[desired_z]>]>
    - define x_distribution <[x_length].mod[<[desired_x]>].div[<[x_count]>]>
    - define z_distribution <[z_length].mod[<[desired_z]>].div[<[z_count]>]>
    - define x <[we_selection].min.x>
    - define undodata <map[]>
    - while <[x]> <= <[we_selection].max.x>:
        - define z <[we_selection].min.z>
        - while <[z]> <= <[we_selection].max.z>:
            - define at <location[<[x]>,<[avg_y]>,<[z]>,0,0,<player.world.name>]>
            - define undodata <[undodata].with[<[at]>].as[<[at].material>]>
            - modifyblock <[at]> <[material]> no_physics delayed
            - define z <[z].add[<[desired_z]>].add[<[z_distribution]>]>
        - define x <[x].add[<[desired_x]>].add[<[x_distribution]>]>
    - run templatetools_push_undo def.player:<player> def.data:<[undodata]>
    - narrate format:templatetools_formats_main "Distributed <[material].name> over x=<[x_length]>, z=<[z_length]> blocks."

templatetools_command_fastcommandpush:
    debug: false
    type: command
    name: fastcommandpush
    description: Adds a command to a fast command by name.
    usage: /fastcommandpush (name) (command)
    permission: templatetools.command.fastcommandpush
    tab completions:
        1: <server.flag[templatetools_fastcommands].keys.if_null[<list[]>]>
        2: command
    script:
    - if <context.args.length> < 2:
        - narrate "<&c>Please provide a name and command!"
        - stop
    - define name <context.args.get[1]>
    - define command <context.args.get[2].to[-1].space_separated>
    - run templatetools_fastcommand_store_push def.name:<[name]> def.command:<[command]>
    - narrate format:templatetools_formats_main "Pushed command '<[command]>' to fast command '<[name].to_lowercase>'."

templatetools_command_fastcommandpop:
    debug: false
    type: command
    name: fastcommandpop
    description: Removes a command from a fast command by name.
    usage: /fastcommandpop (name)
    permission: templatetools.command.fastcommandpoop
    tab completions:
        1: <server.flag[templatetools_fastcommands].keys.if_null[<list[]>]>
    script:
    - if <context.args.length> < 1:
        - narrate "<&c>Please provide a name and command."
        - stop
    - define name <context.args.get[1]>
    - if !<proc[templatetools_fastcommand_exists].context[<[name]>]>:
        - narrate "<&c>Fast command <[name].to_lowercase> is already empty."
        - stop
    - run templatetools_fastcommand_store_pop def.name:<[name]>
    - narrate format:templatetools_formats_main "Popped last command from fast command '<[name].to_lowercase>'."

templatetools_command_fastcommand:
    debug: false
    type: command
    name: fastcommand
    description: Executes all pushed commands sequentially as the player.
    usage: /fastcommand (name)
    permission: templatetools.command.distributeover
    tab completions:
        1: <server.flag[templatetools_fastcommands].keys.if_null[<list[]>]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>Please run this command as a player."
        - stop
    - if <context.args.length> < 1:
        - narrate "<&c>Please provide a name."
        - stop
    - define name <context.args.get[1]>
    - if !<proc[templatetools_fastcommand_exists].context[<[name]>]>:
        - narrate "<&c>Fast command <[name].to_lowercase> is empty."
        - stop
    - run templatetools_fastcommand_execute def.player:<player> def.name:<[name]>
