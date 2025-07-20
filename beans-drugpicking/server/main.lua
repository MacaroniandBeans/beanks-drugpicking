lib = lib or {}

local XPBridge = 'beans-xpbridge'

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

-- Step 1: Return only the pickup duration (for use with progress bar)
lib.callback.register('beans-picking:getPickupDuration', function(src, zoneKey)
    local zone = Config.CircleZones[zoneKey]
    if not zone then return 0 end

    local playerLevel = exports[XPBridge]:GetLevel(src, Config.XPCategory) or 0
    local _, duration = CalculateTieredPickup(playerLevel)
    return duration
end)

-- Step 2: Finalize pickup and give item + XP
RegisterNetEvent('beans-picking:completePickup', function(zoneKey)
    local src = source
    local zone = Config.CircleZones[zoneKey]
    if not zone then return end

    local item = zone.item
    if not item then return end

    local playerLevel = exports[XPBridge]:GetLevel(src, Config.XPCategory) or 0
    local amount = CalculateTieredPickup(playerLevel)
    if type(amount) == "table" then amount = amount[1] end

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
            exports[XPBridge]:AddXP(src, Config.XPCategory, Config.XPRewardPerPickup)
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Inventory Full',
            description = 'You can’t carry more!',
            type = 'error'
        })
    end
end)
