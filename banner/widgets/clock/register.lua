local Build = require("banner.widgets.clock.build")

local M = {}

function M.attach(Registry)
    Registry.register("clock", function(params, ctx)
        return Build.build(params, ctx)
    end, { needs_sleep_refresh = true })
end

return M
