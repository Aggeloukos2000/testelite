FenixElite = FenixElite or {}
FenixElite.AntiCheat = {}

local ArmiBlacklist = {
    [`WEAPON_GRENADELAUNCHER`] = true,
	[`WEAPON_RPG`] = true,
	[`WEAPON_STINGER`] = true,
	[`WEAPON_MINIGUN`] = true,
	[`WEAPON_GRENADE`] = true,
	[`WEAPON_STICKYBOMB`] = true,
	[`WEAPON_RAILGUN`] = true,
	[`WEAPON_COMPACTLAUNCHER`] = true,
	[`WEAPON_PIPEBOMB`] = true,
	[`WEAPON_PROXMINE`] = true,
	[`WEAPON_GRENADELAUNCHER_SMOKE`] = true,
	[`WEAPON_FIREWORK`] = true,
	[`WEAPON_HOMINGLAUNCHER`] = true,
	[`WEAPON_RAYPISTOL`] = true,
	[`WEAPON_RAYCARBINE`] = true,
	[`WEAPON_RAYMINIGUN`] = true,
	[`WEAPON_DIGISCANNER`] = true,
}

local contextTable = {
    [0] = 18.0,
    [1] = 28.0,
    [2] = 20.0,
    [3] = 30.0,
    [4] = 30.0,
    [5] = 30.0,
    [6] = 30.0,
    [7] = 20.0
}

FenixElite.GodModeDetect = 0

local hasNoClip = function(ped)
    return (IsEntityPositionFrozen(ped) or GetPlayerInvincible(source)) and (not IsEntityVisible(ped) or GetEntityCollisionDisabled(ped)) and GetVehiclePedIsIn(ped, false) == 0
end

getCoordsEuclidian = function(coords1, coords2, useZ)
    local x1 = coords1.x;
    local y1 = coords1.y;
    local z1 = useZ and coords1.z or 0

    local x2 = coords2.x;
    local y2 = coords2.x;
    local z2 = useZ and coords2.z or 0;

    return math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1));
end

CreateThread(function()
    repeat
        Wait(1000)
    until cache.ped

    local noClipTimes = 0

    while true do 
        if not NetworkSessionIsSolo() and FenixElite.EnableAntiCheat then
            local coords = GetEntityCoords(cache.ped)

            -- Inizio Freecam --
            local camcoords, contextValue = (coords - GetFinalRenderedCamCoord()), contextTable[GetCamActiveViewModeContext()]
            if not FenixElite.InTutorial and not IsPlayerCamControlDisabled() and not InfoDataSpectate1["isSpectateEnabled"] and ((camcoords.x > contextValue) or (camcoords.y > contextValue) or (camcoords.z > contextValue) or (camcoords.x < -contextValue) or (camcoords.y < -contextValue) or (camcoords.z < -contextValue)) then
                TriggerServerEvent("FenixElite:AntiCheat:Detection", "Freecam")
            end
            -- Fine Freecam --

            if GetPedConfigFlag(cache.ped, 2, false) then
                SetPedConfigFlag(cache.ped, 2, false)
                TriggerServerEvent("FenixElite:AntiCheat:Detection", "Anti HS")
            end

            if not FenixElite.InFreeroam then
                -- Inizio Blacklist --
                local currWeapon = GetSelectedPedWeapon(cache.ped)
                if currWeapon then
                    if ArmiBlacklist[currWeapon] then
                        TriggerServerEvent("FenixElite:AntiCheat:Detection", "Blacklist", {Weapon = currWeapon})
                        RemoveAllPedWeapons(cache.ped, true)
                    end
                end
                -- Fine Blacklist --

                -- Inizio AntiNoclip --
                if not InfoDataSpectate1["isSpectateEnabled"] and not FenixElite.InTutorial and not FenixElite.StartingMatch then
                    print("Checking NoClip", hasNoClip(cache.ped))
                    if hasNoClip(cache.ped) then
                        local start = GetEntityCoords(cache.ped)
                        Wait(1000)
                        local sEnd = GetEntityCoords(cache.ped)

                        local dist = getCoordsEuclidian(start, sEnd, true) * 3.6
                        if (dist > 30.0) then
                            if noClipTimes > 5 then
                                TriggerServerEvent("FenixElite:AntiCheat:Detection", "NoClip")
                            end

                            noClipTimes += 1
                        else
                            noClipTimes -= 1
                        end
                    else
                        noClipTimes -= 1
                    end
                end

                -- Fine AntiNoclip --
            end 

            -- Inizio AntiGodmode --
            if not FenixElite.StartingMatch and not FenixElite.InFreeroam and not InfoDataSpectate1["isSpectateEnabled"] and not FenixElite.IsInDeathmatch and not FenixElite.IsDead and FenixElite.InMatch and FenixElite.InRedzone and FenixElite.IsInCorsaArmi then
                if GetPlayerInvincible(cache.playerId) then
                    TriggerServerEvent("FenixElite:AntiCheat:Detection", "Godmode [0]")
                end
            end

            local health = GetEntityHealth(cache.ped)
            if health > 200 then
                TriggerServerEvent("FenixElite:AntiCheat:Detection", "Godmode [1]")
            end

            SetPlayerHealthRechargeMultiplier(cache.ped, 0.0)
            SetEntityHealth(cache.ped, health - 2)

            Wait(20)

            if GetEntityHealth(cache.ped) > (health - 2) then
                if not FenixElite.StartingMatch and not FenixElite.InFreeroam and not InfoDataSpectate1["isSpectateEnabled"] and not FenixElite.IsInDeathmatch and not FenixElite.IsDead and FenixElite.InMatch and FenixElite.InRedzone and FenixElite.IsInCorsaArmi then
                    FenixElite.GodModeDetect += 1
                end
            elseif (FenixElite.GodModeDetect > 0) then
                FenixElite.GodModeDetect -= 1
            end

            if FenixElite.GodModeDetect > 5 then
                TriggerServerEvent("FenixElite:AntiCheat:Detection", "Godmode [2]")
            end

            SetEntityHealth(cache.ped, health + 2)
            -- Fine AntiGodmode --

            -- Inizio Anti Invisible (Skript - TZX) --
            TriggerServerEvent("FenixElite:AntiCheat:CheckInvisible", GetEntityCoords(cache.ped))
            -- Fine Anti Invisible (Skript - TZX) --
        end

        Wait(4000)
    end
end)

CreateThread(function()
    while true do
        if IsPedInAnyVehicle(cache.ped, false) or IsPedFalling(cache.ped) then
            SetPedCanRagdoll(cache.ped, true)
            Wait(10000)
        else
            SetPedCanRagdoll(cache.ped, false)
        end
        Wait(100)
    end
end)