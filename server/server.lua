local resourceName = 'pl-voting'
lib.callback.register('voting:server:checkelectionstate', function()
  local data = LoadResourceFile(GetCurrentResourceName(), '/electionstate.json') 
  local jsonData = json.decode(data)
  if jsonData then
    local electionState = jsonData.state
    return electionState
  else
    print('Failed to load JSON data')
    return false
  end
end)
lib.callback.register('voting:server:checkIfVoted', function(source)
  local cid = getPlayerIdentifier(source)
  local hasVoted
  
  if GetResourceState('qb-core') == 'started' then
      hasVoted = MySQL.Sync.fetchScalar('SELECT hasvoted FROM players WHERE citizenid = ? LIMIT 1', {cid})
  else
      hasVoted = MySQL.Sync.fetchScalar('SELECT hasvoted FROM users WHERE identifier = ? LIMIT 1', {cid})
  end
  
  if hasVoted == 1 then
      return true
  else
      return false
  end
end)


RegisterNetEvent('pl-voting:checkresults', function()
  local src = source
  MySQL.Async.fetchAll('SELECT name, party, votes FROM election', {}, function(results)
    if results and #results > 0 then
      TriggerClientEvent('pl-voting:sendResults', src, results)
    else
      TriggerClientEvent('pl-voting:notification', src, locale("nothing_display"), 'error')
    end
  end)
end)

RegisterNetEvent('pl-voting:deleteRecord', function()
  local src = source
  local Identifier = getPlayerLicense(src)
  MySQL.Async.execute('DELETE FROM election', {}, function(rowsChanged)
      if rowsChanged then
          TriggerClientEvent('pl-voting:notification', src, locale("election_record"), 'success')
          Log('All previous Election records have been deleted by '.. getPlayerName(src)..'\n**Identifier:**'..Identifier..'')
      end
  end)
end)


RegisterNetEvent('pl-voting:endElection', function()
  local src = source
  local Identifier = getPlayerLicense(src)
  local file = LoadResourceFile(GetCurrentResourceName(), '/electionstate.json')
  local data = json.decode(file)
  data.state = false
  SaveResourceFile(GetCurrentResourceName(), '/electionstate.json', json.encode(data), -1)
  TriggerClientEvent('pl-voting:notification', src, locale('you_ended_election'), 'success')
  Log('The elections has been Ended by ' ..getPlayerName(src) .. '\n**Identifier:** '..Identifier..'')

  if Config.ServerAnnouncement then
      TriggerEvent('pl-voting:chatAnnouncement', locale("election_over"))
  end
end)


RegisterNetEvent('pl-voting:startelection', function()
  local src = source
  local Identifier = getPlayerLicense(src)
  local file = LoadResourceFile(GetCurrentResourceName(), '/electionstate.json')
  local data = json.decode(file)
  data.state = true
  SaveResourceFile(GetCurrentResourceName(), '/electionstate.json', json.encode(data), -1)
  TriggerClientEvent('pl-voting:notification', src, "You have started the election", 'success')
  Log('The elections has been Started by ' ..getPlayerName(src) .. '\n**Identifier:**'..Identifier..'')

  if Config.ServerAnnouncement then
      TriggerEvent('pl-voting:chatAnnouncement', locale("election_started"))
  end
end)

local WaterMark = function()
    SetTimeout(1500, function()
        print('^1['..resourceName..'] ^2Thank you for Downloading the Script^0')
        print('^1['..resourceName..'] ^2If you encounter any issues please Join the discord https://discord.gg/c6gXmtEf3H to get support..^0')
        print('^1['..resourceName..'] ^2Enjoy a secret 20% OFF any script of your choice on https://pulsescripts.tebex.io/freescript^0')
        print('^1['..resourceName..'] ^2Using the coupon code: SPECIAL20 (one-time use coupon, choose wisely)^0')
    
    end)
end

if Config.WaterMark then
    WaterMark()
end


AddEventHandler('onServerResourceStart', function(resourceName)
  Wait(500)
  TriggerClientEvent('pl-voting:ClearVotingMenu',-1)
  local file = LoadResourceFile(GetCurrentResourceName(), '/electionstate.json')
  local data = json.decode(file)
  data.state = false
  SaveResourceFile(GetCurrentResourceName(), '/electionstate.json', json.encode(data), -1)
end)


