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
    - give <proc[itemdb_get].context[flip phone]> quantity:5
    - flag server dealer_loc: !
    - run storyboard_player_end_atomic_sequence def.queue:<queue> def.player:<player>