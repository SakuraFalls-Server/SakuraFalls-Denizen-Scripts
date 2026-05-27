attribute_cardio_data:
    type: data
    debug: false
    ratelimit: 1
    max: 100000


attribute_acro_data:
    type: data
    debug: false
    ratelimit: 0.5
    # at acro 50%, give speed 1, at max give 2. Same for the rest
    at_fifty_precent: 0
    at_max_precent: 1
    max: 10000

attribute_swim_data:
    type: data
    debug: false
    ratelimit: 10
    at_fifty_precent: 0
    at_max_precent: 1
    max: 100000