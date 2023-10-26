fx_version "cerulean"

description "Advanced Fivem Election Voting System"
author "PulsePK https://discord.gg/yc94hR9kPx"
version '1.0.0'

lua54 'yes'

games {
    "gta5"
}

ui_page 'web/index.html'

shared_script {
    'config.lua',
    'locale/*.lua'
}

client_script {
    'client/client.lua',
    'client/clientopen.lua',
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua'

}
server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
    'server/serveropen.lua'
}

files {
    'web/index.html',
    'web/style.css',
    'web/script.js'
}