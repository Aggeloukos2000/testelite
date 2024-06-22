function Noti(type, title, message, time, position)
	SendNUIMessage({
		action = 'notification',
		type = type,
        title = title,
        message = message,
        time = time,
		position = position -- left - appears on the left side of the screen, right - appears on the right side of the screen
	})
end

RegisterNetEvent('VCore-Noti:Noti')
AddEventHandler('VCore-Noti:Noti', function(type, title, message, time, position)
	Noti(type, title, message, time, position)
end)

RegisterNetEvent("FenixElite:ApriBrowserSponsor", function(url)
	SendNUIMessage({
		action = 'apriBrowser',
		url = url
	})
end)

RegisterCommand("getVeh", function ()
	print(GetVehiclePedIsIn(PlayerPedId(), false))
	SetVehicleUndriveable(GetVehiclePedIsIn(PlayerPedId(), false), true)
end, false)