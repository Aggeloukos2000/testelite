-- Last spectate location stored in a vec3
local lastSpectateLocation
-- Spectated ped
local storedTargetPed
-- Spectated player's client ID
local storedTargetPlayerId
InfoDataSpectate1 = {}

local PlayersAbleSpectate = {}
local ActualIndex = 0
local IsAbleToSpectate = false

local function InstructionalButton(controlButton, text)
    ScaleformMovieMethodAddParamPlayerNameString(controlButton)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

local InTimeoutSpec = false

--- Called every 50 frames in SpectateMode to determine whether or not to recreate the GamerTag
local function createGamerTagInfo()
    if storedGameTag and IsMpGamerTagActive(storedGameTag) then return end
    local nameTag = ('[%d] %s'):format(GetPlayerServerId(storedTargetPlayerId), GetPlayerName(storedTargetPlayerId))
    storedGameTag = CreateFakeMpGamerTag(storedTargetPed, nameTag, false, false, '', 0, 0, 0, 0)
    SetMpGamerTagVisibility(storedGameTag, 2, 1)  --set the visibility of component 2(healthArmour) to true
    SetMpGamerTagAlpha(storedGameTag, 2, 255) --set the alpha of component 2(healthArmour) to 255
    SetMpGamerTagHealthBarColor(storedGameTag, 129) --set component 2(healthArmour) color to 129(HUD_COLOUR_YOGA)
    SetMpGamerTagVisibility(storedGameTag, 4, NetworkIsPlayerTalking(i))
    --debugPrint(('Created gamer tag for ped (%s), TargetPlayerID (%s)'):format(storedTargetPlayerId, storedTargetPlayerId))
end

--- Called to cleanup Gamer Tag's once spectate mode is disabled
local function clearGamerTagInfo()
    if not storedGameTag then return end
    RemoveMpGamerTag(storedGameTag)
    storedGameTag = nil
end

local function SearchVisiblePlayer()
    ::searchNext::
    if (ActualIndex + 1) > #PlayersAbleSpectate then
        ActualIndex = 1
    else
        ActualIndex = ActualIndex + 1
    end
    Wait(10)

    if not IsEntityVisible(GetPlayerPed(GetPlayerFromServerId(PlayersAbleSpectate[ActualIndex]))) then
        goto searchNext
    end
end

local function createScaleformThread()
    CreateThread(function()
        -- yay, scaleforms
        local scaleform = RequestScaleformMovie("instructional_buttons")
        while not HasScaleformMovieLoaded(scaleform) do
            Wait(1)
        end
        PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
        PushScaleformMovieFunctionParameterInt(200)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(2)
        InstructionalButton(GetControlInstructionalButton(1, 174), FenixElite.GetTranslation("previus_player"))
        PopScaleformMovieFunctionVoid()
        
        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(1)
        InstructionalButton(GetControlInstructionalButton(1, 175), FenixElite.GetTranslation("next_player"))
        PopScaleformMovieFunctionVoid()


        PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(80)
        PopScaleformMovieFunctionVoid()

        CreateThread(function()
            while InfoDataSpectate1["isSpectateEnabled"] do
                if IsDisabledControlJustPressed(0, 175) and not InTimeoutSpec then
                    InTimeoutSpec = true

                    CreateThread(function()
                        Wait(1500)
                        InTimeoutSpec = false
                    end)

                    SearchVisiblePlayer()
    
                    local ped = GetPlayerPed(GetPlayerFromServerId(PlayersAbleSpectate[ActualIndex]))
                    local coords
                    if ped == 0 then
                        coords = lib.callback.await("fenix:getCoords", false, PlayersAbleSpectate[ActualIndex])
                    else
                        coords = GetEntityCoords(ped)
                    end

                    ChangeTarget(PlayersAbleSpectate[ActualIndex], coords)
                end
    
                if IsDisabledControlJustPressed(0, 174) and not InTimeoutSpec then
                    InTimeoutSpec = true
                    
                    CreateThread(function()
                        Wait(1500)
                        InTimeoutSpec = false
                    end)

                    SearchVisiblePlayer()
    
                    local ped = GetPlayerPed(GetPlayerFromServerId(PlayersAbleSpectate[ActualIndex]))
                    local coords
                    if ped == 0 then
                        coords = lib.callback.await("fenix:getCoords", false, PlayersAbleSpectate[ActualIndex])
                    else
                        coords = GetEntityCoords(ped)
                    end

                    ChangeTarget(PlayersAbleSpectate[ActualIndex], coords)
                end
    
                Wait(0)
            end
        end)

        while InfoDataSpectate1["isSpectateEnabled"] do
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)

            Wait(1)
        end
        SetScaleformMovieAsNoLongerNeeded()
    end)
