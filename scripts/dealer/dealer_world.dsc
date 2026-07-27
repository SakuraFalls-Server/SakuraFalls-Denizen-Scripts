dealer_interact_dropbox:
    debug: false
    type: world
    events:
        on player right clicks player_head:
        - if <server.has_flag[dealer_order_cooldown]>:
            - stop
        - if !<server.has_flag[dealer_loc]>:
            - stop
        - if <context.location> != <server.flag[dealer_loc].as[location]>:
            - stop
        - determine cancelled passively
        - run dealer_interact_dropbox_task
        after server start:
        - if <server.flag[dealer_loc].if_null[null]> != null:
            - flag server dealer_order_cooldown:!

dealer_interact_dropbox_task:
    debug: false
    type: task
    definitions: player
    script:
    - if <[player].has_flag[textbox_state]>:
        - stop
    - if <[player].inventory.empty_slots> < <server.flag[dealer_order_total_quantity]>:
        - narrate "<&c>You need to make more room in your inventory."
        - stop
    - run storyboard_player_begin_atomic_sequence def.queue:<queue> def.player:<[player]>
    - ~run textbox_write def.player:<[player]> def.queue:<queue> "def.line3s:[!] $$nl You opened the dropbox"
    - ~run textbox_write def.player:<[player]> def.queue:<queue> "def.line3s:You found an assortment $$nlof different weapons"
    - ~run dealer_give_actual_items def.player:<[player]>
    - flag server dealer_loc:!
    - flag server dealer_order:!
    - flag server dealer_order_total_quantity:!
    - adjust server save
    - run storyboard_player_end_atomic_sequence def.queue:<queue> def.player:<[player]>

dealer_give_actual_items:
    debug: false
    type: task
    definitions: player
    script:
    - define args <server.flag[dealer_order]>
    - define data <script[dealer_data].data_key[items]>
    - repeat <[args].size.div[2].round_down> as:number:
        - define item_key <[args].get[<[number]>]>
        - define qty <[args].get[<[number].add[1]>]>
        - define item_data <[data].get[<[item_key]>]>
        - define material <[data].get[material]>
        - define cmd <[data].get[custom_model_data]>
        - define name <&c><[data].get[name]>
        - define lore <[data].get[lore].parse_tag[<&7><&o><[parse_value]>]>
        - repeat <[qty]>:
            - ~run itemregistry_generate_item def.initial_holder:<[player]> def.item:<[material]> def.cmd:<[cmd]> save:item
            - define created_item <entry[item].created_queue.determination.get[1]>
            - define uuid <[created_item].flag[itemregistry]>
            - define actual_slot <[player].inventory.map_slots.filter_tag[<[filter_value].flag[itemregistry].if_null[null].equals[<[uuid]>]>].keys.get[1]>
            - define actual_item <[player].inventory.map_slots.get[<[actual_slot]>]>
            - adjust def:actual_item display:<[name]>
            - adjust def:actual_item  lore:<[lore]>
            - ~run itemregistry_adjust_actual_item def.uuid:<[uuid]> def.new_item:<[actual_item]>
            - inventory set player:<[player]> slot:<[actual_slot]> origin:<[actual_item]>
        - define index <[index].add[2]>