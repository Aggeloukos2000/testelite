FenixElite = FenixElite or {}
FenixElite.Amici = {}
FenixElite.RichiesteAmici = {}

RegisterNetEvent("fenix:amici:aggiungiRichiesta", function(username, avatarUrl)
    table.insert(FenixElite.RichiesteAmici, {username = username, avatarUrl = avatarUrl})
    SendReactMessage("aggiungiRichiesta", {username = username, avatarUrl = avatarUrl})
end)

RegisterNetEvent("fenix:amici:rimuoviRichiesta", function(username)
    for k, v in pairs(FenixElite.RichiesteAmici) do
        if v.username == username then
            table.remove(FenixElite.RichiesteAmici, k)
            break
        end
    end
    SendReactMessage("rimuoviRichiesta", username)
end)

RegisterNUICallback('getFriendsList', function(data, cb)
    cb(FenixElite.RichiesteAmici)
end)

RegisterNUICallback('invitaAmico', function(data, cb)
    TriggerServerEvent("fenix:sendinvite", data)
    cb(true)
end)

RegisterNetEvent("fenix:amici:forzaUpdateAmici", function(trg)
    local data = lib.callback.await("fenix:amici:listaAmici", 100)
    table.sort(data, function(a, b)
        if a.Online and not b.Online then
            return true
        elseif not a.Online and b.Online then
            return false
        else
            return a.username < b.username
        end
    end)
    FenixElite.Chaching.SaveData("allFriends", data)
    SendReactMessage("updateAllFriends", data)
end)

RegisterNUICallback('getAllFriends', function(data, cb)
    local cacheData = FenixElite.Chaching.CheckData("allFriends")
    if cacheData then
        cb(cacheData)
    else
        local data = lib.callback.await("fenix:amici:listaAmici", 100)
        table.sort(data, function(a, b)
            if a.Online and not b.Online then
                return true
            elseif not a.Online and b.Online then
                return false
            else
                return a.username < b.username
            end
        end)
        FenixElite.Chaching.SaveData("allFriends", data)
        cb(data)
    end
end)

RegisterNUICallback('aggiungiAmico', function(data, cb)
    TriggerServerEvent("fenix:amici:mandaRichiesta", data)
    cb(true)
end)

RegisterNUICallback('accettaRichiesta', function(data, cb)
    TriggerServerEvent("fenix:amici:accettaRichiesta", data)
    cb(true)
end)

RegisterNUICallback('rifiutaRichiesta', function(data, cb)
    TriggerServerEvent("fenix:amici:rifiutaRichiesta", data)
    cb(true)
end)

RegisterNUICallback('rimuoviAmico', function(data, cb)
    TriggerServerEvent("fenix:amici:rimuoviAmicizia", data)
    cb(true)
end)

RegisterNUICallback('getAllReqs', function(data, cb)
    cb(FenixElite.RichiesteAmici)
end)

RegisterNetEvent("FenixElite:PlayerCaricato", function(data)
    Wait(2000)
    if data.RichiesteAmici then
        FenixElite.RichiesteAmici = data.RichiesteAmici
    end
end)

RegisterNetEvent("fenix:amici:rimuoviAmico", function(username)
    SendReactMessage("rimuoviAmico", username)
end)