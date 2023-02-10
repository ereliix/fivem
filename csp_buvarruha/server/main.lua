ESX = nil

TriggerEvent('esx:getSh4tHVyET11dpJxaredObj4tHVyET11dpJxect', function(obj) ESX = obj end)

RegisterServerEvent('csp_testerrang:teszterrangadas')
AddEventHandler('csp_testerrang:teszterrangadas', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
end)


ESX.RegisterServerCallback('csp_buvarruha:Ruhavetel', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= Config.Price then
		xPlayer.removeMoney(Config.Price)
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sikeres bérlés !', style = { ['background-color'] = '#1aff1a', ['color'] = '#000000' } })
		cb(true)
	else
		cb(false)
	end
end)
