-- ============================================================
--  Re:Mind — After the Fall (RMATF)
--  Author: Seppel
-- ============================================================

-- Veg overlay sprite pools + base sets (TYL-inspired, clean-room lists).

RMATF = RMATF or {}
RMATF.Veg = RMATF.Veg or {}
RMATF.Veg.Data = RMATF.Veg.Data or {}
local D = RMATF.Veg.Data

local function trimSpriteName(s)
    if not s then return nil end
    s = tostring(s)
    -- remove trailing commas / periods / surrounding whitespace
    s = s:gsub('^%s+', ''):gsub('%s+$', '')
    s = s:gsub(',+$', '')
    s = s:gsub('%.+$', '')
    s = s:gsub('_+$', '')
    -- if someone pasted extra words ("... cha"), keep only first token
    s = s:match('([^%s]+)')
    if not s or s == '' then return nil end
    return s
end

local function sanitizeList(list)
    local out = {}
    local seen = {}
    local blank = {
        -- These are known to be "blank overlay textures" in recent builds and spam the log.
        ["f_wallvines_1_28"] = true,
        ["f_wallvines_1_29"] = true,
        ["f_wallvines_1_34"] = true,
        ["f_wallvines_1_35"] = true,
        ["f_wallvines_1_40"] = true,
    }
    for _, v in ipairs(list) do
        local s = trimSpriteName(v)
        if s and not blank[s] and not seen[s] then
            seen[s] = true
            table.insert(out, s)
        end
    end
    return out
end

-- Overlay sprite pools (what gets drawn on top)
local OVERLAY_FLOOR_GRASS = sanitizeList({
    "e_newgrass_1_116","e_newgrass_1_115","e_newgrass_1_114","e_newgrass_1_113","e_newgrass_1_112",
    "e_newgrass_1_89","e_newgrass_1_90","e_newgrass_1_91","e_newgrass_1_92","e_newgrass_1_93",
    "e_newgrass_1_69","e_newgrass_1_68","e_newgrass_1_67","e_newgrass_1_66","e_newgrass_1_65",
    "e_newgrass_1_40","e_newgrass_1_45","e_newgrass_1_44","e_newgrass_1_43","e_newgrass_1_42","e_newgrass_1_41",
    "e_newgrass_1_16","e_newgrass_1_17","e_newgrass_1_18","e_newgrass_1_19","e_newgrass_1_20","e_newgrass_1_21",
    "d_generic_1_14","d_generic_1_10","d_plants_1_62","d_plants_1_58","d_plants_1_61","d_plants_1_27","d_plants_1_24",
})

local OVERLAY_VINES_WALLSET_A = sanitizeList({
    "f_wallvines_1_43","f_wallvines_1_42","f_wallvines_1_37","f_wallvines_1_36","f_wallvines_1_31","f_wallvines_1_30","f_wallvines_1_25","f_wallvines_1_24",
})
local OVERLAY_VINES_WALLSET_B = sanitizeList({
    "f_wallvines_1_45","f_wallvines_1_44","f_wallvines_1_39","f_wallvines_1_38","f_wallvines_1_33","f_wallvines_1_32","f_wallvines_1_27","f_wallvines_1_26",
})
local OVERLAY_VINES_WALLSET_C = sanitizeList({
    "f_wallvines_1_47","f_wallvines_1_46","f_wallvines_1_41","f_wallvines_1_40","f_wallvines_1_34","f_wallvines_1_35","f_wallvines_1_29","f_wallvines_1_28",
})

local OVERLAY_VINES_RAIL_A = sanitizeList({"f_wallvines_1_28","f_wallvines_1_29"})
local OVERLAY_VINES_RAIL_B = sanitizeList({"f_wallvines_1_26","f_wallvines_1_27"})
local OVERLAY_VINES_RAIL_C = sanitizeList({"f_wallvines_1_24","f_wallvines_1_25"})

local OVERLAY_VINES_SMALL = sanitizeList({
    "f_wallvines_1_36","f_wallvines_1_24","f_wallvines_1_25","f_wallvines_1_30","f_wallvines_1_31","f_wallvines_1_37",
})


