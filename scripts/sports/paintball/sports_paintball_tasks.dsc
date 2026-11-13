sports_paintball_join:
    debug: false
    type: task
    definitions: player|arena_id|team
    script:
    - define extra  <proc[sports_arena].context[<[arena_id]>].get[extra_data]>
    - if <[team]> == red:
        - teleport <[player]> <[extra].get[red_start]>
    - else if <[team]> == blue:
        - teleport <[player]> <[extra].get[blue _start]>
    - fakeitem glistening_melon_slice slot:1 players:<[player]>
    - define count <proc[sports_arena_player_count].context[<[arena_id]>]>
    - if <[count]> == 2:
        - define teams <proc[sports_arena_teams].context[<[arena_id]>]>
        - repeat 3:
            - title targets:<[team].get[red].include[<[team].get[blue]>]>
            - wait 1s
        - if <proc[sports_arena_player_count].context[<[arena_id]>]> < 2:
            - stop
        - run sports_paintball_restart_game def.id:<[arena_id]>
    - if <[count]> <2:
        - run sports_paintball_idle_game def.id:<[arena_id]>
# changed everything to blue, removed glow, added fake item and remove fake item (i think i did it right)
sports_paintball_leave:
    debug: false
    type: task
    definitions: player|arena_id
    script:
    - define extra  <proc[sports_arena].context[<[arena_id]>].get[extra_data]>
    - inventory update  player:<[player]>
    - teleport <[player]> <[extra].get[exit]>
    - glow <[player]> reset
    - if <proc[sports_arena_player_count].context[<[arena_id]>]> <= 1:
        - run sports_paintball_idle_game def.id:<[arena_id]>

sports_paintball_redistribute:
    debug: false
    type: task
    definitions: arena_id|team|to|player
    script:
    - define extra  <proc[sports_arena].context[<[arena_id]>].get[extra_data]>
    - if <[to]> == red:
        - teleport <[team].get[red]> <[extra].get[red_start]>
    - else if <[team]> == blue:
        - teleport <[team].get[blue]> <[extra].get[blue_start]>
        - narrate targets:<[player]> format:format_prefix "You were automatically moved to the red team because the blue team had too many players." color:yellow
    - else if <[to]> == blue:
        - teleport <[team].get[blue]> <[extra].get[blue_start]>
        - narrate targets:<[team].get[blue]> format:format_prefix "You were automatically moved to the blue team because the red team had too many players." color:yellow

sports_paintball_restart_game:
    debug: false
    type: task
    definitions: arena_id
    script:
    - define arena <proc[sports_arena].context[<[arena_id]>]>
    - define extra <[arena].get[extra_data]>
    - run sports_arena_redistribute def.id:<[arena_id]>
    - define teams <proc[sports_arena_teams].context[<[arena_id]>]>
    - foreach <[teams].get[red]> as:red_player:
        - teleport <[red_player]> <[extra].get[red_start]>
    - foreach <[teams].get[blue]> as:blue_player:
        - teleport <[blue_player]> <[extra].get[blue_start]>
    - run sports_arena_set_status def.id:<[arena_id]> def.status:normal
    - narrate targets:<[teams].get[red].include[<[teams].get[blue]>]> format:formats_prefix "Next round..."
    - title targets:<[teams].get[red].include[<[teams].get[blue]>]> "title:<&e>Next Round" fade_in:0 fade_out:0 stay:1s
    - playsound <[teams].get[red].include[<[teams].get[blue]>]> sound:BLOCK_NOTE_BLOCK_PLING pitch:1 volume:30

sports_paintball_idle_game:
    debug: false
    type: task
    definitions: arena_id
    script:
    - define extra <proc[sports_arena].context[<[arena_id]>].get[extra_data]>
    - define teams <proc[sports_arena_teams].context[<[arena_id]>]>
    - run sports_arena_set_status def.id:<[arena_id]> def.status:waiting
    - teleport <[teams].get[red].include[<[teams].get[blue]>]> <[extra].get[red_start]>
    - narrate targets:<[teams].get[red].include[<[teams].get[blue]>]> format:formats_prefix "Not enough players. Waiting..."
    - title targets:<[teams].get[red].include[<[teams].get[blue]>]> title:<&7>Waiting fade_in:0 fade_out:0 stay:3s
    - playsound <[teams].get[red].include[<[teams].get[blue]>]> sound:BLOCK_NOTE_BLOCK_HAT pitch:1 volume:30

# should i just get rid of the scoring completely since its paintball and not anything else?
sports_paintball_score_goal:
    debug: false
    type: task
    definitions: arena_id|team
    script:
    - run sports_arena_set_status def.id:<[arena_id]> def.status:goal
    - define teams <proc[sports_arena_teams].context[<[arena_id]>]>
    - if <[team]> == red:
        - title targets:<[teams].get[red].include[<[teams].get[blue]>]> "title:<&c>Point for Red" fade_in:0 fade_out:0 stay:2s
        - narrate targets:<[teams].get[red].include[<[teams].get[blue]>]> format:formats_prefix "<&c>Red team <&7>scored a point!"
    - if <[team]> == blue:
        - title targets:<[teams].get[red].include[<[teams].get[blue]>]> "title:<&9>Point for Blue" fade_in:0 fade_out:0 stay:2s
        - narrate targets:<[teams].get[red].include[<[teams].get[blue]>]> format:formats_prefix "<&9>Blue team <&7>scored a point!"
    - playsound <[teams].get[red].include[<[teams].get[blue]>]> sound:BLOCK_NOTE_BLOCK_PLING pitch:2 volume:30
    - playsound <[teams].get[red].include[<[teams].get[blue]>]> sound:ENTITY_FIREWORK_ROCKET_TWINKLE_FAR pitch:1 volume:30
    - wait 3s
    - run sports_paintball_restart_game def.id:<[arena_id]>