local process = require("@lune/process")
local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local task = require("@lune/task")

local injectScripts = require('./inject-scripts')
local cleanObjects = require('./clean-objects')
local configurePlace = require('./config-place')

local scriptInjectionsPath = process.args[1]
local scriptInjections = fs.readFile(scriptInjectionsPath)
local places = fs.readDir(process.args[2])

local scriptInjectionsPlace = roblox.deserializePlace(scriptInjections)

for _, placePath in places do
    task.spawn(function()
        local placeFile = fs.readFile(placePath)
        local place = roblox.deserializePlace(placeFile)

        configurePlace(place)
        cleanObjects(scriptInjectionsPlace)
        injectScripts(scriptInjectionsPlace, place)

        fs.writeFile(placePath, roblox.serializePlace(place))
    end)
end

print(`Processed {#places} place files successfully`)