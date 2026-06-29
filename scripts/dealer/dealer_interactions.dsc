dealer_interact_dropbox:
    debug: false
    type: world
    events:
        on player right clicks block:
        - if !<context.location.note_name.if_null[null].starts_with[dealer_Location]>:
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
    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:You found an assortment of different weapons"
    