height_world_playerjoins:
    type: world
    debug: false
    events:
        on player joins:
        # Average height in japan 171.4
        - flag <player> height:<player.flag[height].if_null[171.4]>
        # Listener for when the players respawns bc attributes restart after death according to google
        on player respawns:
        - flag <player> height:<player.flag[height].if_null[171.4]>

