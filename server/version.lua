if not Config.UpdateVersion then return end

Citizen.CreateThread(function()
    local resource_name = 'pl_voting'
    local current_version = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
    local version_url = 'https://raw.githubusercontent.com/pulsepk/scriptversion/main/version.json'
    PerformHttpRequest(version_url, function(errorCode, resultData, resultHeaders)
        if errorCode ~= 200 then
            print('^1Version check failed, unable to reach the server.^0')
            return
        end

        local remoteData = json.decode(resultData)
        if not remoteData or not remoteData[resource_name] then
            print('^1Version check failed, invalid data received.^0')
            return
        end

        local remote_version = remoteData[resource_name]

        if current_version < remote_version then
            print('\n^1==================================================================^0')
            print('^1' .. resource_name .. ' is outdated ('..current_version..'). Please update it to version ' .. remote_version .. '^0')
            print('^1==================================================================^0\n')
            print('^1['..resource_name..'] ^2If you encounter any issues please Join the discord https://discord.gg/c6gXmtEf3H to get support..^0')
        else
            print('^2' .. resource_name .. ' is up to date.^0')
            print('^1['..resource_name..'] ^2If you encounter any issues please Join the discord https://discord.gg/c6gXmtEf3H to get support..^0')
        end
    end, 'GET')
end)