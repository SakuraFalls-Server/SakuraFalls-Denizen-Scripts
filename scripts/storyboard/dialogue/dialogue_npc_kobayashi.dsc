dialogue_npc_kobayashi_assign:
    debug: false
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - dialogue_npc_kobayashi

dialogue_npc_kobayashi:
    debug: false
    type: interact
    steps:
        1:
            click trigger:
                script:
                - if <player.flag[textbox_state].if_null[null]> != null:
                    - stop
                - engage player
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:Heya, sorry luv."
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:We're currently under renovations, luv."
                - definemap choices:
                    left:
                        text: Why?
                    right:
                        text: Unfortunate
                - ~run textbox_choice def.player:<player> def.queue:<queue> def.choices:<[choices]> save:result
                - define choice <entry[result].created_queue.determination.get[1]>
                - if <[choice]> == left:
                    - ~run textbox_write def.player:<player> def.queue:<queue> def.line3s:What?$$nlWhy?
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:Well, look, I can't tell you that, luv.$$nl It's against Hospital Policy."
                    - definemap choices:
                        left:
                            text: Sorry
                        right:
                            text: Don't care
                    - ~run textbox_choice def.player:<player> def.queue:<queue> def.choices:<[choices]> save:result
                    - define choice <entry[result].created_queue.determination.get[1]>
                    - if <[choice]> == left:
                        - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:No worries, luv!"
                    - else:
                        - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:What?$$nlYou don't care?"
                        - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:I'm afraid I can't treat that, luv."
                - else:
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:Indeed, luv."
                - wait 1s
                - disengage player
