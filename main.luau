local process = require("@lune/process")
local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local task = require("@lune/task")

local injectObjects = require('./inject-objects')
local cleanObjects = require('./clean-objects')
local configurePlace = require('./config-place')
local cleanClient = require('./clean-client')

local scriptInjectionsPath = process.args[1]
local clientBuildPath = process.args[2]
local places = fs.readDir(process.args[3])

print (process.args)

local clientBuild = fs.readFile(clientBuildPath)
local scriptInjections = fs.readFile(scriptInjectionsPath)

local clientBuildPlace = roblox.deserializePlace(clientBuild)
local scriptInjectionsPlace = roblox.deserializePlace(scriptInjections)

cleanClient(clientBuildPlace)
cleanObjects(scriptInjectionsPlace)

local threads = #places
local successes = 0
for _, placePath in places do
    task.spawn(function()
        local placeFile = fs.readFile(placePath)
        local place = roblox.deserializePlace(placeFile)

        local success = pcall(function()
            configurePlace(place)
            injectObjects(scriptInjectionsPlace, place)
            injectObjects(clientBuildPlace, place)

            fs.writeFile(placePath, roblox.serializePlace(place))
        end)

        if success then
            successes += 1
        end

        threads -= 1
    end)
end

while threads > 0 do
    task.wait(1)
end

assert(successes == #places, "Not all places were processed successfully")
print(`Processed {#places} place files successfully`)