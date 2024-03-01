local QBCore = GetResourceState('qb-core'):find('start') and exports['qb-core']:GetCoreObject() or nil

if not QBCore then return end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(3000)
    onPlayerLoaded()
end)

function Notify(message, type)
    QBCore.Functions.Notify(message, type)
end