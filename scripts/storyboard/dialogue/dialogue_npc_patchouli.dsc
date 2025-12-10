dialogue_npc_patchouli_assign:
    debug: false
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - dialogue_npc_patchouli

dialogue_npc_patchouli:
    debug: false
    type: interact
    steps:
        1:
            click trigger:
                script:
                - if <player.flag[textbox_state].if_null[null]> != null:
                    - stop
                - engage player
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:. . ."
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:. . ."
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:She is fast asleep."
                - wait 1s
                - disengage player
                - ratelimit <player> 10t
