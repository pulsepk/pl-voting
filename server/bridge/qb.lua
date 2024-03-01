QBCore = GetResourceState('qb-core'):find('start') and exports['qb-core']:GetCoreObject() or nil

if not QBCore then return end


function getPlayerName(target)
    local xPlayer = QBCore.Functions.GetPlayer(target)

    return xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname
end

function getPlayerIdentifier(target)
    local xPlayer = QBCore.Functions.GetPlayer(target)

    return xPlayer.PlayerData.citizenid
end

function getPlayerLicense(target)
    local xPlayer = QBCore.Functions.GetIdentifier(target, 'license')

    return xPlayer
end

