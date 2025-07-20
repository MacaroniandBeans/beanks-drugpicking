Config = {}

Config.Locale = 'en'

Config.LicenseEnable = false -- enable processing licenses? The player will be required to buy a license in order to process drugs. 

Config.SharedPickupXPType = 'drug'

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
        coords = vector3(2031.44, 4878.57, 42.89),
        radius = 15.0,
        item = 'water_bottle',
        label = 'Cannabis'
    },
    ChemicalField = {
        coords = vector3(1547.21, 3817.65, 30.54),
        radius = 15.0,
        item = 'water_bottle',
        label = 'Chemicals'
    },
    CocaField = {
        coords = vector3(-2125.3, 1427.3, 284.79),
        radius = 15.0,
        item = 'water_bottle',
        label = 'Coca Leaf'
    }
}

