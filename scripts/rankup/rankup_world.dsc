rankup_world:
    debug: false
    type: world
    events:
        after server start:
        - yaml load:../Autorank/data/Total_time.yml id:autorank_totaltime
        - yaml load:../Autorank/Paths.yml id:autorank_paths
        on delta time minutely every:1:
        - yaml load:../Autorank/data/Total_time.yml id:autorank_totaltime
        - yaml load:../Autorank/Paths.yml id:autorank_paths
