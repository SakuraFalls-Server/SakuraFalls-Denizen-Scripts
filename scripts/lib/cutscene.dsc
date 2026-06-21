#
# Cutscene - library for creating cool cutscenes similar to the Replay Mod
#
# Playing cutscenes can also be atomic, meaning that if the player leaves mid
# cutscene, the cutscene may interrupt the queue that called the task in order
# to prevent the script from continuing.

# Determines the set of points passing through the given points spaced by the given distance.
# Effectively, the points representing the lines going from p0 to p1, then p1 to p2, etc...
# The points have to be given escaped! So <[myinput].escaped>!
cutscene_concatenate_points_between:
    debug: false
    type: procedure
    definitions: points|distance
    script:
    - define points <[points].unescaped>
    - define result <list[]>
    - repeat <[points].size.sub[1]> as:index:
        - define result <[result].include[<[points].get[<[index]>].points_between[<[points].get[<[index].add[1]>]>].distance[<[distance]>]>]>
    - determine <[result]>

# Determines the Catmull-Rom spline passing through the given points, taking the distance
# between the resulting equidistant points and the resolution of the computation into account.
# Note that the efficiency of this algorithm is not amazing necessarily, so you should cache
# the results. Higher resolutions also mean the algorithm will take longer to finish.
# The points have to be given escaped! So <[myinput].escaped>!
cutscene_catmull_rom_equidistant_spline:
    debug: false
    type: procedure
    definitions: points|distance|resolution
    script:
    - define points <[points].unescaped>
    - define distance <[distance].if_null[0.25]>
    - define resolution <[resolution].if_null[100]>
    - if <[points].size> < 2:
        - determine <[points]>
    - if <[points].size> == 2:
        - determine <[points].get[1].points_between[<[points].get[2]>].distance[<[distance]>]>
    - define spline_points <list[]>
    - define cumulative_distances <list[<element[0]>]>
    - repeat <[points].size.sub[1]> from:0 as:segment_index:
        - if <[segment_index]> == 0:
            - define p0 <[points].get[1].sub[<[points].get[2].sub[<[points].get[1]>]>]>
            - define p1 <[points].get[1]>
            - define p2 <[points].get[2]>
            - define p3 <tern[<[points].size.is_more_than[2]>].pass[<[points].get[3]>].fail[<[points].get[2]>]>
        - else if <[segment_index]> == <[points].size.sub[2]>:
            - define p0 <[points].get[<[segment_index]>]>
            - define p1 <[points].get[<[segment_index].add[1]>]>
            - define p2 <[points].get[<[segment_index].add[2]>]>
            - define p3 <[points].get[<[segment_index].add[2]>].add[<[points].get[<[segment_index].add[2]>].sub[<[points].get[<[segment_index].add[1]>]>]>]>
        - else:
            - define p0 <[points].get[<[segment_index]>]>
            - define p1 <[points].get[<[segment_index].add[1]>]>
            - define p2 <[points].get[<[segment_index].add[2]>]>
            - define p3 <[points].get[<[segment_index].add[3]>]>
        - define t 0
        - while <[t]> < 1:
            - define t2 <[t].mul[<[t]>]>
            - define t3 <[t2].mul[<[t]>]>
            - define px <element[0.5].mul[<[p1].x.mul[2].add[<[p2].x.sub[<[p0].x>].mul[<[t]>]>].add[<[p0].x.mul[2].sub[<[p1].x.mul[5]>].add[<[p2].x.mul[4]>].sub[<[p3].x>].mul[<[t2]>]>].add[<[p0].x.mul[-1].add[<[p1].x.mul[3]>].sub[<[p2].x.mul[3]>].add[<[p3].x>].mul[<[t3]>]>]>]>
            - define py <element[0.5].mul[<[p1].y.mul[2].add[<[p2].y.sub[<[p0].y>].mul[<[t]>]>].add[<[p0].y.mul[2].sub[<[p1].y.mul[5]>].add[<[p2].y.mul[4]>].sub[<[p3].y>].mul[<[t2]>]>].add[<[p0].y.mul[-1].add[<[p1].y.mul[3]>].sub[<[p2].y.mul[3]>].add[<[p3].y>].mul[<[t3]>]>]>]>
            - define pz <element[0.5].mul[<[p1].z.mul[2].add[<[p2].z.sub[<[p0].z>].mul[<[t]>]>].add[<[p0].z.mul[2].sub[<[p1].z.mul[5]>].add[<[p2].z.mul[4]>].sub[<[p3].z>].mul[<[t2]>]>].add[<[p0].z.mul[-1].add[<[p1].z.mul[3]>].sub[<[p2].z.mul[3]>].add[<[p3].z>].mul[<[t3]>]>]>]>
            - define point <location[<[px]>,<[py]>,<[pz]>,<[points].get[1].world.name>]>
            - if <[spline_points].size> > 0:
                - define last_point <[spline_points].get[-1]>
                - define cumulative_distance <[last_point].distance[<[point]>]>
                - define cumulative_distances <[cumulative_distances].include[<[cumulative_distances].get[-1].add[<[cumulative_distance]>]>]>
            - define spline_points <[spline_points].include[<[point]>]>
            - define t <[t].add[<element[1].div[<[resolution]>]>]>
    - define equidistant_points <list[<[spline_points].get[1]>]>
    - define total_length <[cumulative_distances].get[-1]>
    - define current_distance 0
    - define current_index 1
    - while <[current_distance]> < <[total_length]>:
        - define target_distance <[current_distance].add[<[distance]>]>
        - if <[target_distance]> > <[total_length]>:
            - while stop
        - while <[current_index]> < <[cumulative_distances].size> && <[cumulative_distances].get[<[current_index].add[1]>]> < <[target_distance]>:
            - define current_index <[current_index].add[1]>
        - define t1 <[cumulative_distances].get[<[current_index]>]>
        - define t2 <[cumulative_distances].get[<[current_index].add[1]>]>
        - define alpha <[target_distance].sub[<[t1]>].div[<[t2].sub[<[t1]>]>]>
        - define p1 <[spline_points].get[<[current_index]>]>
        - define p2 <[spline_points].get[<[current_index].add[1]>]>
        - define x <[p1].x.add[<[alpha].mul[<[p2].x.sub[<[p1].x>]>]>]>
        - define y <[p1].y.add[<[alpha].mul[<[p2].y.sub[<[p1].y>]>]>]>
        - define z <[p1].z.add[<[alpha].mul[<[p2].z.sub[<[p1].z>]>]>]>
        - define point <location[<[x]>,<[y]>,<[z]>,<[points].get[1].world.name>]>
        - define equidistant_points <[equidistant_points].include[<[point]>]>
        - define current_distance <[target_distance]>
    - define last_control_point <[points].get[-1]>
    - define last_generated <[equidistant_points].get[-1]>
    - if <[last_generated].distance[<[last_control_point]>]> >= <[distance].div[2]>:
        - define equidistant_points <[equidistant_points].include[<[last_control_point]>]>
    - determine <[equidistant_points]>

