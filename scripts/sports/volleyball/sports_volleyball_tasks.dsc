sports_volleyball_join:
    debug: false
    type: task
    definitions: id|player|team
    script:
    - define extra <proc[sports_arena].context[<[id]>].get[extra_data]>
    - if <[team]> == red:
        - teleport <[player]> <[extra].get[red_start]>
    - else if <[team]> == blue:
        - teleport <[player]> <[extra].get[blue_start]>
    - define count <proc[sports_arena_player_count].context[<[id]>]>
    - if <[count]> == 2:
        - define teams <proc[sports_arena_teams].context[<[id]>]>
        - repeat 3:
            - title targets:<[teams].get[red].include[<[teams].get[blue]>]> title:<&6><element[3].sub[<[value].sub[1]>]> fade_in:0 fade_out:0 stay:1s
            - wait 1s
        - if <proc[sports_arena_player_count].context[<[id]>]> < 2:
            - stop
        - run sports_volleyball_restart_game def.id:<[id]> def.side:red
        - stop
    - if <[count]> < 2:
        - run sports_volleyball_idle_game def.id:<[id]>

sports_volleyball_leave:
    debug: false
    type: task
    definitions: id|player
    script:
    - define extra <proc[sports_arena].context[<[id]>].get[extra_data]>
    - teleport <[player]> <[extra].get[exit]>
    - glow <[player]> reset
    - define ball <proc[ball_get].context[<[id]>].if_null[null]>
    - if <proc[sports_arena_player_count].context[<[id]>]> <= 1:
        - run sports_volleyball_idle_game def.id:<[id]>

sports_volleyball_redistribute:
    debug: false
    type: task
    definitions: id|player|from|to
    script:
    - define extra <proc[sports_arena].context[<[id]>].get[extra_data]>
    - if <[to]> == red:
        - teleport <[player]> <[extra].get[red_start]>
        - narrate targets:<[player]> format:formats_prefix "You were auto-balanced to the <&c>red team"
    - else if <[to]> == blue:
        - teleport <[player]> <[extra].get[blue_start]>
        - narrate targets:<[player]> format:formats_prefix "You were auto-balanced to the <&9>blue team"

sports_volleyball_restart_game:
    debug: false
    type: task
    definitions: id|side
    script:
    - define arena <proc[sports_arena].context[<[id]>]>
    - define extra <[arena].get[extra_data]>
    - run sports_arena_redistribute def.id:<[id]>
    - define teams <proc[sports_arena_teams].context[<[id]>]>
    - foreach <[teams].get[red]> as:red_player:
        - teleport <[red_player]> <[extra].get[red_start]>
    - foreach <[teams].get[blue]> as:blue_player:
        - teleport <[blue_player]> <[extra].get[blue_start]>
    - run sports_arena_set_status def.id:<[id]> def.status:<tern[<[side].equals[red]>].pass[red_start].fail[blue_start]>
    - define ball_start <tern[<[side].equals[red]>].pass[<[extra].get[red_ball_start]>].fail[<[extra].get[blue_ball_start]>]>
    - run ball_create def.id:<[id]> def.location:<[ball_start]> def.size:<[arena].get[ball_size]> def.display_item:<[arena].get[ball_display]> def.gravity_multiplier:<[arena].get[ball_gravity]>
    - narrate targets:<[teams].get[red].include[<[teams].get[blue]>]> format:formats_prefix "Next round..."
    - title targets:<[teams].get[red].include[<[teams].get[blue]>]> "title:<&e>Next Round" fade_in:0 fade_out:0 stay:1s
    - playsound <[teams].get[red].include[<[teams].get[blue]>]> sound:BLOCK_NOTE_BLOCK_PLING pitch:1 volume:30

sports_volleyball_idle_game:
    debug: false
    type: task
    definitions: id
    script:
    - define extra <proc[sports_arena].context[<[id]>].get[extra_data]>
    - define teams <proc[sports_arena_teams].context[<[id]>]>
    - run sports_arena_set_status def.id:<[id]> def.status:waiting
    - run ball_remove def.id:<[id]>
    - teleport <[teams].get[red]> <[extra].get[red_start]>
    - teleport <[teams].get[blue]> <[extra].get[blue_start]>
    - narrate targets:<[teams].get[red].include[<[teams].get[blue]>]> format:formats_prefix "Not enough players. Waiting..."
    - title targets:<[teams].get[red].include[<[teams].get[blue]>]> title:<&7>Waiting fade_in:0 fade_out:0 stay:3s
    - playsound <[teams].get[red].include[<[teams].get[blue]>]> sound:BLOCK_NOTE_BLOCK_HAT pitch:1 volume:30

sports_volleyball_score_goal:
    debug: false
    type: task
    definitions: id|team
    script:
    - run sports_arena_set_status def.id:<[id]> def.status:goal
    - define teams <proc[sports_arena_teams].context[<[id]>]>
    - if <[team]> == red:
        - title targets:<[teams].get[red].include[<[teams].get[blue]>]> "title:<&c>Point for Red" fade_in:0 fade_out:0 stay:2s
        - narrate targets:<[teams].get[red].include[<[teams].get[blue]>]> format:formats_prefix "<&c>Red team <&7>scored a goal!"
    - if <[team]> == blue:
        - title targets:<[teams].get[red].include[<[teams].get[blue]>]> "title:<&9>Point for Blue" fade_in:0 fade_out:0 stay:2s
        - narrate targets:<[teams].get[red].include[<[teams].get[blue]>]> format:formats_prefix "<&9>Blue team <&7>scored a goal!"
    - playsound <[teams].get[red].include[<[teams].get[blue]>]> sound:BLOCK_NOTE_BLOCK_PLING pitch:2 volume:30
    - playsound <[teams].get[red].include[<[teams].get[blue]>]> sound:ENTITY_FIREWORK_ROCKET_TWINKLE_FAR pitch:1 volume:30
    - wait 3s
    - run sports_volleyball_restart_game def.id:<[id]> def.side:<tern[<[team].equals[red]>].pass[red].fail[blue]>
