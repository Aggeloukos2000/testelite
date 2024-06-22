local disableNui = false
FenixElite.InMatchmaking = false
FenixElite.CurrentMatchType = 1
FenixElite.MenuOpened = false

function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SetNuiFocusKeepInput(shouldShow)
  SendReactMessage('setVisible', shouldShow)
  FenixElite.MenuOpened = shouldShow

  if shouldShow then
    CreateThread(function()
      while FenixElite.MenuOpened do
        DisableAllControlActions(0)
        Wait(0)
      end
    end)
  end
end

RegisterCommand("fixNui", function ()
  SetNuiFocus(false, false)
  SendReactMessage('setVisible', false)
end)

exports('IsMenuOpen', function()
  return FenixElite.MenuOpened
end)

exports("toggleNuiFrame", toggleNuiFrame)

RegisterCommand('apriFenix', function()
  if FenixElite.MenuOpened then
    toggleNuiFrame(false)
    return
  end

  if FenixElite.Check.State then
    return
  end

  if (not FenixElite.IsInDeathmatch and not FenixElite.IsInCorsaArmi and not disableNui and not FenixElite.InMatch and not FenixElite.InFreeroam and not FenixElite.InRedzone) then
    toggleNuiFrame(true)
  end
end)

RegisterNUICallback('hideFrame', function(_, cb)
  toggleNuiFrame(false)
  cb({})
end)

RegisterNUICallback('getUserData', function(data, cb)
  repeat
    Wait(100)
  until FenixElite.PlayerData ~= nil
  cb({avatarUrl = FenixElite.PlayerData.AvatarURL, stats = FenixElite.PlayerData.Stats, bannerUrl = FenixElite.PlayerData.BannerURL, username = FenixElite.PlayerData.DiscordName})
end)

RegisterNUICallback('getIsAdmin', function(data, cb)
  repeat
    Wait(100)
  until FenixElite.PlayerData ~= nil

  cb(FenixElite.PlayerData.isAdmin)
end)

RegisterNUICallback('getAllUsers', function(data, cb)
  local rst = lib.callback.await("fenix:listaplayer", false)
  cb(rst)
end)

RegisterNUICallback('sendInvite', function(data, cb)
  TriggerServerEvent("fenix:sendinvite", data.value)
  cb(true)
end)

RegisterNUICallback('acceptInvite', function(data, cb)
  TriggerServerEvent("fenix:acceptInvite", data)
  cb(true)
end)

RegisterNUICallback('kickPlayer', function(data, cb)
  TriggerServerEvent("fenix:espelli", data)
  cb(true)
end)

RegisterNUICallback('promuoviPlayer', function(data, cb)
  TriggerServerEvent("fenix:mettiLeader", data)
  cb(true)
end)

RegisterNUICallback('enterInMatchmaking', function(data, cb)
  print(data)
  if data.currMatch == "custom" then
    TriggerServerEvent("fenix:enterCustomMatchmaking", data.currMembers, data.otherData)
  else
    TriggerServerEvent("fenix:enterMatchmaking", data.currMatch)
  end

  cb(true)
end)

RegisterNetEvent("FenixElite:TogliMatchmaking", function()
  SendReactMessage('togliMatchmaking')
  FenixElite.InMatchmaking = false
end)

RegisterNetEvent("FenixElite:MettiMatchmaking", function()
  SendReactMessage('mettiMatchmaking')
  FenixElite.InMatchmaking = true
end)

RegisterNUICallback('getMatchmaking', function(data, cb)
  cb(FenixElite.InMatchmaking)
end)

RegisterNUICallback('exitMatchmaking', function(data, cb)
  TriggerServerEvent("fenix:exitMatchmaking")
  cb(true)
end)

RegisterNUICallback('setCurrentMatch', function(data, cb)
  TriggerServerEvent("fenix:setCurrentMatch", data)
  cb(true)
end)

RegisterNUICallback('getLeaderboardData', function(data, cb)
  local cacheData = FenixElite.Chaching.CheckData("LeaderboardData")
  if cacheData then
    cb(cacheData)
  else
    local data = lib.callback.await("fenix:getLeaderboard", 100)
    FenixElite.Chaching.SaveData("LeaderboardData", data)
    cb(data)
  end
end)

RegisterNUICallback('getListaRichieste', function(data, cb)
  local cacheData = FenixElite.Chaching.CheckData("listaRichieste")
  if cacheData then
    cb(cacheData)
  else
    local data = lib.callback.await("fenix:amici:listaRichieste", 100)
    FenixElite.Chaching.SaveData("listaRichieste", data)
    cb(data)
  end
end)

RegisterNUICallback('isInMatch', function(data, cb)
  cb(FenixElite.InMatch)
end)

RegisterNUICallback('getDataForMatch', function(data, cb)
  cb(FenixElite.Match.AllPlayers)
end)

RegisterNetEvent("FenixElite:UpdateMatchmaking", function(mQueues)
  local matchType = tostring(FenixElite.CurrentMatchType)
  if matchType == "fuente" then
    matchType = "6"
  end
  
  if mQueues and mQueues[matchType] then
    SendReactMessage('changeQueuePlayers', mQueues[matchType])
  end
end)

RegisterNetEvent("fenix:reciveMatchData", function(match, queue)
  SendReactMessage('changeMatchData', match)
  SendReactMessage('changeQueuePlayers', queue)
  FenixElite.CurrentMatchType = match

  if FenixElite.Party and FenixElite.Party.CurrentData and FenixElite.Party.CurrentData.Membri and match ~= "custom" then
    local newMembri = {}
    for k, v in pairs(FenixElite.Party.CurrentData.Membri) do
      table.insert(newMembri, v)
    end

    table.sort(newMembri, function (a, b)
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

    FenixElite.Party.CurrentData.Membri = newMembri
    SendReactMessage('aggiornaMembri', FenixElite.Party.CurrentData.Membri)
  end
end)

RegisterNetEvent("fenix:updateStats", function(newStats)
  FenixElite.PlayerData.Stats = newStats
  SendReactMessage('updateUserData', {avatarUrl = FenixElite.PlayerData.AvatarURL, stats = FenixElite.PlayerData.Stats, bannerUrl = FenixElite.PlayerData.BannerURL, username = FenixElite.PlayerData.DiscordName})
end)

RegisterNetEvent("fenix:aggiornaPunteggio", function(a, b)
  SendReactMessage("updateScoreA", a)
  SendReactMessage("updateScoreB", b)
end)

exports("disableNui", function(bool)
  disableNui = bool
end)