# Previews the given path for the given player, where the source definition are the points that
# the resulting path must pass through, for the specified duration_tag. Note for the duration_tag
# that a <duration[]> is required, and it will not work if using simple <element[]>, like '5s'.
cutscene_preview_path:
    debug: false
    type: task
    definitions: player|source|result|duration_tag
    script:
    - define duration_tag <[duration_tag].if_null[<duration[5s]>]>
    - define now <util.current_time_millis>
    - while <util.current_time_millis.sub[<[now]>]> < <[duration_tag].in_milliseconds>:
        - if !<[player].is_online>:
            - stop
        - playeffect at:<[source]> targets:<[player]> effect:CLOUD offset:0,0,0 quantity:1 velocity:0,0,0 visibility:1000
        - playeffect at:<[result]> targets:<[player]> effect:ENCHANTED_HIT offset:0,0,0 quantity:1 velocity:0,0,0 visibility:1000
        - wait 5t

# Simple linear interpolation.
# Given as parameter to cutscene_follow_path_by_interpolation.
cutscene_interpolate_linear:
    debug: false
    type: procedure
    definitions: step
    script:
    - determine 0.5

# Ease in interpolation.
# Given as parameter to cutscene_follow_path_by_interpolation.
cutscene_interpolate_ease_in:
    debug: false
    type: procedure
    definitions: step
    script:
    - determine <[step].mul[<util.pi.div[2]>].sin>

