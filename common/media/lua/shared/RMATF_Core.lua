RMATF = RMATF or {}

-- Prefix-based classification (safe + simple)
RMATF.PREFIX = {
    WALL = {
        "walls_",
        "walls_exterior_",
        "walls_interior_",
    },
    FENCE = {
        "fencing_",
        "fixtures_railings_",
        "fixtures_doors_fences_",
    },
    VINE = {
        "f_wallvines_",
        "wallvines_",
        "vines_",
    },
    BLEND = {
        "blends_",
        "overlays_",
    }
}

local function startsWith(s, p)
    return s and p and s:sub(1, #p) == p
end

function RMATF.isWall(spriteName)
    for _, p in ipairs(RMATF.PREFIX.WALL) do
        if startsWith(spriteName, p) then return true end
    end
    return false
end

function RMATF.isFence(spriteName)
    for _, p in ipairs(RMATF.PREFIX.FENCE) do
        if startsWith(spriteName, p) then return true end
    end
    return false
end

function RMATF.isVine(spriteName)
    for _, p in ipairs(RMATF.PREFIX.VINE) do
        if startsWith(spriteName, p) then return true end
    end
    return false
end

function RMATF.isBlend(spriteName)
    for _, p in ipairs(RMATF.PREFIX.BLEND) do
        if startsWith(spriteName, p) then return true end
    end
    return false
end
