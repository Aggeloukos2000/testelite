FenixElite = FenixElite or {}
FenixElite.Functions = {}
FenixElite.Chaching = {}
FenixElite.Chaching.Saved = {}

function SendReactMessage(action, data)
  SendNUIMessage({
    action = action,
    data = data
  })
end

local currentResourceName = GetCurrentResourceName()
local debugIsEnabled = GetConvarInt(('%s-debugMode'):format(currentResourceName), 0) == 1

function debugPrint(...)
  if not debugIsEnabled then return end
  local args <const> = { ... }
  local appendStr = ''
  for _, v in ipairs(args) do
    appendStr = appendStr .. ' ' .. tostring(v)
  end
  local msgTemplate = '^3[%s]^0%s'
  local finalMsg = msgTemplate:format(currentResourceName, appendStr)
  print(finalMsg)
end

FenixElite.Functions.Notify = function(msg, time)
  msg = msg or "Messaggio"
  time = time or 5000
  exports['Fenix_Notify']:Noti("error", "Fenix Elite", msg:gsub("~(.-)~", ""), time, "right")
end

RegisterNetEvent("fenix:notifica", function(msg, time)
  FenixElite.Functions.Notify(msg, time)
end)

FenixElite.Chaching.SaveData = function(key, data)
  FenixElite.Chaching.Saved[key] = {}
  FenixElite.Chaching.Saved[key].Data = data
  FenixElite.Chaching.Saved[key].LastUpdate = GetGameTimer()
end

FenixElite.Chaching.CheckData = function(key)
  if not FenixElite.Chaching.Saved[key] then
    return false
  end
  if (GetGameTimer() - FenixElite.Chaching.Saved[key].LastUpdate) > 20 * 1000 then
    return false
  else
    return FenixElite.Chaching.Saved[key].Data
  end
end

FenixElite.GetTranslation = function(str)
  if FenixLanguage[FenixElite.PlayerData.Lingua] then
    if FenixLanguage[FenixElite.PlayerData.Lingua][str] then
      return FenixLanguage[FenixElite.PlayerData.Lingua][str]
    else
      return str
    end
  else
    return str
  end
end