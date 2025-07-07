local roblox = require("@lune/roblox")

return function(game)
    local function getTarget(game, path)
        local paths = path:split('.')
    
        local current = game
        for _, v in ipairs(paths) do
            current = current[v]
        end
    
        return current
    end
    
    local function clearRefs(game, instance)
        local attributes = instance:GetAttributes()
    
        for name, value in attributes do
            local parts = name:split('_')
            
            if parts[1] == "REF" then
                local success, target = pcall(getTarget, game, value)
                
                if success then
                    instance[parts[2]] = target
                end

                instance:SetAttribute(name, nil)
            end

        end
    end
    
    local function cleanTeamColors(game)
        local colorConversion = {
            -- There are 2 gold colors in the game, so we need to convert them to the correct one
            ["Gold"] = 333
        }
        for _,team in game:GetService('Teams'):GetChildren() do 
            team.TeamColor = roblox.BrickColor.new(colorConversion[team.TeamColor.Name] or team.TeamColor.Name)
        end
    end
    
    for _,descendant in game:GetDescendants() do
        clearRefs(game, descendant)
    end
    
    cleanTeamColors(game)
end

