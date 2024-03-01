local ESX = GetResourceState('es_extended'):find('start') and exports['es_extended']:getSharedObject() or nil

if not ESX then return end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    Wait(3000)
    onPlayerLoaded()
end)