end

local function calculateSpectatorCoords(coords)
    return vec3(coords[1], coords[2], coords[3] - 15.0)
end

--- Will freeze the player and set the entity to invisible
--- @param bool boolean - Whether we should prepare or cleanup
local function preparePlayerForSpec(bool)
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, bool)
    SetEntityVisible(playerPed, not bool, 0)
end

local function createSpectatorTeleportThread()
    CreateThread(function()
        while InfoDataSpectate1["isSpectateEnabled"] do
            -- Check if ped still exists
            if not DoesEntityExist(storedTargetPed) then
                local _ped = GetPlayerPed(storedTargetPlayerId)
                if _ped > 0 then
                    if _ped ~= storedTargetPed then
                        storedTargetPed = _ped
                    end
                    storedTargetPed = _ped
                else
                    toggleSpectate(storedTargetPed, storedTargetPlayerId)
                    break
                end
            end

            if not IsEntityVisible(storedTargetPed) then
                SearchVisiblePlayer()

                local ped = GetPlayerPed(GetPlayerFromServerId(PlayersAbleSpectate[ActualIndex]))
                local coords
                if ped == 0 then
                    coords = lib.callback.await("fenix:getCoords", false, PlayersAbleSpectate[ActualIndex])
                else
                    coords = GetEntityCoords(ped)
                end
                
                ChangeTarget(PlayersAbleSpectate[ActualIndex], coords)
                break
            end

            -- Update Teleport
            local newSpectateCoords = calculateSpectatorCoords(GetEntityCoords(storedTargetPed))
            SetEntityCoords(PlayerPedId(), newSpectateCoords.x, newSpectateCoords.y, newSpectateCoords.z, 0, 0, 0, false)

            Wait(500)
        end
    end)
end

function ChangeTarget(targetServerId, coords)
    local spectatorPed = PlayerPedId()
    lastSpectateLocation = GetEntityCoords(spectatorPed)

    local targetPlayerId = GetPlayerFromServerId(targetServerId)
    if targetPlayerId == PlayerId() then
        return print('Non puoi spectarti da solo!', 'error')
    end

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(0) end
    InfoDataSpectate1["isSpectateEnabled"] = false

    Wait(500)

    if not IsAbleToSpectate then
        preparePlayerForSpec(false)

        NetworkSetInSpectatorMode(false, storedTargetPed)
        DoScreenFadeIn(500)

        storedTargetPed = nil
        return
    end

    local tpCoords = calculateSpectatorCoords(coords)
    SetEntityCoords(spectatorPed, tpCoords.x, tpCoords.y, tpCoords.z, 0, 0, 0, false)
    preparePlayerForSpec(true)

    --- We need to wait to make sure that the player is actually available once we teleport
    --- this can take some time so we do this. Automatically breaks if a player isn't resolved
    --- within 5 seconds.
--[[     local resolvePlayerAttempts = 0
    local resolvePlayerFailed

    repeat
        if resolvePlayerAttempts > 100 then
            resolvePlayerFailed = true
            break;
        end
        Wait(50)
        targetPlayerId = GetPlayerFromServerId(targetServerId)
        resolvePlayerAttempts = resolvePlayerAttempts + 1
    until (GetPlayerPed(targetPlayerId) > 0) and targetPlayerId ~= -1

    if resolvePlayerFailed then
        print("Resolve Failed")
        return cleanupFailedResolve()
    end ]]

    InfoDataSpectate1["isSpectateEnabled"] = false
    toggleSpectate(GetPlayerPed(targetPlayerId), targetPlayerId)
end

--- Will toggle spectate for a targeted ped
--- @param targetPed nil|number - The target ped when toggling on, can be nil when toggling off
function toggleSpectate(targetPed, targetPlayerId)
    local playerPed = PlayerPedId()

    if InfoDataSpectate1["isSpectateEnabled"] then
        InfoDataSpectate1["isSpectateEnabled"] = false

        preparePlayerForSpec(false)

        NetworkSetInSpectatorMode(false, storedTargetPed)
        DoScreenFadeIn(500)

        storedTargetPed = nil
    else
        storedTargetPed = targetPed
        storedTargetPlayerId = targetPlayerId
        local targetCoords = GetEntityCoords(targetPed)

        RequestCollisionAtCoord(targetCoords.x, targetCoords.y, targetCoords.z)
        while not HasCollisionLoadedAroundEntity(targetPed) do
            Wait(5)
        end

        NetworkSetInSpectatorMode(true, targetPed)
        DoScreenFadeIn(500)
        InfoDataSpectate1["isSpectateEnabled"] = true
        createSpectatorTeleportThread()
        createScaleformThread()
    end
