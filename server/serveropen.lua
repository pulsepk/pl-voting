
local Webhook = "https://discord.com/api/webhooks/1167391436862406676/_QzMxadzP-1oFAU6OpRJexjsa8mAofhe-eLKAyYjYcvJ48WHbMNhse5Gjutw9ufT2bgE"

Log = function(message)
    if not Config.Log then

        return
    end
    PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({
        username = 'PL Election',
        embeds = {{
            ["color"] = 16711680,
            ["author"] = {
                ["name"] = "PL Logs",
                ["icon_url"] = "https://cdn.discordapp.com/attachments/1167388112251535441/1198745389856198786/pulse-scriptslogo.webp"
            },
            ["title"] = 'Election Logs',
            ["description"] = message
        }}, 
        avatar_url = 'https://cdn.discordapp.com/attachments/1167388112251535441/1198745389856198786/pulse-scriptslogo.webp'
    }), {
        ['Content-Type'] = 'application/json'
    })
end

RegisterNetEvent('pl-voting:chatAnnouncement')
AddEventHandler('pl-voting:chatAnnouncement',function(msg)
    TriggerClientEvent('chat:addMessage', -1, {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Announcement", msg}
    })
end)

lib.callback.register('pl-voting:checkplayergroup', function(source)
    
    if GetResourceState('qb-core') == 'started' then
        for license, _ in pairs(Config.AdminLicense) do
	    	if getPlayerLicense(source) == license then
	    		return true 
	    	end
	    end
	    return false
    else
        local xPlayer = GetPlayerAdmin(source)
        for k,v in ipairs(Config.Permissions) do
	    	if xPlayer.getGroup() == v then 
	    		return true 
	    	end
	    end
	    return false
    end
end)

RegisterNetEvent('voting:server:castVote', function(data)
    local src = source
    local cid = getPlayerIdentifier(src)
    if GetResourceState('qb-core') == 'started' then
      MySQL.update('UPDATE players SET hasvoted = ? WHERE citizenid = ?', {1, cid})
    else
      MySQL.update('UPDATE users SET hasvoted = ? WHERE identifier = ?', {1, cid})
    end
    local result = MySQL.Sync.fetchAll('SELECT votes FROM election WHERE name = ?', { json.encode(data.vote) })
    if not result[1] then
        MySQL.insert('INSERT INTO election (name, party, votes) VALUES (?, ?, ?)',{ json.encode(data.vote), json.encode(data.party), 1 })
        TriggerClientEvent('pl-voting:notification', src, locale("successfully_voted"), 'success')
        Log('**Name:** '..getPlayerName(src)..'\n**Identifier:** '..cid..' \n has voted for'.. json.encode(data.vote) ..'')
    else
        MySQL.update("UPDATE election SET votes=? WHERE name=?;", { result[1].votes+1, json.encode(data.vote) })
        TriggerClientEvent('pl-voting:notification', src, locale("successfully_voted"), 'success')
        Log('**Name:** '..getPlayerName(src)..'\n**Identifier:** '..cid..' \n has voted for'.. json.encode(data.vote) ..'')
    end
end)
  
  
  RegisterNetEvent('pl-voting:resetsvotes', function()
    local src = source
    local Identifier = getPlayerLicense(src)
    if GetResourceState('qb-core') == 'started' then
      MySQL.Async.execute('UPDATE players SET hasvoted = 0 WHERE hasvoted = 1', {}, function(rowsChanged)
          TriggerClientEvent('pl-voting:notification', src, locale("reset_player_status"), 'success')
          Log('All players voting status has been reset successfully by '.. getPlayerName(src)..'\n**Identifier:**'..Identifier..'')
      end)
    else
      MySQL.Async.execute('UPDATE users SET hasvoted = 0 WHERE hasvoted = 1', {}, function(rowsChanged)
        TriggerClientEvent('pl-voting:notification', src, locale("reset_player_status"), 'success')
        Log('All players voting status has been reset successfully by '.. getPlayerName(src)..'\n**Identifier:**'..Identifier..'')
      end)
    end
  end)
  
  
RegisterNetEvent('pl-voting:resetSomeonevote', function(playerId)
    local src = source
    local playerID = tonumber(playerId)
    local player = getPlayerIdentifier(playerID)
    if player then
      local cid = player
      if GetResourceState('qb-core') == 'started' then
      MySQL.Async.execute('UPDATE players SET hasvoted = 0 WHERE citizenid = @citizenid AND hasvoted = 1', {
          ['@citizenid'] = cid
      }, function(rowsChanged)
          if rowsChanged > 0 then
              TriggerClientEvent('pl-voting:notification', src, locale("player_voting_status"), 'success')
              TriggerClientEvent('pl-voting:notification', playerID, locale("your_voting_status"), 'success')
              Log('**Name:**'..getPlayerName(src)..'\n has reset vote of ' ..getPlayerName(playerID) .. '')
          else
              TriggerClientEvent('pl-voting:notification', src, locale("no_voting_status"), 'error')
          end
      end)
      else
        MySQL.Async.execute('UPDATE users SET hasvoted = 0 WHERE identifier = @identifier AND hasvoted = 1', {
          ['@identifier'] = cid
      }, function(rowsChanged)
          if rowsChanged > 0 then
              TriggerClientEvent('pl-voting:notification', src, locale("player_voting_status"), 'success')
              TriggerClientEvent('pl-voting:notification', playerID, locale("your_voting_status"), 'success')
              Log('**Name:**'..getPlayerName(src)..'\n has reset vote of ' ..getPlayerName(playerID) .. '')
          else
              TriggerClientEvent('pl-voting:notification', src, locale("no_voting_status"), 'error')
          end
      end)
      end
    else
        TriggerClientEvent('pl-voting:notification', src, locale("couldnot_find_id"), 'error')
    end
end)

