local ZoneState = {}
local showing, isPickingUp = false, false

-- UTILITIES
local function GetGroundZ(x, y)
    local heights = {31.0, 35.0, 40.0, 50.0, 70.0, 90.0, 300.0}
    for _, h in ipairs(heights) do
        local found, z = GetGroundZFor_3dCoord(x, y, h)
        if found then return z end
    end
    return 31.85
end

local function RemoveFromTable(tbl, entity)
    for i = 1, #tbl do
        if tbl[i] == entity then
            table.remove(tbl, i)
            break
        end
    end
end

local function ValidateCoord(coord, existing, center, radius)
    for _, ent in pairs(existing) do
        if #(coord - GetEntityCoords(ent)) < 5 then return false end
    end
    return #(coord - center) <= radius
end

local function GenerateRandomSpawnCoord(center, radius, existing, zFunc)
    for _ = 1, 50 do
        local angle = math.random() * 2 * math.pi
        local r = radius * math.sqrt(math.random())
        local x = center.x + r * math.cos(angle)
        local y = center.y + r * math.sin(angle)
        local z = zFunc(x, y)
        local coord = vector3(x, y, z)
        if ValidateCoord(coord, existing, center, radius) then return coord end
        Wait(1)
    end
    return center
end

-- TARGET + SPAWNING
local function RegisterTarget(obj, label, icon, zoneKey, removeCallback)
    Wait(50)
    if not DoesEntityExist(obj) then return end

    exports.ox_target:addLocalEntity(obj, {
        {
            label = label,
            icon = icon,
            distance = 1.5,
            canInteract = function()
                return not isPickingUp and IsPedOnFoot(PlayerPedId())
            end,
            onSelect = function(data)
                if isPickingUp then return end
                isPickingUp = true

                local ped = PlayerPedId()
                TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, false)

                lib.callback('beans-picking:getPickupDuration', false, function(duration)
                    if not duration or duration <= 0 then
                        ClearPedTasks(ped)
                        isPickingUp = false
                        return
                    end

                    local done = exports.ox_lib:progressBar({
                        duration = duration,
                        label = label,
                        useWhileDead = false,
                        canCancel = true,
                        disable = { move = true, car = true, mouse = false, combat = true }
                    })

                    ClearPedTasks(ped)
                    isPickingUp = false

                    if done then
                        TriggerServerEvent('beans-picking:completePickup', zoneKey)
                        if DoesEntityExist(data.entity) then DeleteEntity(data.entity) end
                        removeCallback(data.entity)
                    else
                        lib.notify({ description = 'Cancelled.', type = 'error' })
                    end
                end, zoneKey)
            end
        }
    })
end

local function SpawnZonePlants(zoneKey)
    local zone = Config.CircleZones[zoneKey]
    if not zone then return 0 end

    local count = 0
    local coordFunc = zone.coordFunc or GetGroundZ
    local trackingTable = ZoneState[zoneKey].objects

    while count < 20 do
        Wait(10)
        local coords = GenerateRandomSpawnCoord(zone.coords, zone.radius, trackingTable, coordFunc)
        local model = zone.model or `prop_weed_02`

        RequestModel(model)
        while not HasModelLoaded(model) do Wait(10) end

        local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
        SetModelAsNoLongerNeeded(model)

        table.insert(trackingTable, obj)
        count += 1

        RegisterTarget(obj, 'Pick up ' .. (zone.label or 'Unknown'), zone.icon or 'fas fa-box', zoneKey, function(entity)
            RemoveFromTable(trackingTable, entity)
            ZoneState[zoneKey].spawned -= 1
        end)
    end

    return count
end

-- ZONE HANDLER
local function SetupDespawnableZone(zoneKey)
    local zone = Config.CircleZones[zoneKey]
    if not zone or zone.enabled == false then return end

    ZoneState[zoneKey] = {
        objects = {},
        spawned = 0,
        inside = 0
    }

    lib.zones.sphere({
        coords = zone.coords,
        radius = zone.radius,
        debug = false,
        onEnter = function()
            ZoneState[zoneKey].inside += 1
            if ZoneState[zoneKey].inside == 1 then
                ZoneState[zoneKey].spawned = SpawnZonePlants(zoneKey)
            end
        end,
        onExit = function()
            ZoneState[zoneKey].inside -= 1
            if ZoneState[zoneKey].inside <= 0 then
                for _, obj in ipairs(ZoneState[zoneKey].objects) do
                    if DoesEntityExist(obj) then DeleteEntity(obj) end
                end
                ZoneState[zoneKey].objects = {}
                ZoneState[zoneKey].spawned = 0
            end
        end
    })
end

-- INIT ZONES
CreateThread(function()
    Wait(1000)
    for zoneKey, zoneData in pairs(Config.CircleZones) do
        if zoneData.enabled ~= false then
            SetupDespawnableZone(zoneKey)
        end
    end
end)

-- TEXT UI DISABLER THREAD
CreateThread(function()
    while true do
        Wait(500)
        if showing then
            local coords = GetEntityCoords(PlayerPedId())
            local found = false
            for _, zone in pairs(Config.CircleZones) do
                if zone.enabled ~= false and zone.model then
                    if DoesEntityExist(GetClosestObjectOfType(coords, 2.0, zone.model, false)) then
                        found = true
                        break
                    end
                end
            end
            if not found then
                lib.hideTextUI()
                showing = false
            end
        end
    end
end)

-- RESOURCE CLEANUP
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for _, state in pairs(ZoneState) do
        for _, obj in ipairs(state.objects) do
            if DoesEntityExist(obj) then DeleteEntity(obj) end
        end
    end
end)
