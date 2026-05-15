local Build = require("banner.widgets.calendar_tile.build")

local M = {}

function M.attach(Registry)
    Registry.register("calendar_tile", function(params, ctx)
        return Build.build(params, ctx)
    end, { needs_sleep_refresh = true })
end

return M
