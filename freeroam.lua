FenixElite.InFreeroam = false
FenixElite.CoordsFreeroam = vec3(-75.5768, -817.5740, 326.1751)
local heading = 0
local speed = 0.1
local up_down_speed = 0.1
FenixElite.Freeroam = {}
FenixElite.Freeroam.VeicoliSalvati = json.decode(GetResourceKvpString('fnx:veicoli')) or {}
FenixElite.Freeroam.Mappe = {}
local GetLabelText = GetLabelText

CreateThread(function()
    Wait(1000)
    local preMappe = {}
    for _, v in pairs(FenixMaps) do
        for kk, vv in pairs(v) do 
            preMappe[kk] = vv.A
        end
    end

    for k, v in pairs(preMappe) do
        table.insert(FenixElite.Freeroam.Mappe, {label = k, args = {coords = v}})
    end
end)

local ListaVeicoli = {
    ["Super"] = {
        "adder",
        "autarch",
        "banshee2",
        "bullet",
        "cheetah",
        "cyclone",
        "entityxf",
        "fmj",
        "infernus",
        "le7b",
        "oppressor",
        "osiris",
        "pfister811",
        "prototipo",
        "reaper",
        "sc1",
        "sheava",
        "sultanrs",
        "t20",
        "turisd",
        "tyrus",
        "vacca",
        "visione",
        "voltic",
        "voltic2",
        "zentorno",
    },
    ["Vans"] = {
        "bison",
        "bobcatxl",
        "burrito3",
        "camper",
        "gburrito",
        "gburrito2",
        "journey",
        "minivan",
        "moonbeam",
        "moonbeam2",
        "paradise",
        "rumpo",
        "rumpo3",
        "surfer",
        "youga",
        "youga2",
    },
    ["SUVs"] = {
        "baller2",
        "baller3",
        "cavalcade2",
        "contender",
        "dubsta",
        "dubsta2",
        "fq2",
        "granger",
        "gresley",
        "huntley",
        "landstalker",
        "mesa",
        "mesa3",
        "patriot",
        "radi",
        "rocoto",
        "seminole",
        "xls",
    },
    ["Motos"] = {
        "AKUMA",
        "avarus",
        "bagger",
        "bati",
        "bati2",
        "bf400",
        "bmx",
        "carbonrs",
        "chimera",
        "cliffhanger",
        "cruiser",
        "daemon",
        "daemon2",
        "defiler",
        "double",
        "enduro",
        "esskey",
        "faggio",
        "faggio2",
        "fixter",
        "gargoyle",
        "hakuchou",
        "hakuchou2",
        "hexer",
        "innovation",
        "manchez",
        "nemesis",
        "nightblade",
        "pcj",
        "ruffian",
        "sanchez",
        "sanchez2",
        "sanctus",
        "scorcher",
        "shotaro",
        "sovereign",
        "thrust",
        "tribike3",
        "vader",
        "vortex",
        "wolfsbane",
        "zombiea",
        "zombieb",
    },
    ["Coupés"] = {
        "cogcabrio",
        "exemplar",
        "f620",
        "felon",
        "felon2",
        "jackal",
        "oracle2",
        "sentinel",
        "sentinel2",
        "windsor",
        "windsor2",
        "zion",
        "zion2",
    },
    ["Muscle"] = {
        "blade",
        "buccaneer",
        "buccaneer2",
        "chino",
        "chino2",
        "coquette3",
        "dominator",
        "dukes",
        "faction",
        "faction2",
        "faction3",
        "gauntlet",
        "hermes",
        "hotknife",
        "hustler",
        "nightshade",
        "phoenix",
        "picador",
        "ruiner2",
        "sabregt",
        "sabregt2",
        "slamvan3",
        "tampa",
        "vigero",
        "virgo",
        "voodoo",
        "yosemite",
    },
    ["Compacts"] = {
        "blista",
        "brioso",
        "issi2",
        "panto",
        "prairie",
    },
    ["Off Road"] = {
        "bfinjection",
        "bifta",
        "blazer",
        "blazer4",
        "blazer5",
        "brawler",
        "dubsta3",
        "dune",
        "guardian",
        "kamacho",
        "monster",
        "rebel2",
        "riata",
        "sandking",
        "trophytruck",
        "trophytruck2",
    },
    ["Sedans"] = {
        "asea",
        "cognoscenti",
        "emperor",
        "fugitive",
        "glendale",
        "intruder",
        "premier",
        "primo2",
        "regina",
        "schafter2",
        "stretch",
        "superd",
        "tailgater",
        "warrener",
        "washington",
    },
    ["Sports Classics"] = {
        "ardent",
        "btype",
        "btype2",
        "btype3",
        "casco",
        "coquette2",
        "deluxo",
        "feltzer3",
        "gt500",
        "manana",
        "monroe",
        "pigalle",
        "rapidgt3",
        "retinue",
        "savestra",
        "stinger",
        "stingergt",
        "viseris",
        "z190",
        "ztype",
    },
    ["Sports"] = {
        "alpha",
        "banshee",
        "bestiagts",
        "buffalo",
        "buffalo2",
        "carbonizzare",
        "comet2",
        "comet5",
        "coquette",
        "elegy2",
        "feltzer2",
        "furoregt",
        "fusilade",
        "jester",
        "jester2",
        "khamelion",
        "kuruma",
        "lynx",
        "mamba",
        "massacro",
        "massacro2",
        "neon",
        "ninef",
        "ninef2",
        "omnis",
        "pariah",
        "penumbra",
        "raiden",
        "rapidgt",
        "rapidgt2",
        "revolter",
        "schafter3",
        "sentinel3",
        "seven70",
        "streiter",
        "stromberg",
        "sultan",
        "surano",
        "tampa2",
        "tropos",
        "verlierer2",
    },
}

local _oldLabelText = GetLabelText
function GetLabelText(arg)
    if _oldLabelText(arg) ~= "NULL" then
        return _oldLabelText(arg)
    else
        return false
    end
end

