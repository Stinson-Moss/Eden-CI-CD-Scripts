local function getInstance(game, path)
    local paths = path:split('.')

    local current = game
    for index,segment in ipairs(paths) do
        if current == nil then return nil end
        if index == 1 then
            current = game:GetService(segment)
        else
            current = current:FindFirstChild(segment)
        end
    end

    return current
end

local function injectObjects(scriptGame, game)
    local services = {
        "Teams",
        "ServerStorage",
        "ReplicatedFirst",
        "ServerScriptService",
        "ReplicatedStorage",
        "StarterPlayer.StarterPlayerScripts",
        "StarterPlayer.StarterCharacterScripts",
    }
    
    for _,service in ipairs(services) do
        local serviceInstance = getInstance(game, service)
        local scriptServiceInstance = getInstance(scriptGame, service)

        if not serviceInstance then
            continue
        end

        if not scriptServiceInstance then
            continue
        end

        for _, child in scriptServiceInstance:GetChildren() do
            local clone = child:Clone()
            clone.Parent = serviceInstance
        end
    end

end

return injectObjects