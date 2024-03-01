local ESX = GetResourceState('es_extended'):find('start') and exports['es_extended']:getSharedObject() or nil

if not ESX then return end

function getPlayerName(target)
    local xPlayer = ESX.GetPlayerFromId(target)

    return xPlayer.getName()
end

function getPlayerIdentifier(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    return xPlayer.getIdentifier()
end

function getPlayerLicense(target)
    local xPlayer =  ESX.GetPlayerFromId(target)

    return xPlayer.getIdentifier()
end

function GetPlayerAdmin(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    return xPlayer
end
