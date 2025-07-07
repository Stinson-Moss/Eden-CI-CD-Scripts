return function(game, filePath)
    local Players = game:GetService('Players')
    local Workspace = game:GetService('Workspace')
    local ServerScriptService = game:GetService('ServerScriptService')
    local TextChatService = game:GetService('TextChatService')
    local SoundService = game:GetService('SoundService')
    local StarterPlayer = game:GetService('StarterPlayer')

    -- clear all scripts
    for _,v in game:GetDescendants() do
        if v:IsA("Script") then
            v:Destroy()
        end
    end
    
    for _,v in Workspace:GetDescendants() do
        if v:IsA("SpawnLocation") then
            v.Duration = 0
        end
    end

    Workspace.FallenPartsDestroyHeight = -500
    Workspace.FallHeightEnabled = true
    Workspace.FluidForces = Enum.FluidForces.Default
    Workspace.SignalBehavior = Enum.SignalBehavior.Deferred
    Workspace.TouchesUseCollisionGroups = true
    Workspace.TouchEventsUseCollisionGroups = Enum.RolloutState.Enabled
    Workspace.StreamingEnabled = false
    Workspace.Gravity = 196.2

    Players.UseStragingAnimations = false
    Players.CharacterAutoLoads = false
    Players.BanningEnabled = true
    Players.RespawnTime = 10

    StarterPlayer.CameraMaxZoomDistance = 25
    StarterPlayer.CameraMinZoomDistance = 0.5
    StarterPlayer.CameraMode = Enum.CameraMode.Classic
    StarterPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
    StarterPlayer.DevComputerCameraMovementMode = Enum.DevComputerCameraMovementMode.UserChoice
    StarterPlayer.DevTouchCameraMovementMode = Enum.DevTouchCameraMovementMode.UserChoice
    StarterPlayer.CharacterMaxSlopeAngle = 65
    StarterPlayer.CharacterWalkSpeed = 16
    StarterPlayer.CharacterJumpPower = 50
    StarterPlayer.CharacterUseJumpPower = true
    StarterPlayer.EnableMouseLockOption = true
    StarterPlayer.AutoJumpEnabled = true
    StarterPlayer.HealthDisplayDistance = 0
    StarterPlayer.NameDisplayDistance = 0

    TextChatService.ChatWindowConfiguration.Enabled = false
    TextChatService.ChatInputBarConfiguration.Enabled = true
    TextChatService.ChannelTabsConfiguration.Enabled = false
    TextChatService.BubbleChatConfiguration.Enabled = true
    TextChatService.BubbleChatConfiguration.TailVisible = false
    TextChatService.BubbleChatConfiguration.AdorneeName = 'HumanoidRootPart'

    ServerScriptService.LoadStringEnabled = false
    SoundService.RespectFilteringEnabled = true
end
