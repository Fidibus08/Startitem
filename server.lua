ESX = exports['es_extended']:getSharedObject()

RegisterCommand(Config.Command, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local identifier = xPlayer.identifier

    MySQL.scalar(
        'SELECT identifier FROM startitems WHERE identifier = ?',
        { identifier },
        function(result)
            if result then
                xPlayer.showNotification('❌ Du hast deine Startitems bereits erhalten!')
                return
            end

            -- Items geben
            for _, v in pairs(Config.Items) do
                xPlayer.addInventoryItem(v.item, v.count)
            end

            -- In DB speichern
            MySQL.insert(
                'INSERT INTO startitems (identifier) VALUES (?)',
                { identifier }
            )

            xPlayer.showNotification('✅ Startitems erfolgreich erhalten!')
        end
    )
end, false)
