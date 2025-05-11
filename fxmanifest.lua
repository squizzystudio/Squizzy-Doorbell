fx_version 'cerulean'
game 'gta5'

author 'Squizzy Studio'
description 'Bell System für FiveM mit Discord-Webhook Integration'
version '1.2.0'

shared_script 'config.lua'

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua',
}

-- Füge eigene Sounds hier hinzu, falls du welche verwendest
files {
    'stream/custom_bell_sound.ogg'
}

-- Diese Zeilen nur auskommentieren, wenn du einen eigenen Sound mit einem 
-- speziellen Sound-Bank-System verwendest
-- data_file 'AUDIO_GAMEDATA' 'audioconfig/bell_sounds.dat'
-- data_file 'AUDIO_SOUNDDATA' 'audioconfig/bell_sounds_sounds.dat'
-- data_file 'AUDIO_WAVEPACK' 'stream/bell_sounds'

lua54 'yes'