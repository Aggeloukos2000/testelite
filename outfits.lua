FenixElite = FenixElite or {}
FenixElite.Outfits = {}

FenixElite.Outfits = GetResourceKvpString("fnx_outfits")

if FenixElite.Outfits == nil then
    FenixElite.Outfits = {}
else
    FenixElite.Outfits = json.decode(FenixElite.Outfits)
end

RegisterCommand("saveoutfit", function(_, args)
    local data = exports["fivem-appearance"]:getPedAppearance(cache.ped)
    if not data then return end

    local name = args[1]
    if not name then
        FenixElite.Functions.Notify("Non hai inserito il nome dell'outfit! Comando esatto: /saveoutfit [nome]")
        return
    end

    for k, v in pairs(FenixElite.Outfits) do
        if v["Nome"] == name then
            FenixElite.Functions.Notify("Outfit già esistente!")
            return
        end
    end

    data["Nome"] = name
    table.insert(FenixElite.Outfits, data)
    SetResourceKvp("fnx_outfits", json.encode(FenixElite.Outfits))
    FenixElite.Functions.Notify("Outfit salvato con successo!")
end, false)

RegisterCommand("deleteoutfit", function(_, args)
    for k, v in pairs(FenixElite.Outfits) do
        if v["Nome"] == args[1] then
            table.remove(FenixElite.Outfits, k)
            SetResourceKvp("fnx_outfits", json.encode(FenixElite.Outfits))
            FenixElite.Functions.Notify("Outfit eliminato con successo!")
            return
        end
    end

    FenixElite.Functions.Notify("Outfit non trovato!")
end, false)

RegisterCommand("listoutfit", function(_, args)
    local formattedString = ""
    for _, v in pairs(FenixElite.Outfits) do
        formattedString = formattedString.. v["Nome"] .."<br>"
    end

    FenixElite.Functions.Notify(formattedString, 5000)
end, false)

RegisterCommand("skin", function()
    if not FenixElite.CanInteract(true, true, true, true, true, true) then return end
    
    local config = {
        ped = true,
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        components = true,
        props = true,
        allowExit = true,
        tattoos = true
    }

    exports['fivem-appearance']:startPlayerCustomization(function (appearance)
        if appearance then
            SetResourceKvp("fenix_skin", json.encode(appearance))
            TriggerServerEvent("fenix:skin:update", appearance)
        end
    end, config)
end, false)

RegisterCommand("skinmenu", function()
    if not FenixElite.CanInteract(true, true, true, true, true, true) then return end

    local config = {
        ped = true,
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        components = true,
        props = true,
        allowExit = true,
        tattoos = true
    }

    exports['fivem-appearance']:startPlayerCustomization(function (appearance)
        if appearance then
            SetResourceKvp("fenix_skin", json.encode(appearance))
            TriggerServerEvent("fenix:skin:update", appearance)
        end
    end, config)
end, false)

RegisterCommand("barbermenu", function()
    if not FenixElite.CanInteract(true, true, true, true, true, true) then return end
    
    local config = {
        ped = true,
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        components = true,
        props = true,
        allowExit = true,
        tattoos = true
    }

    exports['fivem-appearance']:startPlayerCustomization(function (appearance)
        if appearance then
            SetResourceKvp("fenix_skin", json.encode(appearance))
            TriggerServerEvent("fenix:skin:update", appearance)
        end
    end, config)
end, false)

RegisterCommand("outfit", function(_, args)
    local name = args[1]
    if not name then
        FenixElite.Functions.Notify("Non hai inserito il nome dell'outfit! Comando esatto: /outfit [nome]", "error")
        return
    end

    for _, v in pairs(FenixElite.Outfits) do
        if v["Nome"] == name then
            SetResourceKvp("fenix_skin", json.encode(v))
            exports["fivem-appearance"]:setPlayerAppearance(v)
            TriggerServerEvent("fenix:skin:update", v)
            FenixElite.Functions.Notify("Outfit caricato con successo!")
            return
        end
    end
end, false)

