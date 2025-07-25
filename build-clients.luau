-- Assuming Systems/* has Client.rbxlx files. Combine them into a single Client.rbxlx file.

local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local task = require("@lune/task")
local process = require("@lune/process")

local mainDataModel = roblox.Instance.new('DataModel')
local replicatedStorage = mainDataModel:GetService('ReplicatedStorage')
local serverStorage = mainDataModel:GetService('ServerStorage')

local mainClientFolder = roblox.Instance.new('Folder')
mainClientFolder.Name = "Client"
mainClientFolder.Parent = replicatedStorage

local useXML = true
local size = 0
local clients = {}

for _, system in fs.readDir("Systems") do
    for _, file in fs.readDir(`Systems/{system}`) do
        if fs.isFile(`Systems/{system}/{file}`) then
            if file == "Client.rbxlx" then
                clients[system] = `Systems/{system}/{file}`
                size += 1
            end
        end
    end
end

local threads = size
local errors = {}

for system, client in clients do
    task.spawn(function()
        local success, errorMessage = pcall(function()
            print(`Building {system} client...`)
            print(`{system:upper()} | Client: {client}`)
            local clientFile = fs.readFile(client)
            local place = roblox.deserializePlace(clientFile)
            local localReplicatedStorage = place:GetService('ReplicatedStorage')
            local clientFolder = localReplicatedStorage:FindFirstChild('Client')

            local systemFolder = nil; do
                if clientFolder then
                    for _, folder in clientFolder:GetChildren() do
                        if folder.Name:lower() == system:lower() then
                            systemFolder = folder
                            break
                        end
                    end
                end
            end

            if systemFolder then
                systemFolder:Clone().Parent = mainClientFolder
                print(`{system:upper()} | Cloned {system} client successfully`)
            else
                error(`Assets folder does not exist in client build for {system} system`)
            end

        end)

        if not success then
            table.insert(errors, `ERROR: {system} client build failed: {errorMessage}`)
        end

        threads -= 1
    end)
end

while threads > 0 do
    task.wait(1)
end

-- Core/Client.rbxlx
local coreFile = fs.readFile("Core/Client.rbxlx")
local corePlace = roblox.deserializePlace(coreFile)

corePlace.ServerStorage.Tools:Clone().Parent = serverStorage

for _, folder in corePlace.ReplicatedStorage.Client:GetChildren() do
    folder:Clone().Parent = mainClientFolder
end

if #errors > 0 then
    error(table.concat(errors, '\n'))
end

local output = process.args[1]
local serialized = roblox.serializePlace(mainDataModel, useXML)

fs.writeFile(output, serialized)
print ("Built Client.rbxlx successfully")