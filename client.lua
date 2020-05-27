ESX = nil

local PlayerData = {}
local HasAlreadyEnteredMarker = false
local currentZone = nil
local DISTANCE = 10
local DISTANCE_INTERACTION = 2.0
local MARKER_SIZE = 1.0
local E_KEY = 38

Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                'esx:getSharedObject',
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(0)
        end

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        PlayerData = ESX.GetPlayerData()
        Start()
    end
)

function Start()
    for _, ped in pairs(Config.Peds) do
        if ped.model ~= nil then
            local modelHash = GetHashKey(ped.model)
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Wait(1)
            end
            local SpawnedPed = CreatePed(2, modelHash, ped.pos, ped.h, false, true)
            TaskSetBlockingOfNonTemporaryEvents(SpawnedPed, true)
            Citizen.Wait(1)
            if ped.animation ~= nil then
                TaskStartScenarioInPlace(SpawnedPed, ped.animation, 0, false)
            end
            SetEntityInvincible(SpawnedPed, true)
            PlaceObjectOnGroundProperly(SpawnedPed)
            SetModelAsNoLongerNeeded(modelHash)
            Citizen.CreateThread(
                function()
                    local _ped = SpawnedPed
                    Citizen.Wait(1000)
                    FreezeEntityPosition(_ped, true)
                end
            )
        end
    end

    function spawnMarker(ped, coords)
        if PlayerData.job.name == 'police' and ped.policeLock then
            return
        end
        local cur_distance = GetDistanceBetweenCoords(coords, ped.pos, true)
        if ped.onEnter ~= nil and cur_distance < DISTANCE then
            DrawMarker(1, ped.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, MARKER_SIZE, MARKER_SIZE, 0.4, 102, 0, 204, 50, false, false, 2, false, false, false, false)
            if cur_distance < DISTANCE_INTERACTION then
                if not HasAlreadyEnteredMarker then
                    currentZone = ped.name
                    HasAlreadyEnteredMarker = true
                end
                if HasAlreadyEnteredMarker then
                    PlayerData = ESX.GetPlayerData()
                    if ped.onEnterText ~= nil then
                        ESX.ShowHelpNotification(ped.onEnterText)
                    end
                    if IsControlPressed(0, E_KEY) then
                        local pedEvent = ped.resource..':'..ped.onEnter
                        if ped.serverSide then
                            TriggerServerEvent(pedEvent)
                        else
                            TriggerEvent(pedEvent)
                        end
                    end
                end
            elseif ped.onExit ~= nil and HasAlreadyEnteredMarker and ped.name == currentZone then
                HasAlreadyEnteredMarker = false
                local pedEvent = ped.resource..':'..ped.onExit
                if ped.serverSide then
                    TriggerServerEvent(pedEvent)
                else
                    TriggerEvent(pedEvent)
                end
            end
        end
    end

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local coords = GetEntityCoords(PlayerPedId())
            for _, ped in pairs(Config.Peds) do
                if ped.onEnter ~= nil or ped.onExit ~= nil then
                    spawnMarker(ped, coords)
                end
            end
        end
    end)
end