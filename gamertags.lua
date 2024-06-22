-- Variables
local isPlayerIdsEnabled = false
local playerGamerTags = {}
local distanceToCheck = 150
local noClipEnabled = false
local superJumpEnabled = false

-- Game consts
local fivemGamerTagCompsEnum = {
    GamerName = 0,
    CrewTag = 1,
    HealthArmour = 2,
    BigText = 3,
    AudioIcon = 4,
    UsingMenu = 5,
    PassiveMode = 6,
    WantedStars = 7,
    Driver = 8,
    CoDriver = 9,
    Tagged = 12,
    GamerNameNearby = 13,
    Arrow = 14,
    Packages = 15,
    InvIfPedIsFollowing = 16,
    RankText = 17,
    Typing = 18
}

--- Removes all cached tags
local function cleanAllGamerTags()
    debugPrint('Cleaning up gamer tags table')
    for _, v in pairs(playerGamerTags) do
        if IsMpGamerTagActive(v.gamerTag) then
            RemoveMpGamerTag(v.gamerTag)
        end
    end
    playerGamerTags = {}
end


--- Draws a single gamer tag (fivem)
local function setGamerTagFivem(targetTag, pid)
    -- Setup name
    SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.GamerName, 1)

    -- Setup Health
    SetMpGamerTagHealthBarColor(targetTag, 129)
    SetMpGamerTagAlpha(targetTag, fivemGamerTagCompsEnum.HealthArmour, 255)
    SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.HealthArmour, 1)

    -- Setup AudioIcon
    SetMpGamerTagAlpha(targetTag, fivemGamerTagCompsEnum.AudioIcon, 255)
    if NetworkIsPlayerTalking(pid) then
        SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.AudioIcon, true)
        SetMpGamerTagColour(targetTag, fivemGamerTagCompsEnum.AudioIcon, 12) --HUD_COLOUR_YELLOW
        SetMpGamerTagColour(targetTag, fivemGamerTagCompsEnum.GamerName, 12) --HUD_COLOUR_YELLOW
    else
        SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.AudioIcon, false)
        SetMpGamerTagColour(targetTag, fivemGamerTagCompsEnum.AudioIcon, 0)
        SetMpGamerTagColour(targetTag, fivemGamerTagCompsEnum.GamerName, 0)
    end
end

--- Clears a single gamer tag (fivem)
local function clearGamerTagFivem(targetTag)
    -- Cleanup name
    SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.GamerName, 0)
    -- Cleanup Health
    SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.HealthArmour, 0)
    -- Cleanup AudioIcon
    SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.AudioIcon, 0)
end


--- Setting game-specific functions
local setGamerTagFunc = setGamerTagFivem
local clearGamerTagFunc = clearGamerTagFivem


--- Loops through every player, checks distance and draws or hides the tag
local function showGamerTags(tId)
    local targetPed = GetPlayerPed(tId)

    if not playerGamerTags[tId] or not IsMpGamerTagActive(playerGamerTags[tId].gamerTag) then
        local playerName = string.sub(GetPlayerName(tId) or "unknown", 1, 75)
        local playerStr = '[' .. GetPlayerServerId(tId) .. ']' .. ' ' .. playerName
        playerGamerTags[tId] = {
            gamerTag = CreateFakeMpGamerTag(targetPed, playerStr, false, false, 0),
            ped = targetPed
        }
    end

    local targetTag = playerGamerTags[tId].gamerTag

    setGamerTagFunc(targetTag, tId)
end

--- Starts the gamer tag thread
--- Increasing/decreasing the delay realistically only reflects on the 
--- delay for the VOIP indicator icon, 250 is fine
local function createGamerTagThread(tId)
    debugPrint('Starting gamer tag thread')
    CreateThread(function()
        while isPlayerIdsEnabled do
            showGamerTags(tId)
            Wait(250)
        end

        -- Remove all gamer tags and clear out active table
        cleanAllGamerTags()
    end)
end

