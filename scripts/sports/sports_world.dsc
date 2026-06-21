sports_arena_collision_world:
    debug: false
    type: world
    events:
        on custom event id:ball_move:
        - if !<context.ball_id.starts_with[sports_]>:
            - stop
        - define arena <proc[sports_arena].context[<context.ball_id>]>
        - define cuboid <[arena].get[cuboid]>
        - define corners <[cuboid].corners>
        # axis-aligned boundary reflection algorithm
        - define min <[corners].get[1]>
        - define max <[corners].get[8]>
        - define damping 0.75
        - define new_next <context.next>
        - define new_velocity <context.velocity_t1>
        - define bounced false
        - define min_x <[min].x>
        - define max_x <[max].x>
        - define min_y <[min].y>
        - define max_y <[max].y>
        - define min_z <[min].z>
        - define max_z <[max].z>
        # X
        - if <[new_next].x> < <[min_x]>:
            - define new_next <[new_next].with_x[<[min_x]>]>
            - define new_velocity <[new_velocity].with_x[<[new_velocity].x.mul[-<[damping]>]>]>
            - define bounced true
        - if <[new_next].x> > <[max_x]>:
            - define new_next <[new_next].with_x[<[max_x]>]>
            - define new_velocity <[new_velocity].with_x[<[new_velocity].x.mul[-<[damping]>]>]>
            - define bounced true
        # Y
        - if <[new_next].y> < <[min_y]>:
            - define new_next <[new_next].with_y[<[min_y]>]>
            - define new_velocity <[new_velocity].with_y[<[new_velocity].y.mul[-<[damping]>]>]>
            - define bounced true
        - if <[new_next].y> > <[max_y]>:
            - define new_next <[new_next].with_y[<[max_y]>]>
            - define new_velocity <[new_velocity].with_y[<[new_velocity].y.mul[-<[damping]>]>]>
            - define bounced true
        # Z
        - if <[new_next].z> < <[min_z]>:
            - define new_next <[new_next].with_z[<[min_z]>]>
            - define new_velocity <[new_velocity].with_z[<[new_velocity].z.mul[-<[damping]>]>]>
            - define bounced true
        - if <[new_next].z> > <[max_z]>:
            - define new_next <[new_next].with_z[<[max_z]>]>
            - define new_velocity <[new_velocity].with_z[<[new_velocity].z.mul[-<[damping]>]>]>
            - define bounced true
        # update to bounce
        - if <[bounced]>:
            - determine output:<[new_next]> passively
            - determine output:<[new_velocity]> passively
        on player walks:
        - if !<player.has_flag[sports]>:
            - define arenas <server.flag[sports_arenas]>
            - foreach <[arenas]> as:arena:
                - if <[arena].get[cuboid].contains[<context.new_location>]> && !<[arena].get[cuboid].contains[<context.old_location>]>:
                    - if <player.gamemode> == survival || <player.gamemode> == adventure:
                        - determine cancelled passively
                    - run sports_arena_enter_arena_prompt def.id:<[arena].get[id]> def.player:<player>
                    - stop
        - else:
            - define arena_id <player.flag[sports].get[id]>
            - define arena <proc[sports_arena].context[<[arena_id]>]>
            - if !<[arena].get[cuboid].contains[<context.new_location>]> && !<[arena].get[cuboid].contains[<context.old_location>]>:
                - if <player.gamemode> == survival || <player.gamemode> == adventure:
                    - determine cancelled passively
                - run sports_arena_exit_arena_prompt def.id:<[arena_id]> def.player:<player>
        on player quits:
        - if !<player.has_flag[sports]>:
            - stop
        - define arena_id <player.flag[sports].get[id]>
        - run sports_arena_leave def.id:<[arena_id]> def.player:<player>

sports_arena_cleanup_world:
    debug: false
    type: world
    events:
        after server start:
        - foreach <server.flag[sports_arenas]> as:arena:
            - run sports_arena_cleanup def.id:<[arena].get[id]>
