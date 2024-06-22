FenixElite.Redzone = {}

local safeZone = (1.0 - GetSafeZoneSize()) * 0.5
local timerBar = {
  baseX = 0.918,
  baseY = 0.984,
  baseWidth = 0.165,
  baseHeight = 0.035,
  baseGap = 0.080,
  titleX = -0.006,
  titleY = -0.009,
  textX = 0.0785,
  textY = -0.012,
  progressX = 0.047,
  progressY = 0.0015,
  progressWidth = 0.0616,
  progressHeight = 0.0105,
  txtDict = "timerbars",
  txtName = "all_black_bg",
}
local LeaderBoardOn = false

local RedzoneConfig = {

    ["Port"] = {
        coords = {
            vec2(-358.04971313477, -2448.6984863281),
            vec2(-327.00201416016, -2411.0729980469),
            vec2(-314.82598876953, -2422.0498046875),
            vec2(-300.57522583008, -2406.3937988281),
            vec2(-286.05435180664, -2415.8381347656),
            vec2(-298.8427734375, -2433.9204101563),
            vec2(-277.75393676758, -2449.3947753906),
            vec2(-252.40115356445, -2413.4367675781),
            vec2(-243.40327453613, -2418.8364257813),
            vec2(-242.2924041748, -2417.6408691406),
            vec2(-234.78196716309, -2422.8647460938),
            vec2(-227.21308898926, -2428.8188476563),
            vec2(-185.76577758789, -2445.8747558594),
            vec2(-181.91445922852, -2467.7854003906),
            vec2(-177.24868774414, -2496.9147949219),
            vec2(-131.30889892578, -2545.482421875),
            vec2(-108.60059356689, -2587.595703125),
            vec2(-175.88702392578, -2588.3344726563),
            vec2(-175.77717590332, -2605.3989257813),
            vec2(-107.4813079834, -2605.84375),
            vec2(-107.31497955322, -2632.4270019531),
            vec2(-108.22663116455, -2643.7517089844),
            vec2(-135.05113220215, -2643.6875),
            vec2(-135.1879119873, -2718.1157226563),
            vec2(-166.58688354492, -2718.2778320313),
            vec2(-166.54818725586, -2727.7666015625),
            vec2(-198.60395812988, -2726.9836425781),
            vec2(-198.9953918457, -2688.7141113281),
            vec2(-253.61521911621, -2688.2451171875),
            vec2(-305.04409790039, -2737.5915527344),
            vec2(-321.32647705078, -2721.2055664063),
            vec2(-307.72946166992, -2707.4553222656),
            vec2(-315.59790039063, -2685.5024414063),
            vec2(-333.08337402344, -2668.8071289063),
            vec2(-287.59451293945, -2621.8642578125),
            vec2(-289.90548706055, -2599.5126953125),
            vec2(-306.02227783203, -2604.7114257813),
            vec2(-317.6106262207, -2594.8762207031),
            vec2(-343.40243530273, -2570.3364257813),
            vec2(-334.82739257813, -2551.3403320313),
            vec2(-311.95190429688, -2532.5903320313),
            vec2(-287.60083007813, -2552.5114746094),
            vec2(-282.33926391602, -2551.4611816406),
            vec2(-265.85958862305, -2532.3266601563),
            vec2(-266.62176513672, -2526.4372558594),
            vec2(-358.04971313477, -2448.6984863281),
        },
        minZ=5.0,
        maxZ=11.5,

        weapon = `WEAPON_PISTOL`
    },

    
    ["Vespucci"] = {
        coords = {
            vec2(-1183.9851074219, -1591.212890625),
            vec2(-1177.8934326172, -1599.2768554688),
            vec2(-1173.8336181641, -1596.9578857422),
            vec2(-1087.3648681641, -1718.4945068359),
            vec2(-1072.9866943359, -1709.1411132813),
            vec2(-1034.8565673828, -1670.6740722656),

            vec2(-1020.0931396484, -1660.8862304688),
            vec2(-1004.8267211914, -1646.0070800781),

            vec2(-994.46600341797, -1610.5637207031),
            vec2(-1000.9489135742, -1569.1033935547),
            vec2(-1048.1292724609, -1502.3435058594),
            vec2(-1183.9851074219, -1591.212890625)
        },
        minZ=4.0,
        maxZ=10.0,

        weapon = `WEAPON_PISTOL_MK2`
    },

    ["Forum Drive 1"] = {
        coords = {
            vec2(-307.48727416992, -1608.5811767578),

            vec2(-321.70672607422, -1646.6158447266),
            vec2(-231.29063415527, -1673.5017089844),
            vec2(-235.25653076172, -1640.8571777344),

            vec2(-197.48092651367, -1640.2060546875),

            vec2(-196.38836669922, -1630.7510986328),
            vec2(-188.81471252441, -1582.9284667969),
            vec2(-184.93583679199, -1580.7976074219),

            vec2(-211.73022460938, -1550.0460205078),
            vec2(-237.86508178711, -1528.3658447266),
            vec2(-246.5597076416, -1537.4477539063),
            vec2(-258.85513305664, -1536.3225097656),
            vec2(-261.99877929688, -1539.2794189453),
            vec2(-270.08767700195, -1536.8890380859),
            vec2(-307.48727416992, -1608.5811767578),
        },
        minZ=29.4697418212,
        maxZ=38.0,

        weapon = `WEAPON_PISTOL_MK2`
    },
    
    --[[ ["Forum Drive 2"] = {
        coords = {
            vec2(-307.48727416992, -1608.5811767578),

            vec2(-321.70672607422, -1646.6158447266),
            vec2(-231.29063415527, -1673.5017089844),
            vec2(-235.25653076172, -1640.8571777344),

            vec2(-197.48092651367, -1640.2060546875),

            vec2(-196.38836669922, -1630.7510986328),
            vec2(-188.81471252441, -1582.9284667969),
            vec2(-184.93583679199, -1580.7976074219),

            vec2(-211.73022460938, -1550.0460205078),
            vec2(-237.86508178711, -1528.3658447266),
            vec2(-246.5597076416, -1537.4477539063),
            vec2(-258.85513305664, -1536.3225097656),
            vec2(-261.99877929688, -1539.2794189453),
            vec2(-270.08767700195, -1536.8890380859),
            vec2(-307.48727416992, -1608.5811767578),
        },
        minZ=29.4697418212,
        maxZ=38.0,

        weapon = `WEAPON_APPISTOL`
    }, ]]

    ["Fuente"] = {
        coords = {
            vec2(1431.1183, 1188.9399),

            vec2(1431.1210, 1115.5571),
            vec2(1478.0269, 1115.5492),
            vec2(1478.0145, 1188.9070),
        },
        minZ=111.4697418212,
        maxZ=117.0,

        weapon = `WEAPON_PISTOL_MK2`
    }
}




