sports_paintball_join:
    debug: false
    type: task
    definitions: player|arena_id|team
    script:
    - define extra  <proc[sports_arena].context[<[arena_id]>].get[extra_data]>
    - if <[team]> == red:
        - teleport <[player]> <[extra].get[red_start]>
    ## no team "purple". sports framework has 2 hard-coded teams, "red" and "blue"
    ## - else if <[team]> == blue:
    - else if <[team]> == purple:
        ##                                V~~~~ blue_start...
        - teleport <[player]> <[extra].get[purple_start]>
    - run sports_paintball_update_glow def.id:<[arena_id]>
    #
    ## let's use fakeitem here since you can just set it on player's slot:1, even if it
    ##  "removes" their main item. since it's "fake", it's not a real item change, i.e.
    ##   the server still thinks they have their item.
    - give glistering_melon_slice quantity:1 destination:<[player]...inventory>
    ##
    #
    - define count <proc[sports_arena_player_count].context[<[arena_id]>]>
    - if <[count]> == 2:
        - define teams <proc[sports_arena_teams].context[<[arena_id]>]>
        - repeat 3:
            ##                                                   v~~~ purple: CTRL + F to find & replace purple
            - title targets:<[team].get[red].include[<[team].get[purple]>]>
            - wait 1s
        - if <proc[sports_arena_player_count].context[<[arena_id]>]> < 2:
            - stop
        - run sports_paintball_restart_game def.id:<[arena_id]>
    - if <[count]> <2:
        - run sports_paintball_idle_game def.id:<[arena_id]>

sports_paintball_leave:
    debug: false
    type: task
    definitions: player|arena_id
    script:
    - define extra  <proc[sports_arena].context[<[arena_id]>].get[extra_data]>
    ## see line 16
    ## you can do "- inventory update player:<[player]>" to remove all fake items
    - inventory remove destination:<[player]...inventory> origin:glistening_melon_slice
    ##                     V~~~~~~~ <[extra]...>
    - teleport <[player]> <extra].get[exit]>
    - glow <[player]> reset
    - if <proc[sports_arena_player_count].context[<[arena_id]>]> <= 1:
        - run sports_paintball_idle_game def.id:<[arena_id]>

sports_paintball_redistribute:
    debug: false
    type: task
    definitions: arena_id|team
    script:
    - define extra  <proc[sports_arena].context[<[arena_id]>].get[extra_data]>
    ## <[to]> is undefined variable
    ## you have to - define to <...something...>
    - if <[to]> == red:
        - teleport <[team].get[red]> <[extra].get[red_start]>
    - else if <[team]> == purple:
        - teleport <[team].get[purple]> <[extra].get[purple_start]>
        ## same here, <[player]> is undefined. also, team blue not purple, ofc...
        - narrate targets:<[player]> format:format_prefix "You were automatically moved to the red team because the purple team had too many players." color:yellow
    - else if <[to]> == purple:
        - teleport <[team].get[purple]> <[extra].get[purple_start]>
        - narrate targets:<[team].get[purple]> format:format_prefix "You were automatically moved to the purple team because the red team had too many players." color:yellow
    ## extra space at the end..., DenizenScript is YAML so this annoys it
    ##                                                    V~~~~~~~~~~~~~~
    - run sports_paintball_update_glow def.id:<[arena_id]> 

sports_paintball_restart_game:
    debug: false
    type: task
    definitions: arena_id
    script:
    - define arena <proc[sports_arena].context[<[arena_id]>]>
    - define extra <[arena].get[extra_data]>
    - run sports_arena_redistribute def.id:<[arena_id]>
    - define teams <proc[sports_arena_teams].context[<[arena_id]>]>
    - run sports_paintball_update_glow def.id:<[arena_id]>
    - foreach <[teams].get[red]> as:red_player:
        - teleport <[red_player]> <[extra].get[red_start]>
    ## CTRL + F, replace purple with blue, blue is hardcoded
    - foreach <[teams].get[purple]> as:purple_player:
        - teleport <[purple_player]> <[extra].get[purple_start]>
    - run sports_arena_set_status def.id:<[arena_id]> def.status:normal
    - narrate targets:<[teams].get[red].include[<[teams].get[purple]>]> format:formats_prefix "Next round..."
    - title targets:<[teams].get[red].include[<[teams].get[purple]>]> "title:<&e>Next Round" fade_in:0 fade_out:0 stay:1s
    - playsound <[teams].get[red].include[<[teams].get[purple]>]> sound:BLOCK_NOTE_BLOCK_PLING pitch:1 volume:30

## think if the glow is needed for your minigame, if yes keep it
sports_paintball_update_glow:
    debug: false
    type: task
    definitions: arena_id
    script:
    - define teams <proc[sports_arena_teams].context[<[arena_id]>]>
    - foreach <[teams].get[red]> as:red_player:
        - glow <[red_player]> true for:<[teams].get[red]>
        - glow <[red_player]> false for:<[teams].get[purple]>
    ## CTRL + F, replace purple with blue, blue is hardcoded
    - foreach <[teams].get[purple]> as:purple_player:
        - glow <[purple_player]> true for:<[teams].get[purple]>
        - glow <[purple_player]> false for:<[teams].get[red]>

sports_paintball_idle_game:
    debug: false
    type: task
    definitions: arena_id
    script:
    - define extra <proc[sports_arena].context[<[arena_id]>].get[extra_data]>
    - define teams <proc[sports_arena_teams].context[<[arena_id]>]>
    - run sports_arena_set_status def.id:<[arena_id]> def.status:waiting
    - teleport <[teams].get[red].include[<[teams].get[purple]>]> <[extra].get[red_start]>
    - narrate targets:<[teams].get[red].include[<[teams].get[purple]>]> format:formats_prefix "Not enough players. Waiting..."
    - title targets:<[teams].get[red].include[<[teams].get[purple]>]> title:<&7>Waiting fade_in:0 fade_out:0 stay:3s
    - playsound <[teams].get[red].include[<[teams].get[purple]>]> sound:BLOCK_NOTE_BLOCK_HAT pitch:1 volume:30

sports_paintball_score_goal:
    debug: false
    type: task
    definitions: arena_id|team
    script:
    - run sports_arena_set_status def.id:<[arena_id]> def.status:goal
    - define teams <proc[sports_arena_teams].context[<[arena_id]>]>
    - if <[team]> == red:
        - title targets:<[teams].get[red].include[<[teams].get[purple]>]> "title:<&c>Point for Red" fade_in:0 fade_out:0 stay:2s
        - narrate targets:<[teams].get[red].include[<[teams].get[purple]>]> format:formats_prefix "<&c>Red team <&7>scored a point!"
    ## CTRL + F, replace purple with blue, blue is hardcoded
    - if <[team]> == purple:
        - title targets:<[teams].get[red].include[<[teams].get[purple]>]> "title:<&5>Point for Purple" fade_in:0 fade_out:0 stay:2s
        - narrate targets:<[teams].get[red].include[<[teams].get[purple]>]> format:formats_prefix "<&5>Purple team <&7>scored a point!"
    - playsound <[teams].get[red].include[<[teams].get[purple]>]> sound:BLOCK_NOTE_BLOCK_PLING pitch:2 volume:30
    - playsound <[teams].get[red].include[<[teams].get[purple]>]> sound:ENTITY_FIREWORK_ROCKET_TWINKLE_FAR pitch:1 volume:30
    - wait 3s
    - run sports_paintball_restart_game def.id:<[arena_id]>