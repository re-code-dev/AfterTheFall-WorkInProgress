-- ============================================================
--  Re:Mind — After the Fall (RMATF)
--  Author: Seppel
-- ============================================================

-- RMATF/Init.lua
-- Shared-side entry point.

RMATF = RMATF or {}

-- Compatibility flag (some older loaders expected this)
RMATF._MAIN_LOADED = true

require("RMATF/Constants")
require("RMATF/Utils")
require("RMATF/Sandbox")

require("RMATF/Generator")

return RMATF
