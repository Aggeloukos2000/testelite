SpawnManager = {}

local function freezePlayer(id, freeze)
    local player = id
    SetPlayerControl(player, not freeze, false)
    local ped = GetPlayerPed(player)
    if not freeze then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end
        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end
        FreezeEntityPosition(ped, false)
        --SetCharNeverTargetted(ped, false)
        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end
        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        --SetCharNeverTargetted(ped, true)
        SetPlayerInvincible(player, true)
        --RemovePtfxFromPed(ped)
        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end

function SpawnManager.spawnPlayer(spawnIdx, cb)
    CreateThread(function()
        local spawn
        if type(spawnIdx) == 'table' then
            spawn = spawnIdx
            spawn.x = spawn.x + 0.00
            spawn.y = spawn.y + 0.00
            spawn.z = spawn.z + 0.00
            spawn.heading = spawn.heading and (spawn.heading + 0.00) or 0
        end
        if not spawn.skipFade then
            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do
                Citizen.Wait(0)
            end
        end
        if not spawn then
            Citizen.Trace("tried to spawn at an invalid spawn index\n")
            return
        end
        freezePlayer(PlayerId(), true)
        if spawn.model then
            RequestModel(spawn.model)
            while not HasModelLoaded(spawn.model) do
                RequestModel(spawn.model)
                Wait(0)
            end
            SetPlayerModel(PlayerId(), spawn.model)
            SetModelAsNoLongerNeeded(spawn.model)
            if N_0x283978a15512b2fe then
				N_0x283978a15512b2fe(PlayerPedId(), true)
            end
        end
        RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)
        local ped = PlayerPedId()
        SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false, true)
        NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, true, false)
        ClearPedTasksImmediately(ped)
        --SetEntityHealth(ped, 300) -- TODO: allow configuration of this?
        RemoveAllPedWeapons(ped) -- TODO: make configurable (V behavior?)
        ClearPlayerWantedLevel(PlayerId())
        -- why is this even a flag?
        --SetCharWillFlyThroughWindscreen(ped, false)
        -- set primary camera heading
        --SetGameCamHeading(spawn.heading)
        --CamRestoreJumpcut(GetGameCam())
        -- load the scene; streaming expects us to do it
        --ForceLoadingScreen(true)
        --loadScene(spawn.x, spawn.y, spawn.z)
        --ForceLoadingScreen(false)
        local time = GetGameTimer()
        while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
            Citizen.Wait(0)
        end
        ShutdownLoadingScreen()
        if IsScreenFadedOut() then
            DoScreenFadeIn(500)
            while not IsScreenFadedIn() do
                Citizen.Wait(0)
            end
        end
        -- and unfreeze the player
        freezePlayer(PlayerId(), false)
        TriggerEvent('playerSpawned', spawn)
        if cb then
            cb(spawn)
        end
    end)
end