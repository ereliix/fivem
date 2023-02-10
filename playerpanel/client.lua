ESX = nil

local steamId = nil
local balance = nil
local update = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
	Citizen.Wait(100)
	ESX.TriggerServerCallback('playerpanel:getConnectedPlayers', function(connectedPlayers)
		UpdatePlayerTable(connectedPlayers)
	end)
	TriggerServerEvent("csp_admin:getAdmins")
end)

local antiSpam = false

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustPressed(1, 212) then
			adatok()
			Citizen.Wait(20)
			noSpam(2000)
		end
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)
	SendNUIMessage({
		action = 'updateServerInfo',

		maxPlayers = GetConvarInt('sv_maxclients', 200),
		uptime = 'unknown',
		playTime = '00h 00m'
	})
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded",function(xPlayer)
    ESX.PlayerData = xPlayer
    local id = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))

	ESX.TriggerServerCallback('playerpanel:getConnectedPlayers', function(connectedPlayers)
		UpdatePlayerTable(connectedPlayers)
	end)

end)

RegisterNetEvent('playerpanel:updateConnectedPlayers')
AddEventHandler('playerpanel:updateConnectedPlayers', function(connectedPlayers)
	UpdatePlayerTable(connectedPlayers)
end)

RegisterNetEvent('playerpanel:updatePing')
AddEventHandler('playerpanel:updatePing', function(connectedPlayers)
	SendNUIMessage({
		action  = 'updatePing',
		players = connectedPlayers
	})
end)

RegisterNetEvent('uptime:tick')
AddEventHandler('uptime:tick', function(uptime)
	SendNUIMessage({
		action = 'updateServerInfo',
		uptime = uptime
	})
end)

function UpdatePlayerTable(connectedPlayers)
	local formattedPlayerList, num = {}, 1
	local ems, police, taxi, mechanic, slaughterer, fueler, lumberjack, tailor, reporter, miner, unemployed, estate, cardeal, arma, stato, players = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

	for k,v in pairs(connectedPlayers) do

		if num == 1 then
			table.insert(formattedPlayerList, ('<tr><td>%s</td><td>%s</td>'):format(v.playerId, v.ping))
			num = 2
		elseif num == 2 then
			table.insert(formattedPlayerList, ('<td>%s</td><td>%s</td></tr>'):format(v.playerId, v.ping))
			num = 1
		end
		players = players + 1
		if v.job == 'ambulance' then
			ems = "✔️"
		elseif v.job == 'police' then
			police = "✔️"
		elseif v.job == 'mechanic' then
			mechanic = "✔️"
		elseif v.job == 'firefighter' then
			firefighter = "✔️"
		end
	end

	if num == 1 then
		table.insert(formattedPlayerList, '</tr>')
	end

	SendNUIMessage({
		action  = 'updatePlayerList',
		players = table.concat(formattedPlayerList)
	})

	SendNUIMessage({
		action = 'updatePlayerJobs',
		jobs   = {ems = ems, police = police, firefighter = firefighter, mechanic = mechanic, slaughterer = slaughterer, fueler = fueler, lumberjack = lumberjack, tailor = tailor, reporter = reporter, miner = miner, unemployed = unemployed, estate = estate, cardeal = cardeal, arma = arma, stato = stato, player_count = players}
	})
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 212) and IsInputDisabled(0) then
			ToggleScoreBoard()
			Citizen.Wait(200)
	end
end
end)


function ToggleScoreBoard()
	TriggerServerEvent('playerpanel:kurvaanyad')
	SendNUIMessage({
		action = 'toggle'
	})
end

