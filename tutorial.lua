FenixElite = FenixElite or {}
FenixElite.InTutorial = false

FenixElite.IniziaTutorial = function ()
    Wait(1000)
    print("Started")
    FenixElite.InTutorial = true
    SetEntityVisible(cache.ped, false, false)
    NetworkStartSoloTutorialSession()

    while NetworkIsTutorialSessionChangePending() do
        Wait(100)
    end

    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_FLY_CAMERA", 288.8044, -1600.9761, 31.2629 + 300, -90.00, 0.00, 280.4711, 100.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    Wait(1000)
    SetCamActive(cam, false)

    if not FenixElite.InTutorial then return end

    FenixElite.InTutorialLoop()

    local cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 279.9364, -1555.4797, 46.5941, 0.00, 0.00, 188.1425, 100.00, false, 0)
    SetCamActiveWithInterp(cam2, cam, 5000, true, true)
    DestroyCam(cam, false)
    Wait(5000)

    if not FenixElite.InTutorial then return end
    FenixElite.Scaleform.ShowSplashText("Welcome to ~c~Fenix~r~ Elite", "DIO CANE", 5)

    if not FenixElite.InTutorial then return end

    local camTopTier = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 288.3762, -1599.5844, 36.1410, -20.00, 0.00, 186.2287, 50.00, false, 0)
    SetCamActiveWithInterp(camTopTier, cam2, 5000, true, true)
    Wait(5000)
    FenixElite.ShowHelpNotification("~r~~italic~TopTier~italic~~n~~n~~s~ ".. FenixElite.GetTranslation("toptier_desc"), false, true, 5000)
    Wait(5000)
    DestroyCam(cam2, false)

    if not FenixElite.InTutorial then return end

    local camCommandList = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 297.6743, -1614.9307, 30.5319, -20.00, 0.00, 214.6660, 50.00, false, 0)
    SetCamActiveWithInterp(camCommandList, camTopTier, 4000, true, true)
    Wait(4000)
    FenixElite.ShowHelpNotification("~r~~italic~Command List~italic~~n~~n~~s~ ".. FenixElite.GetTranslation("commands_desc"), false, true, 5000)
    Wait(7000)
    DestroyCam(camTopTier, false)

    if not FenixElite.InTutorial then return end

    local camFenixMenu = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 302.9179, -1608.0834, 32.5316, -20.00, 0.00, 241.1628, 50.00, false, 0)
    SetCamActiveWithInterp(camFenixMenu, camCommandList, 4000, true, true)
    Wait(4000)
    FenixElite.ShowHelpNotification("~r~~italic~Menu Fenix~italic~~n~~n~~s~ ".. FenixElite.GetTranslation("menufenix_desc"), false, true, 5000)
    Wait(7000)
    DestroyCam(camCommandList, false)

    if not FenixElite.InTutorial then return end

    local camAimLab = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 304.9984, -1599.8833, 32.5319, -20.00, 0.00, 274.6129, 50.00, false, 0)
    SetCamActiveWithInterp(camAimLab, camFenixMenu, 4000, true, true)
    Wait(4000)
    FenixElite.ShowHelpNotification("~r~~italic~AimLab~italic~~n~~n~~s~ ".. FenixElite.GetTranslation("aimlab_desc"), false, true, 5000)
    Wait(7000)
    DestroyCam(camFenixMenu, false)

    if not FenixElite.InTutorial then return end

    local camCrosshair = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 302.4875, -1591.5344, 32.5319, -20.00, 0.00, 308.9849, 50.00, false, 0)
    SetCamActiveWithInterp(camCrosshair, camAimLab, 4000, true, true)
    Wait(4000)
    FenixElite.ShowHelpNotification("~r~~italic~Crosshair Editor~italic~~n~~n~~s~".. FenixElite.GetTranslation("crosshair_desc"), false, true, 5000)
    Wait(7000)
    DestroyCam(camAimLab, false)

    if not FenixElite.InTutorial then return end

    local camFreeroam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 295.2754, -1586.7633, 32.5319, -20.00, 0.00, 333.1285, 50.00, false, 0)
    SetCamActiveWithInterp(camFreeroam, camCrosshair, 4000, true, true)
    Wait(4000)
    FenixElite.ShowHelpNotification("~r~~italic~Freeroam~italic~~n~~n~~s~".. FenixElite.GetTranslation("freeroam_desc"), false, true, 5000)
    Wait(7000)
    DestroyCam(camCrosshair, false)

    if not FenixElite.InTutorial then return end

    DestroyCam(camFreeroam, false)
    RenderScriptCams(false, false, 1, false, false)
    SetEntityVisible(cache.ped, true, true)

    FenixElite.InTutorial = false

    local config = {
        ped = true,
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        components = true,
        props = true,
        allowExit = true,
        tattoos = true
    }

    exports['fivem-appearance']:startPlayerCustomization(function (appearance)
        NetworkEndTutorialSession()
        if appearance then
            SetResourceKvp("fenix_skin", json.encode(appearance))
            TriggerServerEvent("fenix:skin:update", appearance)
        end
    end, config)
end

FenixElite.InTutorialLoop = function()
    Scale = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS");
    while not HasScaleformMovieLoaded(Scale) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(Scale, "CLEAR_ALL");
    EndScaleformMovieMethod();

    BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
    ScaleformMovieMethodAddParamInt(0);
    PushScaleformMovieMethodParameterString("~INPUT_EEDF9193~");
    PushScaleformMovieMethodParameterString("Stop Tutorial");
    EndScaleformMovieMethod();

    BeginScaleformMovieMethod(Scale, "DRAW_INSTRUCTIONAL_BUTTONS");
    ScaleformMovieMethodAddParamInt(0);
    EndScaleformMovieMethod();

    CreateThread(function()
        while FenixElite.InTutorial do
            DrawScaleformMovieFullscreen(Scale, 255, 255, 255, 255, 0)
            Wait(1)
        end
    end)
end



RegisterCommand("stopintro", function()
    if not FenixElite.InTutorial then return end
    
    FenixElite.InTutorial = false
    RenderScriptCams(false, false, 1, false, false)
    SetEntityVisible(cache.ped, true, true)
    local config = {
        ped = true,
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        components = true,
        props = true,
        allowExit = true,
        tattoos = true
    }

    exports['fivem-appearance']:startPlayerCustomization(function (appearance)
        NetworkEndTutorialSession()
        if appearance then
            SetResourceKvp("fenix_skin", json.encode(appearance))
            TriggerServerEvent("fenix:skin:update", appearance)
        end
    end, config)
end)

RegisterKeyMapping("stopintro", "Stop Intro", "keyboard", "BACK")