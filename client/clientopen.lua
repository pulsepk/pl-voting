Object = nil

Citizen.CreateThread(function()
    Object = frameworkObject() 
end)

RegisterNetEvent('custom:notification')
AddEventHandler('custom:notification', function(message, type)
    if Config.Notify == 'qb' then
    Object.Functions.Notify(message, type)
    elseif Config.Notify == 'ox' then
        TriggerEvent('ox_lib:notify', {description = message, type = type or "success"})
    elseif Config.Notify == 'okok' then
        TriggerEvent('okokNotify:Alert', message, 6000, type)
    elseif Config.Notify == 'custom' then
        -- Add your custom notifications here
    end
end)
