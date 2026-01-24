-- ============================================================
--  Re:Mind — After the Fall
--  Author: Seppel
-- ============================================================

-- Client bootstrap (keep minimal)
require("RMATF/Init")

local function onGameStart()
    if RMATF and RMATF.Utils and RMATF.Utils.log then
        RMATF.Utils.log("Client loaded.")
    else
        print("[RMATF] Client loaded.")
    end
end

if Events and Events.OnGameStart and Events.OnGameStart.Add then
    Events.OnGameStart.Add(onGameStart)
end
