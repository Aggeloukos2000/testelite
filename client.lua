FenixElite = FenixElite or {}
FenixElite.SavedSkin = GetResourceKvpString('fenix_skin')
FenixElite.LobbyCoords = vec3(288.7519, -1601.2214, 31.2729)

CreateThread(function()
    while true do
		Wait(0)
		if NetworkIsPlayerActive(PlayerId()) then
			DoScreenFadeOut(0)
			TriggerServerEvent('FenixElite:PlayerEntrato')
			break
		end
	end
end)

function FenixElite.TranslateLangIdToName(id)
    if id == 3 then
        return "IT"
    elseif id == 0 then
        return "EN"
    elseif id == 4 then
        return "ES"
    elseif id == 5 then
        return "BR"
    elseif id == 1 then
        return "FR"
    elseif id == 2 then
        return "DE"
    end

    return "EN"
end 

lib.callback.register('fenix:prendiDati', function()
    return {Lingua = FenixElite.TranslateLangIdToName(GetCurrentLanguage()), Skin = exports['fivem-appearance']:getPedAppearance(cache.ped)}
end)

FenixElite.LoadAnim = function(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

RegisterNetEvent("FenixElite:PlayerCaricato", function(data, nuovo)
    FenixElite.PlayerData = data
    FenixElite.Coins.CurrValue = data.coins
    FenixElite.Items.List = data.items or {}
    FenixElite.PlayerData.ped = PlayerPedId()
    FreezeEntityPosition(FenixElite.PlayerData.ped, true)
    SpawnManager.spawnPlayer({
        x = 288.7519,
        y = -1601.2214,
        z = 31.2729,
        heading = 230.7382,
        model = `mp_m_freemode_01`,
        skipFade = false
    }, function()
        FenixElite.PlayerData.ped = PlayerPedId()
        FenixElite.PlayerData.Lobby = 0
        FreezeEntityPosition(FenixElite.PlayerData.ped, false)
        SetRunSprintMultiplierForPlayer(cache.playerId, 1.49)

        if not nuovo then
            if FenixElite.SavedSkin then
                exports['fivem-appearance']:setPlayerAppearance(json.decode(FenixElite.SavedSkin))
            else
                SetPedComponentVariation(FenixElite.PlayerData.ped, 3, 0, 0, 2)
                SetPedComponentVariation(FenixElite.PlayerData.ped, 4, 0, 0, 0)
                SetPedComponentVariation(FenixElite.PlayerData.ped, 6, 0, 0, 0)
            end
        else
            SetPedComponentVariation(FenixElite.PlayerData.ped, 3, 0, 0, 2)
            SetPedComponentVariation(FenixElite.PlayerData.ped, 4, 0, 0, 0)
            SetPedComponentVariation(FenixElite.PlayerData.ped, 6, 0, 0, 0)

            FenixElite.IniziaTutorial()
        end
    end)

    for k, v in pairs(FenixElite.PlayerData.Top3) do
        FenixElite.CreateTopPed(k, v.username, v.skin)
    end

    print('[^1FenixElite^7] Player caricato con successo')

    Wait(10000)

    if not data.isAdmin then
        FenixElite.EnableAntiCheat = true 
        print('[^1FenixElite^7] AntiCheat avviato con successo!')
    end
end)
RegisterKeyMapping('apriFenix', 'Open FenixElite Menu', 'keyboard', 'F2')

local function SetDay()
    SetWeatherTypePersist("EXTRASUNNY")
    SetWeatherTypeNow("EXTRASUNNY")
    SetWeatherTypeNowPersist("EXTRASUNNY")
    NetworkOverrideClockTime(13, 00, 00)
    FenixElite.Functions.Notify("Time Changed!")
end
RegisterCommand("day", SetDay, false)
RegisterCommand("giorno", SetDay, false)

local function SetNight()
    SetWeatherTypePersist("EXTRASUNNY")
    SetWeatherTypeNow("EXTRASUNNY")
    SetWeatherTypeNowPersist("EXTRASUNNY")
    NetworkOverrideClockTime(00, 00, 00)
    FenixElite.Functions.Notify("Time Changed!")
end
RegisterCommand("night", SetNight, false)
RegisterCommand("notte", SetNight, false)

CreateThread(function()
    Wait(5000)
    for i = 1, 12, 1 do
        EnableDispatchService(i, false)
    end
    local playerId = PlayerId()
    SetPlayerWantedLevel(playerId, 0, false)
    SetPlayerWantedLevelNow(playerId, false)
    SetPlayerWantedLevelNoDrop(playerId, 0, false)
    -- IN TEST
    SetPlayerCanUseCover(playerId, false)
    DisplayRadar(false)
    DisableIdleCamera(true)
    RemoveMultiplayerHudCash(0x968F270E39141ECA)
    RemoveMultiplayerBankCash(0xC7C6789AA1CFEDD0)
	ReplaceHudColourWithRgba(116, 254, 54, 87, 255) -- Colore Menu ESC
    AddTextEntry('FE_THDR_GTAO', '~r~FenixElite~s~ - discord.gg/fnx') -- Menu ESC
    AddTextEntry('PM_PANE_CFX', '~r~FenixElite~s~ - Commands') -- Cambio Comandi KeyMapping
    SetPlayerTargetingMode(3)
    --
    print('[^1FenixElite^7] '..GetNumResources()..' risorse caricate con successo')
    while true do
        if IsPedArmed(cache.ped, 6) then
	        DisableControlAction(1, 140, true)
       	    DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            RestorePlayerStamina(cache.playerId, 1.0)
        end

        SetPedCanPlayAmbientAnims(cache.ped, false)
        DisableControlAction(0, 36, true)
        DisableControlAction(1, 36, true)

        if not FenixElite.InFreeroam then
            BlockWeaponWheelThisFrame()
            DisableControlAction(0, 37, true)
        end
        Wait(0)
    end
end)

CreateThread(function()
    while true do
        if not FenixElite.InFreeroam then
            DisplayRadar(false)
        end

        if not FenixElite.IsDead and not FenixElite.InRedzone and not FenixElite.AdminSpectating then
            ResetEntityAlpha(cache.ped)
            SetEntityVisible(cache.ped, true, true)
        end

        SetPedAccuracy(cache.ped, 95)
        StatSetInt(GetHashKey('MP0_SHOOTING_ABILITY'), 100, true)
        StatSetInt(GetHashKey('MP0_STAMINA'), 100, true)
        Wait(5000)
    end
end)

AddEventHandler('onClientResourceStop', function(rName)
    print('[^1FenixElite^7] Hai stoppato la risorsa '..tostring(rName)..'')
end)

RegisterNUICallback('getCurrentLang', function(_, cb)
    while not FenixElite.PlayerData do
        Wait(100)
    end

    cb(FenixElite.PlayerData.Lingua)
end)

RegisterNUICallback('setLingua', function(data, cb)
    FenixElite.PlayerData.Lingua = data
    TriggerServerEvent("fenix:setLingua", data)
    cb(true)
end)

exports("canInteract", function()
    return not FenixElite.InMatch and not FenixElite.IsInDeathmatch and not FenixElite.InRedzone
end)

RegisterCommand("stats", function()
    SendReactMessage("setShowScoreboard", true)
    Wait(5000)
    SendReactMessage("setShowScoreboard", false)
end, false)

RegisterCommand("+showScoreboard", function()
    SendReactMessage("setShowScoreboard", true)
end, false)

RegisterCommand("-showScoreboard", function()
    SendReactMessage("setShowScoreboard", false)
end, false)

RegisterKeyMapping('+showScoreboard', 'Show Scoreboard', 'keyboard', 'tab')

function DrawText3Ds(x,y,z, text)
    AddTextEntry('FloatingHelpText', text)
    SetFloatingHelpTextWorldPosition(0, vector3(x, y, z))
    SetFloatingHelpTextStyle(0, true, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('FloatingHelpText')
    EndTextCommandDisplayHelp(1, false, false, -1)
end

function DrawText3Ds2(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

local Top3Coords = {
    vec4(289.1223, -1608.1482, 30.8076, 13.3435),
    vec4(290.0180, -1608.1095, 30.6369, 19.4245),
    vec4(288.3240, -1608.1045, 30.4581, 10.6029),
}

FenixElite.CreateTopPed = function(index, username, skin)
    local coords = Top3Coords[index]
    local model = GetHashKey(skin.model or "mp_m_freemode_01")

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end

    local ped = CreatePed(4, model, coords.x, coords.y, coords.z, coords.h, false, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedDiesWhenInjured(ped, false)
    SetPedCanPlayAmbientAnims(ped, true)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetEntityCanBeDamaged(ped, false)
    SetPedCanRagdoll(ped, false)
    SetPedCanSwitchWeapon(ped, false)

    Wait(1000)

    exports["fivem-appearance"]:setPedAppearance(ped, skin)

    local point = lib.points.new({
        coords = vec3(coords.x, coords.y, coords.z),
        distance = 5
    })

    function point:nearby()
        DrawText3Ds2(self.coords.x, self.coords.y, self.coords.z + 1.95, username)

        if self.currentDistance < 2 and IsControlJustReleased(0, 38) then
            ExecuteCommand(v.command)
        end
    end
end

FenixElite.ShowHelpNotification = function(msg, thisFrame, beep, duration)
    AddTextEntry('esxHelpNotification', msg)

    if thisFrame then
        DisplayHelpTextThisFrame('esxHelpNotification', false)
    else
        if beep == nil then
            beep = true
        end
        BeginTextCommandDisplayHelp('esxHelpNotification')
        EndTextCommandDisplayHelp(0, false, beep, duration or -1)
    end
end

CreateThread(function()
    while true do
        SetDiscordAppId(1133794534346723328)
        SetDiscordRichPresenceAsset('fenix')
        SetDiscordRichPresenceAssetText('discord.gg/fnx')
        SetRichPresence("Playing on new version Fenix Elite")
        SetDiscordRichPresenceAction(0, "DISCORD", "https://discord.gg/fnx")
        SetDiscordRichPresenceAction(1, "JOIN", "fivem://connect/5.181.31.164:30120")
        SetDiscordAppId(1133794534346723328)
        Wait(35000)
    end
end)

local SkinGexy1 = json.decode('{"model":"mp_f_freemode_01","hair":{"highlight":29,"color":29,"style":73},"headOverlays":{"bodyBlemishes":{"style":0,"color":0,"opacity":0},"sunDamage":{"style":0,"color":0,"opacity":0},"moleAndFreckles":{"style":0,"color":0,"opacity":0.7},"complexion":{"style":0,"color":0,"opacity":0},"makeUp":{"style":3,"color":56,"opacity":1},"ageing":{"style":0,"color":0,"opacity":0},"lipstick":{"style":0,"color":22,"opacity":1},"eyebrows":{"style":30,"color":61,"opacity":1},"chestHair":{"style":16,"color":0,"opacity":1},"beard":{"style":0,"color":0,"opacity":0},"blush":{"style":0,"color":0,"opacity":0.2},"blemishes":{"style":0,"color":0,"opacity":0}},"eyeColor":2,"components":[{"texture":0,"component_id":0,"drawable":0},{"texture":0,"component_id":1,"drawable":0},{"texture":0,"component_id":2,"drawable":73},{"texture":0,"component_id":3,"drawable":4},{"texture":9,"component_id":4,"drawable":104},{"texture":0,"component_id":5,"drawable":0},{"texture":0,"component_id":6,"drawable":27},{"texture":0,"component_id":7,"drawable":0},{"texture":0,"component_id":8,"drawable":2},{"texture":0,"component_id":9,"drawable":15},{"texture":0,"component_id":10,"drawable":0},{"texture":1,"component_id":11,"drawable":74}],"faceFeatures":{"noseWidth":0.1,"chinBoneSize":0.2,"chinHole":0,"lipsThickness":0.1,"neckThickness":0,"cheeksBoneHigh":0,"cheeksWidth":0.1,"eyeBrownHigh":0,"nosePeakLowering":-0.6,"noseBoneTwist":0,"jawBoneBackSize":0,"chinBoneLowering":0.7,"nosePeakSize":-0.4,"eyesOpening":0.1,"nosePeakHigh":0,"jawBoneWidth":0,"noseBoneHigh":0,"eyeBrownForward":0,"chinBoneLenght":0,"cheeksBoneWidth":0.1},"props":[{"texture":-1,"prop_id":0,"drawable":-1},{"texture":-1,"prop_id":1,"drawable":-1},{"texture":0,"prop_id":2,"drawable":0},{"texture":-1,"prop_id":6,"drawable":-1},{"texture":-1,"prop_id":7,"drawable":-1}],"headBlend":{"skinFirst":0,"skinMix":0,"shapeFirst":31,"shapeSecond":25,"skinSecond":0,"shapeMix":0.6},"tattoos":[]}')
local SkinGexy2 = json.decode('{"faceFeatures":{"cheeksBoneWidth":0.1,"chinHole":0,"cheeksWidth":0.1,"jawBoneBackSize":0,"eyeBrownForward":0,"neckThickness":0,"nosePeakHigh":0,"eyesOpening":0.1,"cheeksBoneHigh":0,"eyeBrownHigh":0,"chinBoneLowering":0.7,"noseBoneTwist":0,"lipsThickness":0.1,"nosePeakSize":-0.4,"noseWidth":0.1,"nosePeakLowering":-0.6,"chinBoneLenght":0,"noseBoneHigh":0,"chinBoneSize":0.2,"jawBoneWidth":0},"eyeColor":14,"model":"mp_f_freemode_01","headBlend":{"shapeMix":0.6,"shapeFirst":31,"skinFirst":0,"skinMix":0,"skinSecond":0,"shapeSecond":45},"tattoos":[],"components":[{"component_id":0,"texture":0,"drawable":0},{"component_id":1,"texture":0,"drawable":0},{"component_id":2,"texture":0,"drawable":59},{"component_id":4,"texture":1,"drawable":102},{"component_id":5,"texture":0,"drawable":0},{"component_id":6,"texture":0,"drawable":27},{"component_id":7,"texture":0,"drawable":0},{"component_id":8,"texture":0,"drawable":13},{"component_id":9,"texture":0,"drawable":15},{"component_id":10,"texture":0,"drawable":0},{"component_id":11,"texture":0,"drawable":8},{"component_id":3,"texture":0,"drawable":21}],"props":[{"drawable":-1,"texture":-1,"prop_id":0},{"drawable":-1,"texture":-1,"prop_id":1},{"drawable":0,"texture":0,"prop_id":2},{"drawable":-1,"texture":-1,"prop_id":6},{"drawable":-1,"texture":-1,"prop_id":7}],"hair":{"style":59,"color":34,"highlight":55},"headOverlays":{"beard":{"style":0,"color":0,"opacity":0},"bodyBlemishes":{"style":0,"color":0,"opacity":0},"blemishes":{"style":0,"color":0,"opacity":0},"makeUp":{"style":3,"color":56,"opacity":1},"chestHair":{"style":16,"color":0,"opacity":1},"blush":{"style":0,"color":0,"opacity":0.2},"complexion":{"style":0,"color":0,"opacity":0},"ageing":{"style":0,"color":0,"opacity":0},"lipstick":{"style":0,"color":6,"opacity":1},"eyebrows":{"style":30,"color":61,"opacity":1},"sunDamage":{"style":0,"color":0,"opacity":0},"moleAndFreckles":{"style":0,"color":0,"opacity":0.7}}}')
local SkinGexy3 = json.decode('{"props":[{"drawable":-1,"prop_id":0,"texture":-1},{"drawable":11,"prop_id":1,"texture":0},{"drawable":-1,"prop_id":2,"texture":-1},{"drawable":-1,"prop_id":6,"texture":-1},{"drawable":-1,"prop_id":7,"texture":-1}],"tattoos":[],"headOverlays":{"bodyBlemishes":{"opacity":0,"color":0,"style":0},"makeUp":{"opacity":0,"color":0,"style":0},"beard":{"opacity":0,"color":0,"style":0},"blush":{"opacity":0,"color":0,"style":0},"ageing":{"opacity":0,"color":0,"style":0},"complexion":{"opacity":0,"color":0,"style":0},"eyebrows":{"opacity":1,"color":61,"style":30},"chestHair":{"opacity":0,"color":0,"style":0},"moleAndFreckles":{"opacity":0,"color":0,"style":0},"lipstick":{"opacity":0,"color":0,"style":0},"sunDamage":{"opacity":0,"color":0,"style":0},"blemishes":{"opacity":0,"color":0,"style":0}},"model":"mp_m_freemode_01","hair":{"highlight":4,"color":2,"style":3},"faceFeatures":{"chinBoneLenght":0,"chinHole":0,"neckThickness":0,"chinBoneLowering":0,"nosePeakSize":0.1,"cheeksWidth":0,"eyeBrownForward":0,"nosePeakLowering":-0.4,"nosePeakHigh":-0.1,"cheeksBoneWidth":0,"eyeBrownHigh":0,"lipsThickness":0,"noseWidth":-0.5,"eyesOpening":0,"jawBoneBackSize":0,"cheeksBoneHigh":0,"jawBoneWidth":-1,"chinBoneSize":0,"noseBoneHigh":0,"noseBoneTwist":0},"eyeColor":12,"components":[{"component_id":0,"drawable":0,"texture":0},{"component_id":1,"drawable":103,"texture":0},{"component_id":2,"drawable":3,"texture":0},{"component_id":5,"drawable":0,"texture":0},{"component_id":7,"drawable":0,"texture":0},{"component_id":9,"drawable":13,"texture":0},{"component_id":10,"drawable":0,"texture":0},{"component_id":6,"drawable":7,"texture":0},{"component_id":8,"drawable":57,"texture":0},{"component_id":11,"drawable":2,"texture":3},{"component_id":3,"drawable":0,"texture":0},{"component_id":4,"drawable":42,"texture":4}],"headBlend":{"skinSecond":0,"shapeMix":0.1,"skinMix":0,"skinFirst":16,"shapeSecond":12,"shapeFirst":33}}')
local SkinGexy4 = json.decode('{"faceFeatures":{"eyeBrownHigh":0,"nosePeakLowering":-0.4,"cheeksBoneHigh":0,"noseBoneHigh":0,"neckThickness":0,"nosePeakHigh":-0.1,"eyeBrownForward":0,"chinBoneSize":0,"chinBoneLowering":0,"nosePeakSize":0.1,"chinHole":0,"cheeksBoneWidth":0,"cheeksWidth":0,"noseBoneTwist":0,"jawBoneBackSize":0,"noseWidth":-0.5,"jawBoneWidth":-1,"eyesOpening":0,"lipsThickness":0,"chinBoneLenght":0},"model":"mp_m_freemode_01","headOverlays":{"eyebrows":{"style":30,"opacity":1,"color":61},"ageing":{"style":0,"opacity":0,"color":0},"lipstick":{"style":0,"opacity":0,"color":0},"beard":{"style":0,"opacity":0,"color":0},"makeUp":{"style":0,"opacity":0,"color":0},"complexion":{"style":0,"opacity":0,"color":0},"bodyBlemishes":{"style":0,"opacity":0,"color":0},"moleAndFreckles":{"style":0,"opacity":0,"color":0},"blush":{"style":0,"opacity":0,"color":0},"sunDamage":{"style":0,"opacity":0,"color":0},"chestHair":{"style":0,"opacity":0,"color":0},"blemishes":{"style":0,"opacity":0,"color":0}},"components":[{"component_id":0,"drawable":0,"texture":0},{"component_id":2,"drawable":3,"texture":0},{"component_id":5,"drawable":0,"texture":0},{"component_id":7,"drawable":0,"texture":0},{"component_id":8,"drawable":57,"texture":0},{"component_id":9,"drawable":13,"texture":0},{"component_id":10,"drawable":0,"texture":0},{"component_id":11,"drawable":238,"texture":0},{"component_id":4,"drawable":6,"texture":9},{"component_id":3,"drawable":2,"texture":0},{"component_id":6,"drawable":2,"texture":1},{"component_id":1,"drawable":111,"texture":15}],"props":[{"drawable":-1,"texture":-1,"prop_id":0},{"drawable":11,"texture":0,"prop_id":1},{"drawable":-1,"texture":-1,"prop_id":2},{"drawable":-1,"texture":-1,"prop_id":6},{"drawable":-1,"texture":-1,"prop_id":7}],"eyeColor":12,"hair":{"highlight":14,"style":36,"color":14},"headBlend":{"skinMix":0,"shapeSecond":12,"shapeFirst":33,"skinFirst":16,"shapeMix":0.1,"skinSecond":0},"tattoos":[]}')
local SkinParmex = json.decode('{"model":"mp_m_freemode_01","eyeColor":0,"components":[{"drawable":0,"texture":0,"component_id":0},{"drawable":14,"texture":0,"component_id":2},{"drawable":0,"texture":0,"component_id":3},{"drawable":0,"texture":0,"component_id":4},{"drawable":0,"texture":0,"component_id":5},{"drawable":0,"texture":0,"component_id":7},{"drawable":15,"texture":0,"component_id":8},{"drawable":0,"texture":0,"component_id":9},{"drawable":0,"texture":0,"component_id":10},{"drawable":79,"texture":0,"component_id":11},{"drawable":121,"texture":0,"component_id":1},{"drawable":5,"texture":0,"component_id":6}],"headBlend":{"skinFirst":0,"shapeMix":0,"shapeFirst":21,"skinMix":0,"skinSecond":0,"shapeSecond":21},"props":[{"prop_id":0,"texture":-1,"drawable":-1},{"prop_id":1,"texture":-1,"drawable":-1},{"prop_id":2,"texture":-1,"drawable":-1},{"prop_id":6,"texture":-1,"drawable":-1},{"prop_id":7,"texture":-1,"drawable":-1}],"hair":{"style":14,"highlight":31,"color":0},"tattoos":[],"faceFeatures":{"eyeBrownForward":0,"cheeksBoneHigh":0,"noseWidth":0,"chinBoneSize":0,"eyesOpening":0,"chinHole":0,"nosePeakLowering":0,"cheeksWidth":0,"eyeBrownHigh":0,"chinBoneLowering":0,"jawBoneBackSize":0,"nosePeakHigh":0,"nosePeakSize":0,"noseBoneTwist":0,"lipsThickness":0,"chinBoneLenght":0,"jawBoneWidth":0,"cheeksBoneWidth":0,"neckThickness":0,"noseBoneHigh":0},"headOverlays":{"lipstick":{"style":0,"opacity":0,"color":0},"makeUp":{"style":4JUdGzvrMFDWrUUwY3toJATSeNwjn54LkCnKBPRzDuhzi5vSepHfUckJNxRL2gjkNrSqtCoRUrEDAgRwsQvVCjZbRyFTLRNyDmT1a1boZVcolor":0},"ageing":{"style":0,"opacity":0,"color":0},"beard":{"style":0,"opacity":0,"color":0},"blush":{"style":0,"opacity":0,"color":0},"sunDamage":{"style":0,"opacity":0,"color":0},"moleAndFreckles":{"style":0,"opacity":0,"color":0},"blemishes":{"style":0,"opacity":0,"color":0},"eyebrows":{"style":0,"opacity":0,"color":0},"bodyBlemishes":{"style":0,"opacity":0,"color":0}}}')

local Pagine = {
    "/1v1 [ID]~n~/1v1~n~/day~n~/night~n~/report [Target ID] [Reason]~n~/saveoutfit [Name]~n~/outfit [Name]~n~/updateImage",
    "/skin~n~/listoutfit~n~/deleteoutfit [Name]~n~/copyoutfit [ID]~n~/crosshair~n~/hub~n~F4 - Radio Animation~n~F2 - Fenix Menu~n~TAB - Show Stats/Ping"
}
local CurrPagina = 1

CreateThread(function()
    local NPCToSpawn = {
        {x = 299.9223, y = -1617.8962, z = 29.5318, h = 38.0863, arma = `weapon_railgun`, model = `mp_m_freemode_01`, text = "~r~~h~Command List~h~~n~~n~~w~", command = "", customSkin = SkinParmex},
    }

    for k, v in pairs(NPCToSpawn) do
        RequestModel(v.model)
        while not HasModelLoaded(v.model) do
            Wait(1)
        end

        local ped = CreatePed(4, v.model, v.x, v.y, v.z, v.h, false, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedDiesWhenInjured(ped, false)
        SetPedCanPlayAmbientAnims(ped, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        SetEntityCanBeDamaged(ped, false)
        SetPedCanRagdoll(ped, false)
        SetPedCanSwitchWeapon(ped, false)

        if v.customSkin then
            exports["fivem-appearance"]:setPedAppearance(ped, v.customSkin)
        end

        Wait(1000)

        if v.arma then
            GiveWeaponToPed(ped, v.arma, 999, true, true)
        end

        local point = lib.points.new({
            coords = vec3(v.x, v.y, v.z),
            distance = 5
        })

        function point:nearby()
            if self.currentDistance < 4 then
                DrawText3Ds(self.coords.x, self.coords.y, self.coords.z + 1.95, v.text .. Pagine[CurrPagina] .."~n~~n~~INPUT_CELLPHONE_LEFT~  ~INPUT_CELLPHONE_RIGHT~")

                if IsControlJustPressed(0, 175) then -- Destra
                    if CurrPagina >= #Pagine then
                        return
                    end

                    CurrPagina += 1
                elseif IsControlJustPressed(0, 174) then -- Sinistra
                    if CurrPagina <= 1 then
                        return
                    end

                    CurrPagina -= 1
                end
            end
        end
    end
end)

CreateThread(function()
    local NPCToSpawn = {
        {x = 306.6740, y = -1609.9127, z = 29.5318, h = 68.7955, arma = `weapon_sniperrifle`, model = `mp_f_freemode_01`, text = "~INPUT_PICKUP~ Menu Fenix", command = "apriFenix", customSkin = SkinGexy1},
        {x = 308.6938, y =-1599.4312, z = 29.5318, h = 98.4107, arma = `WEAPON_MINIGUN`, model = `mp_m_freemode_01`, text = "~INPUT_PICKUP~ Aim Lab", command = "aimlab", customSkin = SkinGexy3},
        {x = 305.0286, y = -1589.6289, z = 29.5318, h = 120.6660, arma = `WEAPON_RPG`, model = `mp_f_freemode_01`, text = "~INPUT_PICKUP~ Crosshair", command = "crosshair", customSkin = SkinGexy2},
        {x = 297.0049, y = -1583.0256, z = 29.5318, h = 160.5378, arma = `weapon_railgun`, model = `mp_m_freemode_01`, text = "~INPUT_PICKUP~ Freeroam", command = "freeroam", customSkin = SkinGexy4},
        {x = -71.9019, y = -812.1151, z = 325.1751, h = 145.4796, arma = `weapon_railgun`, model = `mp_m_freemode_01`, text = "~INPUT_C078E4D4~ Menu", command = "freeroamMenu", customSkin = SkinGexy4},
    }

    for k, v in pairs(NPCToSpawn) do
        RequestModel(v.model)
        while not HasModelLoaded(v.model) do
            Wait(1)
        end

        local ped = CreatePed(4, v.model, v.x, v.y, v.z, v.h, false, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedDiesWhenInjured(ped, false)
        SetPedCanPlayAmbientAnims(ped, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        SetEntityCanBeDamaged(ped, false)
        SetPedCanRagdoll(ped, false)
        SetPedCanSwitchWeapon(ped, false)

        if v.customSkin then
            exports["fivem-appearance"]:setPedAppearance(ped, v.customSkin)
        end

        Wait(1000)

        if v.arma then
            GiveWeaponToPed(ped, v.arma, 999, true, true)
        end

        local point = lib.points.new({
            coords = vec3(v.x, v.y, v.z),
            distance = 5
        })

        function point:nearby()
            DrawText3Ds(self.coords.x, self.coords.y, self.coords.z + 1.95, v.text)

            if IsControlJustReleased(0, 38) then
                ExecuteCommand(v.command)
            end
        end
    end
end)

FenixElite.CanInteract = function(checkMatch, checkMatchmaking, checkDeathmatch, checkRedzone, checkFreeroam, checkCorsaArmi)
    if checkMatch then
        if FenixElite.InMatch then
            return false
        end
    end

    if checkMatchmaking then
        if FenixElite.InMatchmaking then
            return false
        end
    end

    if checkDeathmatch then
        if FenixElite.IsInDeathmatch then
            return false
        end
    end

    if checkRedzone then
        if FenixElite.InRedzone then
            return false
        end
    end

    if checkFreeroam then
        if FenixElite.InFreeroam then
            return false
        end
    end

    if checkCorsaArmi then
        if FenixElite.IsInCorsaArmi then
            return false
        end
    end

    return true
end

RegisterCommand("id", function()
    FenixElite.Functions.Notify("ID: ".. cache.serverId, 5000)
end)

RegisterNUICallback('openBrowser', function(data, cb)
    TriggerEvent("FenixElite:ApriBrowserSponsor", data)

    cb()
end)