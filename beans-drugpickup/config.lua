Config = {} --check xp logic and also configure drugs/locations
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
    PoppyField = { --opium
        enabled = true,
        coords = vector3(2207.937, 1972.514, 104.105),
        radius = 15.0,
        spawnTriggerRadius = 60.0,
        item = 'poppyresin',
        label = 'Poppy',
        model = `prop_plant_01b`,
        icon = 'fas fa-leaf'
    },
 MethylamineField = { --meth and dmt
        enabled = true,
        coords = vector3(-2386.529, 2687.469, 1.857),
        radius = 15.0,
        spawnTriggerRadius = 60.0,
        item = 'methylamine',
        label = 'Methylamine',
        model = `prop_barrel_01a`,
        icon = 'fas fa-skull-crossbones'
    },
CocaField = { --coke crack
        enabled = true,
        coords = vector3(-1617.171, 2949.281, 33.144),
        radius = 15.0,
        spawnTriggerRadius = 60.0,
        item = 'cocaine',
        label = 'Coca Leaf',
        model = `prop_plant_01a`,
        icon = 'fas fa-leaf'
    },
MushroomField = {
    enabled = true,
    coords = vector3(1953.228, 552.965, 162.099),
    radius = 15.0,
    spawnTriggerRadius = 60.0,
    item = 'mushroomcaps',
    label = 'Mushroom Caps',
    model = `prop_plant_01a`,
    icon = 'fas fa-leaf'
},
IsosafroleField = { --ectasy
    enabled = true,
    coords = vector3(-1374.981, 4413.157, 29.465),
    radius = 15.0,
    item = 'isosafrole',
    label = 'Isosafrole',
    model = `xm3_prop_xm3_barrel_02a`,
    icon = 'fas fa-skull-crossbones'
},
    
--[[     SteppedOnField = { --crack
    enabled = true,
    coords = vector3(-2125.3, 1427.3, 284.79),
    radius = 15.0,
    item = 'water_bottle',
    label = 'Coca Leaf',
    model = `prop_plant_01a`,
    icon = 'fas fa-leaf'
    }, ]]
PeyoteField = { --dried peyote
    enabled = true,
    coords = vector3(1668.128, 3020.135, 56.785),
    radius = 15.0,
    spawnTriggerRadius = 60.0,
    item = 'peyote',
    label = 'Peyote',
    model = `prop_cactus_02`,
    icon = 'fas fa-skull-crossbones'
},
SodiumHydroxideField = { --ayuhasca dmt plus peyote
    enabled = true,
    coords = vector3(-1256.292, 5324.370, 9.437),
    radius = 15.0,
    spawnTriggerRadius = 60.0,
    item = 'sodiumhydroxide',
    label = 'Sodium Hydroxide',
    model = `prop_barrel_exp_01b`,
    icon = 'fas fa-skull-crossbones'
},
PMKField = { --mdma alkso needs methylamine
    enabled = true,
    coords = vector3(-437.752, -2447.620, 6.001),
    radius = 15.0,
    spawnTriggerRadius = 60.0,
    item = 'pmk',
    label = 'PMK',
    model = `prop_barrel_02b`,
    icon = 'fas fa-skull-crossbones'
    },
    AmmoniumHydroxideField = {
    enabled = true,
    coords = vector3(63.332, -2746.750, 6.005),
    radius = 15.0,
    spawnTriggerRadius = 60.0,
    item = 'amoniumhydroxide',
    label = 'Ammonium Hydroxide',
    model = `prop_barrel_01a`,
    icon = 'fas fa-skull-crossbones'
    }

}

-- mdma -- pmk and methlamine
-- ayuhasca -- peyote and sodiumhydroxide


--peyote -- peyote making dried peyote
--isosifrole -- ectasy
--mushrooms --dried mushrooms/ golden teachers
-- crack -- baking soda and coca
--coke -- coke field and b12
--meth --ephedrine and methlymine
--opium -- poppy
--Fentanyl -- poppy and --Ammonium Hydroxide


