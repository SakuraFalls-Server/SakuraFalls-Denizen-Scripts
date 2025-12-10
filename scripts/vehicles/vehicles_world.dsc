vehicles_world:
    debug: false
    type: world
    events:
        # cleanup lost vehicles
        after server start:
        - flag server vehicles:!
        - foreach <server.worlds> as:world:
            - foreach <[world].entities> as:entity:
                - if <[entity].has_flag[vehicles]>:
                    - run vehicle_pickup def.vehicle_entity:<[entity]>
        on player quits:
        - if <player.has_flag[vehicles]>:
            - define vehicle <player.flag[vehicles]>
            - run vehicle_pickup def.vehicle_entity:<[vehicle]>
        # vehicle tick
        on tick:
        - ratelimit server 1t
        - define remove <list[]>
        - foreach <server.flag[vehicles].if_null[<list[]>]> as:vehicle:
            - if !<[vehicle].is_spawned>:
                - define remove <[remove].include[<[vehicle]>]>
                - foreach next
            - run vehicle_world_parallel_loop def.vehicle:<[vehicle]>
        - flag server vehicles:<server.flag[vehicles].if_null[<list[]>].exclude[<[remove]>]>
        # vehicle safety
        on armor_stand damaged:
        - if <context.entity.has_flag[vehicles]>:
            - determine cancelled
        # add passenger on click or pickup vehicle
        on player right clicks armor_stand bukkit_priority:lowest:
        - if !<context.entity.has_flag[vehicles]>:
            - stop
        - determine cancelled passively
        - if <context.entity.has_passenger>:
            - stop
        - if <context.entity.flag[vehicles]> == model:
            - define driver_entity <context.entity.flag[vehicles_data].get[driver_entity]>
            - if <[driver_entity].has_passenger>:
                - stop
            - if <context.entity.flag[vehicles_data].get[owner]> != <player> && !<player.is_op>:
                - stop
            - if <player.is_sneaking>:
                - run vehicle_pickup def.vehicle_entity:<context.entity>
            - else:
                - adjust <[driver_entity]> passenger:<player>
        - else if <context.entity.flag[vehicles]> == driver:
            - define model_entity <context.entity.flag[vehicles_data]>
            - if <context.entity.has_passenger>:
                - stop
            - if <[model_entity].flag[vehicles_data].get[owner]> != <player> && !<player.is_op>:
                - stop
            - if <player.is_sneaking>:
                - run vehicle_pickup def.vehicle_entity:<[model_entity]>
            - else:
                - adjust <context.entity> passenger:<player>
        - else if <context.entity.flag[vehicles]> == passenger:
            - adjust <context.entity> passenger:<player>
        # vehicle control
        on player steers armor_stand:
        - if <context.entity.flag[vehicles].if_null[null]> != driver:
            - stop
        - define vehicle <context.entity.flag[vehicles_data]>
        - flag <[vehicle]> vehicles_player_input:<map[].with[forward].as[<context.forward>].with[sideways].as[<context.sideways>]>
        # place vehicle down
        on player right clicks block:
        - if <player.item_in_hand.has_flag[vehicles]>:
            - determine cancelled passively
            - if <player.has_flag[vehicles]>:
                - narrate "<&c>You have spawned a vehicle already. Want to pick it up?"
                - define vehicle <player.flag[vehicles]>
                - clickable save:pickup until:1m usages:1:
                    - run vehicle_pickup def.vehicle_entity:<[vehicle]>
                - narrate <&e><underline><element[Pick up].on_click[<entry[pickup].command>]>
                - stop
            - ~run vehicle_create def.vehicle_id:<player.item_in_hand.flag[vehicles]> def.owner:<player> def.location:<player.location> save:result
            - define vehicle <entry[result].created_queue.determination.get[1]>
            - flag <player> vehicles:<[vehicle]>
            - if <player.gamemode> != creative:
                - take iteminhand

