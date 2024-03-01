fx_version "cerulean"
games { "gta5" }
description "Advanced Fivem Election Voting System"
author "PulsePK https://discord.gg/yc94hR9kPx"
version '1.0.0'



ui_page 'web/index.html'

dependencies {
    'ox_lib'
}


shared_script {
    '@ox_lib/init.lua', --Comment out if you are not using ox
    'config.lua',
}

client_script {
    'client/client.lua',
    'client/bridge/qb.lua',
    'client/bridge/esx.lua',
    'client/clientopen.lua'
}
server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
    'server/bridge/qb.lua',
    'server/bridge/esx.lua',
    'server/serveropen.lua'
}

files {
    'web/index.html',
    'web/style.css',
    'web/script.js'
}