# Ease out interpolation.
# Given as parameter to cutscene_follow_path_by_interpolation.
cutscene_interpolate_ease_out:
    debug: false
    type: procedure
    definitions: step
    script:
    - determine <[step].mul[<util.pi.div[2]>].add[<util.pi.div[2]>].sin>


# Ease in-out interpolation.
# Given as parameter to cutscene_follow_path_by_interpolation.
cutscene_interpolate_ease_in_out:
    debug: false
    type: procedure
    definitions: step
    script:
    - determine <[step].mul[<util.pi>].sin>

# Makes the player follow the given path at the given speed, using the provided interpolation.
# Note that the speed is an arbitrary construct, but higher numbers will make the player follow
# the path faster.
cutscene_follow_path_by_interpolation:
    debug: false
    type: task
    definitions: player|path|look_at|speed|interpolation_procedure
    script:
    - if <[path].size> == 0:
        - stop
    - define look_at_is_list <tern[<[look_at].get[1].if_null[null].equals[null]>].pass[false].fail[true]>
    - teleport <[player]> <[path].get[1]>
    - define time_unit <[path].size.div[<[speed].mul[20]>]>
    - define should_await_time 0
    - define index 1
    - while <[index]> < <[path].size>:
        - define point <[path].get[<[index]>]>
        - define step <[index].sub[1].div[<[path].size>]>
        - define await_time <element[1].sub[<proc[<[interpolation_procedure]>].context[<[step]>]>].mul[<[time_unit]>]>
        - define should_await_time <[should_await_time].add[<[await_time]>]>
        - if <[should_await_time]> < 1:
            - define index <[index].add[1]>
            - while next
        - wait <[should_await_time].round_down>t
        - define should_await_time <[should_await_time].sub[<[should_await_time].round_down>]>
        - define direction <[look_at].sub[<[point]>].normalize>
        - define quaternion_pitch <[direction].quaternion_between_vectors[0,1,0].represented_angle.sub[<util.pi.div[2]>].to_degrees>
        - define result_point <[point].with_pitch[<[quaternion_pitch]>].with_yaw[<[point].direction[<[look_at]>].yaw>]>
        - if !<[player].is_online>:
            - determine false
        - teleport <[player]> <[result_point].add[0,-1,0]> offthread_repeat:8
        - define index <[index].add[1]>
    - if !<[player].is_online>:
        - determine false
    - teleport <[player]> <[path].get[-1]>
    - determine true

# Creates and saves a cutscene.
# Definitions explanation:
# - name: The name of the cutscene. Must be unique, case sensitive.
# - points: The source points to generate the path from.
# - look_at: The location that the player should look at throughout the entire path follow
# - compute_spline: Whether to use straight lines for the path, or to compute a smooth spline.
# - interpolation_procedure: A procedure to interpolate the speed of the path follower.
#
# If the cutscene already exists, it will not create it and silently fail.
# Determines true if the cutscene was created, or false if it already exists.
cutscene_create_and_save:
    debug: false
    type: task
    definitions: name|points|look_at|speed|compute_spline|interpolation_procedure
    script:
    - if <server.flag[cutscene].if_null[<map[]>].contains[<[name]>]>:
        - determine false
    - if !<[compute_spline]>:
        - define result <proc[cutscene_concatenate_points_between].context[<[points].escaped>|0.33]>
    - else:
        - define result <proc[cutscene_catmull_rom_equidistant_spline].context[<[points].escaped>|0.33|50]>
    - definemap cutscene:
        name: <[name]>
        source: <[points]>
        result: <[result]>
        look_at: <[look_at]>
        speed: <[speed]>
        interpolation_procedure: <[interpolation_procedure]>
    - flag server cutscene:<server.flag[cutscene].if_null[<map[]>].with[<[name]>].as[<[cutscene]>]>
    - adjust server save
    - determine true

