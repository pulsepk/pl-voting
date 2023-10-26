local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('custom:notification')
AddEventHandler('custom:notification', function(message, type)
    if Config.Notify == 'qb' then
    QBCore.Functions.Notify(message, type)
    end
end)
