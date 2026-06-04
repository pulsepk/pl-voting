-- ── Chat announcement ────────────────────────────────────────────────────────

RegisterNetEvent('pl-voting:chatAnnouncement')
AddEventHandler('pl-voting:chatAnnouncement', function(msg)
    TriggerClientEvent('chat:addMessage', -1, {
        color     = { 255, 0, 0 },
        multiline = true,
        args      = { 'Announcement', msg },
    })
end)

-- ── Admin permission callback (used by client command) ───────────────────────

lib.callback.register('pl-voting:checkplayergroup', function(source)
    return isAdmin(source)
end)

-- ── Vote casting ─────────────────────────────────────────────────────────────

RegisterNetEvent('voting:server:castVote', function(data)
    local src = source

    -- Basic input validation
    if type(data) ~= 'table' or type(data.vote) ~= 'string' or type(data.party) ~= 'string' then
        TriggerClientEvent('pl-voting:notification', src, 'Invalid vote data.', 'error')
        return
    end

    -- Server-side election state check (prevents console exploits)
    local file  = LoadResourceFile(GetCurrentResourceName(), '/electionstate.json')
    local state = json.decode(file)
    if not state or not state.state then
        TriggerClientEvent('pl-voting:notification', src, locale('election_closed'), 'error')
        return
    end

    local cid = exports['pl_lib']:GetPlayerIdentifier(src)
    local fw  = exports['pl_lib']:GetFramework()

    -- Server-side duplicate-vote check
    local hasVoted
    if fw == 'qb' or fw == 'qbox' then
        hasVoted = MySQL.Sync.fetchScalar('SELECT hasvoted FROM players WHERE citizenid = ? LIMIT 1', { cid })
    else
        hasVoted = MySQL.Sync.fetchScalar('SELECT hasvoted FROM users WHERE identifier = ? LIMIT 1', { cid })
    end
    if hasVoted == 1 then
        TriggerClientEvent('pl-voting:notification', src, locale('already_voted'), 'error')
        return
    end

    -- Mark player as voted
    if fw == 'qb' or fw == 'qbox' then
        MySQL.update('UPDATE players SET hasvoted = 1 WHERE citizenid = ?', { cid })
    else
        MySQL.update('UPDATE users SET hasvoted = 1 WHERE identifier = ?', { cid })
    end

    -- Record the vote (names stored plainly, not double-encoded)
    local existing = MySQL.Sync.fetchAll('SELECT votes FROM election WHERE name = ?', { data.vote })
    if not existing[1] then
        MySQL.insert('INSERT INTO election (name, party, votes) VALUES (?, ?, ?)', { data.vote, data.party, 1 })
    else
        MySQL.update('UPDATE election SET votes = ? WHERE name = ?', { existing[1].votes + 1, data.vote })
    end

    TriggerClientEvent('pl-voting:notification', src, locale('successfully_voted'), 'success')
    logAction('**' .. exports['pl_lib']:GetPlayerName(src) .. '** (`' .. cid .. '`) voted for **' .. data.vote .. '**')
end)

-- ── Reset all votes ──────────────────────────────────────────────────────────

RegisterNetEvent('pl-voting:resetsvotes', function()
    local src = source
    if not isAdmin(src) then
        TriggerClientEvent('pl-voting:notification', src, locale('dont_have_permission'), 'error')
        return
    end
    local fw = exports['pl_lib']:GetFramework()
    local query = (fw == 'qb' or fw == 'qbox')
        and 'UPDATE players SET hasvoted = 0 WHERE hasvoted = 1'
        or  'UPDATE users SET hasvoted = 0 WHERE hasvoted = 1'
    MySQL.Async.execute(query, {}, function()
        TriggerClientEvent('pl-voting:notification', src, locale('reset_player_status'), 'success')
        logAction('All voting statuses reset by **' .. exports['pl_lib']:GetPlayerName(src) ..
                  '**\n**Identifier:** ' .. getPlayerLicense(src))
    end)
end)

-- ── Reset a single player's vote ─────────────────────────────────────────────

RegisterNetEvent('pl-voting:resetSomeonevote', function(playerId)
    local src      = source
    if not isAdmin(src) then
        TriggerClientEvent('pl-voting:notification', src, locale('dont_have_permission'), 'error')
        return
    end
    local playerID = tonumber(playerId)
    if not playerID then
        TriggerClientEvent('pl-voting:notification', src, locale('couldnot_find_id'), 'error')
        return
    end
    local cid = exports['pl_lib']:GetPlayerIdentifier(playerID)
    if not cid then
        TriggerClientEvent('pl-voting:notification', src, locale('couldnot_find_id'), 'error')
        return
    end
    local fw = exports['pl_lib']:GetFramework()
    local query, params
    if fw == 'qb' or fw == 'qbox' then
        query  = 'UPDATE players SET hasvoted = 0 WHERE citizenid = @id AND hasvoted = 1'
        params = { ['@id'] = cid }
    else
        query  = 'UPDATE users SET hasvoted = 0 WHERE identifier = @id AND hasvoted = 1'
        params = { ['@id'] = cid }
    end
    MySQL.Async.execute(query, params, function(rows)
        if rows > 0 then
            TriggerClientEvent('pl-voting:notification', src,      locale('player_voting_status'), 'success')
            TriggerClientEvent('pl-voting:notification', playerID, locale('your_voting_status'),   'success')
            logAction('**' .. exports['pl_lib']:GetPlayerName(src) .. '** reset the vote of **' ..
                      exports['pl_lib']:GetPlayerName(playerID) .. '**')
        else
            TriggerClientEvent('pl-voting:notification', src, locale('no_voting_status'), 'error')
        end
    end)
end)
