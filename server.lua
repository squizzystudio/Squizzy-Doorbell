local ESX = nil
local QBCore = nil
local cooldowns = {}

-- Framework Initialisierung
if Config.UseESX then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
elseif Config.UseQBCore then
    QBCore = exports['qb-core']:GetCoreObject()
end

-- Sound abspielen für alle Spieler in der Nähe
RegisterServerEvent('bell_system:playSound')
AddEventHandler('bell_system:playSound', function(coords)
    TriggerClientEvent('bell_system:playClientSound', -1, coords)
end)

-- Cooldown-Verwaltung
RegisterServerEvent('bell_system:checkCooldown')
AddEventHandler('bell_system:checkCooldown', function()
    local _source = source
    local identifier = getPlayerIdentifier(_source)
    
    if cooldowns[identifier] then
        local timeLeft = cooldowns[identifier] - os.time()
        if timeLeft > 0 then
            -- Cooldown noch aktiv
            local minutes = math.floor(timeLeft / 60)
            local seconds = timeLeft % 60
            local timeString = string.format("%d Minuten und %d Sekunden", minutes, seconds)
            local message = string.gsub(Config.CooldownMessage, "{time}", timeString)
            TriggerClientEvent('bell_system:cooldownNotification', _source, message)
            return
        end
    end
    
    -- Kein Cooldown aktiv oder abgelaufen, Klingel auslösen
    cooldowns[identifier] = os.time() + Config.Cooldown
    TriggerClientEvent('bell_system:triggerBell', _source)
    
    -- Discord Webhook senden
    if Config.DiscordWebhook.enabled then
        sendDiscordWebhook(_source)
    end
end)

-- Discord Webhook senden
function sendDiscordWebhook(source)
    local playerName = GetPlayerName(source)
    local steamName, steam, discord, ip = getPlayerData(source)
    
    local embeds = {
        {
            ["title"] = "Einreise Klingel wurde betätigt",
            ["description"] = "<@&" .. Config.DiscordWebhook.roleId .. "> Es wartet jemand am Einreise-Schalter!",
            ["color"] = Config.DiscordWebhook.color,
            ["fields"] = {
                {
                    ["name"] = "Spieler",
                    ["value"] = playerName,
                    ["inline"] = true
                },
                {
                    ["name"] = "Steam",
                    ["value"] = steamName or "Nicht verfügbar",
                    ["inline"] = true
                },
                {
                    ["name"] = "ID",
                    ["value"] = source,
                    ["inline"] = true
                },
                {
                    ["name"] = "Zeit",
                    ["value"] = os.date("%d.%m.%Y %H:%M:%S"),
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Bell System • " .. os.date("%d.%m.%Y %H:%M:%S")
            }
        }
    }
    
    PerformHttpRequest(Config.DiscordWebhook.url, function(err, text, headers) end, 'POST', json.encode({
        username = Config.DiscordWebhook.botName,
        avatar_url = Config.DiscordWebhook.avatarUrl,
        embeds = embeds,
        content = "<@&" .. Config.DiscordWebhook.roleId .. ">"
    }), { ['Content-Type'] = 'application/json' })
end

-- Hilfsfunktionen
function getPlayerIdentifier(source)
    local identifier = nil
    
    if Config.UseESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            identifier = xPlayer.getIdentifier()
        end
    elseif Config.UseQBCore then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            identifier = Player.PlayerData.citizenid
        end
    else
        for k, v in ipairs(GetPlayerIdentifiers(source)) do
            if string.sub(v, 1, string.len("steam:")) == "steam:" then
                identifier = v
                break
            end
        end
    end
    
    -- Fallback auf IP-Adresse, falls kein Identifier gefunden wurde
    if not identifier then
        identifier = GetPlayerEndpoint(source)
    end
    
    return identifier
end

function getPlayerData(source)
    local steamName, steam, discord, ip = "Unbekannt", "Unbekannt", "Unbekannt", "Unbekannt"
    
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steam = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = string.sub(v, 9)
            discord = "Discord: <@" .. discord .. ">"
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = string.sub(v, 4)
        end
    end
    
    if steam ~= "Unbekannt" then
        local steamIdentifier = string.sub(steam, 7)
        PerformHttpRequest("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=YOUR_STEAM_API_KEY&steamids=" .. tonumber(steamIdentifier, 16), function(err, text, headers)
            if text then
                local data = json.decode(text)
                if data and data.response and data.response.players and data.response.players[1] then
                    steamName = data.response.players[1].personaname
                end
            end
        end, "GET", "", {["Content-Type"] = "application/json"})
    end
    
    return steamName, steam, discord, ip
end

-- Konsolen-Nachricht beim Start
if Config.Debug then
    print("^2[Bell System] Server-Side wurde geladen^7")
end