timebar_world:
    debug: false
    type: world
    events:
        on delta time secondly every:1:
        - run timebar_increment