local freecamVeh = 0
local isVehAHorse = false
local setLocallyInvisibleFunc = IS_FIVEM and SetEntityLocallyInvisible or SetPlayerInvisibleLocally
local function toggleFreecam(enabled)
    noClipEnabled = enabled
    local ped = PlayerPedId()
    SetEntityVisible(ped, not enabled)
    SetEntityInvincible(ped, enabled)
    FreezeEntityPosition(ped, enabled)

    if enabled then
        freecamVeh = GetVehiclePedIsIn(ped, false)
        if IsPedOnMount(ped) then
            isVehAHorse = true
            freecamVeh = GetMount(ped)
        end
        if freecamVeh > 0 then
            NetworkSetEntityInvisibleToNetwork(freecamVeh, true)
            SetEntityCollision(freecamVeh, false, false)
            SetEntityVisible(freecamVeh, false)
            FreezeEntityPosition(freecamVeh, true)
            if not isVehAHorse then
                SetVehicleCanBreak(freecamVeh, false)
                SetVehicleWheelsCanBreak(freecamVeh, false)
            end
        end
    end

    local function enableNoClip()
        SetFreecamActive(true)
        StartFreecamThread()

        Citizen.CreateThread(function()
            while IsFreecamActive() do
                setLocallyInvisibleFunc(ped, true)
                if freecamVeh > 0 then
                    if DoesEntityExist(freecamVeh) then
                        setLocallyInvisibleFunc(freecamVeh, true) -- only works for players in RedM, but to prevent errors.
                    else
                        freecamVeh = 0
                    end
                end
                Wait(0)
            end

            if freecamVeh > 0 and DoesEntityExist(freecamVeh) then
                local coords = GetEntityCoords(ped)
                NetworkSetEntityInvisibleToNetwork(freecamVeh, false)
                SetEntityCoords(freecamVeh, coords[1], coords[2], coords[3], false, false, false, false)
                SetVehicleOnGroundProperly(freecamVeh)
                SetEntityCollision(freecamVeh, true, true)
                SetEntityVisible(freecamVeh, true)
                FreezeEntityPosition(freecamVeh, false)

                if isVehAHorse then
                    Citizen.InvokeNative(0x028F76B6E78246EB, ped, freecamVeh, -1) --SetPedOntoMount
                else
                    SetEntityAlpha(freecamVeh, 125)
                    SetPedIntoVehicle(ped, freecamVeh, -1)
                    local persistVeh = freecamVeh --since freecamVeh is erased down below
                    CreateThread(function()
                        Wait(2000)
                        ResetEntityAlpha(persistVeh)
                        SetVehicleCanBreak(persistVeh, true)
                        SetVehicleWheelsCanBreak(persistVeh, true)
                    end)
                end
            end
            freecamVeh = 0
        end)
    end

    local function disableNoClip()
        SetFreecamActive(false)
        if IS_FIVEM then
            SetGameplayCamRelativeHeading(0)
        else
            Citizen.InvokeNative(0x14F3947318CA8AD2, 0.0, 0.0) -- SetThirdPersonCamRelativeHeadingLimitsThisUpdate
        end
    end

    if not IsFreecamActive() and enabled then
        enableNoClip()
    end

    if IsFreecamActive() and not enabled then
        disableNoClip()
    end
end

FenixElite.AdminSpectating = false

RegisterNetEvent("fenix:adminSpectate", function(tId, coords)
    FenixElite.AdminSpectating = true
    SetEntityVisible(cache.ped, false, false)
    Wait(100)
    SetEntityCoords(cache.ped, coords.xyz, true, false, false, false)
    Wait(100)

    local playerInfo = -1
    repeat
        playerInfo = GetPlayerFromServerId(tId)
        Wait(100)
    until playerInfo ~= -1

    isPlayerIdsEnabled = true
    createGamerTagThread(playerInfo)

    toggleFreecam(true)
end)

RegisterNetEvent("fenix:adminNormal", function(tId, coords)
    FenixElite.AdminSpectating = false
    SetEntityVisible(cache.ped, true, true)
    isPlayerIdsEnabled = false
    toggleFreecam(false)
    Wait(100)
    SetEntityCoords(cache.ped, FenixElite.LobbyCoords, true, false, false, false)
end)