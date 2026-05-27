chestprotectinterop_world:
    debug: false
    type: world
    events:
        on internal bukkit event event:me.angeschossen.chestprotect.api.events.ProtectionPreCreationEvent:
        - define protect_player <context.reflect_event.reflect_field[player]>
        - define field_names <[protect_player].field_names>
        - foreach <[field_names]> as:field_name:
            - define field <[protect_player].reflect_field[<[field_name]>]>
            - define type <[field].simple_class_name.if_null[null]>
            ## evil protected code...
            - if <[type]> == CraftPlayer:
                - define player <[protect_player].read_field[<[field_name]>]>
                - if <[player].is_op>:
                    - stop
                - define location <context.reflect_event.read_field[location]>
                - if !<[location].regions.first.owners.if_null[<list[]>].contains[<[player]>]>:
                    - narrate targets:<[player]> "<&c>You do not have permission to lock here."
                    - determine cancelled
                - stop
