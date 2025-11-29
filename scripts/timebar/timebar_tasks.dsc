# use in PAPI: %denizen_<proc[timebar_format]>%
timebar_format:
    debug: false
    type: procedure
    script:
    - define time <server.flag[timebar_time].if_null[<util.time_now>]>
    # typical format
    - define result "<&6>☀ <&f><[time].format[HH:mm, E.]>"
    # dawn, morning, noon, afternoon, evening, night
    - define period Dawn
    - if <[time].hour> < 6 || <[time].hour> >= 22:
        - define period Night
    - else if <[time].hour> < 12:
        - define period Morning
    - else if <[time].hour> < 15:
        - define period Noon
    - else if <[time].hour> < 18:
        - define period Afternoon
    - else if <[time].hour> < 22:
        - define period Evening
    - define result "<[result]> <&e>🔔 <&f><[period]>"
    # map name
    - define location <script[timebar_worlds].data_key[<player.location.world.name>]>
    - define regions <player.location.regions.filter_tag[<[filter_value].id.starts_with[zone_]>]>
    - if <[regions].size> > 0:
    	- define location <[regions].get[1].id.replace[zone_].with[].split[_].parse[to_sentence_case].space_separated>
    - define result "<[result]> <&c>📌 <&f><[location]>"
    # result
    - determine <[result]>

timebar_increment:
    debug: false
    type: task
    script:
    - define time <server.flag[timebar_time].if_null[<util.time_now>]>
    - define time <[time].add[5s]>
    - flag server timebar_time:<[time]>
    - run timebar_sync_sun

timebar_sync_sun:
    debug: false
    type: task
    script:
    - define time <server.flag[timebar_time].if_null[<util.time_now>]>
    - define hour <[time].hour>
    - define minute <[time].minute>
    - define second <[time].second>
    # calculate as floor((hour - 6) * 1000 + minute * (1000 / 60) + second * (1000 / 60 / 60))
    - define thousanddivsixty <element[1000].div[60]>
    - define total_ticks <[hour].sub[6].mul[1000].add[<[minute].mul[<[thousanddivsixty]>]>].add[<[second].mul[<[thousanddivsixty].div[60]>]>].round_down>
    - foreach <server.worlds> as:world:
        - adjust <[world]> time:<[total_ticks]>
