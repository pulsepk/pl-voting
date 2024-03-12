
function onPlayerLoaded()
    local after = {}
    for k, v in pairs(Config.Candidates) do
        after[#after + 1] = {
            name = v.name,
            party = v.party
        }
    end

    SendNUIMessage({
        type = 'updateCandidates',
        candidates = after
    })
end

function onEnter(self)
    if Config.DrawText == 'qb' then
        exports['qb-core']:DrawText('[E] Vote', 'left')
        inZone = true
        TriggerEvent('pl-voting:showui')
    elseif Config.DrawText == 'cd' then
        TriggerEvent('cd_drawtextui:ShowUI', 'show', '[E] Vote')   
        inZone = true
        TriggerEvent('pl-voting:showui')
    elseif Config.DrawText == 'ox' then
        lib.showTextUI('[E] Vote', {
            position = "left",
            style = {
                borderRadius = 0,
                backgroundColor = '#000000',
                color = 'white'
            }
        })
        inZone = true
        TriggerEvent('pl-voting:showui')
    end
end
 
function onExit(self)
    if Config.DrawText == 'qb' then
        exports['qb-core']:HideText()
        inZone = false
    elseif Config.DrawText == 'cd' then
        TriggerEvent('cd_drawtextui:ShowUI', 'show', '[E] Vote')   
        inZone = false
    elseif Config.DrawText == 'ox' then
        lib.hideTextUI()
        inZone = false
    end
end


CreateThread(function()
        local zones = {}
        for k, v in pairs(Config.VotingBooths) do
        zones[#zones + 1] = lib.zones.box({
                name = "votingZone",
                coords = vec3(v.x, v.y, v.z),
                size = vec3(1.0, 1.5, 2.0),
                rotation = 55.0,
                debug = Config.Debugpoly,
                onEnter = onEnter,
                onExit = onExit
                
        })   
    end
end)

RegisterNetEvent('pl-voting:startvoting',function()
    TriggerServerEvent('pl-voting:startelection')
end)

function SendReactMessage(action, data)
    SendNUIMessage({
      action = action,
      data = data
    })
end

local function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', shouldShow)
end

RegisterNetEvent('pl-voting:showui', function()
  while true do
      if not inZone then break end
      if IsControlJustReleased(0, 38) then
            local electionState = lib.callback.await('voting:server:checkelectionstate', false)
                if electionState then
                    local hasVoted = lib.callback.await('voting:server:checkIfVoted', false)
                        if not hasVoted then
                            SendNUIMessage({
                                type = 'show_ui',  
                            })
                            SetNuiFocus(true, true)
                        else
                            TriggerEvent('pl-voting:notification',locale("already_voted"), 'error')
                        end
                else
                    TriggerEvent('pl-voting:notification',locale("election_closed"), 'error')
                end
      end
      Wait(3)
  end
end)


RegisterNetEvent('pl-voting:ShowUiAdmin')
AddEventHandler('pl-voting:ShowUiAdmin', function()
  SendNUIMessage({
      type = "ShowUiAdmin"
  })
  SetNuiFocus(true,true)
end)

RegisterNetEvent('showUiEvent')
AddEventHandler('showUiEvent', function()
    SendNUIMessage({
        type = "show_ui"
    })
end)

RegisterNUICallback('hideFrame', function(data, cb)
  toggleNuiFrame(false)
end)


RegisterNUICallback('votesubmit',function(data,cb)
    TriggerServerEvent('voting:server:castVote', data)
end)

RegisterNUICallback('deleteRecord',function(data,cb)
  TriggerServerEvent('pl-voting:deleteRecord', data)
end)

RegisterNUICallback('startelection',function(data,cb)
  TriggerEvent('pl-voting:startvoting')
end)

RegisterNUICallback('resetvotes',function(data,cb)
  TriggerServerEvent('pl-voting:resetsvotes')
end)

RegisterNUICallback('resetSomeonevote',function(data,cb)
    local playerId = data.playerNumber
    TriggerServerEvent('pl-voting:resetSomeonevote', playerId)
end)

RegisterNUICallback('endElection',function(data,cb)
    TriggerServerEvent('pl-voting:endElection')
end)

RegisterNUICallback('Results',function(data,cb)
  TriggerServerEvent('pl-voting:checkresults')
end)

RegisterNetEvent('pl-voting:sendResults')
AddEventHandler('pl-voting:sendResults', function(results)
    local resultArray = {} -- Create an array to store results
    for _, result in ipairs(results) do
        local name = result.name
        local party = result.party
        local votes = result.votes

        local resultObject = {
            name = name,
            party = party,
            votes = votes
        }
        table.insert(resultArray, resultObject) -- Add the result to the array
    end
        SendNUIMessage({
            type = 'result',
            results = resultArray -- Send the array of results
        })
end)

RegisterNetEvent('pl-voting:ClearVotingMenu')
AddEventHandler('pl-voting:ClearVotingMenu',function()
	onPlayerLoaded()
end)
