-- ============================================================
--  Re:Mind — After the Fall
--  Author: Seppel
-- ============================================================

-- Server bootstrap (keep minimal)
require("RMATF/Init")

local function onServerStarted()
    if RMATF and RMATF.Utils and RMATF.Utils.log then
        RMATF.Utils.log("Server loaded (Generator active).")
    else
        print("[RMATF] Server loaded (Generator active).")
    end
end

if Events and Events.OnServerStarted and Events.OnServerStarted.Add then
    Events.OnServerStarted.Add(onServerStarted)
end
