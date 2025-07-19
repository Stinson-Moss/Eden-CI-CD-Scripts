--[[
 This script checks the Client build for:
 - Any script. This should not have any scripts.

]]


return function(clientPlace)
    for _, child in clientPlace:GetDescendants() do
        if child:IsA('LuaSourceContainer') then
            child:Destroy()
        end
    end
end

