dealer_interact_dropbox:
    debug: true
    type: world
    events:
        on player right clicks player_head:
        - if !<server.has_flag[dealer_loc]>:
            - stop
        - if <context.location> != <server.flag[dealer_loc].as[location]>:
            - stop
        - determine cancelled passively
        - if <player.has_flag[textbox_state]>:
            - stop
        - run dealer_interact_dropbox_task

dealer_interact_dropbox_task:
    debug: false
    type: task
    script:
    - run storyboard_player_begin_atomic_sequence def.queue:<queue> def.player:<player>
    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:[!] $$nl You opened the dropbox"
    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:You found an assortment $$nlof different weapons"
    - foreach <server.flag[dealer_order]> as:entry:
      - define args <server.flag[dealer_order]>
    - define index 1
    - repeat <[args].size.div[2].round_down>:
        - define item <[args].get[<[index]>]>
        - define qty <[args].get[<[index].add[1]>]>
        - give <proc[itemdb_get].context[<[item]>]> quantity:<[qty]>
        - define index <[index].add[2]>
    - flag server dealer_loc:!
    - flag server dealer_order:!
    - run storyboard_player_end_atomic_sequence def.queue:<queue> def.player:<player>