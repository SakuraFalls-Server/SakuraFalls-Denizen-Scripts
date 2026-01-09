# Posters
intro_interact_posters:
    debug: false
    type: world
    events:
        on player right clicks block:
        - if !<context.location.note_name.if_null[null].starts_with[intro_interact_posters]>:
            - stop
        - determine cancelled passively
        - if <player.has_flag[textbox_state]>:
            - stop
        - run intro_interact_posters_task

intro_interact_posters_task:
    debug: false
    type: task
    script:
    - run storyboard_player_begin_atomic_sequence def.queue:<queue> def.player:<player>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:Book-related posters are on the wall."
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:<&o><&dq>Screw that. I'm running away.<&dq>"
    - ~run textbox_write def.player:<player>  def.queue:<queue> def.line3s:<&o><&dq>Where?<&dq>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:<&o><&dq>Dunno. Do you want to come?<&dq>"
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:<&o><&dq>Yes,<&dq> I said without thinking."
    - run storyboard_player_end_atomic_sequence def.queue:<queue> def.player:<player>

# Cirno
intro_interact_cirno:
    debug: false
    type: world
    events:
        on player right clicks block:
        - if !<context.location.note_name.if_null[null].starts_with[intro_interact_cirno]>:
            - stop
        - determine cancelled passively
        - if <player.has_flag[textbox_state]>:
            - stop
        - run intro_interact_cirno_task

intro_interact_cirno_task:
    debug: false
    type: task
    script:
    - run storyboard_player_begin_atomic_sequence def.queue:<queue> def.player:<player>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:A quality, soft plushie of a beloved$$nlcharacter."
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:It seems familiar, as if there are a$$nlsubstantial amount of images circulating$$nlaround with this character."
    - run storyboard_player_end_atomic_sequence def.queue:<queue> def.player:<player>

# Laptop
intro_interact_laptop:
    debug: false
    type: world
    events:
        on player right clicks block:
        - if !<context.location.note_name.if_null[null].starts_with[intro_interact_laptop]>:
            - stop
        - determine cancelled passively
        - if <player.has_flag[textbox_state]>:
            - stop
        - run intro_interact_laptop_task

intro_interact_laptop_task:
    debug: false
    type: task
    script:
    - run storyboard_player_begin_atomic_sequence def.queue:<queue> def.player:<player>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:It looks like a game is booted up.$$nlYou can see a city, and it looks like..."
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:. . ."
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:It's <bold>you!$$nl. . .$$nlWell, it's your character."
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:You should give your character$$nla cool name, right?"
    - waituntil <player.has_flag[textbox_state].not> max:5s
    - ~run textbox_flush def.player:<player>
    - run anvil_input def.player:<player> "def.prompt:Character Name" def.callback:intro_interact_laptop_task_name_callback

intro_interact_laptop_task_name_callback:
    debug: false
    type: task
    definitions: player|input
    script:
    - define __player <[player]>
    - define name <[input].substring[1,24]>
    - execute as_player player:<[player]> "rpname <[name]>"
    - ~run textbox_write def.player:<player>  def.queue:<queue> def.line3s:<[name]>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:How nice!"
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:Let's give them a description.$$nlDescribe their physical attributes."
    - waituntil <player.has_flag[textbox_state].not> max:5s
    - ~run textbox_flush def.player:<player>
    - run anvil_input def.player:<player> def.prompt:Description def.callback:intro_interact_laptop_task_description_callback

intro_interact_laptop_task_description_callback:
    debug: false
    type: task
    definitions: player|input
    script:
    - define __player <[player]>
    - execute as_player player:<[player]> "setdesc <[input]>"
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:Great, your character's almost ready."
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:Lastly, your character can start$$nlout as a student or as$$nlan <bold>adult."
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:Both options are great, and it's$$nlmostly a matter of preference."
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:For complete beginners, we recommend$$nlstarting out as a student."
    - waituntil <player.has_flag[textbox_state].not> max:5s
    - ~run textbox_flush def.player:<player>
    - run intro_interact_laptop_task_role_menu def.player:<player>

