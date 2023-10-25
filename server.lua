local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('voting:server:checkelectionstate', function(source, cb)
  local cid = QBCore.Functions.GetPlayer(source).PlayerData.citizenid
  MySQL.Async.fetchScalar('SELECT state FROM electionstate', {}, function(electionState)
    if electionState then
      cb(true)
    else
      cb(false)
    end
  end)
end)


QBCore.Functions.CreateCallback('voting:server:checkIfVoted', function(source, cb)
  local cid = QBCore.Functions.GetPlayer(source).PlayerData.citizenid
  local hasVoted = MySQL.Sync.fetchScalar('SELECT hasvoted FROM players WHERE citizenid = ? LIMIT 1', {cid})
  if hasVoted == 1 then
    cb(true)
  else
    cb(false)
  end
end)

RegisterNetEvent('voting:server:castVote', function(data)
  local src = source
  local cid = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
  MySQL.update('UPDATE players SET hasvoted = ? WHERE citizenid = ?', {1, cid})
  local result = MySQL.Sync.fetchAll('SELECT votes FROM election WHERE name = ?', { json.encode(data.vote) })
  if not result[1] then
      MySQL.insert('INSERT INTO election (name, party, votes) VALUES (?, ?, ?)',{ json.encode(data.vote), json.encode(data.party), 1 })
      TriggerClientEvent('custom:notification', src, "You have successfully Voted", 'success')
  else
      MySQL.update("UPDATE election SET votes=? WHERE name=?;", { result[1].votes+1, json.encode(data.vote) })
  end
end)

RegisterNetEvent('pl-voting:checkresults', function()
  local src = source
  MySQL.Async.fetchAll('SELECT name, party, votes FROM election', {}, function(results)
    if results and #results > 0 then
      TriggerClientEvent('pl-voting:sendResults', src, results)
    else
      TriggerClientEvent('custom:notification', src, "There is nothing to display", 'error')
    end
  end)
end)

RegisterNetEvent('pl-voting:deleteRecord', function()
  local src = source
  MySQL.Async.execute('DELETE FROM election', {}, function(rowsChanged)
    if rowsChanged then
    TriggerClientEvent('custom:notification', src, "All records of previous Election has been deleted successfully", 'success')
    end
  end)
end)

RegisterNetEvent('pl-voting:resetsvotes', function()
  local src = source
  MySQL.Async.execute('UPDATE players SET hasvoted = 0 WHERE hasvoted = 1', {}, function(rowsChanged)
    TriggerClientEvent('custom:notification', src, "All players voting status has been reset successfully", 'success')
  end)
end)

RegisterNetEvent('pl-voting:endElection', function()
  local src = source
  MySQL.Async.execute('UPDATE electionstate SET state = 0 WHERE state = 1', {}, function(rowsChanged)
    TriggerClientEvent('custom:notification', src, "You have ended the election", 'success')
  end)
  if Config.ServerAnnouncement then
    TriggerEvent('custom:chatAnnouncement', 'The election are over now. The results will be announced soon.')
  end
end)

RegisterNetEvent('pl-voting:startelection', function()
  local src = source
  MySQL.Async.execute('UPDATE electionstate SET state = 1 WHERE state = 0', {}, function(rowsChanged)
    TriggerClientEvent('custom:notification', src, "You have started the election", 'success')
  end)
  if Config.ServerAnnouncement then
    TriggerEvent('custom:chatAnnouncement', 'The election is started! Head over to City Hall to cast your vote.')
  end
end)

RegisterNetEvent('custom:chatAnnouncement')
AddEventHandler('custom:chatAnnouncement',function(msg)
    TriggerClientEvent('chat:addMessage', -1, {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Announcement", msg}
    })
end)
