FenixElite = FenixElite or {}
FenixElite.InMatch = false
FenixElite.Match = {}
FenixElite.group1Hash = nil
FenixElite.group2Hash = nil
FenixElite.StartingMatch = false
FenixElite.EnableBF = false

RegisterNetEvent("fenix:match:start", function(coords, myTeam, wpn, teamList, allPlayers, enCrouch, enRadio, enBf)
    FenixElite.Match.MyTeam = myTeam
    FenixElite.Match.Temmates = teamList or FenixElite.Match.Temmates
    FenixElite.Match.AllPlayers = allPlayers or FenixElite.Match.AllPlayers
    FenixElite.InMatch = true
    FenixElite.StartingMatch = true

    if enRadio ~= nil then
        FenixElite.EnableRadio = enRadio
    end

    if enCrouch ~= nil then
        FenixElite.EnableCrouch = enCrouch
    end

    if enBf ~= nil then
        FenixElite.EnableBF = enBf
    end

    FenixElite.Match.TeamA = {}
    FenixElite.Match.TeamB = {}
    if FenixElite.Match and FenixElite.Match.AllPlayers then
        for k, v in pairs(FenixElite.Match.AllPlayers) do
            if v.team == "A" then
                table.insert(FenixElite.Match.TeamA, v)
            elseif v.team == "B" then
                table.insert(FenixElite.Match.TeamB, v)
            end
        end
    end

    SendReactMessage("updateScoreboard", {TeamA = FenixElite.Match.TeamA, TeamB = FenixElite.Match.TeamB})
    TriggerEvent("FivemLeague:DisattivaSpectate")
    TriggerEvent("fenix:checkLeave")
    TriggerServerEvent("fenix:redzone:exit")
    toggleNuiFrame(false)
    Wait(1600)
    TriggerEvent("FivemLeague:DisattivaSpectate")
    FenixElite.IsDead = false
    NetworkResurrectLocalPlayer(GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))
    SetEntityCoords(cache.ped, coords, true, false, false, false)
    SetEntityHeading(cache.ped, 0.0)
    SetEntityVisible(cache.ped, true)
    SetEntityCollision(cache.ped, true)
    SetEntityInvincible(cache.ped, true)
    FreezeEntityPosition(cache.ped, true)
    SetEntityAlpha(cache.ped, 255, false)
    SetCanAttackFriendly(cache.ped, true, true)
    NetworkSetFriendlyFireOption(false)
    SetPedAccuracy(cache.ped, 95)
    StatSetInt(GetHashKey('MP0_SHOOTING_ABILITY'), 100, true)
    StatSetInt(GetHashKey('MP0_STAMINA'), 100, true)
    SetPedSuffersCriticalHits(cache.ped, true)
    if FenixElite.group1Hash then
        RemoveRelationshipGroup(FenixElite.group1Hash)
        FenixElite.group1Hash = nil
    end

    if FenixElite.group2Hash then
        RemoveRelationshipGroup(FenixElite.group2Hash)
        FenixElite.group2Hash = nil
    end

    _, FenixElite.group1Hash = AddRelationshipGroup("A")
    __, FenixElite.group2Hash = AddRelationshipGroup("B")
    SetRelationshipBetweenGroups(5, FenixElite.group1Hash, FenixElite.group2Hash)
    SetRelationshipBetweenGroups(5, FenixElite.group2Hash, FenixElite.group1Hash)

    if myTeam == "A" then
        SetPedRelationshipGroupHash(cache.ped, FenixElite.group1Hash)
        SetEntityCanBeDamagedByRelationshipGroup(cache.ped, false, FenixElite.group1Hash)
    elseif myTeam == "B" then
        SetPedRelationshipGroupHash(cache.ped, FenixElite.group2Hash)
        SetEntityCanBeDamagedByRelationshipGroup(cache.ped, false, FenixElite.group2Hash)
    end

    for k, v in pairs(FenixElite.Match.AllPlayers) do
        FenixElite.Match.AllPlayers[k].vivo = true
    end
    SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 0.0)
    SetWeaponDamageModifier(GetHashKey("WEAPON_PISTOL_MK2"), 0.000001)
    SetWeaponDamageModifier(GetHashKey("WEAPON_PISTOL"), 0.5)
    ClearRagdollBlockingFlags(cache.ped, 0)
    ResetPedMovementClipset(cache.ped, 0)
    FenixElite.Scaleform.Countdown(255, 88, 88, 3, true)
    CreateThread(function()
        while FenixElite.StartingMatch do
            FreezeEntityPosition(cache.ped, true)
            --SetEntityCoords(cache.ped, coords, true, false, false, false)
            if #(GetEntityCoords(cache.ped) - coords) > 2 then
                SetEntityCoords(cache.ped, coords, true, false, false, false)
            end
            Wait(300)
        end
    end)

    Wait(3000)
    FenixElite.StartingMatch = false
    if FenixElite.InMatch then
        if #(GetEntityCoords(cache.ped) - coords) > 2 then
            SetEntityCoords(cache.ped, coords, true, false, false, false)
        end
        --NetworkResurrectLocalPlayer(GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))
        SetRunSprintMultiplierForPlayer(cache.playerId, 1.0)
        NetworkSetInSpectatorMode(false, nil)
        FreezeEntityPosition(cache.ped, false)
        SetEntityVisible(cache.ped, true, 0)
        TriggerEvent("FivemLeague:DisattivaSpectate")
        --SetEntityCoords(cache.ped, coords, true, false, false, false)
        GiveWeaponToPed(cache.ped, wpn, 1000, true,true)
        SetAmmoInClip(cache.ped, wpn, GetMaxAmmoInClip(cache.ped, wpn, 1))

        if wpn == `WEAPON_PISTOL_MK2` then
            GiveWeaponComponentToPed(cache.ped,wpn, `COMPONENT_AT_PI_COMP`)
            GiveWeaponComponentToPed(cache.ped,wpn, `COMPONENT_AT_PI_RAIL`)
            GiveWeaponComponentToPed(cache.ped,wpn, `COMPONENT_PISTOL_MK2_CLIP_02`)
        elseif wpn == `WEAPON_PISTOL` then
            GiveWeaponComponentToPed(cache.ped,wpn, `COMPONENT_APPISTOL_CLIP_02`)
            GiveWeaponComponentToPed(cache.ped,wpn, `COMPONENT_APPISTOL_VARMOD_LUXE`)
        end

        SetWeaponRecoilShakeAmplitude(wpn, 0.0)
        --SetGameplayCamRelativePitch(0.0, 1.0)
        --ResetPedMovementClipset(cache.ped, 0)
        FreezeEntityPosition(cache.ped, false)
        SetEntityInvincible(cache.ped, false)
        SetEntityVisible(cache.ped, true, true)
        SendReactMessage("showInMatchNUI", true)
        SendReactMessage("forceUpdateMatch")
        FenixElite.StartTeamInfo(teamList)
        SetPedSuffersCriticalHits(cache.ped, true)
        SetAmmoInClip(cache.ped, wpn, GetMaxAmmoInClip(cache.ped, wpn, 1))
    end
