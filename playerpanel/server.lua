ESX = nil
local connectedPlayers = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local owner = {
	['owner'] = true;
	['dev'] = false;
	['admincontroller'] = false;
	['superadmin'] = false;
	['admin'] = false;
	['mod'] = false;
}


ESX.RegisterServerCallback('playerpanel:getConnectedPlayers', function(source, cb)
	cb(connectedPlayers)
end)


AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	connectedPlayers[playerId].job = job.name

	TriggerClientEvent('playerpanel:updateConnectedPlayers', -1, connectedPlayers)
end)

AddEventHandler('esx:playerLoaded', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

		AddPlayerToScoreboard(xPlayer, true)
		TriggerClientEvent('playerpanel:updateConnectedPlayers', -1, connectedPlayers)
end)

AddEventHandler('esx:playerDropped', function(playerId)
	connectedPlayers[playerId] = nil

	TriggerClientEvent('playerpanel:updateConnectedPlayers', -1, connectedPlayers)
end)


ESX.RegisterServerCallback('playerpanel:adatoklekerdezese2', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local info = {
		money = xPlayer.getMoney(),
		bankMoney = xPlayer.getAccount('bank').money,
    	blackMoney = xPlayer.getAccount('black_money').money,
		icname = xPlayer.getName(source),
    	grade = xPlayer.job.grade_label,
		job = xPlayer.job.label,
		group = xPlayer.getGroup(source),
	}
	cb(info)
end)

RegisterServerEvent('playerpanel:setVehicle')
AddEventHandler('playerpanel:setVehicle', function (vehicleProps, playerID,model)
	local _source = playerID
	local xPlayer = ESX.GetPlayerFromId(_source)
	local date = os.date("%y/%m/%d %X")
	sourceid = GetPlayerIdentifiers(_source)[1]

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, stored) VALUES (@owner, @plate, @vehicle, @stored)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@stored']  = 1
	}, function ()
	end)
	MySQL.Async.execute("INSERT INTO premiumpont_log (steamid, cuccneve	, darab,kocsi, datum) VALUES (@steamid, @cuccneve, @darab, @kocsi, @datum)", {['@steamid'] = sourceid, ['@cuccneve'] = model, ['@darab'] = "1", ['@kocsi'] = "IGEN", ['@datum'] = date})
	TriggerClientEvent("csp_notify", _source,'success', "Sikeresen megvetted az új autódat,ezt megtalálod már a garázsban", 4500,"")
end)

RegisterServerEvent('playerpanel:barattorlese')
AddEventHandler('playerpanel:barattorlese', function (source,id)
	local result = MySQL.Sync.fetchAll("SELECT * FROM csp_friendlist WHERE `index` = @index", {['@index'] = id})

	if result[1] ~= nil then
	local value = result[1]

	Citizen.CreateThread(function()
		for i, v in ipairs(GetPlayers()) do
		 	--print(v)
			if (value['friend1_steam_identifier'] == GetPlayerIdentifiers(v)[1]) or (value['friend2_steam_identifier'] == GetPlayerIdentifiers(v)[1]) then
				exports['csp_labels']:refreshFriends(v)
			end
		end
	end)
	end

	MySQL.Sync.execute("DELETE FROM csp_friendlist WHERE `index` = @index", {
        ['@index'] = id
	})
	exports['csp_labels']:refreshFriends(source)
end)


ESX.RegisterServerCallback('playerpanel:baratlekerdez', function(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]
	local baratlista = {}

		local result = MySQL.Sync.fetchAll("SELECT * FROM csp_friendlist WHERE friend1_steam_identifier = @friend1_steam_identifier", {['@friend1_steam_identifier'] = identifier})
		local result2 = MySQL.Sync.fetchAll("SELECT * FROM csp_friendlist WHERE friend2_steam_identifier = @friend2_steam_identifier", {['@friend2_steam_identifier'] = identifier})
		for _,v in pairs(result) do
			table.insert(baratlista, {icname = v.friend2_name, added = v.added, index = v.index})
		end
		for _,v in pairs(result2) do
			table.insert(baratlista, {icname = v.friend1_name, added = v.added, index = v.index})
		end
		cb(baratlista)
end)


