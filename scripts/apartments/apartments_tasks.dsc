apartments_at:
    debug: false
    type: procedure
    definitions: location
    script:
    - determine <[location].regions.filter_tag[<[filter_value].id.starts_with[apt-]>].get[1].if_null[null]>

apartments_owner:
    debug: false
    type: procedure
    definitions: apartment
    script:
    - determine <[apartment].owners.get[1].if_null[null]>

apartments_access:
    debug: false
    type: procedure
    definitions: player|location
    script:
    - define apartment <proc[apartments_at].context[<[location]>]>
    - if <[apartment]> == null:
        - determine true
    - define owner <proc[apartments_owner].context[<[apartment]>]>
    - if <[owner]> == null:
        - determine false
    - if <[owner]> == <[player]>:
        - determine true
    - define access <[owner].flag[apartments_access].get[<[apartment]>].get[<[player]>].if_null[null]>
    - if <[access]> == null:
        - determine false
    - determine true

apartments_access_level:
    debug: false
    type: procedure
    definitions: player|location
    script:
    - define apartment <proc[apartments_at].context[<[location]>]>
    - if <[apartment]> == null:
        - determine null
    - define owner <proc[apartments_owner].context[<[apartment]>]>
    - if <[owner]> == null:
        - determine none
    - if <[owner]> == <[player]>:
        - determine owner
    - define access <[owner].flag[apartments_access].get[<[apartment]>].get[<[player]>].if_null[null]>
    - if <[access]> == null:
        - determine none
    - determine <[access]>

apartments_add_member:
    debug: false
    type: task
    definitions: apartment|member
    script:
    - define owner <proc[apartments_owner].context[<[apartment]>]>
    - if <[owner]> == null:
        - stop
    - define access_all <[owner].flag[apartments_access].get[<[apartment]>].if_null[<map[]>].with[<[member]>].as[member]>
    - flag <[owner]> apartments_access:<[owner].flag[apartments_access].if_null[<map[]>].with[<[apartment]>].as[<[access_all]>]>
    - execute as_server "as addfriend <[member].name> <[apartment].id>"

apartments_add_moderator:
    debug: false
    type: task
    definitions: apartment|moderator
    script:
    - define owner <proc[apartments_owner].context[<[apartment]>]>
    - if <[owner]> == null:
        - stop
    - execute as_server "rg addmember <[apartment].id> <[moderator].name> -w <[apartment].world.name>"
    - define access_all <[owner].flag[apartments_access].get[<[apartment]>].if_null[<map[]>].with[<[moderator]>].as[moderator]>
    - flag <[owner]> apartments_access:<[owner].flag[apartments_access].if_null[<map[]>].with[<[apartment]>].as[<[access_all]>]>
    - execute as_server "as addfriend <[moderator].name> <[apartment].id>"

apartments_remove_access:
    debug: false
    type: task
    definitions: apartment|member
    script:
    - define owner <proc[apartments_owner].context[<[apartment]>]>
    - if <[owner]> == null:
        - stop
    - execute as_server "rg removemember <[apartment].id> <[member].name> -w <[apartment].world.name>"
    - define access_all <[owner].flag[apartments_access].get[<[apartment]>].if_null[<map[]>].exclude[<[member]>]>
    - flag <[owner]> apartments_access:<[owner].flag[apartments_access].if_null[<map[]>].with[<[apartment]>].as[<[access_all]>]>
    - execute as_server "as delfriend <[member].name> <[apartment].id>"

apartments_begin_edit:
    debug: false
    type: task
    definitions: apartment|player
    script:
    - definemap apartments_edit_data:
        apartment: <[apartment]>
        inventory: <[player].inventory.map_slots>
    - flag <[player]> apartments_edit:<[apartments_edit_data]>
    - inventory clear player:<[player]>
    - adjust <[player]> gamemode:creative

apartments_end_edit:
    debug: false
    type: task
    definitions: player
    script:
    - define apartments_edit_data <[player].flag[apartments_edit]>
    - inventory clear player:<[player]>
    - foreach <[apartments_edit_data].get[inventory]> key:slot as:item:
        - inventory set origin:<[item]> slot:<[slot]> player:<[player]>
    - adjust <[player]> gamemode:survival
    - flag <[player]> apartments_edit:!

apartments_all_with_access:
    debug: false
    type: procedure
    definitions: player
    script:
    - define location <player.location>
    - define apartment <proc[apartments_at].context[<[location]>]>
    - if <[apartment]> == null:
        - determine <list[]>
    - define owner <proc[apartments_owner].context[<[apartment]>]>
    - if <[owner]> != <[player]>:
        - determine <list[]>
    - determine <[owner].flag[apartments_access].get[<[apartment]>].if_null[<list[]>].keys>