local coords_respawn_redzone = {

    ["Forum Drive 1"] = {    
        vec4(-203.3849029541, -1567.7786865234, (35.237773895264-0.95), 50.241706848145),
        vec4(-215.06657409668, -1549.0932617188, (33.789264678955-0.95), 139.64991760254),
        vec4(-238.69885253906, -1533.2104492188, (31.506341934204-0.95), 155.37884521484),
        vec4(-268.79824829102, -1538.9240722656, (31.742931365967-0.95), 210.62977600098),

        vec4(-317.95474243164, -1644.1009521484, (31.853046417236-0.95), 301.9528503418),
        vec4(-309.17324829102, -1618.0750732422, (31.848838806152-0.95), 305.06018066406),
        vec4(-235.78868103027, -1664.5372314453, (33.854183197021-0.95), 50.139923095703),

        vec4(-267.78308105469, -1583.1048583984, (31.849805831909-0.95), 170.36364746094),
        vec4(-214.62641906738, -1580.6013183594, (34.869338989258-0.95), 175.0457611084),
        vec4(-217.58616638184, -1615.3942871094, (34.869327545166-0.95), 351.19177246094),
        vec4(-194.04312133789, -1606.4953613281, (34.02462387085-0.95), 75.863800048828),
        vec4(-205.23243713379, -1635.0600585938, (33.562023162842-0.95), 88.110168457031),

    },
    --[[ ["Forum Drive 2"] = {    
        vec4(-203.3849029541, -1567.7786865234, (35.237773895264-0.95), 50.241706848145),
        vec4(-215.06657409668, -1549.0932617188, (33.789264678955-0.95), 139.64991760254),
        vec4(-238.69885253906, -1533.2104492188, (31.506341934204-0.95), 155.37884521484),
        vec4(-268.79824829102, -1538.9240722656, (31.742931365967-0.95), 210.62977600098),

        vec4(-317.95474243164, -1644.1009521484, (31.853046417236-0.95), 301.9528503418),
        vec4(-309.17324829102, -1618.0750732422, (31.848838806152-0.95), 305.06018066406),
        vec4(-235.78868103027, -1664.5372314453, (33.854183197021-0.95), 50.139923095703),

        vec4(-267.78308105469, -1583.1048583984, (31.849805831909-0.95), 170.36364746094),
        vec4(-214.62641906738, -1580.6013183594, (34.869338989258-0.95), 175.0457611084),
        vec4(-217.58616638184, -1615.3942871094, (34.869327545166-0.95), 351.19177246094),
        vec4(-194.04312133789, -1606.4953613281, (34.02462387085-0.95), 75.863800048828),
        vec4(-205.23243713379, -1635.0600585938, (33.562023162842-0.95), 88.110168457031),

    }, ]]
    ["Vespucci"] = {    

        vec4(-1171.2470703125, -1586.1431884766, (4.3262186050415-0.95), 216.32536315918),
        vec4(-1127.5179443359, -1611.8243408203, (4.3984327316284-0.95), 300.26416015625),
        vec4(-1084.4512939453, -1672.0377197266, (4.7219042778015-0.95), 300.26416015625),
        vec4(-1087.8220214844, -1684.1789550781, (4.6478071212769-0.95), 177.62791442871),
        vec4(-1066.8026123047, -1565.0668945313, (4.5612750053406-0.95), 215.52963256836),
        vec4(-1035.5231933594, -1570.2662353516, (5.1268458366394-0.95), 33.289588928223),
        vec4(-1095.7205810547, -1597.8948974609, (4.6517415046692-0.95), 308.51483154297),
        vec4(-1130.9912109375, -1560.2973632813, (4.3771910667419-0.95), 214.11781311035),
        vec4(-1057.8900146484, -1510.19140625, (5.1607151031494-0.95), 214.11781311035),
        vec4(-1133.1477050781, -1633.9705810547, (4.3608732223511-0.95), 125.42972564697),
        vec4(-1034.7814941406, -1590.3395996094, (4.9510583877563-0.95), 125.42972564697),

    },
    ["Port"] = { 
        vec4(-131.87351989746, -2582.1647949219, (6.000705242157-0.95), 30.835460662842),
        vec4(-151.82710266113, -2536.9201660156, (6.0030241012573-0.95), 162.99363708496),
        vec4(-167.13340759277, -2580.9165039063, (6.0010280609131-0.95), 346.93542480469),
        vec4(-202.38557434082, -2462.9963378906, (6.0102596282959-0.95), 197.5587310791),
        vec4(-182.05377197266, -2495.0146484375, (6.0377683639526-0.95), 34.710536956787),
        vec4(-210.22422790527, -2457.2788085938, (6.002866268158-0.95), 46.510234832764),
        vec4(-246.80386352539, -2423.6823730469, (6.0013933181763-0.95), 200.10299682617),
        vec4(-297.82376098633, -2415.4572753906, (6.0006294250488-0.95), 143.17723083496),
        vec4(-265.35873413086, -2441.3249511719, (6.0006384849548-0.95), 235.15081787109),
        vec4(-343.08737182617, -2435.0703125, (6.0006284713745-0.95), 231.39044189453),
        vec4(-330.32830810547, -2467.9060058594, (6.0006380081177-0.95), 228.63087463379),
        vec4(-289.93304443359, -2505.7145996094, (6.0006308555603-0.95), 260.16375732422),
        vec4(-263.46264648438, -2496.1284179688, (6.0006275177002-0.95), 222.47468566895),
        vec4(-255.44396972656, -2586.740234375, (6.0006279945374-0.95), 111.08584594727),
        vec4(-223.39973449707, -2600.1218261719, (6.0013957023621-0.95), 111.81046295166),
        vec4(-305.14959716797, -2731.7434082031, (6.0002946853638-0.95), 345.93664550781),
        vec4(-309.84527587891, -2696.6662597656, (6.0003018379211-0.95), 306.56103515625),
        vec4(-290.40670776367, -2661.7102050781, (6.1595339775085-0.95), 44.879261016846),
        vec4(-266.416015625, -2694.0412597656, (6.0003008842468-0.95), 115.46580505371),
        vec4(-243.80473327637, -2676.99609375, (6.0002899169922-0.95), 7.6505765914917),
        vec4(-200.8173828125, -2662.9243164063, (6.000292301178-0.95), 4.6124997138977),
        vec4(-141.82220458984, -2706.7583007813, (6.0024790763855-0.95), 20.785442352295),
        vec4(-168.00354003906, -2659.7326660156, (6.0010266304016-0.95), 267.05511474609),
        vec4(-138.80438232422, -2661.3581542969, (6.0002269744873-0.95), 114.58283233643),
        vec4(-114.76831054688, -2630.1809082031, (6.0020380020142-0.95), 62.177276611328),
        vec4(-197.24578857422, -2625.7580566406, (6.0013918876648-0.95), 356.04968261719),
        vec4(-194.71713256836, -2555.3237304688, (6.0014033317566-0.95), 183.78996276855),
        vec4(-216.90551757813, -2560.2385253906, (6.0013928413391-0.95), 48.93424987793),
        vec4(-323.33749389648, -2549.36328125, (6.0006279945374-0.95), 232.10729980469),
    },

    ["Fuente"] = {
        vec4(1463.7878, 1123.5337, 114.3369, 17.0024),
        vec4(1447.1542, 1124.0050, 114.3367, 113.3053),
        vec4(1436.2463, 1136.2115, 114.5207, 4.0696),
        vec4(1434.2520, 1156.2014, 114.2207, 2.7572),
        vec4(1450.7191, 1181.8909, 114.0902, 220.2070),
        vec4(1465.1019, 1181.8699, 114.2124, 259.7984),
        vec4(1465.9191, 1162.0763, 114.2784, 97.8153),
        vec4(1447.7203, 1162.0262, 114.2990, 88.9519),
        vec4(1449.1937, 1147.2366, 114.3012, 266.4830),
        vec4(1465.2465, 1147.1396, 114.3103, 271.8973),
        vec4(1478.0154, 1140.4943, 114.3371, 327.7798),
        vec4(1477.8962, 1164.6692, 114.3283, 358.2111),
        vec4(1474.4587, 1153.6360, 114.3075, 182.9372),
        vec4(1454.9904, 1161.8865, 114.2781, 269.1619),
        vec4(1458.1667, 1146.9999, 114.3123, 329.4751),
    }
}

