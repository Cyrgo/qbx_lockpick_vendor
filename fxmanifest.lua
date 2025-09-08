fx_version 'cerulean'
game 'gta5'

name 'qbx_lockpick_vendor'
description 'Simple NPC vendor that sells lockpicks'
version '1.0.0'

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua',
}

client_scripts {
  'client.lua',
}

server_scripts {
  'server.lua',
}

lua54 'yes'

