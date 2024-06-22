FenixElite = FenixElite or {}
FenixElite.animRadio = FenixElite.animRadio or {}

FenixElite.animRadio.radio = nil

FenixElite.EnableRadio = false
FenixElite.EnableCrouch = false

local ListaAnims = {
    {
        dict = 'random@arrests',
        anim = 'generic_radio_chatter',
        image = "https://cdn.discordapp.com/attachments/597182139129266177/1150923749214933022/Video_senza_titolo_-_Realizzato_con_Clipchamp_1.mp4"
    },
    {
        dict = 'amb@code_human_police_investigate@idle_a',
        anim = 'idle_b',
        image = "https://cdn.discordapp.com/attachments/597182139129266177/1150923744215302174/Video_senza_titolo_-_Realizzato_con_Clipchamp_2.mp4"
    },
    {
        dict = 'random@arrests',
        anim = 'generic_radio_enter',
        image = "https://cdn.discordapp.com/attachments/597182139129266177/1150923745247109181/Video_senza_titolo_-_Realizzato_con_Clipchamp_3.mp4",
        prop = {
            prop = `prop_serto_radio_black`,
            bone = 60309,
            pos = vec3(0.06, 0.01, 0.00),
            rot = vec3(-90.0, 30.0, 0.0),
        },
    },
    {
        dict = 'cellphone@str',
        anim = 'cellphone_call_listen_a',
        image = "https://cdn.discordapp.com/attachments/597182139129266177/1150923746253754419/Video_senza_titolo_-_Realizzato_con_Clipchamp_4.mp4",
        prop = {
            prop = `prop_serto_radio_black`,
            bone = 28422,
            pos = vec3(0.0, 0.0, 0.0),
            rot = vec3(0.0, 0.0, 0.0),
        },
    },
    {
        dict = 'anim@move_m@security_guard',
        anim = 'idle_var_02',
        image = "https://cdn.discordapp.com/attachments/597182139129266177/1150923747369427024/Video_senza_titolo_-_Realizzato_con_Clipchamp_5.mp4"
    },
    {
        dict = 'anim@cellphone@in_car@ds',
        anim = 'cellphone_text_to_call',
        image = "https://cdn.discordapp.com/attachments/597182139129266177/1150923748266999859/Video_senza_titolo_-_Realizzato_con_Clipchamp_6.mp4"
    },
}

RegisterNetEvent("FenixElite:PlayerCaricato", function()
    FenixElite.animRadio.radio = GetResourceKvpInt("fenix:radio:anim") or 1

    FenixElite.SelectedAnim = ListaAnims[FenixElite.animRadio.radio] or ListaAnims[1]
end)

--[[ RegisterNUICallback('setRadio', function(data, cb)
    data = tonumber(data)
    SetResourceKvpInt("fenix:radio:anim", data)
    FenixElite.animRadio.radio = data

    FenixElite.SelectedAnim = ListaAnims[data] or ListaAnims[1]

    cb(true)
end)

RegisterNUICallback('getRadio', function(data, cb)
    cb(FenixElite.animRadio.radio)
end) ]]

local calculateOptions = function()
    local options = {}

    for k, v in pairs(ListaAnims) do
        table.insert(options, {
            title = (FenixElite.animRadio.radio == k and "✅" or "❌") .. "Animation: ".. k,
            onSelect = function()
                FenixElite.SelectedAnim = v
                FenixElite.animRadio.radio = k
                SetResourceKvpInt("fenix:radio:anim", k)

                ExecuteCommand("_radioAnimation")
            end,
            image = v.image
        })
    end

    return options
end

RegisterCommand("_radioAnimation", function()
    lib.registerContext({
        id = 'anim_radio',
        title = 'Anim Radio',
        options = calculateOptions()
    })

    lib.showContext('anim_radio')
end, false)

RegisterKeyMapping("_radioAnimation", "Select radio animation", "keyboard", "f4")

local ImUsingRadio = false
local TimeoutRadio = false

RegisterCommand("+radioAnim", function()
    if ImUsingRadio then return end
    if TimeoutRadio then return end
    if not FenixElite.EnableRadio then return end
    if FenixElite.InMatch or FenixElite.IsInDeathmatch or FenixElite.InRedzone or FenixElite.InFreeroam then
        local AnimDict = FenixElite.SelectedAnim.dict or 'random@arrests'
        local propInfo = FenixElite.SelectedAnim.prop

        while not HasAnimDictLoaded(AnimDict) do
            RequestAnimDict(AnimDict)
            Wait(100)
        end

        if propInfo then
            local pHash = propInfo.prop
            if pHash then
                RequestModel(pHash)
                while not HasModelLoaded(pHash) do Wait(125) end
                FenixElite.CurrentProp = CreateObject(pHash, 0.0, 0.0, 0.0, false, true, false)
                SetEntityCollision(FenixElite.CurrentProp, false, false)
                AttachEntityToEntity(FenixElite.CurrentProp, playerPed, GetPedBoneIndex(playerPed, propInfo.bone), propInfo.pos, propInfo.rot, false, false, false, false, 2, true)
                SetModelAsNoLongerNeeded(FenixElite.CurrentProp)
            end
        end

        TaskPlayAnim(cache.ped, AnimDict, (FenixElite.SelectedAnim.anim or 'generic_radio_chatter'), 8.0, 2.5, -1, 50, 0, 0, 0, 0)
        ImUsingRadio = true
    end
end)

RegisterCommand("-radioAnim", function()
    if ImUsingRadio then
        ImUsingRadio = false
        StopAnimTask(cache.ped, (FenixElite.SelectedAnim.dict or 'random@arrests'), (FenixElite.SelectedAnim.anim or 'generic_radio_chatter'), 1.0)
        if DoesEntityExist(FenixElite.CurrentProp) then
            NetworkRequestControlOfEntity(FenixElite.CurrentProp)
            while not NetworkHasControlOfEntity(FenixElite.CurrentProp) do Wait(150) end
            SetEntityAsMissionEntity(FenixElite.CurrentProp, false, false)
            DeleteObject(FenixElite.CurrentProp)
        end

        TimeoutRadio = true
        SetTimeout(250, function()
            TimeoutRadio = false
        end)
    end
end)

RegisterKeyMapping("+radioAnim", "Use radio", "keyboard", "LMENU")

CreateThread(function()
    RequestAnimSet("move_ped_crouched")
    while not HasAnimSetLoaded("move_ped_crouched") do
        Wait(100)
    end
end)

local isCrouched = false
RegisterCommand('crouched', function()
    if not FenixElite.EnableCrouch then return end
    if isCrouched then
        isCrouched = false
        ResetPedMovementClipset(cache.ped, 0.25)
    else
        SetPedMovementClipset(cache.ped, "move_ped_crouched", 0.25)
        isCrouched = true
    end
end, false)

RegisterKeyMapping('crouched', 'Crouch', 'keyboard', 'LCONTROL')