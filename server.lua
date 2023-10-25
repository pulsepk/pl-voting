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
  local _s = source
  local cid = QBCore.Functions.GetPlayer(_s).PlayerData.citizenid
  MySQL.update('UPDATE players SET hasvoted = ? WHERE citizenid = ?', {1, cid})
  local result = MySQL.Sync.fetchAll('SELECT votes FROM election WHERE name = ?', { json.encode(data.vote) })

  if not result[1] then
      MySQL.insert('INSERT INTO election (name, party, votes) VALUES (?, ?, ?)',{ json.encode(data.vote), "PTI", 1 })
  else
      MySQL.update("UPDATE election SET votes=? WHERE name=?;", { result[1].votes+1, json.encode(data.vote) })
  end
end)

RegisterNetEvent('pl-voting:checkresults', function(data)
  MySQL.Async.fetchAll('SELECT name, party, votes FROM election', {}, function(results)
    if results and #results > 0 then
      TriggerClientEvent('pl-voting:sendResults', -1, results)
    end
  end)
end)

RegisterNetEvent('pl-voting:deleteRecord', function(data)
  MySQL.Async.execute('DELETE FROM election', {}, function(rowsChanged)
  end)
end)

RegisterNetEvent('pl-voting:resetsvotes', function(data)
  MySQL.Async.execute('UPDATE players SET hasvoted = 0 WHERE hasvoted = 1', {}, function(rowsChanged)
  end)
end)

RegisterNetEvent('pl-voting:endElection', function(data)
  MySQL.Async.execute('UPDATE electionstate SET state = 0 WHERE state = 1', {}, function(rowsChanged)
  end)
end)

RegisterNetEvent('pl-voting:startelection', function(data)
  MySQL.Async.execute('UPDATE electionstate SET state = 1 WHERE state = 0', {}, function(rowsChanged)
  end)
end)

QBCore.Commands.Add("checkvotestest", 'Check votes', {}, false, function(source)
	local src = source
    local result = MySQL.Sync.fetchAll('SELECT * FROM election')
    
    local menu = {
        {
            header = "Candidates",
            isMenuHeader = true
        }
    }

    for k, v in pairs(result) do
        menu[#menu+1] = {
            header = v.name..' - '..v.party,
            txt = 'Votes: '..v.votes,
        }
    end

    TriggerClientEvent('qb-menu:client:openMenu', source, menu)
end, "admin")
