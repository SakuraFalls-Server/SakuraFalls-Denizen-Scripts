info_commands_forums:
    debug: false
    type: command
    name: forums
    description: Visit our forums!
    usage: /forums
    script:
    - narrate <&f>
    - narrate format:formats_prefix "Click on the link below to visit our forums:"
    - narrate "<&f><&sp><&sp><&sp><&e><&n>https://www.sakurafalls.net"
    - narrate <&f>