FenixElite.CurrentRedzone = "Forum Drive 1"

RespawnIntoRedzone  = function ()
    if not FenixElite.InRedzone then return end
    RemoveAllPedWeapons(cache.ped)
    local MyRedzone = FenixElite.CurrentRedzone
    local random = math.random(1,#coords_respawn_redzone[MyRedzone])

    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(cache.ped, true, true)
    ClearRagdollBlockingFlags(cache.ped, 0)
    ClearPedTasks(cache.ped)
    SetEntityHealth(cache.ped, GetEntityMaxHealth(cache.ped))
    FreezeEntityPosition(cache.ped, true)
    SetEntityVisible(cache.ped, true, true) 
    SetEntityInvincible(cache.ped,false)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    local x,y,z,h = table.unpack(coords_respawn_redzone[MyRedzone][random])
    SetEntityCoords(cache.ped,x,y,z)
    SetEntityHeading(cache.ped,h)
    ClearPedTasks(cache.ped)
    FreezeEntityPosition(cache.ped, true)
    Wait(200)
    if not FenixElite.InRedzone then return end

    SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 0.0)
    SetWeaponDamageModifier(GetHashKey("WEAPON_PISTOL_MK2"), 0.000001)
    SetWeaponDamageModifier(GetHashKey("WEAPON_PISTOL"), 0.5)
    ClearPedTasks(cache.ped)

    FreezeEntityPosition(cache.ped, false)

   local time = 0
   local ped = cache.ped
   FenixElite.CanGodmode = true
    while time < 170 and FenixElite.InRedzone do
        time = time + 1
        Wait(0)
        ClearPedTasks(cache.ped)
        DisablePlayerFiring(ped,true)
        SetEntityInvincible(ped, true)
        SetEntityVisible(cache.ped, false, false)
        SetEntityAlpha(ped, 100, false)
        SetEntityLocallyVisible(ped)
        SetLocalPlayerVisibleLocally(ped)

        DisableControlAction(1, 140, true)
        DisableControlAction(1, 141, true)
        DisableControlAction(1, 142, true)
        DisableControlAction(1, 36, true)
        DisableControlAction(1,44, true)
        --SetEntityCollision(ped, false, false)
        --FreezeEntityPosition(ped, true)
    end
    FenixElite.CanGodmode = false
    if FenixElite.InRedzone then
        SetEntityInvincible(ped, false)
        ResetEntityAlpha(ped)
        SetEntityVisible(ped, true, false)
        --SetEntityCollision(ped, true, false)
        SetBlockingOfNonTemporaryEvents(ped, false)
        DisablePlayerFiring(ped,false)
        --FreezeEntityPosition(ped, false)
        ClearPedTasks(cache.ped)
        GiveWeaponToPed(cache.ped,RedzoneConfig[MyRedzone].weapon, 9999, true,true)

        SetWeaponRecoilShakeAmplitude(RedzoneConfig[MyRedzone].weapon, 0.0)
        if RedzoneConfig[MyRedzone].weapon == GetHashKey("WEAPON_PISTOL_MK2") then
            GiveWeaponComponentToPed(cache.ped,RedzoneConfig[MyRedzone].weapon, GetHashKey("COMPONENT_AT_PI_COMP"))
            GiveWeaponComponentToPed(cache.ped,RedzoneConfig[MyRedzone].weapon, GetHashKey("COMPONENT_AT_PI_RAIL"))
            GiveWeaponComponentToPed(cache.ped,RedzoneConfig[MyRedzone].weapon, GetHashKey("COMPONENT_PISTOL_MK2_CLIP_02"))
        elseif RedzoneConfig[MyRedzone].weapon == GetHashKey("WEAPON_PISTOL") then
            GiveWeaponComponentToPed(cache.ped,RedzoneConfig[MyRedzone].weapon, GetHashKey("COMPONENT_APPISTOL_CLIP_02"))
            GiveWeaponComponentToPed(cache.ped,RedzoneConfig[MyRedzone].weapon, GetHashKey("COMPONENT_APPISTOL_VARMOD_LUXE"))
        end
    end
