settings_config:
    debug: false
    type: data
    tabs:
    - General
    - Miscellaneous
    keys:
        example1_key:
            tab: General
            name: example1 setting key
            description: example1 description, Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...
            type: boolean
            default: true
        example2_key:
            tab: General
            name: example2 setting key
            description: example2 description, Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...
            type: number
            default: 5
            min: 0
            max: 10
            increment: 0.5
        example3_key:
            tab: Miscellaneous
            name: example3 setting key
            description: example3 description, Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...
            type: list
            default: male
            values:
            - male
            - female
            - prefer not to say
        example4_key:
            tab: Miscellaneous
            name: example4 setting key
            description: example4 description, Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...
            type: text
            default: text
            max-length: 64
            regex: [a-z]
        example5_key:
            tab: Miscellaneous
            name: example5 setting key
            description: example5 description, Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...
            type: text
            default: text
            max-length: 64
            regex: [a-z]
        example6_key:
            tab: Miscellaneous
            name: example6 setting key
            description: example6 description, Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...
            type: text
            default: text
            max-length: 64
            regex: [a-z]
        example7_key:
            tab: Miscellaneous
            name: example7 setting key
            description: example7 description, Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...
            type: text
            default: text
            max-length: 64
            regex: [a-z]
