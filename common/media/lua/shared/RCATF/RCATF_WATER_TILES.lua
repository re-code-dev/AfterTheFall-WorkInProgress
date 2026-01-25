--10100101110--10100101111--10100101110--10100101110--
--1010  ____            ____          _            0101        Author : Seppel
--1111 |  _ \ ___ : ___/ ___|___   __| | ___       1010
--1010 | |_) / _ \:/ __| |   / _ \ / _` |/ _ \     1111
--1111 |  _ <  __/:\__ \ |__| (_) | (_| |  __/     1010
--1010 |_| \_\___| :___/\____\___/ \__,_|\___|     1111
--10100101110--10100101111--10100101110--10100101110--

-- Whitelist: ONLY these sprite names count as "river/lake water".
-- This intentionally ignores puddles/wet overlays even if they expose IsoFlagType.water.
local WATER_TILES = {
    ["blends_natural_02_0"] = true,
    ["blends_natural_02_5"] = true,
    ["blends_natural_02_6"] = true,
    ["blends_natural_02_7"] = true,
}

return WATER_TILES
