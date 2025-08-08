fx_version 'cerulean'
game 'gta5'

description 'BEANS-PICKING (QBox)'

lua54 'yes'

shared_script 'config.lua'

client_scripts {
    '@ox_lib/init.lua', 
    'client/main.lua'
}

server_scripts {
    '@ox_lib/init.lua',
    'server/main.lua'
}

dependencies {
    'ox_lib',
    'ox_inventory', 
}
