local QBCore = exports['qb-core']:GetCoreObject()

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

RegisterNetEvent('pl-voting:startvoting',function()
    local after = {}
    for k, v in pairs(Config.Candidates) do
      after[#after + 1] = {
          name = v.name,
      }
    end
    SendNUIMessage({
    type = 'updateCandidates',
    candidates = after
    })
    local zones = {}
    for k, v in pairs(Config.VotingBooths) do
        zones[#zones + 1] = BoxZone:Create(vector3(v.x, v.y, v.z), 1.0, 1.0, {
            name = 'votingZone',
            heading = v.w,
            debugPoly = true
        })
    end
    votingComboZone = ComboZone:Create(zones, {
        name = "votingBoothZones",
    })
    votingComboZone:onPlayerInOut(function(isPointInside, point)
        if isPointInside then
            exports['qb-core']:DrawText('[E] Vote', 'left')
            inZone = true
            TriggerEvent('pl-voting:showui')
        else
            exports['qb-core']:HideText()
            inZone = false
        end
    end)
end)

RegisterNetEvent('pl-voting:showui', function()
  while true do
      if not inZone then break end
      if IsControlJustReleased(0, 38) then
          QBCore.Functions.TriggerCallback('voting:server:checkIfVoted', function(hasVoted)
              if not hasVoted then
                  SendNUIMessage({
                      type = 'show_ui',  
                  })
                  SetNuiFocus(true, true)
              else
                  QBCore.Functions.Notify('You have already voted.', 'error')
              end
          end)
      end
      Wait(3)
  end
end)


RegisterCommand('uiadmin', function()
  TriggerEvent("ShowUiAdmin")
  SetNuiFocus(true,true)
end, false)

AddEventHandler("ShowUiAdmin", function()
  SendNUIMessage({
      type = "ShowUiAdmin"
  })
end)


AddEventHandler("showUiEvent", function()
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

RegisterNUICallback('endElection',function(data,cb)
  
end)

RegisterNUICallback('Results',function(data,cb)
  TriggerServerEvent('pl-voting:checkresults', function()
  end)
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


