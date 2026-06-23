# Ball Library
# A library that manages & controls "bouncing balls", i.e. some kind of game ball
# which has gravity, movement, collision, and so on.
# It also efficiently handles everything and adds custom event handlers that other
# plugins can handle.


# Creates a new ball with the given id, at the given location, with the given
# collision size and using the given display item, and some gravity multiplier.
# Only one ball with a given id can exist at one time. If this method is called
# while another ball with this id exists, it will be removed automatically.
ball_create:
    debug: false
    type: task
    definitions: id|location|size|display_item|gravity_multiplier
    script:
    - ~run ball_remove def.id:<[id]>
    - spawn slime[silent=true;size=<[size]>;has_ai=false;visible=false] <[location].with_pitch[0].with_yaw[0]> save:ball_collision
    - define ball_collision <entry[ball_collision].spawned_entity>
    - define size <[ball_collision].bounding_box.get[1].sub[<[ball_collision].location>].x.abs.add[0.01]>
    - spawn zombie[silent=true;has_ai=false;gravity=false;visible=false] <[location].with_pitch[0].with_yaw[0].below[<[size].add[1]>]> save:ball_display
    - define ball_display <entry[ball_display].spawned_entity>
    - if <[ball_display].is_baby>:
        - age <[ball_display]> adult lock
    - if <[ball_display].is_inside_vehicle>:
        # CHICKEN JOCKEEEEEEEEEEEEEEEEEEEEEEEEEY
        - define chicken <[ball_display].vehicle>
        - adjust <[chicken]> passengers:<list[]>
        - remove <[chicken]>
    - adjust <[ball_display]> equipment:<map[].with[helmet].as[<[display_item]>]>
    - flag <[ball_collision]> ball:<[id]>
    - flag <[ball_collision]> ball_display:<[ball_display]>
    - flag <[ball_collision]> ball_velocity:<location[0,0,0,<[location].world>]>
    - flag <[ball_collision]> ball_size:<[size]>
    - flag <[ball_collision]> ball_gravity:<[gravity_multiplier]>
    - flag <[ball_display]> ball:<[id]>
    - flag server ball:<server.flag[ball].if_null[<map[]>].with[<[id]>].as[<[ball_collision]>]>
    - determine <[ball_collision]>

# Removes a ball by id. If that ball does not exist, it will silently fail.
ball_remove:
    debug: false
    type: task
    definitions: id
    script:
    - if <server.flag[ball].if_null[<map[]>].contains[<[id]>]>:
        - remove <server.flag[ball].get[<[id]>].flag[ball_display]>
        - remove <server.flag[ball].get[<[id]>]>
        - flag server ball:<server.flag[ball].exclude[<[id]>]>

# Gets a ball by id.
ball_get:
    debug: false
    type: procedure
    definitions: id
    script:
    - determine <server.flag[ball].if_null[<map[]>].get[<[id]>]>

# Adds a vector to the ball's current velocity
# This has the effect of "pushing" the ball in that direction.
ball_vector_add:
    debug: false
    type: task
    definitions: ball|vector
    script:
    - flag <[ball]> ball_velocity:<[ball].flag[ball_velocity].add[<[vector]>]>

# Handling a ball's event:
# Create a world script and add the following event
# //   on custom event id:ball_move:
# The following context is provided:
#   - <context.ball_id> (EleemntTag) - the ball's ID.
#   - <context.ball> (EntityTag) - the ball entity with current state in its flag_map
#   - <context.now> (LocationTag) - the ball's current location
#   - <context.next> (LocationTag) - the ball's computed next location, which may be reflected if it bounced
#   - <context.velocity_t0> (LocationTag) - the ball's current velocity
#   - <context.velocity_t1> (LocationTag) - the ball's next computed velocity
#   - <context.bounced> (ElementTag) - true if the ball bounced, false otherwise
#   - <context.ground> (ElementTag) - true if the ball bounced or is on the ground, false otherwise
# You can cancel the event as any other event, or you can "determine output:<list[...]>" containing:
#   - element 1 (LocationTag): the next location for the ball for when it gets moved
#   - element 2 (LocationTag): the next velocity for the next processing tick

