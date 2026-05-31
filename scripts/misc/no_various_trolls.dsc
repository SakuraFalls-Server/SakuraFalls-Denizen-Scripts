no_spawn_eggs:
    debug: false
    type: world
    events:
        on entity spawns because SPAWNER_EGG:
        - determine cancelled
        on entity spawns because DISPENSE_EGG:
        - determine cancelled
        on entity spawns because SPAWNER:
        - determine cancelled
        on entity spawns because TRIAL_SPAWNER:
        - determine cancelled
        on entity spawns because SLIME_SPLIT:
        - determine cancelled
        on entity spawns because NETHER_PORTAL:
        - determine cancelled
        on entity spawns because SPELL:
        - determine cancelled
        on entity spawns because VILLAGE_DEFENSE:
        - determine cancelled
        on entity spawns because VILLAGE_INVASION:
        - determine cancelled
        on entity spawns because METAMORPHOSIS:
        - determine cancelled
        on entity spawns because BREEDING:
        - determine cancelled
        on entity spawns because BEEHIVE:
        - determine cancelled
        on player starts gliding:
        - determine cancelled
        on splash_potion spawns:
        - determine cancelled
        on lingering_potion spawns:
        - determine cancelled
        on egg spawns:
        - determine cancelled
        on wither spawns:
        - determine cancelled
        on iron_golem spawns:
        - determine cancelled
        on snow_golem spawns:
        - determine cancelled
        on end_crystal spawns:
        - determine cancelled
        on entity explodes:
        - determine cancelled
        on block explodes:
        - determine cancelled
        on block grows:
        - if <context.material.advanced_matches[sniffer_egg]>:
            - determine cancelled
        on player places block:
        - if <player.is_op>:
            - stop
        - if <context.material.advanced_matches[bedrock|spawner|trial_spawner|decorated_pot|cake|ender_chest|sculk_shrieker|dragon_egg|sculk_sensor|pointed_dripstone|dried_ghast|test_block|command_block|chain_command_block|repeating_command_block|jigsaw|structure_block]>:
            - determine cancelled
        on player opens inventory:
        - if <player.is_op>:
            - stop
        - if <context.inventory.inventory_type> == ender_chest:
            - determine cancelled
        on player right clicks block:
        - if <player.item_in_hand.advanced_matches[*firework*]> || <player.item_in_offhand.advanced_matches[*firework*]>:
            - determine cancelled
        - if <player.item_in_hand.advanced_matches[*_boat]> || <player.item_in_offhand.advanced_matches[*_boat]>:
            - determine cancelled
        - if <player.item_in_hand.advanced_matches[*minecart]> || <player.item_in_offhand.advanced_matches[*minecart]>:
            - determine cancelled
        - if <player.item_in_hand.advanced_matches[ender_eye]> || <player.item_in_offhand.advanced_matches[ender_eye]>:
            - determine cancelled
        - if <player.is_op>:
            - stop
        - if <context.location.material.advanced_matches[*_shelf].if_null[false]>:
            - determine cancelled
        on player places hanging:
        - if <player.is_op>:
            - stop
        - determine cancelled
        on command bukkit_priority:lowest:
        - if <context.source_type> == player:
            - if <player.open_inventory> != <player.inventory>:
                - if !<player.open_inventory.title.equals[<&f>邑邑邑邑鄈]> && !<player.has_flag[anvil_input]>:
                    - determine cancelled
        on inventory picks up item:
        - determine cancelled
        on item moves from inventory to inventory:
        - determine cancelled
        on player uses recipe book:
        - determine cancelled
        on item recipe formed:
        - determine cancelled
