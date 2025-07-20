Config = {}

-- Tiered reward amounts based on level
Config.SharedPickupTiers = {
    [1] = 1,    -- level 1+
    [5] = 2,    -- level 5+
    [10] = 3,   -- level 10+
    [20] = 4,   -- level 20+
}

Config.XPRewardPerPickup = 1 -- You can change this value later as needed
Config.XPCategory = "drug" -- Change to match your XP category name in pickle_xp


Config.CircleZones = {
    WeedField = {
        enabled = true,
        coords = vector3(2031.44, 4878.57, 42.89),
        radius = 15.0,
        item = 'water_bottle',
        label = 'Cannabis',
        model = `prop_weed_02`,
        icon = 'fas fa-leaf'
    },
    ChemicalField = {
        enabled = true,
        coords = vector3(1547.21, 3817.65, 30.54),
        radius = 15.0,
        item = 'water_bottle',
        label = 'Chemicals',
        model = `prop_barrel_01a`,
        icon = 'fas fa-flask'
    },
    CocaField = {
        enabled = true,
        coords = vector3(-2125.3, 1427.3, 284.79),
        radius = 15.0,
        item = 'water_bottle',
        label = 'Coca Leaf',
        model = `prop_plant_01a`,
        icon = 'fas fa-leaf'
    }
}