## Do not change! This handles updating the ball's physics as well as movement.
ball_internal_physics_update:
    debug: false
    type: world
    events:
        on tick:
        - foreach <server.flag[ball].if_null[<map[]>]> key:id as:ball:
            - run ball_internal_physics_update_ball def.ball:<[ball]>
        on entity damaged:
        - if <context.entity.has_flag[ball]>:
            - determine cancelled passively
        on player right clicks entity:
        - if <context.entity.has_flag[ball]>:
            - determine cancelled passively

ball_internal_physics_update_ball:
    debug: false
    type: task
    definitions: ball
    script:
    - if <[ball].flag[ball_display].type.if_null[null]> == null:
        - run ball_remove def.id:<[ball].flag[ball]>
        - stop
    - define velocity <[ball].flag[ball_velocity]>
    - define gravity <[ball].flag[ball_gravity].mul[0.035]>
    - define now <[ball].location>
    - define next <[ball].location.add[<[velocity]>]>
    - define yaw <[next].direction[<[now]>].yaw.sub[180].if_null[0]>
    - define pitch <location[0,1,0].quaternion_between_vectors[<[next].sub[<[now]>].normalize>].represented_angle.to_degrees.sub[90].if_null[0]>
    - define now <[now].with_yaw[<[yaw]>].with_pitch[<[pitch]>]>
    - define size <[ball].flag[ball_size]>
    - define trace <[now].ray_trace[range=<[now].distance[<[next]>].add[<[size]>]>].if_null[null]>
    - define bounced false
    - if <[trace]> != null:
        - define bounced true
        - define normal <[trace].direction.vector>
        - define direction <[next].sub[<[now]>]>
        - define dot <[direction].x.mul[<[normal].x>].add[<[direction].y.mul[<[normal].y>]>].add[<[direction].z.mul[<[normal].z>]>]>
        - define reflection <[direction].sub[<[normal].mul[<[dot].mul[2]>]>].mul[0.65]>
        - define next <[trace].add[<[reflection]>]>
        - define velocity <[reflection]>
        - if <util.current_time_millis.sub[<[ball].flag[ball_sound_time].if_null[0]>]> > 200:
            - playsound <[now]> sound:BLOCK_STONE_BREAK pitch:1.8
            - flag <[ball]> ball_sound_time:<util.current_time_millis>
    - define grounded false
    - if !<[ball].location.below[<[size].div[4]>].material.is_solid>:
        - define velocity <[velocity].mul[0.99]>
        - define velocity <[velocity].add[0,-<[gravity]>,0]>
    - else:
        - define velocity <[velocity].mul[0.75]>
        - define next <[next].with_y[<[next].above[<[size].add[0.25]>].block.y>]>
        - define grounded true
    - if <[next].sub[<[now]>].vector_length_squared> >= 0.01:
        - definemap event_context:
            ball_id: <[ball].flag[ball]>
            ball: <[ball]>
            now: <[now]>
            next: <[next]>
            velocity_t0: <[ball].flag[ball_velocity]>
            velocity_t1: <[velocity]>
            bounced: <[bounced]>
            ground: <[grounded]>
        - customevent id:ball_move context:<[event_context]> save:move_event
        - if <entry[move_event].any_ran>:
            - if <entry[move_event].was_cancelled>:
                - stop
            - if !<entry[move_event].determination_list.is_empty>:
                - define changes <entry[move_event].determination_list>
                - define next <[changes].get[1].if_null[<[next]>]>
                - define velocity <[changes].get[2].if_null[<[velocity]>]>
    - flag <[ball]> ball_velocity:<[velocity]>
    - teleport <[ball].flag[ball_display]> <[ball].bounding_box.get[1].add[<[ball].bounding_box.get[2]>].div[2].below[1.575].below[0.125]>
    - teleport <[ball]> <[next]>
