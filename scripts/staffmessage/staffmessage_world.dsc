staffmessage_world:
    debug: false
    type: world
    events:
        on player quits:
            - flag <player> staffmessage_last_staff:!
        on player joins:
            - flag <player> staffmessage_last_staff:!