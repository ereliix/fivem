fx_version 'bodacious'
games { 'gta5' }

version '0.0.1'

client_scripts {
    'client.lua',
	'kocsinevek.lua',
}

server_scripts {
    'server.lua',
    '@mysql-async/lib/MySQL.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/config.json',
    'html/images/*'
}