vehicles_config:
    debug: false
    type: data
    whitelisted_blocks:
    - cobbled_deepslate_stairs
    - gray_concrete_powder
    - white_concrete
    - white_concrete_powder
    - cobblestone_slab
    - tuff
    - calcite
    - cobbled_deepslate_slab
    vehicles:
        mx5:
            name: <&6>MX5
            material: diamond_horse_armor
            custom-model-data: 1
            driver-offset: 0,-1.25,0
            passengers:
            - 0,-1.25,1
            acceleration: 0.02
            max-speed: 2.37
            turn-speed-percentage: 0.01
        ambulance:
            name: <&6>Ambulance
            material: diamond_horse_armor
            custom-model-data: 2
            driver-offset: 0,-1,-0.5
            passengers:
            - 0,-1,0.5
            - -2,-0.8,0
            - -3,-0.8,0
            acceleration: 0.015
            max-speed: 2.32
            turn-speed-percentage: 0.01
        police_van:
            name: <&6>Police Van
            material: diamond_horse_armor
            custom-model-data: 3
            driver-offset: 0,-1.25,-0.5
            passengers:
            - 0,-1.25,0.5
            - -1,-1.25,-0.5
            - -1,-1.25,0.5
            - -2,-1.25,-0.5
            - -2,-1.25,0.5
            acceleration: 0.02
            max-speed: 2.35
            turn-speed-percentage: 0.01
        monte_carlo_86:
            name: <&6>Monte Carlo (1986)
            material: diamond_horse_armor
            custom-model-data: 4
            driver-offset: -0.25,-1.6,-0.5
            passengers:
            - -0.25,-1.6,0.5
            acceleration: 0.02
            max-speed: 2.37
            turn-speed-percentage: 0.01
        countach_85:
            name: <&6>Countach (1985)
            material: diamond_horse_armor
            custom-model-data: 5
            driver-offset: -0.15,-1.5,-0.5
            passengers:
            - -0.15,-1.5,0.5
            acceleration: 0.032
            max-speed: 2.45
            turn-speed-percentage: 0.01
        benz_190:
            name: <&6>Benz 190
            material: diamond_horse_armor
            custom-model-data: 6
            driver-offset: -0.15,-1.25,-0.5
            passengers:
            - -0.15,-1.4,0.5
            - -1.25,-1.4,-0.5
            - -1.25,-1.4,0.5
            acceleration: 0.02
            max-speed: 2.37
            turn-speed-percentage: 0.01
        ae86:
            name: <&6>AE86
            material: diamond_horse_armor
            custom-model-data: 7
            driver-offset: -0.15,-1.4,-0.5
            passengers:
            - -0.15,-1.4,0.5
            - -1.25,-1.4,-0.5
            - -1.25,-1.4,0.5
            acceleration: 0.02
            max-speed: 2.37
            turn-speed-percentage: 0.01
        supra_mk4:
            name: <&6>Supra MK4
            material: diamond_horse_armor
            custom-model-data: 8
            driver-offset: -0.15,-1.4,-0.5
            passengers:
            - -0.15,-1.4,0.5
            acceleration: 0.028
            max-speed: 2.4
            turn-speed-percentage: 0.01
        rakuzaichi_van:
            name: <&6>Armored Van
            material: diamond_horse_armor
            custom-model-data: 9
            driver-offset: -0.15,-1.35,-0.65
            passengers:
            - -0.15,-1.35,0.65
            acceleration: 0.015
            max-speed: 2.32
            turn-speed-percentage: 0.01
