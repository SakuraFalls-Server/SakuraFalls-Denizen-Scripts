tab_prefix_shortened:
    debug: false
    type: procedure
    definitions: player
    script:
    - define full_prefix <placeholder[luckperms_prefix_element_highest_on_track_roles].player[<[player]>].if_null[<&f>].parse_color>
    - if <[full_prefix].strip_color.trim.length> == 0:
        - determine <&f>
    - define bracket_left <[full_prefix].substring[1,3]>
    - define bracket_right <[full_prefix].substring[<[full_prefix].length.sub[2]>,<[full_prefix].length>]>
    - define color <[full_prefix].substring[4,5]>
    - define abbreviation <[full_prefix].substring[6,<[full_prefix].length.sub[3]>].split[-].parse_tag[<[color]><tern[<[parse_value].is_integer>].pass[<[parse_value]>].fail[<[parse_value].substring[1,1].to_uppercase>]>].separated_by[.]>
    - determine <[bracket_left]><[abbreviation]><[bracket_right]>