Citizen.CreateThread(function()
	local playMinute, playHour = 0, 0

	while true do
		Citizen.Wait(1000 * 60) -- every minute
		playMinute = playMinute + 1
	
		if playMinute == 60 then
			playMinute = 0
			playHour = playHour + 1
		end

		SendNUIMessage({
			action = 'updateServerInfo',
			playTime = string.format("%02dh %02dm", playHour, playMinute)
		})
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		while antiSpam do
			Citizen.Wait(0)
			if IsControlJustPressed(1, 212) then
				--exports['mythic_notify']:DoHudText('error', 'Kérlek várj egy másodpercet!', { ['background-color'] = '#ff2a2a', ['color'] = '#ffffff' })
				TriggerEvent("csp_notify", 'error', "Kérlek várj egy másodpercet mielott megnyitod a menut!", 4500,"")
			end
		end
	end
end)

function noSpam(sec)
	antiSpam = true
	Citizen.Wait(sec)
	antiSpam = false
end


function dump(o)
	if type(o) == 'table' then
	   local s = '{ '
	   for k,v in pairs(o) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end
		  s = s .. '['..k..'] = ' .. dump(v) .. ','
	   end
	   return s .. '} '
	else
	   return tostring(o)
	end
 end
 RegisterCommand("p", function()
    close()
end)

function close()
    SendNUIMessage({
        type = "ui",
        status = false,
    })
    SetNuiFocus(false, false)
end

RegisterCommand("tesztelek", function()
	exports['csp_progbar']:startUI(4500, "fasz")
end)

RegisterNetEvent("playerpanel:updateadmin")
AddEventHandler("playerpanel:updateadmin",function(admins)
	local adminlist = {}

	local owner, dev, admincontroller, superadmin, admin, mod = 0, 0, 0, 0, 0, 0

	for k,v in ipairs(admins) do
		if v[3] == "owner" then
			owner = owner + 1
		elseif v[3] == "dev" then
			dev = dev + 1
		elseif v[3] == "admincontroller" then
			admincontroller = admincontroller + 1
		elseif v[3] == "superadmin" then
			superadmin = superadmin + 1
		elseif v[3] == "admin" then
			admin = admin + 1
		elseif v[3] == "mod" then
			mod = mod + 1
		end
	end

	adminlist[1] = {["id"] = 1, ["group"] = "owner", ["name"] = owner .. " fő"}
	adminlist[2] = {["id"] = 2, ["group"] = "dev", ["name"] = dev .. " fő"}
	adminlist[3] = {["id"] = 3, ["group"] = "admincontroller", ["name"] = admincontroller .. " fő"}
	adminlist[4] = {["id"] = 4, ["group"] = "superadmin", ["name"] = superadmin .. " fő"}
	adminlist[5] = {["id"] = 5, ["group"] = "admin", ["name"] = admin .. " fő"}
	adminlist[6] = {["id"] = 6, ["group"] = "mod", ["name"] = mod .. " fő"}

	SendNUIMessage({
		type="admin",
		admins=adminlist
	})
end)


RegisterNUICallback('hudon', function(data, cb)
	TriggerEvent("hud:toggleui", true)
end)

RegisterNUICallback('hudoff', function(data, cb)
	TriggerEvent("hud:toggleui", false)
end)

RegisterNUICallback('chaton', function(data, cb)
	TriggerEvent('chat:toggleChat',true)
end)

RegisterNUICallback('chatoff', function(data, cb)
	TriggerEvent('chat:toggleChat',false)
end)

RegisterNUICallback('baratok', function(data, cb)
	local pina = GetPlayerServerId(PlayerId())
	local x = data.x
	TriggerServerEvent('playerpanel:barattorlese', pina,x)
end)

