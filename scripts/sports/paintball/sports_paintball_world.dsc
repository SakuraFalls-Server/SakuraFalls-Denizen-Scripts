sports_paintball_world:
    debug: false
    type: world
    events:
        # Detects when a player right clicks block
        on player right clicks block:
        - if !<player.has_flag[sports]>:
            - stop
        - define arena_id <player.flag[sports].get[id]>
        - if !<[arena_id].starts_with[sports_paintball]>:
            - stop
        - if <proc[sports_arena_get_status].context[<[arena_id]>]> != normal:
            - stop
        - ratelimit <player> 5t
        # shoots a snowball when player clicks
        - shoot snowball origin:<player.eye_location> speed:2.5 shooter:<player>
        # just plays a sound when snowball is shot
        - playsound <player.location> sound:entity.snowball.throw volume:1.5 pitch:1

        # detects when a player hits another player with a snowball with the entity
        on snowball hits entity:player:
        - if !<context.projectile.has_flag[paintball_shooter]>:
            - stop
            # i think? unless i just keep it as - define victim ?
        - define victim <context.hit_entity>
        - define shooter <context.shooter>
        - define shooter_team <[shooter].flag[sports].get[team]>
        # so i could put - define shooter_team <context.projectile.flag[id]> for the arena_id?
        - define arena_id <[shooter].flag[sports].get[id]>
        - if !<[victim].has_flag[sports]> && <[victim].flag[sports].get[id]> != <[arena_id]>:
            - stop
        - define victim_team <[victim].flag[sports].get[team]>
        - if <[shooter_team]> == <[victim_team]>:
            - stop
            # removed scoring
        - define extra <proc[sports_arena].context[<[arena_id]>].get[extra_data]>
        - teleport <[victim]> <[extra].get[<[victim_team]>_start]>
        - actionbar  "<&c>You were hit by <[shooter].name>!" targets:<[victim]>
        - actionbar "<&a>You hit <[victim].name>!" targets:<[shooter]>