end

FenixElite.InRedzonePoly = false
FenixElite.InRedzone = false

RegisterNUICallback('enterRedzone', function(data, cb)
    TriggerServerEvent("fenix:redzone:enter", data)
    cb(true)
end)

RegisterNetEvent("fenix:redzone:exit", function()
    FenixElite.Redzone.Esci()
end)

RegisterNetEvent("fenix:redzone:enter", function(arena)
    FenixElite.Redzone.Entra(arena)
end)

CreateThread(function()
    FenixElite.Zones = {}
    for a, b in pairs(RedzoneConfig) do
        FenixElite.Zones[a] = PolyZone:Create(b.coords, {
            name= a,
            minZ= b.minZ,
            maxZ= b.maxZ,
            debugGrid=true,
            gridDivisions=25
        })

        FenixElite.Zones[a]:onPlayerInOut(function(isPointInside, point)
            FenixElite.InRedzonePoly = isPointInside

            if a ~= FenixElite.CurrentRedzone then return end

            if FenixElite.InRedzone then
                if not FenixElite.InRedzonePoly then
                    FenixElite.Redzone.StartCountdown()
                end
            end
        end)
    end
end)

RegisterNUICallback("fenix:redzone:getCounts", function(_, cb)
    cb(lib.callback.await("fenix:redzone:getCounts", 100))
end)

