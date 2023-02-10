ESX = nil

TriggerEvent('esx:getSh4tHVyET11dpJxaredObj4tHVyET11dpJxect', function(obj) ESX = obj end)

RegisterServerEvent('csp_takarito:fizu')
AddEventHandler('csp_takarito:fizu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(Config.Fizettseg)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Elvégezted a munkát,fizettséged: '..Config.Fizettseg..' CSurint', length = 2500, style = { ['background-color'] = '#66ff66', ['color'] = '#000000' } })
	local target = "society_"..xPlayer.getJob().name --socipénz
	TriggerEvent('esx_addonaccount:getSharedAccount', target, function(account)
	account.addMoney(Config.Fizettseg)
end)
end)

