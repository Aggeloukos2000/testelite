FenixElite = FenixElite or {}
FenixElite.Party = {}
FenixElite.Party.Invites = {}
FenixElite.Party.IsOwner = false

RegisterNetEvent("fenix:invitaArrivato", function(rUsername, rId, rAvatarURL)
    table.insert(FenixElite.Party.Invites, {id = rId, username = rUsername, avatarURL = rAvatarURL})
    SendReactMessage('aggiungiInvito', {
        id = rId,
        username = rUsername,
        avatarURL = rAvatarURL
    })
end)

RegisterNetEvent("fenix:invitoRimosso", function(rId)
    for k, v in pairs(FenixElite.Party.Invites) do
        if v.id == rId then
            table.remove(FenixElite.Party.Invites, k)
            break
        end
    end
    SendReactMessage('rimuoviInvito', rId)
end)

RegisterNetEvent("fenix:esciParty", function()
  print("Uscendo...")
    FenixElite.Party.CurrentData = nil
    SendReactMessage('aggiornaMembri', {})
    SendReactMessage('impostaLeader', false)
end)

RegisterNetEvent("fenix:partyPlayerRemoved", function(uId)
    for k, v in pairs(FenixElite.Party.CurrentData.Membri) do
        if v.id == uId then
            table.remove(FenixElite.Party.CurrentData.Membri, k)
            break
        end
    end

    table.sort(FenixElite.Party.CurrentData.Membri, function (a, b)
        if a.isOwner then
          return true
        elseif b.isOwner then
          return false
        elseif a.id and b.id then
          return a.id < b.id
        elseif a.id then
          return true
        elseif b.id then
          return false
        else
          return false
        end
    end)

    SendReactMessage('aggiornaMembri', FenixElite.Party.CurrentData.Membri)
end)

RegisterNetEvent("fenix:entrataParty", function(pData, queue)
    FenixElite.Party.CurrentData = pData
    FenixElite.CurrentMatchType = FenixElite.Party.CurrentData.currMatch
    local isOwner = false
    for k, v in pairs(FenixElite.Party.CurrentData.Membri) do
        if v.id == cache.serverId then
            if v.isOwner then
                isOwner = true
            end
            break
        end
    end

    table.sort(FenixElite.Party.CurrentData.Membri, function (a, b)
        if a.isOwner then
          return true
        elseif b.isOwner then
          return false
        elseif a.id and b.id then
          return a.id < b.id
        elseif a.id then
          return true
        elseif b.id then
          return false
        else
          return false
        end
    end)

    FenixElite.Party.IsOwner = isOwner
    SendReactMessage('aggiornaMembri', FenixElite.Party.CurrentData.Membri)
    SendReactMessage('changeMatchData', FenixElite.Party.CurrentData.currMatch)
    SendReactMessage('changeQueuePlayers', queue)
    SendReactMessage('impostaLeader', isOwner)
end)

RegisterNUICallback('getListaInviti', function(data, cb)
    repeat
        Wait(100)
    until FenixElite.Party

    cb(FenixElite.Party.Invites or {})
end)

RegisterNUICallback('getPartyData', function(data, cb)
    repeat
        Wait(100)
    until FenixElite.Party.CurrentData

    cb(FenixElite.Party.CurrentData.Membri or {})
end)

RegisterNUICallback('isPartyOwner', function(data, cb)
    local party = FenixElite.Party or {}
    cb((party.IsOwner or false))
end)

RegisterNUICallback('esciDalParty', function(data, cb)
    TriggerServerEvent("fenix:party:esci")
end)