function adatok()
	ESX.TriggerServerCallback("playerpanel:getBalance")
	ESX.TriggerServerCallback('playerpanel:adatoklekerdezese2', function(adatok)
					TriggerServerEvent("playerpanel:getSteam")					
					while steamId == nil or update == false do
						Citizen.Wait(20)
					end
					update = false
					Citizen.Wait(450)
					SendNUIMessage({
					type = "ui",
					penz=adatok.money, 
					munka=adatok.job.." - "..adatok.grade,
					bank=adatok.bankMoney,
					black=adatok.blackMoney,
					group=adatok.group,
					name=adatok.icname,
					steam = steamId,
					bal = balance,
					status = true,
				})
				SetNuiFocus(true, true)
	end)

	ESX.TriggerServerCallback('playerpanel:kocsileker', function(ownedCars)
		local vehicles = {};
		for key,vehicleData in pairs(ownedCars) do
			local hashVehicule = vehicleData.vehicle.model
			local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
			local vehicleName = GetLabelText(aheadVehName)
			local plate = vehicleData.plate
			local Fuel = tonumber(vehicleData.vehicle.fuelLevel)
				vehicles[#vehicles + 1] = {}
				vehicles[#vehicles] = {
					plate = vehicleData['plate'],
					kocsimodel = vehicleName,
					stored = vehicleData['stored'],
					fuel = Fuel
				}
		end	
		if (#vehicles == #ownedCars) then 	
			SendNUIMessage({
				type = 'kocsi',
				kocsik = vehicles
			});
		end
	end)
	ESX.TriggerServerCallback('playerpanel:baratlekerdez', function(baratlista)
	SendNUIMessage({
		type="barat",
		barat = baratlista,
	})
	end)
end

function buy(price, func) 
    SendNUIMessage({
        type = "wait",
        wait = true
    })
    ESX.TriggerServerCallback("playerpanel:getBalance")
    while not update do
        Citizen.Wait(20)
    end
    update = false

    if balance >= price then 
        TriggerServerEvent("playerpanel:storeBalance", price)
        TriggerEvent(func)

        while not update do
            Citizen.Wait(0)
        end
        update = false

        ESX.TriggerServerCallback("playerpanel:getBalance")

        while not update do
            Citizen.Wait(0)
        end
        update = false
    else 
		--exports['mythic_notify']:DoHudText('error', 'Nincs elég pontod!', { ['background-color'] = '#ff2a2a', ['color'] = '#ffffff' })
		TriggerEvent("csp_notify", 'error', "Nincs rá elég csudapest pontod!", 4500,"")
    end

    SendNUIMessage({
        type = "wait",
        wait = false
    })

end

-- //////////////////////////////////////////////////////

RegisterNetEvent("playerpanel:setSteam")
AddEventHandler("playerpanel:setSteam", function(data)
    steamId = string.gsub(data,"steam:", "")
    update=true
end)


RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent("playerpanel:setBalance")
AddEventHandler("playerpanel:setBalance", function(bal)

    balance = bal
    update = true

    SendNUIMessage({
        type = "balance",
        bal = balance
    })

end)

RegisterNetEvent("playerpanel:updateBalance")
AddEventHandler("playerpanel:updateBalance", function(bal)
    update = true
end)

RegisterNUICallback("buy", function(data)
	buy(data.price, data.func)
end)

RegisterNetEvent('playerpanel:spawnVehicle')
AddEventHandler('playerpanel:spawnVehicle', function(playerID, model, playerName, type)
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
	local carExist  = false
	ESX.Game.SpawnVehicle(model, coords, 0.0, function(vehicle) --get vehicle info
		if DoesEntityExist(vehicle) then
			carExist = true
			SetEntityVisible(vehicle, false, false)
			SetEntityCollision(vehicle, false)
			
			local newPlate     = exports.d3x_vehicleshop:GeneratePlate()
			local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			vehicleProps.plate = newPlate
			TriggerServerEvent('playerpanel:setVehicle', vehicleProps, playerID,model)
			ESX.Game.DeleteVehicle(vehicle)	
			if type ~= 'console' then
				ESX.ShowNotification(_U('gived_car', model, newPlate, playerName))
			else
				local msg = ('addCar: ' ..model.. ', plate: ' ..newPlate.. ', toPlayer: ' ..playerName)
				TriggerServerEvent('esx_giveownedcar:printToConsole', msg)
			end				
		end		
	end)
	
	Wait(2000)
	if not carExist then
		if type ~= 'console' then
			print("nincs ilyen")
		else
			TriggerServerEvent('esx_giveownedcar:printToConsole', "ERROR: "..model.." is an unknown vehicle model")
		end		
	end
end)

-- //////////////////////////////////PP ITEMEK///////////////////////////////////
RegisterNetEvent("givecaraudir8")
AddEventHandler("givecaraudir8", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'r820', geci, 'player')
end)

RegisterNetEvent("givecaraudirs6")
AddEventHandler("givecaraudirs6", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'rs62', geci, 'player')
end)

