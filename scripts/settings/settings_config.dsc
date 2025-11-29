settings_config:
    debug: false
    type: data
    tabs:
    - General
    - Miscellaneous
    keys:
        example1.key:
            tab: General
            name: example1 setting key
            description: example1 description, Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...
            type: boolean
            default: true
        example2.key:
            tab: General
            name: example2 setting key
            description: example2 description, Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...
            type: number
            default: 5
            min: 0
            max: 10
            increment: 0.5
        example3.key:
            tab: Miscellaneous
            name: example3 setting key
            description: example3 description, Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...
            type: list
            default: male
            values:
            - male
            - female
            - prefer not to say
        example4.key:
            tab: Miscellaneous
            name: example4 setting key
            description: example4 description, Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...
            type: text
            default: text
            max-length: 64
            regex: [a-z]
