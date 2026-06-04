RegisterNetEvent('pl-voting:notification')
AddEventHandler('pl-voting:notification', function(message, ntype)
    exports['pl_lib']:Notify('Election', message, ntype or 'success')
end)

RegisterCommand(Config.MenuCommand, function()
    local isAdmin = lib.callback.await('pl-voting:checkplayergroup', false)
    if isAdmin then
        TriggerEvent('pl-voting:ShowUiAdmin')
    else
        TriggerEvent('pl-voting:notification', locale('dont_have_permission'), 'error')
    end
end)
