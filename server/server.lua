Object = nil

Citizen.CreateThread(function()
  Object = frameworkObject()
  if Config.Framework == "qb" then
    Object.Functions.CreateCallback('voting:server:checkelectionstate', function(source, cb)
      local cid = Object.Functions.GetPlayer(source).PlayerData.citizenid
      MySQL.Async.fetchScalar('SELECT state FROM electionstate', {}, function(electionState)
        if electionState then
          cb(true)
        else
          cb(false)
        end
      end)
    end)

    Object.Functions.CreateCallback('voting:server:checkIfVoted', function(source, cb)
      local cid = Object.Functions.GetPlayer(source).PlayerData.citizenid
      local hasVoted = MySQL.Sync.fetchScalar('SELECT hasvoted FROM players WHERE citizenid = ? LIMIT 1', {cid})
      if hasVoted == 1 then
        cb(true)
      else
        cb(false)
      end
    end)
    
    Object.Commands.Add(Config.MenuCommand, 'Open Election Management', {}, false, function(source)
      TriggerClientEvent('pl-voting:ShowUiAdmin', source)
    end, 'admin')
  end
end)



RegisterNetEvent('voting:server:castVote', function(data)
  local src = source
  local cid = Object.Functions.GetPlayer(src).PlayerData.citizenid
  MySQL.update('UPDATE players SET hasvoted = ? WHERE citizenid = ?', {1, cid})
  local result = MySQL.Sync.fetchAll('SELECT votes FROM election WHERE name = ?', { json.encode(data.vote) })
  if not result[1] then
      MySQL.insert('INSERT INTO election (name, party, votes) VALUES (?, ?, ?)',{ json.encode(data.vote), json.encode(data.party), 1 })
      TriggerClientEvent('custom:notification', src, Language["Notification"]["successfully_voted"], 'success')
      local logMessage = GetPlayerName(src) .. ' has voted for ' .. json.encode(data.vote)
      TriggerEvent('custom:sendToDiscord',logMessage) 
  else
      MySQL.update("UPDATE election SET votes=? WHERE name=?;", { result[1].votes+1, json.encode(data.vote) })
      TriggerClientEvent('custom:notification', src, Language["Notification"]["successfully_voted"], 'success')
      local logMessage = GetPlayerName(src) .. ' has voted for ' .. json.encode(data.vote)
      TriggerEvent('custom:sendToDiscord',logMessage)
  end
end)

RegisterNetEvent('pl-voting:checkresults', function()
  local src = source
  MySQL.Async.fetchAll('SELECT name, party, votes FROM election', {}, function(results)
    if results and #results > 0 then
      TriggerClientEvent('pl-voting:sendResults', src, results)
    else
      TriggerClientEvent('custom:notification', src, Language["Notification"]["nothing_display"], 'error')
    end
  end)
end)

RegisterNetEvent('pl-voting:deleteRecord', function()
  local src = source
  MySQL.Async.execute('DELETE FROM election', {}, function(rowsChanged)
      if rowsChanged then
          TriggerClientEvent('custom:notification', src, Language["Notification"]["election_record"], 'success')
          local logMessage = 'All previous Election records have been deleted by ' .. GetPlayerName(src)
          TriggerEvent('custom:sendToDiscord',logMessage)
      end
  end)
end)

RegisterNetEvent('pl-voting:resetsvotes', function()
  local src = source
  MySQL.Async.execute('UPDATE players SET hasvoted = 0 WHERE hasvoted = 1', {}, function(rowsChanged)
      TriggerClientEvent('custom:notification', src, Language["Notification"]["reset_player_status"], 'success')
      local logMessage = 'All players voting status has been reset successfully by ' .. GetPlayerName(src)
      TriggerEvent('custom:sendToDiscord',logMessage)
  end)
end)


RegisterNetEvent('pl-voting:resetSomeonevote', function(playerId)
  local src = source
  local playerID = tonumber(playerId)

  local player = Object.Functions.GetPlayer(playerID)
  if player and player.PlayerData and player.PlayerData.citizenid then
      local cid = player.PlayerData.citizenid
      MySQL.Async.execute('UPDATE players SET hasvoted = 0 WHERE citizenid = @citizenid AND hasvoted = 1', {
          ['@citizenid'] = cid
      }, function(rowsChanged)
          if rowsChanged > 0 then
              TriggerClientEvent('custom:notification', src, Language["Notification"]["player_voting_status"], 'success')
              TriggerClientEvent('custom:notification', playerID, Language["Notification"]["your_voting_status"], 'success')
              local logMessage = GetPlayerName(src)..'has reset vote of' GetPlayerName(playerID)
              TriggerEvent('custom:sendToDiscord',logMessage)
          else
              TriggerClientEvent('custom:notification', src, Language["Notification"]["no_voting_status"], 'error')
          end
      end)
  else
      TriggerClientEvent('custom:notification', src, Language["Notification"]["couldnot_find_id"], 'error')
  end
end)


RegisterNetEvent('pl-voting:endElection', function()
  local src = source
  MySQL.Async.execute('UPDATE electionstate SET state = 0 WHERE state = 1', {}, function(rowsChanged)
    TriggerClientEvent('custom:notification', src, Language["Notification"]["you_ended_election"], 'success')
    local logMessage = 'The elections has been Ended by' ..GetPlayerName(src)
    TriggerEvent('custom:sendToDiscord',logMessage)
  end)
  if Config.ServerAnnouncement then
    TriggerEvent('custom:chatAnnouncement', Language["ChatAnnouncement"]["election_over"])
  end
end)

RegisterNetEvent('pl-voting:startelection', function()
  local src = source
  MySQL.Async.execute('UPDATE electionstate SET state = 1 WHERE state = 0', {}, function(rowsChanged)
    TriggerClientEvent('custom:notification', src, "You have started the election", 'success')
    local logMessage = 'The elections has been Started by' ..GetPlayerName(src)
    TriggerEvent('custom:sendToDiscord',logMessage)
  end)
  if Config.ServerAnnouncement then
    TriggerEvent('custom:chatAnnouncement', Language["ChatAnnouncement"]["election_started"])
  end
end)
function CheckScriptVersion()
  local scriptVersion = '1.0.0'
  local latestVersion = nil

  PerformHttpRequest('https://api.github.com/repos/pulsepk/pl-voting-version/releases/latest', function(statusCode, data, headers)
      if statusCode == 200 then
          local release = json.decode(data)
          if release and release.tag_name then
              latestVersion = release.tag_name
          end
      end

      if latestVersion then
          if scriptVersion == latestVersion then
              print('Your script is up to date (v' .. scriptVersion .. ')')
          else
              print('New version available! Your version: v' .. scriptVersion .. ', Latest version: v' .. latestVersion)
          end
      else
          print('Failed to check for updates.')
      end
  end, 'GET', '', { ['User-Agent'] = 'YourServerName' })
end


AddEventHandler('onServerResourceStart', function(resourceName)
  if Config.UpdateVersion then
  if resourceName == GetCurrentResourceName() then
      CheckScriptVersion()
  end
  end
end)


