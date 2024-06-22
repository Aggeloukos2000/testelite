FenixElite = FenixElite or {}
FenixElite.IsDead = false

local Text = function (txt)
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(txt)
    DrawText(0.5, 0.8)
end

RegisterNetEvent("fenix:registerDeath", function(killer, weapon)
    if FenixElite.InMatch or FenixElite.IsInDeathmatch or FenixElite.InRedzone or FenixElite.InFreeroam or FenixElite.IsInCorsaArmi then
        TriggerEvent("fenix:morto", killer, weapon)
    elseif FenixElite.InFreeroam then
        if IsEntityDead(cache.ped) then
            TriggerEvent("fenix:morto", killer, weapon)
        end
    else
        SetPlayerHealthRechargeMultiplier(cache.ped, 0.0)
        NetworkResurrectLocalPlayer(GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))
        SetEntityVisible(cache.ped, true)
    end
end)

AddEventHandler("gameEventTriggered", function (name, data)
    if name == "CEventNetworkEntityDamage" then
        local vittima, killer, fatale = tonumber(data[1]), tonumber(data[2]), tonumber(data[6])
        if vittima == cache.ped and fatale == 1 then
            if FenixElite.InFreeroam then
                TriggerEvent("fenix:morto", GetPlayerServerId(NetworkGetPlayerIndexFromPed(killer)), data[7])
            elseif FenixElite.InMatch or FenixElite.IsInDeathmatch or FenixElite.InRedzone or FenixElite.IsInCorsaArmi then
                TriggerEvent("fenix:morto", GetPlayerServerId(NetworkGetPlayerIndexFromPed(killer)), data[7])
            else
                if IsEntityDead(cache.ped) then
                    SetPlayerHealthRechargeMultiplier(cache.ped, 0.0)
                    NetworkResurrectLocalPlayer(GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))
                    SetEntityVisible(cache.ped, true)
                end
            end
        elseif vittima == cache.ped then
            if FenixElite.InFreeroam then
                if IsEntityDead(cache.ped) then
                    TriggerEvent("fenix:morto", GetPlayerServerId(NetworkGetPlayerIndexFromPed(killer)), data[7])
                end
            elseif FenixElite.InMatch or FenixElite.IsInDeathmatch or FenixElite.InRedzone or FenixElite.IsInCorsaArmi then
                if IsEntityDead(cache.ped) then
                    TriggerEvent("fenix:morto", GetPlayerServerId(NetworkGetPlayerIndexFromPed(killer)), data[7])
                end
            else
                if IsEntityDead(cache.ped) then
                    SetPlayerHealthRechargeMultiplier(cache.ped, 0.0)
                    NetworkResurrectLocalPlayer(GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))
                    SetEntityVisible(cache.ped, true)
                end
            end
        end
    end
end)


RegisterNetEvent("fenix:morto", function(killer, weapon)
    FenixElite.IsDead = true
    if FenixElite.InMatch then
        FenixElite.StartDeathFunction()

        if FenixElite.Match.AllPlayers then
            local foundAlive = false
            local myTeam

            for k, v in pairs(FenixElite.Match.AllPlayers) do
                if v.id == cache.serverId then
                    myTeam = v.team
                    break
                end
            end

            for k, v in pairs(FenixElite.Match.AllPlayers) do
                if myTeam == v.team and not v.exit and v.id ~= cache.serverId then
                    foundAlive = true
                    break
                end
            end

            if foundAlive then
                TriggerEvent("MatchLeague:IniziaSpectate")
            end
        else
            TriggerEvent("MatchLeague:IniziaSpectate")
        end
    elseif FenixElite.IsInDeathmatch then
        if killer == cache.serverId then
            TriggerEvent("dz-crosshair:client:KillNotify")
            FenixElite.FakeKillfeed()
        else
            FenixElite.StartDeathFunction()
        end
    elseif FenixElite.IsInCorsaArmi then
        if killer == cache.serverId then
            TriggerEvent("dz-crosshair:client:KillNotify")
            FenixElite.FakeKillfeed()
        else
            FenixElite.StartDeathFunction()
        end
    elseif FenixElite.InRedzone then
        FenixElite.StartDeathFunction()
        CreateThread(function()
            Wait(1300)
            FenixElite.IsDead = false
            SetEntityCollision(cache.ped, true, true)
            RespawnIntoRedzone()
        end)
    elseif FenixElite.InFreeroam then
        CreateThread(function()
            local pressed = false
            Wait(1000)
            while FenixElite.IsDead do
                Wait(0)
                if not pressed then
                    Text("Press ~r~[E]~w~ for respawn")
                end
                if IsDisabledControlJustPressed(1, 51) and not pressed then
                    pressed = true
                    FenixElite.IsDead = false
                    ClearPedTasksImmediately(cache.ped)
                    ClearPedBloodDamage(cache.ped)
                    FreezeEntityPosition(cache.ped, false)
                    SetEntityCollision(cache.ped, true, true)
                    SetEntityAlpha(cache.ped, 255, false)
                    NetworkResurrectLocalPlayer(GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))
                    Wait(100)
                    SetCurrentPedWeapon(cache.ped, FenixElite.CurrentWpn, true)
                end
            end
        end)

        FenixElite.StartDeathFunction()
    else
        FenixElite.StartDeathFunction()
    end

    TriggerServerEvent("fenix:aggiornaMorto", tonumber(killer), weapon)
end)

FenixElite.StartDeathFunction = function ()
    ClearPedTasksImmediately(cache.pd)
    SetEntityCompletelyDisableCollision(cache.ped,false,false)
    SetEntityVisible(cache.ped, false, false)
    --SetEntityLocallyVisible(cache.ped)
    SetEntityAlpha(cache.ped, 100, false)
    SetBlockingOfNonTemporaryEvents(cache.ped, true)
    Wait(50)
    FenixElite.DeathAnimation()
end

FenixElite.DeathAnimation = function()
    --ClearPedTasksImmediately(playerPedId)
    SetPlayerHealthRechargeMultiplier(cache.ped, 0.0)
    NetworkResurrectLocalPlayer(GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))
    SetEntityInvincible(cache.ped, true)
    SetEntityVisible(cache.ped, false)
    FreezeEntityPosition(cache.ped, true)
    SetEntityCollision(cache.ped, false, false)
    CreateThread(function ()
        while FenixElite.IsDead do
            if IsEntityVisible(cache.ped) then
                SetEntityVisible(cache.ped, false)
            end
            DisableAllControlActions(0)
            EnableControlAction(0, 1)
            EnableControlAction(0, 2)
            SetPedToRagdoll(cache.ped, 1000, 1000, 0, 0, 0, 0)
            ResetPedRagdollTimer(cache.ped)
            Wait(0)
        end
        SetEntityInvincible(cache.ped, false)
        SetEntityVisible(cache.ped, true)
        Wait(1000)
        if not IsEntityVisible(cache.ped) then
           SetEntityVisible(cache.ped, true)
        end
    end)
end