local WeaponList = {
    ['Pistols'] = {
        [GetLabelText('WT_PIST_AP') or "AP Pistol"] = 'weapon_appistol',
        [GetLabelText('WT_PIST') or "Pistol"] = 'weapon_pistol',
        [GetLabelText('WT_PIST_50') or "Pistol .50"] = 'weapon_pistol50',
        [GetLabelText('WT_PIST2')] = 'weapon_pistol_mk2',
        [GetLabelText('WT_HEAVYPSTL') or 'Pistol MK2'] = 'weapon_heavypistol',
        [GetLabelText('WT_SNSPISTOL') or 'SNS Pistol'] = 'weapon_snspistol',
        [GetLabelText('WT_SNSPISTOL2') or 'SNS Pistol MK2'] = 'weapon_snspistol_mk2',
        [GetLabelText('WT_VPISTOL') or 'Vintage Pistol'] = 'weapon_vintagepistol',
        [GetLabelText('WT_CERPST') or 'Ceramic Pistol'] = 'weapon_ceramicpistol',
        [GetLabelText('WT_COMBATPISTOL') or 'Combat Pistol'] = 'weapon_combatpistol',
        [GetLabelText('WT_REVOLVER') or 'Revolver'] = 'weapon_revolver',
        [GetLabelText('WT_REVOLVER_MK2') or 'Revolver MK2'] = 'weapon_revolver_mk2',
        [GetLabelText('WT_DOUBLEACTION') or 'Double Action Revolver'] = 'weapon_doubleaction',
        [GetLabelText('WT_MARKSMANPISTOL') or 'Marksman Pistol'] = 'weapon_marksmanpistol',
        [GetLabelText('WT_MACHINEPISTOL') or 'Marksman Pistol'] = 'weapon_machinepistol',
        [GetLabelText('WT_COMPACTRIFLE') or 'Compact Rifle'] = 'weapon_compactrifle',
        [GetLabelText('WT_STUNGUN') or 'Tazer'] = 'weapon_stungun',
        [GetLabelText('WT_FLAREGUN') or 'Flare Gun'] = 'weapon_flaregun',
        [GetLabelText('WT_RAYPISTOL') or 'Up-n-Atomizer'] = 'weapon_raypistol',
        [GetLabelText('WT_NAVYREVOLVER') or 'Navy Revolver'] = 'weapon_navyrevolver',
        
        [GetLabelText('WEAPON_POOLCUE') or 'Biliardo'] = 'WEAPON_POOLCUE',
    },
    ['Submachine Guns'] = {
        [GetLabelText('WT_SMG') or 'SMG'] = 'weapon_smg',
        [GetLabelText('WT_SMG2') or 'SMG MK2'] = 'weapon_smg_mk2',
        [GetLabelText('WT_ASSAULTSMG') or 'Assault SMG'] = 'weapon_assaultsmg',
        [GetLabelText('WT_COMBATPDW') or 'Combat PDW'] = 'weapon_combatpdw',
    },
    ['Assault Rifles'] = {
        [GetLabelText('WT_ASSAULTRIFLE') or 'Assault Rifle'] = 'weapon_assaultrifle',
        [GetLabelText('WT_ASSAULTRIFLE2') or 'Assault Rifle MK2'] = 'weapon_assaultrifle_mk2',
        [GetLabelText('WT_CARBINERIFLE') or 'Carbine Rifle'] = 'weapon_carbinerifle',
        [GetLabelText('WT_CARBINERIFLE_MK2') or 'Carbine Rifle MK2'] = 'weapon_carbinerifle_mk2',
        [GetLabelText('WT_SPECIALCARBINE') or 'Special Carbine'] = 'weapon_specialcarbine',
        [GetLabelText('WT_SPECIALCARBINE_MK2') or 'Special Carbine MK2'] = 'weapon_specialcarbine_mk2',
        [GetLabelText('WT_BULLPUPRIFLE') or 'Bullpup Rifle'] = 'weapon_bullpuprifle',
        [GetLabelText('WT_BULLPUPRIFLE_MK2') or 'Bullpup Rifle MK2'] = 'weapon_bullpuprifle_mk2',
    },
    -- Far finire a chatgpt
}


