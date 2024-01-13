Object = nil

Citizen.CreateThread(function()
    Object = frameworkObject() 
end)

local function createPeds()
    if pedSpawned then return end
        local pedModel = Config.pedModel
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Wait(0)
        end
        for _, coords in ipairs(Config.VotingBooths) do
        local entity = CreatePed(0, pedModel, coords.x, coords.y, coords.z-1, coords.w, true, false)
        TaskStartScenarioInPlace(entity, "WORLD_HUMAN_COP_IDLES", 0, true)
        FreezeEntityPosition(entity, true)
        SetEntityInvincible(entity, true)
        SetBlockingOfNonTemporaryEvents(entity, true)

        if Config.UseTarget then
            if Config.Target == 'qb' then
            exports['qb-target']:AddTargetEntity(entity, {
                options = {
                    {
                    
                    type = "client",
                    event = "pl-voting:showuitarget",
                    icon = 'fa-solid fa-coins',
                    label = "Open Voting Menu",
                    

                },
            },
            distance = 1.5
            })
            elseif Config.Target == 'ox' then
            exports.ox_target:addLocalEntity(entity, {
                {
                    icon = 'fa-solid fa-coins',
                    label = 'Open Voting Menu',
                    onSelect = function(entity)
                        TriggerEvent('pl-voting:showuitarget')
                    end,
                    distance = 1.5
                }
            })
            end
        end
        end
    pedSpawned = true
end

local function deletePeds()
    if not pedSpawned then return end

        DeletePed(entity)
    
    pedSpawned = false
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
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
    createPeds()
end)

if not Config.UseTarget then
    CreateThread(function()
        local zones = {}
        for k, v in pairs(Config.VotingBooths) do
        zones[#zones + 1] = BoxZone:Create(vector3(v.x, v.y, v.z), 1.0, 1.0, {
            name = 'votingZone',
            heading = v.w,
        })
        end
        votingComboZone = ComboZone:Create(zones, {
        name = "votingBoothZones",
        })
        votingComboZone:onPlayerInOut(function(isPointInside, point)
        if isPointInside then
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
        else
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
        end)
    end)
end

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
            Object.Functions.TriggerCallback('voting:server:checkelectionstate', function(electionState)
                if electionState then
                    Object.Functions.TriggerCallback('voting:server:checkIfVoted', function(hasVoted)
                        if not hasVoted then
                            SendNUIMessage({
                                type = 'show_ui',  
                            })
                            SetNuiFocus(true, true)
                        else
                            TriggerEvent('custom:notification',Language["Notification"]["already_voted"], 'error')
                        end
                      end)
                else
                    TriggerEvent('custom:notification',Language["Notification"]["election_closed"], 'error')
                end
            end)
      end
      Wait(3)
  end
end)

RegisterNetEvent('pl-voting:showuitarget', function()
    Object.Functions.TriggerCallback('voting:server:checkelectionstate', function(electionState)
        if electionState then
            Object.Functions.TriggerCallback('voting:server:checkIfVoted', function(hasVoted)
            if not hasVoted then
                SendNUIMessage({
                type = 'show_ui',  
                })
                SetNuiFocus(true, true)
            else
                TriggerEvent('custom:notification',Language["Notification"]["already_voted"], 'error')
                end
            end)
        else
            TriggerEvent('custom:notification',Language["Notification"]["election_closed"], 'error')
        end
    end)
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


if Config.Debugscript then
    RegisterCommand("debugscript", function()
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
    end)
end


AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if Config.UseTarget then
    createPeds()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    deletePeds()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    deletePeds()
    PlayerData = nil
end)