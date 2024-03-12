fx_version "cerulean"
games { "gta5" }
description "Advanced Fivem Election Voting System"
author "PulsePK https://discord.gg/yc94hR9kPx"
version '1.0.1'

lua54 'yes'


ui_page 'web/index.html'

dependencies {
    'ox_lib'
}


shared_script {
    '@ox_lib/init.lua',
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
    'web/script.js',
    'locales/*.json',
    'electionstate.json'
}

escrow_ignore {
    'client/bridge/qb.lua',
    'client/bridge/esx.lua',
    'server/bridge/qb.lua',
    'server/bridge/esx.lua',
    "client/clientopen.lua",
    "server/serveropen.lua",
    "config.lua",
    "web/**",
    'locales/*.json',
    "electionstate.json",
    "database.sql"
}

