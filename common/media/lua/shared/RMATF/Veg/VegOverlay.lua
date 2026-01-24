-- ============================================================
--  Re:Mind — After the Fall (RMATF)
--  VegOverlay.lua (B42.13.x)
--  TYL-style, no scanning, safe registration
-- ============================================================

RMATF = RMATF or {}
RMATF.Veg = RMATF.Veg or {}
RMATF.Veg.VegOverlay = RMATF.Veg.VegOverlay or {}
local V = RMATF.Veg.VegOverlay

local Data = require("RMATF/Veg/Data")

local function clamp(v, lo, hi)
    v = tonumber(v)
    if not v then return lo end
    if v < lo then return lo end
    if v > hi then return hi end
    return math.floor(v)
end

local function addOverlayMap(overlays, baseList, chanceInt, overlayTiles)
    if not baseList or not overlayTiles then return end
    baseList    = Data.sanitizeList(baseList)
    overlayTiles = Data.sanitizeList(overlayTiles)
    if #baseList == 0 or #overlayTiles == 0 then return end

    for _, base in ipairs(baseList) do
        overlays[base] = overlays[base] or {}
        table.insert(overlays[base], {
            name   = "other",
            chance = chanceInt, -- INT chance (TYL style)
            usage  = "",
            tiles  = overlayTiles,
        })
    end
end

local function getBaseChanceInt()
    local S = RMATF.Sandbox
    if not S then return 3 end

    -- strict 3-step preset (NO custom level 4)
    local mode = clamp(S.getInt and S.getInt("vegOverlayChance", 2) or 2, 1, 3)
    if mode == 1 then return 1 end
    if mode == 2 then return 3 end
    return 5
end

local function scaleChance(base, multKey, defaultMult)
    local S = RMATF.Sandbox
    if not S or not S.getInt then return base end
    local mult = clamp(S.getInt(multKey, defaultMult), 0, 500)
    local out = math.floor(base * mult / 100)
    return clamp(out, 1, 25)
end

function V.register()
    if V._registered then return end
    if TILEZED then return end
    if not getTileOverlays then return end
    if not RMATF.Sandbox or not RMATF.Sandbox.isEnabled() then return end

    local baseChance = getBaseChanceInt()
    if baseChance <= 0 then return end

    local floorChance = scaleChance(baseChance, "OutdoorMultiplier", 220)
    local wallChance  = scaleChance(baseChance, "VinesMultiplier", 250)

    local overlays = {}

    -- =========================
    -- FLOOR OVERLAYS
    -- =========================
    addOverlayMap(overlays, Data.BASE_FLOORS_SET_A, floorChance, Data.OVERLAY_FLOOR_GRASS)
    addOverlayMap(overlays, Data.BASE_FLOORS_SET_B, floorChance, Data.OVERLAY_FLOOR_GRASS)

    -- =========================
    -- WALL / VINE OVERLAYS
    -- =========================
    addOverlayMap(overlays, Data.BASE_WALLS_SET_A, wallChance, Data.OVERLAY_VINES_WALLSET_A)
    addOverlayMap(overlays, Data.BASE_WALLS_SET_B, wallChance, Data.OVERLAY_VINES_WALLSET_B)
    addOverlayMap(overlays, Data.BASE_WALLS_SET_C, wallChance, Data.OVERLAY_VINES_WALLSET_C)

    -- Rails / fences
    if Data.BASE_WALLS_SET_A then
        addOverlayMap(overlays, Data.BASE_WALLS_SET_A, wallChance, Data.OVERLAY_VINES_RAIL_A)
        addOverlayMap(overlays, Data.BASE_WALLS_SET_B, wallChance, Data.OVERLAY_VINES_RAIL_B)
        addOverlayMap(overlays, Data.BASE_WALLS_SET_C, wallChance, Data.OVERLAY_VINES_RAIL_C)
    end

    -- small helper vines
    addOverlayMap(overlays, Data.BASE_WALLS_SET_A, wallChance, Data.OVERLAY_VINES_SMALL)

    getTileOverlays():addOverlays(overlays)
    V._registered = true

    if RMATF.Utils and RMATF.Utils.log then
        local c = 0
        for _ in pairs(overlays) do c = c + 1 end
        RMATF.Utils.log("[RMATF] VegOverlay registered " .. c .. " base sprites")
    end
end

if Events and Events.OnLoadedTileDefinitions then
    Events.OnLoadedTileDefinitions.Add(function()
        V.register()
    end)
end

return V
