vehicle_relative_location:
    debug: false
    type: procedure
    definitions: location|relative
    script:
    - define relative <[relative].split[,]>
    - define location <[location].forward_flat[<[relative].get[1]>]>
    - define location <[location].above[<[relative].get[2]>]>
    - define location <[location].left[<[relative].get[3]>]>
    - determine <[location]>

vehicle_create:
    debug: false
    type: task
    definitions: vehicle_id|owner|location
    script:
    - define location <[location].with_pitch[0]>
    #
    - define vehicle_id <[vehicle_id].to_lowercase>
    - define vehicle <map[]>
    - define vehicle_data <script[vehicles_config].data_key[vehicles].get[<[vehicle_id]>]>
    - define vehicle <[vehicle].with[id].as[<[vehicle_id]>]>
    - define vehicle <[vehicle].with[owner].as[<[owner]>]>
    - define vehicle <[vehicle].with[acceleration].as[<[vehicle_data].get[acceleration]>]>
    - define vehicle <[vehicle].with[max_speed].as[<[vehicle_data].get[max-speed]>]>
    - define vehicle <[vehicle].with[turn_speed_percentage].as[<[vehicle_data].get[turn-speed-percentage]>]>
    #
    - define vehicle_item <item[<[vehicle_data].get[material]>[custom_model_data=<[vehicle_data].get[custom-model-data]>]]>
    - define vehicle <[vehicle].with[name].as[<[vehicle_data].get[name].parsed>]>
    - define vehicle <[vehicle].with[item].as[<[vehicle_item]>]>
    #
    - spawn armor_stand <[location]> persistent reason:custom save:model
    - define model_entity <entry[model].spawned_entity>
    - adjust <[model_entity]> invulnerable:true
    - adjust <[model_entity]> visible:false
    - adjust <[model_entity]> equipment:<map[].with[helmet].as[<[vehicle_item]>]>
    - flag <[model_entity]> vehicles:model
    - define vehicle <[vehicle].with[model_entity].as[<[model_entity]>]>
    #
    - define driver_offset <[vehicle_data].get[driver-offset]>
    - define driver_location <proc[vehicle_relative_location].context[<[location]>|<[driver_offset]>]>
    - spawn armor_stand <[driver_location]> persistent reason:custom save:driver
    - define driver_entity <entry[driver].spawned_entity>
    - adjust <[driver_entity]> invulnerable:true
    - adjust <[driver_entity]> visible:false
    - adjust <[driver_entity]> gravity:false
    - flag <[driver_entity]> vehicles:driver
    - flag <[driver_entity]> vehicles_data:<[model_entity]>
    - define vehicle <[vehicle].with[driver_entity].as[<[driver_entity]>]>
    - define vehicle <[vehicle].with[driver_offset].as[<[driver_offset]>]>
    #
    - define passenger_entities <map[]>
    - foreach <[vehicle_data].get[passengers]> as:passenger_offset:
        - define passenger_location <proc[vehicle_relative_location].context[<[location]>|<[passenger_offset]>]>
        - spawn armor_stand <[location].add[<[passenger_offset]>]> persistent reason:custom save:passenger<[loop_index]>
        - define passenger_entity <entry[passenger<[loop_index]>].spawned_entity>
        - adjust <[passenger_entity]> invulnerable:true
        - adjust <[passenger_entity]> visible:false
        - adjust <[passenger_entity]> gravity:false
        - flag <[passenger_entity]> vehicles:passenger
        - flag <[passenger_entity]> vehicles_data:<[model_entity]>
        - define passenger_entities <[passenger_entities].with[<[passenger_entity]>].as[<[passenger_offset]>]>
    - define vehicle <[vehicle].with[passenger_entities].as[<[passenger_entities]>]>
    #
    - flag <[model_entity]> vehicles_data:<[vehicle]>
    - flag <[model_entity]> vehicles_last_location:<[model_entity].location.add[0,1,0]>
    - flag server vehicles:<server.flag[vehicles].if_null[<list[]>].include[<[model_entity]>]>
    - determine <[model_entity]>

vehicle_destroy:
    debug: false
    type: task
    definitions: vehicle_entity
    script:
    - define vehicle <[vehicle_entity].flag[vehicles_data].if_null[null]>
    - if <[vehicle]> == null:
        - debug error "Vehicle entity <[vehicle_entity]> is not a vehicle!"
        - stop
    - remove <[vehicle].get[driver_entity]>
    - remove <[vehicle].get[passenger_entities].keys>
    - remove <[vehicle_entity]>

vehicle_find_snap_location:
    debug: false
    type: procedure
    definitions: next_location
    script:
    - if !<script[vehicles_config].data_key[whitelisted_blocks].contains[<[next_location].below[0.5].material.name>]>:
        - determine collide
    - if <[next_location].above[0.15].material.is_solid>:
        - if !<[next_location].above.material.is_solid>:
            - determine <[next_location].above[0.5]>
        - else:
            - determine collide
    - determine null

vehicle_pickup:
    debug: false
    type: task
    definitions: vehicle_entity
    script:
    - define owner <[vehicle_entity].flag[vehicles_data].get[owner]>
    - define item <[vehicle_entity].flag[vehicles_data].get[item]>
    - adjust def:item display:<[vehicle_entity].flag[vehicles_data].get[name]>
    - flag <[item]> vehicles:<[vehicle_entity].flag[vehicles_data].get[id]>
    - if <[owner].inventory.can_fit[<[item]>]>:
        - give <[item]> player:<[owner]>
        - run vehicle_destroy def.vehicle_entity:<[vehicle_entity]>
        - flag <[owner]> vehicles:!
        - if <[owner].is_online>:
            - narrate targets:<[owner]> format:formats_prefix "Picked up previous vehicle!"
    - else:
        - if <[owner].is_online>:
            - narrate "<&c>You don't have enough space in your inventory to pick up the vehicle!"
        - else:
            # praying there's nothing there... will special-flag just in case
            - flag <[owner]> vehicles_i_need_help:<player.inventory.map_slots.get[18]>
            - adjust server save
            - inventory set slot:18 origin:<[item]> player:<[owner]>
            - run vehicle_destroy def.vehicle_entity:<[vehicle_entity]>
            - flag <[owner]> vehicles:!
