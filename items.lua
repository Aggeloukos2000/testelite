FenixElite.Items = {}
FenixElite.Items.List = {}

RegisterNetEvent("fenix:addItem", function (itemIndex)
    table.insert(FenixElite.Items.List, itemIndex)

    SendReactMessage("fenix:updateItems", FenixElite.Items.List)
end)

RegisterNUICallback('getAllBoughtItems', function(_, cb)
    cb(FenixElite.Items.List)
end)