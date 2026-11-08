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
        # for some reason, AutoRank fails to sync roles; likely LiteProfiles related
        - foreach <server.online_players> as:player:
            - run rankup_sync_school def.player:<[player]>
