sports_volleyball_world:
    debug: false
    type: world
    events:
        ## ball click
        on player damages entity bukkit_priority:low:
        - ratelimit <player> 10t
        - define ball <context.entity>
        - if !<[ball].has_flag[ball]>:
            - stop
        - if <[ball].entity_type> == armor_stand:
            - define ball <proc[ball_get].context[<[ball].flag[ball]>]>
        - if !<[ball].flag[ball].starts_with[sports_volleyball]>:
            - stop
        - if !<player.has_flag[sports]>:
            - stop
        - define arena_id <player.flag[sports].get[id]>
        - if !<[arena_id].starts_with[sports_volleyball]>:
            - stop
        - define status <proc[sports_arena_get_status].context[<[arena_id]>]>
        - if <[status]> == normal:
            - if <player.location.with_y[<[ball].location.y>].distance_squared[<[ball].location>]> > 22:
                - stop
            - define y <player.eye_location.direction.vector.y>
            - if <[y]> < 0.45:
                - define y 0.45
            - if <[y]> > 0.95:
                - define y 0.95
            - define kick <player.eye_location.direction.vector.mul[0.58].with_y[<[y]>]>
            - if <player.is_sneaking>:
                - define kick <location[0,0.525,0]>
                - if !<player.is_on_ground>:
                    - define kick <location[0,0.375,0]>
                - define kick <[kick].add[<player.eye_location.direction.vector.with_y[0].mul[0.35]>]>
            - define kick <[kick].add[<location[0,0,0].sub[<[ball].flag[ball_velocity]>]>]>
            - run ball_vector_add def.ball:<[ball]> def.vector:<[kick]>
            - flag <[ball]> sports_volleyball_delay_score:!
        - else if <[status]> == blue_start || <[status]> == red_start:
            - run sports_arena_set_status def.id:<[arena_id]> def.status:normal
            - define kick <player.eye_location.direction.vector.mul[0.58].with_y[0.75]>
            - run ball_vector_add def.ball:<[ball]> def.vector:<[kick]>
        - playsound <[ball].location> sound:BLOCK_STONE_BREAK pitch:1.8
        ## point scored
        on custom event id:ball_move bukkit_priority:low:
        - if !<context.ball_id.starts_with[sports_volleyball]>:
            - stop
        - define arena_id <context.ball_id>
        - if <proc[sports_arena_get_status].context[<[arena_id]>]> != normal:
            - define status <proc[sports_arena_get_status].context[<[arena_id]>]>
            - if <[status]> == blue_start || <[status]> == red_start:
                - determine cancelled
            - stop
        - if !<context.ball.has_flag[sports_volleyball_delay_score]>:
            - if !<context.bounced>:
                - stop
            - flag <context.ball> sports_volleyball_delay_score:<util.current_time_millis>
            - stop
        - else:
            - if <util.current_time_millis.sub[<context.ball.flag[sports_volleyball_delay_score]>]> < 300:
                - stop
        - define extra <proc[sports_arena].context[<[arena_id]>].get[extra_data]>
        - define red_start <[extra].get[red_start]>
        - define blue_start <[extra].get[blue_start]>
        - if <context.next.distance_squared[<[red_start]>]> < <context.next.distance_squared[<[blue_start]>]>:
            - run sports_volleyball_score_goal def.id:<[arena_id]> def.team:blue
        - else:
            - run sports_volleyball_score_goal def.id:<[arena_id]> def.team:red
