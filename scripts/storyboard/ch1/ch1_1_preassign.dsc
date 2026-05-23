ch1_1_preassign:
    debug: false
    type: world
    events:
        after player joins:
        - wait 1s
        - if <proc[storyboard_player_state_get].context[<player>|preassign]> == null:
            - if !<proc[storyboard_npc_exists].context[<player>|marie]>:
                - run storyboard_npc_memalloc "def:<player>|marie|player|<location[-4,2,-15,world]>|Marie Ayashibayomi|true|<script[storyboard_skin_dump].data_key[marie].get[a]>"
            - run storyboard_npc_set_assignment def.player:<player> def.name:marie def.assignment:ch1_1_marie_assign
            - run storyboard_player_state_set def.player:<player> def.key:preassign def.value:true

ch1_1_marie_assign:
    debug: false
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - ch1_1_marie_interact

ch1_1_define_phone:
    debug: false
    type: task
    script:
    - determine <proc[itemdb_get].context[flip phone]>

ch1_1_marie_interact:
    debug: false
    type: interact
    steps:
        1:
            click trigger:
                script:
                - run storyboard_player_begin_atomic_sequence def.queue:<queue> def.player:<player>
                - if <player.flag[textbox_state].if_null[null]> != null:
                    - stop
                - engage player duration:999999s
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Hey there, <proc[storyboard_character_first_name].context[<player>]>!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I'm so happy to see ya!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[happy]>
                - definemap choices:
                    left:
                        text: Likewise
                    right:
                        text: My name?
                - ~run textbox_choice def.player:<player> def.queue:<queue> def.choices:<[choices]> save:result
                - define choice <entry[result].created_queue.determination.get[1]>
                - if <[choice]> == right:
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Oh, right." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[sweat]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Let's just say a little bird$$nltold me it, wink wink!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[happy]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* So, what do you think?$$nlThis town's looking neat, no?" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - definemap choices:
                    left:
                        text: Yeah
                    right:
                        text: Don't know
                - ~run textbox_choice def.player:<player> def.queue:<queue> def.choices:<[choices]> save:result
                - define choice <entry[result].created_queue.determination.get[1]>
                - if <[choice]> == left:
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Right???$$nlOh man." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[happy]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Golly me! I just love$$nlit here." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[happy]>
                - else:
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* That's alright, you got this!$$nlYou'll fit right in, I'm sure of it." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[sweat]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I'm actually really fond of this$$nltown, although it's a little small." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* You're new anyway, you probably need$$nlsomebody to show you around a little,$$nlno?" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - definemap choices:
                    top:
                        text: It would help
                    bottom:
                        text: You talk a lot
                - ~run textbox_choice def.player:<player> def.queue:<queue> def.choices:<[choices]> save:result
                - define choice <entry[result].created_queue.determination.get[1]>
                - define displeased false
                - if <[choice]> == top:
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Oh welp, I had a feeling." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Don't worry dearie, I've gotcha$$nlaaaall covered!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[happy]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I'll be in front of the Academy." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* You know, like... the big building." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* The one with the big gates." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* You cannot miss it!$$nlSee you there!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[happy]>
                - else:
                    - define displeased true
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Oh.." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[ummm]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Um.." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[neutral]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Yeah, I, uh.." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[neutral]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Actually.." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[neutral]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I'll be in front of the Academy." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[oof]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Sorry." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[oof]>
                - run storyboard_player_freeze def.player:<player>
                - ~walk <npc> <location[-4,2,-33,world]>
                - run storyboard_npc_movement_commit def.player:<player> def.name:marie def.new_location:<location[-5,2,-78,world]>
                - run storyboard_player_unfreeze def.player:<player>
                - if !<[displeased]>:
                    - run storyboard_npc_state_set def.player:<player> def.name:marie def.key:opinion def.value:1
                - else:
                    - run storyboard_npc_state_set def.player:<player> def.name:marie def.key:opinion def.value:-1
                - zap 2
                - disengage player
                - run storyboard_player_end_atomic_sequence def.queue:<queue> def.player:<player>
        2:
            click trigger:
                script:
                - run storyboard_player_begin_atomic_sequence def.queue:<queue> def.player:<player>
                - if <player.flag[textbox_state].if_null[null]> != null:
                    - stop
                - engage player duration:999999s
                - define displeased false
                - define opinion <proc[storyboard_npc_state_get].context[<player>|marie|opinion]>
                - ~run ch1_1_define_phone save:result
                - define phone <entry[result].created_queue.determination.get[1]>
                - if <[opinion]> == null:
                    - define opinion 1
                - if <[opinion]> == 1:
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Alrighty, here we are!!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[happy]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Sorry, sorry." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[sweat]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I'll calm myself down now." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[oof]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I've got to show ya things$$nland I can't be all jumpy!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[happy]>
                - else:
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Oh. Hey." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[upset]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Need something?" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[upset]>
                    - definemap choices:
                        left:
                            text: I'm sorry
                        right:
                            text: No, bye
                    - ~run textbox_choice def.player:<player> def.queue:<queue> def.choices:<[choices]> save:result
                    - define choice <entry[result].created_queue.determination.get[1]>
                    - if <[choice]> == right:
                        - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Mkay." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[upset]>
                        - wait 1s
                        - disengage player
                        - run storyboard_player_end_atomic_sequence def.queue:<queue> def.player:<player>
                        - stop
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Hm. Are you now?" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[upset]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* You know, that was kind of$$nlmean of you." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[upset]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Why should I help you, anyway?" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[upset]>
                    - definemap choices:
                        top:
                            text: I'll change my ways
                        bottom:
                            text: You're right, I'm pretending
                    - ~run textbox_choice def.player:<player> def.queue:<queue> def.choices:<[choices]> save:result
                    - define choice <entry[result].created_queue.determination.get[1]>
                    - if <[choice]> == top:
                        - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Well." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[upset]>
                        - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* . . ." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[neutral]>
                        - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Okay, look, if you insist." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[oof]>
                        - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I'll try to pretend that$$nlnever happened." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[neutral]>
                    - else:
                        - define displeased true
                        - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Well." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[ugh]>
                        - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I should've guessed." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[upset]>
                        - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* So look, I'll cut it short." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[upset]>
                        - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I was going to show you around$$nland then give you a flip phone." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[upset]>
                        - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* But honestly, I don't care$$nlabout that anymore, so why don't$$nlyou just take the phone instead?" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[upset]>
                        - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Makes things easier." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[upset]>
                        - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:$$nl(You got the flip phone.)"
                        - give <[phone]>
                        - run storyboard_player_freeze def.player:<player>
                        - ~walk <npc> <location[-6,2,-83,world]>
                        - run storyboard_npc_memfree def.player:<player> def.name:marie
                        - run storyboard_player_unfreeze def.player:<player>
                        - goto done
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* As promised, I'll show you around." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[neutral]>
                - if <[opinion]> == 1:
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* You should pay attention$$nlbecause it's going to help you out!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I hope so at least!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[happy]>
                - else:
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* You can pay attention, but$$nlhonestly I don't care." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[neutral]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Anyway, follow me." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~walk <npc> <location[2,2,-130,world]> speed:1
                - ~run storyboard_waituntil_safe def.player:<player> def.queue:<queue> def.condition:[player].location.distance_squared[<location[2,2,-130,world]>].is_less_than[10]
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* So this is the academy." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Really big place." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[happy]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Nobody really likes the <&4><&l>principal<&0><&l>, or$$nlwell, so I hear." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[neutral]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Grumpy, rich... You get the idea." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[neutral]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Although, they did something right." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Behind this building, there are$$nlsome <&o>sport fields." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* A lot of people really enjoy them." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I'll take you there soon, but$$nllet's walk through the academy a bit." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~walk <npc> <location[23,2,-174,world]> speed:1
                - ~walk <npc> <location[2,2,-197,world]> speed:1
                - ~walk <npc> <location[2,5,-225,world]> speed:1
                - ~run storyboard_waituntil_safe def.player:<player> def.queue:<queue> def.condition:[player].location.distance_squared[<location[2,5,-225,world]>].is_less_than[10]
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* So, anyway, the <&4><&l>principal<&0><&l> really went$$nlextra with this." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* No, but really...$$nlA decorative garden at the$$nlentrance...?" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[surprised]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Anyway, let's keep going." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~walk <npc> <location[12,5,-240,world]> speed:1
                - ~walk <npc> <location[2,5,-254,world]> speed:1
                - ~walk <npc> <location[2,4,-314,world]> speed:1
                - ~run storyboard_waituntil_safe def.player:<player> def.queue:<queue> def.condition:[player].location.distance_squared[<location[2,4,-314,world]>].is_less_than[10]
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* It is pretty, is it not?" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[happy]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Maybe they had a point." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[surprised]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Though I think people would appreciate$$nlit if they stopped being as snarky." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Not everyone in this town is kind and$$nlnice to you, you know?" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[neutral]>
                - if <[opinion]> != 1:
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* <&o>I can think of one, at least." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[upset]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* So it's best you are careful." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* You never know who you'll run into." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~walk <npc> <location[2,2,-333,world]> speed:1
                - ~walk <npc> <location[-34,2,-359,world]> speed:1
                - ~walk <npc> <location[-24,2,-398,world]> speed:1
                - ~walk <npc> <location[2,2,-419,world]> speed:1
                - ~run storyboard_waituntil_safe def.player:<player> def.queue:<queue> def.condition:[player].location.distance_squared[<location[2,2,-419,world]>].is_less_than[10]
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Well, here are the sport fields." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[happy]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I heard they're quite fun to play at!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Though I suppose you'll need a friend,$$nlso maybe go together with someone!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[neutral]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I'm sure you can call someone on$$nlthe phone!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[happy]>
                - define should_give_phone <player.inventory.map_slots.values.filter[has_flag[phones]].is_empty>
                - if <[should_give_phone]>:
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* ..." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[ummm]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* What?!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[ummm]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* You don't have a phone?" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[ummm]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Hey, I know." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I'll just give you a flip phone!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* You can call, text, play music..." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Give it a try!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[happy]>
                    - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:$$nl(You got the flip phone.)"
                    - fakeitem <[phone]> slot:hand
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Oh, and..." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* We can continue at the Central Park." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* I hear it's really easy to get there!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[normal]>
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:$$nl(You remember something about /spawn)"
                - ~run textbox_write def.player:<player> def.queue:<queue> "def.line3s:* Well then, toodles!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[marie].get[happy]>
                - run storyboard_player_freeze def.player:<player>
                - ~walk <npc> <location[-44,2,-378,world]> speed:2
                - run storyboard_player_unfreeze def.player:<player>
                - run storyboard_npc_movement_commit def.player:<player> def.name:marie def.new_location:<location[-4,2,-15,world]>
                - inventory update
                - if <[should_give_phone]>:
                    - give <[phone]>
                - mark done
                - if !<[displeased]>:
                    - run storyboard_npc_state_set def.player:<player> def.name:marie def.key:opinion def.value:<[opinion].add[1]>
                - else:
                    - run storyboard_npc_state_set def.player:<player> def.name:marie def.key:opinion def.value:<[opinion].sub[1]>
                - inventory update
                - zap 3
                - disengage player
                - run storyboard_player_end_atomic_sequence def.queue:<queue> def.player:<player>
