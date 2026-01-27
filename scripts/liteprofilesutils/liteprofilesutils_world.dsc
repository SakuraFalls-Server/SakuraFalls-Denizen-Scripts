liteprofilesutils_world:
    debug: false
    type: world
    events:
        ## load YAML data
        after server start:
        - ~run liteprofilesutils_load_data
        ## patch join/leave & rank sync
        on player quits:
        - define masteruuid <proc[liteprofilesutils_get_master_uuid].context[<player>]>
        - define profilelimit <placeholder[liteprofiles_limit]>
        #
        - flag server liteprofilesutils_lastseengroups:<server.flag[liteprofilesutils_lastseengroups].if_null[<map[]>].with[<[masteruuid]>].as[<player.groups>]>
        #
        - define lastbestlimit <server.flag[liteprofilesutils_lastbestlimit].if_null[<map[]>]>
        - flag server liteprofilesutils_lastbestlimit:<[lastbestlimit].with[<[masteruuid]>].as[<[profilelimit].max[<[lastbestlimit].get[<[masteruuid]>].if_null[1]>]>]>
        #
        - define joinleavedata <script[liteprofilesutils_data].data_key[join-leave]>
        - define setting_enabled_players <server.online_players.filter_tag[<proc[settings_get].context[<[filter_value]>|general_see_player_join_leave]>]>
        - narrate <[joinleavedata].get[leave].parsed> targets:<[setting_enabled_players]>
        on player joins:
        - define masteruuid <proc[liteprofilesutils_get_master_uuid].context[<player>]>
        # sync groups, O(scary)
        - define syncgroupdata <script[liteprofilesutils_data].data_key[rank-sync]>
        - define lastseengroups <server.flag[liteprofilesutils_lastseengroups].get[<[masteruuid]>].if_null[<list[]>]>
        - if <[lastseengroups].is_empty>:
            - goto joinmessage
        - foreach <[lastseengroups].include[<player.groups>]> as:trygroup:
            - define ok false
            - foreach <[syncgroupdata]> as:matchgroup:
                - if <[trygroup].advanced_matches[<[matchgroup]>]>:
                    - define ok true
                    - foreach stop
            - if !<[ok]>:
                - foreach next
            - if <[lastseengroups].contains[<[trygroup]>]>:
                - if !<player.in_group[<[trygroup]>]>:
                    - group add <[trygroup]>
            - else:
                - if <player.in_group[<[trygroup]>]>:
                    - group remove <[trygroup]>
        - if !<player.in_group[default]>:
            - group add default
        # sync best perm level
        - define bestlimit <server.flag[liteprofilesutils_lastbestlimit].get[<[masteruuid]>].if_null[1]>
        - if !<player.has_permission[liteprofiles.limit.<[bestlimit]>]>:
            - permission add liteprofiles.limit.<[bestlimit]>
        # sync op
        - if <player[<[masteruuid]>].is_op>:
            - adjust <player> is_op:true
        - else:
            - adjust <player> is_op:false
        # sync whitelist
        - if <player[<[masteruuid]>].whitelisted>:
            - adjust <player> whitelisted:true
        - else:
            - adjust <player> whitelisted:false
        # adjust join message
        - mark joinmessage
        - define joinleavedata <script[liteprofilesutils_data].data_key[join-leave]>
        - if <player.uuid> == <[masteruuid]>:
            - if <server.flag[liteprofilesutils_welcome].if_null[<list[]>].contains[<player.uuid>]>:
                - announce <[joinleavedata].get[welcome].parsed>
                - flag server liteprofilesutils_welcome:<server.flag[liteprofilesutils_welcome].if_null[<list[]>].include[<player.uuid>]>
        - define setting_enabled_players <server.online_players.filter_tag[<proc[settings_get].context[<[filter_value]>|general_see_player_join_leave]>]>
        - narrate <[joinleavedata].get[join].parsed> targets:<[setting_enabled_players]>
        ## prevent /profile remove
        on command:
        - if <context.source_type> != player:
            - stop
        - if <player.is_op>:
            - stop
        - if <context.command.to_lowercase> == profile || <context.command.to_lowercase> == account || <context.command.to_lowercase> == pf:
            - if <context.args.get[1].to_lowercase.if_null[null]> == remove:
                - determine cancelled passively
                - narrate "<&c>You are forbidden from performing this operation."
        ## GUI menu
        on player clicks in inventory bukkit_priority:low:
        - if <context.inventory.title> != <&f>邑邑邑邑鄈:
            - stop
        - if <player.flag[liteprofiles_legacy_menu].get[id].if_null[null]> != liteprofiles:
            - stop
        - if <context.slot> > 45:
            - stop
        - if <context.item.advanced_matches[air]>:
            - stop
        # logic
        - define data <context.item.flag[liteprofiles].if_null[null]>
        - if <[data]> == null:
            - stop
        - if <[data].get[type]> == master:
            - define value <[data].get[value]>
            - inventory close
            - execute as_player "profile use <[value]>"
        - else if <[data].get[type]> == slave:
            - define value <[data].get[value]>
            - inventory close
            - execute as_player "profile use <[value]>"
        - else if <[data].get[type]> == free:
            - execute as_player "profile add"
            - run liteprofilesutils_show_menu def.player:<player>
        ## patch whitelisting
        on player prelogin:
        - define uuid <context.uuid>
        - define master <proc[liteprofilesutils_get_master_uuid].context[<player[<[uuid]>]>]>
        - if <[master]> == <[uuid]>:
            - stop
        - adjust <player[<[uuid]>]> whitelisted:<player[<[master]>].is_whitelisted>