local ListaPeds = {
    '[M] mp_m_freemode_01',
    '[F] mp_f_freemode_01',
    'a_f_m_beach_01',
    'a_f_m_bevhills_01',
    'a_f_m_bevhills_02',
    'a_f_m_bodybuild_01',
    'a_f_m_business_02',
    'a_f_m_downtown_01',
    'a_f_m_eastsa_01',
    'a_f_m_eastsa_02',
    'a_f_m_fatbla_01',
    'a_f_m_fatcult_01',
    'a_f_m_fatwhite_01',
    'a_f_m_ktown_01',
    'a_f_m_ktown_02',
    'a_f_m_prolhost_01',
    'a_f_m_salton_01',
    'a_f_m_skidrow_01',
    'a_f_m_soucentmc_01',
    'a_f_m_soucent_01',
    'a_f_m_soucent_02',
    'a_f_m_tourist_01',
    'a_f_m_trampbeac_01',
    'a_f_m_tramp_01',
    'a_f_o_genstreet_01',
    'a_f_o_indian_01',
    'a_f_o_ktown_01',
    'a_f_o_salton_01',
    'a_f_o_soucent_01',
    'a_f_o_soucent_02',
    'a_f_y_beach_01',
    'a_f_y_bevhills_01',
    'a_f_y_bevhills_02',
    'a_f_y_bevhills_03',
    'a_f_y_bevhills_04',
    'a_f_y_business_01',
    'a_f_y_business_02',
    'a_f_y_business_03',
    'a_f_y_business_04',
    'a_f_y_eastsa_01',
    'a_f_y_eastsa_02',
    'a_f_y_eastsa_03',
    'a_f_y_epsilon_01',
    'a_f_y_fitness_01',
    'a_f_y_fitness_02',
    'a_f_y_genhot_01',
    'a_f_y_golfer_01',
    'a_f_y_hiker_01',
    'a_f_y_hippie_01',
    'a_f_y_hipster_01',
    'a_f_y_hipster_02',
    'a_f_y_hipster_03',
    'a_f_y_hipster_04',
    'a_f_y_indian_01',
    'a_f_y_juggalo_01',
    'a_f_y_runner_01',
    'a_f_y_rurmeth_01',
    'a_f_y_scdressy_01',
    'a_f_y_skater_01',
    'a_f_y_soucent_01',
    'a_f_y_soucent_02',
    'a_f_y_soucent_03',
    'a_f_y_tennis_01',
    'a_f_y_topless_01',
    'a_f_y_tourist_01',
    'a_f_y_tourist_02',
    'a_f_y_vinewood_01',
    'a_f_y_vinewood_02',
    'a_f_y_vinewood_03',
    'a_f_y_vinewood_04',
    'a_f_y_yoga_01',
    'a_m_m_acult_01',
    'a_m_m_afriamer_01',
    'a_m_m_beach_01',
    'a_m_m_beach_02',
    'a_m_m_bevhills_01',
    'a_m_m_bevhills_02',
    'a_m_m_business_01',
    'a_m_m_eastsa_01',
    'a_m_m_eastsa_02',
    'a_m_m_farmer_01',
    'a_m_m_fatlatin_01',
    'a_m_m_genfat_01',
    'a_m_m_genfat_02',
    'a_m_m_golfer_01',
    'a_m_m_hasjew_01',
    'a_m_m_hillbilly_01',
    'a_m_m_hillbilly_02',
    'a_m_m_indian_01',
    'a_m_m_ktown_01',
    'a_m_m_malibu_01',
    'a_m_m_mexcntry_01',
    'a_m_m_mexlabor_01',
    'a_m_m_og_boss_01',
    'a_m_m_paparazzi_01',
    'a_m_m_polynesian_01',
    'a_m_m_prolhost_01',
    'a_m_m_rurmeth_01',
    'a_m_m_salton_01',
    'a_m_m_salton_02',
    'a_m_m_salton_03',
    'a_m_m_salton_04',
    'a_m_m_skater_01',
    'a_m_m_skidrow_01',
    'a_m_m_socenlat_01',
    'a_m_m_soucent_01',
    'a_m_m_soucent_02',
    'a_m_m_soucent_03',
    'a_m_m_soucent_04',
    'a_m_m_stlat_02',
    'a_m_m_tennis_01',
    'a_m_m_tourist_01',
    'a_m_m_trampbeac_01',
    'a_m_m_tramp_01',
    'a_m_o_acult_01',
    'a_m_o_acult_02',
    'a_m_o_beach_01',
    'a_m_o_genstreet_01',
    'a_m_o_ktown_01',
    'a_m_o_salton_01',
    'a_m_o_soucent_01',
    'a_m_o_soucent_02',
    'a_m_o_soucent_03',
    'a_m_o_tramp_01',
    'a_m_y_acult_01',
    'a_m_y_acult_02',
    'a_m_y_beachvesp_01',
    'a_m_y_beachvesp_02',
    'a_m_y_beach_01',
    'a_m_y_beach_02',
    'a_m_y_beach_03',
    'a_m_y_bevhills_01',
    'a_m_y_bevhills_02',
    'a_m_y_breakdance_01',
    'a_m_y_busicas_01',
    'a_m_y_business_01',
    'a_m_y_business_02',
    'a_m_y_business_03',
    'a_m_y_cyclist_01',
    'a_m_y_dhill_01',
    'a_m_y_downtown_01',
    'a_m_y_eastsa_01',
    'a_m_y_eastsa_02',
    'a_m_y_epsilon_01',
    'a_m_y_epsilon_02',
    'a_m_y_gay_01',
    'a_m_y_gay_02',
    'a_m_y_genstreet_01',
    'a_m_y_genstreet_02',
    'a_m_y_golfer_01',
    'a_m_y_hasjew_01',
    'a_m_y_hiker_01',
    'a_m_y_hippy_01',
    'a_m_y_hipster_01',
    'a_m_y_hipster_02',
    'a_m_y_hipster_03',
    'a_m_y_indian_01',
    'a_m_y_jetski_01',
    'a_m_y_juggalo_01',
    'a_m_y_ktown_01',
    'a_m_y_ktown_02',
    'a_m_y_latino_01',
    'a_m_y_methhead_01',
    'a_m_y_mexthug_01',
    'a_m_y_motox_01',
    'a_m_y_motox_02',
    'a_m_y_musclbeac_01',
    'a_m_y_musclbeac_02',
    'a_m_y_polynesian_01',
    'a_m_y_roadcyc_01',
    'a_m_y_runner_01',
    'a_m_y_runner_02',
    'a_m_y_salton_01',
    'a_m_y_skater_01',
    'a_m_y_skater_02',
    'a_m_y_soucent_01',
    'a_m_y_soucent_02',
    'a_m_y_soucent_03',
    'a_m_y_stbla_01',
    'a_m_y_stbla_02',
    'a_m_y_stlat_01',
    'a_m_y_stwhi_01',
    'a_m_y_stwhi_02',
    'a_m_y_sunbathe_01',
    'a_m_y_surfer_01',
    'a_m_y_vindouche_01',
    'a_m_y_vinewood_01',
    'a_m_y_vinewood_02',
    'a_m_y_vinewood_03',
    'a_m_y_vinewood_04',
    'a_m_y_yoga_01',
    'csb_abigail',
    'csb_anita',
    'csb_anton',
    'csb_ballasog',
    'csb_bride',
    'csb_burgerdrug',
    'csb_car3guy1',
    'csb_car3guy2',
    'csb_chef',
    'csb_chin_goon',
    'csb_cletus',
    'csb_cop',
    'csb_customer',
    'csb_denise_friend',
    'csb_fos_rep',
    'csb_g',
    'csb_groom',
    'csb_grove_str_dlr',
    'csb_hao',
    'csb_heli_pilot',
    'csb_hugh',
    'csb_imran',
    'csb_janitor',
    'csb_maude',
    'csb_mweather',
    'csb_ortega',
    'csb_oscar',
    'csb_porndudes',
    'csb_prologuedriver',
    'csb_prolsec',
    'csb_ramp_gang',
    'csb_ramp_hic',
    'csb_ramp_hipster',
    'csb_ramp_marine',
    'csb_ramp_mex',
    'csb_reporter',
    'csb_roccopelosi',
    'csb_screen_writer',
    'csb_stripper_01',
    'csb_stripper_02',
    'csb_tonya',
    'csb_trafficwarden',
    'cs_amandatownley',
    'cs_andreas',
    'cs_ashley',
    'cs_bankman',
    'cs_barry',
    'cs_beverly',
    'cs_brad',
    'cs_bradcadaver',
    'cs_carbuyer',
    'cs_casey',
    'cs_chengsr',
    'cs_chrisformage',
    'cs_clay',
    'cs_dale',
    'cs_davenorton',
    'cs_debra',
    'cs_denise',
    'cs_devin',
    'cs_dom',
    'cs_dreyfuss',
    'cs_drfriedlander',
    'cs_fabien',
    'cs_fbisuit_01',
    'cs_floyd',
    'cs_guadalope',
    'cs_gurk',
    'cs_hunter',
    'cs_janet',
    'cs_jewelass',
    'cs_jimmyboston',
    'cs_jimmydisanto',
    'cs_joeminuteman',
    'cs_johnnyklebitz',
    'cs_josef',
    'cs_josh',
    'cs_karen_daniels',
    'cs_lamardavis',
    'cs_lazlow',
    'cs_lestercrest',
    'cs_lifeinvad_01',
    'cs_magenta',
    'cs_manuel',
    'cs_marnie',
    'cs_martinmadrazo',
    'cs_maryann',
    'cs_michelle',
    'cs_milton',
    'cs_molly',
    'cs_movpremf_01',
    'cs_movpremmale',
    'cs_mrk',
    'cs_mrs_thornhill',
    'cs_mrsphillips',
    'cs_natalia',
    'cs_nervousron',
    'cs_nigel',
    'cs_old_man1a',
    'cs_old_man2',
    'cs_omega',
    'cs_orleans',
    'cs_paper',
    'cs_patricia',
    'cs_priest',
    'cs_prolsec_02',
    'cs_russiandrunk',
    'cs_siemonyetarian',
    'cs_solomon',
    'cs_stevehains',
    'cs_stretch',
    'cs_tanisha',
    'cs_taocheng',
    'cs_taostranslator',
    'cs_tenniscoach',
    'cs_terry',
    'cs_tom',
    'cs_tomepsilon',
    'cs_tracydisanto',
    'cs_wade',
    'cs_zimbor',
    'g_f_y_ballas_01',
    'g_f_y_families_01',
    'g_f_y_lost_01',
    'g_f_y_vagos_01',
    'g_m_m_armboss_01',
    'g_m_m_armgoon_01',
    'g_m_m_armlieut_01',
    'g_m_m_chemwork_01',
    'g_m_m_chemwork_02',
    'g_m_m_chiboss_01',
    'g_m_m_chiboss_02',
    'g_m_m_chicold_01',
    'g_m_m_chigoon_01',
    'g_m_m_chigoon_02',
    'g_m_m_korboss_01',
    'g_m_m_mexboss_01',
    'g_m_m_mexboss_02',
    'g_m_y_armgoon_02',
    'g_m_y_azteca_01',
    'g_m_y_ballaeast_01',
    'g_m_y_ballaorig_01',
    'g_m_y_ballasout_01',
    'g_m_y_famca_01',
    'g_m_y_famdnf_01',
    'g_m_y_famfor_01',
    'g_m_y_korean_01',
    'g_m_y_korean_02',
    'g_m_y_korlieut_01',
    'g_m_y_lost_01',
    'g_m_y_lost_02',
    'g_m_y_lost_03',
    'g_m_y_mexgang_01',
    'g_m_y_mexgoon_01',
    'g_m_y_mexgoon_02',
    'g_m_y_mexgoon_03',
    'g_m_y_pologoon_01',
    'g_m_y_pologoon_02',
    'g_m_y_salvaboss_01',
    'g_m_y_salvagoon_01',
    'g_m_y_salvagoon_02',
    'g_m_y_salvagoon_03',
    'g_m_y_strpunk_01',
    'g_m_y_strpunk_02',
    'hc_driver',
    'hc_gunman',
    'hc_hacker',
    'ig_abigail',
    'ig_amandatownley',
    'ig_andreas',
    'ig_ashley',
    'ig_ballasog',
    'ig_bankman',
    'ig_barry',
    'ig_bestmen',
    'ig_beverly',
    'ig_brad',
    'ig_bride',
    'ig_car3guy1',
    'ig_car3guy2',
    'ig_casey',
    'ig_chef',
    'ig_chengsr',
    'ig_chrisformage',
    'ig_clay',
    'ig_claypain',
    'ig_cletus',
    'ig_dale',
    'ig_davenorton',
    'ig_denise',
    'ig_devin',
    'ig_dom',
    'ig_dreyfuss',
    'ig_drfriedlander',
    'ig_fabien',
    'ig_fbisuit_01',
    'ig_floyd',
    'ig_groom',
    'ig_hao',
    'ig_hunter',
    'ig_janet',
    'ig_jay_norris',
    'ig_jewelass',
    'ig_jimmyboston',
    'ig_jimmydisanto',
    'ig_joeminuteman',
    'ig_johnnyklebitz',
    'ig_josef',
    'ig_josh',
    'ig_karen_daniels',
    'ig_lamardavis',
    'ig_lazlow',
    'ig_lestercrest',
    'ig_lifeinvad_01',
    'ig_lifeinvad_02',
    'ig_magenta',
    'ig_manuel',
    'ig_marnie',
    'ig_maryann',
    'ig_maude',
    'ig_michelle',
    'ig_milton',
    'ig_molly',
    'ig_mrk',
    'ig_mrs_thornhill',
    'ig_mrsphillips',
    'ig_natalia',
    'ig_nervousron',
    'ig_nigel',
    'ig_old_man1a',
    'ig_old_man2',
    'ig_omega',
    'ig_oneil',
    'ig_orleans',
    'ig_ortega',
    'ig_paper',
    'ig_patricia',
    'ig_priest',
    'ig_prolsec_02',
    'ig_ramp_gang',
    'ig_ramp_hic',
    'ig_ramp_hipster',
    'ig_ramp_mex',
    'ig_roccopelosi',
    'ig_russiandrunk',
    'ig_screen_writer',
    'ig_siemonyetarian',
    'ig_solomon',
    'ig_stevehains',
    'ig_stretch',
    'ig_talina',
    'ig_tanisha',
    'ig_taocheng',
    'ig_taostranslator',
    'ig_tenniscoach',
    'ig_terry',
    'ig_tomepsilon',
    'ig_tonya',
    'ig_tracydisanto',
    'ig_trafficwarden',
    'ig_tylerdix',
    'ig_wade',
    'ig_zimbor',
    'mp_f_deadhooker',
    'mp_f_misty_01',
    'mp_f_stripperlite',
    'mp_g_m_pros_01',
    'mp_headtargets',
    'mp_m_avongoon',
    'mp_m_boatstaff_01',
    'mp_m_claude_01',
    'mp_m_cocaine_01',
    'mp_m_counterfeit_01',
    'mp_m_exarmy_01',
    'mp_m_execpa_01',
    'mp_m_famdd_01',
    'mp_m_fibsec_01',
    'mp_m_marston_01',
    'mp_m_niko_01',
    'mp_m_shopkeep_01',
    'mp_m_waremech_01',
    'mp_m_weapexp_01',
    'mp_m_weapwork_01',
    'mp_m_securoguard_01',
    'mp_s_m_armoured_01',
    'player_one',
    'player_two',
    'player_zero',
    'slod_human',
    'slod_large_quadped',
    'slod_small_quadped',
    'strm_peds_mpshare',
    'strm_peds_mptattrts',
    's_f_m_fembarber',
    's_f_m_maid_01',
    's_f_m_shop_high',
    's_f_m_sweatshop_01',
    's_f_y_airhostess_01',
    's_f_y_bartender_01',
    's_f_y_baywatch_01',
    's_f_y_cop_01',
    's_f_y_factory_01',
    's_f_y_hooker_01',
    's_f_y_hooker_02',
}

