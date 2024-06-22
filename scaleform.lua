FenixElite = FenixElite or {}
FenixElite.Scaleform = {}

function FenixElite.Scaleform.showCountdown(_number, _r, _g, _b)
    local scaleform = FenixElite.Scaleform.Request('COUNTDOWN')
    FenixElite.Scaleform.CallFunction(scaleform, false, "SET_MESSAGE", _number, _r, _g, _b, true)
    FenixElite.Scaleform.CallFunction(scaleform, false, "FADE_MP", _number, _r, _g, _b)
    return scaleform
end

FenixElite.Scaleform.ShowBanner = function(_text1, _text2)
    local showCD = true
    local scaleform = FenixElite.Scaleform.Request('MP_BIG_MESSAGE_FREEMODE')
    FenixElite.Scaleform.CallFunction(scaleform, false, "SHOW_SHARD_CENTERED_MP_MESSAGE")
    FenixElite.Scaleform.CallFunction(scaleform, false, "SHARD_SET_TEXT", _text1, _text2, 0)
    CreateThread(function()
        Wait((tonumber(5) * 1000) - 400)
        FenixElite.Scaleform.CallFunction(scaleform, false, "SHARD_ANIM_OUT", 2, 0.4, 0)
        Wait(400)
        showCD = false
    end)
    CreateThread(function()
        while showCD do
            Wait(1)
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
        end
    end)
end

function FenixElite.Scaleform.ShowSplashText(_text1, _fadeout, time)
    local showST = true

    CreateThread(function ()
        Wait(time * 1000)
        showST = false
    end)

    local function drackSplashText(text1, fade)
        local scaleform = FenixElite.Scaleform.Request('SPLASH_TEXT')

        FenixElite.Scaleform.CallFunction(scaleform, false, "SET_SPLASH_TEXT", text1, 5000, 255, 255, 255, 255)
        FenixElite.Scaleform.CallFunction(scaleform, false, "SPLASH_TEXT_LABEL", text1, 255, 255, 255, 255)
        FenixElite.Scaleform.CallFunction(scaleform, false, "SPLASH_TEXT_COLOR", 255, 255, 255, 255)
        FenixElite.Scaleform.CallFunction(scaleform, false, "SPLASH_TEXT_TRANSITION_OUT", fade, 0)

        return scaleform
    end

    local scale = drackSplashText(_text1, _fadeout)
    while showST do
        Wait(1)
        DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
    end
end

FenixElite.Scaleform.Countdown = function(_r, _g, _b, _waitTime, _playSound)
    local showCD = true
    local time = _waitTime
    local scale = 0
    if _playSound ~= nil and _playSound == true then
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end
    scale = FenixElite.Scaleform.showCountdown(time, _r, _g, _b)
    CreateThread(function()
        while showCD do
            Wait(1000)
            if time > 1 then
                time = time - 1
                scale = FenixElite.Scaleform.showCountdown(time, _r, _g, _b)
            elseif time == 1 then
                time = time - 1
                scale = FenixElite.Scaleform.showCountdown("GO", _r, _g, _b)
            else
                showCD = false
            end
        end
    end)
    CreateThread(function()
        while showCD do
            Wait(1)
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end)
end

function FenixElite.Scaleform.Request(scaleform)
    local scaleform_handle = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform_handle) do
        Wait(0)
    end
    return scaleform_handle
end

function FenixElite.Scaleform.CallFunction(scaleform, returndata, the_function, ...)
    BeginScaleformMovieMethod(scaleform, the_function)
    local args = {...}
    if args ~= nil then
        for i = 1,#args do
            local arg_type = type(args[i])

            if arg_type == "boolean" then
                ScaleformMovieMethodAddParamBool(args[i])
            elseif arg_type == "number" then
                if not string.find(args[i], '%.') then
                    ScaleformMovieMethodAddParamInt(args[i])
                else
                    ScaleformMovieMethodAddParamFloat(args[i])
                end
            elseif arg_type == "string" then
                ScaleformMovieMethodAddParamTextureNameString(args[i])
            end
        end
        if not returndata then
            EndScaleformMovieMethod()
        else
            return EndScaleformMovieMethodReturnValue()
        end
    end
end