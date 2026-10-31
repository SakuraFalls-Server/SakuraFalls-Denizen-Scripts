sports_paintball_world:
    debug: false
    type: world
    events:
        # Detects when a player right clicks with their glisening melon slice
        # I think for the most part this works but i haven't tested it yet
        - if !<player.has_flag[sports]>:
            - stop
        - define arena_id <player.flag[sports].get[id]>
        - if !<[arena_id].starts_with[sports_paintball]>:
            - stop
        - if <proc[sports_arena_get_status].context[<[arena_id]>]> != normal:
            - stop
        - ratelimit <player> 5t
        # shoots a snowbal when player clicks
        - shoot snowball origin:<player.eye_location> speed:2.5 shooter:<player>
        - flag <player> paintball_shooter:<player>
        - flag <player> paintball_team:<player.flag[sports].get[team]>
        # just plays a sound when snowball is shot
        - playsound <player.location> sound:entity.snowball.throw volume:1.5 pitch:1

        # detects when a player hits another player with a snowball
        # i thought about how to get the snow ball to work when a player clicks on the slice but im not quote sure just how to do that without getting an error, i've looked it up but i'm not too sure myself
        
        on snowball hits player:
        - if !<context.projectile.has_flag[paintball_shooter]>:
            - stop
        - define victim <context.hit_player>
        - define shooter <context.projectile.flag[paintball_shooter]>
        - define shooter_team <context.projectile.flag[paintball_team]>
        - define arena_id <shooter.flag[sports].get[id]>
        - if !<[victim].has_flag[sports]> && <[victim].flag[sports].get[id]> != <[arena_id]>:
            - stop
        - define victim_team <[victim].flag[sports].get[team]>
        - if <[shooter_team]> == <[victim_team]>:
            - stop
        - run <script[sports_paintball_score_goal]> def.id:<[arena_id]> def.shooter:<[shooter]> def.victim:<[victim]>