local ListaComponenti = {
    [GetHashKey('WEAPON_PISTOL')] = {
        ['esteso'] = GetHashKey('COMPONENT_PISTOL_CLIP_02'),
        ['torcia'] = GetHashKey('COMPONENT_AT_PI_FLSH'),
        --['silenziatore'] = GetHashKey('COMPONENT_AT_PI_SUPP_02'),
    },
    [GetHashKey('WEAPON_PISTOL_MK2')] = {
        ['esteso'] = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_02'),
        ['torcia'] = GetHashKey('COMPONENT_AT_PI_FLSH_02'),
        --['silenziatore'] = GetHashKey('COMPONENT_AT_PI_SUPP_02'), 
        ['compensatore'] = GetHashKey('COMPONENT_AT_PI_COMP'),
        ['mirino'] = GetHashKey('COMPONENT_AT_PI_RAIL'),
    },
    [GetHashKey('WEAPON_COMBATPISTOL')] = {
        ['esteso'] = GetHashKey('COMPONENT_COMBATPISTOL_CLIP_02'),
        ['torcia'] = GetHashKey('COMPONENT_AT_PI_FLSH'),
        --['silenziatore'] = GetHashKey('COMPONENT_AT_PI_SUPP'),
    },
    [GetHashKey('WEAPON_PISTOL50')] = {
        ['esteso'] = GetHashKey('COMPONENT_PISTOL50_CLIP_02'),
        ['torcia'] = GetHashKey('COMPONENT_AT_PI_FLSH'),
        --['silenziatore'] = GetHashKey('COMPONENT_AT_AR_SUPP_02')
    },
    [GetHashKey('WEAPON_SMG')] = {
        ['esteso'] = GetHashKey('COMPONENT_SMG_CLIP_02'),
        ['torcia'] = GetHashKey('COMPONENT_AT_AR_FLSH'),
        --['silenziatore'] = GetHashKey('COMPONENT_AT_PI_SUPP'),
        ['mirino'] = GetHashKey('COMPONENT_AT_SCOPE_MACRO_02'),
    },
    [GetHashKey('WEAPON_SMG_MK2')] = {
        ['esteso'] = GetHashKey('COMPONENT_SMG_MK2_CLIP_02'),
        ['torcia'] = GetHashKey('COMPONENT_AT_AR_FLSH'),
        --['silenziatore'] = GetHashKey('COMPONENT_AT_PI_SUPP'),
        ['mirino'] = GetHashKey('COMPONENT_AT_SIGHTS_SMG'),
    },
    [GetHashKey('WEAPON_ASSAULTSMG')] = {
        ['esteso'] = GetHashKey('COMPONENT_ASSAULTSMG_CLIP_02'),
        ['torcia'] = GetHashKey('COMPONENT_AT_AR_FLSH'),
        --['silenziatore'] = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
        ['mirino'] = GetHashKey('COMPONENT_AT_SCOPE_MACRO'),
    },
    [GetHashKey('WEAPON_MICROSMG')] = {
        ['esteso'] = GetHashKey('COMPONENT_MICROSMG_CLIP_02'),
        ['torcia'] = GetHashKey('COMPONENT_AT_PI_FLSH'),
        --['silenziatore'] = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
        ['mirino'] = GetHashKey('COMPONENT_AT_SCOPE_MACRO'),

    },
    [GetHashKey('WEAPON_ASSAULTRIFLE')] = {
        ['esteso'] = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_02'),
        ['torcia'] = GetHashKey('COMPONENT_AT_AR_FLSH'),
        --['silenziatore'] = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
        ['mirino'] = GetHashKey('COMPONENT_AT_SCOPE_MACRO'),
        ['grip'] = GetHashKey('COMPONENT_AT_AR_AFGRIP'),
    },
    [GetHashKey('WEAPON_ASSAULTRIFLE_MK2')] = {
        ['esteso'] = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_02'),
        ['torcia'] = GetHashKey('COMPONENT_AT_AR_FLSH'),
        --['silenziatore'] = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
        ['mirino'] = GetHashKey('COMPONENT_AT_SIGHTS'),
        ['grip'] = GetHashKey('COMPONENT_AT_AR_AFGRIP_02'),
    },
    [GetHashKey('WEAPON_CARBINERIFLE_MK2')] = {
        ['esteso'] = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_02'),
        ['torcia'] = GetHashKey('COMPONENT_AT_AR_FLSH'),
        --['silenziatore'] = GetHashKey('COMPONENT_AT_AR_SUPP'),
        ['mirino'] = GetHashKey('COMPONENT_AT_SIGHTS'),
        ['grip'] = GetHashKey('COMPONENT_AT_AR_AFGRIP_02'),
        },
    [GetHashKey('WEAPON_CARBINERIFLE')] = {
        ['esteso'] = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_02'),
        ['torcia'] = GetHashKey('COMPONENT_AT_AR_FLSH'),
        --['silenziatore'] = GetHashKey('COMPONENT_AT_AR_SUPP'),
        ['mirino'] = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM'),
        ['grip'] = GetHashKey('COMPONENT_AT_AR_AFGRIP'),
    },
    [GetHashKey('WEAPON_SPECIALCARBINE')] = {
        ['esteso'] = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_02'),
        ['torcia'] = GetHashKey('COMPONENT_AT_AR_FLSH'),
        --['silenziatore'] = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
        ['mirino'] = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM'),
        ['grip'] = GetHashKey('COMPONENT_AT_AR_AFGRIP'),
    },
    [GetHashKey('WEAPON_SPECIALCARBINE_MK2')] = {
        ['esteso'] = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_02'),
        ['torcia'] = GetHashKey('COMPONENT_AT_AR_FLSH'),
        --['silenziatore'] = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
        ['mirino'] = GetHashKey('COMPONENT_AT_SIGHTS'),
        ['grip'] = GetHashKey('COMPONENT_AT_AR_AFGRIP_02'),
    },
}

