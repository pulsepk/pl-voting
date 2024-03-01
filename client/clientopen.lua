

RegisterNetEvent('pl-voting:notification')
AddEventHandler('pl-voting:notification', function(message, type)
    if Config.Notify == 'qb' then
        Notify(message, type)
    elseif Config.Notify == 'ox' then
        TriggerEvent('ox_lib:notify', {description = message, type = type or "success"})
    elseif Config.Notify == 'esx' then
        exports["esx_notify"]:Notify("info", 3000, message)
    elseif Config.Notify == 'okok' then
        TriggerEvent('okokNotify:Alert', message, 6000, type)
    elseif Config.Notify == 'custom' then
        -- Add your custom notifications here
    end
end)


RegisterCommand(Config.MenuCommand,function()
    local isAdmin = lib.callback.await('pl-voting:checkplayergroup', false)
    if isAdmin then
        TriggerEvent('pl-voting:ShowUiAdmin')
    else
        TriggerEvent('pl-voting:notification',locale('dont_have_permission'),'error')
    end
end)
