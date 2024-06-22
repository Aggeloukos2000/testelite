lib.callback.register('fenix:richiesta1v1', function(username)
    return lib.alertDialog({
        header = 'FenixElite',
        content = FenixElite.GetTranslation("request_1v1"):format(username),
        centered = true,
        cancel = true
    })
end)

RegisterNetEvent("fenix:entraMatchmaking1v1", function()
    TriggerServerEvent("fenix:enterMatchmaking", "1")
end)