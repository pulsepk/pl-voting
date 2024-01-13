
Object = nil

Citizen.CreateThread(function()
    Object = frameworkObject() 
end)

local webhook = "https://discord.com/api/webhooks/1167391436862406676/_QzMxadzP-1oFAU6OpRJexjsa8mAofhe-eLKAyYjYcvJ48WHbMNhse5Gjutw9ufT2bgE"

RegisterNetEvent('custom:sendToDiscord')
AddEventHandler('custom:sendToDiscord', function(message)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end)

RegisterNetEvent('custom:chatAnnouncement')
AddEventHandler('custom:chatAnnouncement',function(msg)
    TriggerClientEvent('chat:addMessage', -1, {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Announcement", msg}
    })
end)


