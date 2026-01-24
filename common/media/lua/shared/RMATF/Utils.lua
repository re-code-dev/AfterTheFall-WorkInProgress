-- ============================================================
--  Re:Mind — After the Fall (RMATF)
--  Author: Seppel
-- ============================================================

RMATF = RMATF or {}
RMATF.Utils = RMATF.Utils or {}
local U = RMATF.Utils

function U.isDebug()
    return RMATF.Sandbox and RMATF.Sandbox.getBool and RMATF.Sandbox.getBool("Debug", false) or false
end

function U.log(msg)
    local p = (RMATF.Constants and RMATF.Constants.LOG_PREFIX) or "[RMATF] "
    print(p .. tostring(msg))
end

function U.debug(msg)
    if U.isDebug() then
        U.log("DEBUG: " .. tostring(msg))
    end
end

function U.clampInt(value, minValue, maxValue)
    local v = tonumber(value) or 0
    if v < minValue then return minValue end
    if v > maxValue then return maxValue end
    return math.floor(v)
end

-- Run a function once per key (simple idempotency helper)
U._once = U._once or {}
function U.once(key, fn)
    if U._once[key] then return false end
    U._once[key] = true
    local ok, err = pcall(fn)
    if not ok then
        U.log("ERROR in once(" .. tostring(key) .. "): " .. tostring(err))
    end
    return ok
end

return U
