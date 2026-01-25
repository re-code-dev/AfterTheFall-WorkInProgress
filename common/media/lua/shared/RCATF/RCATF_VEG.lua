--10100101110--10100101111--10100101110--10100101110--
--1010  ____            ____          _            0101        Author : Seppel
--1111 |  _ \ ___ : ___/ ___|___   __| | ___       1010
--1010 | |_) / _ \:/ __| |   / _ \ / _` |/ _ \     1111
--1111 |  _ <  __/:\__ \ |__| (_) | (_| |  __/     1010
--1010 |_| \_\___| :___/\____\___/ \__,_|\___|     1111
--10100101110--10100101111--10100101110--10100101110--

local overlays = {}
overlays.VERSION = 1

local function chance01(value, defaultPercent)
    local n = tonumber(value)
    if not n then n = defaultPercent end
    if n < 10 then n = 10 end
    if n > 100 then n = 100 end
    return n / 100
end

local cfg = SandboxVars and SandboxVars.RCATF or {}
local overlayChance = chance01(cfg.VegOverlayChance, 30)

local function addOverlay(baseTile, tilePool)
    overlays[baseTile] = {
        { name = "other", chance = overlayChance, usage = "", tiles = tilePool }
    }
end

local function addRange(dst, prefix, from, to)
    for i = from, to do
        dst[#dst + 1] = prefix .. tostring(i)
    end
end

-- Ground overlays (grass + plants)
local GROUND_OVERLAYS = {
    "e_newgrass_1_116","e_newgrass_1_115","e_newgrass_1_114","e_newgrass_1_113","e_newgrass_1_112",
    "e_newgrass_1_89","e_newgrass_1_90","e_newgrass_1_91","e_newgrass_1_92","e_newgrass_1_93",
    "e_newgrass_1_69","e_newgrass_1_68","e_newgrass_1_67","e_newgrass_1_66","e_newgrass_1_65",
    "e_newgrass_1_40","e_newgrass_1_45","e_newgrass_1_44","e_newgrass_1_43","e_newgrass_1_42","e_newgrass_1_41",
    "e_newgrass_1_16","e_newgrass_1_17","e_newgrass_1_18","e_newgrass_1_19","e_newgrass_1_20","e_newgrass_1_21",
    "d_generic_1_14","d_generic_1_10",
    "d_plants_1_62","d_plants_1_58","d_plants_1_61","d_plants_1_27","d_plants_1_24",
}

-- Wall vines
local WALL_VINES = {
    -- set A
    "f_wallvines_1_43","f_wallvines_1_42","f_wallvines_1_37","f_wallvines_1_36","f_wallvines_1_31","f_wallvines_1_30","f_wallvines_1_25","f_wallvines_1_24",
    -- set B
    "f_wallvines_1_45","f_wallvines_1_44","f_wallvines_1_39","f_wallvines_1_38","f_wallvines_1_33","f_wallvines_1_32","f_wallvines_1_27","f_wallvines_1_26",
    -- set C
    "f_wallvines_1_47","f_wallvines_1_46","f_wallvines_1_41","f_wallvines_1_40","f_wallvines_1_35","f_wallvines_1_34","f_wallvines_1_29","f_wallvines_1_28",
}

-- Targets: lawns/parks/ground
local GROUND_TARGETS = {}
addRange(GROUND_TARGETS, "blends_natural_01_", 0, 103)
addRange(GROUND_TARGETS, "floors_exterior_natural_01_", 0, 64)
addRange(GROUND_TARGETS, "floors_exterior_street_01_", 0, 20)
addRange(GROUND_TARGETS, "blends_street_01_", 0, 103)
addRange(GROUND_TARGETS, "floors_exterior_tilesandstone_01_", 0, 7)

-- Targets: exterior walls/fences for vines (broad coverage)
local WALL_TARGETS = {}
addRange(WALL_TARGETS, "walls_exterior_house_01_", 0, 120)
addRange(WALL_TARGETS, "walls_exterior_house_02_", 0, 120)
addRange(WALL_TARGETS, "walls_exterior_wooden_01_", 0, 80)
addRange(WALL_TARGETS, "walls_exterior_wooden_02_", 0, 20)
addRange(WALL_TARGETS, "walls_commercial_01_", 0, 120)
addRange(WALL_TARGETS, "walls_commercial_02_", 0, 80)
addRange(WALL_TARGETS, "walls_commercial_03_", 0, 80)
addRange(WALL_TARGETS, "fencing_01_", 0, 120)

for _, tile in ipairs(GROUND_TARGETS) do
    addOverlay(tile, GROUND_OVERLAYS)
end

for _, tile in ipairs(WALL_TARGETS) do
    addOverlay(tile, WALL_VINES)
end

if not TILEZED then
    getTileOverlays():addOverlays(overlays)
end

return overlays
