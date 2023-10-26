local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('custom:chatAnnouncement')
AddEventHandler('custom:chatAnnouncement',function(msg)
    TriggerClientEvent('chat:addMessage', -1, {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Announcement", msg}
    })
end)
