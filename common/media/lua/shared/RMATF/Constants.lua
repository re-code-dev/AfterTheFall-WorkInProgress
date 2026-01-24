-- ============================================================
--  Re:Mind — After the Fall (RMATF)
--  Author: Seppel
-- ============================================================

RMATF = RMATF or {}
RMATF.Constants = RMATF.Constants or {}
local C = RMATF.Constants

C.MOD_ID     = "ReMindsAftertheFall"
C.PAGE_ID    = "RMATF"
C.LOG_PREFIX = "[RMATF] "


C.MinSquaresPerTick        = 50
C.MaxSquaresPerTick        = 10000
C.DefaultMaxSquaresPerTick = 3000


C.DEFAULTS = {
    Enable           = true,
    Debug            = false,

    -- Trees: 1=low, 2=med, 3=high (4 removed)
    treesChance     = 3,
    noTreesOnRoad   = false,

    -- Overgrowth base preset: 1=low, 2=med, 3=high (4 removed)
    vegOverlayChance = 3,

    -- Multipliers (percent of base) — HIGH
    IndoorMultiplier  = 180,
    OutdoorMultiplier = 260,
    VinesMultiplier   = 320,

    -- World decay (visual "age")
    EnableDecay             = true,
    DecayMultiplier         = 180,
    WallDamageChance        = 40,
    RoofDamageChance        = 35,
    WindowSmashChance       = 30,
    BarricadeChance         = 25,

    -- Performance
    MaxSquaresPerTick = 5000,
}
return C