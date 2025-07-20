lib = lib or {}

---@param playerLevel number
---@return number amount, number duration
local function CalculateTieredPickup(playerLevel)
    local itemAmount = 1
    local pickupDuration = 7500 -- default duration in ms

    for level, amount in pairs(Config.SharedPickupTiers) do
        if playerLevel >= level then
            itemAmount = amount
            pickupDuration = math.max(2000, 8000 - (level * 200)) -- Faster pickups at higher levels
        end
    end

    return itemAmount, pickupDuration
end

---@param src number
---@param zoneKey string
lib.callback.register('beans-picking:attemptPickup', function(src, zoneKey)
    local zone = Config.CircleZones[zoneKey]
    if not zone then return false, 0 end

    local item = zone.item
    if not item then return false, 0 end

    local playerLevel = exports['pickle_xp']:GetCurrentXPLevel(src, Config.XPCategory) or 0
    local amount, pickupDuration = CalculateTieredPickup(playerLevel)

    local added = exports.ox_inventory:AddItem(src, item, amount)

    if added then
        TriggerClientEvent('ox_inventory:displayItemBox', src, item, 'add')

        local label = zone.label or exports.ox_inventory:Items()[item]?.label or item
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Success',
            description = ("Picked up %sx %s!"):format(amount, label),
            type = 'success'
        })

        if Config.XPRewardPerPickup and Config.XPCategory then
            exports['pickle_xp']:AddPlayerXP(src, Config.XPCategory, Config.XPRewardPerPickup)
        end

        return true, pickupDuration
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Inventory Full',
            description = 'You can’t carry more!',
            type = 'error'
        })
        return false, 0
    end
end)

RegisterNetEvent('beans-picking:pickedUpCannabis', function()
    handlePickup(source, 'WeedField')
end)

RegisterNetEvent('beans-picking:pickedUpChemicals', function()
    handlePickup(source, 'ChemicalField')
end)

RegisterNetEvent('beans-picking:pickedUpCocas', function()
    handlePickup(source, 'CocaField')
end)
