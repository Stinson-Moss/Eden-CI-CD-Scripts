return function(game)
    local CustomizeManager = game:GetService('ReplicatedStorage').Managers.CustomizeManager
   -- Initialize all the object values to the right model
	-- Set Clothing object values to corresponding outfit values under Appearance
	local appearance = game.ReplicatedStorage.Client.Appearance.Models.Outfits
	for _, value in pairs(CustomizeManager.Clothing:GetDescendants()) do
		if value:IsA('ObjectValue') then
			local folder = appearance:FindFirstChild(value.Parent.Name)
			local object = folder and folder:FindFirstChild(value.Name)

			if object then
				value.Value = object
			end
		end
	end

	-- Set Tool object values to corresponding outfit values under ToolData of ToolManager
	local toolModels = game.ReplicatedStorage.Client.ToolManager.Models.Tools

	for _,value in pairs(CustomizeManager.Tools:GetDescendants()) do
		if value:IsA('ObjectValue') then
			local folder = toolModels:FindFirstChild(value.Parent.Name)
			local object = folder and folder:FindFirstChild(value.Name)

			if object then
				value.Value = object
			end
		end
	end 
end