RegisterNetEvent("givecarmercamggtr")
AddEventHandler("givecarmercamggtr", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'amggtr18', geci, 'player')
end)

RegisterNetEvent("givecarmercike")
AddEventHandler("givecarmercike", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'e63sf', geci, 'player')
end)

RegisterNetEvent("givecarastonm")
AddEventHandler("givecarastonm", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'rmodmartin', geci, 'player')
end)


RegisterNetEvent("givecaraudisq7")
AddEventHandler("givecaraudisq7", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'sq72016', geci, 'player')
end)

RegisterNetEvent("givecarbmwe60m5")
AddEventHandler("givecarbmwe60m5", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'm5e60', geci, 'player')
end)

RegisterNetEvent("givecarbentleyc")
AddEventHandler("givecarbentleyc", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'rmodbentleygt', geci, 'player')
end)

RegisterNetEvent("givemercamg")
AddEventHandler("givemercamg", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'rmodgt63', geci, 'player')
end)

RegisterNetEvent("givemustang")
AddEventHandler("givemustang", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'rmodmustang', geci, 'player')
end)

RegisterNetEvent("givedodge")
AddEventHandler("givedodge", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'rampage10', geci, 'player')
end)

RegisterNetEvent("giveyamaha")
AddEventHandler("giveyamaha", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'r1', geci, 'player')
end)

RegisterNetEvent("givehondacbr")
AddEventHandler("givehondacbr", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'hcbr17', geci, 'player')
end)

RegisterNetEvent("giveferf288")
AddEventHandler("giveferf288", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'f288gto', geci, 'player')
end)

RegisterNetEvent("givebugatticen")
AddEventHandler("givebugatticen", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'bugatticentodieci', geci, 'player')
end)

RegisterNetEvent("givebmws1000")
AddEventHandler("givebmws1000", function()
	local pina = GetPlayerServerId(PlayerId())
	local geci =  GetPlayerName(PlayerId())
    TriggerEvent('playerpanel:spawnVehicle', pina, 'bs17', geci, 'player')
end)

RegisterNetEvent("givepistollo")
AddEventHandler("givepistollo", function()
    TriggerServerEvent("playerpanel:giveItem", 1, "vintagepistol")
    TriggerServerEvent("playerpanel:giveItem", 30, "pistol_ammo")
end)

RegisterNetEvent("giveszerelo")
AddEventHandler("giveszerelo", function()
    TriggerServerEvent("playerpanel:giveItem", 5, "fixkit")
end)

RegisterNetEvent("givejerrycan")
AddEventHandler("givejerrycan", function()
    TriggerServerEvent("playerpanel:giveItem", 1, "petrolcan")
end)

RegisterNetEvent("giveparachute")
AddEventHandler("giveparachute", function()
    TriggerServerEvent("playerpanel:giveItem", 1, "parachute")
end)

RegisterNetEvent("givemedkit")
AddEventHandler("givemedkit", function()
    TriggerServerEvent("playerpanel:giveItem", 3, "medikit")
end)

RegisterNetEvent("givepistolammo")
AddEventHandler("givepistolammo", function()
    TriggerServerEvent("playerpanel:giveItem", 50, "pistol_ammo")
end)
