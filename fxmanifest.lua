fx_version "cerulean"
games { "gta5" }
description "Advanced Fivem Election Voting System"
author 'PulseScripts - pulsescripts.com'
version '1.1.0'

lua54 'yes'

ui_page 'web/index.html'

dependencies {
    'ox_lib',
    'pl_lib',
}

shared_script {
    '@ox_lib/init.lua',
    'config.lua',
}

client_script {
    'client/client.lua',
    'client/clientopen.lua',
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
    'server/serveropen.lua',
}

files {
    'web/index.html',
    'web/style.css',
    'web/script.js',
    'locales/*.json',
    'electionstate.json',
}