FenixElite.Redzone.Entra = function(arena)
    TriggerEvent("Fenix:ChangePoly", true)
    FenixElite.InRedzone = true
    FenixElite.CurrentRedzone = arena
    toggleNuiFrame(false)
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.0)
    FenixElite.EnableRadio = true
    FenixElite.EnableCrouch = true

    RespawnIntoRedzone()
end

FenixElite.Redzone.Esci = function()
    TriggerEvent("Fenix:ChangePoly", false)
    FenixElite.InRedzone = false
    FenixElite.EnableRadio = false
    FenixElite.EnableCrouch = false
    NetworkSetFriendlyFireOption(false)
    SetCanAttackFriendly(cache.ped, false, false)

    NetworkResurrectLocalPlayer(GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))
    SetEntityAlpha(cache.ped, 255, false)
    SetEntityCoords(cache.ped, FenixElite.LobbyCoords, true, false, false, false) 
    SetEntityVisible(cache.ped, true)
    SetEntityCollision(cache.ped, true)
    SetEntityInvincible(cache.ped, false)
    SetCanAttackFriendly(cache.ped, false, false)
    NetworkSetFriendlyFireOption(false)
    SetEntityHealth(cache.ped, GetEntityMaxHealth(cache.ped))
    ClearPedBloodDamage(cache.ped)
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.49)
    ResetPedMovementClipset(cache.ped, 0)
    RemoveAllPedWeapons(cache.ped, false)

    Wait(900)

    FreezeEntityPosition(cache.ped, false)

    LeaderBoardOn = false
