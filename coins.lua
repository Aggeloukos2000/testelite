FenixElite.Coins = {}
FenixElite.Coins.CurrValue = 0

RegisterNetEvent("fenix:updateCoins", function(newCoins)
    FenixElite.Coins.CurrValue = newCoins
    SendReactMessage('updateCoins', newCoins)
end)

RegisterNUICallback('getCoins', function(_, cb)
    cb(FenixElite.Coins.CurrValue)
end)

RegisterNUICallback('getAllItems', function(_, cb)
    cb(FenixItems)
end)

RegisterNUICallback('fenix:AcquistoItem', function(label, cb)
    TriggerServerEvent("FenixElite:Coins:BuyItem", label)
    cb(false)
end)

RegisterCommand("_AnimMenu", function (source, args, raw)
    local formattedAnims = {}
    for i = 1, #FenixElite.Items.List do
        table.insert(formattedAnims, {
            title = FenixItems[FenixElite.Items.List[i]].label,
            value = i,
            onSelect = function ()
                FenixElite.Coins.PlayAnim(FenixElite.Items.List[i])
            end,
            image = FenixItems[FenixElite.Items.List[i]].img
        })
    end

    lib.registerContext({
        id = 'anim_menu',
        title = 'Animation Menu',
        options = formattedAnims
    })

    lib.showContext('anim_menu')
end)

RegisterKeyMapping("_AnimMenu", "Open animation menu", "keyboard", "F5")

local PlayingEmote = false
FenixElite.Coins.PlayAnim = function(index)
    local CurrAnim = FenixItems[index]
    FenixElite.LoadAnim(CurrAnim.dict)
    TaskPlayAnim(cache.ped, CurrAnim.dict, CurrAnim.clip, 2.0, 2.0, -1, 1, 0, false, false, false)

    PlayingEmote = true
end

RegisterCommand("_StopAnim", function()
    if PlayingEmote then
        PlayingEmote = false
        ClearPedTasks(cache.ped)
    end
end)

RegisterKeyMapping("_StopAnim", "Stop playing emote", "keyboard", "x")