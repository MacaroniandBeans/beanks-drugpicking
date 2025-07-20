local spawnedWeed, spawnedChemical, spawnedCoca = 0, 0, 0
local weedPlants, chemicalBarrels, cocaLeaf = {}, {}, {}
local showing, isPickingUp = false, false

-- Startup
CreateThread(function()
    Wait(1000)
    CheckCoordsWeed()
    CheckCoordsChemical()
    CheckCoordsCoca()
end)

-- Hide TextUI
CreateThread(function()
    while true do
        Wait(500)
        if showing then
            local coords = GetEntityCoords(PlayerPedId())
            local nearby = {
                GetClosestObjectOfType(coords, 2.0, `prop_weed_02`, false),
                GetClosestObjectOfType(coords, 2.0, `prop_barrel_01a`, false),
                GetClosestObjectOfType(coords, 2.0, `prop_plant_01a`, false),
            }
            if not DoesEntityExist(nearby[1]) and not DoesEntityExist(nearby[2]) and not DoesEntityExist(nearby[3]) then
                lib.hideTextUI()
                showing = false
            end
        end
    end
end)

-- Cleanup
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for _, v in pairs(weedPlants) do DeleteEntity(v) end
    for _, v in pairs(chemicalBarrels) do DeleteEntity(v) end
    for _, v in pairs(cocaLeaf) do DeleteEntity(v) end
end)

-- ZONE REGIONS
function CheckCoordsWeed()
    lib.zones.sphere({
        coords = Config.CircleZones.WeedField.coords,
        radius = Config.CircleZones.WeedField.radius,
        debug = false,
        onEnter = function()
            if not hasSpawnedWeed then
                SpawnWeedPlants()
                hasSpawnedWeed = true
            end
        end,
        onExit = function()
            hasSpawnedWeed = false
        end
    })
end

function CheckCoordsChemical()
    lib.zones.sphere({
        coords = Config.CircleZones.ChemicalField.coords,
        radius = Config.CircleZones.ChemicalField.radius,
        debug = false,
        onEnter = function()
            if not hasSpawnedChemical then
                SpawnChemicalPlants()
                hasSpawnedChemical = true
            end
        end,
        onExit = function()
            hasSpawnedChemical = false
        end
    })
end

function CheckCoordsCoca()
    lib.zones.sphere({
        coords = Config.CircleZones.CocaField.coords,
        radius = Config.CircleZones.CocaField.radius,
        debug = false,
        onEnter = function()
            if not hasSpawnedCoca then
                SpawnCocaPlants()
                hasSpawnedCoca = true
            end
        end,
        onExit = function()
            hasSpawnedCoca = false
        end
    })
end

-- Target Setup
function RegisterTarget(obj, label, icon, zoneKey, removeCallback)
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

                lib.callback('beans-picking:attemptPickup', false, function(success, duration)
                    if not success then
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

-- Spawning
function SpawnWeedPlants()
    while spawnedWeed < 20 do
        Wait(10)
        local coords = GenerateRandomSpawnCoord(Config.CircleZones.WeedField.coords, Config.CircleZones.WeedField.radius, weedPlants, GetCoordZWeed)
        local model = `prop_weed_02`
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(10) end
        local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
        SetModelAsNoLongerNeeded(model)
        table.insert(weedPlants, obj)
        spawnedWeed += 1

        RegisterTarget(obj, 'Pick up Cannabis', 'fas fa-leaf', 'WeedField', function(entity)
            RemoveFromTable(weedPlants, entity)
            spawnedWeed -= 1
        end)
    end
end

function SpawnChemicalPlants()
    while spawnedChemical < 20 do
        Wait(10)
        local coords = GenerateRandomSpawnCoord(Config.CircleZones.ChemicalField.coords, Config.CircleZones.ChemicalField.radius, chemicalBarrels, GetCoordZChemical)
        local model = `prop_barrel_01a`
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(10) end
        local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
        SetModelAsNoLongerNeeded(model)
        table.insert(chemicalBarrels, obj)
        spawnedChemical += 1

        RegisterTarget(obj, 'Pick up Chemicals', 'fas fa-flask', 'ChemicalField', function(entity)
            RemoveFromTable(chemicalBarrels, entity)
            spawnedChemical -= 1
        end)
    end
end

function SpawnCocaPlants()
    while spawnedCoca < 20 do
        Wait(10)
        local coords = GenerateRandomSpawnCoord(Config.CircleZones.CocaField.coords, Config.CircleZones.CocaField.radius, cocaLeaf, GetCoordZCoca)
        local model = `prop_plant_01a`
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(10) end
        local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
        SetModelAsNoLongerNeeded(model)
        table.insert(cocaLeaf, obj)
        spawnedCoca += 1

        RegisterTarget(obj, 'Pick up Coca Leaf', 'fas fa-leaf', 'CocaField', function(entity)
            RemoveFromTable(cocaLeaf, entity)
            spawnedCoca -= 1
        end)
    end
end

-- Utils
function RemoveFromTable(tbl, entity)
    for i = 1, #tbl do
        if tbl[i] == entity then
            table.remove(tbl, i)
            break
        end
    end
end

function GetCoordZWeed(x, y) return GetGroundZ(x, y) end
function GetCoordZChemical(x, y) return GetGroundZ(x, y) end
function GetCoordZCoca(x, y) return GetGroundZ(x, y) end

function GetGroundZ(x, y)
    local heights = {31.0, 35.0, 40.0, 50.0, 70.0, 90.0, 300.0}
    for _, h in ipairs(heights) do
        local found, z = GetGroundZFor_3dCoord(x, y, h)
        if found then return z end
    end
    return 31.85
end

function GenerateRandomSpawnCoord(center, radius, existing, zFunc)
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

function ValidateCoord(coord, existing, center, radius)
    for _, ent in pairs(existing) do
        if #(coord - GetEntityCoords(ent)) < 5 then return false end
    end
    return #(coord - center) <= radius
end
