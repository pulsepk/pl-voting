-- Returns the license identifier for a player using native FiveM, no bridge needed
local function getPlayerLicense(src)
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:sub(1, 8) == 'license:' then return id end
    end
    return 'unknown'
end

-- Server-side admin check — used by every admin-only event handler
local function isAdmin(src)
    local fw = exports['pl_lib']:GetFramework()
    if fw == 'qb' or fw == 'qbox' then
        return Config.AdminLicense[getPlayerLicense(src)] == true
    elseif fw == 'esx' then
        local xPlayer = exports['pl_lib']:GetPlayer(src)
        if not xPlayer then return false end
        for _, perm in ipairs(Config.Permissions) do
            if xPlayer.getGroup() == perm then return true end
        end
        return false
    end
    return false
end

local function logAction(msg)
    exports['pl_lib']:Log(msg, {
        type     = Config.LogType,
        enable   = Config.Log,
        webhook  = Config.LogWebhook,
        jobname  = 'PL Election',
    })
end

-- Expose helpers so serveropen.lua can use them without re-declaring
_ENV.getPlayerLicense = getPlayerLicense
_ENV.isAdmin          = isAdmin
_ENV.logAction        = logAction

-- ── Callbacks ────────────────────────────────────────────────────────────────

lib.callback.register('voting:server:checkelectionstate', function()
    local data = LoadResourceFile(GetCurrentResourceName(), '/electionstate.json')
    local decoded = json.decode(data)
    if decoded then return decoded.state end
    print('[pl-voting] Failed to read electionstate.json')
    return false
end)

lib.callback.register('voting:server:checkIfVoted', function(source)
    local cid = exports['pl_lib']:GetPlayerIdentifier(source)
    local fw  = exports['pl_lib']:GetFramework()
    local hasVoted
    if fw == 'qb' or fw == 'qbox' then
        hasVoted = MySQL.Sync.fetchScalar('SELECT hasvoted FROM players WHERE citizenid = ? LIMIT 1', { cid })
    else
        hasVoted = MySQL.Sync.fetchScalar('SELECT hasvoted FROM users WHERE identifier = ? LIMIT 1', { cid })
    end
    return hasVoted == 1
end)

-- ── Election state events ────────────────────────────────────────────────────

RegisterNetEvent('pl-voting:checkresults', function()
    local src = source
    MySQL.Async.fetchAll('SELECT name, party, votes FROM election', {}, function(results)
        if results and #results > 0 then
            TriggerClientEvent('pl-voting:sendResults', src, results)
        else
            TriggerClientEvent('pl-voting:notification', src, locale('nothing_display'), 'error')
        end
    end)
end)

RegisterNetEvent('pl-voting:deleteRecord', function()
    local src = source
    if not isAdmin(src) then
        TriggerClientEvent('pl-voting:notification', src, locale('dont_have_permission'), 'error')
        return
    end
    MySQL.Async.execute('DELETE FROM election', {}, function(rowsChanged)
        if rowsChanged then
            TriggerClientEvent('pl-voting:notification', src, locale('election_record'), 'success')
            logAction('All election records deleted by **' .. exports['pl_lib']:GetPlayerName(src) ..
                      '**\n**Identifier:** ' .. getPlayerLicense(src))
        end
    end)
end)

RegisterNetEvent('pl-voting:endElection', function()
    local src = source
    if not isAdmin(src) then
        TriggerClientEvent('pl-voting:notification', src, locale('dont_have_permission'), 'error')
        return
    end
    local file = LoadResourceFile(GetCurrentResourceName(), '/electionstate.json')
    local data = json.decode(file)
    data.state = false
    SaveResourceFile(GetCurrentResourceName(), '/electionstate.json', json.encode(data), -1)
    TriggerClientEvent('pl-voting:notification', src, locale('you_ended_election'), 'success')
    logAction('Election ended by **' .. exports['pl_lib']:GetPlayerName(src) ..
              '**\n**Identifier:** ' .. getPlayerLicense(src))
    if Config.ServerAnnouncement then
        TriggerEvent('pl-voting:chatAnnouncement', locale('election_over'))
    end
end)

RegisterNetEvent('pl-voting:startelection', function()
    local src = source
    if not isAdmin(src) then
        TriggerClientEvent('pl-voting:notification', src, locale('dont_have_permission'), 'error')
        return
    end
    local file = LoadResourceFile(GetCurrentResourceName(), '/electionstate.json')
    local data = json.decode(file)
    data.state = true
    SaveResourceFile(GetCurrentResourceName(), '/electionstate.json', json.encode(data), -1)
    TriggerClientEvent('pl-voting:notification', src, locale('election_started'), 'success')
    logAction('Election started by **' .. exports['pl_lib']:GetPlayerName(src) ..
              '**\n**Identifier:** ' .. getPlayerLicense(src))
    if Config.ServerAnnouncement then
        TriggerEvent('pl-voting:chatAnnouncement', locale('election_started'))
    end
end)

-- ── Resource start ───────────────────────────────────────────────────────────

local resourceName = GetCurrentResourceName()

if Config.WaterMark then
    SetTimeout(1500, function()
        print('^1[' .. resourceName .. '] ^2Thank you for downloading the script^0')
        print('^1[' .. resourceName .. '] ^2Support: https://discord.gg/c6gXmtEf3H^0')
    end)
end

AddEventHandler('onServerResourceStart', function(started)
    if started ~= resourceName then return end
    Wait(500)
    TriggerClientEvent('pl-voting:ClearVotingMenu', -1)
    local file = LoadResourceFile(resourceName, '/electionstate.json')
    local data = json.decode(file)
    data.state = false
    SaveResourceFile(resourceName, '/electionstate.json', json.encode(data), -1)
end)
