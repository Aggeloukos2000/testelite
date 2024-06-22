RegisterNetEvent("fenix:deathmatch:start", function(pos, allPlayers, firstStart)
    if not firstStart then
        Wait(1000)
        SetPlayerHealthRechargeMultiplier(cache.ped, 0.0)
        NetworkResurrectLocalPlayer(GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))
    end

    if firstStart then
        FenixElite.IsInDeathmatch = true
    end

    if not FenixElite.IsInDeathmatch then return end
    
    FenixElite.IsDead = false
    toggleNuiFrame(false)
    SetEntityCoords(cache.ped, pos.x, pos.y, pos.z, true, false, false, false)
    FreezeEntityPosition(cache.ped, true)
    ResetPedMovementClipset(cache.ped, 0)
    SetEntityHeading(cache.ped, 0.0)
    SetEntityVisible(cache.ped, true)
    SetEntityCollision(cache.ped, true)
    TriggerEvent('dz-crosshair:client:ToggleHud')
    SetPedAccuracy(cache.ped, 95)
    StatSetInt(GetHashKey('MP0_SHOOTING_ABILITY'), 100, true)
    StatSetInt(GetHashKey('MP0_STAMINA'), 100, true)
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(cache.ped, true, true)
    SetEntityAlpha(cache.ped, 255, false)
    SetPedSuffersCriticalHits(cache.ped, true)
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.0)
    FenixElite.EnableRadio = true
    FenixElite.EnableCrouch = true

    if firstStart then
        for k, _ in pairs(allPlayers) do
            allPlayers[k].Kills = 0
        end

        FenixElite.Match.AllPlayers = allPlayers
        SendReactMessage("updateAllPlayers", FenixElite.Match.AllPlayers)
        SetEntityInvincible(cache.ped, true)
        FreezeEntityPosition(cache.ped, true)
        TaskReloadWeapon(cache.ped, 1)

        SetCanAttackFriendly(ped, true, true)
        NetworkSetFriendlyFireOption(true)

        SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 0.0)
        SetWeaponDamageModifier(GetHashKey("WEAPON_PISTOL_MK2"), 0.000001)
        SetWeaponDamageModifier(GetHashKey("WEAPON_PISTOL"), 0.000001)
        ClearRagdollBlockingFlags(cache.ped, 0)
        ResetPedMovementClipset(cache.ped, 0)
        FenixElite.Scaleform.Countdown(255, 88, 88, 3, true)
        Wait(3000)
    end

    SendReactMessage("showInDeathmatchNUI", true)

    Wait(500)

    GiveWeaponToPed(cache.ped, "WEAPON_PISTOL_MK2", 1000, true,true)
    SetAmmoInClip(cache.ped, "WEAPON_PISTOL_MK2", GetMaxAmmoInClip(cache.ped, "WEAPON_PISTOL_MK2", true))
    ResetPedMovementClipset(cache.ped, 0)
    FreezeEntityPosition(cache.ped, false)
    SetEntityInvincible(cache.ped, false)
    SetEntityVisible(cache.ped, true, true)
end)

RegisterNetEvent("fenix:deathmatch:end", function(winner, winnerUsername)
    FenixElite.IsDead = false
    TriggerEvent('dz-crosshair:client:ToggleHud')
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
    FenixElite.IsInDeathmatch = false

    if winnerUsername then
        if winnerUsername and winner == cache.serverId then
            FenixElite.Scaleform.ShowBanner(FenixElite.GetTranslation("you_won"), FenixElite.GetTranslation("player_won"):format(winnerUsername))
        else
            FenixElite.Scaleform.ShowBanner(FenixElite.GetTranslation("you_lost"), FenixElite.GetTranslation("player_won"):format(winnerUsername))
        end
    end

    Wait(1000)

    FenixElite.IsInDeathmatch = false
    SendReactMessage("showInDeathmatchNUI", false)
    RemoveAllPedWeapons(cache.ped, false)
end)

RegisterNetEvent("fenix:deathmatch:aggiornaData", function(killer)
    if FenixElite.Match.AllPlayers then
        for k, v in pairs(FenixElite.Match.AllPlayers) do
            if v.id == killer then
                FenixElite.Match.AllPlayers[k].Kills = FenixElite.Match.AllPlayers[k].Kills + 1
                break
            end
        end

        table.sort(FenixElite.Match.AllPlayers, function(a, b) return a.Kills > b.Kills end)

        SendReactMessage("updateAllPlayers", FenixElite.Match.AllPlayers)
    end
end)

RegisterNetEvent("fenix:deathmatch:playerLeft", function(id)
    for k, v in pairs(FenixElite.Match.AllPlayers) do
        if v.id == id then
            FenixElite.Match.AllPlayers[k].exit = true
        end
    end

    SendReactMessage("updateAllPlayers", FenixElite.Match.AllPlayers)
end)