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
        on player right clicks block:
        - if <player.item_in_hand.advanced_matches[*firework*]> || <player.item_in_offhand.advanced_matches[*firework*]>:
            - if <util.current_time_millis.sub[<player.flag[no_firework_spam].if_null[0]>]> < 2000:
                - determine cancelled
            - flag <player> no_firework_spam:<util.current_time_millis>
        on inventory picks up item:
        - determine cancelled
        on item moves from inventory to inventory:
        - determine cancelled