end)

local loopingTeam = false

FenixElite.StartTeamInfo = function(team)
    if loopingTeam then return end

    loopingTeam = true
    while FenixElite.InMatch do
        local CicloMarkerino = 500
        if next(team) then
            for key, value in pairs(GetActivePlayers()) do
                local pServerId = GetPlayerServerId(value)
                local pPed = GetPlayerPed(value)
                if DoesEntityExist(pPed) and team[tonumber(pServerId)] and pServerId ~= cache.serverId and IsEntityVisible(pPed) then
                    local coords = GetEntityCoords(pPed)
                    if coords and coords.x and coords.y and coords.z then
                        CicloMarkerino = 0
                        DrawMarker(28, coords.x, coords.y, coords.z + 0.90, 0.0, 0.0, 0.0, 0.0, 0, 0, 0.050, 0.050, 0.050, 0, 255, 0, 255 , false, true, 2, nil, nil, false)
                    end
                end
            end
        end
        Wait(CicloMarkerino)
    end
    loopingTeam = false
end

RegisterNetEvent("fenix:match:end", function(tWon)
    FenixElite.IsDead = false
    FenixElite.InMatch = false
    FenixElite.Match.AllPlayers = nil
    FenixElite.StartingMatch = false
    FenixElite.EnableBF = false
    NetworkResurrectLocalPlayer(GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))
    TriggerEvent("FivemLeague:DisattivaSpectate")
    TriggerEvent('dz-crosshair:client:ToggleHud')
    Wait(1000)
    SendReactMessage("showInMatchNUI", false)
    SetEntityAlpha(cache.ped, 255, false)
    SetEntityCoords(cache.ped, FenixElite.LobbyCoords, true, false, false, false) 
    RemoveRelationshipGroup(FenixElite.group1Hash)
    RemoveRelationshipGroup(FenixElite.group2Hash)
    SetEntityVisible(cache.ped, true)
    SetEntityCollision(cache.ped, true)
    SetEntityInvincible(cache.ped, true)
    SetCanAttackFriendly(cache.ped, false, false)
    NetworkSetFriendlyFireOption(false)
    SetEntityHealth(cache.ped, GetEntityMaxHealth(cache.ped))
    ClearPedBloodDamage(cache.ped)
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.49)
    ResetPedMovementClipset(cache.ped, 0)
    RemoveAllPedWeapons(cache.ped, false)
    FenixElite.EnableRadio = false
    FenixElite.EnableCrouch = false
    FenixElite.EnableBF = false
    if tWon then
        if tWon == FenixElite.Match.MyTeam then
            FenixElite.Scaleform.ShowBanner(FenixElite.GetTranslation("you_won"), FenixElite.GetTranslation("team_won"):format(tWon))
        else
            FenixElite.Scaleform.ShowBanner(FenixElite.GetTranslation("you_lost"), FenixElite.GetTranslation("team_won"):format(tWon))
        end
    end
    if FenixElite.group1Hash then
        FenixElite.group1Hash = nil
    end

    if FenixElite.group2Hash then
        FenixElite.group2Hash = nil
    end

    FenixElite.Match = {}

    toggleNuiFrame(false)
    TriggerEvent("FivemLeague:DisattivaSpectate")

    Wait(1000)
    TriggerEvent("FivemLeague:DisattivaSpectate")
    FreezeEntityPosition(cache.ped, false)
    NetworkResurrectLocalPlayer(GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))
