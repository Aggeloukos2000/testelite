FenixElite = FenixElite or {}
FenixElite.Check = {}
FenixElite.Check.State = false

RegisterNetEvent("fenix:check:update", function(state)
    FenixElite.Check.State = state
end)