FenixElite.CorsaAlleArmi = {}

FenixElite.CorsaAlleArmi.ArmiUtilizzabili = {}
FenixElite.CorsaAlleArmi.CurrWeapon = nil

RegisterNetEvent("fenix:corsaarmi:inizia", function(pos, allPlayers, firstStart, listaId)
    if not firstStart then
        Wait(1000)
        SetPlayerHealthRechargeMultiplier(cache.ped, 0.0)
        NetworkResurrectLocalPlayer(GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))
    end

    if firstStart then
        FenixElite.IsInCorsaArmi = true
    end

    if not FenixElite.IsInCorsaArmi then return end

    FenixElite.StartingMatch = true
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
        FenixElite.CorsaAlleArmi.CurrWeapon = FenixElite.CorsaArmi[listaId][0]
        FenixElite.CorsaAlleArmi.ArmiUtilizzabili = FenixElite.CorsaArmi[listaId]
        FenixElite.CorsaAlleArmi.ArmiUtilizzabili[0].current = true

        for k, _ in pairs(allPlayers) do
            allPlayers[k].Kills = 0
        end

        FenixElite.Match.AllPlayers = allPlayers
        SendReactMessage("showCorsaAlleArmi", true)
        SendReactMessage("changeCurrentKills", 0)

        local tmpArr = {}
        for k, v in pairs(FenixElite.CorsaAlleArmi.ArmiUtilizzabili) do
            table.insert(tmpArr, {img = v.img, kills = tostring(k), current = (k == 0), killsNumber = k})
        end

        table.sort(tmpArr, function(a, b) return a.killsNumber < b.killsNumber end)

        SendReactMessage("updateWeaponList", tmpArr)
        SetEntityInvincible(cache.ped, true)
        FreezeEntityPosition(cache.ped, true)
        TaskReloadWeapon(cache.ped, 1)

        SetCanAttackFriendly(cache.ped, true, true)
        NetworkSetFriendlyFireOption(true)

        SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 0.0)
        SetWeaponDamageModifier(GetHashKey("WEAPON_PISTOL_MK2"), 0.000001)
        SetWeaponDamageModifier(GetHashKey("WEAPON_PISTOL"), 0.000001)
        ClearRagdollBlockingFlags(cache.ped, 0)
        ResetPedMovementClipset(cache.ped, 0)
        FenixElite.Scaleform.Countdown(255, 88, 88, 3, true)
        Wait(3000)
    end

    Wait(500)

    local currHash = GetHashKey(FenixElite.CorsaAlleArmi.CurrWeapon.Name)

    GiveWeaponToPed(cache.ped, currHash, 1000, true,true)
    SetAmmoInClip(cache.ped, currHash, GetMaxAmmoInClip(cache.ped, currHash, true))
    ResetPedMovementClipset(cache.ped, 0)
    FreezeEntityPosition(cache.ped, false)
    SetEntityInvincible(cache.ped, false)
    SetEntityVisible(cache.ped, true, true)
    FenixElite.StartingMatch = false
end)

RegisterNetEvent("fenix:corsaarmi:end", function(winner, winnerUsername)
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
    FenixElite.IsInCorsaArmi = false

    SendReactMessage("showCorsaAlleArmi", false)
    if winnerUsername then
        if winnerUsername and winner == cache.serverId then
            FenixElite.Scaleform.ShowBanner(FenixElite.GetTranslation("you_won"), FenixElite.GetTranslation("player_won"):format(winnerUsername))
        else
            FenixElite.Scaleform.ShowBanner(FenixElite.GetTranslation("you_lost"), FenixElite.GetTranslation("player_won"):format(winnerUsername))
        end
    end

    Wait(1000)

    FenixElite.IsInCorsaArmi = false
    RemoveAllPedWeapons(cache.ped, false)
end)

RegisterNetEvent("fenix:corsaarmi:aggiornaData", function(killer)
    if FenixElite.Match.AllPlayers then
        local foundIndex = 0
        for k, v in pairs(FenixElite.Match.AllPlayers) do
            if v.id == killer then
                foundIndex = k
                FenixElite.Match.AllPlayers[k].Kills = FenixElite.Match.AllPlayers[k].Kills + 1
                break
            end
        end

        if cache.serverId == killer and foundIndex then
            local needWeapon = FenixElite.CorsaAlleArmi.ArmiUtilizzabili[FenixElite.Match.AllPlayers[foundIndex].Kills]

            SendReactMessage("changeCurrentKills", FenixElite.Match.AllPlayers[foundIndex].Kills)

            if needWeapon then
                if needWeapon.Name == "Winner" then
                    return
                end

                local currHash = GetHashKey(needWeapon.Name)

                RemoveAllPedWeapons(cache.ped, false)
                GiveWeaponToPed(cache.ped, currHash, 1000, true, true)
                FenixElite.CorsaAlleArmi.CurrWeapon = needWeapon

                for k, v in pairs(FenixElite.CorsaAlleArmi.ArmiUtilizzabili) do
                    FenixElite.CorsaAlleArmi.ArmiUtilizzabili[k].current = false
                end

                FenixElite.CorsaAlleArmi.ArmiUtilizzabili[FenixElite.Match.AllPlayers[foundIndex].Kills].current = true

                local tmpArr = {}
                for k, v in pairs(FenixElite.CorsaAlleArmi.ArmiUtilizzabili) do
                    table.insert(tmpArr, {img = v.img, kills = tostring(k), current = v.current, killsNumber = k})
                end

                table.sort(tmpArr, function(a, b) return a.killsNumber < b.killsNumber end)

                SetAmmoInClip(cache.ped, currHash, GetMaxAmmoInClip(cache.ped, currHash, true))

                SendReactMessage("updateWeaponList", tmpArr)
            end
        end

        table.sort(FenixElite.Match.AllPlayers, function(a, b) return a.Kills > b.Kills end)
    end
end)