end

-- Run whenever we failed to resolve a target player to spectate
local function cleanupFailedResolve()
    local playerPed = PlayerPedId()

    RequestCollisionAtCoord(lastSpectateLocation.x, lastSpectateLocation.y, lastSpectateLocation.z)
    SetEntityCoords(playerPed, lastSpectateLocation.x, lastSpectateLocation.y, lastSpectateLocation.z)
    -- The player is still frozen while we wait for collisions to load
    while not HasCollisionLoadedAroundEntity(playerPed) do
        Wait(5)
    end
    preparePlayerForSpec(false)

    DoScreenFadeIn(500)

    print('Spectate Fallito', 'error')
end

-- Client-side event handler for an authorized spectate request
function PartiSpectate(targetServerId, coords)
    local spectatorPed = PlayerPedId()
    lastSpectateLocation = GetEntityCoords(spectatorPed)

    local targetPlayerId = GetPlayerFromServerId(targetServerId)
    if targetPlayerId == PlayerId() then
        return print('Non puoi spectarti da solo!', 'error')
    end

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(0) end

    local tpCoords = calculateSpectatorCoords(coords)
    SetEntityCoords(spectatorPed, tpCoords.x, tpCoords.y, tpCoords.z, 0, 0, 0, false)
    preparePlayerForSpec(true)

    --- We need to wait to make sure that the player is actually available once we teleport
    --- this can take some time so we do this. Automatically breaks if a player isn't resolved
    --- within 5 seconds.
--[[     local resolvePlayerAttempts = 0
    local resolvePlayerFailed

    repeat
        if resolvePlayerAttempts > 100 then
            resolvePlayerFailed = true
            break;
        end
        Wait(50)
        targetPlayerId = GetPlayerFromServerId(targetServerId)
        resolvePlayerAttempts = resolvePlayerAttempts + 1
    until (GetPlayerPed(targetPlayerId) > 0) and targetPlayerId ~= -1

    if resolvePlayerFailed then
        return cleanupFailedResolve()
    end ]]

    toggleSpectate(GetPlayerPed(targetPlayerId), targetPlayerId)
end

CreateThread(function()
    while true do
        if InfoDataSpectate1["isSpectateEnabled"] then
            createGamerTagInfo()
        else
            clearGamerTagInfo()
        end
        Wait(50)
    end
end)

local function isPlayerAlive(pId)
    for k, v in pairs(FenixElite.Match.AllPlayers) do
        print("Comparing ", v.id, " with ", pId, " and ", v.vivo, " with ", "true")
        if v.id == pId then
            return v.vivo
        end
    end
end

RegisterNetEvent("MatchLeague:IniziaSpectate", function()
    local myId = GetPlayerServerId(PlayerId())
    PlayersAbleSpectate = {}
    local pAlives = 0

    for k, v in pairs(FenixElite.Match.Temmates) do
        if k ~= myId then
            local newIndex = #PlayersAbleSpectate + 1
            PlayersAbleSpectate[newIndex] = k
            if isPlayerAlive(k) then
                pAlives += 1
            end
        end
    end

    print("Able spectaste:", IsAbleToSpectate)
    IsAbleToSpectate = true

    if pAlives > 0 then
        ::regeneratePly::
        ActualIndex = math.random(1, #PlayersAbleSpectate)

        Wait(10)
        if not IsEntityVisible(GetPlayerPed(GetPlayerFromServerId(PlayersAbleSpectate[ActualIndex]))) then
            goto regeneratePly
        end

        local ped = GetPlayerPed(GetPlayerFromServerId(PlayersAbleSpectate[ActualIndex]))
        local coords
        if ped == 0 then
            coords = lib.callback.await("fenix:getCoords", false, PlayersAbleSpectate[ActualIndex])
        else
            coords = GetEntityCoords(ped)
        end
        PartiSpectate(PlayersAbleSpectate[ActualIndex], coords)
    else
        print("Nessuno vivo")
    end
end)

RegisterNetEvent("FivemLeague:DisattivaSpectate", function()
    print("Eseguito")
    IsAbleToSpectate = false
    if InfoDataSpectate1["isSpectateEnabled"] then
        toggleSpectate()
    end
end)