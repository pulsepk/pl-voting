fx_version "cerulean"

description "Advanced Fivem Election Voting System"
author "PulsePK https://discord.gg/yc94hR9kPx"
version '1.0.0'


games {
    "gta5"
}

ui_page 'web/index.html'

shared_script {
    '@ox_lib/init.lua', --Comment out if you are not using ox
    'config.lua',
    'locale/*.lua'
}

client_script {
    'frameworkObject.lua',
    'client/client.lua',
    'client/clientopen.lua',
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua'

}
server_script {
    'frameworkObject.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
    'server/serveropen.lua'
}

files {
    'web/index.html',
    'web/style.css',
    'web/script.js'
}

escrow_ignore {
    "client/clientopen.lua",
    "server/serveropen.lua",
    "config.lua",
    "web/**",
    "frameworkObject.lua",
    "fxmanifest.lua",
    "README.md",
    "sql.sql"
}

lua54 'yes'
dependency '/assetpacks'