Config = {}

-- Allgemeine Einstellungen
Config.UseESX = true -- Auf true setzen, wenn du ESX benutzt
Config.UseQBCore = false -- Auf true setzen, wenn du QBCore benutzt

-- Ped Einstellungen
Config.Ped = {
    model = "a_m_y_business_03", -- Ped Modell (https://docs.fivem.net/docs/game-references/ped-models/)
    coords = vector4(205.73, -1651.32, 29.80, 140.0), -- Position und Rotation des Peds (X, Y, Z, Heading)
    scenario = "WORLD_HUMAN_CLIPBOARD" -- Animation des Peds (https://github.com/DurtyFree/gta-v-data-dumps/blob/master/scenarios.json)
}

-- Klingel Einstellungen
Config.Belltext = "Drücke ~g~E~s~ um das Einreise Team zu kontaktieren" -- Text über dem Ped
Config.BellDistance = 2.0 -- Distanz, in der der Text angezeigt wird
Config.InteractKey = 38 -- Taste E (https://docs.fivem.net/docs/game-references/controls/)
Config.Cooldown = 5 * 60 -- Cooldown in Sekunden (5 Minuten)
Config.SuccessMessage = "Sie haben erfolgreich das Einreise Team kontaktiert" -- Erfolgsmeldung
Config.CooldownMessage = "Du musst noch {time} warten, bis du erneut klingeln kannst" -- Cooldown-Nachricht

-- Sound Einstellungen
Config.UseCustomSound = false  -- Auf true setzen, wenn du einen eigenen Sound verwenden willst
Config.SoundFile = "custom_bell_sound" -- Sound-Datei Name (ohne Dateiendung) - nur für eigene Sounds
Config.SoundVolume = 1.0 -- Lautstärke des Sounds (0.0 - 1.0)
Config.SoundRadius = 10.0 -- Radius, in dem der Sound zu hören ist

-- Notification Einstellungen
Config.NotificationType = "mythic_notify" -- Notification-System: 'esx', 'qbcore', 'mythic_notify', 'custom'
Config.NotificationDuration = 5000 -- Dauer der Benachrichtigung in ms
Config.NotificationPosition = "top-right" -- Position der Benachrichtigung (nur für mythic_notify)

-- Discord Webhook Einstellungen
Config.DiscordWebhook = {
    enabled = true,
    url = "https://discord.com/api/webhooks/YOUR_WEBHOOK_URL_HERE", -- Deine Discord Webhook URL
    botName = "Einreise Klingel", -- Name des Bots
    avatarUrl = "https://i.imgur.com/wSTFkRM.png", -- Avatar des Bots
    roleId = "123456789012345678", -- ID der Rolle, die gepingt werden soll
    color = 3447003 -- Farbe des Embeds (Blau)
}

-- Debug-Modus
Config.Debug = false -- Debug-Modus aktivieren/deaktivieren