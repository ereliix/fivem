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


function asztaltorles()
	local dict = "timetable@floyd@clean_kitchen@base"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	Citizen.Wait(10)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, "base", 8.0, 8.0, -1, 11, 0, false, false, false)
end


Citizen.CreateThread(function()
	while loaded == false do
        Citizen.Wait(20)
    end
	while true do
		Citizen.Wait(1)
		local playerPos = GetEntityCoords(PlayerPedId(), true)
		for k,v in pairs(CasinoPortorles) do
			local CasinoPortorles = v.position
			local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, CasinoPortorles.x, CasinoPortorles.y, CasinoPortorles.z)
			local plyPed = GetPlayerPed(-1)
			if ESX.PlayerData.job.name == "casino" then
			if distance < 3 then --marker mikor latszodjon
			--DrawMarker(Config.Marker.Type, Portorlespos.x, Portorlespos.y, Portorlespos.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, true, 2, false, false, false, false)

					if distance < 1.6 then --szoveg mikor latszodjon es tudj nyomni e-t

						ESX.Game.Utils.DrawText3D({x = CasinoPortorles.x, y = CasinoPortorles.y, z = CasinoPortorles.z-0.5}, "NYOMJ [~g~F~s~]-T hogy elkezd letörölni a port", 0.3, 0.7)
						if IsControlJustReleased(0, 23) then
							TaskStartScenarioInPlace(plyPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
							exports['csp_progbar']:startUI(15000, "Szépen letörlöd a port")
							Wait(15000)
							ClearPedTasksImmediately(plyPed)
							TriggerServerEvent('csp_takarito:fizu')					
						end
					end
				end
			end
		end
		for k,v in pairs(CasinoSepregetes) do
			local CasinoSepregetes = v.position
			local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, CasinoSepregetes.x, CasinoSepregetes.y, CasinoSepregetes.z)
			local plyPed = GetPlayerPed(-1)
			if ESX.PlayerData.job.name == "casino" then
			if distance < 3 then --marker mikor latszodjon
			--DrawMarker(Config.Marker.Type, Sepregetes.x, Sepregetes.y, Sepregetes.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, true, 2, false, false, false, false)

					if distance < 1.6 then --szoveg mikor latszodjon es tudj nyomni e-t

						ESX.Game.Utils.DrawText3D({x = CasinoSepregetes.x, y = CasinoSepregetes.y, z = CasinoSepregetes.z-0.5}, "NYOMJ [~g~F~s~]-T hogy elkezdj felsepregetni", 0.3, 0.7)
						if IsControlJustReleased(0, 23) then
							local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
							local felmosospawn = CreateObject(GetHashKey(felmoso), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
							local netid = ObjToNet(felmosospawn)

							ESX.Streaming.RequestAnimDict("amb@world_human_janitor@male@idle_a", function()
									TaskPlayAnim(PlayerPedId(), "amb@world_human_janitor@male@idle_a", "idle_a", 8.0, -8.0, -1, 0, 0, false, false, false)
									AttachEntityToEntity(felmosospawn,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
									felmoso_net = netid
								end)

								ESX.SetTimeout(15000, function()
									disable_actions = false
									DetachEntity(NetToObj(felmoso_net), 1, 1)
									DeleteEntity(NetToObj(felmoso_net))
									felmoso_net = nil
									ClearPedTasks(PlayerPedId())
								end)
								exports['csp_progbar']:startUI(15000, "Szépen felsepred a padlót")
							Wait(15000)
							TriggerServerEvent('csp_takarito:fizu')					
						end
					end
				end
			end
		end
		for k,v in pairs(CasinoAsztaltorles) do
			local CasinoAsztaltorles = v.position
			local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, CasinoAsztaltorles.x, CasinoAsztaltorles.y, CasinoAsztaltorles.z)
			local plyPed = GetPlayerPed(-1)
			if ESX.PlayerData.job.name == "casino" then
			if distance < 3 then --marker mikor latszodjon
			--DrawMarker(Config.Marker.Type, Sepregetes.x, Sepregetes.y, Sepregetes.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, true, 2, false, false, false, false)

					if distance < 1.6 then --szoveg mikor latszodjon es tudj nyomni e-t

						ESX.Game.Utils.DrawText3D({x = CasinoAsztaltorles.x, y = CasinoAsztaltorles.y, z = CasinoAsztaltorles.z-0.5}, "NYOMJ [~g~F~s~]-T hogy letöröld az asztald", 0.3, 0.7)
						if IsControlJustReleased(0, 23) then
							local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
							local szivacs = CreateObject(GetHashKey(szivacs), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
							local netid = ObjToNet(szivacs)

							asztaltorles()
							AttachEntityToEntity(szivacs,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
							felmoso_net = netid
								ESX.SetTimeout(15000, function()
									disable_actions = false
									DetachEntity(NetToObj(felmoso_net), 1, 1)
									DeleteEntity(NetToObj(felmoso_net))
									felmoso_net = nil
									ClearPedTasks(PlayerPedId())
								end)
								exports['csp_progbar']:startUI(15000, "Tisztára törlöd az asztalt")
							Wait(15000)
							TriggerServerEvent('csp_takarito:fizu')					
						end
					end
				end
			end
		end
		-----Familia
		for k,v in pairs(FamiliaPortorles) do
			local FamiliaPortorles = v.position
			local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, FamiliaPortorles.x, FamiliaPortorles.y, FamiliaPortorles.z)
			local plyPed = GetPlayerPed(-1)
			if ESX.PlayerData.job.name == "lafamiglia" then
			if distance < 3 then --marker mikor latszodjon
			--DrawMarker(Config.Marker.Type, Portorlespos.x, Portorlespos.y, Portorlespos.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, true, 2, false, false, false, false)

					if distance < 1.6 then --szoveg mikor latszodjon es tudj nyomni e-t

						ESX.Game.Utils.DrawText3D({x = FamiliaPortorles.x, y = FamiliaPortorles.y, z = FamiliaPortorles.z-0.5}, "NYOMJ [~g~F~s~]-T hogy elkezd letörölni a port", 0.3, 0.7)
						if IsControlJustReleased(0, 23) then
							TaskStartScenarioInPlace(plyPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
							exports['csp_progbar']:startUI(15000, "Szépen letörlöd a port")
							Wait(15000)
							ClearPedTasksImmediately(plyPed)
							TriggerServerEvent('csp_takarito:fizu')					
						end
					end
				end
			end
		end
		for k,v in pairs(FamiliaSepregetes) do
			local FamiliaSepregetes = v.position
			local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, FamiliaSepregetes.x, FamiliaSepregetes.y, FamiliaSepregetes.z)
			local plyPed = GetPlayerPed(-1)
			if ESX.PlayerData.job.name == "lafamiglia" then
			if distance < 3 then --marker mikor latszodjon
			--DrawMarker(Config.Marker.Type, Sepregetes.x, Sepregetes.y, Sepregetes.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, true, 2, false, false, false, false)

					if distance < 1.6 then --szoveg mikor latszodjon es tudj nyomni e-t

						ESX.Game.Utils.DrawText3D({x = FamiliaSepregetes.x, y = FamiliaSepregetes.y, z = FamiliaSepregetes.z-0.5}, "NYOMJ [~g~F~s~]-T hogy elkezdj felsepregetni", 0.3, 0.7)
						if IsControlJustReleased(0, 23) then
							local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
							local felmosospawn = CreateObject(GetHashKey(felmoso), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
							local netid = ObjToNet(felmosospawn)

							ESX.Streaming.RequestAnimDict("amb@world_human_janitor@male@idle_a", function()
									TaskPlayAnim(PlayerPedId(), "amb@world_human_janitor@male@idle_a", "idle_a", 8.0, -8.0, -1, 0, 0, false, false, false)
									AttachEntityToEntity(felmosospawn,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
									felmoso_net = netid
								end)

								ESX.SetTimeout(15000, function()
									disable_actions = false
									DetachEntity(NetToObj(felmoso_net), 1, 1)
									DeleteEntity(NetToObj(felmoso_net))
									felmoso_net = nil
									ClearPedTasks(PlayerPedId())
								end)
								exports['csp_progbar']:startUI(15000, "Szépen felsepred a padlót")
							Wait(15000)
							TriggerServerEvent('csp_takarito:fizu')					
						end
					end
				end
			end
		end
		for k,v in pairs(FamiliaAsztaltorles) do
			local FamiliaAsztaltorles = v.position
			local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, FamiliaAsztaltorles.x, FamiliaAsztaltorles.y, FamiliaAsztaltorles.z)
			local plyPed = GetPlayerPed(-1)
			if ESX.PlayerData.job.name == "lafamiglia" then
			if distance < 3 then --marker mikor latszodjon
			--DrawMarker(Config.Marker.Type, Sepregetes.x, Sepregetes.y, Sepregetes.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, true, 2, false, false, false, false)

					if distance < 1.6 then --szoveg mikor latszodjon es tudj nyomni e-t

						ESX.Game.Utils.DrawText3D({x = FamiliaAsztaltorles.x, y = FamiliaAsztaltorles.y, z = FamiliaAsztaltorles.z-0.5}, "NYOMJ [~g~F~s~]-T hogy letöröld az asztald", 0.3, 0.7)
						if IsControlJustReleased(0, 23) then
							local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
							local szivacs = CreateObject(GetHashKey(szivacs), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
							local netid = ObjToNet(szivacs)

							asztaltorles()
							AttachEntityToEntity(szivacs,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
							felmoso_net = netid
								ESX.SetTimeout(15000, function()
									disable_actions = false
									DetachEntity(NetToObj(felmoso_net), 1, 1)
									DeleteEntity(NetToObj(felmoso_net))
									felmoso_net = nil
									ClearPedTasks(PlayerPedId())
								end)
								exports['csp_progbar']:startUI(15000, "Tisztára törlöd az asztalt")
							Wait(15000)
							TriggerServerEvent('csp_takarito:fizu')					
						end
					end
				end
			end
		end
		for k,v in pairs(Gymtakaritas) do
			local Gymtakaritas = v.position
			local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, Gymtakaritas.x, Gymtakaritas.y, Gymtakaritas.z)
			local plyPed = GetPlayerPed(-1)
			if ESX.PlayerData.job.name == "gorilla" then
			if distance < 3 then --marker mikor latszodjon
			--DrawMarker(Config.Marker.Type, Sepregetes.x, Sepregetes.y, Sepregetes.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, true, 2, false, false, false, false)

					if distance < 1.6 then --szoveg mikor latszodjon es tudj nyomni e-t

						ESX.Game.Utils.DrawText3D({x = Gymtakaritas.x, y = Gymtakaritas.y, z = Gymtakaritas.z-0.5}, "NYOMJ [~g~F~s~]-T hogy elkezdj felsepregetni", 0.3, 0.7)
						if IsControlJustReleased(0, 23) then
							local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
							local felmosospawn = CreateObject(GetHashKey(felmoso), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
							local netid = ObjToNet(felmosospawn)

							ESX.Streaming.RequestAnimDict("amb@world_human_janitor@male@idle_a", function()
									TaskPlayAnim(PlayerPedId(), "amb@world_human_janitor@male@idle_a", "idle_a", 8.0, -8.0, -1, 0, 0, false, false, false)
									AttachEntityToEntity(felmosospawn,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
									felmoso_net = netid
								end)

								ESX.SetTimeout(15000, function()
									disable_actions = false
									DetachEntity(NetToObj(felmoso_net), 1, 1)
									DeleteEntity(NetToObj(felmoso_net))
									felmoso_net = nil
									ClearPedTasks(PlayerPedId())
								end)
								exports['csp_progbar']:startUI(15000, "Szépen felsepred a padlót")
							Wait(15000)
							TriggerServerEvent('csp_takarito:fizu')					
						end
					end
				end
			end
		end
	end
end)
