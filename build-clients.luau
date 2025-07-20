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
            print(`{system:upper()} | Client File: {clientFile}`)
            local place = roblox.deserializePlace(clientFile)

            print(`{system:upper()} | Place: {place}`)
            local localReplicatedStorage = place:GetService('ReplicatedStorage')
            local clientFolder = localReplicatedStorage:FindFirstChild('Client')
            print(`{system:upper()} | Client Folder: {clientFolder}`)
            local systemFolder = clientFolder and clientFolder:FindFirstChild(system)

            if systemFolder then
                systemFolder:Clone().Parent = mainClientFolder
            else
                error(`System folder does not exist in assets build for {system} system`)
            end

            print(`{system:upper()} | Cloned {system} client successfully`)
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

for _, folder in corePlace.Client do
    folder:Clone().Parent = mainClientFolder
end

if #errors > 0 then
    error(table.concat(errors, '\n'))
end

local output = process.args[1]
local serialized = roblox.serializePlace(mainDataModel, true)

fs.writeFile(output, serialized)
print ("Built Client.rbxlx successfully")