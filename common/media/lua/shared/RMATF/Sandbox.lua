--

-- TileOverlay registrations (TileOverlays API) can spam logs on some B42 tiles.
-- Default: disabled (use generator-based overgrowth instead).
--============================================================
--  Re:Mind — After the Fall (RMATF)
--  Author: Seppel
-- ============================================================
RMATF = RMATF or {}
RMATF.Sandbox = RMATF.Sandbox or {}
local S = RMATF.Sandbox

local function getRoot()
    return SandboxVars
end

local function getPage()
    local root = getRoot()
    if not root then return nil end
    local pageId = (RMATF.Constants and RMATF.Constants.PAGE_ID) or "RMATF"
    return root[pageId] or {}

end

local function getDefault(key, fallback)
    local C = RMATF.Constants
    if C and C.DEFAULTS and C.DEFAULTS[key] ~= nil then
        return C.DEFAULTS[key]
    end
    return fallback
end

function S.getBool(key, fallback)
    local page = getPage()
    if not page then return getDefault(key, fallback) end
    local v = page[key]
    if v == nil then return getDefault(key, fallback) end
    return v == true
end

function S.getInt(key, fallback)
    local page = getPage()
    if not page then return getDefault(key, fallback) end
    local v = page[key]
    if v == nil then return getDefault(key, fallback) end
    local n = tonumber(v)
    if not n then return getDefault(key, fallback) end
    return math.floor(n)
end

local function clampPercent(n)
    n = tonumber(n) or 0
    if n < 0 then n = 0 end
    if n > 100 then n = 100 end
    return math.floor(n)
end

function S.isEnabled()
    return S.getBool("Enable", true)
end

function S.isGeneratorEnabled()
    return S.getBool("EnableGenerator", true)
end

--
-- Overgrowth base chance (percent)
--
function S.getOvergrowBasePercent()
    -- vegOverlayChance enum + customVegOverlay percent
    local mode   = S.getInt("vegOverlayChance", 2)
    
    if mode == 4 then mode = 3 end
-- NOTE: We intentionally keep accepting a saved value of 4 from older presets,
    -- but treat it as "High". Build 42 configs error if a save contains 4 while
    -- the option max is 3.

    if mode == 1 then return 6 end      -- Low
    if mode == 2 then return 15 end     -- Medium
    if mode == 3 or mode == 4 then return 35 end -- High (and legacy 4)
    return 15
end

local function applyMultiplier(basePct, multKey, defaultMult)
    local mult = S.getInt(multKey, defaultMult)
    if mult < 0 then mult = 0 end
    -- Build 42 sandbox UI presets commonly go up to 400%.
    if mult > 400 then mult = 400 end
    local out = math.floor((basePct * mult) / 100)
    return clampPercent(out)
end

local function applyCappedMultiplier(basePct, multKey, defaultMult, capKey, defaultCap)
    local pct = applyMultiplier(basePct, multKey, defaultMult)
    local cap = S.getInt(capKey, defaultCap)
    cap = tonumber(cap) or defaultCap
    -- cap <= 0 means "no cap"
    if cap and cap > 0 then
        if pct > cap then pct = cap end
    end
    return clampPercent(pct)
end

function S.getIndoorHardCap()
    return S.getInt("IndoorHardCap", 0)
end

function S.getOutdoorHardCap()
    return S.getInt("OutdoorHardCap", 0)
end

function S.getVinesHardCap()
    return S.getInt("VinesHardCap", 0)
end

function S.getDecayMultiplier()
    local m = S.getInt("DecayMultiplier", 100)
    if m < 0 then m = 0 end
    if m > 400 then m = 400 end
    return m
end


function S.getIndoorOvergrowPercent()
    -- default cap = 0 (no cap). Caps are controlled by the sandbox sliders.
    return applyCappedMultiplier(S.getOvergrowBasePercent(), "IndoorMultiplier", 100, "IndoorHardCap", 0)
end

function S.getOutdoorOvergrowPercent()
    return applyCappedMultiplier(S.getOvergrowBasePercent(), "OutdoorMultiplier", 100, "OutdoorHardCap", 0)
end

function S.getVinesOvergrowPercent()
    return applyCappedMultiplier(S.getOvergrowBasePercent(), "VinesMultiplier", 100, "VinesHardCap", 0)
end

--
-- Tree chance (divisor, lower = more trees)
--
function S.getTreeSpawnDivisor()
    local mode   = S.getInt("treesChance", 2)
    if mode == 4 then mode = 3 end
    local custom = S.getInt("customTreeSpawn", 50)

    local div
    if mode == 1 then div = 60
    elseif mode == 2 then div = 25
    elseif mode == 3 then div = 10
    elseif mode == 4 then div = 10 -- legacy "4" treated as High
    else div = 25 end

    div = tonumber(div) or 25
    if div < 1 then div = 1 end
    if div > 500 then div = 500 end
    return math.floor(div)
end

function S.noTreesOnRoad()
    return S.getBool("noTreesOnRoad", false)
end

--
-- Decay / "age" chances (percent)
--
function S.isDecayEnabled()
    return S.getBool("EnableDecay", true)
end

function S.getWallDamageChance()
    local base = clampPercent(S.getInt("WallDamageChance", 13))
    local m = S.getDecayMultiplier and S.getDecayMultiplier() or 100
    return clampPercent(math.floor((base * m) / 100))
end

function S.getRoofDamageChance()
    local base = clampPercent(S.getInt("RoofDamageChance", 10))
    local m = S.getDecayMultiplier and S.getDecayMultiplier() or 100
    return clampPercent(math.floor((base * m) / 100))
end

function S.getWindowSmashChance()
    local base = clampPercent(S.getInt("WindowSmashChance", 12))
    local m = S.getDecayMultiplier and S.getDecayMultiplier() or 100
    return clampPercent(math.floor((base * m) / 100))
end

function S.getBarricadeChance()
    local base = clampPercent(S.getInt("BarricadeChance", 3))
    local m = S.getDecayMultiplier and S.getDecayMultiplier() or 100
    return clampPercent(math.floor((base * m) / 100))
end

-- Kept for backwards-compat callers (old name)
function S.getOverlayChance()
    return S.getOvergrowBasePercent()
end

function S.getMaxSquaresPerTick()
    local C = RMATF.Constants
    local val = S.getInt("MaxSquaresPerTick", C and C.DefaultMaxSquaresPerTick or 3000)
    return (RMATF.Utils and RMATF.Utils.clampInt or function(v) return v end)(
        val,
        C and C.MinSquaresPerTick or 50,
        C and C.MaxSquaresPerTick or 20000
    )
end
return S