local BlipRapine = {
    ['vanilla_market'] = vector3(29.6967, -1339.991, 28.48206),
    ['market_1'] = vector3(2550.25, 385.6615, 107.6088),
    ['market_2'] = vector3(2673.824, 3287.024, 54.22852),
    ['market_3'] = vector3(545.5648, 2663.367, 41.15308),
    ['market_4'] = vector3(1707.864, 4920.382, 41.052),
    ['market_5'] = vector3(-3047.143, 586.9055, 6.897461),
    ['market_6'] = vector3(379.3846, 332.5187, 102.5538),
    ['market_7'] = vector3(-3249.191, 1005.824, 11.81763),
    ['paleto_twentyfourseven'] = vector3(1736.32, 6419.47, 34.03),
    ['sandyshores_twentyfoursever'] = vector3(1961.24, 3749.46, 31.34),
    ['littleseoul_twentyfourseven'] = vector3(-709.17, -904.21, 18.21),
    ['bar_one'] = vector3(1990.57, 3044.95, 46.21),
    ['ocean_liquor'] = vector3(-2959.33, 388.21, 13.00),
    ['rancho_liquor'] = vector3(1126.80, -980.40, 44.41),
    ['sanandreas_liquor'] = vector3(-1219.85, -916.27, 10.32),
    ['grove_ltd'] = vector3(-43.40, -1749.20, 28.42),
    ['mirror_ltd'] = vector3(1160.67, -314.40, 68.20),
    ['gabriela'] = vector3(1170.83, -295.76, 68.12),
    ['fleeca'] = vector3(311.22, -284.41, 53.16),
    ['fleeca2'] = vector3(-353.87, -55.29, 48.04),
    ['fleeca3'] = vector3(-1210.82, -336.52, 36.78),
    ['fleeca4'] = vector3(1176.053, 2712.752, 37.07544),
    ['fleeca5'] = vector3(-2956.602, 481.622, 14.68201),
    ['blaine'] = vector3(-105.34, 6476.72, 30.63),
    ['gioielleria'] = vector3(-628.5383, -235.3651, 37.0571),
}

local RedZoneBlips = {
    ["Forum Drive"] = vector3(-203.3849029541, -1567.7786865234, 35.237773895264),
    ["Vespucci"] = vector3(-1171.2470703125, -1586.1431884766, 4.3262186050415),
    ["Port"] = vector3(-131.87351989746, -2582.1647949219, 6.000705242157),
}

local BlipSpawnati = {}
function SpawnaBlips()
    for k, v in pairs(BlipRapine) do
        local blip = AddBlipForCoord(v.xyz)
        SetBlipSprite(blip, 156) 
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 0.9)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Robbery')
        EndTextCommandSetBlipName(blip)
        table.insert(BlipSpawnati, blip)
    end
    for k, v in pairs(RedZoneBlips) do
        local blip = AddBlipForCoord(v.xyz)
        SetBlipSprite(blip, 4)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 0.3)
        SetBlipHiddenOnLegend(blip, true)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(k)
        EndTextCommandSetBlipName(blip)
        table.insert(BlipSpawnati, blip)
    end
end

function TogliBlip()
    for k, v in pairs(BlipSpawnati) do
        RemoveBlip(v)
    end
    BlipSpawnati = {}
end

RegisterNetEvent("fenix:freeroam:entra", function ()
    FenixElite.InFreeroam = true
    FenixElite.EnableRadio = true
    FenixElite.EnableCrouch = true

    FenixElite.StartFreeroamSafezone()
    CreateThread(function()
        while FenixElite.InFreeroam do
            if not FenixElite.IsDead then
                FenixElite.CurrentWpn = GetSelectedPedWeapon(cache.ped)
            end
            Wait(2000)
        end
    end)
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.0)
    SetEntityCoords(cache.ped, FenixElite.CoordsFreeroam, true, false, false ,false)
    SetCanAttackFriendly(cache.ped, true, true)
    NetworkSetFriendlyFireOption(true)
    SpawnaBlips()
    FenixElite.Freeroam.RegistraMenu()
end)