end)

RegisterNetEvent("fenix:updateAllPings", function(newPings)
    for k, v in pairs(newPings) do
        for kk, vv in pairs(FenixElite.Match.TeamA) do
            if k == vv.id then
                FenixElite.Match.TeamA[kk].ping = v
                break
            end
        end

        for kk, vv in pairs(FenixElite.Match.TeamB) do
            if k == vv.id then
                FenixElite.Match.TeamB[kk].ping = v
                break
            end
        end
    end

    SendReactMessage("updateScoreboard", {TeamA = FenixElite.Match.TeamA, TeamB = FenixElite.Match.TeamB})
end)

RegisterNUICallback('getScoreboardData', function(_, cb)
    cb({TeamA = FenixElite.Match.TeamA, TeamB = FenixElite.Match.TeamB})
end)

RegisterNetEvent("fenix:playerLeft", function(uId)
    for k, v in pairs(FenixElite.Match.AllPlayers) do
        if v.id == uId then
            FenixElite.Match.AllPlayers[k].exit = true
        end
    end

    SendReactMessage("forceUpdateMatch")
end)

FenixElite.FakeKillfeed = function()
    RequestModel(`mp_m_freemode_01`)
     while not HasModelLoaded(`mp_m_freemode_01`) do
         Wait(100)
     end
 
     local coords = GetEntityCoords(cache.ped)
     local ped = CreatePed(4, `mp_m_freemode_01`, vec3(coords.x, coords.y, coords.z - 10), 0.0, false, false)
     FreezeEntityPosition(ped, true)
 
     local RootPosition = GetPedBoneCoords(ped, 0x0, 0, 0, 0)
     local HandPosition = GetPedBoneCoords(ped, 0x796E, 0, 0, 0.2)
     local WeaponHash = GetHashKey("WEAPON_PISTOL")
 
     ShootSingleBulletBetweenCoords(
         HandPosition.x,
         HandPosition.y,
         HandPosition.z,
         RootPosition.x,
         RootPosition.y,
         RootPosition.z,
         500,
         0,
         WeaponHash,
         cache.ped,
         false,
         true,
         1
     )
     PlaySoundFrontend(-1, "Criminal_Damage_Kill_Player", "GTAO_FM_Events_Soundset", 0, 0, 1)
     TriggerEvent("fnx:provvisorio:client:setKf")
 
     Wait(100)
 
     DeleteEntity(ped)
