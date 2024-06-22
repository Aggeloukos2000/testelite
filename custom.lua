RegisterNUICallback("spostaTeam", function(data, cb)
    TriggerServerEvent("fenix:spostaTeam", data)
end)

RegisterNetEvent("fenix:spostaTeam", function(user, newIndex)
    if FenixElite.Party.CurrentData.Membri then
        local data
        if FenixElite.Party.CurrentData.Membri[newIndex] and #FenixElite.Party.CurrentData.Membri[newIndex] > 0 then return end

        for k, v in pairs(FenixElite.Party.CurrentData.Membri) do
            if v.id == user then
                data = v
                FenixElite.Party.CurrentData.Membri[k] = {}
                break
            end
        end

        if data then
            FenixElite.Party.CurrentData.Membri[newIndex] = data
        end

        SendReactMessage("aggiornaMembri", FenixElite.Party.CurrentData.Membri)
    end
end)