ESX.RegisterServerCallback("playerpanel:getBalance", function(source)
    local id = GetPlayerIdentifiers(source)[1]
    MySQL.Async.fetchAll('SELECT pont FROM premiumpont WHERE identifier = @identifier', {
		['@identifier'] = id
    }, 
    function(result)
		if result[1] then
            TriggerClientEvent("playerpanel:setBalance", source, result[1].pont)
		else
            TriggerClientEvent("playerpanel:setBalance", source, 0)
		end
	end)
end)


ESX.RegisterServerCallback('playerpanel:kocsileker', function(source, cb)
	local ownedCars = {}
	local identifier = GetPlayerIdentifiers(source)[1]
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
	['@owner'] = xPlayer.identifier,
	['@Type'] = 'car',
	['@job'] = 'civ'
}, function(data)
	for _,v in pairs(data) do
		local vehicle = json.decode(v.vehicle)
		table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
	end
	cb(ownedCars)
end)
end)

RegisterServerEvent("playerpanel:getSteam")
AddEventHandler("playerpanel:getSteam", function(steam)
    steam = GetPlayerIdentifier(source)
    TriggerClientEvent("playerpanel:setSteam", source, steam)
end)

RegisterServerEvent("playerpanel:storeBalance")
AddEventHandler("playerpanel:storeBalance", function(price)
    local id = GetPlayerIdentifiers(source)[1]
    local done = nil
    MySQL.Async.execute('UPDATE premiumpont SET pont = pont - @price WHERE identifier = @identifier', {
        ['@identifier'] = id,
        ['@price'] = price
    }, function(done)
    end)

    TriggerClientEvent("playerpanel:updateBalance", source)
end)

RegisterServerEvent("playerpanel:giveItem")
AddEventHandler("playerpanel:giveItem", function(amount, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local date = os.date("%y/%m/%d %X")
	sourceid = GetPlayerIdentifiers(source)[1]
	xPlayer.addInventoryItem(item, amount)
	MySQL.Async.execute("INSERT INTO premiumpont_log (steamid, cuccneve	, darab, datum) VALUES (@steamid, @cuccneve, @darab, @datum)", {['@steamid'] = sourceid, ['@cuccneve'] = item, ['@darab'] = amount, ['@datum'] = date})
	TriggerClientEvent("csp_notify", source,'success', "Sikeresen megvetted a tárgyat,már megtalálható az inventorydban", 4500,"")
end)

RegisterServerEvent("playerpanel:giveWeapon")
AddEventHandler("playerpanel:giveWeapon", function(ammo, weapon)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addWeapon(weapon, ammo)
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		UpdatePing()
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.CreateThread(function()
			Citizen.Wait(1000)
			AddPlayersToScoreboard()
		end)
	end
end)

function AddPlayerToScoreboard(xPlayer, update)
	local playerId = xPlayer.source

	connectedPlayers[playerId] = {}
	connectedPlayers[playerId].ping = GetPlayerPing(playerId)
	connectedPlayers[playerId].name = xPlayer.getName()
	connectedPlayers[playerId].playerId = playerId
	connectedPlayers[playerId].job = xPlayer.job.name

	if update then
		TriggerClientEvent('playerpanel:updateConnectedPlayers', -1, connectedPlayers)
	end
end
RegisterServerEvent("playerpanel:kurvaanyad")
AddEventHandler('playerpanel:kurvaanyad', function()
	AddPlayersToScoreboard()
end)

function AddPlayersToScoreboard()
	local players = ESX.GetPlayers()

	for i=1, #players, 1 do
		local xPlayer = ESX.GetPlayerFromId(players[i])
		AddPlayerToScoreboard(xPlayer, false)
	end

	TriggerClientEvent('playerpanel:updateConnectedPlayers', -1, connectedPlayers)
end

function UpdatePing()
	for k,v in pairs(connectedPlayers) do
		v.ping = GetPlayerPing(k)
	end

	TriggerClientEvent('playerpanel:updatePing', -1, connectedPlayers)
end