vehicle_world_parallel_loop:
    debug: false
    type: task
    definitions: vehicle
    script:
    - if !<[vehicle].flag[vehicles_data].get[driver_entity].has_passenger>:
        - flag <[vehicle]> vehicles_player_input:!
    - define vehicles_player_input <[vehicle].flag[vehicles_player_input].if_null[null]>
    - define forward <[vehicles_player_input].get[forward].if_null[0]>
    - define sideways <[vehicles_player_input].get[sideways].if_null[0]>
    - if <[forward]> != 0:
        - define speed <[vehicle].flag[vehicles_speed].if_null[0]>
        - define speed <[speed].add[<[vehicle].flag[vehicles_data].get[acceleration].mul[<[forward]>]>]>
        - define max <[vehicle].flag[vehicles_data].get[max_speed]>
        - if <[speed]> < <[max].mul[-1].div[3]>:
            - define speed <[max].mul[-1].div[3]>
        - if <[speed]> > <[max]>:
            - define speed <[max]>
        - flag <[vehicle]> vehicles_speed:<[speed]>
    - if <[sideways]> != 0:
        - define speed <[vehicle].flag[vehicles_speed].if_null[0]>
        - if <[speed].abs> > 0.1:
            - define max_speed <[vehicle].flag[vehicles_data].get[max_speed]>
            - define speed_turn_coefficient <[speed].div[<[max_speed]>].mul[0.25].add[0.85]>
            - define turn_speed <[vehicle].flag[vehicles_data].get[turn_speed_percentage].mul[360].mul[<[speed_turn_coefficient]>]>
            - define turn_speed <[turn_speed].mul[<[sideways]>].mul[-1].mul[<tern[<[speed].is_less_than[0]>].pass[-1].fail[1]>]>
            - rotate <[vehicle]> duration:1t yaw:<[turn_speed]>
    - define speed <[vehicle].flag[vehicles_speed].if_null[0]>
    - if <[speed].abs> < 0.1:
        - define speed 0
    - else:
        - define speed <[speed].div[1.015]>
    - if <[speed]> >= 0:
        - define ray_cast_location <[vehicle].location.above[0.5].ray_trace[range=<[speed].abs>].if_null[null]>
    - else:
        - define backwards <[vehicle].location.direction.vector.mul[-1]>
        - define ray_cast_location <[vehicle].location.with_pitch[<[backwards].pitch>].with_yaw[<[backwards].yaw>].above[0.5].ray_trace[range=<[speed].abs>].if_null[null]>
    - if <[ray_cast_location]> != null:
        - define new_location <[ray_cast_location].with_pitch[<[vehicle].location.pitch>].with_yaw[<[vehicle].location.yaw>]>
        - define speed <[speed].div[1.075]>
    - else:
        - define new_location <[vehicle].location.forward_flat[<[speed]>]>
    - define snap <proc[vehicle_find_snap_location].context[<[new_location]>]>
    - if <[snap]> != null:
        - if <[snap]> == collide:
            - define new_location <[vehicle].location>
            - define speed <[speed].div[1.1]>
        - else:
            - define new_location <[snap]>
    - if !<[new_location].below[0.25].material.is_solid>:
        - define new_location <[new_location].add[0,-<element[<[vehicle].location.y.sub[<[vehicle].location.below[0.15].y.round_down>]>].min[0.25].sub[0.001]>,0]>
    - if <[vehicle].flag[vehicles_speed].if_null[0]> != 0:
        - if <[speed].abs> > 0:
            - teleport <[vehicle]> <[new_location]> cause:plugin offthread_repeat:8
            - flag <[vehicle]> vehicles_speed:<[speed]>
    - if <[vehicle].flag[vehicles_data].get[driver_entity].has_passenger>:
        - playsound <[new_location]> custom sound:vehicle.engine pitch:<element[0.5].add[<[speed].abs.mul[32].mod[24].round_down.div[18]>]>
    - if <[vehicle].flag[vehicles_last_location]> == <[new_location]>:
        - stop
    - define driver_entity <[vehicle].flag[vehicles_data].get[driver_entity]>
    - define driver_offset <[vehicle].flag[vehicles_data].get[driver_offset]>
    - teleport <[driver_entity]> <proc[vehicle_relative_location].context[<[new_location]>|<[driver_offset]>]> cause:plugin offthread_repeat:8
    - foreach <[vehicle].flag[vehicles_data].get[passenger_entities]> key:passenger_entity as:passenger_offset:
        - teleport <[passenger_entity]> <proc[vehicle_relative_location].context[<[new_location]>|<[passenger_offset]>]> cause:plugin offthread_repeat:8
    - flag <[vehicle]> vehicles_last_location:<[vehicle].location>
