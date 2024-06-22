local fps = false
RegisterCommand("fps", function()
    fps = not fps
    if fps then
        FPS()
        FenixElite.Functions.Notify("FPS BOOST [ON]")
    else
        FenixElite.Functions.Notify("FPS BOOST [OFF]")
    end
end)

FPS = function ()
    CreateThread(function()
        while fps do
            SetTimecycleModifier("cinema")
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
            Wait(1000)
        end
        SetTimecycleModifier("default")
    end)
end