# Destroys an existing cutscnee.
# If the cutscene doesn't exist, it will fail silently.
# Determines true if the cutscene was destroyed, or false if it did not yet exist.
cutscene_destroy:
    debug: false
    type: task
    definitions: name
    script:
    - if !<server.flag[cutscene].if_null[<map[]>].contains[<[name]>]>:
        - determine false
    - flag server cutscene:<server.flag[cutscene].if_null[<map[]>].exclude[<[name]>]>
    - adjust server save
    - determine false

# Previews the given path for the given player, using a saved cutscene as the source.
# Note for the duration_tag that a <duration[]> is required, and it will not work if
# using simple <element[]>, like '5s'.
cutscene_preview_path_by_name:
    debug: false
    type: task
    definitions: name|player|duration_tag
    script:
    - if !<server.flag[cutscene].if_null[<map[]>].contains[<[name]>]>:
        - debug error "Cannot preview path by name! <[name]> @ <[player]>"
        - stop
    - define cutscene <server.flag[cutscene].get[<[name]>]>
    - run cutscene_preview_path def.player:<[player]> def.source:<[cutscene].get[source]> def.result:<[cutscene].get[result]> def.duration_tag:<[duration_tag]>

# Plays the given cutscene by name.
# If the player disconnects, the cutscene will stop playing, but the queue that
# called this task will continue. Consider cutscene_play_atomic in case you would
# like to stop the queue that called this task.
# Determines true if the cutscene completed, false otherwise.
# Should be ~waited for.
cutscene_play:
    debug: false
    type: task
    definitions: name|player
    script:
    - run cutscene_stop def.player:<[player]>
    - if !<server.flag[cutscene].if_null[<map[]>].contains[<[name]>]>:
        - determine false
    - define cutscene <server.flag[cutscene].get[<[name]>]>
    - flag <[player]> cutscene:<map[].with[gamemode].as[<player.gamemode>].with[location].as[<player.location>]>
    - adjust <[player]> gamemode:spectator
    - run cutscene_follow_path_by_interpolation def.player:<[player]> def.path:<[cutscene].get[result]> def.look_at:<[cutscene].get[look_at]> def.speed:<[cutscene].get[speed]> def.interpolation_procedure:<[cutscene].get[interpolation_procedure]> save:result
    - define queue <entry[result].created_queue>
    - flag <[player]> cutscene_queue:<[queue]>
    - waituntil <[queue].state.equals[running]> max:5t
    - waituntil <[queue].state.equals[running].not>
    - define ok <[queue].determination.get[1]>
    - run cutscene_stop def.player:<player>
    - determine <[ok]>

# Plays the cutscene atomically.
# See cutscene_play for an explanation.
# Should be ~waited for.
cutscene_play_atomic:
    debug: false
    type: task
    definitions: name|player|queue
    script:
    - ~run cutscene_play def.name:<[name]> def.player:<[player]> save:result
    - define result <entry[result].created_queue.determination.get[1]>
    - if !<[result].if_null[false]>:
        - debug log "Cancelled atomic cutscene: <[player].name> @ <[name]>"
        - queue stop <[queue]>

# Stops the currently playing cutscene from playing.
# If no cutscene is playing, it silently fails.
cutscene_stop:
    debug: false
    type: task
    definitions: player
    script:
    - if !<[player].has_flag[cutscene]>:
        - stop
    - define save <[player].flag[cutscene]>
    - if <[player].flag[cutscene_queue]> != null:
        - queue stop <[player].flag[cutscene_queue]>
    - adjust <[player]> gamemode:<[save].get[gamemode]>
    - teleport <[player]> <[save].get[location]>
    - flag <[player]> cutscene:!

## Internal only!
cutscene_world:
    debug: false
    type: world
    events:
        on player joins:
        - run cutscene_stop def.player:<player>