RegisterNetEvent("fenix:freeroam:esci", function ()
    FenixElite.InFreeroam = false
    FenixElite.EnableRadio = false
    FenixElite.EnableCrouch = false

    RemoveAllPedWeapons(cache.ped, true)
    lib.hideMenu(true)
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.49)
    SetEntityCoords(cache.ped, FenixElite.LobbyCoords, true, false, false ,false)
    SetCanAttackFriendly(cache.ped, false, false)
    NetworkSetFriendlyFireOption(false)
    TriggerEvent("fenix:checkLeave")
    TogliBlip()
    Wait(1000)
    SetEntityInvincible(cache.ped, false)
end)

FenixElite.Freeroam.RegistraVeicoliSalvati = function ()
    local options = {}
    for k, v in pairs(FenixElite.Freeroam.VeicoliSalvati) do
        options[#options + 1] = {label = GetDisplayNameFromVehicleModel(v), args = {veicolo = v, index = k}}
    end

    lib.registerMenu({
        id = 'menu_freeroam',
        title = FenixElite.GetTranslation("freeroam_menu"),
        position = 'top-left',
        options = options
    }, function(selected, scrollIndex, args)
        if selected then
            lib.registerMenu({
                id = 'menu_freeroam',
                title = FenixElite.GetTranslation("freeroam_menu"),
                position = 'top-left',
                options = {
                    {label = 'Spawna Veicolo'},
                    {label = 'Rimuovi Veicolo'},
                }
            }, function(selected, scrollIndex, args2)
                if selected == 1 then
                    SpawnVeh(args.veicolo)
                elseif selected == 2 then
                    table.remove(FenixElite.Freeroam.VeicoliSalvati, args.index)
                    SetResourceKvp('fnx:veicoli', json.encode(FenixElite.Freeroam.VeicoliSalvati))
                    FenixElite.Freeroam.RegistraVeicoliSalvati()
                end
            end)
        end
    end)
end

FenixElite.Freeroam.MenuPlayer = function()
    local rst = lib.callback.await("fenix:freeroam:getPlayers")
    if not rst then return end

    local options = {}
    for _, v in pairs(rst) do
        options[#options + 1] = v
    end

    lib.registerMenu({
        id = 'menu_player',
        title = FenixElite.GetTranslation("freeroam_menu"),
        position = 'top-left',
        options = options
    }, function(selected, scrollIndex, args)
        if selected then
            if args and args.id then
                lib.registerMenu({
                    id = 'selected_player',
                    title = FenixElite.GetTranslation("freeroam_menu"),
                    position = 'top-left',
                    options = {
                        {label = FenixElite.GetTranslation("freeroam_teleport")},
                    }
                }, function(selected2, scrollIndex2, args2)
                    print(selected)
                    if selected2 == 1 then
                        TriggerServerEvent("fenix:freeroam:teleport", args.id)
                    end
                end)

                lib.showMenu("selected_player")
            end
        end
    end)

    lib.showMenu("menu_player")
end

FenixElite.Freeroam.RegistraMenu = function()
    -- Registro tutti i menu per il freeroam

    FenixElite.Freeroam.RegistraVeicoliSalvati()

    lib.registerMenu({
        id = 'menu_freeroam',
        title = FenixElite.GetTranslation("freeroam_menu"),
        position = 'top-left',
        options = {
            {label = FenixElite.GetTranslation("freeroam_player_menu")},
            {label = FenixElite.GetTranslation("freeroam_vehicle_menu")},
            {label = FenixElite.GetTranslation("freeroam_maps_menu")},
            {label = FenixElite.GetTranslation("freeroam_weapon_menu")},
        }
    }, function(selected, scrollIndex, args)
        if selected == 1 then
            FenixElite.Freeroam.MenuPlayer()
        elseif selected == 2 then
            lib.showMenu("menu_veicoli", 1)
        elseif selected == 3 then
            lib.showMenu("menu_mappe", 1)
        elseif selected == 4 then
            lib.showMenu("menu_armi", 1)
        end
    end)

    local vehOptions = {}
    for k, v in pairs(ListaVeicoli) do
        vehOptions[#vehOptions + 1] = {label = k,  args = {categoria = k}}
    end

    lib.registerMenu({
        id = 'veicoli_categoria',
        title = FenixElite.GetTranslation("freeroam_category"),
        position = 'top-left',
        options = vehOptions
    }, function(selected, scrollIndex, args)
        if selected then
            local categoria = args.categoria

            local listaVehs = {}
            for k, v in pairs(ListaVeicoli[categoria]) do
                listaVehs[#listaVehs + 1] = {label = v, args = {veicolo = v}}
            end

            lib.registerMenu({
                id = 'categoria_singola',
                title = FenixElite.GetTranslation("freeroam_category"),
                position = 'top-left',
                options = listaVehs
            }, function(selected, scrollIndex, args)
                ExecuteCommand("car ".. args.veicolo)
            end)

            lib.showMenu('categoria_singola', 1)
        end
    end)

    lib.registerMenu({
        id = 'menu_mappe',
        title = FenixElite.GetTranslation("freeroam_maps_menu"),
        position = 'top-left',
        options = FenixElite.Freeroam.Mappe
    }, function(selected, scrollIndex, args)
        if selected then
            SetEntityCoords(cache.ped, args.coords, true, false, false ,false)
        end
    end)

    lib.registerMenu({
        id = 'menu_armi',
        title = 'Menu Armi',
        position = 'top-left',
        options = {
            {label = FenixElite.GetTranslation("freeroam_kit_weapon")},
            {label = FenixElite.GetTranslation("freeroam_kit_weapon_r")},
            {label = FenixElite.GetTranslation("freeroam_giveall")},
            {label = FenixElite.GetTranslation("freeroam_removeall")},
            {label = FenixElite.GetTranslation("freeroam_weapon_list")}
        }
    }, function(selected, scrollIndex, args)
        if selected == 1 then
            ExecuteCommand('kit')
        elseif selected == 2 then
            ExecuteCommand('removekit')
        elseif selected == 3 then
            for category, weapons in pairs(WeaponList) do
                for weaponName, weaponHash in pairs(weapons) do
                    local wpnHash = GetHashKey(weaponHash)
                    GiveWeaponToPed(cache.ped, wpnHash, 999, false, true)
                    SetWeaponRecoilShakeAmplitude(wpnHash, 0.0)
                    SetGameplayCamRelativePitch(0.0, 1.0)
                end
            end
        elseif selected == 4 then
            RemoveAllPedWeapons(cache.ped, 1)
        elseif selected == 5 then
            lib.showMenu("categorie_armi")
        end
    end)

    local weaponCat = {}
    for category, _ in pairs(WeaponList) do
        weaponCat[#weaponCat + 1] = {label = category, args = {category = category}}
        for weaponName, weaponHash in pairs(WeaponList[category]) do
            SetWeaponRecoilShakeAmplitude(weaponHash, 0.0)
        end
    end

    print(json.encode(weaponCat, {indent = true}))

    lib.registerMenu({
        id = 'categorie_armi',
        title = 'Menu Armi',
        position = 'top-left',
        options = weaponCat
    }, function(selected, scrollIndex, args)
        if selected then
            local category = args.category

            local weaponList = {}
            for weaponName, weaponHash in pairs(WeaponList[category]) do
                weaponList[#weaponList + 1] = {label = weaponName, args = {weapon = weaponHash}}
            end

            lib.registerMenu({
                id = 'singola_categoria',
                title = FenixElite.GetTranslation("freeroam_vehicle_menu"),
                position = 'top-left',
                options = weaponList
            }, function(selected, scrollIndex, args)
                GiveWeaponToPed(cache.ped, GetHashKey(args.weapon), 999, false, true)
                SetWeaponRecoilShakeAmplitude(GetHashKey(args.weapon), 0.0)
                SetGameplayCamRelativePitch(0.0, 0.0)
            end)

            lib.showMenu('singola_categoria', 1)
        end
    end)

    lib.registerMenu({
        id = 'menu_veicoli',
        title = FenixElite.GetTranslation("freeroam_vehicle_menu"),
        position = 'top-left',
        options = {
            {label = FenixElite.GetTranslation("freeroam_spawn_vehicle")},
            {label = FenixElite.GetTranslation("freeroam_vehicle_list")},
            --[[ {label = 'Veicoli Salvati'}, ]]
        }
    }, function(selected, scrollIndex, args)
        if selected == 1 then
            local input = lib.inputDialog('Spawn Vehicle', {'Vehicle Name'})

            if input and input[1] then
                ExecuteCommand("car ".. input[1])
            end
        elseif selected == 2 then
            lib.showMenu("veicoli_categoria", 1)
--[[         elseif selected == 3 then
            lib.showMenu("veicoli_salvati", 1) ]]
        end
    end)
end

RegisterCommand("freeroamMenu", function ()
    if FenixElite.InFreeroam then
        lib.showMenu('menu_freeroam', 1)
    end
end, false)

RegisterKeyMapping("freeroamMenu", "Open freeroam menu", "keyboard", "M")

local BlacklistVehs = {
    [`jet`] = true,
}

local function SetCurrentPed(ped)
    local model = GetHashKey(ped)
    Wait(25)
    if model and IsModelValid(model) and IsModelInCdimage(model) then
        local pedd = PlayerPedId()
        NetworkRequestControlOfEntity(pedd)
        Wait(250)
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(25) end
        SetPlayerModel(PlayerId(), model)
        pedd = PlayerPedId()
        SetPedDefaultComponentVariation(pedd)
        ClearAllPedProps(pedd)
        ClearPedDecorations(pedd)
        ClearPedFacialDecorations(pedd)
        Wait(100)
        SetPedDefaultComponentVariation(pedd)
        SetModelAsNoLongerNeeded(model)
        FenixElite.Functions.Notify('Ped impostato con successo')
    end
end

local SpawnTimeout = false
function SpawnVeh(vehicle, networked)
    local peds = cache.ped
    if #(GetEntityCoords(peds) - vector3(-75.125274658203, -819.40222167969, 326.17358398438)) < 15 then
        FenixElite.Functions.Notify(FenixElite.GetTranslation("freeroam_spawn_zone"))
        return
    end
    if SpawnTimeout then
        FenixElite.Functions.Notify(FenixElite.GetTranslation("freeroam_spawn_now"))
        return
    end
    local model = type(vehicle) == 'number' and vehicle or GetHashKey(vehicle)
    if BlacklistVehs[model] then
        FenixElite.Functions.Notify(FenixElite.GetTranslation("freeroam_spawn_blacklist"))
        return
    end
    local oldVeh = GetVehiclePedIsIn(peds, false)
    if oldVeh and oldVeh > 0 then
        ExecuteCommand('dv')
        Wait(375)
    end
    networked = networked or true
    if not HasModelLoaded(model) and IsModelInCdimage(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end
    end
    local vector = GetEntityCoords(peds)
    local veh = CreateVehicle(model, vector.x, vector.y, (vector.z + 0.5), GetEntityHeading(peds), networked, true)
    Wait(25)
    if veh and veh > 0 then
        NetworkRequestControlOfEntity(veh)
        SetVehicleHasBeenOwnedByPlayer(veh, true)
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(veh), true)
        SetEntityAsMissionEntity(veh, true, true)
        SetVehicleNeedsToBeHotwired(veh, false)
        SetVehRadioStation(veh, 'OFF')
        RequestCollisionAtCoord(vector.x, vector.y, vector.z)
        while not HasCollisionLoadedAroundEntity(veh) do Wait(0) end
        SetModelAsNoLongerNeeded(model)
        SetPedIntoVehicle(peds, veh, -1)
        SpawnTimeout = true
        FenixElite.Functions.Notify(FenixElite.GetTranslation("freeroam_vehicle_spawned"))
        Wait(10*1000)
        SpawnTimeout = false
    end
end

RegisterCommand('kit',function (src,arg)
    local Ped = GetPlayerPed(-1)
    if not FenixElite.InFreeroam then return end
     if IsPedArmed(Ped, 4) then
        local WeaponHash = GetSelectedPedWeapon(Ped)
         if WeaponHash ~= nil then
             if arg[1] == nil then
                 if ListaComponenti[WeaponHash] ~= nil then
                     for a, b in pairs(ListaComponenti[WeaponHash]) do
                         GiveWeaponComponentToPed(Ped, WeaponHash, b)
                     end
                 end
             else
                 if ListaComponenti[WeaponHash][arg[1]] ~= nil then
                     GiveWeaponComponentToPed(Ped, WeaponHash, ListaComponenti[WeaponHash][arg[1]])
                 end
             end
             FenixElite.Functions.Notify('Hai Aggiunto tutti gli accessori disponibili per la tua arma')
         end
     else
         FenixElite.Functions.Notify(FenixElite.GetTranslation("no_weapon_in_hand"))
     end
 end)
 
 RegisterCommand('removekit',function (src,arg)
     local Ped = GetPlayerPed(-1)
     if not FenixElite.InFreeroam then return end
     if IsPedArmed(Ped, 4) then
         local WeaponHash = GetSelectedPedWeapon(Ped)
         if WeaponHash ~= nil then
             if arg[1] == nil then
                 if ListaComponenti[WeaponHash] ~= nil then
                     for a, b in pairs(ListaComponenti[WeaponHash]) do
                         RemoveWeaponComponentFromPed(Ped, WeaponHash, b)
                     end
                 end
             else
                 if ListaComponenti[WeaponHash][arg[1]] ~= nil then
                     RemoveWeaponComponentFromPed(Ped, WeaponHash, ListaComponenti[WeaponHash][arg[1]])
                 end
             end
             FenixElite.Functions.Notify('Hai Rimosso tutti gli accessori dalla tua arma')
         end
     else
         FenixElite.Functions.Notify('Non hai un arma in mano')
     end
 end)
 
 RegisterCommand('colorazione',function (src,arg)
     local Ped = GetPlayerPed(-1)
     if not FenixElite.InFreeroam then return end
     if IsPedArmed(Ped, 4) then
         local WeaponHash = GetSelectedPedWeapon(Ped)
         if WeaponHash ~= nil then
             if tonumber(arg[1]) ~= nil then
                 if tonumber(arg[1]) <= GetWeaponTintCount(WeaponHash) then
                     SetPedWeaponTintIndex(Ped, WeaponHash, tonumber(arg[1]))
                     FenixElite.Functions.Notify(FenixElite.GetTranslation("skin_added"):format(tonumber(arg[1])))
                 else
                     FenixElite.Functions.Notify(FenixElite.GetTranslation("skin_not_exist"))
                 end
             else
                 FenixElite.Functions.Notify(FenixElite.GetTranslation("insert_valid_value"))
             end
         end
     else
         FenixElite.Functions.Notify(FenixElite.GetTranslation("no_weapon_in_hand"))
     end
 end)

 RegisterCommand('ammo',function (src,arg)
    if not FenixElite.InFreeroam then return end
    
     local Ped = GetPlayerPed(-1)
     if IsPedArmed(Ped, 4) then
         local WeaponHash = GetSelectedPedWeapon(Ped)
         if WeaponHash ~= nil then
             AddAmmoToPed(Ped, WeaponHash, 500)
             FenixElite.Functions.Notify(FenixElite.GetTranslation("ammo_loaded"))
         end
     else
         FenixElite.Functions.Notify(FenixElite.GetTranslation("no_weapon_in_hand"))
     end
 end)

 RegisterCommand('car', function(source, args)
     if not FenixElite.InFreeroam then return end
     local argo = args[1] or 't20'
     SpawnVeh(argo)
 end)
 
 RegisterCommand('dv', function(source, args)
     if not FenixElite.InFreeroam then return end
     local peds = PlayerPedId()
     local veh = GetVehiclePedIsIn(peds, false)
     if not veh or veh <= 0 then
         veh = GetClosestVehicle(GetEntityCoords(peds), 15, 0, 2)
     end
     NetworkRequestControlOfEntity(veh)
     DeleteEntity(veh)
 end)

RegisterCommand("noclip", function ()
    if not FenixElite.InFreeroam then return end

    if FenixElite.inNoclip then
        FenixElite.inNoclip = false
    else
        NoClip()
    end
end)

RegisterKeyMapping("noclip", "NoClip", "keyboard", "F6")

 function InfoNoClip(heading)
	Scale = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS");
    while not HasScaleformMovieLoaded(Scale) do
        Citizen.Wait(0)
	end

    BeginScaleformMovieMethod(Scale, "CLEAR_ALL");
    EndScaleformMovieMethod();

    BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
    ScaleformMovieMethodAddParamInt(0);
    PushScaleformMovieMethodParameterString("~INPUT_SPRINT~");
    PushScaleformMovieMethodParameterString("Velocità corrente: "..speed);
    EndScaleformMovieMethod();

    BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
    ScaleformMovieMethodAddParamInt(1);
    PushScaleformMovieMethodParameterString("~INPUT_MOVE_LR~");
    PushScaleformMovieMethodParameterString("Sinistra/Destra");
    EndScaleformMovieMethod();

    BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
    ScaleformMovieMethodAddParamInt(2);
    PushScaleformMovieMethodParameterString("~INPUT_MOVE_UD~");
    PushScaleformMovieMethodParameterString("Dietro/Avanti");
    EndScaleformMovieMethod();

    BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
    ScaleformMovieMethodAddParamInt(3);
    PushScaleformMovieMethodParameterString("~INPUT_MULTIPLAYER_INFO~");
    PushScaleformMovieMethodParameterString("Scendi");
    EndScaleformMovieMethod();

    BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
    ScaleformMovieMethodAddParamInt(4);
    PushScaleformMovieMethodParameterString("~INPUT_COVER~");
    PushScaleformMovieMethodParameterString("Sali");
    EndScaleformMovieMethod();

    BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
    ScaleformMovieMethodAddParamInt(7);
    PushScaleformMovieMethodParameterString("Rotazione: "..math.floor(heading));
    EndScaleformMovieMethod();

    BeginScaleformMovieMethod(Scale, "DRAW_INSTRUCTIONAL_BUTTONS");
    ScaleformMovieMethodAddParamInt(0);
    EndScaleformMovieMethod();

    DrawScaleformMovieFullscreen(Scale, 255, 255, 255, 255, 0);
end


local noclip_pos

NoClip = function()

    FenixElite.inNoclip = true
    noclip_pos = GetEntityCoords(cache.ped, false)

    CreateThread(function()
        while true do
            Citizen.Wait(1)
            local ped = cache.ped
            local targetVeh = GetVehiclePedIsUsing(ped)
            if IsPedInAnyVehicle(ped) then
                ped = targetVeh
            end

            if FenixElite.inNoclip and FenixElite.InFreeroam then
                InfoNoClip(heading)

                SetEntityInvincible(ped, true)
                SetEntityVisible(ped, false, false)

                SetEntityLocallyVisible(ped)
                SetEntityAlpha(ped, 100, false)
                SetBlockingOfNonTemporaryEvents(ped, true)
                ForcePedMotionState(ped, -1871534317, 0, 0, 0)

                SetLocalPlayerVisibleLocally(ped)
                --SetEntityAlpha(ped, (255 * 0.2), 1)
                SetEntityCollision(ped, false, false)
                
                SetEntityCoordsNoOffset(ped, noclip_pos.x, noclip_pos.y, noclip_pos.z, true, true, true)

                if IsControlPressed(1, 34) then
                    heading = heading + 2.0
                    if heading > 359.0 then
                        heading = 0.0
                    end

                    SetEntityHeading(ped, heading)
                end

                if IsControlPressed(1, 9) then
                    heading = heading - 2.0
                    if heading < 0.0 then
                        heading = 360.0
                    end

                    SetEntityHeading(ped, heading)
                end
                heading = GetEntityHeading(ped)

                if IsControlJustPressed(1, 21) then
                    if speed == 0.1 then
                        speed = 0.2
                        up_down_speed = 0.2
                    elseif speed == 0.2 then
                        speed = 0.3
                        up_down_speed = 0.3
                    elseif speed == 0.3 then
                        speed = 0.5
                        up_down_speed = 0.5
                    elseif speed == 0.5 then
                        speed = 1.5
                        up_down_speed = 0.5
                    elseif speed == 1.5 then
                        speed = 2.5
                        up_down_speed = 0.9
                    elseif speed == 2.5 then
                        speed = 3.5
                        up_down_speed = 1.3
                    elseif speed == 3.5 then
                        speed = 4.5
                        up_down_speed = 1.5
                    elseif speed == 4.5 then
                        speed = 0.1
                        up_down_speed = 0.1
                    end
                end

                if IsControlPressed(1, 8) then
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, -speed, 0.0)
                end

                if IsControlPressed(1, 44) and IsControlPressed(1, 32) then -- Q e W
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, speed, up_down_speed)
                elseif IsControlPressed(1, 44) then -- solo Q
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, up_down_speed)
                elseif IsControlPressed(1, 32) then -- solo W
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, speed, 0.0)
                end

                if IsControlPressed(1, 20) and IsControlPressed(1, 32) then -- Z e W
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, speed, -up_down_speed)
                elseif IsControlPressed(1, 20) then -- solo Z
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -up_down_speed)
                end
            else
                SetEntityInvincible(ped, false)
                ResetEntityAlpha(ped)
                SetEntityVisible(ped, true, false)
                SetEntityCollision(ped, true, false)
                SetBlockingOfNonTemporaryEvents(ped, false)

                return
            end
        end
    end)
end


FenixElite.StartFreeroamSafezone = function()
    CreateThread(function()
        while FenixElite.InFreeroam do
            local dist = #(GetEntityCoords(cache.ped) - vector3(-75.125274658203, -819.40222167969, 326.17358398438))
    
            if dist < 100 then
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
                DisableControlAction(1, 36, true)
                DisableControlAction(1, 44, true)
                DisableControlAction(1, 257, true)
                DisableControlAction(1, 24, true)
            else
                Wait(1500)
            end
            Wait(1)
        end
    end)
end