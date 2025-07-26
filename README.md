# FiveM Einreise Klingel System

Ein einfaches FiveM-Script für ein Klingelsystem mit visuellen Effekten, Sound und Discord-Webhook Integration.

## Features

- Ein Ped, der als Einreise-Schalter dient
- Interaktiver Text über dem Ped ("Drücke E um das Einreise Team zu kontaktieren")
- Visueller Sound-Effekt beim Klingeln
- Erfolgsbenachrichtigung für den Spieler
- Discord-Webhook mit Rolle-Ping (@beispiel)
- 5-Minuten-Cooldown zwischen Nutzungen
- Vollständig konfigurierbar über config.lua

## Installation

1. Lade das Repository herunter
2. Kopiere den Ordner in deinen FiveM-Server Ressourcen-Ordner
3. Füge `ensure bell_system` (oder wie auch immer du den Ordner benannt hast) zu deiner server.cfg hinzu
4. Konfiguriere die config.lua nach deinen Wünschen (besonders die Discord Webhook URL und Rollen-ID)
5. Starte deinen Server neu oder führe `refresh` und `start bell_system` in der Konsole aus

## Konfiguration

Öffne die `config.lua` Datei, um das Script anzupassen:

### Allgemeine Einstellungen
- `Config.UseESX` - Auf true setzen, wenn du ESX benutzt
- `Config.UseQBCore` - Auf true setzen, wenn du QBCore benutzt

### Ped Einstellungen
- `Config.Ped.model` - Das Ped-Modell
- `Config.Ped.coords` - Position und Rotation des Peds (X, Y, Z, Heading)
- `Config.Ped.scenario` - Animation des Peds

### Klingel Einstellungen
- `Config.Belltext` - Text über dem Ped
- `Config.BellDistance` - Distanz, in der der Text angezeigt wird
- `Config.InteractKey` - Taste für die Interaktion (Standard: E)
- `Config.Cooldown` - Cooldown in Sekunden
- `Config.SuccessMessage` - Erfolgsmeldung
- `Config.CooldownMessage` - Cooldown-Nachricht

### Sound Einstellungen
- `Config.SoundFile` - Sound-Datei Name
- `Config.SoundVolume` - Lautstärke des Sounds
- `Config.SoundRadius` - Radius, in dem der Sound zu hören ist

### Notification Einstellungen
- `Config.NotificationType` - Notification-System: 'esx', 'qbcore', 'mythic_notify', 'custom'
- `Config.NotificationDuration` - Dauer der Benachrichtigung in ms
- `Config.NotificationPosition` - Position der Benachrichtigung

### Discord Webhook Einstellungen
- `Config.DiscordWebhook.enabled` - Discord Webhook aktivieren/deaktivieren
- `Config.DiscordWebhook.url` - Discord Webhook URL
- `Config.DiscordWebhook.botName` - Name des Discord Bots
- `Config.DiscordWebhook.avatarUrl` - Avatar des Discord Bots
- `Config.DiscordWebhook.roleId` - ID der Discord Rolle, die gepingt werden soll
- `Config.DiscordWebhook.color` - Farbe des Discord Embeds

## Sound anpassen

Das Script verwendet standardmäßig den GTA-Sound "CONFIRM_BEEP" aus dem "HUD_MINI_GAME_SOUNDSET". Du kannst auch einen eigenen Sound hinzufügen:

1. Erstelle einen `stream` Ordner in deinem Ressourcenordner, falls noch nicht vorhanden
2. Füge deine .ogg Sound-Datei in den Ordner `stream` ein (am besten im Format `custom_bell_sound.ogg`)
3. In `config.lua` ändere folgende Einstellungen:
   ```lua
   Config.UseCustomSound = true -- Auf true setzen für eigenen Sound
   Config.SoundFile = "custom_bell_sound" -- Name deiner Sound-Datei ohne .ogg
   ```

### Wichtige Hinweise zu Sounds:

- Sound-Dateien müssen im .ogg Format sein
- Der Dateiname in der Config muss exakt mit dem Dateinamen übereinstimmen (ohne Dateiendung)
- Für optimale Kompatibilität solltest du die Abtastrate auf 44100 Hz und eine Bitrate von 128-192 kbps verwenden
- Halte die Sound-Datei klein (unter 1 MB), um Leistungsprobleme zu vermeiden

## Support

Bei Fragen oder Problemen kannst du ein Issue auf GitHub erstellen.

## Lizenz

[MIT](https://choosealicense.com/licenses/mit/)