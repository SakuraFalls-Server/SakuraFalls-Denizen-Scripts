dialogue_npc_ryuko_assign:
    debug: false
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - dialogue_npc_ryuko

dialogue_npc_ryuko:
    debug: false
    type: interact
    steps:
        1:
            click trigger:
                script:
                - run storyboard_player_begin_atomic_sequence def.queue:<queue> def.player:<player>
                - if <player.flag[textbox_state].if_null[null]> != null:
                    - stop
                - engage player
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Hey, what's up?!"
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I hang out here a lot.$$nlI love to stay fit, be athletic."
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Kicking balls is great!$$nl   $$nl* uh.."
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Anyway, the Academy sorta ran out of$$nlof tennis rackets."
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Something about them being broken$$nland rusty, apparently."
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* If you ask me, that's a bunch of crap!$$nlI think <&4><&l>the dean<&0><&l> is just no fun."
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I think they don't want us playing.$$nlIt wouldn't be the first time."
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I also haven't seen anyone play any$$nlbasketball recently, so I'm not sure$$nlwhat that's about."
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* They should resolve this as soon as$$nlpossible before the students start a$$nlrebellion."
                - wait 1s
                - disengage player
                - ratelimit <player> 10t
                - run storyboard_player_end_atomic_sequence def.queue:<queue> def.player:<player>