end

FenixElite.Redzone.StartCountdown = function()
    CreateThread(function()
        local Countdown = 10
        while not FenixElite.InRedzonePoly and FenixElite.InRedzone do
            FenixElite.Functions.Notify(FenixElite.GetTranslation("enter_redzone"):format(Countdown))
            if Countdown == 0 then
                TriggerServerEvent("fenix:redzone:exit")
                break
            end
            Countdown -= 1
            Wait(1000)
        end
    end)
end

local DataFromServer

RegisterNetEvent("fenix:redzone:makeLeaderboard")
AddEventHandler("fenix:redzone:makeLeaderboard",function (data, killer)

    if killer == cache.serverId then
        TriggerEvent("dz-crosshair:client:KillNotify")
        FenixElite.FakeKillfeed()
    end

    if not LeaderBoardOn  then
        DataFromServer = data
        if not DataFromServer[1] then
            DataFromServer[1] = {kills = 0, deaths = 0, name = "NoName"}
        end
        if not DataFromServer[2] then
            DataFromServer[2] = {kills = 0, deaths = 0, name = "NoName"}
        end
        if not DataFromServer[3] then
            DataFromServer[3] = {kills = 0, deaths = 0, name = "NoName"}
        end
        LeaderBoardOn = true
        CreaLeaderBoardRedzone()
    else
        DataFromServer = data
        if not DataFromServer[1] then
            DataFromServer[1] = {kills = 0, deaths = 0, name = "NoName"}
        end
        if not DataFromServer[2] then
            DataFromServer[2] = {kills = 0, deaths = 0, name = "NoName"}
        end
        if not DataFromServer[3] then
            DataFromServer[3] = {kills = 0, deaths = 0, name = "NoName"}
        end
    end
end)



