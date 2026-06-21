sports_football_world:
    debug: false
    type: world
    events:
        ## ball click
        on player damages entity bukkit_priority:low:
        - ratelimit <player> 10t
        - if !<context.entity.has_flag[ball]>:
            - stop
        - define ball <context.entity>
        - if <[ball].type> != slime:
            - define ball <proc[ball_get].context[<[ball].flag[ball]>]>
        - if !<[ball].flag[ball].starts_with[sports_football]>:
            - stop
        - if !<player.has_flag[sports]>:
            - stop
        - define arena_id <player.flag[sports].get[id]>
        - if !<[arena_id].starts_with[sports_football]>:
            - stop
        - if <proc[sports_arena_get_status].context[<[arena_id]>]> != normal:
            - stop
        - define min_y <player.eye_location.direction.vector.y>
        - if <[min_y]> < 0:
            - define min_y 0
        - define velo <[ball].flag[ball_velocity].normalize.mul[0.05]>
        - define kick <player.eye_location.direction.vector.mul[0.75].with_y[<[min_y]>].add[0,0.25,0].add[<[velo]>]>
        - if <player.is_sprinting>:
            - define kick <player.eye_location.direction.vector.with_y[0.25].mul[1.5]>
            - if !<player.is_on_ground>:
                - define kick <player.eye_location.direction.vector.with_y[0.75].mul[1.5]>
        - run ball_vector_add def.ball:<[ball]> def.vector:<[kick]>
        ## out of bounds & ball collision
        on player walks:
        - if !<player.has_flag[sports]>:
            - stop
        - define arena_id <player.flag[sports].get[id]>
        - if !<[arena_id].starts_with[sports_football]>:
            - stop
        - if <proc[sports_arena_get_status].context[<[arena_id]>]> != normal:
            - stop
        # ball collision
        - define ball <proc[ball_get].context[<[arena_id]>]>
        - if <player.location.y.add[0.1]> > <[ball].location.y>:
            - if <player.location.distance_squared[<[ball].location>]> < 0.5:
                - run ball_vector_add def.ball:<[ball]> def.vector:<[ball].location.sub[<player.location>].normalize.mul[0.5].add[0,0.05,0]>
                - ratelimit <player> 10t
        ## goal scoring
        on custom event id:ball_move bukkit_priority:low:
        - if !<context.ball_id.starts_with[sports_football]>:
            - stop
        - define arena_id <context.ball_id>
        - if <proc[sports_arena_get_status].context[<[arena_id]>]> != normal:
            - stop
        - define extra <proc[sports_arena].context[<[arena_id]>].get[extra_data]>
        - if <[extra].get[red_goal].contains[<context.now>]> || <[extra].get[red_goal].contains[<context.next>]>:
            - run sports_football_score_goal def.id:<[arena_id]> def.team:blue
        - else if <[extra].get[blue_goal].contains[<context.now>]> || <[extra].get[blue_goal].contains[<context.next>]>:
            - run sports_football_score_goal def.id:<[arena_id]> def.team:red
