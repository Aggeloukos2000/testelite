FenixElite = FenixElite or {}
FenixElite.StreamerMode = {}
FenixElite.StreamerMode.SavedUsername = nil

RegisterNUICallback('setStreamerMode', function(data, cb)
    if data then
        TriggerServerEvent("fenix:streamerMode", data)
        FenixElite.StreamerMode.SavedUsername = FenixElite.PlayerData.DiscordName
        FenixElite.PlayerData.DiscordName = "Unknown"

        SendReactMessage('updateUserData', {avatarUrl = FenixElite.PlayerData.AvatarURL, stats = FenixElite.PlayerData.Stats, bannerUrl = FenixElite.PlayerData.BannerURL, username = FenixElite.PlayerData.DiscordName})
    else
        TriggerServerEvent("fenix:streamerMode", data)

        FenixElite.PlayerData.DiscordName = FenixElite.StreamerMode.SavedUsername
        SendReactMessage('updateUserData', {avatarUrl = FenixElite.PlayerData.AvatarURL, stats = FenixElite.PlayerData.Stats, bannerUrl = FenixElite.PlayerData.BannerURL, username = FenixElite.PlayerData.DiscordName})
    end

    cb(true)
end)

RegisterNUICallback('getStreamerMode', function(_, cb)
    cb(FenixElite.PlayerData.StreamerMode)
end)