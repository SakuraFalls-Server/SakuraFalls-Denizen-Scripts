dealer_interact_dropbox:
    debug: false
    type: world
    events:
        on player right clicks block:
        - if !<context.location.note_name.if_null[null].starts_with[dealer_Location]>
