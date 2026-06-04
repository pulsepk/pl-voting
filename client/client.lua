local inZone = false

function onPlayerLoaded()
    local candidates = {}
    for _, v in pairs(Config.Candidates) do
        candidates[#candidates + 1] = { name = v.name, party = v.party }
    end
    SendNUIMessage({ type = 'updateCandidates', candidates = candidates })
end

-- Register the framework-specific player-loaded event using pl_lib detection
local fw = exports['pl_lib']:GetFramework()
if fw == 'qbox' or fw == 'qb' then
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        Wait(3000)
        onPlayerLoaded()
    end)
elseif fw == 'esx' then
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function()
        Wait(3000)
        onPlayerLoaded()
    end)
end

function onEnter()
    exports['pl_lib']:TextUIShow('[E] Vote', { position = 'left-center' })
    inZone = true
    TriggerEvent('pl-voting:showui')
end

function onExit()
    exports['pl_lib']:TextUIHide()
    inZone = false
end

CreateThread(function()
    for _, v in pairs(Config.VotingBooths) do
        lib.zones.box({
            name     = 'votingZone',
            coords   = vec3(v.x, v.y, v.z),
            size     = vec3(1.0, 1.5, 2.0),
            rotation = 55.0,
            debug    = Config.Debugpoly,
            onEnter  = onEnter,
            onExit   = onExit,
        })
    end
end)

RegisterNetEvent('pl-voting:startvoting', function()
    TriggerServerEvent('pl-voting:startelection')
end)

local function toggleNuiFrame(shouldShow)
    SetNuiFocus(shouldShow, shouldShow)
    SendNUIMessage({ action = 'setVisible', data = shouldShow })
end

RegisterNetEvent('pl-voting:showui', function()
    while true do
        if not inZone then break end
        if IsControlJustReleased(0, 38) then
            local electionState = lib.callback.await('voting:server:checkelectionstate', false)
            if electionState then
                local hasVoted = lib.callback.await('voting:server:checkIfVoted', false)
                if not hasVoted then
                    SendNUIMessage({ type = 'show_ui' })
                    SetNuiFocus(true, true)
                else
                    TriggerEvent('pl-voting:notification', locale('already_voted'), 'error')
                end
            else
                TriggerEvent('pl-voting:notification', locale('election_closed'), 'error')
            end
        end
        Wait(3)
    end
end)

RegisterNetEvent('pl-voting:ShowUiAdmin')
AddEventHandler('pl-voting:ShowUiAdmin', function()
    SendNUIMessage({ type = 'ShowUiAdmin' })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('hideFrame', function(_, cb)
    toggleNuiFrame(false)
    cb({})
end)

RegisterNUICallback('votesubmit', function(data, cb)
    TriggerServerEvent('voting:server:castVote', data)
    cb({})
end)

RegisterNUICallback('deleteRecord', function(_, cb)
    TriggerServerEvent('pl-voting:deleteRecord')
    cb({})
end)

RegisterNUICallback('startelection', function(_, cb)
    TriggerEvent('pl-voting:startvoting')
    cb({})
end)

RegisterNUICallback('resetvotes', function(_, cb)
    TriggerServerEvent('pl-voting:resetsvotes')
    cb({})
end)

RegisterNUICallback('resetSomeonevote', function(data, cb)
    TriggerServerEvent('pl-voting:resetSomeonevote', data.playerNumber)
    cb({})
end)

RegisterNUICallback('endElection', function(_, cb)
    TriggerServerEvent('pl-voting:endElection')
    cb({})
end)

RegisterNUICallback('Results', function(_, cb)
    TriggerServerEvent('pl-voting:checkresults')
    cb({})
end)

RegisterNetEvent('pl-voting:sendResults')
AddEventHandler('pl-voting:sendResults', function(results)
    local resultArray = {}
    for _, r in ipairs(results) do
        resultArray[#resultArray + 1] = { name = r.name, party = r.party, votes = r.votes }
    end
    SendNUIMessage({ type = 'result', results = resultArray })
end)

RegisterNetEvent('pl-voting:ClearVotingMenu')
AddEventHandler('pl-voting:ClearVotingMenu', function()
    onPlayerLoaded()
end)
