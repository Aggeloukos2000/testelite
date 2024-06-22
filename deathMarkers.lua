FenixElite.DeathMarker = {}

-- Encodes a character as a percent encoded string
local function char_to_pchar(c)
	return string.format("%%%02X", c:byte(1,1))
end

-- encodeURI replaces all characters except the following with the appropriate UTF-8 escape sequences:
-- ; , / ? : @ & = + $
-- alphabetic, decimal digits, - _ . ! ~ * ' ( )
-- #
local function encodeURI(str)
	return (str:gsub("[^%;%,%/%?%:%@%&%=%+%$%w%-%_%.%!%~%*%'%(%)%#]", char_to_pchar))
end

FenixElite.DeathMarker.TextureDictory = 'fnxMarkers'
FenixElite.DeathMarker.Txd = CreateRuntimeTxd(FenixElite.DeathMarker.TextureDictory)
FenixElite.PlayersGenerated = {}

FenixElite.DeathMarker.GenerateTexture = function(mId, Img)
    if not FenixElite.PlayersGenerated[mId] then
        Img = 'http://185.229.237.160/altro.html?src='.. encodeURI(Img)
        local duiObj = CreateDui(Img, 250, 250)
        local dui = GetDuiHandle(duiObj)
        local boh = CreateRuntimeTextureFromDuiHandle(FenixElite.DeathMarker.Txd, mId, dui)

        FenixElite.PlayersGenerated[mId] = true
    end
end