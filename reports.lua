FenixElite.CurrReports = {}

RegisterNetEvent("fenix:addReport", function(newReport)
    table.insert(FenixElite.CurrReports, newReport)
    SendReactMessage("updateReports", FenixElite.CurrReports)

    FenixElite.Functions.Notify("NEW REPORT!<br />Player:".. newReport.trg .."<br />ID: ".. newReport.trgSurce .."<br />Reason: ".. newReport.reason)
end)

RegisterNetEvent("fenix:report:remove", function(rId)
    table.remove(FenixElite.CurrReports, rId)

    SendReactMessage("updateReports", FenixElite.CurrReports)
end)

RegisterNUICallback('getReports', function(_, cb)
    if not FenixElite.CurrReports or #FenixElite.CurrReports <= 0 then
        FenixElite.CurrReports = lib.callback.await("fenix:getReports", 100)
    end

    cb(FenixElite.CurrReports)
end)

RegisterNUICallback('closeReport', function(data, cb)
    TriggerServerEvent("fenix:closeReport", data)
    cb(true)
end)

RegisterNUICallback('reportTeleport', function(data, cb)
    TriggerServerEvent("fenix:reportTeleport", data)
    cb(true)
end)

local ReportTimeout = false

RegisterCommand("report", function(src, args)
    if ReportTimeout then
        FenixElite.Functions.Notify("Wait 30 seconds to send another report")
        return
    end
    
    local trg = tonumber(args[1])
    local reason = table.concat(args, " ", 2)

    if not trg or not reason then
        FenixElite.Functions.Notify("You didn't enter the player ID or the reason! Exact command: /report [id] [reason]")
        return
    end

    if reason == "" or reason == " " then
        FenixElite.Functions.Notify("You didn't enter the reason! Exact command: /report [id] [reason]")
        return
    end

    if trg == src then
        FenixElite.Functions.Notify("You can't report yourself!")
        return
    end

    ReportTimeout = true
    TriggerServerEvent("fenix:makeReport", trg, reason)
    Wait(30000)
    ReportTimeout = false
end, false)