RegisterCommand("loadoutfit", function(_, args)
    local name = args[1]
    if not name then
        FenixElite.Functions.Notify("Non hai inserito il nome dell'outfit! Comando esatto: /loadoutfit [nome]", "error")
        return
    end

    for _, v in pairs(FenixElite.Outfits) do
        if v["Nome"] == name then
            local currWeapon = GetSelectedPedWeapon(cache.ped)
            SetResourceKvp("fenix_skin", json.encode(v))
            exports["fivem-appearance"]:setPlayerAppearance(v)
            TriggerServerEvent("fenix:skin:update", v)
            FenixElite.Functions.Notify("Outfit caricato con successo!")
            Wait(200)
            GiveWeaponToPed(cache.ped, currWeapon, 1000, false, true)
            return
        end
    end
end, false)

RegisterCommand("copyoutfit", function(_, args)
    local id = args[1]
    if not id or not tonumber(id) then
        FenixElite.Functions.Notify("Non hai inserito l'id del giocatore! Comando esatto: /copyoutfit [id]", "error")
        return
    end

    local userSkin = lib.callback.await("fenix:getOutfit", 100, tonumber(id))
    if userSkin then
        local currWeapon = GetSelectedPedWeapon(cache.ped)
        exports["fivem-appearance"]:setPlayerAppearance(userSkin)
        TriggerServerEvent("fenix:skin:update", userSkin)
        FenixElite.Functions.Notify("Outfit caricato con successo!")
        Wait(200)
        GiveWeaponToPed(cache.ped, currWeapon, 1000, false, true)
    else
        FenixElite.Functions.Notify("Utente non trovato!")
    end
end, false)

lib.callback.register("fenix:getPlayerSkin", function()
    return exports["fivem-appearance"]:getPedAppearance(cache.ped)
end)

CreateThread(function ()
    Wait(2000)
    local ECM = exports["FenixElite"]

    ECM:Register(function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
        if (not DoesEntityExist(hitEntity) or not (IsEntityAPed(hitEntity) and IsPedAPlayer(hitEntity))) then
            return
        end

        local ply = hitEntity
        local sId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ply))
        local Header = ECM:AddItem(0, "Name: ".. Player(sId).state.discordName)
        local itemDelete = ECM:AddItem(0, "Copy Outfit")
        local item1v1 = ECM:AddItem(0, "Request 1v1")
        local itemInvite = ECM:AddItem(0, "Invite Party")
        local itemFriend = ECM:AddItem(0, "Add Friend")
        local reportUser = ECM:AddItem(0, "Report")

        ECM:OnActivate(reportUser, function()
            if DoesEntityExist(ply) then
                local input = lib.inputDialog('Fenix Elite', {'Reason'})

                if not input or not input[1] then
                    return
                end

                TriggerServerEvent("fenix:makeReport", sId, input[1])
            end
        end)

        ECM:OnActivate(itemDelete, function()
            if DoesEntityExist(ply) then
                local currWeapon = GetSelectedPedWeapon(cache.ped)
                local data = exports["fivem-appearance"]:getPedAppearance(ply)
                if not data then return end

                SetResourceKvp("fenix_skin", json.encode(data))
                exports["fivem-appearance"]:setPlayerAppearance(data)
                TriggerServerEvent("fenix:skin:update", data)
                Wait(200)
                GiveWeaponToPed(cache.ped, currWeapon, 1000, false, true)
            end
        end)

        ECM:OnActivate(item1v1, function()
            if DoesEntityExist(ply) then
                ExecuteCommand("1v1 ".. sId)
            end
        end)

        ECM:OnActivate(itemInvite, function()
            if DoesEntityExist(ply) then
                TriggerServerEvent("fenix:sendinvite", sId)
            end
        end)

        ECM:OnActivate(itemFriend, function()
            if DoesEntityExist(ply) then
                TriggerServerEvent("fenix:amici:mandaRichiesta", Player(sId).state.discordName)
            end
        end)
    end)
end)