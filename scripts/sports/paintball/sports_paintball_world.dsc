sports_paintball_world:
    debug: false
    type: world
    events:
        # Detects when a player right clicks with their glisening melon slice
        # I think for the most part this works but i haven't tested it yet
        ## unfortunately, it doesn't right now.
        ## first, do `on player right clicks block:`
        # on player right clicks block:
        ##
        - if !<player.has_flag[sports]>:
            - stop
        - define arena_id <player.flag[sports].get[id]>
        - if !<[arena_id].starts_with[sports_paintball]>:
            - stop
        - if <proc[sports_arena_get_status].context[<[arena_id]>]> != normal:
            - stop
        - ratelimit <player> 5t
        # shoots a snowball when player clicks
        ## no need to comment this, your code below makes it clear I'd say
        - shoot snowball origin:<player.eye_location> speed:2.5 shooter:<player>
        ##
        ## no need for these flags, this is overcomplicated: see lines 42 -> 52, you will see what I mean.
        - flag <player> paintball_shooter:<player>
        - flag <player> paintball_team:<player.flag[sports].get[team]>
        ##
        # just plays a sound when snowball is shot
        ## same here, no comment needed
        - playsound <player.location> sound:entity.snowball.throw volume:1.5 pitch:1
        ##
        ## - - - - -
        ##
        # detects when a player hits another player with a snowball
        # i thought about how to get the snow ball to work when a player clicks on the slice but im not quote sure just how to do that without getting an error, i've looked it up but i'm not too sure myself
        ## try just "on projectile hits" or easier, "on snowball hits"
        ## you can check for player by doing entity:player (this is called a 'switch' on events)
        ## https://meta.denizenscript.com/Docs/Events/projectile%20hits
        ##
        # on snowball hits entity:player:
        ##
        on snowball hits player:
        - if !<context.projectile.has_flag[paintball_shooter]>:
            - stop
        ## try <context.hit_entity>, you know it's player if using entity:player switch
        - define victim <context.hit_player>
        ##
        ## no need. <context.shooter>
        - define shooter <context.projectile.flag[paintball_shooter]>
        ##
        ## overcomplicated. see below
        # - define shooter_team <[shooter].flag[sports].get[team]> returns what you want
        ##
        - define shooter_team <context.projectile.flag[paintball_team]>
        ##
        ## you meant <[shooter]> not <shooter> - you want the definition
        ## funnily, here you do almost what you wanted for <[shooter_team]> but instead you get id not team :P
        - define arena_id <shooter.flag[sports].get[id]>
        ##
        - if !<[victim].has_flag[sports]> && <[victim].flag[sports].get[id]> != <[arena_id]>:
            - stop
        ## lol, see above what i mean..
        - define victim_team <[victim].flag[sports].get[team]>
        ##
        - if <[shooter_team]> == <[victim_team]>:
            - stop
        ## we won't score a goal. just damage/remove the player or something
        - run <script[sports_paintball_score_goal]> def.id:<[arena_id]> def.shooter:<[shooter]> def.victim:<[victim]>
        ##
