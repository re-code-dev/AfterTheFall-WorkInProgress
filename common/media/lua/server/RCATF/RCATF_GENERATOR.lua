--10100101110--10100101111--10100101110--10100101110--
--1010  ____             ____          _        0101--       -- Author : Seppel --
--1111 |  _ \ ___ :  ___/ ___|___   __| | ___   1010--
--1010 | |_) / _ \:  __| |   / _ \ / _` |/ _ \  1111--
--1111 |  _ <  __/: __ \ |__| (_) | (_| |  __/  1010--
--1010 |_| \_\___| :___/\____\___/ \__,_|\___|  1111--
--10100101110--10100101111--10100101110--10100101110--
require("RCATF/RCATF_SQUARE_CHECK")
require("luautils")

local okIsoUtils, IsoObjectUtils = pcall(require, "Starlit/IsoObjectUtils")
if not okIsoUtils then IsoObjectUtils = nil end

local function clamp01(x)
    if x < 0 then return 0 end
    if x > 1 then return 1 end
    return x
end

local function getConfig()
    local c = (SandboxVars and SandboxVars.RCATF) or {}

    local treeChance = tonumber(c.TreeChance) or 30
    local grassChance = tonumber(c.GrassChance) or 30
    local bushChance = tonumber(c.BushChance) or 20

    return {
        treeDensity = clamp01(treeChance / 100),
        grassDensity = clamp01(grassChance / 100),
        bushDensity = clamp01(bushChance / 100),

        noTreesOnRoad = c.noTreesOnRoad == true,
        disableGrassSpawn = c.disableGrassSpawn == true,
        disableBushSpawn = c.disableBushSpawn == true,

        disableRandomTrash = c.disableRandomTrash == true,
        randomTrashRate = tonumber(c.randomTrashRate) or 20,
    }
end

local TREE_SPRITES = {
    "e_carolinasilverbell_1_0","e_easternredbud_1_0","e_americanlinden_1_0","e_americanholly_1_1",
    "e_canadianhemlock_1_1","e_riverbirch_1_0","e_yellowwoodJUMBO_1_0","e_yellowwoodJUMBO_1_1",
    "e_carolinasilverbellJUMBO_1_0","e_carolinasilverbellJUMBO_1_1","e_easternredbudJUMBO_1_0",
    "e_easternredbudJUMBO_1_1","e_virginiapineJUMBO_1_0","e_virginiapineJUMBO_1_1","e_redmapleJUMBO_1_0",
    "e_redmapleJUMBO_1_1","e_americanlindenJUMBO_1_0","e_americanlindenJUMBO_1_1","e_americanhollyJUMBO_1_0",
    "e_americanhollyJUMBO_1_1","e_canadianhemlockJUMBO_1_0","e_canadianhemlockJUMBO_1_1",
    "e_cockspurhawthornJUMBO_1_0","e_cockspurhawthornJUMBO_1_1","e_dogwoodJUMBO_1_0","e_cockspurhawthorn_1_3",
    "e_easternredbud_1_3","e_dogwoodJUMBO_1_1","e_riverbirchJUMBO_1_0","e_riverbirchJUMBO_1_1"
}

local STREET_TILES = {
    ["blends_street_01_96"]=true,["blends_street_01_101"]=true,["blends_street_01_102"]=true,["blends_street_01_103"]=true,
    ["blends_street_01_80"]=true,["blends_street_01_85"]=true,["blends_street_01_86"]=true,["blends_street_01_87"]=true,
    ["blends_street_01_32"]=true,["blends_street_01_37"]=true,["blends_street_01_38"]=true,["blends_street_01_39"]=true,
    ["blends_street_01_64"]=true,["blends_street_01_69"]=true,["blends_street_01_70"]=true,["blends_street_01_71"]=true,
    ["blends_street_01_48"]=true,["blends_street_01_53"]=true,["blends_street_01_54"]=true,["blends_street_01_55"]=true,
    ["blends_natural_01_0"]=true,["blends_natural_01_5"]=true,["blends_natural_01_6"]=true,["blends_natural_01_7"]=true
}

local GRASS_OVERLAYS = {
    "e_newgrass_1_16","e_newgrass_1_17","e_newgrass_1_18","e_newgrass_1_19","e_newgrass_1_20","e_newgrass_1_21",
    "e_newgrass_1_8","e_newgrass_1_9","e_newgrass_1_10","e_newgrass_1_11","e_newgrass_1_12","e_newgrass_1_13",
    "e_newgrass_1_0","e_newgrass_1_1","e_newgrass_1_2","e_newgrass_1_3","e_newgrass_1_4","e_newgrass_1_5",
}

local BIG_BUSHES = {
    "f_bushes_1_65","f_bushes_1_66","f_bushes_1_97","f_bushes_1_98","f_bushes_1_77","f_bushes_1_78",
    "f_bushes_1_110","f_bushes_1_109","f_bushes_1_99","f_bushes_1_67","f_bushes_1_103","f_bushes_1_71",
    "f_bushes_1_69","f_bushes_1_70","f_bushes_1_72","f_bushes_1_73","f_bushes_1_75","f_bushes_1_76",
    "f_bushes_1_79","f_bushes_1_101","f_bushes_1_102","f_bushes_1_104","f_bushes_1_105","f_bushes_1_107",
    "f_bushes_1_108","f_bushes_1_111","f_bushes_1_64","f_bushes_1_96","f_bushes_1_100","f_bushes_1_68",
    "f_bushes_1_106","f_bushes_1_74"
}

local function isRoadSquare(square)
    local floor = square and square:getFloor()
    local spr = floor and floor:getSprite()
    local name = spr and spr:getName()
    return name and STREET_TILES[name] == true
end

local function spawnTree(square)
    local spriteName = TREE_SPRITES[ZombRand(1, #TREE_SPRITES + 1)]
    local sprite = getSprite(spriteName)
    if not sprite then return end
    local tree = IsoTree.new(square, sprite)
    square:AddSpecialObject(tree)
    tree:setAttachedAnimSprite(ArrayList.new())
end

local function spawnOverlay(square, sprites)
    local spriteName = sprites[ZombRand(1, #sprites + 1)]
    if not spriteName then return end
    local obj = IsoObject.new(getCell(), square, spriteName)
    square:AddSpecialObject(obj)
end

local function spawnTrash(square)
    local n = ZombRand(0, 52)
    local spriteName = "trash_01_" .. tostring(n)
    local obj = IsoObject.new(getCell(), square, spriteName)
    square:getObjects():add(obj)
    square:RecalcProperties()
end

local processed = nil

local function shouldProcessChunk(chunk)
    processed = processed or ModData.getOrCreate("RCATF_chunks")
    local key = tostring(chunk.wx) .. "x" .. tostring(chunk.wy)
    if processed[key] then return false end
    processed[key] = true
    return true
end

local function canTouchSquare(square)
    if not square then return false end

    -- Only apply StarlitLibrary's playable-area filter for negative Z levels.
    -- On some B42 builds it can classify normal outdoor ground tiles as non-playable.
    if square:getZ() < 0 and IsoObjectUtils and IsoObjectUtils.isInPlayableArea then
        local ok = true
        local success, res = pcall(IsoObjectUtils.isInPlayableArea, square)
        if success then ok = res end
        if not ok then return false end
    end

    return checkSquare(square)
end

local function processChunk(chunk)
    if not shouldProcessChunk(chunk) then return end

    local cfg = getConfig()
    local minZ, maxZ = chunk:getMinLevel(), chunk:getMaxLevel()

    for x = 0, 9 do
        for y = 0, 9 do
            for z = minZ, maxZ do
                local sq = chunk:getGridSquare(x, y, z)
                if sq and canTouchSquare(sq) then
                    if z == 0 and cfg.noTreesOnRoad and isRoadSquare(sq) then
                        -- keep the road clean (no tree spawns)
                    else
                        if (not cfg.disableGrassSpawn) and ZombRandFloat(0, 1) < cfg.grassDensity then
                            spawnOverlay(sq, GRASS_OVERLAYS)
                        end
                        if (not cfg.disableBushSpawn) and ZombRandFloat(0, 1) < cfg.bushDensity then
                            spawnOverlay(sq, BIG_BUSHES)
                        end
                        if ZombRandFloat(0, 1) < cfg.treeDensity then
                            spawnTree(sq)
                        end
                    end

                    if (not cfg.disableRandomTrash) and z < maxZ and ZombRand(0, cfg.randomTrashRate) == 0 then
                        spawnTrash(sq)
                    end
                end
            end
        end
    end
end

Events.LoadChunk.Add(processChunk)
