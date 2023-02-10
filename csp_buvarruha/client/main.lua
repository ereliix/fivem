local playerLoaded
ESX = nil
loaded = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSh4tHVyET11dpJxaredObj4tHVyET11dpJxect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while not ESX.GetPlayerData().job do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	loaded = true
end)

local felmoso = "prop_tool_broom"
local felmoso_net = nil
local szivacs = "prop_sponge_01"


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job) ESX.PlayerData.job = job end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData.job = xPlayer
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    playerLoaded = true
end)


Citizen.CreateThread(function()
	while loaded == false do
        Citizen.Wait(20)
    end
	while true do
		Citizen.Wait(1)
		local playerPos = GetEntityCoords(PlayerPedId(), true)
		for k,v in pairs(Buvarberles) do
			local Buvarberles = v.position
			local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, Buvarberles.x, Buvarberles.y, Buvarberles.z)
			local plyPed = GetPlayerPed(-1)
			if distance < 3 then --marker mikor latszodjon
			DrawMarker(Config.Marker.Type, Buvarberles.x, Buvarberles.y, Buvarberles.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, true, 2, false, false, false, false)

					if distance < 1.6 then --szoveg mikor latszodjon es tudj nyomni e-t

						ESX.Game.Utils.DrawText3D({x = Buvarberles.x, y = Buvarberles.y, z = Buvarberles.z-0.5}, "NYOMJ [~g~E~s~]-T bérelj egy buvár ruhát [~g~Ár~s~] 5000 CS", 0.7, 0.7)
						if IsControlJustReleased(0, 38) then
							CloakRoomMenu()				
						end
					end
			end
		end
	end
end)


function CloakRoomMenu()

	local elements = {}
	local playerPed = GetPlayerPed(-1)
		table.insert(elements, {label = "Civil Ruha", value = 'citizen_wear'})
		table.insert(elements, {label = "Buvár Ruha", value = 'job_wear'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = "Buvár Ruha bérlés",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'citizen_wear' then
			menu.close()
			SetEnableScuba(GetPlayerPed(-1),false)
			SetPedMaxTimeUnderwater(GetPlayerPed(-1), 10.00)
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)

		elseif data.current.value == 'job_wear' then
			ESX.TriggerServerCallback('csp_buvarruha:Ruhavetel', function(bought)
				if bought then
			setUniform(data.current.value)
			SetEnableScuba(GetPlayerPed(-1),true)
			SetPedMaxTimeUnderwater(GetPlayerPed(-1), 1500.00)
			menu.close()
				else
					exports['mythic_notify']:DoHudText('inform', 'Nincs elég pénzed a buvár ruha bérléséhez', { ['background-color'] = '#ff1a1a', ['color'] = '#000000' })
				end
			end)
		end

		CurrentAction     = 'cloakroom_menu'
		CurrentActionData = {}
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'cloakroom_menu'
		CurrentActionData = {}
	end)

end



function setUniform(job)
	TriggerEvent('skinchanger:getSkin', function(skin)

		if skin.sex == 0 then
			if Config.Uniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('locker_nooutfit'))
			end
		else
			if Config.Uniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('locker_nooutfit'))
			end
		end

	end)
end