-- ============================================================
-- Random helpers used by Generator (kept here so pools stay consistent)
-- ============================================================
local function pick(list)
    if not list or #list == 0 then return nil end
    return list[ZombRand(#list) + 1]
end

local function mergeLists(...)
    local out = {}
    for i = 1, select('#', ...) do
        local t = select(i, ...)
        if t then
            for j = 1, #t do
                out[#out+1] = t[j]
            end
        end
    end
    return out
end

-- Extra outdoor pools derived from your sprite scans (roads/forest/suburb)
local OVERLAY_ROAD_WEEDS = sanitizeList({
    "d_plants_1_16","d_plants_1_17","d_plants_1_18","d_plants_1_19","d_plants_1_20","d_plants_1_21","d_plants_1_22","d_plants_1_23",
    "d_plants_1_32","d_plants_1_33","d_plants_1_34","d_plants_1_35","d_plants_1_36","d_plants_1_37","d_plants_1_38","d_plants_1_39",
    "e_newgrass_1_24","e_newgrass_1_25","e_newgrass_1_26","e_newgrass_1_27","e_newgrass_1_28","e_newgrass_1_29",
    "e_newgrass_1_40","e_newgrass_1_41","e_newgrass_1_42","e_newgrass_1_43","e_newgrass_1_44","e_newgrass_1_45",
})

local OVERLAY_OUTDOOR_WEEDS = sanitizeList({
    -- small grass + weeds
    "e_newgrass_1_24","e_newgrass_1_25","e_newgrass_1_26","e_newgrass_1_27","e_newgrass_1_28","e_newgrass_1_29",
    "e_newgrass_1_40","e_newgrass_1_41","e_newgrass_1_42","e_newgrass_1_43","e_newgrass_1_44","e_newgrass_1_45",
    "e_newgrass_1_65","e_newgrass_1_66","e_newgrass_1_67","e_newgrass_1_68","e_newgrass_1_69",
    "d_plants_1_16","d_plants_1_17","d_plants_1_18","d_plants_1_19","d_plants_1_20","d_plants_1_21","d_plants_1_22","d_plants_1_23",
    "d_plants_1_32","d_plants_1_33","d_plants_1_34","d_plants_1_35","d_plants_1_36","d_plants_1_37","d_plants_1_38","d_plants_1_39",
})

local OVERLAY_OUTDOOR_BUSHES = sanitizeList({
    -- Wider vanilla span (small + medium + "wild" bushes). This is the main
    -- reason yards looked too clean before.
    "f_bushes_1_0","f_bushes_1_1","f_bushes_1_2","f_bushes_1_3","f_bushes_1_4","f_bushes_1_5","f_bushes_1_6","f_bushes_1_7",
    "f_bushes_1_8","f_bushes_1_9","f_bushes_1_10","f_bushes_1_11","f_bushes_1_12","f_bushes_1_13","f_bushes_1_14","f_bushes_1_15",
    "f_bushes_1_16","f_bushes_1_17","f_bushes_1_18","f_bushes_1_19","f_bushes_1_20","f_bushes_1_21","f_bushes_1_22","f_bushes_1_23",
    "f_bushes_1_24","f_bushes_1_25","f_bushes_1_26","f_bushes_1_27","f_bushes_1_28","f_bushes_1_29","f_bushes_1_30","f_bushes_1_31",
    -- denser / taller variants (commonly present in vanilla)
    "f_bushes_1_64","f_bushes_1_65","f_bushes_1_66","f_bushes_1_67","f_bushes_1_68","f_bushes_1_69","f_bushes_1_70","f_bushes_1_71",
    "f_bushes_1_72","f_bushes_1_73","f_bushes_1_74","f_bushes_1_75","f_bushes_1_76","f_bushes_1_77","f_bushes_1_78","f_bushes_1_79",
    "f_bushes_1_96","f_bushes_1_97","f_bushes_1_98","f_bushes_1_99","f_bushes_1_100","f_bushes_1_101","f_bushes_1_102","f_bushes_1_103",
    "f_bushes_1_104","f_bushes_1_105","f_bushes_1_106","f_bushes_1_107","f_bushes_1_108","f_bushes_1_109","f_bushes_1_110","f_bushes_1_111",
})

local OVERLAY_ALL_VINES = sanitizeList(mergeLists(
    OVERLAY_VINES_WALLSET_A, OVERLAY_VINES_WALLSET_B, OVERLAY_VINES_WALLSET_C,
    OVERLAY_VINES_RAIL_A, OVERLAY_VINES_RAIL_B, OVERLAY_VINES_RAIL_C,
    OVERLAY_VINES_SMALL
))

function D.getRandomFloorGrass()
    return pick(OVERLAY_FLOOR_GRASS)
end

function D.getRandomRoadWeed()
    return pick(OVERLAY_ROAD_WEEDS)
end

function D.getRandomOutdoorWeed()
    return pick(OVERLAY_OUTDOOR_WEEDS)
end

function D.getRandomOutdoorBush()
    return pick(OVERLAY_OUTDOOR_BUSHES)
end

function D.getRandomVine()
    return pick(OVERLAY_ALL_VINES)
end


-- Base sprites (what tiles are allowed to receive overlays)
local BASE_WALLS_SET_A = {
    "walls_exterior_wooden_01_28","walls_commercial_02_0","location_hospitality_sunstarmotel_02_8","location_hospitality_sunstarmotel_02_18",
    "location_restaurant_diner_01_8","location_restaurant_diner_01_0","walls_commercial_01_64","walls_commercial_01_80","walls_commercial_02_8",
    "walls_exterior_house_02_92","DylansWalls01_12","DylansWalls01_4","walls_exterior_house_02_26","fencing_01_80","fencing_01_81",
    "walls_interior_house_01_42","fencing_01_72","walls_commercial_02_8","walls_commercial_01_16","walls_interior_house_04_36","walls_interior_house_04_48",
    "walls_interior_house_03_52","walls_interior_house_03_48","walls_interior_house_03_36","walls_interior_house_03_4","walls_interior_house_02_52",
    "walls_interior_house_02_4","walls_interior_house_02_32","walls_interior_house_01_4","walls_exterior_house_02_4","walls_exterior_wooden_01_0",
    "walls_exterior_wooden_01_40","walls_exterior_wooden_01_68","walls_exterior_wooden_01_64","walls_exterior_wooden_02_0","walls_commercial_03_48",
    "walls_exterior_house_01_0","walls_exterior_house_02_96","walls_exterior_house_02_84","walls_exterior_house_02_68","walls_interior_bathroom_01_0",
    "walls_interior_bathroom_01_16","walls_interior_bathroom_01_4","walls_garage_02_16","location_sewer_01_24","location_sewer_01_0","location_sewer_01_8",
    "industry_trucks_01_4","industry_trucks_01_0","industry_railroad_05_24","location_hospitality_sunstarmotel_01_4","location_hospitality_sunstarmotel_01_0",
    "location_hospitality_sunstarmotel_01_24","location_shop_gas2go_01_0","location_shop_mall_01_0","walls_exterior_house_02_88","walls_exterior_house_02_80",
    "location_restaurant_spiffos_01_5","walls_exterior_house_02_0","walls_exterior_house_02_10","location_restaurant_spiffos_01_6","location_restaurant_spiffos_01_4",
    "location_restaurant_spiffos_01_0","location_restaurant_pizza-whirled_01_0","walls_exterior_house_02_52","walls_interior_house_02_8","walls_interior_house_02_0",
    "walls_interior_house_01_32","walls_interior_house_01_0","walls_interior_house_01_10","walls_interior_house_04_0","walls_interior_house_04_76",
    "walls_interior_house_04_68","walls_interior_house_04_52","industry_railroad_05_8","walls_interior_house_02_58","walls_interior_house_03_16",
    "walls_interior_house_01_30","walls_interior_house_01_28","walls_interior_house_01_20","walls_interior_house_01_16","fencing_01_67","fencing_01_66",
    "walls_exterior_house_02_72","walls_exterior_house_02_24","location_community_church_small_01_8","walls_commercial_03_32","walls_commercial_01_40",
    "walls_garage_01_32","walls_exterior_house_02_56","walls_exterior_house_02_48","location_community_church_small_01_0","location_restaurant_spiffos_01_46",
    "location_restaurant_spiffos_01_40","location_restaurant_spiffos_01_8","location_restaurant_spiffos_01_10","location_restaurant_spiffos_01_8",
    "walls_burnt_01_8","walls_garage_01_32","location_trailer_01_32","location_trailer_01_34","location_trailer_01_37","location_trailer_01_36",
    "location_trailer_01_24","location_trailer_01_10","location_trailer_01_8","location_trailer_01_0","location_shop_bargNclothes_01_24",
    "walls_interior_house_03_10","walls_interior_house_02_16","walls_burnt_01_14","walls_burnt_01_0","walls_burnt_01_4","walls_exterior_house_02_20",
    "walls_interior_house_04_26","walls_interior_house_04_24","walls_interior_house_04_16","walls_interior_house_02_36","walls_interior_house_01_52",
    "walls_interior_house_01_60","walls_interior_house_01_48","walls_exterior_wooden_01_32","walls_exterior_wooden_01_34","walls_exterior_wooden_01_24",
    "walls_interior_house_04_4","walls_interior_house_02_36","walls_interior_house_02_20","walls_exterior_house_01_12","walls_exterior_house_01_4",
    "walls_exterior_house_01_56","walls_exterior_house_01_58","walls_exterior_house_01_58","walls_exterior_house_01_56","walls_exterior_house_01_48",
    "walls_exterior_house_01_56","location_trailer_01_10","location_trailer_01_0","location_trailer_01_8","walls_commercial_01_32",
    "walls_commercial_03_0","walls_garage_01_36","walls_commercial_03_16","walls_interior_house_03_42","walls_interior_house_04_64",
    "walls_interior_house_04_72","walls_exterior_wooden_01_24","walls_interior_house_04_78","walls_interior_house_04_70","fencing_01_59",
    "fencing_01_58","walls_interior_house_04_50","walls_interior_house_04_58","walls_exterior_house_02_40","walls_exterior_house_02_32",
    "walls_garage_01_16","walls_exterior_house_01_40","walls_exterior_house_01_32","walls_interior_house_02_56","walls_interior_house_01_36",
    "walls_interior_house_03_0","walls_interior_house_03_8","walls_interior_house_04_20","walls_interior_house_03_0","walls_interior_house_04_84",
    "walls_exterior_house_01_60","walls_exterior_house_01_52","walls_interior_house_04_32","walls_interior_house_03_28","walls_interior_house_03_20",
    "walls_interior_house_03_40","walls_interior_house_03_32","walls_interior_house_02_48","walls_commercial_01_48","walls_exterior_house_01_24",
    "walls_exterior_house_02_64","walls_exterior_house_02_16","walls_commercial_01_112","walls_exterior_house_01_16","walls_exterior_house_01_16",
    "location_community_church_small_01_4","walls_interior_house_04_80","walls_exterior_house_02_36","walls_exterior_house_02_44",
    "fencing_damaged_01_85","fencing_damaged_01_91","carpentry_02_100","carpentry_02_80","carpentry_02_82","location_military_tent_01_0",
    "location_military_tent_01_8",
}

local BASE_WALLS_SET_B = {
    "walls_commercial_02_54","walls_commercial_01_81","fencing_01_73","walls_commercial_01_33","walls_commercial_02_1","location_hospitality_sunstarmotel_02_9",
    "location_restaurant_diner_01_1","location_restaurant_diner_01_13","walls_exterior_roofs_03_27","walls_exterior_roofs_03_35","walls_commercial_02_9",
    "fencing_01_74","walls_commercial_01_17","walls_commercial_02_9","fixtures_doors_01_49","walls_commercial_01_17","fixtures_doors_01_49",
    "walls_exterior_wooden_01_69","location_hospitality_sunstarmotel_01_25","location_hospitality_sunstarmotel_01_1","location_hospitality_sunstarmotel_01_5",
    "walls_exterior_house_02_5","walls_exterior_house_01_1","location_shop_mall_01_1","location_shop_gas2go_01_1","industry_railroad_05_9",
    "industry_railroad_05_25","industry_trucks_01_1","industry_trucks_01_5","location_sewer_01_1","location_sewer_01_9","location_sewer_01_25",
    "walls_garage_02_17","walls_interior_bathroom_01_1","walls_interior_bathroom_01_17","walls_interior_bathroom_01_5","walls_interior_house_03_5",
    "walls_interior_house_04_65","walls_exterior_wooden_02_1","walls_exterior_wooden_01_1","walls_exterior_wooden_01_41","walls_exterior_wooden_01_65",
    "walls_exterior_house_02_97","walls_exterior_house_02_85","walls_exterior_house_02_69","walls_interior_house_01_5","walls_interior_house_01_1",
    "walls_interior_house_02_33","walls_interior_house_02_5","walls_interior_house_03_49","walls_interior_house_03_53","walls_interior_house_03_37",
    "walls_exterior_house_02_89","walls_exterior_house_02_81","location_restaurant_spiffos_01_16","walls_exterior_house_02_1","location_restaurant_spiffos_01_19",
    "location_restaurant_spiffos_01_18","walls_exterior_house_02_61","walls_exterior_house_02_53","location_restaurant_spiffos_01_17",
    "location_restaurant_spiffos_01_1","location_restaurant_pizzawhirled_01_1","location_community_school_01_11","location_community_school_01_1",
    "fencing_01_89","fencing_01_90","walls_interior_house_02_1","walls_interior_house_02_11","walls_interior_house_01_41","walls_interior_house_01_33",
    "walls_interior_house_04_1","walls_interior_house_01_25","walls_interior_house_01_17","walls_interior_house_04_53","walls_interior_house_01_47",
    "walls_interior_house_03_27","walls_interior_house_02_59","walls_interior_house_02_53","walls_interior_house_02_57","walls_interior_house_03_17",
    "walls_interior_house_03_1","walls_interior_house_01_57","walls_interior_house_01_21","walls_interior_house_01_29",
    "walls_burnt_01_5","walls_burnt_01_1","walls_burnt_01_13","walls_burnt_01_9",
    "fencing_01_64","fencing_01_65","walls_commercial_03_25","fixtures_doors_frames_01_30","walls_exterior_house_02_73","walls_exterior_house_02_65",
    "location_community_church_small_01_9","fencing_01_57","fencing_01_56","location_community_church_small_01_1","walls_commercial_03_49",
    "walls_commercial_03_33","walls_garage_01_33","walls_exterior_house_02_57","walls_exterior_house_02_49","walls_commercial_01_45",
    "walls_commercial_01_41","walls_commercial_01_113","location_community_church_small_01_2","walls_commercial_01_49",
    "location_restaurant_spiffos_01_47","location_restaurant_spiffos_01_41","location_restaurant_spiffos_01_9","walls_burnt_01_15","walls_burnt_01_13",
    "location_trailer_01_38","location_trailer_01_39","location_trailer_01_25","location_trailer_01_35","location_trailer_01_1",
    "location_trailer_01_15","location_trailer_01_14","location_shop_bargNclothes_01_35","location_shop_bargNclothes_01_25",
    "walls_interior_house_03_9","walls_interior_house_03_11","walls_interior_house_02_27","walls_interior_house_02_17",
    "walls_exterior_house_01_17","walls_exterior_house_01_25",
    "walls_exterior_house_02_21","walls_exterior_house_02_29",
    "walls_interior_house_04_17","walls_interior_house_04_25","walls_interior_house_04_27",
    "walls_exterior_wooden_01_38","walls_exterior_wooden_01_37","walls_exterior_wooden_01_29",
    "walls_interior_house_02_37","walls_interior_house_01_53","walls_interior_house_01_49","walls_exterior_wooden_01_25",
    "walls_interior_house_04_5","walls_interior_house_02_21","walls_exterior_house_01_15","walls_exterior_house_01_13","walls_exterior_house_01_5",
    "fencing_01_8","fencing_01_9","walls_exterior_house_01_49","walls_exterior_house_01_59","walls_exterior_house_01_57",
    "location_trailer_01_11","location_trailer_01_1","location_trailer_01_9","walls_exterior_wooden_01_29",
    "carpentry_02_101","location_military_tent_01_0","carpentry_02_81","walls_commercial_03_1","fencing_01_10","fencing_01_11",
    "walls_interior_house_04_66","walls_exterior_wooden_01_33","walls_interior_house_04_49","walls_exterior_house_01_41","walls_exterior_house_01_33",
    "walls_interior_house_04_93","walls_exterior_house_01_53","walls_exterior_house_01_61","walls_exterior_house_02_17","walls_exterior_house_02_25",
    "walls_interior_house_03_21","walls_interior_house_02_49","walls_interior_house_03_33","walls_interior_house_04_33",
    "location_community_church_small_01_5","walls_interior_house_04_81","walls_exterior_house_02_37","walls_exterior_house_02_45",
    "walls_interior_house_04_21","walls_interior_house_04_41","walls_interior_house_01_45","walls_interior_house_01_37",
    "walls_interior_house_04_85","walls_exterior_house_02_33","walls_exterior_house_02_41",
    "walls_interior_house_03_41","walls_interior_house_03_29","walls_interior_house_04_69","walls_interior_house_04_79",
    "walls_commercial_03_17","walls_commercial_03_27","walls_garage_01_37","walls_commercial_01_42","walls_commercial_01_0",
}

local BASE_WALLS_SET_C = {
    "industry_trucks_01_6","walls_interior_house_02_34","walls_interior_house_02_6","location_hospitality_sunstarmotel_02_10","location_restaurant_diner_01_2",
    "walls_exterior_house_01_54","walls_commercial_01_82","walls_commercial_02_10","walls_exterior_house_02_50","walls_exterior_house_02_2",
    "location_restaurant_spiffos_01_15","location_restaurant_pizzawhirled_01_2","location_community_school_01_2",
    "walls_interior_house_01_22","walls_interior_house_01_34","walls_interior_house_04_54","walls_interior_house_04_2","walls_interior_house_04_49",
    "walls_exterior_house_01_50","walls_interior_house_02_54","walls_interior_house_03_18","walls_commercial_03_18","walls_exterior_house_02_34",
    "walls_commercial_03_34","walls_exterior_house_02_66","walls_commercial_01_97","walls_exterior_house_02_18","walls_exterior_house_02_38",
    "location_restaurant_spiffos_01_42","walls_garage_01_34","walls_exterior_wooden_01_26","location_trailer_01_26","walls_interior_house_02_18",
    "walls_exterior_house_01_18","walls_burnt_01_6","walls_exterior_house_02_22","walls_interior_house_04_18","walls_interior_house_02_38",
    "walls_interior_house_01_54","walls_interior_house_01_50","walls_interior_house_04_6","walls_interior_house_02_28","walls_exterior_house_01_6",
    "fencing_01_12","walls_exterior_wooden_01_30","walls_commercial_03_2","walls_garage_01_38","walls_exterior_house_01_34",
    "walls_interior_house_01_38","walls_interior_house_03_22","walls_interior_house_04_86","walls_interior_house_02_50","walls_interior_house_03_34",
    "walls_commercial_01_50","walls_interior_house_04_34","location_community_church_small_01_6","walls_interior_house_04_82","walls_interior_house_03_2",
}

-- Floors & roofs that can receive the FLOOR_GRASS overlay
local BASE_FLOORS_SET_A = sanitizeList({
    "ceilings_01_0","floors_exterior_street_01_0","industry_01_6","floors_exterior_tilesandstone_01_1","floors_interior_carpet_01_15",
    "floors_interior_tilesandwood_01_48","floors_interior_tilesandwood_01_21","floors_interior_tilesandwood_01_19","floors_exterior_tilesandstone_01_6",
    "blends_street_01_69","blends_street_01_64","blends_street_01_71","vegetation_ornamental_01_17","floors_exterior_street_01_14",
    "blends_street_01_55","blends_street_01_0","floors_interior_tilesandwood_01_13","floors_exterior_tilesandstone_01_7","floors_exterior_tilesandstone_01_5",
    "blends_natural_01_55","blends_natural_01_54","blends_natural_01_53","blends_natural_01_48","blends_natural_01_39","blends_natural_01_38",
    "blends_natural_01_37","blends_natural_01_32","blends_natural_01_23","blends_natural_01_22","blends_natural_01_21","blends_natural_01_16",
    "blends_natural_01_51","blends_natural_01_52","blends_natural_01_49","blends_natural_01_59","blends_natural_01_58","blends_natural_01_57",
    "blends_natural_01_56","blends_natural_01_34","blends_natural_01_35","blends_natural_01_36","blends_natural_01_33","blends_natural_01_43",
    "blends_natural_01_42","blends_natural_01_41","blends_natural_01_40","blends_natural_01_18","blends_natural_01_19","blends_natural_01_20",
    "blends_natural_01_17","blends_natural_01_27","blends_natural_01_26","blends_natural_01_25","blends_natural_01_24","blends_natural_01_2",
    "blends_natural_01_3","blends_natural_01_4","blends_natural_01_1","blends_natural_01_11","blends_natural_01_10","blends_natural_01_9",
    "blends_natural_01_8","blends_natural_01_7","blends_natural_01_6","blends_natural_01_64","blends_natural_01_69","blends_natural_01_70",
    "blends_natural_01_71","blends_natural_01_80","blends_natural_01_85","blends_natural_01_86","blends_natural_01_87","blends_natural_01_5",
    "blends_street_01_101","blends_street_01_102","blends_street_01_103","blends_street_01_48","blends_street_01_16","blends_street_01_21",
    "blends_street_01_53","blends_street_01_54","blends_street_01_55","blends_street_01_80","blends_street_01_85","blends_street_01_86",
    "blends_street_01_87","blends_street_01_96",
})

local BASE_FLOORS_SET_B = sanitizeList({
    "ceilings_01_0","floors_interior_tilesandwood_01_29","floors_interior_tilesandwood_01_14","floors_interior_tilesandwood_01_10","floors_interior_tilesandwood_01_23",
    "floors_interior_tilesandwood_01_2","recreational_sports_01_63","location_restaurant_diner_01_40","location_restaurant_diner_01_41","industry_railroad_05_46",
    "location_restaurant_bar_01_24","floors_interior_tilesandwood_01_40","floors_interior_tilesandwood_01_41","floors_interior_carpet_01_4","fixtures_stairs_01_72",
    "fixtures_stairs_01_73","fixtures_stairs_01_74","location_restaurant_spiffos_01_38","location_restaurant_pizzawhirled_01_16","location_shop_mall_01_38",
    "location_shop_mall_01_35","location_shop_mall_01_34","floors_interior_tilesandwood_01_46","location_shop_mall_01_22","floors_rugs_01_21","floors_rugs_01_20",
    "floors_rugs_01_17","floors_rugs_01_23","floors_rugs_01_22","floors_rugs_01_16","camping_01_24","camping_01_25","camping_01_38",
    "camping_01_39","carpentry_02_12","carpentry_02_13","carpentry_02_14","carpentry_02_62","construction_01_4","construction_01_5",
    "floors_burnt_01_0","floors_burnt_01_1","floors_exterior_natural_01_12","floors_exterior_street_01_16","floors_exterior_street_01_17",
    "floors_exterior_tilesandstone_01_2","floors_exterior_tilesandstone_01_3","floors_exterior_tilesandstone_01_5","floors_exterior_tilesandstone_01_7",
    "floors_interior_carpet_01_10","floors_interior_carpet_01_11","floors_interior_carpet_01_12","floors_interior_carpet_01_13","floors_interior_carpet_01_2",
    "floors_interior_carpet_01_3","floors_interior_carpet_01_5","floors_interior_carpet_01_6","floors_interior_carpet_01_9",
    "floors_interior_tilesandwood_01_11","floors_interior_tilesandwood_01_12","floors_interior_tilesandwood_01_16","floors_interior_tilesandwood_01_17",
    "floors_interior_tilesandwood_01_18","floors_interior_tilesandwood_01_3","floors_interior_tilesandwood_01_41","floors_interior_tilesandwood_01_42",
    "floors_interior_tilesandwood_01_43","floors_interior_tilesandwood_01_44","floors_interior_tilesandwood_01_45","floors_interior_tilesandwood_01_49",
    "floors_interior_tilesandwood_01_5","floors_interior_tilesandwood_01_51","floors_interior_tilesandwood_01_52","floors_interior_tilesandwood_01_6",
    "floors_interior_tilesandwood_01_8","floors_rugs_01_24","floors_rugs_01_25","floors_rugs_01_32","floors_rugs_01_33","floors_rugs_01_40",
    "floors_rugs_01_41","furniture_seating_indoor_02_60","furniture_seating_indoor_02_61","furniture_seating_indoor_02_62","furniture_seating_indoor_02_63",
    "location_shop_zippee_01_7",
})

local BASE_ROOFS_SET = sanitizeList({
    "roofs_04_55","ceilings_01_0","roofs_03_23","roofs_01_22","floors_exterior_natural_01_13","floors_exterior_street_01_10","floors_exterior_street_01_12",
    "roofs_03_37","roofs_03_32","roofs_03_54","roofs_02_32","roofs_02_54","floors_exterior_natural_01_44","floors_exterior_tilesandstone_01_4",
    "roofs_02_92","floors_exterior_street_01_16","roofs_02_90","roofs_03_55","location_trailer_01_52","location_trailer_01_53",
    "roofs_05_23","roofs_05_90","roofs_05_5","roofs_05_87","roofs_05_81","roofs_05_80","roofs_05_22","location_trailer_02_45",
    "location_trailer_02_44","roofs_04_5","roofs_02_22","roofs_01_87","roofs_01_86","roofs_01_85","roofs_01_4","roofs_01_91",
    "roofs_01_0","roofs_01_8","roofs_01_5","roofs_01_6","roofs_01_96","roofs_01_81","roofs_02_1","roofs_02_0","roofs_02_24",
    "roofs_01_97","roofs_02_80","roofs_01_80","roofs_02_87","roofs_02_86","roofs_02_85","roofs_02_84","roofs_02_3","roofs_02_23",
    "roofs_02_91","roofs_02_5","roofs_02_4","roofs_02_9","roofs_02_11","roofs_02_2",
})

-- Roof-to-roof overlays (subtle dirt swaps)
local ROOF_BASE_0  = sanitizeList({"roofs_06_0","roofs_05_32","roofs_05_0","roofs_02_0","roofs_01_0"})
local ROOF_OVER_0  = sanitizeList({"roofs_01_32","roofs_03_32","roofs_03_0","roofs_04_0"})
local ROOF_BASE_5  = sanitizeList({"roofs_06_5","roofs_05_37","roofs_05_5","roofs_02_5","roofs_01_5"})
local ROOF_OVER_5  = sanitizeList({"roofs_03_37","roofs_03_5","roofs_01_37","roofs_04_5"})
local ROOF_BASE_1  = sanitizeList({"roofs_01_1","roofs_02_1","roofs_05_1","roofs_06_1"})
local ROOF_OVER_1  = sanitizeList({"roofs_03_1","roofs_04_1"})
local ROOF_BASE_2  = sanitizeList({"roofs_01_2","roofs_02_2","roofs_05_2","roofs_06_2"})
local ROOF_OVER_2  = sanitizeList({"roofs_03_2","roofs_04_2"})
local ROOF_BASE_3  = sanitizeList({"roofs_01_3","roofs_02_3","roofs_05_3","roofs_06_3"})
local ROOF_OVER_3  = sanitizeList({"roofs_03_3","roofs_04_3"})
local ROOF_BASE_4  = sanitizeList({"roofs_01_4","roofs_02_4","roofs_05_4","roofs_06_4"})
local ROOF_OVER_4  = sanitizeList({"roofs_03_4","roofs_04_4"})

local ROOF_BASE_A  = sanitizeList({"roofs_01_0","roofs_02_0","roofs_05_0","roofs_06_0"})
local ROOF_OVER_A  = sanitizeList({"roofs_03_0","roofs_04_0"})

local ROOF_BASE_B  = sanitizeList({"roofs_02_106","roofs_02_104","roofs_05_138","roofs_05_136"})
local ROOF_OVER_B  = sanitizeList({"roofs_04_72","roofs_04_74"})
local ROOF_BASE_C  = sanitizeList({"roofs_02_107","roofs_02_105","roofs_05_137","roofs_05_139"})
local ROOF_OVER_C  = sanitizeList({"roofs_04_73","roofs_04_75"})
local ROOF_BASE_D  = sanitizeList({"roofs_02_110","roofs_02_109","roofs_02_111","roofs_05_141","roofs_05_143"})
local ROOF_OVER_D  = sanitizeList({"roofs_04_77","roofs_04_79"})
local ROOF_BASE_E  = sanitizeList({"roofs_02_109","roofs_02_108","roofs_05_110","roofs_05_142","roofs_05_140"})
local ROOF_OVER_E  = sanitizeList({"roofs_04_78","roofs_04_76"})


D.trimSpriteName = trimSpriteName
D.sanitizeList   = sanitizeList

-- Export all pools/sets used by VegOverlay.register()
D.OVERLAY_FLOOR_GRASS = OVERLAY_FLOOR_GRASS
D.OVERLAY_VINES_WALLSET_A = OVERLAY_VINES_WALLSET_A
D.OVERLAY_VINES_WALLSET_B = OVERLAY_VINES_WALLSET_B
D.OVERLAY_VINES_WALLSET_C = OVERLAY_VINES_WALLSET_C
D.OVERLAY_VINES_RAIL_A = OVERLAY_VINES_RAIL_A
D.OVERLAY_VINES_RAIL_B = OVERLAY_VINES_RAIL_B
D.OVERLAY_VINES_RAIL_C = OVERLAY_VINES_RAIL_C
D.OVERLAY_VINES_SMALL  = OVERLAY_VINES_SMALL

D.ROOF_BASE_0 = ROOF_BASE_0; D.ROOF_OVER_0 = ROOF_OVER_0
D.ROOF_BASE_5 = ROOF_BASE_5; D.ROOF_OVER_5 = ROOF_OVER_5
D.ROOF_BASE_1 = ROOF_BASE_1; D.ROOF_OVER_1 = ROOF_OVER_1
D.ROOF_BASE_2 = ROOF_BASE_2; D.ROOF_OVER_2 = ROOF_OVER_2
D.ROOF_BASE_3 = ROOF_BASE_3; D.ROOF_OVER_3 = ROOF_OVER_3
D.ROOF_BASE_4 = ROOF_BASE_4; D.ROOF_OVER_4 = ROOF_OVER_4
D.ROOF_BASE_A = ROOF_BASE_A; D.ROOF_OVER_A = ROOF_OVER_A
D.ROOF_BASE_B = ROOF_BASE_B; D.ROOF_OVER_B = ROOF_OVER_B
D.ROOF_BASE_C = ROOF_BASE_C; D.ROOF_OVER_C = ROOF_OVER_C
D.ROOF_BASE_D = ROOF_BASE_D; D.ROOF_OVER_D = ROOF_OVER_D
D.ROOF_BASE_E = ROOF_BASE_E; D.ROOF_OVER_E = ROOF_OVER_E

D.BASE_FLOORS_SET_A = BASE_FLOORS_SET_A
D.BASE_FLOORS_SET_B = BASE_FLOORS_SET_B
D.BASE_ROOFS_SET    = BASE_ROOFS_SET
D.BASE_WALLS_SET_A   = BASE_WALLS_SET_A
D.BASE_WALLS_SET_B   = BASE_WALLS_SET_B
D.BASE_WALLS_SET_C   = BASE_WALLS_SET_C

return D