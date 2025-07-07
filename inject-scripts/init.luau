local function getInstance(game, path)
    local paths = path:split('.')

    local current = game
    for _,segment in paths do
        current = current[segment]
    end

    return current
end

local function injectScripts(scriptGame, game)
    local services = {
        "Teams",
        "ServerStorage",
        "ReplicatedFirst",
        "ReplicatedStorage",
        "StarterPlayer.StarterPlayerScripts",
        "StarterPlayer.StarterCharacterScripts",
    }

    for _,service in services do
        local serviceInstance = getInstance(game, service)
        local scriptServiceInstance = getInstance(scriptGame, service)

        for _, child in scriptServiceInstance:GetChildren() do
            local clone = child:Clone()
            clone.Parent = serviceInstance
        end
    end

end

return injectScripts