end 

RegisterNetEvent("fenix:mettiMorto", function(user, coords, killer)
    local url, savedIndex
    if cache.serverId == killer then
        TriggerEvent("dz-crosshair:client:KillNotify")
        FenixElite.FakeKillfeed()
    end

    for k, v in pairs(FenixElite.Match.AllPlayers) do
        if v.id == user then
            FenixElite.Match.AllPlayers[k].vivo = false
            url = FenixElite.Match.AllPlayers[k].avatarUrl
            savedIndex = k
        end
    end

    for k, v in pairs(FenixElite.Match.TeamA) do
        if v.id == user then
            FenixElite.Match.TeamA[k].deaths += 1
        end

        if v.id == killer then
            FenixElite.Match.TeamA[k].kills += 1
        end
    end

    for k, v in pairs(FenixElite.Match.TeamB) do
        if v.id == user then
            FenixElite.Match.TeamB[k].deaths += 1
        end

        if v.id == killer then
            FenixElite.Match.TeamB[k].kills += 1
        end
    end

    SendReactMessage("forceUpdateMatch")
    SendReactMessage("updateScoreboard", {TeamA = FenixElite.Match.TeamA, TeamB = FenixElite.Match.TeamB})

    if savedIndex and url then
        print("Generating ", user, url)
        FenixElite.DeathMarker.GenerateTexture(user, url)

        Wait(1500)

        RequestStreamedTextureDict(FenixElite.DeathMarker.TextureDictory, true)
        while not HasStreamedTextureDictLoaded(FenixElite.DeathMarker.TextureDictory) do
            Wait(100)
        end

        while FenixElite.Match.AllPlayers and not FenixElite.Match.AllPlayers[savedIndex].vivo do
            DrawMarker(9, coords.x, coords.y, coords.z - 0.50, 0.0, 0.0, 0.0, 90.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 255, 255, 255, false, true, 2, false, FenixElite.DeathMarker.TextureDictory, user, false)
            Wait(1)
        end
    end
end)

local spawned = false
local Vehicle = false
local function SpawnMotoVehicle()
    local ModelHash = `bf400`
    if not IsModelInCdimage(ModelHash) then return end
    RequestModel(ModelHash)
    while not HasModelLoaded(ModelHash) do
      Wait(10)
    end
    local MyPed = PlayerPedId()
    Vehicle = CreateVehicle(ModelHash, GetEntityCoords(MyPed), GetEntityHeading(MyPed), true, false)

    if DoesEntityExist(Vehicle) then
        SetModelAsNoLongerNeeded(ModelHash)
        SetPedIntoVehicle(cache.ped, Vehicle,-1)
        spawned = true
        CreateThread(function()
            while IsPedInAnyVehicle(cache.ped, false) do
                if IsControlJustPressed(1, 311) and GetEntitySpeed(Vehicle) < 3 then
                    DeleteEntity(Vehicle)
                    EnableControlAction(0, 75, true)
                    EnableControlAction(27, 75, true)
                    spawned = false
                    return
                end
                if GetEntitySpeed(Vehicle) > 5 then
                    DisableControlAction(0, 75, true)
                    DisableControlAction(27, 75, true)
                else
                    EnableControlAction(0, 75, true)
                    EnableControlAction(27, 75, true)
                end
                Wait(0)
            end
            DeleteEntity(Vehicle)
            spawned = false
        end)
    end
end

RegisterCommand("moto", function(src, args)
    if FenixElite.EnableBF and not spawned then
        SpawnMotoVehicle()
    end
end)

RegisterCommand("veh", function(src, args)
    if FenixElite.EnableBF and not spawned then
        SpawnMotoVehicle()
    end
end)

RegisterCommand("bf", function(src, args)
    if FenixElite.EnableBF and not spawned then
        SpawnMotoVehicle()
    end
end)