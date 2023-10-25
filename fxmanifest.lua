fx_version "cerulean"

description "Voting"
author "PulsePK"
version '1.0.0'

lua54 'yes'

games {
    "gta5"
}

ui_page 'web/index.html'

shared_script 'config.lua'

client_script {
    'client.lua',
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua'
}
server_script {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua'
}

files {
    'web/index.html',
    'web/style.css',
    'web/script.js'
}