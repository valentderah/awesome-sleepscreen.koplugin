local logger = require("logger")

local Registry = { _types = {}, _meta = {} }

function Registry.register(type_id, builder, meta)
    Registry._types[type_id] = builder
    meta = meta or {}
    local span = tonumber(meta.default_col_span)
    if span ~= 2 and span ~= 3 then
        span = 1
    end
    Registry._meta[type_id] = {
        default_col_span = span,
        needs_sleep_refresh = meta.needs_sleep_refresh and true or false,
    }
end

function Registry.placements_want_refresh(placements)
    local GridModel = require("grid.grid_model")
    local function default_span(t)
        return Registry.default_col_span(t)
    end
    local list = GridModel.normalizePlacements(placements or {}, default_span)
    local resolved = GridModel.placementsWithSpan(list, default_span)
    for _, p in ipairs(resolved) do
        local m = Registry._meta[p.type]
        if m and m.needs_sleep_refresh then
            return true
        end
    end
    return false
end

function Registry.default_col_span(type_id)
    local m = Registry._meta[type_id]
    return (m and m.default_col_span) or 1
end

function Registry.build(block, ctx)
    local id = block.type
    local fn = Registry._types[id]
    if not fn then
        logger.warn("sleepscreenwidgets", "unknown widget type: " .. tostring(id))
        return nil
    end
    return fn(block.params or {}, ctx)
end

function Registry.ensure_registered()
    if Registry._registered then
        return
    end
    Registry._registered = true
    Registry._meta = {}
    local order = {
        "template",
        "highlight",
        "clock",
        "clock_analog",
        "header_datetime",
        "battery_status",
        "reading_now",
        "calendar_tile",
        "today_reading",
    }
    for _, id in ipairs(order) do
        -- KOReader package.path has no ?/init.lua; load folder entry by explicit ".init" suffix.
        local pack = assert(require("banner.widgets." .. id .. ".init"), "widget pack missing: " .. id)
        assert(type(pack.attach) == "function", "widget pack must export attach(): " .. id)
        pack.attach(Registry)
    end
end

return Registry