intro_interact_laptop_task_role_menu:
    debug: false
    type: task
    definitions: player
    script:
    - definemap contents:
        1:
            item: <item[paper[display=<&6><&l>» <&e>Choose your starting role;lore=<&7>Your role gives you different roleplay opportunities and gameplay.|<&7>You can make a new character after the tutorial if you are unsure.]]>
        4:
            item: <item[book[display=<&f>鐀;lore=<&7><&o>A new student at Tatsuru Academy, ready to learn|<&7><&o>and live a highschooler's life.]]>
            script: intro_interact_laptop_task_role_callback
            definitions:
                player: <[player]>
                input: no
        6:
            item: <item[book[display=<&f>鐃;lore=<&7><&o>Freshly moved into Atarashikibo, on your way to|<&7><&o>find a job and a meaning.]]>
            script: intro_interact_laptop_task_role_callback
            definitions:
                player: <[player]>
                input: yes
    - run menu_open def.player:<[player]> def.title:<&f>邑邑邑邑酐<&a><&sp><&b><&sp><&c><&sp> def.size:9 def.contents:<[contents]>

intro_interact_laptop_task_role_callback:
    debug: false
    type: task
    definitions: player|input
    script:
    - inventory close player:<[player]>
    - define __player <[player]>
    - define adult <[input].to_lowercase.trim.equals[yes]>
    - if <[adult]>:
        - execute as_server "lp user <player.name> parent add adult"
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:An adult it shall be.$$nlIf this is wrong, let us know."
    - else:
        - execute as_server "lp user <player.name> parent add grade-10"
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:A student it shall be.$$nlIf this is wrong, let us know."
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:You should now be ready to start!"
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:Have fun!"
    - waituntil <player.has_flag[textbox_state].not> max:5s
    - cast BLINDNESS duration:infinite <player> no_ambient hide_particles no_icon
    - wait 1s
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* Though..." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[normal]>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* I feel obligated to ask." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* Have you heard of <&o>IC<&0><&l> and <&o>OOC<&0><&l>?" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[normal]>
    - definemap choices:
        left:
            text: Not really
        right:
            text: Yeah
    - ~run textbox_choice def.player:<player> def.queue:<queue> def.choices:<[choices]> save:result
    - define choice <entry[result].created_queue.determination.get[1]>
    - if <[choice]> == left:
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* Ah..." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[normal]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* You see, this WORLD..." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[normal]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* This... <&o>representation<&0><&l>." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[normal]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* You exist beyond it." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* I'm talking about you, <player.name>." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smirk]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* Your character.$$nlYour VESSEL.$$nl<player.flag[character_rpname]>" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[normal]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* They do not." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smirk]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* You, <player.name>, are <&o>out of character<&0><&l>." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[normal]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* Your VESSEL...$$nl<player.flag[character_rpname]>$$nlThey are <&o>in character<&0><&l>." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[normal]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* So, when your VESSEL speaks..." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[normal]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* That is not <&o>you<&0><&l>." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* Your VESSEL has different feelings,$$nlemotions, and experiences." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* What those are is for you to decide." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smirk]>
    - else:
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* Ah..." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[unimpressed]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* So you know they stand for$$nl<&o>in character<&0><&l> and <&o>out of character." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[normal]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* You are probably familiar with$$nlthis WORLD." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[normal]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* You are probably familiar with$$nlroleplaying, too." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[normal]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* I apologise for doubting you$$nllike that." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* . . ." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[unimpressed]>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* In this world, we get to choose who$$nlwe are, at least sort of." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* Maybe we cannot decide what the$$nloutcome will be, but we can try." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* <player.flag[character_rpname]>, I..." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[normal]>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* I think your choices are important,$$nlregardless." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* I think you should try your best to$$nldo what your heart tells you." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* Wouldn't you agree?" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
    - definemap choices:
        left:
            text: Correct
        right:
            text: ...
    - ~run textbox_choice def.player:<player> def.queue:<queue> def.choices:<[choices]> save:result
    - define choice <entry[result].created_queue.determination.get[1]>
    - if <[choice]> == left:
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* I'm glad you understand." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
    - else:
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* Ah..." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[unimpressed]>
        - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* I see." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smirk]>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* Very well. You are truly ready." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* When you are finally linked to$$nlour WORLD, you will see <&o>Marie<&0><&l>." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* She has talked to many others just$$nllike you." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* So, you should probably talk to her." def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
    - ~run textbox_write def.player:<player>  def.queue:<queue> "def.line3s:* I'll be on my way.$$nlGood luck!" def.avatar_unicode:<script[storyboard_avatar_dump].data_key[emika].get[smile]>
    - waituntil <player.has_flag[textbox_state].not> max:5s
    - ~run textbox_flush def.player:<player>
    - adjust <player> remove_effects
    - adjust <player> show_to_players
    - flag <player> intro:done
    - execute as_player player:<player> spawn
    - run storyboard_player_end_atomic_sequence def.queue:<queue> def.player:<player>
