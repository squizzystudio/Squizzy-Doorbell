local ESX = nil
local QBCore = nil
local pedHandle = nil
local isNearPed = false
local displayingText = false

-- Framework Initialisierung
Citizen.CreateThread(function()
    if Config.UseESX then
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    elseif Config.UseQBCore then
        QBCore = exports['qb-core']:GetCoreObject()
    end
    
    if Config.Debug then
        print("^2[Bell System] Client-Side wurde geladen^7")
    end
    
    -- Ped erstellen
    createPed()
    
    -- GTA Sound Banks laden
    RequestScriptAudioBank("HUD_MINI_GAME_SOUNDSET", false)
    RequestScriptAudioBank("SASQUATCH_SOUNDSET", false)  -- Für den Doorbell Sound
    
    -- Eigene Sound Bank laden, falls vorhanden
    if Config.UseCustomSound then
        RequestScriptAudioBank("bell_system_sounds", false)
    end
end)

-- Haupt-Loop
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local pedCoords = vector3(Config.Ped.coords.x, Config.Ped.coords.y, Config.Ped.coords.z)
        local dist = #(coords - pedCoords)
        
        isNearPed = dist < Config.BellDistance
        
        if isNearPed then
            if not displayingText then
                displayingText = true
                -- 3D Text anzeigen
                Citizen.CreateThread(function()
                    while displayingText and isNearPed do
                        local textCoords = vector3(Config.Ped.coords.x, Config.Ped.coords.y, Config.Ped.coords.z + 2.0)
                        DrawText3D(textCoords, Config.Belltext)
                        Citizen.Wait(0)
                    end
                end)
            end
            
            -- E-Taste abfragen
            if IsControlJustPressed(0, Config.InteractKey) then
                TriggerServerEvent('bell_system:checkCooldown')
            end
        else
            displayingText = false
        end
        
        Citizen.Wait(isNearPed and 0 or 500)
    end
end)

-- Ped erstellen
function createPed()
    RequestModel(GetHashKey(Config.Ped.model))
    while not HasModelLoaded(GetHashKey(Config.Ped.model)) do
        Citizen.Wait(1)
    end
    
    -- Vorherigen Ped entfernen, falls vorhanden
    if DoesEntityExist(pedHandle) then
        DeleteEntity(pedHandle)
    end
    
    -- Neuen Ped erstellen
    pedHandle = CreatePed(4, GetHashKey(Config.Ped.model), Config.Ped.coords.x, Config.Ped.coords.y, Config.Ped.coords.z - 1.0, Config.Ped.coords.w, false, true)
    FreezeEntityPosition(pedHandle, true)
    SetEntityInvincible(pedHandle, true)
    SetBlockingOfNonTemporaryEvents(pedHandle, true)
    
    -- Ped-Animation setzen
    if Config.Ped.scenario ~= "" then
        TaskStartScenarioInPlace(pedHandle, Config.Ped.scenario, 0, true)
    end
    
    if Config.Debug then
        print("^2[Bell System] Ped wurde erstellt^7")
    end
end

-- Klingel auslösen
RegisterNetEvent('bell_system:triggerBell')
AddEventHandler('bell_system:triggerBell', function()
    -- Visueller Sound (Animation)
    local pedCoords = vector3(Config.Ped.coords.x, Config.Ped.coords.y, Config.Ped.coords.z)
    TriggerServerEvent('bell_system:playSound', pedCoords)
    
    -- Erfolgsmeldung anzeigen
    showNotification(Config.SuccessMessage)
end)

-- Sound abspielen (für alle Clients)
RegisterNetEvent('bell_system:playClientSound')
AddEventHandler('bell_system:playClientSound', function(coords)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(playerCoords - coords)
    
    if distance <= Config.SoundRadius then
        -- Sound abspielen
        local soundId = GetSoundId()
        if Config.UseCustomSound then
            -- Eigener Sound
            PlaySoundFromCoord(soundId, Config.SoundFile, coords.x, coords.y, coords.z, nil, Config.SoundVolume, 0, 0)
        else
            -- GTA-Sound
            PlaySoundFromCoord(soundId, "CONFIRM_BEEP", coords.x, coords.y, coords.z, "HUD_MINI_GAME_SOUNDSET", Config.SoundVolume, 0, 0)
        end
        
        -- Visuelle Animation der Soundwellen
        createSoundWaves(coords)
        
        -- Sound-ID freigeben
        Citizen.SetTimeout(2000, function()
            ReleaseSoundId(soundId)
        end)
    end
end)

-- Cooldown-Benachrichtigung
RegisterNetEvent('bell_system:cooldownNotification')
AddEventHandler('bell_system:cooldownNotification', function(message)
    showNotification(message)
end)

-- Soundwellen visualisieren
function createSoundWaves(coords)
    local dict = "scr_appartment_mp"
    local particleName = "scr_tn_meet_phone_camera_flash"
    
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end
    
    SetPtfxAssetNextCall(dict)
    local effect = StartParticleFxLoopedAtCoord(particleName, coords.x, coords.y, coords.z + 1.0, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    
    Citizen.SetTimeout(1000, function()
        StopParticleFxLooped(effect, 0)
    end)
end

-- 3D Text anzeigen
function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local scale = (1 / #(GetGameplayCamCoords() - coords)) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Benachrichtigung anzeigen
function showNotification(message)
    if Config.NotificationType == "esx" and ESX then
        ESX.ShowNotification(message)
    elseif Config.NotificationType == "qbcore" and QBCore then
        QBCore.Functions.Notify(message)
    elseif Config.NotificationType == "mythic_notify" then
        exports['mythic_notify']:DoHudText('inform', message)
    else
        -- Standard-Benachrichtigung
        SetNotificationTextEntry("STRING")
        AddTextComponentString(message)
        DrawNotification(false, false)
    end
end

-- Cleanup beim Resource-Stop
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
    if DoesEntityExist(pedHandle) then
        DeleteEntity(pedHandle)
    end
    
    if Config.Debug then
        print("^1[Bell System] Resource wurde gestoppt^7")
    end
end)