CreaLeaderBoardRedzone = function ()
    CreateThread(function()
        while LeaderBoardOn do
            Wait(0)
            local idx =  {1}
            local titleColor = { 255, 255, 255, 255 }
            local textColor =  { 255, 255, 255, 255 }
            local titleScale =  0.25
            local titleFont =  0
            local titleFontOffset =  0.0

            local yOffset = (timerBar.baseY - safeZone) - ((idx[1] or 0) * timerBar.baseGap)

            if not HasStreamedTextureDictLoaded(timerBar.txtDict) then
                RequestStreamedTextureDict(timerBar.txtDict, true)

                local t = GetGameTimer() + 5000

                repeat
                    Citizen.Wait(0)
                until HasStreamedTextureDictLoaded(timerBar.txtDict) or (GetGameTimer() > t)
            end

            DrawSprite(timerBar.txtDict, timerBar.txtName, timerBar.baseX - safeZone, yOffset, timerBar.baseWidth, timerBar.baseHeight, 0.0, 255, 255, 255, 160)

            BeginTextCommandDisplayText("CELL_EMAIL_BCON")
            SetTextFont(titleFont)
            SetTextScale(titleScale, titleScale)
            SetTextColour(198, 119, 0, 255)

            SetTextRightJustify(true)
            SetTextWrap(0.0, (timerBar.baseX - safeZone) + timerBar.titleX)
            AddTextComponentSubstringPlayerName("| K: "..(DataFromServer[3].kills or 0).." | D: "..(DataFromServer[3].deaths or 0))
            EndTextCommandDisplayText((timerBar.baseX - safeZone) +timerBar.titleX, yOffset + timerBar.titleY - titleFontOffset)

            BeginTextCommandDisplayText("CELL_EMAIL_BCON")
            SetTextFont(0)
            SetTextScale(0.3, 0.3)
            SetTextColour(titleColor[1], titleColor[2], titleColor[3], titleColor[4])
            SetTextRightJustify(true)
            SetTextWrap(0.0, (timerBar.baseX - safeZone) + timerBar.textX)
            AddTextComponentSubstringPlayerName((DataFromServer[3].name or ""))
            EndTextCommandDisplayText((timerBar.baseX - safeZone) + timerBar.textX, yOffset + timerBar.textY)
            local yOffset2 = (timerBar.baseY - safeZone) - ((idx[1] or 0) * 0.120)
            DrawSprite(timerBar.txtDict, timerBar.txtName, timerBar.baseX - safeZone, yOffset2, timerBar.baseWidth, timerBar.baseHeight, 0.0, 255, 255, 255, 160)

            BeginTextCommandDisplayText("CELL_EMAIL_BCON")
            SetTextFont(titleFont)
            SetTextScale(titleScale, titleScale)
            SetTextColour(158, 158, 158, 255)
            SetTextRightJustify(true)
            SetTextWrap(0.0, (timerBar.baseX - safeZone) + timerBar.titleX)
            AddTextComponentSubstringPlayerName("| K: "..(DataFromServer[2].kills or 0).." | D: "..(DataFromServer[2].deaths or 0))
            EndTextCommandDisplayText((timerBar.baseX - safeZone) +timerBar.titleX, yOffset2 + timerBar.titleY - titleFontOffset)
            
            BeginTextCommandDisplayText("CELL_EMAIL_BCON")
            SetTextFont(0)
            SetTextScale(0.3, 0.3)
            SetTextColour(textColor[1], textColor[2], textColor[3], textColor[4])
            SetTextRightJustify(true)
            SetTextWrap(0.0, (timerBar.baseX - safeZone) + timerBar.textX)
            AddTextComponentSubstringPlayerName((DataFromServer[2].name or " "))
            EndTextCommandDisplayText((timerBar.baseX - safeZone) + timerBar.textX, yOffset2 + timerBar.textY)

            local yOffset3 = (timerBar.baseY - safeZone) - ((idx[1] or 0) * 0.160)

            DrawSprite(timerBar.txtDict, timerBar.txtName, timerBar.baseX - safeZone, yOffset3, timerBar.baseWidth, timerBar.baseHeight, 0.0, 255, 255, 255, 160)

            BeginTextCommandDisplayText("CELL_EMAIL_BCON")
            SetTextFont(titleFont)
            SetTextScale(titleScale, titleScale)
            SetTextColour(222, 209, 23, 255)
            SetTextRightJustify(true)
            SetTextWrap(0.0, (timerBar.baseX - safeZone) + timerBar.titleX)
            AddTextComponentSubstringPlayerName("| K: "..(DataFromServer[1].kills or 0).." | D: "..(DataFromServer[1].deaths or 0))
            EndTextCommandDisplayText((timerBar.baseX - safeZone) +timerBar.titleX, yOffset3 + timerBar.titleY - titleFontOffset)


            BeginTextCommandDisplayText("CELL_EMAIL_BCON")
            SetTextFont(0)
            SetTextScale(0.3, 0.3)
            SetTextColour(textColor[1], textColor[2], textColor[3], textColor[4])
            SetTextRightJustify(true)
            SetTextWrap(0.0, (timerBar.baseX - safeZone) + timerBar.textX)
            AddTextComponentSubstringPlayerName((DataFromServer[1].name or " "))
            EndTextCommandDisplayText((timerBar.baseX - safeZone) + timerBar.textX, yOffset3 + timerBar.textY)
        end
    end)
end