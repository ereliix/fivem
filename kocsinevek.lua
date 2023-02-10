function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end
Citizen.CreateThread(function()

	AddTextEntry('rmodmustang', 'Ford Mustang')
	AddTextEntry('307CC', 'Peugeot 307CC')
end)